--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-30 17:05:02
--
local FunctionOpenTipView = class("FunctionOpenTipView", function()
	return display.newNode()
end)

function FunctionOpenTipView:ctor(func_data)
	self.func_data = func_data or{}
	self:initialization()
end

function FunctionOpenTipView:initialization()
	local container = display.newNode()
	local img_bg = display.newScale9Sprite("#com_panelBg4.png", 0, 0, cc.size(200,160),cc.rect(25, 25,1, 1))
--display.newSprite("#com_panelBg4.png")
	local img_icon = display.newSprite("#" .. (self.func_data.icon_file or "") )
	local lbl_text = display.newTTFLabel({
		text = "开启" .. (self.func_data.name or "error"),
		size = 22,
		color = TextColor.TEXT_Y
	}):align(display.CENTER,0,0)

	img_icon:setPositionY(20)
	lbl_text:setPositionY(-50)

	container:center()
	container:addChild(img_bg)
	container:addChild(img_icon)
	container:addChild(lbl_text)
	
	self:addChild(container)
	self:setCascadeOpacityEnabled(true)
	container:setCascadeOpacityEnabled(true)
end

function FunctionOpenTipView:show()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, self)
	local action = transition.sequence({
		cca.fadeIn(.2),
		cca.delay(2),
		cca.fadeOut(.2),
		cca.removeSelf(),
	})
	self:runAction(action)
end


return FunctionOpenTipView