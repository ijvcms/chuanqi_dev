--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 18:00:41
--

--[[
	组队窗口子视图
	*子视图：我的队伍
]]
local TabView = import("app.gameui.tab.TabView")
local SubView_MyTeam = class("SubView_MyTeam", TabView)
local PlayerListItem = class("PlayerListItem", function()
	return display.newNode()
end)

--
-- 构造器
--
function SubView_MyTeam:ctor(view, flag)
	SubView_MyTeam.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_MyTeam:initialization()
	SubView_MyTeam.super.initialization(self)

	self._currentSelected = nil
	self._menberList = nil

	self:initComponents()
	self:initListeners()
	--GlobalController.team:RefreshMyTeamInfo()
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_MyTeam:Show()
	SubView_MyTeam.super.Show(self)
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_MyTeam:Hide()
	SubView_MyTeam.super.Hide(self)
end

function SubView_MyTeam:initComponents()
	local root = self:GetView()

	
	self.chkAutoAcceptRequest = cc.uiloader:seekNodeByName(root, "chk_auto_accept_request")
 
	self.chkAutoAcceptRequest:onButtonStateChanged(function(event)
		GlobalController.team:SetOptionEnabled(GlobalController.team.TEAM_OPTION_AUTO_ACCEPT_REQUEST,
			self.chkAutoAcceptRequest:isButtonSelected())
	end)

	local buttonContainer = cc.uiloader:seekNodeByName(root, "container_buttons")
	--self.btnCheckInfo = cc.uiloader:seekNodeByName(buttonContainer, "btn_check_info")
	--self.btnAddFriend = cc.uiloader:seekNodeByName(buttonContainer, "btn_add_friend")
	self.btnLeaveTeam = cc.uiloader:seekNodeByName(buttonContainer, "btn_leave_team")
	self.teamAdditionNum = cc.uiloader:seekNodeByName(root, "teamAdditionNum")

	--self.btnOutTeam   = cc.uiloader:seekNodeByName(buttonContainer, "btn_out_team")
	--self.btnTransferCaptain = cc.uiloader:seekNodeByName(buttonContainer, "btn_transfer_captain")
	--self.btnDissolutionTeam = cc.uiloader:seekNodeByName(buttonContainer, "btn_dissolution_team")
	self.btn_invite_team    = cc.uiloader:seekNodeByName(buttonContainer, "btn_invite_team")
	self.btn_findLeader_team    = cc.uiloader:seekNodeByName(buttonContainer, "btn_findLeader_team")
	self.btn_findLeader_team:setVisible(false)

	--self.btnCheckInfo:onButtonClicked(handler(self, self.onCheckInfo_clickHandler))
	--self.btnAddFriend:onButtonClicked(handler(self, self.onAddFriend_clickHandler))
	self.btnLeaveTeam:onButtonClicked(handler(self, self.onLeaveTeam_clickHandler))
	--self.btnOutTeam:onButtonClicked(handler(self, self.onOutTeam_clickHandler))
	--self.btnTransferCaptain:onButtonClicked(handler(self, self.onTransferCaptain_clickHandler))
	--self.btnDissolutionTeam:onButtonClicked(handler(self, self.onDissolutionTeam_clickHandler))

	self.btn_invite_team:onButtonClicked(handler(self, self.onInvite_clickHandler))
	self.btn_findLeader_team:onButtonClicked(handler(self, self.onfindLeader_clickHandler))

	self:disableAllButton()
	--self.chkAutoAcceptInvite:setButtonSelected(false)
	self.chkAutoAcceptRequest:setButtonSelected(false)

	local playerListContainer = display.newNode()
	playerListContainer:setPosition(23, 114 - 41)
	root:addChild(playerListContainer)

	local listSelectedSkin = display.newScale9Sprite("#com_listSelFrame.png", 0, 0, cc.size(834, 50))
	listSelectedSkin:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	listSelectedSkin:setVisible(false)
	playerListContainer:addChild(listSelectedSkin)

	self.playerListContainer = playerListContainer
	self.listSelectedSkin = listSelectedSkin
end

--
-- 初始化对全局事件的监听，用于更新组件UI。
--
function SubView_MyTeam:initListeners()
	self:registerGlobalEventHandler(TeamEvent.TEAM_INFO_CHANGED, function()
		self:invalidateTeamOption()
		self:invalidateTeamMenberList()
		self:invalidateButtonState()
	end)

	self:registerGlobalEventHandler(TeamEvent.TEAM_OPTION_CHANGED, function()
		self:invalidateTeamOption()
	end)
end

--
-- 设置当前的选中项。
--
function SubView_MyTeam:setSelectedItem(listItem)
	self._currentSelected = listItem

	if listItem then
		self.listSelectedSkin:setPositionY(listItem:getPositionY() - 2)
		self.listSelectedSkin:setVisible(true)
	else
		self.listSelectedSkin:setVisible(false)
	end
	self:invalidateButtonState()
 
