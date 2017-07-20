
--属性变化动画view
local GradientTips = class("GradientTips", function()
	return display.newNode()
end)

local leftWidth = 60
local rightWidth = 60

function GradientTips:ctor(contentSize,color)
	local color = color or cc.c3b(255, 255, 255)
	self:setContentSize(contentSize.width,contentSize.height)
	--self:setAnchorPoint(0.5,0.5)

	self.midLayer = cc.LayerColor:create(cc.c4b(color.r,color.g,color.b,180))
	self.midLayer:setContentSize(contentSize.width,contentSize.height)
	--self.midLayer:setPosition(-contentSize.width/2,-contentSize.height/2)
	self:addChild(self.midLayer)

	self.leftGLayer = cc.LayerGradient:create(cc.c4b(color.r, color.g, color.b, 180), cc.c4b(color.r, color.g, color.b, 0))
	self.leftGLayer:changeWidthAndHeight(leftWidth,contentSize.height)
	self.leftGLayer:setPosition(-leftWidth,0)
	self.leftGLayer:setVector(cc.p(-1.0,0))
	self:addChild(self.leftGLayer)

	self.rightGLayer = cc.LayerGradient:create(cc.c4b(color.r, color.g, color.b, 180), cc.c4b(color.r, color.g, color.b, 0))
	self.rightGLayer:changeWidthAndHeight(rightWidth,contentSize.height)
	self.rightGLayer:setPosition(contentSize.width,0)
	self.rightGLayer:setVector(cc.p(1.0,0))
	self:addChild(self.rightGLayer)
end

function GradientTips:getLeftWidth()
	return leftWidth
end

function GradientTips:getRightWidth()
	return rightWidth
end

-- function GradientTips:childRunAction(ac)
-- 	-- self.midLayer:runAction(ac)
-- 	-- self.leftGLayer:runAction(ac)
-- 	-- self.rightGLayer:runAction(ac)
-- end

function GradientTips:fadeOut(time)
	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	self.midLayer:runAction(cc.FadeOut:create(time))
	self.fadeOutSche = scheduler.scheduleUpdateGlobal(function()
		self.leftGLayer:setStartOpacity(self.midLayer:getOpacity())
		self.rightGLayer:setStartOpacity(self.midLayer:getOpacity())
	end)
end

function GradientTips:unScheFadeOut()
	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	if self.fadeOutSche then
		scheduler.unscheduleGlobal(self.fadeOutSche)
		self.fadeOutSche = nil
	end
end

return GradientTips