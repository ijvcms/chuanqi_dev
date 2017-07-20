--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 10:24:37
--

--[[
	ViewPager 组件的中间人接口。
	PagerAdapter 用于适配数据及视图的桥接方式。
]]
local PagerAdapter = class("PagerAdapter")

PagerAdapter.DATA_CHANGED = "DATA_CHANGED"

function PagerAdapter:ctor()
	cc(self)
		:addComponent("components.behavior.EventProtocol")
		:exportMethods()
end

function PagerAdapter:notifyDataChanged()
	self:dispatchEvent({name = PagerAdapter.DATA_CHANGED})
end

--
-- Number of the adapter elements.
--
function PagerAdapter:GetCount()
end

--
-- Get object from adapter of position.
--
function PagerAdapter:GetItem(position)
end

--
-- Instance a page into ViewPager.
--
function PagerAdapter:InstantiateItem(position)
end

--
-- Remove a page from ViewPager.
--
function PagerAdapter:DestroyItem(item)
end

--
-- Destory adapter.
--
function PagerAdapter:Destroy()
end

return PagerAdapter