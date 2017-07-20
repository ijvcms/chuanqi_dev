--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 09:31:16
--
local ELEMENT_SIZE = cc.size(78, 78)

local BagPage = class("BagPage", function()
	return display.newNode()
end)

function BagPage:ctor(param)
	param = param or {}
	self.column = param.colum or 5
	self.rows = param.rows or 4

	self.itemNums = self.column * self.rows
	local p_pageWidth = param.pageWidth or 400
	local p_pageHeight = param.pageHeight or 400
	self.pageSize =  cc.size(p_pageWidth, p_pageHeight)


	self.elementColumnGap = (self.pageSize.width - self.column * ELEMENT_SIZE.width) / self.column
	self.elementRowGap = (self.pageSize.height - self.rows * ELEMENT_SIZE.height) / self.rows
	self.layoutWidth = ELEMENT_SIZE.width + self.elementColumnGap
	self.layoutHeight = ELEMENT_SIZE.height + self.elementRowGap

	self:initialization()
end

function BagPage:initialization()
	self._pageIndex      = nil
	self._pageData       = nil
	self._onClickHandler = nil
	self._onClickLockedHandler = nil
	self._itemBgs        = {}
	self._itemLocks      = {}
	self._itemComponents = {}
	self._unLockNumber   = -1
	self._poolItemComponents = {}
	self._itemSelectVisible = false
	self._itemChooseEnabled = true

	self:setContentSize(self.pageSize.width, self.pageSize.height)
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
function BagPage:EveryCallBack(callback)
	if not callback then return end
	for _, v in ipairs(self._itemComponents) do
		callback(v, v:getData())
	end
end

function BagPage:SetPageItemsData(itemList)
	self._pageData = itemList
	self:invalidateData()
end

function BagPage:SetUnLockNumber(unLockNumber)
	if self._unLockNumber == unLockNumber then return end
	self._unLockNumber = unLockNumber
	self:invalidateUnLock()
end

function BagPage:SetItemsSelectVisible(visible)
	self._itemSelectVisible = visible
	for _, v in ipairs(self._itemComponents) do
		v:setCBVisible(visible)
	end
end

function BagPage:SetChooseEnabled(enabled)
	self._itemChooseEnabled = enabled
	if not self._itemChooseEnabled then
		self:SetSelectedBorderByItem(nil)
	end
end

function BagPage:ResetItemsSelectState()
	for _, v in ipairs(self._itemComponents) do
		v:setSelected(false)
	end
end

function BagPage:SelectItemByData(itemData)
	if not itemData then return end
	for _, v in ipairs(self._itemComponents) do
		if v:getData() == itemData then
			self:onClickItem(v)
			break
		end
	end
end

function BagPage:SetItemSelectState(itemData, isSelected)
	if not itemData then return end
	for _, v in ipairs(self._itemComponents) do
		if v:getData() == itemData then
			v:setSelected(isSelected)
			break
		end
	end
end

function BagPage:SetPageIndex(pageIndex)
	self._pageIndex = pageIndex
end

function BagPage:GetPageIndex()
	return self._pageIndex
end

function BagPage:SetOnItemClickHandler(handler)
	self._onClickHandler = handler
end

function BagPage:SetOnLockClickHandler(handler)
	self._onClickLockedHandler = handler
end

function BagPage:SetSelectedBorderByItem(item)
	self._selectedSprite:setVisible(item ~= nil)
	if item then
		self._selectedSprite:setPosition(item:getPosition())
	end
end

-- ====================================================================================
-- Private Methods
-- ------------------------------------------------------------------------------------

