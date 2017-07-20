--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-07 14:12:55
--

--[[
	组队功能控制器。
	与服务器收发数据并更新组队状态。
	操作数据并抛出相应的事件。
]]
TeamController = TeamController or class("TeamController", BaseController)

local TeamData = import(".model.TeamData")

local TeamProtos = {
	CREATE_TEAM          = 21000, -- 创建队伍
	SELF_TEAM_INFO       = 21001, -- 获取当前所在队伍信息
	OPTION_SET           = 21002, -- 开关组队选项
	TEAM_NOTIFICATION    = 21003, -- 队伍通知
	INVITE_PLAYER        = 21004, -- 邀请玩家加入我的队伍
	RECEIVE_INVITE       = 21005, -- 接收邀请通知
	JOIN_TEAM_HANDLE     = 21006, -- 处理邀请通知
	REQUEST_JOIN_TEAM    = 21007, -- 申请加入一个队伍
	RECEIVE_REQUEST      = 21008, -- 接收申请请求
	LEAD_HANDLE_REQUEST  = 21009, -- 处理申请请求
	GET_NEAR_PLAYER_INFO = 21010, -- 获取附近玩家信息
	GET_NEAR_TEAM_INFO   = 21011, -- 获取附近团队信息
	TRANSFER_TEAM_LEAD   = 21012, -- 转移队长给另外一个玩家
	DISMISS_TEAM_PLAYER  = 21013, -- 把一个队员请出队伍
	DISSOLUTION_TEAM     = 21014, -- 解散我的队伍
	LEAVE_TEAM           = 21015, -- 离开当前的队伍
	UPDATE_TEAM           = 21016, -- 更新当前的队伍
	TRANSFER_TEAM           = 21017, -- 传送队长
}

TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE  = 1
TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST = 2

function TeamController:ctor()
	self:initialization()
end

function TeamController:initialization()
	self._teamData = TeamData.new()
	self.inviteList = {}
	self.joinList = {}
	self:registerProto()
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------

--
-- 设置当前的组队系统选项
-- @param option:
-- 		TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE
-- 		TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST
-- @return isEnabled 是否开启此选项
--
function TeamController:GetOptionEnabled(option)
	assert(option ~= nil, "[TeamController:SetOptionEnabled] - option can't be nil!")
	assert(option == TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE
		or option == TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST,
		"[TeamController:SetOptionEnabled] - option is a illegal value.")
	return self._teamData:GetOptionEnabled(option)
end

--
-- 返回当前我是否已经加入了一个团队。
--
function TeamController:HasTeam()
	return self._teamData:GetTeamPlayerList():Count() ~= 0
end

--
-- 返回指定玩家是否为队长。
--
function TeamController:IsTeamLead(playerId)
	local isLead = false
	local teamMenber = self._teamData:GetTeamPlayerList():GetElements()
	for _, v in ipairs(teamMenber) do
		-- type 1 队长， 2 队员
		if v.player_id == playerId and v.type == 1 then
			isLead = true
			break
		end
	end
	return isLead
end

--
-- 返回当前所在团队内的所有成员。
--
function TeamController:GetTeamPlayerList()
	return self._teamData:GetTeamPlayerList():GetElements()
end

--
-- 返回附近的团队列表。
--
function TeamController:GetNearTeamList()
	return self._teamData:GetNearTeamList():GetElements()
end

--
-- 返回附近的玩家列表。
--
function TeamController:GetNearPlayerList()
	return self._teamData:GetNearPlayerList():GetElements()
end

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------

--
-- 创建一个队伍
--
function TeamController:CreateTeam()
	self:sendDataToServer(TeamProtos.CREATE_TEAM)
end

--
-- 刷新当前我所在队伍的信息
--
function TeamController:RefreshMyTeamInfo()
	self:sendDataToServer(TeamProtos.SELF_TEAM_INFO)
end

