--
-- Author: Yi hanneng
-- Date: 2016-09-23 17:07:39
--


local RechargeTips = RechargeTips or class("RechargeTips", BaseView)

function RechargeTips:ctor()
	self.ccui = cc.uiloader:load("resui/tipsWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	
    local size = self.ccui:getContentSize()
    self:setPosition((display.width-size.width)/2,(display.height-size.height)/2)
   	self:init()
end

function RechargeTips:init()
 
	self.tipsText = cc.uiloader:seekNodeByName(self.ccui, "tipsText")
	self.continueBtn = cc.uiloader:seekNodeByName(self.ccui, "continueBtn")
	self.okBtn = cc.uiloader:seekNodeByName(self.ccui, "okBtn")
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")

	self.tipsText:setVisible(false)
   	self.ruleRich = SuperRichText.new(nil,self.tipsText:getContentSize().width)
   	self.ruleRich:setAnchorPoint(0,1)
   	self.tipsText:getParent():addChild(self.ruleRich)
   	self.ruleRich:setPosition(self.tipsText:getPositionX(), self.tipsText:getPositionY() + 10)
 
 	self.continueBtn:setTouchEnabled(true)
    self.continueBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.continueBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.continueBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.RECHARGEWIN)
            if self.callback then
            	self.callback()
            end
            self:removeSelf()
        end
        return true
    end)

    self.okBtn:setTouchEnabled(true)
    self.okBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.okBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.okBtn:setScale(1.0)
            self:removeSelf()
        end
        return true
    end)

    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:removeSelf()
        end
        return true
    end)

    self:setViewInfo()
end

function RechargeTips:setViewInfo()
	
	local vipLv = RoleManager:getInstance().roleInfo.vip
 	if vipLv > 0 then
 		self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..configHelper:getRuleByKey(26).."</font>")
 	else
 		self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..configHelper:getRuleByKey(25).."</font>")
 	end
end

function RechargeTips:setCallBack(func)
	self.callback = func 
end

function RechargeTips:open()
 
end


return RechargeTips