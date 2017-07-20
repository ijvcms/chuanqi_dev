--
-- Author: Yi hanneng
-- Date: 2016-06-22 10:34:27
--

local  GuildWarComfirmWin = GuildWarComfirmWin or class("GuildWarComfirmWin", BaseView)

function GuildWarComfirmWin:ctor(winTag,data,winconfig)
	GuildWarComfirmWin.super.ctor(self,winTag,data,winconfig)
 	self:init()
end

function GuildWarComfirmWin:init()

	self.closeBtn = self:seekNodeByName("btnClose")
  	self.closeBtn:setTouchEnabled(true)
  	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
  	end)
 
  	self.confirmBtn = self:seekNodeByName("confirmBtn")
  	self.confirmBtn:setTouchEnabled(true)
  	self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
        	if not FunctionOpenManager:getFunctionOpenById(72) then
        		  GlobalWinManger:openWin(WinName.GUILDWARWIN)
        	else
        		  GlobalMessage:show("只能与一个行会同时宣战!")
        	end
        end
        return true
  	end)

end

return GuildWarComfirmWin