--
-- 初始化页面组件。
--
function BagPage:initPageComponents()
	for i = 1, self.itemNums do
		local itemBg = display.newSprite("#com_propBg1.png")
        self:setItemPosition(itemBg, i)
        self:addChild(itemBg)
        self._itemBgs[#self._itemBgs + 1] = itemBg
    end

    self.lockBgLayer = display.newNode()
    self:addChild(self.lockBgLayer, 200)

    self._selectedSprite = display.newSprite("#com_propFrameSel.png")
    self._selectedSprite:setVisible(false)
    self:addChild(self._selectedSprite, 500)
end

--
-- 页面的触摸时间处理方法。
--
function BagPage:onTouchHandler(event)
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
            if not self:handleTouchHasContain(self._itemComponents, nodeSpacePoint, handler(self, self.onClickItem)) then
            	self:handleTouchHasContain(self._itemLocks, nodeSpacePoint, handler(self, self.onClickLockItem))
            end
		end
	end
	return true
end

function BagPage:handleTouchHasContain(items, localPoint, handler)
	for _, v in ipairs(items) do
		local rect = cc.rect()
	    rect.x = v:getPositionX() - ELEMENT_SIZE.width / 2
	    rect.y = v:getPositionY() - ELEMENT_SIZE.height / 2
	    rect.width = ELEMENT_SIZE.width
	    rect.height = ELEMENT_SIZE.height
        if cc.rectContainsPoint(rect, localPoint) then
            handler(v)
            return true
        end
	end
    return false
end

--
-- 当一个子项被点击之后将会调用此方法。
--
function BagPage:onClickItem(item)
	item:onItemClick()

	if item:getCBVisible() then
		item:setSelected(not item:getSelected())
	end

	if self._onClickHandler then
		self._onClickHandler(item:getData(), item:getSelected())
	end

	if self._itemChooseEnabled then
		self:SetSelectedBorderByItem(item)
	end
end

--
-- 当一个锁定子项被点击之后将会调用此方法。
--
function BagPage:onClickLockItem(item)
	if self._onClickLockedHandler then
		--self._onClickLockedHandler()
	end
end

--
-- 标记数据位为失效状态，并刷新当前的页面元素。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
-- 此外，还需要一个失效管理器来机型集中散发事件及处理帧运算。
--
function BagPage:invalidateData()
	self:unscheduleUpdate()
	self.itemNumOfLoaded = 0
	self:scheduleUpdate()
end

function BagPage:update_()--每帧只加载5个
	local count = 0
	while  count < 5 do
		if self._pageData and  self.itemNumOfLoaded < self.itemNums then
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
-- 刷新解锁信息。
--
function BagPage:invalidateUnLock()
	self._itemLocks = {}
	self.lockBgLayer:removeAllChildren()
	local num = 0
	local w = 0
	local h = 0
	for k, v in ipairs(self._itemBgs) do
		if k > self._unLockNumber then
			local lockBg = display.newSprite("#com_picLockClose.png")
			lockBg:setPosition(v:getPosition())
			self.lockBgLayer:addChild(lockBg)
			self._itemLocks[#self._itemLocks + 1] = lockBg
			num = num + 1
			w = v:getContentSize().width
			h = v:getContentSize().height
		end
	end

 	self:initLockMask(num,w,h)
end

function BagPage:initLockMask(num,w,h)
	local info = BagManager:getInstance():getBagLock(self._pageIndex,num)
	--dump(info)
	local lastItem = nil
	for i=#info,1,-1 do
		local hh = (h+5)*(info[i].value/5)
		local item = self:createLockMask(info[i].lv,info[i].value,w,h):addTo(self.lockBgLayer)
		if lastItem ~= nil then
			item:setPosition((w+10)*4/2,lastItem:getPositionY() + hh/2 + hh/2+22)
		else
			item:setPosition((w+10)*4/2,hh/2+24)
		end
		lastItem = item
	end

end
--添加未开锁遮罩层
function BagPage:createLockMask(lv,num,w,h)

	--local bg = display.newScale9Sprite("#com_bghedi.png", 0, 0, cc.size((w+10)*5, (h+5)*(num/5)))
	local titleLab = display.newTTFLabel({text = "LV"..lv,
        size = 22})
            :align(display.CENTER,0,0)
           -- :addTo(bg)
    
    --bg:setPosition(bg:getContentSize().width/2,(h+10)*(num*2 - 1))
    --titleLab:setPosition(w/2,h/2)
    display.setLabelFilter(titleLab)
    return titleLab

end

--
-- 根据物品数据以及他所在的位置，在页面上生成一个新的元素显示在那个位置上。
--
function BagPage:showItem(itemData, index)
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
    -- MARK GUIDE DEMAND SETUP
    item:setupGuide()
    item:release()
    table.insert(self._itemComponents, index, item) -- 增加
end


--
-- 创建一个物品显示对象并返回。
--
function BagPage:createItemComponent()
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
function BagPage:setItemPosition(itemComponent, index)
	local xUnit = ((index - 1) % (self.column)) + 1
	local yUnit = self.rows - math.ceil(index / self.column) + 1

	local xx = (xUnit - 1) * self.layoutWidth + (self.layoutWidth / 2)
	local yy = (yUnit - 1) * self.layoutHeight  + (self.layoutHeight  / 2)
	itemComponent:setPosition(xx, yy)
end

function BagPage:Destory()
	self:removeAllItems()
	self:destoryInvalidateItems()
	self:removeAllChildren()
end

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Item component cache pool -- Start

--
-- 移除当前页面上的所有物品。
--
function BagPage:removeAllItems()
	local removeItems = self._itemComponents
	self._itemComponents = {}

	for _, v in ipairs(removeItems) do
		self:pushItemToPool(v)
	end
end

--
-- 销毁没有被使用到的物品组件。
--
function BagPage:destoryInvalidateItems()
	for _, v in pairs(self._poolItemComponents) do
		v:cleanup()
		v:release()
	end
	self._poolItemComponents = {}
end

--
-- 从缓存内获取一个没有被使用过的组件。
--
function BagPage:popItemFromPool()
	local count = #self._poolItemComponents
	if count > 0 then
		return table.remove(self._poolItemComponents, count)
	end
end

function BagPage:pushItemToPool(item)
	item:retain()
    item:clear()
	item:removeFromParent(false)
	table.insert(self._poolItemComponents, item)
end

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Item component cache pool -- End

return BagPage