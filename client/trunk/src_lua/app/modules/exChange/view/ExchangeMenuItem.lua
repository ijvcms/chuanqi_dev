--
-- Author: zhangshunqiu
-- Date: 2017-5-22 17:53:58
--
local ExchangeMenuItem = ExchangeMenuItem or class("ExchangeMenuItem", function() return display.newNode() end )

function ExchangeMenuItem:ctor(param)
	self:init(param)
end
--子类只重写这方法
function ExchangeMenuItem:init(param)
	
	local sp
	local fontSize = 20	
	self.resType = param.resType
	if self.resType == 1 then
		sp = display.newSprite("#com_treeBtn1.png")
		self.sp2 = display.newSprite("#com_treeBtn1Sel.png")
	elseif self.resType == 2 then
		sp = display.newSprite("#com_treeBtn2.png")--display.newScale9Sprite("#com_treeBtn2.png", 0, 0,cc.size(165,45))
		self.sp2 = display.newSprite("#com_treeBtn2Sel.png") --display.newScale9Sprite("#com_treeBtn2Sel.png", 0, 0,cc.size(165,45))
	elseif self.resType == 3 then
		sp = display.newSprite("#com_treeBtn3.png") --display.newScale9Sprite("#com_treeBtn3.png", 0, 0,cc.size(156,29))
		self.sp2 = display.newSprite("#com_treeBtn3Sel.png")--display.newScale9Sprite("#com_treeBtn3Sel.png", 0, 0,cc.size(156,29))
		fontSize = 18
	end

    sp:setPosition(sp:getContentSize().width/2,sp:getContentSize().height/2)
    self.sp2:setPosition(sp:getPositionX(), sp:getPositionY())
  	self.sp2:setVisible(false)
  	self:addChild(sp)
  	self:addChild(self.sp2)
    self:setContentSize(cc.size(sp:getContentSize().width, sp:getContentSize().height))
    self.name = display.newTTFLabel({
            text=param.name,
            color = cc.c3b(203, 165, 115),
            size = fontSize,
            x=self:getContentSize().width/2 - 20,
            y=self:getContentSize().height/2})
     display.setLabelFilter(self.name)
     self:addChild(self.name)

     self.select = false
     self.type = param.type
     self.data = param
end

function ExchangeMenuItem:getType()
	return self.type
end

function ExchangeMenuItem:setData(data)
	self.data = data
end

function ExchangeMenuItem:getData()
	return self.data
end

function ExchangeMenuItem:selected(b)
	self.select = b
	self.sp2:setVisible(b)
	if b then
		self.name:setColor(cc.c3b(231, 211, 173))
	else
		self.name:setColor(cc.c3b(203, 165, 115))
	end
end

function ExchangeMenuItem:isSelected()
	return self.select
end

function ExchangeMenuItem:clone()
    return ExchangeMenuItem.new(self.data)
end

return ExchangeMenuItem