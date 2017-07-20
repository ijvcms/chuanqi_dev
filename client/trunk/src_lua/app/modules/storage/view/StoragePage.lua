--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 09:31:16
--

local PAGE_SIZE = cc.size(420, 370)
local NUM_OF_COLUMN = 5
local NUM_OF_ROWS   = 4
local NUM_OF_ITEMS  = NUM_OF_COLUMN * NUM_OF_ROWS
local ELEMENT_SIZE = cc.size(78, 78)

local ELEMENT_COLUMN_GAP = (PAGE_SIZE.width - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
local ELEMENT_ROW_GAP = (PAGE_SIZE.height - NUM_OF_ROWS * ELEMENT_SIZE.height) / NUM_OF_ROWS

local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP
local LAYOUT_HEIGHT = ELEMENT_SIZE.height + ELEMENT_ROW_GAP


local StoragePage = class("StoragePage", function()
	return display.newNode()
end)

function StoragePage:ctor()
	self:initialization()
end

function StoragePage:initialization()
	self._pageIndex      = nil
	self._pageData       = nil
	self._onClickHandler = nil
	self._itemComponents = {}
	self._poolItemComponents = {}

	self:setContentSize(PAGE_SIZE.width, PAGE_SIZE.height)
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouchHandler))
	self:initPageComponents()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
		self:update_(...)
	end)
	self:scheduleUpdate()
	-- test
	-- self:SetPageItemsData(BagManager:getInstance().bagInfo:getTotalList())
end

-- ====================================================================================
-- Public Methods
-- ------------------------------------------------------------------------------------

function StoragePage:SetPageItemsData(itemList)
	self._pageData = itemList
	self:invalidateData()
end

function StoragePage:SetPageIndex(pageIndex)
	self._pageIndex = pageIndex
end

function StoragePage:GetPageIndex()
	return self._pageIndex
end

function StoragePage:SetOnItemClickHandler(handler)
	self._onClickHandler = handler
end

-- ====================================================================================
-- Private Methods
-- ------------------------------------------------------------------------------------

--
-- 初始化页面组件。
--
function StoragePage:initPageComponents()
	for i = 1, NUM_OF_ITEMS do
		local itemBg = display.newSprite("#com_propBg1.png")
        self:setItemPosition(itemBg, i)
        self:addChild(itemBg)
    end
end

--
-- 页面的触摸时间处理方法。
--
function StoragePage:onTouchHandler(event)
	if "began" == event.name then
		self.hasMoving = false
	elseif "moved" == event.name then
		--
		-- 拖动距离大于一个安全阀值之后就不是点击状态了。
		--
		local distance = math.abs(event.x - event.prevX)
		if distance > 5 then
			self.hasMoving = true
		end
	elseif "ended" == event.name then
		if not self.hasMoving then
			local nodeSpacePoint = self:convertToNodeSpace(event)
            -- print("--------------------------------x:"..nodeSpacePoint.x .. "\ty:" .. nodeSpacePoint.y)
            local itemsCount = #self._itemComponents
            for i = 1, itemsCount do
                local item = self._itemComponents[i]
                local rect = cc.rect()
                rect.x = item:getPositionX() - ELEMENT_SIZE.width / 2
                rect.y = item:getPositionY() - ELEMENT_SIZE.height / 2
                rect.width = ELEMENT_SIZE.width
                rect.height = ELEMENT_SIZE.height
                if cc.rectContainsPoint(rect, nodeSpacePoint) then
                    self:onClickItem(item)
                    break
                end
            end
		end
	end
	return true
end

--
-- 当一个子项被点击之后将会调用此方法。
--
function StoragePage:onClickItem(item)
	if self._onClickHandler then
		self._onClickHandler(item:getData())
	end
end

--
-- 标记数据位为失效状态，并刷新当前的页面元素。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
-- 此外，还需要一个失效管理器来机型集中散发事件及处理帧运算。
--
function StoragePage:invalidateData()
	self:unscheduleUpdate()
	self.itemNumOfLoaded = 0
	self:scheduleUpdate()
