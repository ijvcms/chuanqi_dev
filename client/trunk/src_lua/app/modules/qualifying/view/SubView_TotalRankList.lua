--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-15 16:46:29
--

--[[
	排位赛窗口子视图
	*子视图：排位赛总排行
]]
local TabView = import("app.gameui.tab.TabView")
local SubView_TotalRankList = class("SubView_TotalRankList", TabView)
local ListItem = class("ListItem", function()
	return display.newNode()
end)

local NUM_ITEM_OF_PAGE = 11

--
-- 构造器
--
function SubView_TotalRankList:ctor(view, flag)
	SubView_TotalRankList.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_TotalRankList:initialization()
	SubView_TotalRankList.super.initialization(self)

	self._currentSelected = nil

	self:initComponents()
	self:initListeners()
	self:invalidatePage()
	GlobalController.qualifying:RefreshTotalRankList()
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_TotalRankList:Show()
	SubView_TotalRankList.super.Show(self)
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_TotalRankList:Hide()
	SubView_TotalRankList.super.Hide(self)
end

--
-- 初始化组件相关显示对象。
--
function SubView_TotalRankList:initComponents()
	local root = self:GetView()

	-- 更多操作按钮。
	local btn_more_operate = cc.uiloader:seekNodeByName(root, "btn_more_operate")
    btn_more_operate:setTouchEnabled(true)
    btn_more_operate:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn_more_operate:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn_more_operate:setScale(1.0)
            -- TODO 更多操作
            self:showMoreOpPannel()
        end
        return true
    end)

    --
    -- 列表容器
    --
	local listContainer = display.newNode()
	listContainer:setPosition(12, 68)
	root:addChild(listContainer)

	local listSelectedSkin = display.newScale9Sprite("#com_listSelFrame.png", 4, 0, cc.size(578, 37))
	listSelectedSkin:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	listSelectedSkin:setVisible(false)
	listContainer:addChild(listSelectedSkin)

	self.btn_more_operate = btn_more_operate
	self.listContainer = listContainer
	self.listSelectedSkin = listSelectedSkin

	self:initPageControl()
	self:initMoreOpButtons()
end

--
-- 更多操作按钮组初始化。
--
function SubView_TotalRankList:initMoreOpButtons()
	local root = self:GetView()
	local container_more_op = cc.uiloader:seekNodeByName(root, "container_more_opreation")

	local btn_check_info = cc.uiloader:seekNodeByName(container_more_op, "btn_check_info")

	btn_check_info:onButtonClicked(handler(self, self.onButton_checkInfoHandler))

	local opLayer = display.newLayer()
	container_more_op:retain()
	container_more_op:removeFromParent(false)
	opLayer:setVisible(false)
	opLayer:addChild(container_more_op)
	opLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:hideMoreOpPannel()
        end
        return true
    end)
    container_more_op:release()
	root:addChild(opLayer)

	self.container_more_op = opLayer
end

--
-- 初始化翻页控件。
--
function SubView_TotalRankList:initPageControl()
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
-- 初始化全局数据事件监听。
--
function SubView_TotalRankList:initListeners()
	-- 获取挑战列表
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_TOTAL_RANK, function()
		self:invalidatePlayerList()
	end)
end