--
-- 设置当前的组队系统选项
-- @param option:
-- 		TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE
-- 		TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST
-- @param isEnabled 是否开启此选项
--
function TeamController:SetOptionEnabled(option, isEnabled)
	assert(option ~= nil, "[TeamController:SetOptionEnabled] - option can't be nil!")
	assert(isEnabled ~= nil, "[TeamController:SetOptionEnabled] - option can't be nil!")
	assert(option == TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE
		or option == TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST,
		"[TeamController:SetOptionEnabled] - option is a illegal value.")
	assert(type(isEnabled) == "boolean", "[TeamController:SetOptionEnabled] - isEnabled is a illegal value.")

	--[[
		<Packet proto="21002" type="c2s" name="req_team_switch" describe="开启关闭队伍开关">
			<Param name="switch_type" type="int8" describe="开关类型1 2"/>
			<Param name="status" type="int8" describe="0不勾选 1勾选"/>
		</Packet>
	]]
	local __isEnabled = isEnabled and 1 or 0
	self:sendDataToServer(TeamProtos.OPTION_SET, {switch_type = option, status = __isEnabled})
end

--
-- 队长操作
-- 邀请一个玩家加入我的队伍
-- @param playerId 玩家id
--
function TeamController:InvitePlayer(playerId)
	assert(playerId ~= nil, "[TeamController:InvitePlayer] - playerId can't be nil!")
	--[[
		<Packet proto="21004" type="c2s" name="req_invite_join_team" describe="邀请玩家入队">
			<Param name="player_id" type="int64" describe="玩家id"/>
		</Packet>
	]]
	if playerId == RoleManager:getInstance().roleInfo.player_id then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"不能邀请自己")
	else
		self:sendDataToServer(TeamProtos.INVITE_PLAYER, {player_id = playerId})
	end
	
end

--
-- 处理一个队伍的队长发给我的邀请信息
-- @param teamId 队伍id
-- @param isAccept 是否同意加入此队伍
--
function TeamController:HandleInvite(teamId, player_id, isAccept)
	assert(teamId ~= nil, "[TeamController:HandleInvite] - teamId can't be nil!")
	assert(isAccept ~= nil, "[TeamController:HandleInvite] - isAccept can't be nil!")
	assert(type(isAccept) == "boolean", "[TeamController:HandleInvite] - isAccept is a illegal value.")
	--[[
		<Packet proto="21006" type="c2s" name="req_agree_join_team" describe="是否同意加入">
			<Param name="team_id" type="int64" describe="队伍id"/>
			<Param name="type" type="int8" describe="0拒绝 1同意"/>
		</Packet>
	]]
	for i=#self.inviteList,1,-1 do
		if self.inviteList[i] == teamId then
			table.remove(self.inviteList,i)
		end
	end
	local __isAccept = isAccept and 1 or 0
	self:sendDataToServer(TeamProtos.JOIN_TEAM_HANDLE, {team_id = teamId, player_id = player_id,type = __isAccept})
end

--
-- 给一个队伍的队长发出请求加入他们的队伍。
-- @param teamId 队伍id
--
function TeamController:RequestJoinTeam(teamId)
	assert(teamId ~= nil, "[TeamController:RequestJoinTeam] - teamId can't be nil!")
	--[[
		<Packet proto="21007" type="c2s" name="req_apply_join_team" describe="玩家申请加入队伍">
			<Param name="team_id" type="int64" describe="队伍id"/>
		</Packet>
	]]
	self:sendDataToServer(TeamProtos.REQUEST_JOIN_TEAM, {team_id = teamId})
end

--
-- 队长操作
-- 处理一个玩家发给我的入队请求。
-- @param playerId 玩家id
-- @param isAccept 是否同意其加入我的队伍
--
function TeamController:HandleRequest(playerId, isAccept)
	assert(playerId ~= nil, "[TeamController:HandleRequest] - playerId can't be nil!")
	assert(isAccept ~= nil, "[TeamController:HandleRequest] - isAccept can't be nil!")
	assert(type(isAccept) == "boolean", "[TeamController:HandleRequest] - isAccept is a illegal value.")
	--[[
		<Packet proto="21009" type="c2s" name="req_agree_apply_team" describe="队长同意申请">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="type" type="int8" describe="0拒绝 1同意"/>
		</Packet>
	]]
	for i=#self.joinList,1,-1 do
		if self.joinList[i] == playerId then
			table.remove(self.joinList,i)
		end
	end
	local __isAccept = isAccept and 1 or 0
	self:sendDataToServer(TeamProtos.LEAD_HANDLE_REQUEST, {player_id = playerId, type = __isAccept})
end

--
-- 刷新当前附近的玩家列表信息。
--
function TeamController:RefreshNearPlayerList()
	self:sendDataToServer(TeamProtos.GET_NEAR_PLAYER_INFO)
end

