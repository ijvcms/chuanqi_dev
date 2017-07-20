-- 自动生成，请勿修改 
-- 时间：2016/08/04
-- 21102585@qq.com

local equips_baptiz_change_jadeConfig = class("equips_baptiz_change_jadeConfig")
function equips_baptiz_change_jadeConfig:ctor()
	self.fields = {"key", "min_percent", "max_percent", "jade"}
	self.datas = {
		[1] = {1, 1, 1000, 5},
		[2] = {2, 1001, 2000, 10},
		[3] = {3, 2001, 3000, 15},
		[4] = {4, 3001, 4000, 25},
		[5] = {5, 4001, 5000, 50},
		[6] = {6, 5001, 6000, 150},
		[7] = {7, 6001, 7000, 250},
		[8] = {8, 7001, 8000, 350},
		[9] = {9, 8001, 9000, 450},
		[10] = {10, 9001, 10000, 500},

	}
end
return equips_baptiz_change_jadeConfig
