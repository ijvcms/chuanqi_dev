--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-17 19:58:27
--
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local QualifyingStoreWin = class("QualifyingStoreWin", BaseView)

local ITEM_LAYOUT_FILE = "resui/item_qualifying_store_goods.ExportJson"
local ListItem = class("ListItem", function()
	return display.newNode()
end)

function QualifyingStoreWin:ctor(winTag, data, winconfig)
	QualifyingStoreWin.super.ctor(self, winTag, data, winconfig)
	self:initialization()
end

function QualifyingStoreWin:initialization()
	local loader = GameUILoaderUtils.new()
	self.loader = loader
	self.loader:AddUIEditorCache(ITEM_LAYOUT_FILE)

	self:initComponents()
	self:initListeners()
	self:buildGoodsList()

	GlobalController.qualifying:RefreshFame()
end

--
-- 初始化全局数据事件监听。
--
function QualifyingStoreWin:initListeners()
	-- 获取我在排位赛中的排名
	self:registerGlobalEventHandler(QualifyingEvent.VALUE_OF_FAME, function()
		self:invalidateFame()
	end)
end

--
-- 初始化当前窗口的所有组件。
--
function QualifyingStoreWin:initComponents()
	local win = cc.uiloader:seekNodeByName(self:getRoot(), "win")

	self.itemContainer  = cc.uiloader:seekNodeByName(win, "container_items")
	self.lbl_fame_value = cc.uiloader:seekNodeByName(win, "lbl_fame_value")
end

function QualifyingStoreWin:invalidateFame()
	local fame = GlobalController.qualifying:GetFame()
	self.lbl_fame_value:setString(fame)
end

function QualifyingStoreWin:buildGoodsList()
	-- -------------------------------------------
	local getListItem = function(cacheItems)
		local listItem = nil
		if cacheItems and #cacheItems > 0 then
			listItem = table.remove(cacheItems, #cacheItems)
		else
			local newLayoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
			listItem = ListItem.new(newLayoutNode)
			self.itemContainer:addChild(listItem)
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
		local ITEM_GAP = cc.size(37, 5)
		local ITEM_SIZE = cc.size(251, 164)
		local LIST_SIZE = cc.size(840, 434)
		local COUNT = #items
		local ROW_COUNT = 3

		for i = 1, COUNT do
			local rowIdx    = math.ceil(i / ROW_COUNT) - 1
			local columnIdx = ((i - 1) % ROW_COUNT)
			local posX = (ITEM_SIZE.width + ITEM_GAP.width) * columnIdx
			local posY = LIST_SIZE.height - (ITEM_SIZE.height + ITEM_GAP.height) * rowIdx - ITEM_SIZE.height
			local listItem = items[i]

			listItem:setPosition(posX, posY)
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

	local oldListItems   = self._itemList
	local goodsListData  = configHelper.getInstance():GetQualifyingStoreGoodsList()
	local newListItems   = buildItemsByData(goodsListData, oldListItems)

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._itemList = newListItems
end


--
-- 注册全局事件监听。
--
function QualifyingStoreWin:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function QualifyingStoreWin:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
	self._eventHandles = nil
end

--打开界面
function QualifyingStoreWin:open()
	self.super.open(self)
end


--清理界面
function QualifyingStoreWin:destory()

	self:removeAllEvents()
	self.super.destory(self)
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

	-- 物品项
	local container_item = cc.uiloader:seekNodeByName(itemUI, "container_item")
	local item_goods  = CommonItemCell.new()
	item_goods:setPosition(39, 39)
	container_item:addChild(item_goods)
	self.item_goods = item_goods

	self.lbl_goods_name         = cc.uiloader:seekNodeByName(itemUI, "lbl_goods_name")
	self.lbl_consume_fame_value = cc.uiloader:seekNodeByName(itemUI, "lbl_consume_fame_value")
	self.lbl_buy_limit_value    = cc.uiloader:seekNodeByName(itemUI, "lbl_buy_limit_value")
	self.btn_buy                = cc.uiloader:seekNodeByName(itemUI, "btn_buy")

	self.btn_buy:onButtonClicked(function()
		local data = self:getItemData()
		GlobalController.qualifying:ConvertGoods(data.storeid)
	end)
end

function ListItem:invalidateData()
	local data = self:getItemData()
	if data then
		self.item_goods:setData(data)
		self.lbl_goods_name:setString(data.goodsName)
		self.lbl_consume_fame_value:setString(data.fame)
		self.lbl_buy_limit_value:setString(data.limit)
	end
end

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

return QualifyingStoreWin