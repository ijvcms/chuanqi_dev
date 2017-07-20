--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 09:31:45
--
local ViewPagerImp = import(".ViewPagerImp")
local ViewPager = class("ViewPager", function(options)
	local params    = {}
	params.viewRect = cc.rect(options.x, options.y, options.width, options.height)

	return ViewPagerImp.new(params)
end)

ViewPager.PAGE_CHANGED = "PAGE_CHANGED"

local PREVIOUS = 1
local CURRENT  = 2
local NEXT     = 3

-- ============================================================================================
-- initialization Method & Fields
-- --------------------------------------------------------------------------------------------
function ViewPager:ctor()
	self:initialization()
end

function ViewPager:initialization()
	self._pageIndex = 0
	self._adapter = nil
	self._cacheView = {}
	self:addEventListener(self.EVENT_PAGE_CHANGED, handler(self, self.onPageViewListenerHandler))
end

-- ============================================================================================
-- Public Methods
-- --------------------------------------------------------------------------------------------

--
-- 设置适配器。
--
function ViewPager:SetAdapter(adapter)
	self:removeAdapterEvents()
	self:removeAllPages()
	self._adapter = adapter
	self:invalidateAdapter()
end

--
-- @Override Method
-- 前往指定索引的页面。
-- @param index 需要跳转过去的索引。
--
function ViewPager:GotoPageByIndex(index)
	if index == self._pageIndex then return end
	if index < 1 or index > self:numOfPages() then return end

	--[[
		具体做法为：
			1、移除当前所有的页面
			2、设置当前页面索引为最后一页
			3、生成当前页面
			4、生成上一个页面
			5、生成下一个页面
	]]
	self:removeAllPages()
	self._pageIndex = index
	self:dispatchEventWithPageChanged()

	-- 生成当前页面
	local firstPage = self._adapter:InstantiateItem(self._pageIndex)
	self._cacheView[CURRENT] = firstPage
	self:AddPage(firstPage)

	self:readyNextPage()
	self:readyPreviousPage()
	self._realPageIndex = self:GetCurrentPageIndex()
end

-- ============================================================================================
-- Private Methods
-- --------------------------------------------------------------------------------------------

--
-- 广播事件已改变当前页。
-- 考虑在设置Setter函数中调用此方法！！！！！！！！！！！！
-- Fix me
--
function ViewPager:dispatchEventWithPageChanged()
	self:dispatchEvent({name = ViewPager.PAGE_CHANGED, currentIndex = self._pageIndex})
end

--
-- 为当前的适配器增加事件侦听处理方法。
--
function ViewPager:addAdapterEvents()
	local handles = {}
	handles[1] = self._adapter:addEventListener(self._adapter.DATA_CHANGED, handler(self, self.onAdapterDataChanged))

	self._adapter_handles = handles
end

--
-- 为当前的适配器移除事件处理方法。
--
function ViewPager:removeAdapterEvents()
	if self._adapter and self._adapter_handles then
		for _, v in pairs(self._adapter_handles) do
			self._adapter:removeEventListener(v)
		end
		
	end
	self._adapter_handles = nil
end

function ViewPager:removeAllPages()
	if not self._adapter then return end

	for _, v in pairs(self._cacheView) do
		self._adapter:DestroyItem(v)
	end
	self._pageIndex = 0
	self._cacheView = {}
	self:RemoveAllPage()
end

--
-- PagerAdapter 当适配器的数据发生变化，需要重新根据数据载入页面。
--
function ViewPager:onAdapterDataChanged(event)
	self:invalidateDataChanged()
end

