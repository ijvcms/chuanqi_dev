--高性能通用PageDataAdapter，加快加载ccsui
--@author shine

local GeneralPageDataAdapter = import(".GeneralPageDataAdapter")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")

local GeneralPageDataAdapterEx = class("GeneralPageDataAdapter", GeneralPageDataAdapter)

function GeneralPageDataAdapterEx:ctor(layoutFile, itemClass, pageSize)
    GeneralPageDataAdapterEx.super.ctor(self, itemClass, pageSize)
    self.loader = GameUILoaderUtils.new()
    self:setFile(layoutFile)
end

function GeneralPageDataAdapterEx:getView(position, convertView, parent)
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
    return convertView
end

function GeneralPageDataAdapterEx:setFile(layoutFile)
    if not self.loader then
        self.loader = GameUILoaderUtils.new()
    end
    self.loader:AddUIEditorCache(layoutFile)
    self.layoutFile = layoutFile
end

function GeneralPageDataAdapterEx:destory()
    GeneralPageDataAdapterEx.super.destory(self)
    if self.loader then
        self.loader:Clear()
        self.loader = nil
    end
   
end

return GeneralPageDataAdapterEx