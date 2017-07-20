--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:01:33
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

GuildController = GuildController or class("GuildController", BaseController)

local GuildActivityBase = import(".ctl.GuildActivityBase")

local GuildProtos = {
	-- 创建解散退出
	CREATE_GUILD               = 17001, -- 创建帮派
	EXIT_GUILD                 = 17013, -- 退出帮派
	DISSOLUTION_GUILD          = 17014, -- 解除帮派

	-- 帮派列表
	GET_GUILD_LIST             = 17005, -- 获取帮派列表
	GET_GUILD_COUNT            = 17004, -- 获取所有帮派总数
	GET_JOIN_RULE              = 17002, -- 获取入帮条件
	SET_JOIN_RULE              = 17003, -- 设置入帮条件
	REQUEST_JOIN_GUILD         = 17006, -- 申请加入帮派
	GET_JOIN_REQUEST_COUNT     = 17007, -- 获取申请人数
	GET_JOIN_REQUEST_LIST      = 17008, -- 获取申请列表
	ACCETP_JOIN_REQUEST        = 17009, -- 同意玩家加入帮派

	-- 帮派信息
	GET_GUILD_INFO             = 17010, -- 获取帮派详细信息
	GET_MY_GUILD_INFO          = 17011, -- 获取玩家帮派信息
	GET_GUILD_PLAYER_INFO      = 17017, -- 获取帮派成员详细信息
	GET_GUILD_PLAYER_INFO_LIST = 17012, -- 获取帮派成员信息列表
	GET_GUILD_PLAYER_COUNT     = 17015, -- 获取帮派人数

	-- 管理员操作
	SET_GUILD_NOTICE           = 17016, -- 修改帮会公告
	DELETE_GUILD_PLAYER        = 17018, -- 剔除成员
	SET_WORK_POSITION          = 17019, -- 委任职位
	CLEAR_REQUEST_LIST         = 17020, -- 清空申请列表

	-- 其他操作
	CONTRIBUTE_GUILD           = 17050, -- 行会捐献
	BUY_GUILD_STORE            = 17051, -- 行会商店兑换
	GET_CONTRIBUTE_INFO        = 17052, -- 获取捐献信息
	GET_GUILD_LOG_LIST         = 17053, -- 行会日志信息

	-- 邀请相关
	INVITE_PLAYER_JOIN_GUILD   = 17054, -- 邀请加入行会
	RECEIVE_INVITE_INFO        = 17055, -- 推送的玩家行会邀请信息
	ACCEPT_INVITE              = 17056, -- 同意会长得邀请

	-- 行会活动相关
	ACT_GUILD_FB_INFO  = 17061, -- 获取行会秘境信息
	ACT_GUILD_FB_ENTER = 17057, -- 进入行会秘境
	ACT_SBK_FB_INFO    = 17062, -- 获取沙巴克秘境信息
	ACT_SBK_FB_OPEN    = 17058, -- 开启沙巴克秘境
	ACT_SBK_FB_ENTER   = 17059, -- 进入沙巴克秘境
	ACT_BOSS_CHALLENGE = 17060, -- 挑战公会BOSS

	-- 行会宣战
	GUILD_WAR_APPLY = 17080,--行会挑战发起
	GUILD_WAR_INVITE = 17081,--收到行会挑战邀请
	GUILD_WAR_ANSWER = 17082,--处理行会挑战邀请
	GUILD_WAR_PUSH = 17083,--行会挑战数据推送

}


--构造器
function GuildController:ctor()
	GuildController.super.ctor(self)
	self.fight_guild_id = 0
	self.guildWarInfo = nil
	self:initialization()
end

function GuildController:initialization()
	self:registerProto()

end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------

--
-- 打开活动。
--
function GuildController:openActivity(config)
	local activity = GuildActivityBase.create(config)
	activity:onRun()
end

--
-- 异步请求服务器获得公会秘境信息。
--
function GuildController:requestGuildFBInfo()
	self:sendDataToServer(GuildProtos.ACT_GUILD_FB_INFO)
end

--
-- 进入行会秘境。
--
function GuildController:enterGuildFB()
	self:sendDataToServer(GuildProtos.ACT_GUILD_FB_ENTER)
end

--
-- 异步请求服务器获得沙巴克秘境信息。
--
function GuildController:requestSBKFBInfo()
	self:sendDataToServer(GuildProtos.ACT_SBK_FB_INFO)
