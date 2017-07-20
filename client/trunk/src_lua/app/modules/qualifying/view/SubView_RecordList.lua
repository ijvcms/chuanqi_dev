--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-15 16:46:48
--

--[[
	排位赛窗口子视图
	*子视图：挑战记录
]]
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local TabView           = import("app.gameui.tab.TabView")
local SubView_RecordList = class("SubView_RecordList", TabView)
local ListItem = class("ListItem", function()
	return display.newNode()
end)

local ITEM_LAYOUT_FILE = "resui/item_challenge_record.ExportJson"
local NUM_ITEM_OF_PAGE = 5

--
-- 构造器
--
function SubView_RecordList:ctor(view, flag)
	SubView_RecordList.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_RecordList:initialization()
	SubView_RecordList.super.initialization(self)

	local loader = GameUILoaderUtils.new()
	self.loader = loader
	self.loader:AddUIEditorCache(ITEM_LAYOUT_FILE)

	self:initComponents()
	self:initListeners()
	self:invalidatePage()
	GlobalController.qualifying:RefreshRecordList()
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_RecordList:Show()
	SubView_RecordList.super.Show(self)
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_RecordList:Hide()
	SubView_RecordList.super.Hide(self)
end

--
-- 销毁
--
function SubView_RecordList:Destory()
	SubView_RecordList.super.Destory(self)
	self.loader:Clear()
end

--
-- 初始化组件相关显示对象。
--
function SubView_RecordList:initComponents()
	local root = self:GetView()

	-- 清空记录按钮。
	local btn_clear_record = cc.uiloader:seekNodeByName(root, "btn_clear_record")
    btn_clear_record:setTouchEnabled(true)
    btn_clear_record:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn_clear_record:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn_clear_record:setScale(1.0)
            -- TODO 清空记录
            GlobalController.qualifying:ClearRecords()
        end
        return true
    end)

	-- 列表容器
	local playerListContainer = display.newNode()
	playerListContainer:setPosition(12, 76)
	root:addChild(playerListContainer)

	self.playerListContainer = playerListContainer

	self:initPageControl()
end

--
-- 初始化翻页控件。
--
function SubView_RecordList:initPageControl()
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
function SubView_RecordList:initListeners()
	-- 获取记录列表
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_RECORD, function()
		self:invalidateRecordList()
	end)
end

--
-- 获取当前页面的列表数据。
--
function SubView_RecordList:getDataOfCurrentPage()
	local listData = self._recordListData
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


