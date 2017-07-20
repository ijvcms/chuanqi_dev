--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-25 15:42:27
--

local TopNavigationItem = import(".TopNavigationItem")
local TopNavigationView = class("TopNavigationView", function()
	return display.newNode()
end)

local ITEM_SIZE = cc.size(70, 70)

function TopNavigationView:ctor()
	self:initialization()
end

function TopNavigationView:initialization()
	self._offsetPoint = cc.p(164, 0)
	self._maxWidth = display.width * .5
	self._gapSize = cc.size(3, 0)
	self._items = nil
	self._isHide = false

	self:initComponents()
	self:initListeners()
	self:invalidateFunctions()
end

function TopNavigationView:initComponents()
	local edgeButton = display.newSprite("#scene/scene_topMinBtn.png")
	edgeButton:setAnchorPoint(cc.p(.5, 1))
	edgeButton:setTouchEnabled(true)
	edgeButton:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "ended" then
			edgeButton:setColor(cc.c3b(255, 255, 255))
			if self._isHide then self:show() else self:hide() end
		elseif event.name == "began" then
			edgeButton:setColor(cc.c3b(128, 128, 128))
		end
		return true
	end)
	edgeButton:setScaleX(-1)
	self._edgeButton = edgeButton
	self._itemContainer = display.newNode()
	self._itemContainer:setCascadeOpacityEnabled(true)
	self:addChild(self._itemContainer)
	self:addChild(edgeButton)
end

function TopNavigationView:initListeners()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
    	if event.name == "cleanup" then
    		if self.func_handle then
    			GlobalEventSystem:removeEventListenerByHandle(self.func_handle)
    			GlobalEventSystem:removeEventListenerByHandle(self.show_handle)
    			GlobalEventSystem:removeEventListenerByHandle(self.hide_handle)

    			self.func_handle = nil
    			self.show_handle = nil
    			self.hide_handle = nil
    		end
    	end
    end)

	self.func_handle = GlobalEventSystem:addEventListener(GlobalEvent.UPDATE_FUNCTION_OPEN, function()
		self:invalidateFunctions()
	end)

	self.show_handle = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_TOP_NAV_BAR, function()
		if self._isHide then
			self:show()
		end
	end)

	self.hide_handle = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_TOP_NAV_BAR, function()
		if not self._isHide then
			self:hide()
		end
	end)
end

function TopNavigationView:invalidateFunctions()
	self._itemContainer:removeAllChildren()
	self._items = {}
	local menuItems = configHelper:getTopNavigationMenus()
	local itemHandler = handler(self, self.onItemClick)
	for _, v in ipairs(menuItems) do
		if FunctionOpenManager:getFunctionOpenById(v.function_id) then
			local item = TopNavigationItem.new()
			item:setData(v)
			item:setOnItemClickeHandler(itemHandler)
			self._itemContainer:addChild(item)
			table.insert(self._items, item)
		end
	end
	self:invalidateLayout()
end

function TopNavigationView:hideBtnExceptIdList(arr)
	for k,v in pairs(self._items) do
		v:setVisible(false)
		for i=1,#arr do
			if arr[i] == v._data.function_id then
				v:setVisible(true)
			end
		end
	end
end

function TopNavigationView:showAllBtnList()
	for k,v in pairs(self._items) do
		if v:isVisible() == false then
			v:setVisible(true)
		end
	end
end


function TopNavigationView:setOffsetPoint(offsetPoint)
	self._offsetPoint = offsetPoint or self._offsetPoint
	self:invalidateLayout()
end

-- function TopNavigationView:setMaxWidth(maxWidth)
-- 	if self._maxWidth == maxWidth then return end
-- 	self._maxWidth = maxWidth or self._maxWidth
-- 	self:invalidateLayout()
-- end

function TopNavigationView:setGapSize(gapSize)
	self._gapSize = gapSize or self._gapSize
	self:invalidateLayout()
end

function TopNavigationView:getItemSize()
	return cc.size(ITEM_SIZE.width + self._gapSize.width,
		ITEM_SIZE.height + self._gapSize.height)
end

function TopNavigationView:setBtnVisible(b)
	if b == false then
		self._edgeButton:setScaleX(1)
		self._isHide = true
		self._itemContainer:stopAllActions()
		self._itemContainer:setPosition(self._maxWidth,0)
		self._itemContainer:setVisible(false)
		if self.setHuoLongTips  then
			self.setHuoLongTips:setVisible(self._isHide)
		end
	else
		self._edgeButton:setScaleX(-1)
		self._isHide = false
		if self.setHuoLongTips  then
			self.setHuoLongTips:setVisible(self._isHide)
		end
		self._itemContainer:stopAllActions()
		self._itemContainer:setPosition(0,0)
		self._itemContainer:setOpacity(255)
		self._itemContainer:setVisible(true)
	end

	-- 跨服幻境之城
	if self.dreamlandTipsView then
		self.dreamlandTipsView:setVisible(not b)
	end

end

function TopNavigationView:setHuoLongTipsView(view)
	self.setHuoLongTips = view
end

-- 跨服幻境之城
function TopNavigationView:setDreamlandTipsView(view)
	self.dreamlandTipsView = view
end

function TopNavigationView:getIsHide()
	return self._isHide
end

