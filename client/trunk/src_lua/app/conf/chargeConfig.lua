-- 自动生成，请勿修改 
-- 时间：2016/06/17
-- 21102585@qq.com

local chargeConfig = class("chargeConfig")
function chargeConfig:ctor()
	self.fields = {"key", "jade", "first_giving", "common_giving", "giving_desc", "common_desc", "rmb", "icon", "markIcon", "number"}
	self.datas = {
		[1] = {1, 100, 0, 0, "", "", 30, "charge_monthCard", "chargeLimit", 1},
		[2] = {2, 60, 60, 0, "首次充值返利60元宝", "", 6, "coin2", "chargeDouble", 2},
		[3] = {3, 250, 250, 0, "首次充值返利250元宝", "", 25, "coin3", "chargeDouble", 3},
		[4] = {4, 680, 680, 0, "首次充值返利680元宝", "", 68, "coin4", "chargeDouble", 4},
		[5] = {5, 980, 980, 0, "首次充值返利980元宝", "", 98, "coin5", "chargeDouble", 5},
		[6] = {6, 3280, 3280, 0, "首次充值返利3280元宝", "", 328, "coin6", "chargeDouble", 7},
		[7] = {7, 6480, 6480, 0, "首次充值返利6480元宝", "", 648, "coin6", "chargeDouble", 8},
		[8] = {8, 19980, 19980, 0, "首次充值返利19980元宝", "", 1998, "coin6", "chargeDouble", 9},
		[9] = {9, 1980, 1980, 0, "首次充值返利1980元宝", "", 198, "coin5", "chargeDouble", 6},

	}
end
return chargeConfig