end

--
-- 打开沙巴克秘境。
--
function GuildController:openSBKFB()
	self:sendDataToServer(GuildProtos.ACT_SBK_FB_OPEN)
end

--
-- 进入沙巴克秘境。
--
function GuildController:enterSBKFB()
	self:sendDataToServer(GuildProtos.ACT_SBK_FB_ENTER)
end

--请求下一页红包
function GuildController:requestBriberyMoneyList(id)
	GameNet:sendMsgToSocket(17064, {last_red_id = id})
end

--请求下一页红包日记
function GuildController:requestBriberyMoneyRecordList(id)
	GameNet:sendMsgToSocket(17065, {last_id = id})
end

--发送红包，类型 1 手气红包,2 定额红包
function GuildController:sendBriberyMoney(jade, num, type, des)
    GameNet:sendMsgToSocket(17071, {jade = jade, num = num, type = type, des = des})
end

--领取红包
function GuildController:getBriberyMoney(id)
    GameNet:sendMsgToSocket(17070, { red_id = id })
end


--请求红包数据
function GuildController:requestBriberyMoneyData()
	GameNet:sendMsgToSocket(17063, {})
end

function GuildController:stopPushBriberyMoneyData()
	GameNet:sendMsgToSocket(17069, {})
end


--
-- 挑战公会BOSS。
--
function GuildController:challengeBoss(bossId)
	self:sendDataToServer(GuildProtos.ACT_BOSS_CHALLENGE, {id = bossId})
end

--销毁
function GuildController:destory()
	self:unRegisterProto()
	self:clear()
	self:stopReqCorpsRedPoint()
	GuildController.super.destory(self)
end

--清理
function GuildController:clear()
	self:clearTimer()
	GuildController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------

