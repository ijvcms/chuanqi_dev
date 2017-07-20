--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-01 09:34:33
--
local ViewPagerImp = class("ViewPagerImp", function()
	return cc.ClippingRectangleNode:create()
end)

local PREVIOUS = 1
local CURRENT  = 2
local NEXT     = 3
local TRANSITION_TIME = .2

ViewPagerImp.EVENT_PAGE_CHANGED = "EVENT_PAGE_CHANGED"
ViewPagerImp.EVENT_PAGE_CLICKED = "EVENT_PAGE_CLICKED"

-- ============================================================================================
-- initialization Method & Fields
-- --------------------------------------------------------------------------------------------
function ViewPagerImp:ctor(params)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:initialization_(params)
end

function ViewPagerImp:initialization_(params)
	self.curPageIdx_ = 0
	self.pages_ = {}
	self.viewRect_ = params.viewRect or cc.rect(0, 0, display.width, display.height)
	self:setClippingRegion(self.viewRect_)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))
end

-- ============================================================================================
-- Public Methods
-- --------------------------------------------------------------------------------------------

--
-- 增加一个页面。
--
function ViewPagerImp:AddPage(page)
	self:InsertPage(page, self:numOfPages_() + 1)
end

--
-- 在指定索引位置插入一个新的页面。
-- 插入页面操作会有当前页面锁定机制。
-- 也就是说，假如我现在处于第二页，那么我们再第二页又插入了一个页面，那么此时的页面就会变为第三页。
--
function ViewPagerImp:InsertPage(page, index)
	local currentItem = self:getCurrentPage_()
	table.insert(self.pages_, index, page)
	self.curPageIdx_ = table.indexof(self.pages_, currentItem) or 1

	-- dump(self.pages_, "------------[ViewPagerImp] -> Insert page:" .. index .. " ---- curPageIdx_:" .. self.curPageIdx_)
	self:invalidatePages_()
end

--
-- 移除指定页面。
--
function ViewPagerImp:RemovePage(page)
	local currentItem = self:getCurrentPage_()
	local removeIdx = table.indexof(self.pages_, page)
	if not removeIdx then return end
	table.remove(self.pages_, removeIdx)
	local currentIndex = table.indexof(self.pages_, currentItem)
	if currentIndex then
		self.curPageIdx_ = currentIndex
	else
		-- 移除了当前页面，去到最后一页。
		self.curPageIdx_ = self:numOfPages_()
	end

	-- dump(self.pages_, "------------[ViewPagerImp] -> Remove page index:" .. removeIdx .. " ---- curPageIdx_:" .. self.curPageIdx_)
	
	self:invalidatePages_()
end

--
-- 移除当前组件内拥有的所有页面。
--
function ViewPagerImp:RemoveAllPage()
	self.curPageIdx_ = 0
	self.pages_ = {}

	-- dump(self.pages_, "------------[ViewPagerImp] -> Remove All Page:")
	self:invalidatePages_()
end

--
-- 获取当前的页面索引。
--
function ViewPagerImp:GetCurrentPageIndex()
	return self.curPageIdx_
end

--
-- 前往指定索引的页面。
--
function ViewPagerImp:GotoPageByIndex(index)
	if index == self.curPageIdx_ then return end
	if index < 1 or index > self:numOfPages_() then return end
	self.currentIdx = index
	self:invalidatePages_()
end

-- ============================================================================================
-- Private Methods
-- --------------------------------------------------------------------------------------------

--
-- 使之前的页面缓存引用处于无效状态。
-- 移除所有的页面，然后把现有的页面添加进舞台，隐藏其余页面，设置当前页面的位置。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
-- 此外，还需要一个失效管理器来机型集中散发事件及处理帧运算。
--
function ViewPagerImp:invalidatePages_()
	self:stopAllTransition()
	for _, v in ipairs(self.pages_) do
		v:retain()
	end

	-- Remove all child because maybe has abandoned of some pages.
	self:removeAllChildren(false)

	for _, v in ipairs(self.pages_) do
		self:addChild(v)
		v:release()
	end

	self:hideOtherPages_()
	self:fixCurrentPagePosition_()
end

--
-- Hide all pages apart current page.
--
function ViewPagerImp:hideOtherPages_()
	for k, v in ipairs(self.pages_) do
		v:setVisible(k == self.curPageIdx_)
	end
end

--
-- Setting current page position to viewport area.
--
function ViewPagerImp:fixCurrentPagePosition_()
	local currentPage = self:getCurrentPage_()
	if currentPage then
		currentPage:setPosition(self.viewRect_.x, self.viewRect_.y)
	end
end

--
-- When touch me will call the function & push parameter of the event object.
--
function ViewPagerImp:onTouch_(event)
	if "began" == event.name and not self:isTouchInViewRect_(event) then
		printInfo("UIPageView - touch didn't in viewRect")
		return false
	end

	if "began" == event.name then
		self:stopAllTransition()
		self.bDrag_ = false
	elseif "moved" == event.name then
		self.bDrag_ = true
		self.speed = event.x - event.prevX
		self:scrollTo_(self.speed)
	elseif "ended" == event.name then
		if self.bDrag_ then
			self:perfromScrollFix_()
		else
			-- self:resetPages_()
			-- self:onClick_(event)
		end
	end

	return true
end

