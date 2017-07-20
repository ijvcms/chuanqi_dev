--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-05 11:33:53
--

local BagAdapter  = import(".BagAdapter")
local PageManager = class("PageManager")

function PageManager:ctor(pageParent, posX, posY,param)
    self._parent = pageParent
    self._posX = posX or 0
    self._posY = posY or 0
    self.params = param or {}
    self:initialization(self.params)
end

function PageManager:initialization(param)
    -- if  self.hideBg == false then
    --     local bg = display.newScale9Sprite("#com_propBg1.png", 0, 0, cc.size(self.bgW,self.bgH))
    --     self._parent:addChild(bg)
    --     bg:setAnchorPoint(0, 0)
    --     bg:setPosition(self._posX, self._posY)
    -- end

    --param = {colum = 5,rows = 4,pageWidth = 400,pageHeight = 300,pageOfNum = 5,pageCapacity = 20}
    local adapter = BagAdapter.new(param)
    local pager   = ViewPager.new({x = 0, y = 0, height = (param.pageHeight or 400)+2, width = (param.pageWidth or 400)+2})
    local pagerMarker = PageMarker.create(param.pageOfNum or 5)

    pager:addEventListener(ViewPager.PAGE_CHANGED, handler(self, self.onPageChanged))
    pager:SetAdapter(adapter)
    pagerMarker:setPosition(((param.pageWidth or 400)+2)/2+self._posX+16, -20+self._posY)

    self._parent:addChild(pager)
    self._parent:addChild(pagerMarker)
    pager:setPosition(self._posX,self._posY)

    self.adapter = adapter
    self.pager   = pager
    self.pagerMarker = pagerMarker
    self.bg = bg
end

function PageManager:onPageChanged(event)
    local index = event.currentIndex
    if self.pagerMarker then
        self.pagerMarker:SetMarkIndex(index)
    end
end

function PageManager:SetItemLoadedCallBack(callback)
    self.adapter:SetItemLoadedCallBack(callback)
end

--
-- 是否启用唯一选中功能？默认开启。
--
function PageManager:SetChooseEnabled(enabled)
    self.adapter:SetChooseEnabled(enabled)
end

--
-- 将指定数据项的视图的选中状态设置为指定值。
--
function PageManager:SetItemSelectState(itemData, isSelected)
    self.adapter:SetItemSelectState(itemData, isSelected)
end

--
-- 在当前滑动组件中 选中指定的数据项的视图项。
--
function PageManager:SelectItemByData(itemData)
    self.adapter:SelectItemByData(itemData)
end

--
-- 显示或隐藏当前数据项对应视图的选中状态。
--
function PageManager:SetItemsSelectVisible(visible)
    self.adapter:SetItemsSelectVisible(visible)
end

--
-- 重置所有数据的视图项的选中状态。
--
function PageManager:ResetItemsSelectState()
    self.adapter:ResetItemsSelectState()
end

--
-- 跳转至第一页。
--
function PageManager:GotoFirstPage()
    self.pager:GotoPageByIndex(1)
end

--
-- 刷新当前的背包解锁状态。
--
function PageManager:RefreshLockStates()
    self.adapter:RefreshLockStates()
end

--
-- 为当前的翻页组件设定数据项列表。
--
function PageManager:SetPageItemsData(data)
    self.adapter:SetBagItems(data)
    self:ResetItemsSelectState()
end

--
-- 获取当前设置的数据列表。
--
function PageManager:GetPageItemsData()
    return self.adapter:GetBagItems()
end

--
-- 跳转到指定物品的所在页数。
--
function PageManager:GotoPageByGoodsId(goods_id)
    local pageIdx = self.adapter:GetPageIndexByGoodsId(goods_id)
    if pageIdx then
        self.pager:GotoPageByIndex(pageIdx)
        return true
    end
    return false
end

--
-- 获取指定物品的矩形对象（相对于世界坐标系），如果没有则返回nil.
--
function PageManager:GetItemRectByGoodsId(goods_id)
    return self.adapter:GetItemRectByGoodsId(goods_id)
end


function PageManager:SetOnItemsSelectedHandler(handler)
    self.adapter:addEventListener(BagAdapter.ON_SELECTED_ITEM, handler)
end

function PageManager:SetOnLockClickHandler(handler)
    self.adapter:addEventListener(BagAdapter.ON_CLICKED_LOCK, handler)
end

function PageManager:Destory()
    self.adapter:Destory()
end

----------------------------------------------------------------------------
-- 兼容接口
function PageManager:setVisible(visible)
    self.pager:setVisible(visible)
    self.pagerMarker:setVisible(visible)
    if self.bg then
        self.bg:setVisible(visible)
    end
end

return PageManager