--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 15:03:56
--
local StoragePage 		= import(".StoragePage")
local StorageAdapter 	= class("StorageAdapter", PagerAdapter)

StorageAdapter.ON_SELECTED_ITEM = "ON_SELECTED_ITEM"

function StorageAdapter:ctor(params)
	StorageAdapter.super.ctor(self)
	self:initialization(params)
end

function StorageAdapter:initialization(params)
	self._pageCapacity = params.pageCapacity
	self._pagePool  = {}
	self._usedPages = {}
	self._items     = {}
end

function StorageAdapter:fromPool()
	local page = nil
	local poolCount = #self._pagePool
	if poolCount > 0 then
		page = table.remove(self._pagePool, poolCount)
	end
	return page
end

function StorageAdapter:toPool(page)
	self._pagePool[#self._pagePool + 1] = page
end

function StorageAdapter:getBagPage(pageIndex)
	local page = self:fromPool()
	if not page then
		page = StoragePage.new()
		--
		-- #Define MUST_CALL_RELEASE OPEN
		-- 这里保留一次引用计数，因为不用到的页面会被缓存，直到执行ClearPages方法才会清除。
		--
		page:retain()
		page:SetOnItemClickHandler(handler(self, self.onItemCLickHandler))
	end

	local pageData  = self:getPageDataByIndex(pageIndex)
	page:SetPageIndex(pageIndex)
	page:SetPageItemsData(pageData)

	return page
end

function StorageAdapter:onItemCLickHandler(itemData)
	self:dispatchEvent({name = StorageAdapter.ON_SELECTED_ITEM, data = itemData})
end

function StorageAdapter:getPageDataByIndex(pageIndex)
	local pageData = {}
	local startIndex = (pageIndex - 1) * self._pageCapacity
	for i = 1, self._pageCapacity do
		local item = self._items[startIndex + i]
		if item then
			pageData[#pageData + 1] = item
		end
	end
	-- print("Index:" .. pageIndex .. "--StartIndex:" .. startIndex .. "---Count:" .. #pageData)
	return pageData
end

function StorageAdapter:invalidateBagItems()
	-- print("===================================Bag items Count:" .. #self._items)
	for k, v in ipairs(self._usedPages) do
		local pageIndex = v:GetPageIndex()
		local pageData  = self:getPageDataByIndex(pageIndex)
		v:SetPageItemsData(pageData)
	end
end

function StorageAdapter:SetBagItems(items)
	self._items = items or {}
	self:invalidateBagItems()
	self:notifyDataChanged()
end

--
-- Number of the adapter elements.
--
function StorageAdapter:GetCount()
	return math.ceil(#self._items / self._pageCapacity)
end

--
-- Get object from adapter of position.
--
function StorageAdapter:GetItem(position)
end

--
-- Instance a page into ViewPager.
--
function StorageAdapter:InstantiateItem(position)
	local page = self:getBagPage(position)
	self._usedPages[#self._usedPages + 1] = page
	return page
end

--
-- Remove a page from ViewPager.
--
function StorageAdapter:DestroyItem(item)
	local itemUsedIndex = table.indexof(self._usedPages, item)
	if itemUsedIndex then
		table.remove(self._usedPages, itemUsedIndex)
		self:toPool(item)
	end
end

--
-- Destory adapter.
--
function StorageAdapter:Destroy()
	-- #Define MUST_CALL_RELEASE END
	for _, v in ipairs(self._pagePool) do
		v:release()
	end

	for _, v in ipairs(self._usedPages) do
		v:release()
	end
	self:removeAllEventListeners()
end

return StorageAdapter