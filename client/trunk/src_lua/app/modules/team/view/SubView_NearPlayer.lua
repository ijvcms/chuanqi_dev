--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 18:00:41
--

--[[
	组队窗口子视图
	*子视图：附近玩家
]]
local TabView = import("app.gameui.tab.TabView")
local SubView_NearPlayer = class("SubView_NearPlayer", TabView)
local PlayerListItem = class("PlayerListItem", function()
	return display.newNode()
end)

local NUM_ITEM_OF_PAGE = 5

--
-- 构造器
--
function SubView_NearPlayer:ctor(view, flag)
	SubView_NearPlayer.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_NearPlayer:initialization()
	SubView_NearPlayer.super.initialization(self)

	self._currentSelected = nil

	self:initComponents()
	self:initListeners()
	self:invalidatePage()
	GlobalController.team:RefreshNearPlayerList()
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_NearPlayer:Show()
	SubView_NearPlayer.super.Show(self)
	self:invalidatePlayerList()
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_NearPlayer:Hide()
	SubView_NearPlayer.super.Hide(self)
end

--
-- 初始化组件。
--
function SubView_NearPlayer:initComponents()
	local root = self:GetView()
	self.btnRefreshList  = cc.uiloader:seekNodeByName(root, "btn_refresh")
	self.btnAddFriend    = cc.uiloader:seekNodeByName(root, "btn_add_friend")
	self.btnInvitePlayer = cc.uiloader:seekNodeByName(root, "btn_invite_player")

	self.btnRefreshList:onButtonClicked(handler(self, self.onRefreshList_clickHandler))
	self.btnAddFriend:onButtonClicked(handler(self, self.onAddFriend_clickHandler))
	self.btnInvitePlayer:onButtonClicked(handler(self, self.onInvitePlayer_clickHandler))

	local listContainer = display.newNode()
	listContainer:setPosition(30, 130)
	root:addChild(listContainer)

	local listSelectedSkin = display.newScale9Sprite("#com_listSelFrame.png", 0, 0, cc.size(823, 37))
	listSelectedSkin:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	listSelectedSkin:setVisible(false)
	listContainer:addChild(listSelectedSkin)

	self.listContainer = listContainer
	self.listSelectedSkin = listSelectedSkin

	self:initPageControl()
end

--
-- 初始化翻页控件。
--
function SubView_NearPlayer:initPageControl()
	self._currentPage = 0
	self._totalPage = 0

	local root = self:GetView()
	self.btnPreviousPage = cc.uiloader:seekNodeByName(root, "btn_previous_page")
	self.btnNextPage     = cc.uiloader:seekNodeByName(root, "btn_next_page")
	self.lblPageStatus   = cc.uiloader:seekNodeByName(root, "lbl_list_page")

	self.btnPreviousPage:onButtonClicked(function()
		SoundManager:playClickSound()
		if self._currentPage > 1 then
			self._currentPage = self._currentPage - 1
			self:invalidatePage()
		end
	end)

	self.btnNextPage:onButtonClicked(function()
		SoundManager:playClickSound()
		if self._currentPage < self._totalPage then
			self._currentPage = self._currentPage + 1
			self:invalidatePage()
		end
	end)
end

--
-- 初始化对全局事件的监听，用于更新组件UI。
--
function SubView_NearPlayer:initListeners()
	local doRefreshList = function()
		self:invalidatePlayerList()
	end
	self:registerGlobalEventHandler(TeamEvent.TEAM_INFO_CHANGED, doRefreshList)
	self:registerGlobalEventHandler(TeamEvent.GET_NEAR_PLAYER_INFO, doRefreshList)
end

