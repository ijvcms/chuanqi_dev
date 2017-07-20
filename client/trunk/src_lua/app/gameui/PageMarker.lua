--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-03 14:29:10
--
local PageMarker = class("PageMarker", function()
	return display.newNode()
end)

function PageMarker.create(numOfMark, gap)
	local params = {
		count      = numOfMark,
		markSkin   = "#com_radioBg.png",
		unMarkSkin = "#com_radioPic.png",
		markGap    = gap or 15,
	}

	return PageMarker.new(params)
end

function PageMarker:ctor(params)
	self:initialization(params)
end

function PageMarker:initialization(params)
	self._count      = params.count
	self._markSkin   = params.markSkin
	self._unMarkSkin = params.unMarkSkin
	self._markGap    = params.markGap
	self._markIndex  = 0
	self._unMarks    = nil
	self._mark       = nil
	self:initComponents()
	self:SetMarkIndex(1)
end

function PageMarker:initComponents()
	local unMarks = {}
	local ITEM_WIDTH = display.newSprite(self._unMarkSkin):getContentSize().width + self._markGap
	local ITEM_START_X = -(ITEM_WIDTH * self._count / 2)
	for i = 1, self._count do
		local unMark = display.newSprite(self._unMarkSkin)
		unMark:setPositionX((i - 1) * ITEM_WIDTH + ITEM_START_X)
		unMarks[i] = unMark
		self:addChild(unMark)
	end

	local mark = display.newSprite(self._markSkin)
	self:addChild(mark)

	self._unMarks = unMarks
	self._mark    = mark
end

function PageMarker:checkIndex(newIndex)
	newIndex = newIndex or 0
	return newIndex >= 1 and newIndex <= self._count
end

function PageMarker:invalidateMarkIndex()
	local targetUnMark = self._unMarks[self._markIndex]
	local targetPositionX = targetUnMark:getPositionX()
	self._mark:setPositionX(targetPositionX)
end

function PageMarker:SetMarkIndex(newIndex)
	if self._markIndex == newIndex then return end
	if self:checkIndex(newIndex) then
		self._markIndex = newIndex
		self:invalidateMarkIndex()
	end
end

function PageMarker:SetMarkCount(newCount)
	self._count = newCount
	self:removeAllChildren()
	self:initComponents()
	
	self._markIndex = 0
	self:SetMarkIndex(1)
end

return PageMarker