function TopNavigationView:show()
	self._edgeButton:setScaleX(-1)
	self._isHide = false
	self._itemContainer:setVisible(true)
	self._itemContainer:stopAllActions()
	transition.moveTo(self._itemContainer, {x = 0, time = .3}) --easing = "backOut"
	transition.fadeIn(self._itemContainer, {time = .3})
	if self.setHuoLongTips  then
		self.setHuoLongTips:setVisible(self._isHide)
	end

	-- 跨服幻境之城
	if self.dreamlandTipsView then
		self.dreamlandTipsView:setVisible(false)
	end
end

function TopNavigationView:hide()
	self._edgeButton:setScaleX(1)
	self._isHide = true
	self._itemContainer:stopAllActions()
	transition.moveTo(self._itemContainer, {x = self._maxWidth, time = .3, onComplete = function()
		self._itemContainer:setVisible(false)
	end}) --easing = "backIn"

	transition.fadeOut(self._itemContainer, {time = .3})
	if self.setHuoLongTips  then
		self.setHuoLongTips:setVisible(self._isHide)
	end

	-- 跨服幻境之城
	if self.dreamlandTipsView then
		self.dreamlandTipsView:setVisible(true)
	end
end

function TopNavigationView:onItemClick(itemData)
	local func_id = itemData.function_id
	if func_id == 0 then
		GlobalMessage:show("该功能未开放！")
		return
	end

	if func_id == "debug" then
		require("app.modules.guide.GuideTest"):new():Test()
		return
	end
	FunctionOpenManager:gotoFunctionById(func_id)
end

function TopNavigationView:invalidateLayout()
	self._edgeButton:setPosition(
		-(self._offsetPoint.x - self._edgeButton:getContentSize().width * 0.5)+10,
		-self._offsetPoint.y-6)

	local positions = self:measureItemsPosition(self._items)
	for k, v in ipairs(self._items) do
		local pos = positions[k]
		v:setPosition(pos.x, pos.y)
	end
end

function TopNavigationView:measureItemsPosition(items)
	local totalModX = {}

	local positions = {}
	local itemSize = self:getItemSize()
	local count = #items
	local pos = 0
	local maxRowLengthCount = 0
	local curRowIndex = 1 -- 当前的行
	for i = 1, count do
		local rowIndex = items[i]:getRow()
		if rowIndex ~= curRowIndex then
			if maxRowLengthCount < pos then
				maxRowLengthCount = pos
			end
			pos = 0
			curRowIndex = rowIndex
		end
		local posX = -(pos * itemSize.width + itemSize.width * .5)
		local posY = -(rowIndex * itemSize.height - itemSize.height * .5)
		if rowIndex >= 1 then
			posX = posX - self._offsetPoint.x
		end
		positions[i] = cc.p(posX, posY)
		pos = pos + 1
	end
	self._maxWidth = maxRowLengthCount * itemSize.width + self._offsetPoint.x --计算最长的行，加上self._offsetPoint.x 大约计算
	return positions
 end

--[[旧的自动换行
function TopNavigationView:measureItemsPosition(items)
	local totalModX = {}
	local function getRowIndex(sumWidth, idx)
		idx = idx or 0
		if sumWidth > self._maxWidth then
			idx = idx + 1
			return getRowIndex(sumWidth - self._maxWidth - (totalModX[idx] or 0), idx)
		end
		return idx
	end

	local positions = {}
	local itemSize = self:getItemSize()
	local count = #items
	for i = 1, count do
		local idx = i - 1
		local sumWidth = idx * itemSize.width + self._offsetPoint.x
		local rowIndex = getRowIndex(sumWidth)
		local offsetY = itemSize.height * rowIndex + self._offsetPoint.y
		local offsetX = sumWidth - self._maxWidth * rowIndex

		-- 如果是第一行之后，需要格式化一下X位置，不然会出现初始空格的情况。
		-- 计算这个位置模元素的大小，得出间隔了多少偏差，累计并减去这个偏差即可格式化位置。
		-- 下一个元素需要在计算长度的时候就需要减去这个累计值，以便得到正确的位置。
		if rowIndex > 0 then
			local modX = (offsetX % itemSize.width)
			totalModX[rowIndex] = (totalModX[rowIndex] or 0) + modX
			offsetX = offsetX - modX
		end

		local posX = -(offsetX + itemSize.width * .5)
		local posY = -(offsetY + itemSize.height * .5)
		positions[#positions + 1] = cc.p(posX, posY)
	end

 	return positions
 end
--]]

--[[
function TopNavigationView:show()
	self._edgeButton:setScaleX(1)
	self._isHide = false
	self._itemContainer:setVisible(true)
	self._itemContainer:stopAllActions()

	local moveto = transition.create(cca.moveTo(.3, 0, 0), {}) --easing = "backOut"
	local action = cc.Spawn:create(moveto, cca.fadeIn(.3))
	self._itemContainer:runAction(action)
end

function TopNavigationView:hide()
	self._edgeButton:setScaleX(-1)
	self._isHide = true
	self._itemContainer:stopAllActions()

	local moveto = transition.create(cca.moveTo(.3, self._maxWidth, 0), {onComplete = function()
		self._itemContainer:setVisible(false)
	end}) --easing = "backIn"
	local action = cc.Spawn:create(moveto, cca.fadeOut(.3))
	self._itemContainer:runAction(action)
end
]]

return TopNavigationView