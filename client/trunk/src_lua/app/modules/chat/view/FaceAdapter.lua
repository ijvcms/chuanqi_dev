--
-- Author: Yi hanneng
-- Date: 2016-01-13 20:49:23
--
local FacePage 		= import(".FacePage")
local FaceAdapter = class("FaceAdapter", PagerAdapter)

FaceAdapter.ON_SELECTED_ITEM = "FACE_ON_SELECTED_ITEM"

function  FaceAdapter:ctor()
	FaceAdapter.super.ctor(self)
	self._usedPages = {}
	self.faceList = {}
end

function FaceAdapter:setData(data)
 
	self.faceList = data
	self:notifyDataChanged()
end

--
-- Number of the adapter elements.
--
function FaceAdapter:GetCount()
	return math.ceil(#self.faceList / 12)
end

--
-- Get object from adapter of position.
--
function FaceAdapter:GetItem(position)
	dump(position)
end

--
-- Instance a page into ViewPager.
--
function FaceAdapter:InstantiateItem(position)
	local page = nil
	for k, v in ipairs(self._usedPages) do
		if v:GetPageIndex() == position then
			page = v
			break
		end
	end

	if not page then
		page = self:getFacePage(position)
		self._usedPages[#self._usedPages + 1] = page
	end
	
	return page

end

function FaceAdapter:getFacePage(position)
	local page = FacePage.new()
	page:retain()
	page:setPageIndex(position)
	page:setFaces(self:getPageDataByIndex(position))
	page:SetOnItemClickHandler(handler(self, self.onItemClickHandler))
	return page
end

function FaceAdapter:onItemClickHandler(itemData)
	self:dispatchEvent({name = FaceAdapter.ON_SELECTED_ITEM, data = itemData })
end

function FaceAdapter:getPageDataByIndex(pageIndex)
	local pageData = {}
	local startIndex = (pageIndex - 1) * 12
	for i = 1, 12 do
		local item = self.faceList[startIndex + i]
		if item then
			pageData[#pageData + 1] = item
		end
	end
	return pageData
end

--
-- Remove a page from ViewPager.
--
function FaceAdapter:DestroyItem(item)
end

--
-- Destory adapter.
--
function FaceAdapter:Destroy()
	for _, v in ipairs(self._usedPages) do
		v:release()
	end
end

return FaceAdapter