function SubView_RecordList:invalidateRecordList()
	self._recordListData = GlobalController.qualifying:GetRecordList()

	self._totalPage   = math.ceil(#self._recordListData / NUM_ITEM_OF_PAGE)
	self._currentPage = self._totalPage > 0 and 1 or 0
	self:invalidatePage()
end

--
-- 刷新当前页面的玩家列表。
--
function SubView_RecordList:invalidatePage()
	-- 设置当前页数信息
	self.lblPageStatus:setString(string.format("%d/%d", self._currentPage, self._totalPage))
	self.btnPreviousPage:setButtonEnabled(self._currentPage > 1)
	self.btnNextPage:setButtonEnabled(self._currentPage < self._totalPage)

	-- -------------------------------------------
	local getListItem = function(cacheItems)
		local listItem = nil
		if cacheItems and #cacheItems > 0 then
			listItem = table.remove(cacheItems, #cacheItems)
			listItem:ShowLine()
		else
			local newLayoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
			listItem = ListItem.new(newLayoutNode)
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
		local ITEM_V_GAP  = 0
		local ITEM_HEIGHT = 76
		local LIST_HEIGHT = 387
		local COUNT = #items

		for i = 1, COUNT do
			local posY = LIST_HEIGHT - (ITEM_HEIGHT + ITEM_V_GAP) * (i - 1) - ITEM_HEIGHT
			local listItem = items[i]

			listItem:setPositionY(posY)

			-- 最后一个不显示线条
			if i == COUNT then
				listItem:HideLine()
			end
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

	local oldListItems   = self._recordList
	local playerListData = self:getDataOfCurrentPage()
	local newListItems   = buildItemsByData(playerListData, oldListItems)

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._recordList = newListItems
end

-- ============================================================================================ Class ListItem imp
function ListItem:ctor(root)
	self._root = root
	self:initialization()
end

function ListItem:initialization()
	self:initComponents()
end

function ListItem:initComponents()
	local itemUI = self._root
	self:addChild(itemUI)

	self.img_outline       = cc.uiloader:seekNodeByName(itemUI, "img_outline")
	self.lbl_record_time   = cc.uiloader:seekNodeByName(itemUI, "lbl_record_time")
	self.lbl_result_failed = cc.uiloader:seekNodeByName(itemUI, "lbl_result_failed")
	self.lbl_result_win    = cc.uiloader:seekNodeByName(itemUI, "lbl_result_win")
	self.btn_counterattack = cc.uiloader:seekNodeByName(itemUI, "btn_counterattack")

	self.btn_counterattack:onButtonClicked(function()
		-- 这里，反击就是再次挑战他。
		local data = self:getItemData()
		GlobalController.qualifying:ChallengePlayer(data.player_id)
	end)

	-- 初始化富文本组件
	local container_info    = cc.uiloader:seekNodeByName(itemUI, "container_info")
	local richTextControl = SuperRichText.new(nil, 260)
	container_info:addChild(richTextControl)
	self.richTextControl = richTextControl
end

--[[
	<Type name="proto_arena_record" describe="挑战记录">
		<Param name="type" type="int64" describe="记录类型 1挑战成功 2被击败 3挑战失败 4防守成功 "/>
		<Param name="player_id" type="int64" describe="玩家id"/>
		<Param name="name" type="string" describe="玩家名字"/>
		<Param name="rank" type="int16" describe="名次"/>
		<Param name="time" type="int32" describe="时间戳"/>
	</Type>
]]

function ListItem:getXMLInfo()
	local data = self:getItemData()
	local xml = ""
	if data then
		local infoType = tonumber(data.type)
		local xmlTemplate = ""
		if infoType == 1 then
			xmlTemplate = "你不费吹灰之力就击败了<font color='0xD59738'>%s</font>, 你的名次上升至<font color='0x2C9540'>%d</font>名。"
		elseif infoType == 2 then
			xmlTemplate = "<font color='0xD59738'>%s</font>趁其不备击败了你, 你的名次下降至<font color='0x2C9540'>%d</font>名。"
		elseif infoType == 3 then
			xmlTemplate = "你只差一点就可以击败<font color='0xD59738'>%s</font>了, 别灰心继续努力哦。"
		elseif infoType == 4 then
			xmlTemplate = "<font color='0xD59738'>%s</font>自不量力的向我方发动挑战, 反被打的满地找牙。"
		end

		xmlTemplate = "<font color='0xFFFFFF'>" .. xmlTemplate .. "</font>"

		if infoType == 1 or infoType == 2 then
			xml = string.format(xmlTemplate, data.name, data.rank)
		elseif infoType == 3 or infoType == 4 then
			xml = string.format(xmlTemplate, data.name)
		end
	end
	return xml
end

function ListItem:invalidateData()
	local data = self:getItemData()
	if data then
		local infoType = tonumber(data.type)
		local isWin = infoType == 1 or infoType == 4
		self.lbl_record_time:setString(StringUtil.GetUnixTimestampChineseString(data.time))
		self.richTextControl:renderXml(self:getXMLInfo())
		self.richTextControl:setPositionY(- self.richTextControl:getContentSize().height)
		self.lbl_result_win:setVisible(isWin)
		self.lbl_result_failed:setVisible(not isWin)
		self.btn_counterattack:setVisible(not isWin)
	end
end

function ListItem:HideLine()
	self.img_outline:setVisible(false)
end

function ListItem:ShowLine()
	self.img_outline:setVisible(true)
end

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

return SubView_RecordList