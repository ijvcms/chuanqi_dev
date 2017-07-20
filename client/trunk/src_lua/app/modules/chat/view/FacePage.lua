--
-- Author: Yi hanneng
-- Date: 2016-01-13 20:49:35
--

local PAGE_SIZE = cc.size(400, 200)
local NUM_OF_COLUMN = 6
local NUM_OF_ROWS   = 2
local NUM_OF_ITEMS  = NUM_OF_COLUMN * NUM_OF_ROWS
local ELEMENT_SIZE = cc.size(52, 52)

local ELEMENT_COLUMN_GAP = (PAGE_SIZE.width - NUM_OF_COLUMN * ELEMENT_SIZE.width) / NUM_OF_COLUMN
local ELEMENT_ROW_GAP = (PAGE_SIZE.height - NUM_OF_ROWS * ELEMENT_SIZE.height) / NUM_OF_ROWS

local LAYOUT_WIDTH  = ELEMENT_SIZE.width + ELEMENT_COLUMN_GAP
local LAYOUT_HEIGHT = ELEMENT_SIZE.height + ELEMENT_ROW_GAP

local FacePage = class("FacePage", function() return display.newNode()end)

function FacePage:ctor()
	
	self:initialization()
end

function FacePage:initialization()
	 
	self._onClickHandler = nil
	self._itemBgs ={}
	self:setContentSize(PAGE_SIZE.width, PAGE_SIZE.height)
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouchHandler))
	 
	-- test
	-- self:SetPageItemsData(BagManager:getInstance().bagInfo:getTotalList())
end
--
-- 初始化页面组件。
--
function FacePage:buildFaces()

	for i = 1, #self._faces do
		local itemBg = display.newSprite("#" .. self._faces[i].frameName)
        self:setItemPosition(itemBg, i)
        itemBg.name = self._faces[i].frameName
        self:addChild(itemBg)
        self._itemBgs[#self._itemBgs + 1] = itemBg
 
    end

 
end

function FacePage:setFaces(faces)
	self._faces = faces
	self:buildFaces()
end

function FacePage:GetPageIndex()
	return self._pageIndex
end

function FacePage:setPageIndex(pageIndex)
	self._pageIndex = pageIndex
end

--
-- 根据索引设置一个物品组件在本页面中的位置。
--
function FacePage:setItemPosition(itemComponent, index)
	local xUnit = ((index - 1) % (NUM_OF_COLUMN)) + 1
	local yUnit = NUM_OF_ROWS - math.ceil(index / NUM_OF_COLUMN) + 1
 
	local xx = (xUnit - 1) * LAYOUT_WIDTH + (LAYOUT_WIDTH / 2)
	local yy = (yUnit - 1) * LAYOUT_HEIGHT + (LAYOUT_HEIGHT / 2)
	itemComponent:setPositionX(xx)
	itemComponent:setPositionY(yy)
end

function FacePage:onTouchHandler(event)
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
            self:handleTouchHasContain(self._itemBgs, nodeSpacePoint, handler(self, self.onClickItem))
		end
	end
	return true
end

function FacePage:handleTouchHasContain(items, localPoint, handler)
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

function FacePage:SetOnItemClickHandler(handler)
	self._onClickHandler = handler
end

function FacePage:onClickItem(item)

	if self._onClickHandler then
		self._onClickHandler(item.name)
	end
 
end
return FacePage