--
-- Author: Your Name
-- Date: 2015-12-10 17:56:13
--
local MayaVo = MayaVo or class("MayaVo")

function MayaVo:ctor()
	self.id = 0
	self.name = ""
	self.time = 0
	self.lv = 0
	self.bossId = 0
end

return MayaVo