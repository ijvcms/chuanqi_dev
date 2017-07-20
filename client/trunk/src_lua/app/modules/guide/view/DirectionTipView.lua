--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-12 11:13:13
--
local DirectionTipView = class("DirectionTipView", function()
	local node = display.newNode()
	node:setTouchCaptureEnabled(true)
	return node
end)

local DirectionPosFactor = {
	cc.p(0,   -0.5),
	cc.p(0,    0.5),
	cc.p(0.5,  0),
	cc.p(-0.5, 0),
}

local DirectionRotate = {0, 180, 270, 90}

function DirectionTipView:ctor(direction, tipText)
	self._direction = direction
	self._tipText = tipText
	self:initialization()
end

function DirectionTipView:initialization()
	local factor = DirectionPosFactor[self._direction]
	local rotate = DirectionRotate[self._direction]

	-- arrow default direction is up
	local arrow = display.newSprite("common/guide/img_guide_arrow.png")
	local arrowSize = arrow:getContentSize()

	-- 这里要颠倒
	arrowSize = cc.size(arrowSize.height, arrowSize.width)

	local arrowPos = cc.p(arrowSize.width * factor.x, arrowSize.width * factor.y)
	arrow:setRotation(rotate)
	arrow:setPosition(arrowPos.x, arrowPos.y)

	-- layout textPannel
	local textPannel = self:createTextPannel()
	local textSize  = textPannel:getContentSize()
	textPannel:setPosition(textSize.width * factor.x + (arrowPos.x * 2), textSize.height * factor.y + (arrowPos.y * 2))
	-- textPannel

	self:addChild(textPannel)
	self:addChild(arrow)
end

function DirectionTipView:createTextPannel()
	local pannel = display.newNode()

	local textLabel = SuperRichText.new(self._tipText, 300)
	-- textLabel:renderXml("<font color='0xffd3af' size='18' >1.每天有10次挑战机会。<br />2.战胜比自己排名靠前的玩家可以提升自己的名次。<br />3.每天22点会根据实时排名结算名次奖励并发放。<br />4.名次奖励的声望可以在竞技场商店购买道具。</font>")
	local size   = textLabel:getContentSize()
	local bgSize = cc.size(size.width + 20, size.height + 18)
	local textBg = display.newScale9Sprite("common/guide/img_guide_tip_bg.png", 0, 0, bgSize)

	textLabel:setAnchorPoint(cc.p(.5, .5))

	pannel:addChild(textBg)
	pannel:addChild(textLabel)
	pannel:setContentSize(bgSize)

	return pannel
end


return DirectionTipView