--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 16:56:38
--
local GuildActivityBase  = import(".GuildActivityBase")
local GuildActView_Boss = import("..view.GuildActView_Boss")
local GuildActivity_Boss = class("GuildActivity_Boss", GuildActivityBase)

--
-- Virtual override init.
--
function GuildActivity_Boss:initialization()
end

--
-- Virtual override when run.
--
function GuildActivity_Boss:onRun()
	self.view = GuildActView_Boss.new(self)
	self.view:showAsPopup()
end

--
-- Virtual override when death.
--
function GuildActivity_Boss:onDeath(fromView)
	if self.view then
		if fromView then
			self.view:remove()
		else
			self.view:close()
		end
	end

	GuildActivity_Boss.super.onDeath(self)
end

--
-- 获得BOSS列表。
--
function GuildActivity_Boss:getBossList()
	return configHelper:getGuildActBossList()
end

return GuildActivity_Boss