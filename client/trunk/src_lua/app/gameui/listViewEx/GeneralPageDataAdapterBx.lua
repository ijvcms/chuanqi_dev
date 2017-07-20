--
-- Author: Yi hanneng
-- Date: 2016-08-17 10:07:45
--
local GeneralPageDataAdapterEx = import(".GeneralPageDataAdapterEx")
 
local GeneralPageDataAdapterBx = class("GeneralPageDataAdapterBx", GeneralPageDataAdapterEx)
--itemClickFunc:item点击操作
function GeneralPageDataAdapterBx:ctor(layoutFile, itemClass, pageSize, itemClickFunc)

    GeneralPageDataAdapterBx.super.ctor(self, layoutFile, itemClass, pageSize)
    self.itemClickFunc = itemClickFunc
end

function GeneralPageDataAdapterBx:getView(position, convertView, parent)
    self:checkData(position)
    local content
	if not convertView then
		content = require(self.itemClass).new(self.loader, self.layoutFile)
        convertView = parent:newItem(content)
    else
        content = convertView:getContent()
    end
    content:setData(self.data[position])
    local size = content:getContentSize()
    convertView:setItemSize(size.width, size.height)

    if self.itemClickFunc then
    	content:setItemClick(self.itemClickFunc)
    end
    return convertView
end

function GeneralPageDataAdapterBx:destory()
    GeneralPageDataAdapterBx.super.destory(self)
end

function GeneralPageDataAdapterBx:setItemClick(func)
    self.itemClickFunc = itemClickFunc
end
 

return GeneralPageDataAdapterBx