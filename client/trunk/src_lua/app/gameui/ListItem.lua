--
-- Author: Yi hanneng
-- Date: 2016-01-19 20:26:31
--
local ListItem = ListItem or class("ListItem", function() return display.newNode() end )

function ListItem:ctor(param)
	self:init(param)
end
--子类只重写这方法
function ListItem:init(param)
	local sp = display.newSprite(param.res)
    local scale = param.scale or 1
    sp:setScaleX(scale)
    sp:setPosition(sp:getContentSize().width*scale/2,sp:getContentSize().height/2)
  	self:addChild(sp)
    self:setContentSize(cc.size(sp:getContentSize().width*scale, sp:getContentSize().height))
    local name = display.newTTFLabel({
            text=param.name,
            color = param.color,
            x=self:getContentSize().width/2,
            y=self:getContentSize().height/2})
     display.setLabelFilter(name)
     self:addChild(name)

     self.select = false
     self.type = param.type
     self.data = param
end

function ListItem:getType()
	return self.type
end

function ListItem:setData(data)
	self.data = data
end

function ListItem:getData()
	return self.data
end

function ListItem:selected(b)
	self.select = b
end

function ListItem:isSelected()
	return self.select
end

function ListItem:clone()
    return ListItem.new(self.data)
end

return ListItem