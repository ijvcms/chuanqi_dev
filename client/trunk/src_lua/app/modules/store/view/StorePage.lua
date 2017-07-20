-- --
-- -- Author: Alex mailto: liao131131@vip.qq.com
-- -- Date: 2015-11-30 09:31:16
-- --

-- local PAGE_SIZE = cc.size(530, 350)
-- local NUM_OF_COLUMN = 2
-- local NUM_OF_ROWS   = 3
-- local NUM_OF_ITEMS  = NUM_OF_COLUMN * NUM_OF_ROWS
-- local ELEMENT_SIZE = cc.size(261, 114)

-- local ELEMENT_COLUMN_GAP = (PAGE_SIZE.width - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
-- local ELEMENT_ROW_GAP = (PAGE_SIZE.height - NUM_OF_ROWS * ELEMENT_SIZE.height) / NUM_OF_ROWS

-- local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP
-- local LAYOUT_HEIGHT = ELEMENT_SIZE.height + ELEMENT_ROW_GAP


-- local StorePage = class("StorePage", function()
-- 	return display.newNode()
-- end)

-- local StoreItem = class("StoreItem", function()
-- 	return display.newNode()
-- end)

-- function StorePage:ctor()
-- 	self:initialization()
-- end

-- function StorePage:initialization()
-- 	self._pageIndex      = nil
-- 	self._pageData       = nil
-- 	self._onClickHandler = nil
-- 	self._itemComponents = {}
-- 	self._poolItemComponents = {}

-- 	self:setContentSize(PAGE_SIZE.width, PAGE_SIZE.height)
-- 	self:setTouchEnabled(true)
-- 	self:setTouchSwallowEnabled(false)
-- 	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouchHandler))
-- 	self:initPageComponents()
--     self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
-- 			self:update_(...)
-- 		end)
-- 	self:scheduleUpdate()
-- 	-- test
-- 	-- self:SetPageItemsData(BagManager:getInstance().bagInfo:getTotalList())
-- end

-- -- ====================================================================================
-- -- Public Methods
-- -- ------------------------------------------------------------------------------------

-- function StorePage:SetPageItemsData(itemList)
-- 	self._pageData = itemList
-- 	self:invalidateData()
-- end

-- function StorePage:SetPageIndex(pageIndex)
-- 	self._pageIndex = pageIndex
-- end

-- function StorePage:GetPageIndex()
-- 	return self._pageIndex
-- end

-- function StorePage:SetOnItemClickHandler(handler)
-- 	self._onClickHandler = handler
-- end

-- -- ====================================================================================
-- -- Private Methods
-- -- ------------------------------------------------------------------------------------

-- --
-- -- 初始化页面组件。
-- --
-- function StorePage:initPageComponents()
-- end


-- --
-- -- 页面的触摸时间处理方法。
-- --
-- function StorePage:onTouchHandler(event)
-- 	if "began" == event.name then
-- 		self.hasMoving = false
-- 	elseif "moved" == event.name then
-- 		--
-- 		-- 拖动距离大于一个安全阀值之后就不是点击状态了。
-- 		--
-- 		local distance = math.abs(event.x - event.prevX)
-- 		if distance > 5 then
-- 			self.hasMoving = true
-- 		end
-- 	elseif "ended" == event.name then
-- 		if not self.hasMoving then
-- 			local nodeSpacePoint = self:convertToNodeSpace(event)
--             -- print("--------------------------------x:"..nodeSpacePoint.x .. "\ty:" .. nodeSpacePoint.y)
--             local itemsCount = #self._itemComponents
--             for i = 1, itemsCount do
--                 local item = self._itemComponents[i]
--                 local rect = cc.rect()
--                 rect.x = item:getPositionX()
--                 rect.y = item:getPositionY()
--                 rect.width = ELEMENT_SIZE.width
--                 rect.height = ELEMENT_SIZE.height
--                 if cc.rectContainsPoint(rect, nodeSpacePoint) then
--                     self:onClickItem(item)
--                     break
--                 end
--             end
-- 		end
-- 	end
-- 	return true
-- end

-- --
-- -- 当一个子项被点击之后将会调用此方法。
-- --
-- function StorePage:onClickItem(item)
-- 	if self._onClickHandler then
-- 		self._onClickHandler(item:getData())
-- 	end
-- end

-- --
-- -- 标记数据位为失效状态，并刷新当前的页面元素。
-- -- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- -- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
-- -- 此外，还需要一个失效管理器来机型集中散发事件及处理帧运算。
-- --
-- function StorePage:invalidateData()
-- 	self:removeAllItems()
-- 	self.itemNumOfLoaded = 0
-- end

-- function StorePage::update_()--每帧只加载一个
-- 	if self._pageData and  self.itemNumOfLoaded < NUM_OF_ITEMS then
-- 		self.itemNumOfLoaded = self.itemNumOfLoaded + 1
-- 		local itemData = self._pageData[self.itemNumOfLoaded]
-- 		if itemData then
-- 			self:showItem(itemData, self.itemNumOfLoaded)
-- 		end
-- 	end
-- end

-- --
-- -- 根据物品数据以及他所在的位置，在页面上生成一个新的元素显示在那个位置上。
-- --
-- function StorePage:showItem(itemData, index)
-- 	local item = self:createItemComponent()
--     self:setItemPosition(item, index)
--     self:addChild(item)
--     item:release()
--     item:setData(itemData)

--     self._itemComponents[index] = item
-- end

