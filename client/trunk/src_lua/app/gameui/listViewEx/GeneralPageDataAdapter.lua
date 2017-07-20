--通用PageDataAdapter，实例化时传入继承UIAsynListViewItem的类名
--@author shine

local PageDataAdapter = import(".PageDataAdapter")

local GeneralPageDataAdapter = class("GeneralPageDataAdapter", PageDataAdapter)

function GeneralPageDataAdapter:ctor(itemClass, pageSize)
    GeneralPageDataAdapter.super.ctor(self, pageSize)
    self:setItemClass(itemClass)
end

function GeneralPageDataAdapter:getView(position, convertView, parent)
    self:checkData(position)
    local content
    local itemData = self.data[position]
    if not itemData then
        return nil
    end
    if not convertView then
        content = require(self.itemClass).new()
        convertView = parent:newItem(content)
    else
        content = convertView:getContent()
    end
    content:setData(itemData)
    local size = content:getContentSize()
    convertView:setItemSize(size.width, size.height)
    return convertView
end

function GeneralPageDataAdapter:setItemClass(itemClass)
    self.itemClass = itemClass
end

return GeneralPageDataAdapter