function GuildController:registerProto()
	-- 创建解散退出
	self:registerProtocal(GuildProtos.CREATE_GUILD              , handler(self, self.onHandle17001)) -- 创建帮派
	self:registerProtocal(GuildProtos.EXIT_GUILD                , handler(self, self.onHandle17013)) -- 退出帮派
	self:registerProtocal(GuildProtos.DISSOLUTION_GUILD         , handler(self, self.onHandle17014)) -- 解除帮派

	-- 帮派列表
	self:registerProtocal(GuildProtos.GET_GUILD_LIST            , handler(self, self.onHandle17005)) -- 获取帮派列表
	self:registerProtocal(GuildProtos.GET_GUILD_COUNT           , handler(self, self.onHandle17004)) -- 获取所有帮派总数
	self:registerProtocal(GuildProtos.GET_JOIN_RULE             , handler(self, self.onHandle17002)) -- 获取入帮条件
	self:registerProtocal(GuildProtos.SET_JOIN_RULE             , handler(self, self.onHandle17003)) -- 设置入帮条件
	self:registerProtocal(GuildProtos.REQUEST_JOIN_GUILD        , handler(self, self.onHandle17006)) -- 申请加入帮派
	self:registerProtocal(GuildProtos.GET_JOIN_REQUEST_COUNT    , handler(self, self.onHandle17007)) -- 获取申请人数
	self:registerProtocal(GuildProtos.GET_JOIN_REQUEST_LIST     , handler(self, self.onHandle17008)) -- 获取申请列表
	self:registerProtocal(GuildProtos.ACCETP_JOIN_REQUEST       , handler(self, self.onHandle17009)) -- 同意玩家加入帮派

	-- 帮派信息
	self:registerProtocal(GuildProtos.GET_GUILD_INFO            , handler(self, self.onHandle17010)) -- 获取帮派详细信息
	self:registerProtocal(GuildProtos.GET_MY_GUILD_INFO         , handler(self, self.onHandle17011)) -- 获取玩家帮派信息
	self:registerProtocal(GuildProtos.GET_GUILD_PLAYER_INFO     , handler(self, self.onHandle17017)) -- 获取帮派成员详细信息
	self:registerProtocal(GuildProtos.GET_GUILD_PLAYER_INFO_LIST, handler(self, self.onHandle17012)) -- 获取帮派成员信息列表
	self:registerProtocal(GuildProtos.GET_GUILD_PLAYER_COUNT    , handler(self, self.onHandle17015)) -- 获取帮派人数

	-- 管理员操作
	self:registerProtocal(GuildProtos.SET_GUILD_NOTICE          , handler(self, self.onHandle17016)) -- 修改帮会公告
	self:registerProtocal(GuildProtos.DELETE_GUILD_PLAYER       , handler(self, self.onHandle17018)) -- 剔除成员
	self:registerProtocal(GuildProtos.SET_WORK_POSITION         , handler(self, self.onHandle17019)) -- 委任职位
	self:registerProtocal(GuildProtos.CLEAR_REQUEST_LIST        , handler(self, self.onHandle17020)) -- 清空申请列表

	-- 其他操作
	self:registerProtocal(GuildProtos.CONTRIBUTE_GUILD          , handler(self, self.onHandle17050)) -- 行会捐献
	self:registerProtocal(GuildProtos.BUY_GUILD_STORE           , handler(self, self.onHandle17051)) -- 行会商店兑换
	self:registerProtocal(GuildProtos.GET_CONTRIBUTE_INFO       , handler(self, self.onHandle17052)) -- 获取捐献信息
	self:registerProtocal(GuildProtos.GET_GUILD_LOG_LIST        , handler(self, self.onHandle17053)) -- 行会日志信息

	-- 邀请相关
	self:registerProtocal(GuildProtos.INVITE_PLAYER_JOIN_GUILD  , handler(self, self.onHandle17054)) -- 邀请加入行会
	self:registerProtocal(GuildProtos.RECEIVE_INVITE_INFO       , handler(self, self.onHandle17055)) -- 推送的玩家行会邀请信息
	self:registerProtocal(GuildProtos.ACCEPT_INVITE             , handler(self, self.onHandle17056)) -- 同意会长得邀请

	-- 行会活动相关。
	self:registerProtocal(GuildProtos.ACT_GUILD_FB_INFO  , handler(self, self.onHandle17061)) -- 获取行会秘境信息
	self:registerProtocal(GuildProtos.ACT_GUILD_FB_ENTER , handler(self, self.onHandle17057)) -- 进入行会秘境
	self:registerProtocal(GuildProtos.ACT_SBK_FB_INFO    , handler(self, self.onHandle17062)) -- 获取沙巴克秘境信息
	self:registerProtocal(GuildProtos.ACT_SBK_FB_OPEN    , handler(self, self.onHandle17058)) -- 开启沙巴克秘境
	self:registerProtocal(GuildProtos.ACT_SBK_FB_ENTER   , handler(self, self.onHandle17059)) -- 进入沙巴克秘境
	self:registerProtocal(GuildProtos.ACT_BOSS_CHALLENGE , handler(self, self.onHandle17060)) -- 挑战公会BOSS

	self:registerProtocal(17063, handler(self, self.onHandle17063)) --行会红包的相关信息
	self:registerProtocal(17064, handler(self, self.onHandle17064)) 
	self:registerProtocal(17065, handler(self, self.onHandle17065))

	self:registerProtocal(17066, handler(self, self.onHandle17066))--行会的新红包
	self:registerProtocal(17067, handler(self, self.onHandle17067))--行会的新红包log

	self:registerProtocal(17068, handler(self, self.onHandle17068)) --新红包推送

    self:registerProtocal(17070, handler(self, self.onHandle17070))--领取行会红包
	self:registerProtocal(17071, handler(self, self.onHandle17071))

    
	self:registerProtocal(GuildProtos.GUILD_WAR_APPLY , handler(self, self.onHandle17080)) -- 挑战公会BOSS
	self:registerProtocal(GuildProtos.GUILD_WAR_INVITE , handler(self, self.onHandle17081)) -- 挑战公会BOSS
	self:registerProtocal(GuildProtos.GUILD_WAR_ANSWER , handler(self, self.onHandle17082)) -- 挑战公会BOSS
	self:registerProtocal(GuildProtos.GUILD_WAR_PUSH , handler(self, self.onHandle17083)) -- 挑战公会BOSS

	--======================================================== 军团部分 ==========================================
	self:registerProtocal(37001, handler(self, self.onHandle37001)) -- 创建军团
	self:registerProtocal(37002, handler(self, self.onHandle37002)) -- 获取入团条件
	self:registerProtocal(37003, handler(self, self.onHandle37003)) -- 设置入团条件
	self:registerProtocal(37004, handler(self, self.onHandle37004)) --获取所有军团总数
	self:registerProtocal(37005, handler(self, self.onHandle37005)) --获取军团列表
	self:registerProtocal(37006, handler(self, self.onHandle37006)) --申请加入军团
	self:registerProtocal(37007, handler(self, self.onHandle37007)) -- 获取申请人数
	self:registerProtocal(37008, handler(self, self.onHandle37008)) -- 获取申请列表
	self:registerProtocal(37009, handler(self, self.onHandle37009)) -- 同意玩家加入军团
	self:registerProtocal(37010, handler(self, self.onHandle37010)) -- 获取军团详细信息
	self:registerProtocal(37011, handler(self, self.onHandle37011)) -- 获取玩家军团信息
	self:registerProtocal(37012, handler(self, self.onHandle37012)) -- 获取军团成员信息列表
	self:registerProtocal(37013, handler(self, self.onHandle37013)) -- 退出军团
	self:registerProtocal(37015, handler(self, self.onHandle37015)) -- 获取军团人数
	self:registerProtocal(37016, handler(self, self.onHandle37016)) -- 修改军团公告
	self:registerProtocal(37018, handler(self, self.onHandle37018)) -- 剔除成员
	self:registerProtocal(37019, handler(self, self.onHandle37019)) -- 委任职位
	self:registerProtocal(37020, handler(self, self.onHandle37020)) -- 清空申请列表

	

