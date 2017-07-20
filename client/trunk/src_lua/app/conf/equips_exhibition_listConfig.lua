-- 自动生成，请勿修改 
-- 时间：2016/07/20
-- 21102585@qq.com

local equips_exhibition_listConfig = class("equips_exhibition_listConfig")
function equips_exhibition_listConfig:ctor()
	self.fields = {"key", "name", "function_id"}
	self.datas = {
		[1] = {1, "世界BOSS", 25},
		[2] = {2, "装备打造", 13},
		[3] = {3, "装备强化", 11},
		[4] = {4, "装备铸魂", 69},

	}
end
return equips_exhibition_listConfig
