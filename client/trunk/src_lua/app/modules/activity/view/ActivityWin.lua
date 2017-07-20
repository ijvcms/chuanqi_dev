--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-26 14:13:03
--

local ActivityData = import("..model.ActivityData")
local ActivityItem = import(".ActivityItem")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local ActivityWin = class("ActivityWin", BaseView)

ActivityWin.TAB_ACT_DAY   = 1 -- 每日活动
ActivityWin.TAB_ACT_TIME  = 2 -- 限时活动
ActivityWin.TAB_ACT_OTHER = 3 -- 其他活动

function ActivityWin:ctor(winTag, data, winconfig)
	ActivityWin.super.ctor(self, winTag, data, winconfig)
	
	local root = self:getRoot()
	root:setPosition((display.width-960)/2,(display.height-640)/2)
	self:creatPillar()

	self:initialization()
end

function ActivityWin:initialization()

	self:initComponents()
	self:selecteTabViewByIndex(ActivityWin.TAB_ACT_DAY)
end

--
-- 初始化当前窗口的所有组件。
--
function ActivityWin:initComponents()
	local root = self:getRoot()
	local win = cc.uiloader:seekNodeByName(root, "win")

	self:initTabButtons(win)

	self.rightlayer = display.newNode()
	self.rightlayer:setPosition(288, 30)
	win:addChild(self.rightlayer)

	--关闭窗口按钮
    self.closeBtn = cc.uiloader:seekNodeByName(win, "close")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)
end

function ActivityWin:initTabButtons(win)
	local TabButtonNames = {
		[ActivityWin.TAB_ACT_DAY]   = "Image_2",
		[ActivityWin.TAB_ACT_TIME]  = "Image_2_0",
		[ActivityWin.TAB_ACT_OTHER] = "Image_2_0_1",
	}

	local tabButtons = {}
	for k, v in ipairs(TabButtonNames) do
		local button = cc.uiloader:seekNodeByName(win, v)
		if v == TabButtonNames[ActivityWin.TAB_ACT_DAY] then --日常任务
			local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVITY_DAILY,button,20,80)
		elseif v == TabButtonNames[ActivityWin.TAB_ACT_TIME] then --限时活动
			local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVITY_TIMEACTIVITY,button,20,80)
		end
		button.selectSkin = cc.uiloader:seekNodeByName(button, "Image_9")
		button:setTouchEnabled(true)
		button:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if "ended" == event.name then
				SoundManager:playClickSound()
				self:selecteTabViewByIndex(k)
			end
			return true
		end)
		tabButtons[k] = button
	end
	self._tabButtons = tabButtons
end

function ActivityWin:onItemClick(item)
	local data    = item:getData()
	local func_id = data:getFunctionId()
	FunctionOpenManager:gotoFunctionById(func_id)
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

function ActivityWin:selecteTabViewByIndex(index)
	if self._currentIndex == index then return end
	for k, v in pairs(self._tabButtons) do
		v.selectSkin:setVisible(k == index)
	end

	self._currentIndex = index
	self:invalidateItems()
	self:invalidateItemProgress()

	-- GUIDE CONFIRM
	if self._currentIndex == 2 then
		GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_ACT_TAB_TIME)
	end
end

function ActivityWin:convertIndexToType(index)
	return index
end

function ActivityWin:invalidateItems()
	local itemType = self:convertIndexToType(self._currentIndex)
	local items = configHelper:getActivitysByType(itemType)

	self:buildActivityItems(items)
end

function ActivityWin:invalidateItemProgress()
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

function ActivityWin:buildActivityItems(activitys)
	if self._items == nil then
		self._items = {1, 2, 3, 4, 5, 6}
		for i = 1,6 do
			local item = ActivityItem.new()--layoutNode
		    item:setOnItemClickeHandler(handler(self, self.onItemClick))
		    self:layoutItem(item, i)
		    self.rightlayer:addChild(item)
		    self._items[i] = item
		end
	end
	local pos = 1
	for k, v in ipairs(activitys) do
	    local item = self._items[pos]
	    local itemData = ActivityData.new(v)
		item:setData(itemData)
	    item:setVisible(true)
	    pos = pos + 1
    end
    for i = pos, 6 do
    	local item = self._items[i]
    	item:setVisible(false)
    end
end

function ActivityWin:getItemByActivityId(id)
	for _, v in ipairs(self._items) do
		if v:isVisible() and v:getData():getId() == id then
			return v
		end
	end
end


local PAGE_SIZE = cc.size(643, 529)
local NUM_OF_COLUMN = 3
local NUM_OF_ROWS   = 2
local NUM_OF_ITEMS  = NUM_OF_COLUMN * NUM_OF_ROWS
local ELEMENT_SIZE = cc.size(200, 253)

local ELEMENT_COLUMN_GAP = (PAGE_SIZE.width - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
local ELEMENT_ROW_GAP = (PAGE_SIZE.height - NUM_OF_ROWS * ELEMENT_SIZE.height) / NUM_OF_ROWS

local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP
local LAYOUT_HEIGHT = ELEMENT_SIZE.height + ELEMENT_ROW_GAP

function ActivityWin:layoutItem(layoutNode, index)
	local xUnit = (index - 1) % (NUM_OF_COLUMN)
	local yUnit = NUM_OF_ROWS - math.ceil(index / NUM_OF_COLUMN)

	local xx = xUnit * LAYOUT_WIDTH + ELEMENT_COLUMN_GAP / 2
	local yy = yUnit * LAYOUT_HEIGHT + ELEMENT_ROW_GAP / 2
	layoutNode:setPosition(xx, yy)
end

--
-- 注册全局事件监听。
--
function ActivityWin:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function ActivityWin:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end


--打开界面
function ActivityWin:open()
	-- 刷新进度
	self:registerGlobalEventHandler(ActivityEvent.RCV_ACTIVITY_INFO, function(event)
		self._progressInfo = event.data
		self:invalidateItemProgress()
	end)
end

--关闭界面
function ActivityWin:close()
	self.super.close(self)
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end

	self:removeAllEvents()
end

--清理界面
function ActivityWin:destory()
	self:close()
	ActivityWin.super.destory(self)
end

return ActivityWin