--
-- Author: Yi hanneng
-- Date: 2016-06-23 10:47:40
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local  GuildWarResultWin = GuildWarResultWin or class("GuildWarResultWin", BaseView)

function GuildWarResultWin:ctor(winTag,data,winconfig)

	GuildWarResultWin.super.ctor(self,winTag,data,winconfig)
  	self:getRoot():setPosition((display.width-960)/2,(display.height-640)/2)
 	self:init()

end

function GuildWarResultWin:init()

	self.unionName1 = self:seekNodeByName("unionName1")
	self.killNum1 = self:seekNodeByName("killNum1")
	self.unionName2 = self:seekNodeByName("unionName2")
	self.killNum2 = self:seekNodeByName("killNum2")
	self.timeLabel = self:seekNodeByName("timeLabel")

	self.closeBtn = self:seekNodeByName("closeBtn")
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
 
end

function GuildWarResultWin:setViewInfo(data)

	self.data = data
	self.unionName1:setString(data.guild_name_a)
	self.killNum1:setString(data.kill_a)
	self.unionName2:setString(data.guild_name_b)
	self.killNum2:setString(data.kill_b)
 
	self:startTimer()
end

function GuildWarResultWin:onTimerHandler()
	
	if GlobalController.guild.guildWarInfo then
		GlobalController.guild.guildWarInfo.time_left=GlobalController.guild.guildWarInfo.time_left - 1
		if GlobalController.guild.guildWarInfo.time_left <= 0 then
			GlobalController.guild.guildWarInfo.time_left = 0
			self:clearTimer()
		end
		self.timeLabel:setString(string.format("剩余时间 %s", StringUtil.convertTime2(GlobalController.guild.guildWarInfo.time_left)))
	end
	
end

function GuildWarResultWin:startTimer()
	self:clearTimer()
 
	if GlobalController.guild.guildWarInfo and GlobalController.guild.guildWarInfo.time_left > 0 then
		self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 2)
		self:onTimerHandler()
 
	end
end	

function GuildWarResultWin:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end


function GuildWarResultWin:open()
	self.registerEventId = {}
	local function onGetInfo(data)
    	self:setViewInfo(data.data)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_WAR_INFO,onGetInfo)
	
	if GlobalController.guild.guildWarInfo ~= nil then
		self:setViewInfo(GlobalController.guild.guildWarInfo)
	end
end

function GuildWarResultWin:close()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
    self:clearTimer()
end

function GuildWarResultWin:destory()

	self:close()
	GuildWarResultWin.super.destory(self)

end

return GuildWarResultWin