--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 17:03:41
--
local GuildFBInfo = import("..model.GuildFBInfo")
local GuildActivityBase = import(".GuildActivityBase")
local GuildActView_GuildFB = import("..view.GuildActView_GuildFB")
local GuildActivity_GuildFB = class("GuildActivity_GuildFB", GuildActivityBase)

--
-- Virtual override init.
--
function GuildActivity_GuildFB:initialization()
	self._guildFBInfo = nil
end

--
-- Virtual override when run.
--
function GuildActivity_GuildFB:onRun()
	self:registerGlobalEventHandler(GuildEvent.RCV_ACT_GUILD_FB_INFO, function(event)
		self._guildFBInfo = event.data
		self:updateDisplay()
	end)

	GlobalController.guild:requestGuildFBInfo()
	-- self:updateDisplay()
end

--
-- Virtual override when death.
--
function GuildActivity_GuildFB:onDeath(fromView)
	if self.view then
		if fromView then
			self.view:remove()
		else
			self.view:close()
		end
	end

	GuildActivity_GuildFB.super.onDeath(self)
end

function GuildActivity_GuildFB:getGuildFBInfo()
	-- self._guildFBInfo = self._guildFBInfo or {lv = 5, num = 2, open_time = 1453441217, close_time = 1453455617}
	return GuildFBInfo.new(self._guildFBInfo)
end

function GuildActivity_GuildFB:updateDisplay()
	if not self.view then
		self.view = GuildActView_GuildFB.new(self)
		self.view:showAsPopup()
	end

	self.view:invalidateData()
end

return GuildActivity_GuildFB