--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 18:00:41
--

--[[
	组队窗口子视图
	*子视图：附近队伍
]]
local TabView = import("app.gameui.tab.TabView")
local SubView_NearTeam = class("SubView_NearTeam", TabView)
local PlayerListItem = class("PlayerListItem", function()
	return display.newNode()
end)

local NUM_ITEM_OF_PAGE = 5

--
-- 构造器
--
function SubView_NearTeam:ctor(view, flag)
	SubView_NearTeam.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_NearTeam:initialization()
	SubView_NearTeam.super.initialization(self)

	self._currentSelected = nil

	self:initComponents()
	self:initListeners()
	self:invalidatePage()
	
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_NearTeam:Show()
	SubView_NearTeam.super.Show(self)
	self:invalidateTeamList()
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_NearTeam:Hide()
	SubView_NearTeam.super.Hide(self)
end

--
-- 初始化组件。
--
function SubView_NearTeam:initComponents()
	local root = self:GetView()
	self.btnRefreshList = cc.uiloader:seekNodeByName(root, "btn_refresh")
	self.btnRequestJoin = cc.uiloader:seekNodeByName(root, "btn_join_team")
	self.btnCreateTeam  = cc.uiloader:seekNodeByName(root, "btn_create_team")

	self.chkAutoAcceptInvite = cc.uiloader:seekNodeByName(root, "chk_auto_accept_invite")

	self.chkAutoAcceptInvite:onButtonStateChanged(function(event)
		GlobalController.team:SetOptionEnabled(GlobalController.team.TEAM_OPTION_AUTO_ACCEPT_INVITE,
			self.chkAutoAcceptInvite:isButtonSelected())
	end)

	self.btnRefreshList:onButtonClicked(handler(self, self.onRefreshList_clickHandler))
	self.btnRequestJoin:onButtonClicked(handler(self, self.onRequestJoin_clickHandler))
	self.btnCreateTeam:onButtonClicked(handler(self, self.onCreateTeam_clickHandler))

	local listContainer = display.newNode()
	listContainer:setPosition(23, 114 - 41)
	root:addChild(listContainer)

	local listSelectedSkin = display.newScale9Sprite("#com_listSelFrame.png", 0, 0, cc.size(834, 50))
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
function SubView_NearTeam:initPageControl()
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
function SubView_NearTeam:initListeners()
	local doRefreshList = function()
		self:invalidateTeamList()
	end
	self:registerGlobalEventHandler(TeamEvent.TEAM_INFO_CHANGED, doRefreshList)
	self:registerGlobalEventHandler(TeamEvent.GET_NEAR_TEAM_INFO, doRefreshList)

end

--
-- 获取当前页的数据列表。
--
function SubView_NearTeam:getDataOfCurrentPage()
	local teamListData = self._teamListData
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
function SubView_NearTeam:setSelectedItem(listItem)
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
-- 刷新按钮点击
--
function SubView_NearTeam:onRefreshList_clickHandler()
	SoundManager:playClickSound()
	GlobalController.team:RefreshNearTeamList()
end

--
-- 请求加入一个团队点击
--
function SubView_NearTeam:onRequestJoin_clickHandler()
	SoundManager:playClickSound()
	if self._currentSelected then
		local selectData = self._currentSelected:getData()
		local teamId = selectData.team_id
		GlobalController.team:RequestJoinTeam(teamId)
	end
end

--
-- 创建一个团队点击
--
function SubView_NearTeam:onCreateTeam_clickHandler()
	SoundManager:playClickSound()
	GlobalController.team:CreateTeam()
end

--
-- 当选中了一个团队
--
function SubView_NearTeam:onSelectedListItem(listItem)
	SoundManager:playClickSound()
	self:setSelectedItem(listItem)
end

--
-- 刷新当前的按钮使用状态。
--
function SubView_NearTeam:invalidateButtonState()
	local noTeam = not GlobalController.team:HasTeam()
	local isSelected = self._currentSelected ~= nil

	self.btnCreateTeam:setButtonEnabled(noTeam)
	self.btnRequestJoin:setButtonEnabled(noTeam and isSelected)
end

--
-- 刷新当前的附近团队信息。
--
function SubView_NearTeam:invalidateTeamList()
	self._teamListData = GlobalController.team:GetNearTeamList()

	self._totalPage   = math.ceil(#self._teamListData / NUM_ITEM_OF_PAGE)
	self._currentPage = self._totalPage > 0 and 1 or 0
	self:invalidatePage()
end

--
-- 刷新当前页附近团队信息。
--
function SubView_NearTeam:invalidatePage()
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
			listItem = require("app.modules.team.view.TeamNearItem").new()
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

	local oldListItems   = self._teamItems
	local teamListData = self:getDataOfCurrentPage()
	local newListItems   = buildItemsByData(teamListData, oldListItems)

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
	self.lbl_leadName   = self:createLabel(111)
	self.lbl_leadLevel  = self:createLabel(261)
	self.lbl_leadCareer = self:createLabel(411)
	self.lbl_teamNumber = self:createLabel(561)
	self.lbl_leadGuild  = self:createLabel(711)

	self:addChild(self.lbl_leadName)
	self:addChild(self.lbl_leadLevel)
	self:addChild(self.lbl_leadCareer)
	self:addChild(self.lbl_teamNumber)
	self:addChild(self.lbl_leadGuild)
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
		<Type name="proto_near_by_team" describe="附近队伍信息(组队系统)">
			<Param name="team_id" type="int64" describe="队伍id"/>
			<Param name="name" type="string" describe="队长姓名"/>
			<Param name="lv" type="int8" describe="队长等级"/>
			<Param name="career" type="int16" describe="队长职业"/>
			<Param name="memeber_num" type="int16" describe="队伍人数"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]
	self.lbl_leadName:setString(data.name)
	self.lbl_leadLevel:setString(data.lv) 
	self.lbl_leadCareer:setString(RoleCareerName[data.career]) 
	self.lbl_teamNumber:setString(data.memeber_num)
	self.lbl_leadGuild:setString(data.guild_name)
end

return SubView_NearTeam