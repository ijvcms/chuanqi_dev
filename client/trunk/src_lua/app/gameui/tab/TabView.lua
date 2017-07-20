--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 17:42:36
--
local TabFlag = import(".TabFlag")
local TabView = class("TabView", TabFlag)

function TabView:ctor(view, flag)
	TabView.super.ctor(self, flag)
	assert(view ~= nil, "TabView::ctor - view can't be nil!!")
	self._view = view
	self:initialization()
end

--
-- 初始化操作
--
function TabView:initialization()
end

--
-- 注册全局事件监听。
--
function TabView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function TabView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

--
-- 获取页卡视图。
--
function TabView:GetView()
	return self._view
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function TabView:Show()
	self._view:setVisible(true)
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function TabView:Hide()
	self._view:setVisible(false)
end

--
-- 标识匹配
--
function TabView:Match()
	self:Show()
end

--
-- 标识不匹配
--
function TabView:UnMatch()
	self:Hide()
end

--
-- 销毁
--
function TabView:Destory()
	self:removeAllEvents()
end

return TabView