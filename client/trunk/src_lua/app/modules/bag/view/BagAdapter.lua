--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 15:03:56
--
local BagPage 		= import(".BagPage")
local BagAdapter 	= class("BagAdapter", PagerAdapter)

BagAdapter.ON_SELECTED_ITEM = "ON_SELECTED_ITEM"
BagAdapter.ON_CLICKED_LOCK  = "ON_CLICKED_LOCK"

function BagAdapter:ctor(params)
	self.param = params or {}
	self.numOfPage = self.param.pageOfNum or 5
	BagAdapter.super.ctor(self)
	self:initialization(self.param)
end

function BagAdapter:initialization(params)
	self._pageCapacity = params.pageCapacity or 20
	self._usedPages = {}
	self._items     = {}

	self._itemSelectVisible = false
	self._itemChooseEnabled = true
	self._callBack = nil
end

function BagAdapter:getBagPage(pageIndex)
	local page = BagPage.new(self.param)
	--
	-- #Define MUST_CALL_RELEASE OPEN
	-- 这里保留一次引用计数，因为不用到的页面会被缓存，直到执行ClearPages方法才会清除。
	--
	page:retain()
	page:SetOnItemClickHandler(handler(self, self.onItemClickHandler))
	page:SetOnLockClickHandler(handler(self, self.onLockClickHandler))

	local pageData  = self:getPageDataByIndex(pageIndex)
	local pageUnCap = self:getUnLockNumberByIndex(pageIndex)
	page:SetPageIndex(pageIndex)
	page:SetPageItemsData(pageData)
	page:SetUnLockNumber(pageUnCap)
	page:SetItemsSelectVisible(self._itemSelectVisible)
	page:SetChooseEnabled(self._itemChooseEnabled)

	return page
end

function BagAdapter:onItemClickHandler(itemData, select)
	self:dispatchEvent({name = BagAdapter.ON_SELECTED_ITEM, data = itemData, isSelected = select})
	if self._itemChooseEnabled then
		self:UnSelectItem()
	end
end

function BagAdapter:onLockClickHandler()
	self:dispatchEvent({name = BagAdapter.ON_CLICKED_LOCK})
end

function BagAdapter:getPageDataByIndex(pageIndex)
	local pageData = {}
	local startIndex = (pageIndex - 1) * self._pageCapacity
	for i = 1, self._pageCapacity do
		local item = self._items[startIndex + i]
		if item then
			pageData[#pageData + 1] = item
		end
	end
	return pageData
end

function BagAdapter:getUnLockNumberByIndex(pageIndex)
	local bagDataCap = RoleManager:getInstance().roleInfo.bag
	local resultCap = bagDataCap - (pageIndex - 1) * self._pageCapacity
	return math.max(math.min(self._pageCapacity, resultCap), 0)
end

function BagAdapter:invalidateBagItems()
	for k, v in ipairs(self._usedPages) do
		local pageIndex = v:GetPageIndex()
		local pageData  = self:getPageDataByIndex(pageIndex)
		v:SetPageItemsData(pageData)
	end
end

function BagAdapter:invalidateItemsSelecteVisible()
	for k, v in ipairs(self._usedPages) do
		v:SetItemsSelectVisible(self._itemSelectVisible)
	end
end

function BagAdapter:invalidateItemLoadedCallBack()
	if not self._callBack then return end
	for k, v in ipairs(self._usedPages) do
		v:EveryCallBack(self._callBack)
	end
end

function BagAdapter:invalidateSetChooseEnabled()
	for k, v in ipairs(self._usedPages) do
		v:SetChooseEnabled(self._itemChooseEnabled)
	end
end


--
-- 取消所有页面的选中
--
function BagAdapter:UnSelectItem()
	for k, v in ipairs(self._usedPages) do
		v:SetSelectedBorderByItem(nil)
	end
end

function BagAdapter:SetBagItems(items)
	self._items = items or {}
	self:UnSelectItem()
	self:invalidateBagItems()
	self:invalidateItemsSelecteVisible()
	self:invalidateItemLoadedCallBack()
	self:notifyDataChanged()
end

function BagAdapter:GetBagItems()
	return self._items
end

function BagAdapter:GetPageIndexByGoodsId(goods_id)
	for k, v in ipairs(self._items) do
		if v.goods_id == goods_id then
			return math.ceil(k / self._pageCapacity)
		end
	end
end

--
-- 获取指定物品的矩形对象（相对于世界坐标系），如果没有则返回nil.
--
function BagAdapter:GetItemRectByGoodsId(goods_id)
	local rect = nil
	local function find(item, itemData)
		if rect then return end
		if itemData.goods_id == goods_id then
			local itemParent = item:getParent()
			local worldPoint = itemParent:convertToWorldSpace(cc.p(item:getPosition()))
			rect = cc.rect(worldPoint.x - 40, worldPoint.y - 40, 80, 80)
		end
	end

	for k, v in ipairs(self._usedPages) do
		if rect then break end
		v:EveryCallBack(find)
	end

	return rect
end

function BagAdapter:SetItemLoadedCallBack(callback)
	self._callBack = callback
end

function BagAdapter:SetItemsSelectVisible(visible)
	self._itemSelectVisible = visible
	self:invalidateItemsSelecteVisible()
end

function BagAdapter:SetChooseEnabled(enabled)
    self._itemChooseEnabled = enabled
    self:invalidateSetChooseEnabled()
end

function BagAdapter:SetItemSelectState(itemData, isSelected)
    for k, v in ipairs(self._usedPages) do
		v:SetItemSelectState(itemData, isSelected)
	end
end

function BagAdapter:SelectItemByData(itemData)
	for k, v in ipairs(self._usedPages) do
		v:SelectItemByData(itemData)
	end
end

function BagAdapter:RefreshLockStates()
	for k, v in ipairs(self._usedPages) do
		local pageIndex = v:GetPageIndex()
		local pageUnCap = self:getUnLockNumberByIndex(pageIndex)
		v:SetUnLockNumber(pageUnCap)
	end
end

function BagAdapter:ResetItemsSelectState()
	for k, v in ipairs(self._usedPages) do
		v:ResetItemsSelectState()
	end
end

--
-- Number of the adapter elements.
--
function BagAdapter:GetCount()
	return self.numOfPage
end

--
-- Get object from adapter of position.
--
function BagAdapter:GetItem(position)
end

--
-- Instance a page into ViewPager.
--
function BagAdapter:InstantiateItem(position)
	local page = nil
	for k, v in ipairs(self._usedPages) do
		if v:GetPageIndex() == position then
			page = v
			break
		end
	end

	if not page then
		page = self:getBagPage(position)
		self._usedPages[#self._usedPages + 1] = page
	end
	
	return page
end

--
-- Remove a page from ViewPager.
--
function BagAdapter:DestroyItem(item)
end

--
-- Destory adapter.
--
function BagAdapter:Destory()
	-- #Define MUST_CALL_RELEASE END
	self:removeAllEventListeners()
	for _, v in ipairs(self._usedPages) do
		v:Destory()
		v:release()
	end
end

return BagAdapter