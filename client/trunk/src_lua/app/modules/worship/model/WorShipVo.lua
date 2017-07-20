--
-- Author: Yi hanneng
-- Date: 2016-01-11 15:17:23
--
local WorShipVo = WorShipVo or class("WorShipVo")

function WorShipVo:ctor()
	self.sex = 0
	self.career = 0
	self.name = ""
	self.fight = 0
	self.player_id = 0
end

return WorShipVo