end

function GuildController:unRegisterProto()
	for _, v in pairs(GuildProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function GuildController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function GuildController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

function GuildController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

function GuildController:showTipMessage(message)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(ERR_COMMON_SUCCESS, message))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对公会信息发生的变化
-- ------------------------------------------------------------------------------------------
function GuildController:onHandle17001(data)
	print("onHandle17001",data.result)
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("创建行会成功")
end

function GuildController:onHandle17002(data)
	print("onHandle17002")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:dispatchEventWith(GuildEvent.REQ_ENTER_GUILD_COND,data)
end

function GuildController:onHandle17003(data)
	print("onHandle17003")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("设置加入行会战力成功")
end

function GuildController:onHandle17004(data)
	print("onHandle17004")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_COUNT, data.guild_num)
end

function GuildController:onHandle17005(data)
	print("onHandle17005")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_LISTINFO, data.guild_info)
end

function GuildController:onHandle17006(data)
	print("onHandle17006")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("申请行会成功")
end

function GuildController:onHandle17007(data)
	print("onHandle17007")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_PROPOSER_COUNT,data.num)
end

function GuildController:onHandle17008(data)
	print("onHandle17008")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_PROPOSER_LISTINFO,data)
end

function GuildController:onHandle17009(data)
	print("onHandle17009")
	if data.result ~= 0 then
		self:handleResultCode(data.result)
		self:dispatchEventWith(GuildEvent.PROPOSER_HANDLE, data.player_id)
		return
	end

	if data.type == 1 then 			--同意
		self:dispatchEventWith(GuildEvent.PROPOSER_AGREE,data.player_id)
		self:showTipMessage("已同意玩家入会")
	elseif data.type == 2 then 		--拒绝
		self:dispatchEventWith(GuildEvent.PROPOSER_REFUSE,data.player_id)
	end
end

function GuildController:onHandle17010(data)
	print("onHandle17010")
	self.guild_detailed_info = data.guild_detailed_info
	self:dispatchEventWith(GuildEvent.GUILD_DETAILED_INFO,data.guild_detailed_info)
end

--获取行会详细信息
function GuildController:getGuildDetailedInfo()
	return self.guild_detailed_info
end

function GuildController:onHandle17011(data)
	print("onHandle17011")
	local roleManager = RoleManager:getInstance()
	if not roleManager.guildInfo.isInit then -- 没有初始化，进行初始化
		roleManager.guildInfo:updateFrom17011(data.player_guild_info)
		return
	end
	local guildInfo = RoleGuildInfoVO.new()	--主角行会相关信息
	local temp = roleManager.guildInfo.guild_id
	local oldGuildLv = roleManager.guildInfo.guild_lv
	local oldGuildCont = roleManager.guildInfo.contribution
	guildInfo:updateFrom17011(data.player_guild_info)
	roleManager.guildInfo = guildInfo
	if tonumber(temp) == 0 and tonumber(guildInfo.guild_id)>0 then --加入行会
		self:dispatchEventWith(GuildEvent.JOIN_GUILD)
	end
	if tonumber(temp) >0 and tonumber(guildInfo.guild_id)==0 then --退出行会
		self:dispatchEventWith(GuildEvent.EXIT_GUILD)
	end

	if oldGuildLv ~= guildInfo.guild_lv then
		self:dispatchEventWith(GuildEvent.GUILD_LV_CHANGE)
	end

	if oldGuildCont ~= guildInfo.contribution then
		self:dispatchEventWith(GuildEvent.GUILD_CONT_CHANGE)
	end
	
	self:dispatchEventWith(GuildEvent.ROLE_GUILD_INFO_CHANGE)

