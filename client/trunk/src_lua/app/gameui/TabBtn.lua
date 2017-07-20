--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-12 17:43:50
-- 导航按钮

local TabBtn = class("TabBtn", function()
	return display.newNode() 
end)


function TabBtn.create(param)
	return TabBtn.new(param)
end

function TabBtn:ctor(param)
	
	local label = param.label or ""
	local selImage = param.selImage or "#com_tabBtn1Sel.png"
	local image = param.image or "#com_tabBtn1.png"
	local fontSize = param.fontSize or 20
	self.width = param.width or 98
	self.height = param.height or 62

	self.select = false
	self.data = param.data

	local textColor = param.textColor or UiColorType.BTN_LAB1
	--self:setTouchSwallowEnabled(true)
	self:setTouchEnabled(true)
	if image and image ~= "" then
		self.imageSp = display.newSprite(image)
		self:addChild(self.imageSp)
		--self.imageSp:setPosition(self.width/2,45/2)
	end
	if selImage and selImage ~= "" then
		self.selImageSp = display.newSprite(selImage)
		self:addChild(self.selImageSp)
		--self.selImageSp:setPosition(self.width/2,50/2)
	end
	if label and label ~= "" then
		--local size = self:getContentSize()
		self.text = display.newTTFLabel({
    	  	text = label or " ",    	
    	  	size = fontSize,
    	  	color = textColor,
    	  	-- align = cc.TEXT_ALIGNMENT_LEFT,
    	  	-- dimensions = cc.size(600, 60)
	  	})
    	self:addChild(self.text)
    	self.text:setTouchEnabled(false)
	end
 	self:setSelect(self.select)
end	

function TabBtn:setSelect(booble)
	self.select = booble
	if self.select then
		self.imageSp:setVisible(false)
		self.selImageSp:setVisible(true)
	else
		self.imageSp:setVisible(true)
		self.selImageSp:setVisible(false)
	end	
end

function TabBtn:getSelect()
	return self.select
end

function TabBtn:setLabel(str)
	if self.text then
		self.text:setString(str)
	end	
end

function TabBtn:setLabelColor(color)
	if self.text then
		self.text:setColor(color)
	end	
end


return TabBtn