--
-- 获取当前页面的列表数据。
--
function SubView_NearPlayer:getDataOfCurrentPage()
	local teamListData = self._playerListData
	local pageData = {}

	if teamListData then
		local startIndex = (self._currentPage - 1) * NUM_ITEM_OF_PAGE
		for i = 1, NUM_ITEM_OF_PAGE do
			local item = teamListData[startIndex + i]
			if item then
				pageData[#pageData + 1] = item
			end
		end
	end
	
	return pageData
end

--
-- 设置当前的选中项。
--
function SubView_NearPlayer:setSelectedItem(listItem)
	self._currentSelected = listItem

	if listItem then
		self.listSelectedSkin:setPositionY(listItem:getPositionY())
		self.listSelectedSkin:setVisible(true)
	else
		self.listSelectedSkin:setVisible(false)
	end
	self:invalidateButtonState()
end

--
-- 刷新按钮点击
--
function SubView_NearPlayer:onRefreshList_clickHandler()
	SoundManager:playClickSound()
	GlobalController.team:RefreshNearPlayerList()
end

--
-- 加为好友点击
--
function SubView_NearPlayer:onAddFriend_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		local selectData = self._currentSelected:getItemData()
		local playerId = selectData.player_id
		--
		-- TODO : 这里处理添加好友
		--
	end
end

--
-- 邀请按钮点击
--
function SubView_NearPlayer:onInvitePlayer_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		local selectData = self._currentSelected:getItemData()
		local playerId = selectData.player_id
		GlobalController.team:InvitePlayer(playerId)
	end
end

--
-- 当选中了一个团队
--
function SubView_NearPlayer:onSelectedListItem(listItem)
	SoundManager:playClickSound()
	self:setSelectedItem(listItem)
end

--
-- 刷新当前的按钮操作状态。
--
function SubView_NearPlayer:invalidateButtonState()
	local myPlayerId = RoleManager:getInstance().roleInfo.player_id
	local isTeamLead = GlobalController.team:IsTeamLead(myPlayerId)
	local isSelected = false
	local isSelectedNotMe = false

	if self._currentSelected then
		local selectPlayerId = self._currentSelected:getItemData().player_id
		isSelected = true
		isSelectedNotMe = selectPlayerId ~= myPlayerId
	end

	self.btnAddFriend:setButtonEnabled(isSelected and isSelectedNotMe)
	self.btnInvitePlayer:setButtonEnabled(isSelected and isSelectedNotMe and isTeamLead)
end

--
-- 刷新当前附近的玩家列表。
--
function SubView_NearPlayer:invalidatePlayerList()
	self._playerListData = GlobalController.team:GetNearPlayerList()

	self._totalPage   = math.ceil(#self._playerListData / NUM_ITEM_OF_PAGE)
	self._currentPage = self._totalPage > 0 and 1 or 0
	self:invalidatePage()
end

--
-- 刷新当前页面的玩家列表。
--
function SubView_NearPlayer:invalidatePage()
	-- 设置当前页数信息
	self.lblPageStatus:setString(string.format("%d/%d", self._currentPage, self._totalPage))
	self.btnPreviousPage:setButtonEnabled(self._currentPage > 1)
	self.btnNextPage:setButtonEnabled(self._currentPage < self._totalPage)

	-- -------------------------------------------
	local getListItem = function(cacheItems)
		local listItem = nil
		if cacheItems and #cacheItems > 0 then
			listItem = table.remove(cacheItems, #cacheItems)
		else
			listItem = PlayerListItem.new()
			listItem:setTouchEnabled(true)
			listItem:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "ended" then
		        	self:onSelectedListItem(listItem)
		    	end
		        return true
		    end)
			self.listContainer:addChild(listItem)
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
		local ITEM_V_GAP  = 10
		local ITEM_HEIGHT = 40
		local LIST_HEIGHT = 230
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
				listItem:setItemData(v)
				newListItems[#newListItems + 1] = listItem
			end
		end
		return newListItems
	end

	local oldListItems   = self._teamItems
	local playerListData = self:getDataOfCurrentPage()
	local newListItems   = buildItemsByData(playerListData, oldListItems)

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._teamItems = newListItems

	self:setSelectedItem(nil)
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
		valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
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
		<Type name="proto_near_by_player" describe="附近玩家信息(组队系统)">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="name" type="string" describe="玩家姓名"/>
			<Param name="lv" type="int8" describe="等级"/>
			<Param name="career" type="int16" describe="职业"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]
	self.lbl_playerName:setString(data.name) 
	self.lbl_playerLevel:setString(data.lv) 
	self.lbl_playerCareer:setString(RoleCareerName[data.career]) 
	self.lbl_playerGuild:setString(data.guild_name) 
end

return SubView_NearPlayer