end

function StoragePage:update_()--每帧只加载5个
	local count = 0
	while  count < 5 do
		if self._pageData and  self.itemNumOfLoaded < NUM_OF_ITEMS then
		    self.itemNumOfLoaded = self.itemNumOfLoaded + 1
		    local itemData = self._pageData[self.itemNumOfLoaded]
		    if itemData then
			    self:showItem(itemData, self.itemNumOfLoaded)	
		    end
		else
			while #self._itemComponents > #self._pageData do
				local oldItem = table.remove(self._itemComponents, #self._itemComponents)
				if oldItem then
					self:pushItemToPool(oldItem)
				end
			end
			self:unscheduleUpdate()
			break
	    end 
		count  = count + 1
	end
	
end

--
-- 根据物品数据以及他所在的位置，在页面上生成一个新的元素显示在那个位置上。
--
function StoragePage:showItem(itemData, index)
	local item
	for i = index, #self._itemComponents do
		local item = self._itemComponents[i]
		local oldData = item:getData()
		if oldData.id == itemData.id then--更新旧数据
			if i ~= index then -- 前面有物品减少
				while i ~= index do
					i = i - 1
					local oldItem = table.remove(self._itemComponents, i)
					self:pushItemToPool(oldItem)
				end
			end
			self:setItemPosition(item, index)
			item:setData(itemData)
            item:checkNumAndArrow()
            item:checkIsEquiped()
            item:setCBVisible(self._itemSelectVisible)
            item:setTouchCaptureEnabled(false)
            item:setItemClickFunc(function()end)
			return
		end
	end
	item = self:createItemComponent()
    self:setItemPosition(item, index)
    item:setData(itemData)
    item:checkNumAndArrow()
    item:checkIsEquiped()
    item:setCBVisible(self._itemSelectVisible)
    item:setTouchCaptureEnabled(false)
    item:setItemClickFunc(function()end) -- set null func becase will alert the goods info box.
    self:addChild(item)
    item:release()
    table.insert(self._itemComponents, index, item) -- 增加
end

--
-- 创建一个物品显示对象并返回。
--
function StoragePage:createItemComponent()
	local item = self:popItemFromPool()

	-- 没有缓存使用新的组件。
	if not item then
		item = CommonItemCell.new()
		item:retain()
	end
	return item
end

--
-- 根据索引设置一个物品组件在本页面中的位置。
--
function StoragePage:setItemPosition(itemComponent, index)
	local xUnit = ((index - 1) % (NUM_OF_COLUMN)) + 1
	local yUnit = NUM_OF_ROWS - math.ceil(index / NUM_OF_COLUMN) + 1

	local xx = (xUnit - 1) * LAYOUT_WIDTH + (LAYOUT_WIDTH / 2)
	local yy = (yUnit - 1) * LAYOUT_HEIGHT + (LAYOUT_HEIGHT / 2)
	itemComponent:setPositionX(xx)
	itemComponent:setPositionY(yy)
end

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Item component cache pool -- Start

--
-- 移除当前页面上的所有物品。
--
function StoragePage:removeAllItems()
	local removeItems = self._itemComponents
	self._itemComponents = {}

	for _, v in ipairs(removeItems) do
		self:pushItemToPool(v)
	end
end

--
-- 销毁没有被使用到的物品组件。
--
function StoragePage:destoryInvalidateItems()
	for _, v in pairs(self._poolItemComponents) do
		v:cleanup()
		v:release()
	end
	self._poolItemComponents = {}
end

--
-- 从缓存内获取一个没有被使用过的组件。
--
function StoragePage:popItemFromPool()
	local count = #self._poolItemComponents
	if count > 0 then
		return table.remove(self._poolItemComponents, count)
	end
end

function StoragePage:pushItemToPool(item)
	item:retain()
    item:clear()
	item:removeFromParent(false)
	table.insert(self._poolItemComponents, item)
end

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Item component cache pool -- End

return StoragePage