--
-- 获取当前页面的列表数据。
--
function SubView_TotalRankList:getDataOfCurrentPage()
	local listData = self._playerListData
	local pageData = {}

	if listData then
		local startIndex = (self._currentPage - 1) * NUM_ITEM_OF_PAGE
		for i = 1, NUM_ITEM_OF_PAGE do
			local item = listData[startIndex + i]
			if item then
				pageData[#pageData + 1] = item
			end
		end
	end
	
	return pageData
end

--
-- 显示更多操作面板。
--
function SubView_TotalRankList:showMoreOpPannel()
	self.container_more_op:setVisible(true)
end

--
-- 隐藏更多操作面板。
--
function SubView_TotalRankList:hideMoreOpPannel()
	self.container_more_op:setVisible(false)
end

--
-- 设置当前的选中项。
--
function SubView_TotalRankList:setSelectedItem(listItem)
	self:hideMoreOpPannel()
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
--
--
function SubView_TotalRankList:onButton_checkInfoHandler()
	self:hideMoreOpPannel()
	if self._currentSelected then
		local itemData = self._currentSelected:getItemData()
		GameNet:sendMsgToSocket(10011, {player_id = itemData.player_id})
	end
end

--
-- 当选中了一个项。
--
function SubView_TotalRankList:onSelectedListItem(listItem)
	SoundManager:playClickSound()
	self:setSelectedItem(listItem)
end

--
-- 刷新当前的按钮操作状态。
--
function SubView_TotalRankList:invalidateButtonState()
	if self._currentSelected then
		self.btn_more_operate:setTouchEnabled(true)
		self.btn_more_operate:setColor(cc.c3b(255, 255, 255))
	else
		self.btn_more_operate:setTouchEnabled(false)
		self.btn_more_operate:setColor(cc.c3b(128, 128, 128))
	end
end

--
-- 刷新当前附近的玩家列表。
--
function SubView_TotalRankList:invalidatePlayerList()
	self._playerListData = GlobalController.qualifying:GetTotalRankList()

	self._totalPage   = math.ceil(#self._playerListData / NUM_ITEM_OF_PAGE)
	self._currentPage = self._totalPage > 0 and 1 or 0
	self:invalidatePage()
end

--
-- 刷新当前页面的玩家列表。
--
function SubView_TotalRankList:invalidatePage()
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
			listItem = ListItem.new()
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
		local ITEM_V_GAP  = 0
		local ITEM_HEIGHT = 33
		local LIST_HEIGHT = 365
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

	local oldListItems   = self._rankItems
	local playerListData = self:getDataOfCurrentPage()
	local newListItems   = buildItemsByData(playerListData, oldListItems)

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._rankItems = newListItems

	self:setSelectedItem(nil)
end


-- ============================================================================================ Class ListItem imp
function ListItem:ctor()
	self:initialization()
end

function ListItem:initialization()
	self._data = nil
	self:initComponents()
end


function ListItem:initComponents()
	self.lbl_playerRank   = self:createLabel(26)
	self.lbl_playerName   = self:createLabel(130)
	self.lbl_playerLevel  = self:createLabel(238)
	self.lbl_playerCareer = self:createLabel(296)
	self.lbl_playerCombat = self:createLabel(392)
	self.lbl_playerGuild  = self:createLabel(510)

	self:addChild(self.lbl_playerRank)
	self:addChild(self.lbl_playerName)
	self:addChild(self.lbl_playerLevel)
	self:addChild(self.lbl_playerCareer)
	self:addChild(self.lbl_playerCombat)
	self:addChild(self.lbl_playerGuild)
end

function ListItem:createLabel(posX)
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

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

function ListItem:invalidateData()
	local data = self._data
	if not data then return end
	--[[
		<Type name="proto_arena_rank_info" describe="竞技场排行榜信息">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="name" type="string" describe="玩家名字"/>
			<Param name="career" type="int16" describe="玩家职业"/>
			<Param name="fight" type="int16" describe="玩家战斗力"/>
			<Param name="lv" type="int16" describe="等级"/>
			<Param name="guild_name" type="string" describe="公会名"/>
			<Param name="rank" type="int32" describe="玩家排名"/>
		</Type>
	]]
	self.lbl_playerRank:setString(data.rank)
	self.lbl_playerName:setString(data.name)
	self.lbl_playerLevel:setString(data.lv)
	self.lbl_playerCareer:setString(RoleCareerName[data.career])
	self.lbl_playerCombat:setString(data.fight)
	self.lbl_playerGuild:setString(data.guild_name)
end

return SubView_TotalRankList