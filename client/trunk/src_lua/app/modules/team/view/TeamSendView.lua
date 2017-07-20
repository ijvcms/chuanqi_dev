--
-- Author: Yi hanneng
-- Date: 2016-04-07 14:50:52
--
local TeamSendView = TeamSendView or class("TeamSendView", function() return display.newNode()end)

function TeamSendView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/teamSendWin.ExportJson")
  	self:addChild(self.ccui)
   	local size = self.ccui:getContentSize()
  	self.ccui:setPosition((display.width - size.width)/2,(display.height - size.height)/2)

   	self:init()

end

function TeamSendView:init()
	self.btnCancel = cc.uiloader:seekNodeByName(self.ccui, "btnCancel")
	self.btnConfirm = cc.uiloader:seekNodeByName(self.ccui, "btnConfirm")
	 
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(367, 24),
          --listener = onEdit,
          fontSize = 20,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(367, 20)
        })
    
    self.ccui:addChild(self.inputLab)
    self.inputLab:setAnchorPoint(0,0.5)
    self.inputLab:setPosition(25, 180)
   -- self.inputLab:setFontSize(20)
    self.inputLab:setMaxLength(22)
    self.inputLab:setPlaceHolder("邀请有志之士一起组队，快来加入呀！")
 

    self.btnCancel:setTouchEnabled(true)
	self.btnConfirm:setTouchEnabled(true)

	 self.btnCancel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnCancel:setScale(1.1)
        elseif event.name == "ended" then
            self.btnCancel:setScale(1)
 			self:destory() 
 
        end
        return true
    end)

	  self.btnConfirm:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnConfirm:setScale(1.1)
        elseif event.name == "ended" then
            self.btnConfirm:setScale(1)
 			self:send()
        end
        return true
    end)

end

function TeamSendView:send()
	if self.inputLab:getText() == "" then
		GlobalController.chat:pushTeamMsg("邀请有志之士一起组队，快来加入呀！")
	else
    local s = StringUtil:replaceStr(self.inputLab:getText(),configHelper:getSensitiveWord())
		GlobalController.chat:pushTeamMsg(s)
	end
	--GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_SEND_TEAM, RoleManager:getInstance().roleInfo.teamId)
	self:destory()
end
 
function TeamSendView:destory()

	self:removeSelf()
end

return TeamSendView