end

function GuildController:onHandle17012(data)
	print("onHandle17012")
 
	self:dispatchEventWith(GuildEvent.REQ_GUILD_MEMBER_LISTINFO,data)
	self:dispatchEventWith(TeamEvent.GET_GUILD_MEMBER_LIST,data.guild_member_info_list)

end

function GuildController:onHandle17013(data)
	print("onHandle17013")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("退出行会成功")
end

function GuildController:onHandle17014(data)
	print("onHandle17014")
end

function GuildController:onHandle17015(data)
	print("onHandle17015")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_MEMBER_COUNT,data.num)
end

function GuildController:onHandle17016(data)
	print("onHandle17016")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("行会公告修改成功")
	self:dispatchEventWith(GuildEvent.GUILD_NOTICE_CHANGE)
end

function GuildController:onHandle17017(data)
	print("onHandle17017")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:dispatchEventWith(GuildEvent.REQ_GET_MEMBER_INFO,data)
end

function GuildController:onHandle17018(data)
	print("onHandle17018")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("踢出行会成功")
	self:dispatchEventWith(GuildEvent.REQ_REJECT_MEMBER)
end

function GuildController:onHandle17019(data)
	print("onHandle17019")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:dispatchEventWith(GuildEvent.REQ_APPOINT_MEMBER,data)
end

function GuildController:onHandle17020(data)
	print("onHandle17020")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("清空申请列表成功")
end

function GuildController:onHandle17050(data)
	print("onHandle17050")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("捐献成功")
end

function GuildController:onHandle17051(data)
	print("onHandle17051")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end

function GuildController:onHandle17052(data)
	print("onHandle17052")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_DONATION_INFO,data.donation_info)
end

function GuildController:onHandle17053(data)
	print("onHandle17053")
	self:dispatchEventWith(GuildEvent.REQ_GUILD_LOG_INFO,data.guild_log_info)
end

function GuildController:onHandle17054(data)
	print("onHandle17054")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end

function GuildController:onHandle17055(data)
	print("onHandle17055")
	if GlobalController.fight:getScene().loading then
		self.eventForNewTrade = nil 
		local function onShow()
			SystemNotice:inviteGuildNotice({GuildName = data.guild_name,PlayerName = data.tname,GuildId = data.guild_id})

			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
			self.eventForNewTrade = nil 
		end
		self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:inviteGuildNotice({GuildName = data.guild_name,PlayerName = data.tname,GuildId = data.guild_id})
	end
end

function GuildController:onHandle17056(data)
	print("onHandle17056")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end


 -- 获取行会秘境信息
function GuildController:onHandle17061(data)
	print("onHandle17061")
	self:dispatchEventWith(GuildEvent.RCV_ACT_GUILD_FB_INFO, data)
end
 -- 进入行会秘境
function GuildController:onHandle17057(data)
	print("onHandle17057")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end
 -- 获取沙巴克秘境信息
function GuildController:onHandle17062(data)
	print("onHandle17062")
	self:dispatchEventWith(GuildEvent.RCV_ACT_SBK_FB_INFO, data)
end
 -- 开启沙巴克秘境
function GuildController:onHandle17058(data)
	print("onHandle17058")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end
 -- 进入沙巴克秘境
function GuildController:onHandle17059(data)
	print("onHandle17059")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end
 -- 挑战公会BOSS
function GuildController:onHandle17060(data)
	print("onHandle17060")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end

function GuildController:onHandle17063(data)
	print("onHandle17063")
	dump(data)
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_LOG, {list = data.red_log_list, type = 1})
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_INFO,{list = data.red_list, type = 1})
end