--
-- 刷新当前附近的队伍信息。
--
function TeamController:RefreshNearTeamList()
 	self:sendDataToServer(TeamProtos.GET_NEAR_TEAM_INFO)
end

--
-- 队长操作
-- 转移我的队长给队伍内的一个玩家。
-- @param playerId 接任队长的玩家id
--
function TeamController:TransferLeadToPlayer(playerId)
	assert(playerId ~= nil, "[TeamController:TransferLeadToPlayer] - playerId can't be nil!")
	--[[
		<Packet proto="21012" type="c2s" name="req_change_team" describe="转移队长">
			<Param name="player_id" type="int64" describe="玩家id"/>
		</Packet>
	]]
	self:sendDataToServer(TeamProtos.TRANSFER_TEAM_LEAD, {player_id = playerId})
end

--
-- 队长操作
-- 将一个队员移出队伍。
-- @param playerId 玩家id
--
function TeamController:DismissPlayer(playerId)
	assert(playerId ~= nil, "[TeamController:DismissPlayer] - playerId can't be nil!")
	--[[
		<Packet proto="21013" type="c2s" name="req_remove_team" describe="剔出队伍">
			<Param name="player_id" type="int64" describe="玩家id"/>
		</Packet>
	]]
	self:sendDataToServer(TeamProtos.DISMISS_TEAM_PLAYER, {player_id = playerId})
end

--
-- 队长操作
-- 解散当前的队伍。
--
function TeamController:DissolutionTeam()
	self:sendDataToServer(TeamProtos.DISSOLUTION_TEAM)
end

--
-- 离开当前的队伍。
--
function TeamController:LeaveTeam()
	self:sendDataToServer(TeamProtos.LEAVE_TEAM)
end

--销毁
function TeamController:destory()
	self:unRegisterProto()
	self:clear()
	TeamController.super.destory(self)
end

--清理
function TeamController:clear()
	self.inviteList = {}
	self.joinList = {}
	if self._teamData then
		self._teamData:Destory()
		self._teamData = nil
	end
	self._teamData = TeamData.new()
	TeamController.super.clear(self)
end


-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------

function TeamController:registerProto()
	self:registerProtocal(TeamProtos.CREATE_TEAM,          handler(self, self.onHandle_CREATE_TEAM))
	self:registerProtocal(TeamProtos.SELF_TEAM_INFO,       handler(self, self.onHandle_SELF_TEAM_INFO))
	self:registerProtocal(TeamProtos.OPTION_SET,           handler(self, self.onHandle_OPTION_SET))
	self:registerProtocal(TeamProtos.TEAM_NOTIFICATION,    handler(self, self.onHandle_TEAM_NOTIFICATION))
	self:registerProtocal(TeamProtos.INVITE_PLAYER,        handler(self, self.onHandle_INVITE_PLAYER))
	self:registerProtocal(TeamProtos.RECEIVE_INVITE,       handler(self, self.onHandle_RECEIVE_INVITE))
	self:registerProtocal(TeamProtos.JOIN_TEAM_HANDLE,     handler(self, self.onHandle_JOIN_TEAM_HANDLE))
	self:registerProtocal(TeamProtos.REQUEST_JOIN_TEAM,    handler(self, self.onHandle_REQUEST_JOIN_TEAM))
	self:registerProtocal(TeamProtos.RECEIVE_REQUEST,      handler(self, self.onHandle_RECEIVE_REQUEST))
	self:registerProtocal(TeamProtos.LEAD_HANDLE_REQUEST,  handler(self, self.onHandle_LEAD_HANDLE_REQUEST))
	self:registerProtocal(TeamProtos.GET_NEAR_PLAYER_INFO, handler(self, self.onHandle_GET_NEAR_PLAYER_INFO))
	self:registerProtocal(TeamProtos.GET_NEAR_TEAM_INFO,   handler(self, self.onHandle_GET_NEAR_TEAM_INFO))
	self:registerProtocal(TeamProtos.TRANSFER_TEAM_LEAD,   handler(self, self.onHandle_TRANSFER_TEAM_LEAD))
	self:registerProtocal(TeamProtos.DISMISS_TEAM_PLAYER,  handler(self, self.onHandle_DISMISS_TEAM_PLAYER))
	self:registerProtocal(TeamProtos.DISSOLUTION_TEAM,     handler(self, self.onHandle_DISSOLUTION_TEAM))
	self:registerProtocal(TeamProtos.LEAVE_TEAM,           handler(self, self.onHandle_LEAVE_TEAM))
	self:registerProtocal(TeamProtos.UPDATE_TEAM,           handler(self, self.onHandle_UPDATE_TEAM))
	self:registerProtocal(TeamProtos.TRANSFER_TEAM,         handler(self, self.onHandle_TRANSFER_TEAM))
	