--
-- PageView 页面改变事件处理方法。
--
function ViewPager:onPageViewListenerHandler(event)
	if not self._adapter then return end

	local eventName = event.name
	if eventName == self.EVENT_PAGE_CHANGED then
		--
		-- 千万注意，继承的那个索引，跟我们自己管理的索引是不同步和不一样的。
		-- 完全是两个世界的索引数据。
		--
		local currentIdx  = event.pageIdx
		local previousIdx = self._realPageIndex or 1

		-- 如果当前页面没有改变则不进行处理。
		if currentIdx == previousIdx then return end

		local tmpPagerIndex = self._pageIndex
		local tmpImpIndex   = self:GetCurrentPageIndex()

		self:invalidatePageIndex(currentIdx > previousIdx)
		self._realPageIndex = self:GetCurrentPageIndex()

		-- print("================================================== ViewPager Page Index From " .. tmpPagerIndex .. " To " .. self._pageIndex)
		-- print("================================================== Real Page Index: From " .. tmpImpIndex .. " To " .. self:GetCurrentPageIndex())
		-- print("~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~")
	end
end

--
-- 使之前的数据适配器处于无效状态。
-- 移除所有的页面，生成新的页面。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
--
function ViewPager:invalidateAdapter()
	if self._adapter then
		self:addAdapterEvents()
	end

	self:invalidateDataChanged()
end

--
-- 使之前的数据处于无效状态，这样，我们需要根据新的数据来重新载入页面。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
--
function ViewPager:invalidateDataChanged()
	--[[
		当数据改变时，期望如下：
			1、如果数据增加了，并没有影响到当前页面的索引改变，那么就停留在当前页。
			2、如果数据减少了，那么在页数没有改变的情况下，依旧停留在当前页。
			3、如果数据减少了，并且当前的页数已经超出上限，那么我们就停留到最后一页。
	]]

	-- 如果，当前数据获得的页数为0，那么移除所有页面。
	-- 并且，不在往下进行处理。
	if 0 == self:numOfPages() then
		self:removeAllPages()
		return
	end

	local previousIndex = math.max(1, self._pageIndex)
	local currentIndex = math.min(previousIndex, self:numOfPages())
	self._pageIndex = 0
	self:GotoPageByIndex(currentIndex)
end

--
-- 使之前页面索引处于无效状态。
-- 注意，因为没有参与帧运算，所以这里仅仅只是处理了刷新，并没有记录其状态。
-- 通常境况下，应该参与帧运算，并标记其状态，然后由一个post方法来执行操作。
--
-- @param isNext 是否往下翻了。
--
function ViewPager:invalidatePageIndex(isNext)
	-- 每次移动，至多只会删除一个页面。
	if isNext then
		self:moveToNextPage()
	else
		self:moveToPreviousPage()
	end
end



-- 第一页 -> 第二页 -> 第三页
--
-- ┏━━━━━━━━━━┓      ┏━━━━━━━━━━┓       ┏━━━━━━━━━┓       ┏━━━━━━━━━┓
-- ┃ Previous ┃      ┃ Previous ┃       ┃ Current ┃       ┃   Next  ┃
-- ┗━━━━━━━━━━┛      ┗━━━━━━━━━━┛       ┗━━━━━━━━━┛       ┗━━━━━━━━━┛
--       ▼                 ▼                 ▼                 ▼
-- ┏━━━━━━━━━━┓      ┏━━━━━━━━━━┓       ┏━━━━━━━━━━┓      ┏━━━━━━━━━━┓
-- ┃  DELETE  ┃      ┃ Current  ┃       ┃   Next   ┃      ┃ NEW PAGE ┃
-- ┗━━━━━━━━━━┛      ┗━━━━━━━━━━┛       ┗━━━━━━━━━━┛      ┗━━━━━━━━━━┛
--

function ViewPager:moveToNextPage()
	local previousIdx = self._pageIndex
	self._pageIndex = self:intoNext(self._pageIndex)
	self:dispatchEventWithPageChanged()
	-- 如果，上一次操作遗留下来的引用还存在的话，就调用清除例程并移除对其的引用。
	if self._cacheView[PREVIOUS] ~= nil then
		local itemIndex = self:intoPrevious(previousIdx)

		-- 必须要大于0才能移除掉。
		if itemIndex > 0 then
			-- print("================================================== Remove Page Index =  " .. itemIndex)
			local previousItem = self._cacheView[PREVIOUS]
			self._cacheView[PREVIOUS] = nil
			self._adapter:DestroyItem(previousItem)
			self:RemovePage(previousItem)
		end
	end
	self._cacheView[PREVIOUS] = self._cacheView[CURRENT]
	self._cacheView[CURRENT]  = self._cacheView[NEXT]
	self._cacheView[NEXT]     = nil
	self:readyNextPage()