--
-- Returns clicked whether an area in the display area ?
--
function ViewPagerImp:isTouchInViewRect_(event, rect)
	rect = rect or self.viewRect_
	local viewRect = self:convertToWorldSpace(cc.p(rect.x, rect.y))
	viewRect.width = rect.width
	viewRect.height = rect.height

	return cc.rectContainsPoint(viewRect, cc.p(event.x, event.y))
end

--
-- Stop all page transitions.
--
function ViewPagerImp:stopAllTransition()
	for _, v in ipairs(self.pages_) do
		transition.stopTarget(v)
	end
end

function ViewPagerImp:scrollTo_(distance)
	if 0 == self:numOfPages_() then return end
	self:perfromScrollPages_(distance)
end

function ViewPagerImp:perfromScrollPages_(distance)
	local pages        = self:getVisiblePages()
	local previousPage = pages[PREVIOUS]
	local currentPage  = pages[CURRENT]
	local nextPage     = pages[NEXT]

	-- current
	local posX, posY = currentPage:getPosition()
	posX = posX + distance
	currentPage:setPosition(posX, posY)

	-- previous
	posX = posX - self.viewRect_.width
	if previousPage then
		previousPage:setPosition(posX, posY)
		if not previousPage:isVisible() then
			previousPage:setVisible(true)
		end
	end

	-- next
	posX = posX + self.viewRect_.width * 2
	if nextPage then
		nextPage:setPosition(posX, posY)
		if not nextPage:isVisible() then
			nextPage:setVisible(true)
		end
	end
end

function ViewPagerImp:perfromScrollFix_()
	local count = self:numOfPages_()
	if 0 == count then return end

	local pages        = self:getVisiblePages()
	local previousPage = pages[PREVIOUS]
	local currentPage  = pages[CURRENT]
	local nextPage     = pages[NEXT]

	local bChange = false
	local posX, posY = currentPage:getPosition()
	local dis = posX - self.viewRect_.x
	local isToNext = dis < 0

	local pageRX = self.viewRect_.x + self.viewRect_.width
	local pageLX = self.viewRect_.x - self.viewRect_.width

	if (dis > self.viewRect_.width/2 or self.speed > 10)
		and (self.curPageIdx_ > 1 or self.bCirc)
		and count > 1 then
		bChange = true
	elseif (-dis > self.viewRect_.width/2 or -self.speed > 10)
		and (self.curPageIdx_ < count or self.bCirc)
		and count > 1 then
		bChange = true
	end

	local onCompleteHandler = function()
		self:hideOtherPages_()
		self:dispatchEventWithPageChanged_()
	end

	local onChangedCompleteHandler = function()
		if isToNext then
			self.curPageIdx_ = self:intoNext()
		else
			self.curPageIdx_ = self:intoPrevious()
		end
		onCompleteHandler()
	end

	local transitionPage = function(nextPage, currentToX, nextPageTox)
		if bChange then
			--
			-- 前往下一页
			--
			transition.moveTo(currentPage, {x = currentToX, y = posY, time = TRANSITION_TIME, onComplete = onChangedCompleteHandler})
			transition.moveTo(nextPage,{x = self.viewRect_.x, y = posY, time = TRANSITION_TIME})
		else
			--
			-- 返回当前页
			--
			transition.moveTo(currentPage, {x = self.viewRect_.x, y = posY, time = TRANSITION_TIME, onComplete = onCompleteHandler})
			if nextPage then
				transition.moveTo(nextPage, {x = nextPageTox, y = posY, time = TRANSITION_TIME})
			end
		end
	end

	if isToNext then
		transitionPage(nextPage, pageLX, pageRX)
	else
		transitionPage(previousPage, pageRX, pageLX)
	end
end

--
-- Only user switch page will call this function.
--
function ViewPagerImp:dispatchEventWithPageChanged_()
	local event = {
		name    = ViewPagerImp.EVENT_PAGE_CHANGED,
		pageIdx = self.curPageIdx_
	}
	self:dispatchEvent(event)
end

function ViewPagerImp:numOfPages_()
	return #self.pages_
end

function ViewPagerImp:getVisiblePages()
	return {
		[PREVIOUS] = self:getPreviousPage_(),
		[CURRENT]  = self:getCurrentPage_(),
		[NEXT]     = self:getNextPage_(),
	}
end

function ViewPagerImp:getPreviousPage_(currentIndex)
	local previousIdx = self:intoPrevious(currentIndex)
	return self.pages_[previousIdx]
end

function ViewPagerImp:getCurrentPage_(currentIndex)
	local curIdx = currentIndex or self.curPageIdx_
	return self.pages_[curIdx]
end

function ViewPagerImp:getNextPage_(currentIndex)
	local nextIdx = self:intoNext(currentIndex)
	return self.pages_[nextIdx]
end

--
-- 返回指定索引的上一个索引位置。
-- 如无指定索引返回当前索引的上一个索引位置。
--
function ViewPagerImp:intoPrevious(index)
	local curIdx = index or self.curPageIdx_
	return curIdx - 1
end

--
-- 返回指定索引的下一个索引位置。
-- 如无指定索引返回当前索引的下一个索引位置。
--
function ViewPagerImp:intoNext(index)
	local curIdx = index or self.curPageIdx_
	return curIdx + 1
end

return ViewPagerImp