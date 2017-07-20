--
--排行榜左边菜单
--
local RankMenuItem =  class("RankMenuItem", function() return display.newNode() end )

function RankMenuItem:ctor(param)
	self:init(param)
end
--子类只重写这方法
function RankMenuItem:init(param)
	
	local sp
	local fontSize = 20	
	self.type = param.type
	if self.type == SCLIST_TYPE.SCLIST_MENU then
		sp = display.newScale9Sprite("#com_treeBtn2.png", 0, 0,cc.size(165,45))
		self.sp2 = display.newScale9Sprite("#com_treeBtn2Sel.png", 0, 0,cc.size(165,45))
	elseif self.type == SCLIST_TYPE.SCLIST_SUBITEM then
        sp = display.newScale9Sprite("#com_treeBtn3.png", 0, 0,cc.size(156,29))
		self.sp2 = display.newScale9Sprite("#com_treeBtn3Sel.png", 0, 0,cc.size(156,29))
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
            x=self:getContentSize().width/2,
            y=self:getContentSize().height/2})
     display.setLabelFilter(self.name)
     self:addChild(self.name)

     self.select = false
     self.data = param
end

function RankMenuItem:getType()
	return self.type
end

function RankMenuItem:setData(data)
	self.data = data
end

function RankMenuItem:getData()
	return self.data
end

function RankMenuItem:selected(b)
	self.select = b
	self.sp2:setVisible(b)
	if b then
		if self.type == SCLIST_TYPE.SCLIST_MENU then
		    self.name:setColor(cc.c3b(231, 211, 173))
	    elseif self.type == SCLIST_TYPE.SCLIST_SUBITEM then
            self.name:setColor(cc.c3b(0, 255, 13))
	    end
	else
		self.name:setColor(cc.c3b(203, 165, 115))
	end
end

function RankMenuItem:isSelected()
	return self.select
end

function RankMenuItem:clone()
    return RankMenuItem.new(self.data)
end

return RankMenuItem