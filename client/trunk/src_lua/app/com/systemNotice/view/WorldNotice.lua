--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-25 22:13:02
-- 游戏世界通知
local WorldNotice = class("WorldNotice", function()
	return display.newNode()
end)

function WorldNotice:ctor(noticeManager,cViewKey,tipsString)
	self.manager = noticeManager
	self.viewKey = cViewKey
	if not tipsString or tipsString == "" then return end
	self.defWidth = 620
	self.defHeight = 28
	self.bg = display.newSprite("#scene/scene_popTipsBg.png")
	self.bg:setScaleX(self.defWidth/344)
	self:setPosition(display.cx,display.height-30)
	self:addChild(self.bg)
	--遮罩
	self.clip = cc.ClippingRegionNode:create()
    self.clip:setPosition(0-self.defWidth/2,-18)
    self:addChild(self.clip)
    self.contentTxt = SuperRichText.new(tipsString)
    self.contentTxt:setNodeEventEnabled(false)
    self.clip:addChild(self.contentTxt)
    self.clip:setClippingRegion(cc.rect(0, 0, self.defWidth, self.defHeight+12))
    self.acSpeed = 80
    self:play()
end

function WorldNotice:play()
	self.contentTxt:setPositionY(8)
    self.contentTxt:setPositionX(self.defWidth)
	local acTime = (self.contentTxt:getContentSize().width+self.defWidth+10)/self.acSpeed
	local function rtAc()
		local sequence = transition.sequence({
			cc.MoveTo:create(acTime, cc.p(-self.contentTxt:getContentSize().width-10,self.contentTxt:getPositionY())),
			cc.CallFunc:create(function()
				self:showNext()
		    end)
		})
		return sequence
	end
	self.contentTxt:stopAllActions()
	self.contentTxt:runAction(rtAc())
end

function WorldNotice:reuse(tipsString)
	self.contentTxt:renderXml(tipsString)
	self:play()
end


function WorldNotice:showNext()
	--显示下一个
	SystemNotice:showWorldNotice()
end

function WorldNotice:destory()
	if self.viewKey then 
		self.manager:clearNoticeViewKey(self.viewKey)
	end
	if self.contentTxt then
	    self.contentTxt:stopAllActions()
	end
    self:removeSelf()
end

return WorldNotice
