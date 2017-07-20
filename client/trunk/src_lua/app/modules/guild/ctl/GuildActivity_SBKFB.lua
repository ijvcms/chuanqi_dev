--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 17:04:00
--

local GuildFBInfo = import("..model.SBKFBInfo")
local GuildActView_SBKFB = import("..view.GuildActView_SBKFB")
local GuildActivityBase = import(".GuildActivityBase")
local GuildActivity_SBKFB = class("GuildActivity_SBKFB", GuildActivityBase)

--
-- Virtual override init.
--
function GuildActivity_SBKFB:initialization()
	self._SBKFBInfo = nil
end

--
-- Virtual override when run.
--
function GuildActivity_SBKFB:onRun()
	self:registerGlobalEventHandler(GuildEvent.RCV_ACT_SBK_FB_INFO, function(event)
		self._SBKFBInfo = event.data
		self:updateDisplay()
	end)

	GlobalController.guild:requestSBKFBInfo()
	-- self:updateDisplay()
end

--
-- Virtual override when death.
--
function GuildActivity_SBKFB:onDeath(fromView)
	if self.view then
		if fromView then
			self.view:remove()
		else
			self.view:close()
		end
	end

	GuildActivity_SBKFB.super.onDeath(self)
end

function GuildActivity_SBKFB:getSBKFBInfo()
	-- self._SBKFBInfo = self._SBKFBInfo or {sbk_name = "蛤蛤", lv = 2, state = 1, timestamp = 30}
	return GuildFBInfo.new(self._SBKFBInfo)
end

function GuildActivity_SBKFB:updateDisplay()
	if not self.view then
		self.view = GuildActView_SBKFB.new(self)
		self.view:showAsPopup()
	end

	self.view:invalidateData()
end

return GuildActivity_SBKFB