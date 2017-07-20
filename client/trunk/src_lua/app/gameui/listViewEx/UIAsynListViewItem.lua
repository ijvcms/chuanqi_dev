--动态ListView的Item基类
--@author shine

local UIAsynListViewItem = class("UIAsynListViewItem", function() return display.newNode() end )

--自己实现
function UIAsynListViewItem:setData(params)
end

--条目卸载（不可见）的时候
function UIAsynListViewItem:onUnLoaded()
end

return UIAsynListViewItem