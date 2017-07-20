--
-- Author: Yi hanneng
-- Date: 2016-01-13 10:27:38
--
local ChatMenuView = class("ChatMenuView", BaseView)

function ChatMenuView:ctor(posX,posY)
 
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:addChild(self.bg)
    self:setTouchEnabled(true)
 
	 local ccui = cc.uiloader:load("resui/sendWin_1.ExportJson")
  	self:addChild(ccui)
    ccui:setPosition(posX,posY)
  	self.btnface = cc.uiloader:seekNodeByName(ccui,"btnface")
  	self.btnbag = cc.uiloader:seekNodeByName(ccui,"btnbag")
  	self.btnrole = cc.uiloader:seekNodeByName(ccui,"btnrole")

  	self.btnface:setTouchEnabled(true)
  	self.btnbag:setTouchEnabled(true)
  	self.btnrole:setTouchEnabled(true)
 
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
           
        elseif event.name == "ended" then
           
            if not cc.rectContainsPoint(ccui:getBoundingBox(), event) then
                self:setVisible(false)
 
            end
            
        end     
        return true
    end)

  	self.btnface:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
           	self:onFaceClick()
        end     
        return true
    end)


  	self.btnbag:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
           	self:onBagClick()
        end     
        return true
    end)


  	self.btnrole:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
           	self:onRoleClick()
        end     
        return true
    end)

end

function ChatMenuView:onFaceClick()
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_OPEN_FACE)
end

function ChatMenuView:onBagClick()
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_OPEN_BAG)
end

function ChatMenuView:onRoleClick()
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_OPEN_ROLE)
end

return ChatMenuView