function GuildController:onHandle17064(data)
	print("onHandle17064")
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_INFO,{list = data.red_list, type = 2})
end

function GuildController:onHandle17065(data)
	print("onHandle17065")
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_LOG, {list = data.red_log_list, type = 2})
end

function GuildController:onHandle17066(data)
	print("onHandle17066")
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_INFO,{list = data.red_info, type = 3})
end

function GuildController:onHandle17067(data)
	print("onHandle17067")
    self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_LOG, {list = data.red_log, type = 3})
end


function GuildController:onHandle17068(data)
	print("onHandle17068")
    FunctionOpenManager:UpdateFunctionOpenByList({require("app.modules.functionOpen.FunctionIds").OPEN_GUILD_BM_WIN}, true)
end

function GuildController:onHandle17070(data)
	print("onHandle17070")
	self:dispatchEventWith(GuildEvent.GUILD_BRIBERY_MONEY_GET, data)
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	
end

function GuildController:onHandle17071(data)
	print("onHandle17071")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end

-------------------------------------------------------

function GuildController:requestGuildWar(guild_id)
	if guild_id == nil then
		return
	end
	GameNet:sendMsgToSocket(17080, {guild_id_b = guild_id})
end

function GuildController:requestGuildWarAnswer(guild_id,yes)
	if guild_id == nil or yes == nil then
		return
	end
	print(guild_id,yes)
	GameNet:sendMsgToSocket(17082, {guild_id_a = guild_id,type = yes})
end

function GuildController:onHandle17080(data)
	print("onHandle17080")
	if data.result ~= 0 then 
		self:handleResultCode(data.result) 
	else
		if data.guild_name_b ~= "" then
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"对方已接受挑战!")
		else
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"宣战信息发送成功!")
		end
	end


end

function GuildController:onHandle17081(data)
	print("onHandle17081")
	if GlobalController.fight:getScene().loading then
		self.eventForNewTrade = nil 
		local function onShow()
			SystemNotice:newGuildWarNotice(data)
			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
			self.eventForNewTrade = nil 
		end
		self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:newGuildWarNotice(data)
	end
end

function GuildController:onHandle17082(data)
	print("onHandle17082")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
end

function GuildController:onHandle17083(data)
	print("onHandle17083")
	if RoleManager:getInstance().guildInfo.guild_id == data.guild_id_b then
		self.fight_guild_id = data.guild_id_a
	else
		self.fight_guild_id = data.guild_id_b
	end
	self.guildWarInfo = data
	self:startTimer()
	GlobalEventSystem:dispatchEvent(GuildEvent.GUILD_WAR_INFO,data)
end

function GuildController:onTimerHandler()
	
	if GlobalController.guild.guildWarInfo then
		GlobalController.guild.guildWarInfo.time_left=GlobalController.guild.guildWarInfo.time_left - 1
		if GlobalController.guild.guildWarInfo.time_left <= 0 then
			GlobalController.guild.guildWarInfo.time_left = 0
			self:clearTimer()
		end
	end
	
end

function GuildController:startTimer()
	self:clearTimer()
 
	if GlobalController.guild.guildWarInfo and GlobalController.guild.guildWarInfo.time_left > 0 then
		self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
		self:onTimerHandler()
 
	end
end	

function GuildController:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

--=========================军团部分====================================================================================
function GuildController:onHandle37001(data)
	print("onHandle37001")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("创建军团成功")
end


function GuildController:onHandle37002(data)
	print("onHandle37002")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:dispatchEventWith(CorpsEvent.REQ_ENTER_CORPS_COND,data)
end

function GuildController:onHandle37003(data)
	print("onHandle37003")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("设置加入团战力成功")
end

function GuildController:onHandle37004(data)
	print("onHandle37004")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_COUNT, data.legion_num)
end

function GuildController:onHandle37005(data)
	print("onHandle37005")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_LISTINFO, data.legion_info)
end

function GuildController:onHandle37006(data)
	print("onHandle37006")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("申请军团成功")
end

function GuildController:onHandle37007(data)
	print("onHandle37007")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_PROPOSER_COUNT,data.num)
end

function GuildController:onHandle37008(data)
	print("onHandle37008")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_PROPOSER_LISTINFO,data)
end