end

function TeamController:unRegisterProto()
	for _, v in pairs(TeamProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function TeamController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function TeamController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

function TeamController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对组队信息发生的变化
-- ------------------------------------------------------------------------------------------
function TeamController:onHandle_CREATE_TEAM(data)
	--[[
		<Packet proto="21000" type="s2c" name="rep_create_team" describe="创建队伍">
				<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	-- dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	else
		-- 创建队伍成功，刷新当前的队伍信息
		-- 创建队伍成功，刷新附近团队列表
		self:RefreshMyTeamInfo()
		self:RefreshNearTeamList()
	end
end

function TeamController:onHandle_SELF_TEAM_INFO(data)
	--[[
		<Packet proto="21001" type="s2c" name="rep_team_info" describe="获取自身队伍信息">
			<Param name="switch1" type="int8" describe="组队开关1 0不勾选 1勾选"/>
			<Param name="switch2" type="int8" describe="组队开关2 0不勾选 1勾选"/>
			<Param name="member_list" type="list" sub_type="proto_team_member_info" describe="队伍信息列表"/>
		</Packet>
	]]
	--dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")
	local teamData = self._teamData
	teamData:SetOptionEnabled(TeamController.TEAM_OPTION_AUTO_ACCEPT_INVITE, data.switch1 == 1)
	teamData:SetOptionEnabled(TeamController.TEAM_OPTION_AUTO_ACCEPT_REQUEST, data.switch2 == 1)
	teamData:GetTeamPlayerList():Set(data.member_list)

	self:dispatchEventWith(TeamEvent.NAV_UPDATE,data)

	if data.member_list and #data.member_list > 0 then
		self:dispatchEventWith(TeamEvent.SHOW_MYTEAM)
	else
		self:dispatchEventWith(TeamEvent.SHOW_NEARTEAM)
	end
	
	-- -- test data ------ start
	-- teamData:GetTeamPlayerList():Set(
	-- {
	-- 	{name = "Alex Liao", lv = 88, career = 10086, guild_name = "挖队", type=1},
	-- 	{name = "Alex Nio", lv = 88222222, career = 10086, guild_name = "挖队", type=2},
	-- 	{name = "Alex Mahoxxxxx", lv = 88, career = 10086, guild_name = "挖掘机先锋队", type=2},
	-- 	{name = "Alex", lv = 88, career = 1008999, guild_name = "挖掘机队", type=2},
	-- 	{name = "Alex Jime", lv = 8228, career = 10086, guild_name = "挖掘机先锋队", type=2},
	-- })
	-- -- test data ------ end

	self:dispatchEventWith(TeamEvent.TEAM_INFO_CHANGED)
	self:dispatchEventWith(TeamEvent.TEAM_OPTION_CHANGED)
end

function TeamController:onHandle_OPTION_SET(data)
	--[[
		<Packet proto="21002" type="s2c" name="rep_team_switch" describe="开启关闭队伍开关">
			<Param name="switch_type" type="int8" describe="开关类型1 2"/>
			<Param name="status" type="int8" describe="0不勾选 1勾选"/>
		</Packet>
	]]
	-- dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")
	self._teamData:SetOptionEnabled(data.switch_type, data.status == 1)
	self:dispatchEventWith(TeamEvent.TEAM_OPTION_CHANGED)
end

function TeamController:onHandle_TEAM_NOTIFICATION(data)
	--[[
		<Packet proto="21003" type="s2c" name="rep_team_notice" describe="队伍相关通知">
			<Param name="value" type="string" describe="参数"/>
			<Param name="type" type="int8" describe="通知类型1玩家加入队伍 2玩家离队 3队伍解散 4队长变更"/>
		</Packet>
	]]
	-- dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")

	if 1 == data.type then
		self:dispatchEventWith(TeamEvent.JOIN_TEAM)
		if data.value == RoleManager:getInstance().roleInfo.name then
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"加入队伍成功")
		else
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,data.value.."进入队伍")
		end
	elseif 2 == data.type then
		self:dispatchEventWith(TeamEvent.LEAVE_TEAM)
	elseif 3 == data.type then
		self:dispatchEventWith(TeamEvent.DISSOLUTION_TEAM)
		-- 解散之后需要刷新附近团队列表。
		self:RefreshNearTeamList()
	elseif 4 == data.type then
		self:dispatchEventWith(TeamEvent.TEAM_LEAD_CHANGED)
	end

	-- 以上操作都需要重新刷新我的队伍
	self:RefreshMyTeamInfo()
end

function TeamController:onHandle_INVITE_PLAYER(data)
	--[[
		<Packet proto="21004" type="s2c" name="rep_invite_join_team" describe="邀请玩家入队">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_RECEIVE_INVITE(data)
	--[[
		<Packet proto="21005" type="s2c" name="rep_broadcast_invite" describe="广播邀请">
			<Param name="team_id" type="int64" describe="队伍id"/>
			<Param name="player_name" type="string" describe="邀请人姓名"/>
		</Packet>
	]]
	
	data.type = 2

	if not self:checkTeamData(self.inviteList,data.team_id) then
		table.insert(self.inviteList, data.team_id)
	else
		return
	end
	self:dispatchEventWith(TeamEvent.RECEIVE_INVITE, data)
	if GlobalController.fight:getScene().loading then
		self.eventForNewTrade = nil 
		local function onShow()
			SystemNotice:newTeamNotice(data)
			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
			self.eventForNewTrade = nil 
		end
		self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:newTeamNotice(data)
	end
	--[[
	local accept = function()
		self:HandleInvite(data.team_id, data.player_id, true)
	end

	local cancel = function()
		self:HandleInvite(data.team_id, data.player_id, false)
	end

	local param = {
		enterTxt = "同意",
		backTxt  = "取消",
		tipTxt   = string.format("玩家【%s】邀请您加入队伍，是否同意？", data.player_name),
		enterFun = accept,
		backFun  = cancel
	}
	GlobalMessage:alert(param)
	--]]
end

function TeamController:onHandle_JOIN_TEAM_HANDLE(data)
	--[[
		<Packet proto="21006" type="s2c" name="rep_agree_join_team" describe="是否同意加入">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_REQUEST_JOIN_TEAM(data)
	--[[
		<Packet proto="21007" type="s2c" name="rep_apply_join_team" describe="玩家申请加入队伍">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_RECEIVE_REQUEST(data)
	--[[
		<Packet proto="21008" type="s2c" name="rep_broadcast_apply" describe="广播申请给队长">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="player_name" type="string" describe="玩家姓名"/>
		</Packet>
	]]
	
	data.type = 1

	if not self:checkTeamData(self.joinList,data.player_id) then
		table.insert(self.joinList, data.player_id)
	else
		return
	end

	self:dispatchEventWith(TeamEvent.RECEIVE_REQUEST, data)

	if GlobalController.fight:getScene().loading then
		self.eventForNewTrade = nil 
		local function onShow()
			SystemNotice:newTeamNotice(data)
			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
			self.eventForNewTrade = nil 
		end
		self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:newTeamNotice(data)
	end
	--[[
	local accept = function()
		self:HandleRequest(data.player_id, true)
	end

	local cancel = function()
		self:HandleRequest(data.player_id, false)
	end

	local param = {
		enterTxt = "同意",
		backTxt  = "取消",
		tipTxt   = string.format("玩家【%s】申请加入您的队伍，是否同意？", data.player_name),
		enterFun = accept,
		backFun  = cancel
	}
	GlobalMessage:alert(param)
	--]]
end

function TeamController:onHandle_LEAD_HANDLE_REQUEST(data)
	--[[
		<Packet proto="21009" type="s2c" name="rep_agree_apply_team" describe="队长同意申请">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_GET_NEAR_PLAYER_INFO(data)
	--[[
		<Packet proto="21010" type="s2c" name="rep_near_by_player" describe="获取附近玩家信息">
			<Param name="info_list" type="list" sub_type="proto_near_by_player" describe="队伍玩家信息"/>
		</Packet>
	]]
	-- dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")
	self._teamData:GetNearPlayerList():Set(data.info_list)

	-- -- test data ------ start
	-- self._teamData:GetNearPlayerList():Set(
	-- {
	-- 	{name = "Alex Liao", lv = 88, career = 10086, guild_name = "挖队", type=1},
	-- 	{name = "Alex Nio", lv = 88222222, career = 10086, guild_name = "挖队", type=2},
	-- 	{name = "Alex Mahoxxxxx", lv = 88, career = 10086, guild_name = "挖掘机先锋队", type=2},
	-- 	{name = "Alex", lv = 88, career = 1008999, guild_name = "挖掘机队", type=2},
	-- 	{name = "Alex Jime", lv = 8228, career = 10086, guild_name = "挖掘机先锋队", type=2},
	-- })
	-- -- test data ------ end
	self:dispatchEventWith(TeamEvent.GET_NEAR_PLAYER_INFO)
	self:dispatchEventWith(TeamEvent.GET_NEAR_PALER_LIST,data.info_list)
end

function TeamController:onHandle_GET_NEAR_TEAM_INFO(data)
	--[[
		<Packet proto="21011" type="s2c" name="rep_near_by_team" describe="获取附近队伍信息">
			<Param name="info_list" type="list" sub_type="proto_near_by_team" describe="队伍信息列表"/>
		</Packet>
	]]
	-- dump(data, "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=")
	self._teamData:GetNearTeamList():Set(data.info_list)
	
	-- -- test data ------ start
	-- self._teamData:GetNearTeamList():Set(
	-- {
	-- 	{name = "Alex Liao", lv = 88, career = 10086, guild_name = "挖队", memeber_num=1},
	-- 	{name = "Alex Nio", lv = 88222222, career = 10086, guild_name = "挖队", memeber_num=2},
	-- 	{name = "Alex Mahoxxxxx", lv = 88, career = 10086, guild_name = "挖掘机先锋队", memeber_num=3},
	-- 	{name = "Alex", lv = 88, career = 1008999, guild_name = "挖掘机队", memeber_num=4},
	-- 	{name = "Alex Jime", lv = 8228, career = 10086, guild_name = "挖掘机先锋队", memeber_num=5},
	-- 	{name = "BBBB Liao", lv = 88, career = 10086, guild_name = "挖队", memeber_num=1},
	-- 	{name = "BBBB Nio", lv = 88222222, career = 10086, guild_name = "挖队", memeber_num=2},
	-- 	{name = "BBBB Mahoxxxxx", lv = 88, career = 10086, guild_name = "挖掘机先锋队", memeber_num=3},
	-- 	{name = "BBBB", lv = 88, career = 1008999, guild_name = "挖掘机队", memeber_num=4},
	-- 	{name = "BBBB Jime", lv = 8228, career = 10086, guild_name = "挖掘机先锋队", memeber_num=5},
	-- })
	-- -- test data ------ end
	self:dispatchEventWith(TeamEvent.GET_NEAR_TEAM_INFO)
end

function TeamController:onHandle_TRANSFER_TEAM_LEAD(data)
	--[[
		<Packet proto="21012" type="s2c" name="rep_change_team" describe="转移队长">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_DISMISS_TEAM_PLAYER(data)
	--[[
		<Packet proto="21013" type="s2c" name="rep_remove_team" describe="剔出队伍">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_DISSOLUTION_TEAM(data)
	--[[
		<Packet proto="21014" type="s2c" name="rep_clear_team" describe="解散队伍">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:onHandle_LEAVE_TEAM(data)
	--[[
		<Packet proto="21015" type="s2c" name="rep_leave_team" describe="离开队伍">
			<Param name="result" type="int16" describe="错误码"/>
		</Packet>
	]]
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	else
		-- 退出退伍之后刷新
		self:RefreshMyTeamInfo()
	end
end

function TeamController:onHandle_UPDATE_TEAM(data)
	self:dispatchEventWith(TeamEvent.NAV_UPDATE,data)
	local teamData = self._teamData
	teamData:GetTeamPlayerList():Set(data.member_list)
 
	self:dispatchEventWith(TeamEvent.TEAM_INFO_CHANGED)
	self:dispatchEventWith(TeamEvent.TEAM_OPTION_CHANGED)

end

function TeamController:onHandle_TRANSFER_TEAM(data)
	print("TeamController:onHandle_TRANSFER_TEAM")
	if data.result ~= 0 then
		self:handleResultCode(data.result)
	end
end

function TeamController:checkTeamData(list,data)
	for i=1,#list do
		if list[i] == data then
			return true
		end
	end

	return false
end