end

--
-- 生成下一个页面，以备切换时需要。
--
function ViewPager:readyNextPage()
	-- 如果我此时的位置处于最后边缘状态（倒数最后一个及以后），则不进行处理。
	if not self:isEdgeLast() then
		local newPage = self._adapter:InstantiateItem(self:intoNext(self._pageIndex))
		self._cacheView[NEXT] = newPage
		self:InsertPage(newPage, self:intoNext())
		-- print("================================================== Add Page Index = " .. self:intoNext(self._pageIndex))
	end

	-- dump(self._cacheView)
end


-- 第三页 -> 第二页 -> 第一页
--
--  ┏━━━━━━━━━┓       ┏━━━━━━━━━┓       ┏━━━━━━━━━┓       ┏━━━━━━━━━━┓
--  ┃   Next  ┃       ┃   Next  ┃       ┃ Current ┃       ┃ Previous ┃
--  ┗━━━━━━━━━┛       ┗━━━━━━━━━┛       ┗━━━━━━━━━┛       ┗━━━━━━━━━━┛
--       ▼                 ▼                 ▼                  ▼
--  ┏━━━━━━━━━━┓      ┏━━━━━━━━━┓       ┏━━━━━━━━━━┓      ┏━━━━━━━━━━┓
--  ┃  DELETE  ┃      ┃ Current ┃       ┃ Previous ┃      ┃ NEW PAGE ┃
--  ┗━━━━━━━━━━┛      ┗━━━━━━━━━┛       ┗━━━━━━━━━━┛      ┗━━━━━━━━━━┛
--
--
function ViewPager:moveToPreviousPage()
	local nextIdx = self._pageIndex
	self._pageIndex = self:intoPrevious(self._pageIndex)
	self:dispatchEventWithPageChanged()
	if self._cacheView[NEXT] ~= nil then
		local itemIndex = self:intoNext(nextIdx)
		if itemIndex <= self:numOfPages() then
			-- print("================================================== Remove Page Index =  " .. itemIndex)
			local nextItem = self._cacheView[NEXT]
			self._cacheView[NEXT] = nil
			self._adapter:DestroyItem(nextItem)
			self:RemovePage(nextItem)
		end
	end
	self._cacheView[NEXT]     = self._cacheView[CURRENT]
	self._cacheView[CURRENT]  = self._cacheView[PREVIOUS]
	self._cacheView[PREVIOUS] = nil
	self:readyPreviousPage()
end

--
-- 生成上一个页面，以便切换时需要。
--
function ViewPager:readyPreviousPage()
	--如果我此时的位置处于第一个边缘状态（第一个及及以前），则不进行处理。
	if not self:isEdgeFirst() then
		local newPage = self._adapter:InstantiateItem(self:intoPrevious(self._pageIndex))
		self._cacheView[PREVIOUS] = newPage
		self:InsertPage(newPage, self:GetCurrentPageIndex())
		-- print("================================================== Add Page Index = " .. self:intoPrevious(self._pageIndex))
	end

	-- dump(self._cacheView)
end

--
-- 当前ViewPager总页数。
--
function ViewPager:numOfPages()
	if self._adapter then
		return self._adapter:GetCount()
	end
	return 1
end

--
-- 返回当前索引是否为第一个元素或更前。
--
function ViewPager:isEdgeFirst()
	return self._pageIndex <= 1
end

--
-- 返回当前索引是否为最后一个元素或更后。
--
function ViewPager:isEdgeLast()
	return self._pageIndex >= self:numOfPages()
end


return ViewPager