--
-- Author: Yi hanneng
-- Date: 2016-09-23 18:21:35
--

local LocalDatasManager = require("common.manager.LocalDatasManager")
local ZFTips = ZFTips or class("ZFTips", BaseView)

function ZFTips:ctor()
	self.ccui = cc.uiloader:load("resui/tipsMountWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	local size = self.ccui:getContentSize()
    self:setPosition((display.width-size.width)/2,(display.height-size.height)/2)
   	self:init()
end

function ZFTips:init()
 
	self.CheckBox = cc.uiloader:seekNodeByName(self.ccui, "CheckBox")
	self.continueBtn = cc.uiloader:seekNodeByName(self.ccui, "continueBtn")
	self.okBtn = cc.uiloader:seekNodeByName(self.ccui, "okBtn")
	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
 
 
 	self.continueBtn:setTouchEnabled(true)
    self.continueBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.continueBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.continueBtn:setScale(1.0)
            self:setCheck()
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
            if self.callback then
            	self.callback()
            end
            self:setCheck()
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
            self:setCheck()
            self:removeSelf()
        end
        return true
    end)
    
    local b = LocalDatasManager:getLocalData("ZF_TIP")

    if b ~= nil then
    	self.CheckBox:setButtonSelected(b.selected)
    end
	
end

function ZFTips:setCallBack(func)
	self.callback = func 
end

function ZFTips:setCheck()
	local data = {
           selected =  self.CheckBox:isButtonSelected()
    }
	LocalDatasManager:saveLocalData(data, "ZF_TIP")
end

function ZFTips:open()
 
end


return ZFTips