-- --
-- -- 创建一个物品显示对象并返回。
-- --
-- function StorePage:createItemComponent()
-- 	local item = self:popItemFromPool()

-- 	-- 没有缓存使用新的组件。
-- 	if not item then
-- 		item = StoreItem.new()
-- 		item:retain()
-- 		item:setTouchCaptureEnabled(true)
-- 	end
-- 	return item
-- end

-- --
-- -- 根据索引设置一个物品组件在本页面中的位置。
-- --
-- function StorePage:setItemPosition(itemComponent, index)
-- 	local xUnit = ((index - 1) % (NUM_OF_COLUMN))
-- 	local yUnit = NUM_OF_ROWS - math.ceil(index / NUM_OF_COLUMN)
-- 	local xx = xUnit * LAYOUT_WIDTH
-- 	local yy = yUnit * LAYOUT_HEIGHT
-- 	itemComponent:setPositionX(xx)
-- 	itemComponent:setPositionY(yy)
-- end

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Item component cache pool -- Start

-- --
-- -- 移除当前页面上的所有物品。
-- --
-- function StorePage:removeAllItems()
-- 	local removeItems = self._itemComponents
-- 	self._itemComponents = {}

-- 	for k, v in ipairs(removeItems) do
-- 		v:retain()
-- 		v:clear()
-- 		v:removeFromParent(false)
-- 	end

-- 	self._poolItemComponents = removeItems
-- end

-- --
-- -- 销毁没有被使用到的物品组件。
-- --
-- function StorePage:destoryInvalidateItems()
-- 	for _, v in pairs(self._poolItemComponents) do
-- 		v:onCleanup()
-- 		v:release()
-- 	end
-- 	self._poolItemComponents = {}
-- end

-- --
-- -- 从缓存内获取一个没有被使用过的组件。
-- --
-- function StorePage:popItemFromPool()
-- 	local count = #self._poolItemComponents
-- 	if count > 0 then
-- 		return table.remove(self._poolItemComponents, count)
-- 	end
-- end

-- -- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Item component cache pool -- End

-- -- ---------------------------------------------------------------------------------------------------
-- -- StoreItem Imp
-- -- ---------------------------------------------------------------------------------------------------
-- function StoreItem:ctor()
-- 	self:initialization()
-- end

-- function StoreItem:initialization()
-- 	self:initComponents()
-- end

-- function StoreItem:initComponents()
-- 	local sp = display.newSprite("#4.png")
--     sp:setAnchorPoint(0,0)

--     local sp1 = display.newSprite("#3.png")
-- 	sp1:setPosition(49,57)
--     sp:addChild(sp1)
--     --图标
--     local commonItem = CommonItemCell.new()
--     commonItem:setPosition(49,57)
--     sp:addChild(commonItem)

--     --名字
--     local nameLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
--     nameLabel:setColor(TextColor.TITLE)
--     nameLabel:setAnchorPoint(0,0.5)
--     nameLabel:setPosition(98,78)

--     display.setLabelFilter(nameLabel)
--     --"售价:"
--     local sjLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
--     sjLabel:setColor(TextColor.TEXT_W)
--     sjLabel:setString("售价:")
--     sjLabel:setAnchorPoint(0,0.5)
--     sjLabel:setPosition(98,36)
--     display.setLabelFilter(sjLabel)
--     --价格
--     local jgLabel = display.newTTFLabel({font = "Marker Felt"}):addTo(sp,15)
--     jgLabel:setColor(TextColor.TEXT_Y)
--     jgLabel:setAnchorPoint(0,0.5)
--     jgLabel:setPosition(sjLabel:getPositionX()+sjLabel:getContentSize().width,36)
--     display.setLabelFilter(jgLabel)
--     --代表是何种金币的图标
--     local coinIcon = display.newSprite():addTo(sp,15)
--     coinIcon:setAnchorPoint(0,0.5)

--     self._goodsItem  = commonItem
--     self._goodsName  = nameLabel
--     self._goodsPrice = jgLabel
--     self._coinIcon   = coinIcon

--     self:addChild(sp)
-- end

-- --此次现在不会自动调用
-- function StoreItem:onCleanup()
-- end

-- function StoreItem:clear()
-- 	self._goodsItem:clear()
-- end

-- function StoreItem:setData(data)
-- 	self._data = data
-- 	self:invalidateData()
-- end

-- function StoreItem:getData()
-- 	return self._data
-- end

-- function StoreItem:invalidateData()
-- 	local itemData = self._data
-- 	if not itemData then return end

-- 	self._goodsItem:setData(itemData)
-- 	self._goodsName:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))

-- 	--根据品质改变名字颜色
--     local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
--     if quality then
--         local color
--         if quality == 1 then            --白
--             color = TextColor.TEXT_W
--         elseif quality == 2 then        --绿
--             color = TextColor.TEXT_G
--         elseif quality == 3 then        --蓝
--             color = TextColor.ITEM_B
--         elseif quality == 4 then        --紫
--             color = TextColor.ITEM_P
--         elseif quality == 5 then        --橙
--             color = TextColor.TEXT_O
--         elseif quality == 6 then        --红
-- 		    color = TextColor.TEXT_R
--         end 
--         if color then
--             self._goodsName:setTextColor(color)
--         end
--     end

--     self._goodsPrice:setString(itemData.price)

--     self._coinIcon:setSpriteFrame("com_coin"..itemData.curr_type..".png")
--     self._coinIcon:setPosition(self._goodsPrice:getPositionX()+self._goodsPrice:getContentSize().width + 2, 36)
-- end

-- return StorePage