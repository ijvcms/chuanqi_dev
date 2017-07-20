--
-- Author: Yi hanneng
-- Date: 2016-04-27 10:05:07
--
local ActivityData = import("..model.ActivityData")
local ActivityItem = import(".ActivityItem")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local ActivityView = class("ActivityView", BaseView)

local ITEM_LAYOUT_FILE = "resui/ActivityViewItem.ExportJson"

ActivityView.TAB_ACT_DAY   = 1 -- 每日活动
ActivityView.TAB_ACT_TIME  = 2 -- 限时活动
ActivityView.TAB_ACT_OTHER = 3 -- 其他活动

ActivityName = {"日常活动","限时活动","竞技活动"}

function ActivityView:ctor(winTag, data, winconfig)
	ActivityView.super.ctor(self, winTag, data, winconfig)
	self.data = data
	self:initialization()
end

function ActivityView:initialization()
 
	self:initComponents()
	if self.data then
		self:setViewByType(self.data.type) 
	end
	
end

--
-- 初始化当前窗口的所有组件。
--
function ActivityView:initComponents()
	local root = self:getRoot()
	local win = cc.uiloader:seekNodeByName(root, "win")
	self.mainLayer = cc.uiloader:seekNodeByName(root, "mainLayer")
	--dump(self.mainLayer:getContentSize()) 
end
 
function ActivityView:onItemClick(item)
	local data    = item:getData()
	 
	local func_id = data:getFunctionId()
	local skip = data:hasSkip()

	if skip and skip ~= "" then
		GlobalEventSystem:dispatchEvent(DailyTaskEvent.TASK_JUMP,{win = skip})
	else
		FunctionOpenManager:gotoFunctionById(func_id)
	end
	
	-- GUIDE CONFIRM
	if func_id == FUNC_OPID.OPEN_QUALIFYING_WIN then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_QUALIFYING)
	end

	if func_id == FUNC_OPID.GOTO_FEAT_NPC then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_FEAT_TASK)
	end

	if func_id == FUNC_OPID.OPEN_WORLD_BOSS_WIN then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_WORLD_BOSS)
	end

	if func_id == FUNC_OPID.GOTO_DAILY_TASK_NPC then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_DAILY_TASK)
	end
 
 	
end

function ActivityView:setViewByType(type)
	if self._currentIndex == type then return end
	self._currentIndex = type
	self:invalidateItems()
	self:invalidateItemProgress()

	-- GUIDE CONFIRM
	if self._currentIndex == 2 then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_TAB_TIME)
	end
end

function ActivityView:convertIndexToType(index)
	return index
end

function ActivityView:invalidateItems()
	local itemType = self:convertIndexToType(self._currentIndex)
	local items = configHelper:getActivitysByType(itemType)

	self:buildActivityItems(items)
end

function ActivityView:invalidateItemProgress()
	if self._progressInfo then
		for _, v in ipairs(self._progressInfo) do
			local item = self:getItemByActivityId(v.activity_id)
			if item then
				item:setProgress(v.now_num, v.max_num)
			end
		end
	else
		GlobalController.activity:requestActivityInfo()
	end
end

function ActivityView:buildActivityItems(activitys)
	if self._items == nil then
		self._items = {1, 2, 3, 4, 5, 6,7,8}
		for i = 1,8 do
			local item = ActivityItem.new()--layoutNode
		    item:setOnItemClickeHandler(handler(self, self.onItemClick))
		    self:layoutItem(item, i)
		    self.mainLayer:addChild(item)
		    self._items[i] = item
		end
	end
	local pos = 1
	for k, v in ipairs(activitys) do
	     --local layoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
	    local item = self._items[pos]
	    local itemData = ActivityData.new(v)
		item:setData(itemData)
	    item:setVisible(true)
	    pos = pos + 1
    end
    for i = pos, 8 do
    	local item = self._items[i]
    	item:setVisible(false)
    end
end

function ActivityView:getItemByActivityId(id)
	for _, v in ipairs(self._items) do
		if v:isVisible() and v:getData():getId() == id then
			return v
		end
	end
end


local PAGE_SIZE = cc.size(870, 490)
local NUM_OF_COLUMN = 4
local NUM_OF_ROWS   = 2
local NUM_OF_ITEMS  = NUM_OF_COLUMN * NUM_OF_ROWS
local ELEMENT_SIZE = cc.size(200, 240)

local ELEMENT_COLUMN_GAP = (PAGE_SIZE.width - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
local ELEMENT_ROW_GAP = (PAGE_SIZE.height - NUM_OF_ROWS * ELEMENT_SIZE.height) / NUM_OF_ROWS

local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP
local LAYOUT_HEIGHT = ELEMENT_SIZE.height + ELEMENT_ROW_GAP

function ActivityView:layoutItem(layoutNode, index)
	local xUnit = (index - 1) % (NUM_OF_COLUMN)
	local yUnit = NUM_OF_ROWS - math.ceil(index / NUM_OF_COLUMN)

	local xx = xUnit * LAYOUT_WIDTH + ELEMENT_COLUMN_GAP / 2
	local yy = yUnit * LAYOUT_HEIGHT + ELEMENT_ROW_GAP / 2
	layoutNode:setPosition(xx, yy)
end

--
-- 注册全局事件监听。
--
function ActivityView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function ActivityView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end


--打开界面
function ActivityView:open()
	-- 刷新进度
	self:registerGlobalEventHandler(ActivityEvent.RCV_ACTIVITY_INFO, function(event)
		self._progressInfo = event.data
		self:invalidateItemProgress()
	end)
end

--关闭界面
function ActivityView:close()
	self.super.close(self)
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end

	self:removeAllEvents()
end

--清理界面
function ActivityView:destory()
	self:close()
	ActivityView.super.destory(self)
end

return ActivityView