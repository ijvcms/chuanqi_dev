local ScrollNum = class("ScrollNum", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

function ScrollNum:ctor()	
	self.clipNode = cc.ClippingRegionNode:create()
	self.contentNode = display.newSprite("fonts/powerNumFont.png")
	self.contentNode:setAnchorPoint(0,0)
	self:addChild(self.clipNode)
	self.clipNode:addChild(self.contentNode)
	self.clipNode:setClippingRegion(cc.rect(0, 0, 23, 30))
	self:setNum(1)

	--self.actionSpeed = 0.2
end

function ScrollNum:setNum(num,notAnimation)	
	self.contentNode:stopAllActions()
	local args = {
		time=num*0.1, 
		x=0, 
		y=-(num*30)
	}
	if notAnimation then
		self.contentNode:setPosition(args.x, args.y)
	else
		transition.moveTo(self.contentNode,args)
	end	
end

function ScrollNum:runAction(ac)
	self.contentNode:runAction(ac)
end

-- function ScrollNum:setSpeed(speed)
-- 	self.actionSpeed = speed
-- end

return ScrollNum