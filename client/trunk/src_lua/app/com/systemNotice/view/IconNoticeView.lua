--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-25 17:48:57
-- 中间图标通知
local IconNoticeView = class("IconNoticeView", function()
    return display.newNode()
end)

local isShowing = false

function IconNoticeView:ctor(noticeManager)
	self.manager = noticeManager
	self.backFun = nil
	self.isDestory = false
    self.bg = display.newSprite("#scene/scene_popTipsBg.png")
    self.bg:setPosition((display.width)/2,135)
    self:addChild(self.bg)
    self.sp = display.newSprite()
	self.sp:setPosition((display.width)/2,135)
	self:addChild(self.sp)
	self.sp:setTouchEnabled(true)
	self.sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            if self.backFun then
                    self.backFun()
                end
	            self:destory()
	        end     
	        return true
	end)
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function IconNoticeView:onNodeEvent(data)
	--动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
	if data.name == "cleanup" then
       	if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
			self.viewKey = nil
		end
		if self.sp then
		    self.sp:stopAllActions()
		end
		self.backFun = nil
    end
end

function IconNoticeView:destory()
	if self.isDestory == false then 
		self.isDestory = true
		if self.viewKey then 
			self.manager:clearNoticeViewKey(self.viewKey)
			self.viewKey = nil
		end
		if self.sp then
		    self.sp:stopAllActions()
		end
		self.backFun = nil
	    self:removeSelf()
	end
end

function IconNoticeView:show(image,cViewKey,cbackFun)
	self.backFun = cbackFun
	self.viewKey = cViewKey
	self.sp:setSpriteFrame(image)
	self:startShow()
end


function IconNoticeView:startShow()
    local sequence = transition.sequence({
    cc.FadeOut:create(0.6),
    cc.DelayTime:create(0.3),
    cc.FadeIn:create(0.6)
    })
    local repeatAction = cc.RepeatForever:create(sequence)
    self.sp:stopAllActions()
    self.sp:runAction(repeatAction)
end


function IconNoticeView.getShowing()
    return isShowing
end

function IconNoticeView.setShowing(b)
    isShowing = b
end

return IconNoticeView