--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-25 20:48:42
-- 文本提示
local TextTipsView = class("TextTipsView", function()
    return display.newNode()
end)

function TextTipsView:ctor(noticeManager)
	self.isDestory = false
	self.manager = noticeManager
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	--self.backFun = 
end

function TextTipsView:onNodeEvent(data)
	--动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
	if data.name == "cleanup" then --"cleanup" then
       	self:removeNodeEventListenersByEvent(cc.NODE_EVENT)
		self.isDestory = true
		if self.bg then self.bg:stopAllActions() end
		if self.label then self.label:stopAllActions() end
		if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
			self.viewKey = nil
		end
    end
end

function TextTipsView:show(cViewKey,param)
	self.viewKey = cViewKey
	if not param or param == "" then self:destory() end
	local color = TextColor.TEXT_R
	local text = param
	if type(param) == "table" then
		color = param.color
		text = param.text
	end
	self.label = display.newTTFLabel({
	    text = text,
	    --font = "simhei",
	    size = 18,
	    color = color
	})
	local width = 344--math.max(344,self.label:getContentSize().width)
	local height = 28--math.max(28,self.label:getContentSize().height)

	self.bg = display.newSprite("common/com_popTipsBg.png")
	self.bg:setPosition(display.cx,display.height-200)
	self:addChild(self.bg)
	self.bg:addChild(self.label)
	self.label:setAnchorPoint(0,0)
	self.label:setPosition((width-self.label:getContentSize().width)/2, (self.bg:getContentSize().height-self.label:getContentSize().height)/2)
	self:setTouchEnabled(false)
	self.bg:setTouchEnabled(false)
	self.label:setTouchEnabled(false)
	self:startShow()
end

function TextTipsView:showNext()
	if self.viewKey then 
		self.manager:clearNoticeViewKey(self.viewKey)
	end
	--显示下一个
	SystemNotice:popTextTips()
end


function TextTipsView:startShow()
	local sequence = transition.sequence({
	    cc.MoveTo:create(0.4, cc.p(display.cx, display.height-self.bg:getContentSize().height-70)),
	    cc.CallFunc:create(function()
	    	self:showNext()
	    end),
	    cc.DelayTime:create(0.5),
	    cc.CallFunc:create(function()
	    	self.bg:fadeOut(0.5)
	    	self.label:fadeOut(0.5)
	    end),
	    cc.DelayTime:create(0.5),
	    cc.CallFunc:create(function()
			self.runActionIng = false
	    	self:destory()
	    end)
	})
	self.bg:runAction(sequence)
end

function TextTipsView:destory()
	if self.isDestory == false then
		self:removeNodeEventListenersByEvent(cc.NODE_EVENT)
		self.isDestory = true
		if self.bg then self.bg:stopAllActions() end
		if self.label then self.label:stopAllActions() end
		if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
			self.viewKey = nil
		end
		if self:getParent() then
		    self:removeFromParent()
		end
	end
end

return TextTipsView