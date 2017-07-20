--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-22 16:14:05
--

local QualifyingRuleView = class("QualifyingRuleView", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 100))
end)


function QualifyingRuleView:ctor()
	self:initialization()
end

function QualifyingRuleView:initialization()
	self:initComponents()
end

function QualifyingRuleView:initComponents()

	--富文本内容
	local richStr         = "<font color='0xffd3af' size='18' >1.每天有10次挑战机会。<br />2.战胜比自己排名靠前的玩家可以提升自己的名次。<br />3.每天22点会根据实时排名结算名次奖励并发放。<br />4.名次奖励的声望可以在竞技场商店购买道具。</font>"
	local richTextControl = SuperRichText.new(richStr, 370)
    local bgHeight        = richTextControl:getContentSize().height + 75 + 20

    -- 背景
    -- 描点设置为左下，并居中且拦截鼠标事件。
	local bg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(400, bgHeight),cc.rect(63, 60,1, 1))
	bg:setAnchorPoint(0,0)
	bg:setPosition((display.width - 400) / 2, (display.height - bgHeight) / 2)
	self:addChild(bg)

	--标题
	local title = display.newTTFLabel({text = "排位赛规则", size = 24, color = TextColor.TEXT_O})
	title:setPosition(200, 190)
	--display.setLabelFilter(title)
	bg:addChild(title)

	richTextControl:setPosition(30, 20)

    bg:addChild(richTextControl)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name == "ended" then
    		local rect = cc.rect(bg:getPositionX(), bg:getPositionY(), 400, bgHeight)
    		if not cc.rectContainsPoint(rect, event) then
    			self:removeSelfSafety()
    		end
    	end
    	return true
    end)
end

return QualifyingRuleView