end

--
-- 禁用所有的操作按钮。
--
function SubView_MyTeam:disableAllButton()
	--self.btnCheckInfo:setButtonEnabled(false)
	--self.btnAddFriend:setButtonEnabled(false)
	self.btnLeaveTeam:setButtonEnabled(false)
	--self.btnOutTeam:setButtonEnabled(false)
	--self.btnTransferCaptain:setButtonEnabled(false)
	--self.btnDissolutionTeam:setButtonEnabled(false)
end

function SubView_MyTeam:onCheckInfo_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		--
		-- TODO: 处理查看装备
		--
		local selectData = self._currentSelected:getItemData()
		GameNet:sendMsgToSocket(10011, {player_id = selectData.player_id})
	end
end

function SubView_MyTeam:onInvite_clickHandler()
	SoundManager:playClickSound()
	local TeamInviteView = require("app.modules.team.view.TeamInviteView").new()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,TeamInviteView)

end

function SubView_MyTeam:onfindLeader_clickHandler()
	GameNet:sendMsgToSocket(21017)
end

function SubView_MyTeam:onAddFriend_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		--
		-- TODO: 处理添加好友
		--
		local selectData = self._currentSelected:getItemData()
		GameNet:sendMsgToSocket(24003, {tplayerId = selectData.player_id})
	end
end

function SubView_MyTeam:onLeaveTeam_clickHandler()
	SoundManager:playClickSound()
	GlobalController.team:LeaveTeam()
end

function SubView_MyTeam:onOutTeam_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		local selectData = self._currentSelected:getItemData()
		local playerId = selectData.player_id
		GlobalController.team:DismissPlayer(playerId)
	end
end

function SubView_MyTeam:onTransferCaptain_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		local selectData = self._currentSelected:getItemData()
		local playerId = selectData.player_id
		GlobalController.team:TransferLeadToPlayer(playerId)
	end
end

function SubView_MyTeam:onDissolutionTeam_clickHandler()
	SoundManager:playClickSound()
	GlobalController.team:DissolutionTeam()
end

function SubView_MyTeam:onSelectedListItem(listItem)
	SoundManager:playClickSound()
	self:setSelectedItem(listItem)
end

--
-- 刷新当前的组队系统选项设置。
--
function SubView_MyTeam:invalidateTeamOption()
	local isEnabled1 = GlobalController.team:GetOptionEnabled(GlobalController.team.TEAM_OPTION_AUTO_ACCEPT_INVITE)
	local isEnabled2 = GlobalController.team:GetOptionEnabled(GlobalController.team.TEAM_OPTION_AUTO_ACCEPT_REQUEST)

	--self.chkAutoAcceptInvite:setButtonSelected(isEnabled1)
	self.chkAutoAcceptRequest:setButtonSelected(isEnabled2)
end