function GuildController:onHandle37009(data)
	print("onHandle37009")
	if data.result ~= 0 then
		self:handleResultCode(data.result)
		self:dispatchEventWith(CorpsEvent.PROPOSER_HANDLE, data.player_id)
		return
	end

	if data.type == 1 then 			--同意
		self:dispatchEventWith(CorpsEvent.PROPOSER_AGREE,data.player_id)
		self:showTipMessage("已同意玩家入团")
	elseif data.type == 2 then 		--拒绝
		self:dispatchEventWith(CorpsEvent.PROPOSER_REFUSE,data.player_id)
	end
end

function GuildController:onHandle37010(data)
	print("onHandle37010")
	self.legion_detailed_info = data.legion_detailed_info
	self:dispatchEventWith(CorpsEvent.CORPS_DETAILED_INFO, data.legion_detailed_info)
end

--获取军团详细信息
function GuildController:getCorpsDetailedInfo()
	return self.legion_detailed_info
end

function GuildController:onHandle37011(data)
	print("onHandle37011")
	if tonumber(data.player_legion_info.legion_id, 10) > 0 then
		self:startReqCorpsRedPoint()
	else
		self:stopReqCorpsRedPoint()
	end
	local roleManager = RoleManager:getInstance()
	if not roleManager.corpsInfo.isInit then -- 没有初始化，进行初始化
		roleManager.corpsInfo:updateFrom37011(data.player_legion_info)
		return
	end
	local corpsInfo = RoleCorpsInfoVO.new()	--主角军团相关信息
	local temp = roleManager.corpsInfo.legion_id
	local oldCorpsLv = roleManager.corpsInfo.legion_lv
	local oldCorpsCont = roleManager.corpsInfo.contribution
	corpsInfo:updateFrom37011(data.player_legion_info)
	roleManager.corpsInfo = corpsInfo
	if tonumber(temp) == 0 and tonumber(corpsInfo.legion_id)>0 then --加入军团
		self:dispatchEventWith(CorpsEvent.JOIN_CORPS)
	end
	if tonumber(temp) >0 and tonumber(corpsInfo.legion_id)==0 then --退出军团
		self:dispatchEventWith(CorpsEvent.EXIT_CORPS)
	end

	if oldCorpsLv ~= corpsInfo.legion_lv then
		self:dispatchEventWith(CorpsEvent.CORPS_LV_CHANGE)
	end

	if oldCorpsCont ~= corpsInfo.contribution then
		self:dispatchEventWith(CorpsEvent.CORPS_CONT_CHANGE)
	end
	
	self:dispatchEventWith(CorpsEvent.ROLE_CORPS_INFO_CHANGE)

end

--请求军团红点
function GuildController:startReqCorpsRedPoint()
	if not self.corpsRedPointHandle then
		self.corpsRedPointHandle = GlobalTimer.scheduleGlobal(function() GameNet:sendMsgToSocket(9002, {}) end, 2) 
	end
end

function GuildController:stopReqCorpsRedPoint()
	if self.corpsRedPointHandle then
		GlobalTimer.unscheduleGlobal(self.corpsRedPointHandle) 
	end
end


function GuildController:onHandle37012(data)
	print("onHandle37012")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_MEMBER_LISTINFO,data)
	self:dispatchEventWith(TeamEvent.GET_CORPS_MEMBER_LIST, data.legion_member_info_list)

end

function GuildController:onHandle37013(data)
	print("onHandle37013")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("退出军团成功")
end

function GuildController:onHandle37015(data)
	print("onHandle37015")
	self:dispatchEventWith(CorpsEvent.REQ_CORPS_MEMBER_COUNT,data.num)
end

function GuildController:onHandle37016(data)
	print("onHandle37016")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("军团公告修改成功")
	self:dispatchEventWith(CorpsEvent.CORPS_NOTICE_CHANGE)
end

function GuildController:onHandle37018(data)
	print("onHandle37018")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("踢出军团成功")
	self:dispatchEventWith(CorpsEvent.REQ_REJECT_MEMBER)
end

function GuildController:onHandle37019(data)
	print("onHandle37019")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:dispatchEventWith(CorpsEvent.REQ_APPOINT_MEMBER,data)
end

function GuildController:onHandle37020(data)
	print("onHandle17020")
	if data.result ~= 0 then self:handleResultCode(data.result) return end
	self:showTipMessage("清空申请列表成功")
end






























return GuildController