--
-- 刷新当前的团队列表。
--
function SubView_MyTeam:invalidateTeamMenberList()
	-- 数据改变清除当前选中。
	self:setSelectedItem(nil)

	-- -------------------------------------------
	local getListItem = function(cacheItems)
		local listItem = nil
		if cacheItems and #cacheItems > 0 then
			listItem = table.remove(cacheItems, #cacheItems)
		else
			listItem = require("app.modules.team.view.TeamItem").new()
			listItem:setTouchEnabled(true)
			listItem:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "ended" then
		        	self:onSelectedListItem(listItem)

		        	if listItem:getData().player_id ~= RoleManager:getInstance().roleInfo.player_id then
		        		if self.TeamOperationMenu == nil then
							self.TeamOperationMenu = require("app.modules.team.view.TeamOperationMenu").new()
							self.playerListContainer:getParent():addChild(self.TeamOperationMenu)
						end
						local pos = self.playerListContainer:getParent():convertToWorldSpace(event)
						self.TeamOperationMenu:setData(listItem:getData())
						if pos.x - 100 >  self.playerListContainer:getParent():getContentSize().width - self.TeamOperationMenu:getContentSize().width  then
							pos.x = pos.x - self.TeamOperationMenu:getContentSize().width  + 30
						end
						self.TeamOperationMenu:setPosition(pos.x - 100,pos.y - self.TeamOperationMenu:getContentSize().height)
						self.TeamOperationMenu:setVisible(true)
		        	end
 
		    	end
		        return true
		    end)
			self.playerListContainer:addChild(listItem)
		end
		return listItem
	end

	-- -------------------------------------------
	local destoryItems = function(items)
		if items and #items > 0 then
			for _, v in ipairs(items) do
				v:removeFromParent()
			end
		end
	end

	-- -------------------------------------------
	local layoutItems = function(items)
		local ITEM_V_GAP  = 12
		local ITEM_HEIGHT = 40
		local LIST_HEIGHT = 350
		local COUNT = #items
 
		for i = 1, COUNT do
			local posY = LIST_HEIGHT - (ITEM_HEIGHT + ITEM_V_GAP) * (i - 1)
			local listItem = items[i]

			listItem:setPositionY(posY)
		end
	end

	-- -------------------------------------------
	local buildItemsByData = function(data, cacheItems)
		local newListItems = {}
		if data then
			for _, v in ipairs(data) do
				local listItem = getListItem(cacheItems)
				listItem:setData(v)
				newListItems[#newListItems + 1] = listItem
			end
		end
		return newListItems
	end

	local oldListItems   = self._menberList
	local menberListData = GlobalController.team:GetTeamPlayerList()
	local newListItems   = buildItemsByData(menberListData, oldListItems)

	if self.teamAdditionNum then
	 	self.teamAdditionNum:setString(((1 + (#newListItems - 1)/10)*100).."%")
	 end

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._menberList = newListItems
end

--
-- 刷新当前的按钮操作状态。
--
function SubView_MyTeam:invalidateButtonState()
	self:disableAllButton()

	-- 如果我没有加入任何一个队伍，则不继续往下处理。
	if not GlobalController.team:HasTeam() then
		self.btn_invite_team:setVisible(false)
		self.btn_findLeader_team:setVisible(false)
		self.btnLeaveTeam:setVisible(false)
		return
	end

	-- 检查是否为队长，开放对应的按钮。
	local myPlayerId = RoleManager:getInstance().roleInfo.player_id
	local isTeamLead = GlobalController.team:IsTeamLead(myPlayerId)

	self.btnLeaveTeam:setVisible(true)
	if isTeamLead then
		--self.btnDissolutionTeam:setButtonEnabled(true)
		self.btn_invite_team:setVisible(true)
		self.btn_findLeader_team:setVisible(false)
	else
		self.btn_invite_team:setVisible(false)
		self.btn_findLeader_team:setVisible(false)
	end

	-- 检查当前是否有选中的玩家，开放查看装备和加为好友的按钮。
	-- Fix me，加为好友这里还需要判断一下他是否已经为我的好友，
	--[[
	if self._currentSelected then
		local selectPlayerId = self._currentSelected:getItemData().player_id
		-- 如果选中的是自己，则没有这些选项。
		if selectPlayerId ~= myPlayerId then
			self.btnCheckInfo:setButtonEnabled(true)
			self.btnAddFriend:setButtonEnabled(true)

			-- 我是队长踢人选项打开。
			if isTeamLead then
				self.btnTransferCaptain:setButtonEnabled(true)
				self.btnOutTeam:setButtonEnabled(true)
			end
		end
	end
	--]]
	self.btnLeaveTeam:setButtonEnabled(true)
end

-- ============================================================================================ Class PlayerListItem imp
function PlayerListItem:ctor()
	self:initialization()
end

function PlayerListItem:initialization()
	self._data = nil
	self:initComponents()
end


function PlayerListItem:initComponents()
	self.lbl_playerName = self:createLabel(123)
	self.lbl_playerLevel = self:createLabel(307)
	self.lbl_playerCareer = self:createLabel(490)
	self.lbl_playerGuild = self:createLabel(690)

	self:addChild(self.lbl_playerName)
	self:addChild(self.lbl_playerLevel)
	self:addChild(self.lbl_playerCareer)
	self:addChild(self.lbl_playerGuild)
end

function PlayerListItem:createLabel(posX)
	local label = cc.ui.UILabel.new({text = " ",
		size = 18,
		color = cc.c3b(242, 210, 176),
		align = cc.TEXT_ALIGNMENT_CENTER,
		valign =  cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
		x = posX, y = 0})
	label:setLayoutSize(240, 30)
	label:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER])
	return label
end

function PlayerListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function PlayerListItem:getItemData()
	return self._data
end

function PlayerListItem:invalidateData()
	local data = self._data
	if not data then return end
	--[[
		<Type name="proto_team_member_info" describe="捐献信息">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="name" type="string" describe="玩家姓名"/>
			<Param name="type" type="int8" describe="玩家类型1队长 2队员"/>
			<Param name="lv" type="int8" describe="等级"/>
			<Param name="career" type="int16" describe="职业"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]

	local getPlayerName = function()
		local name = ""
		if data.type == 1 then
			name = name .. "[队长]"
		end
		return name .. data.name
	end

	self.lbl_playerName:setString(getPlayerName()) 
	self.lbl_playerLevel:setString(data.lv) 
	self.lbl_playerCareer:setString(RoleCareerName[data.career])
	self.lbl_playerGuild:setString(data.guild_name) 
end

return SubView_MyTeam