-- 自动生成，请勿修改 
-- 时间：2016/08/12
-- 21102585@qq.com

local equips_baptize_lockConfig = class("equips_baptize_lockConfig")
function equips_baptize_lockConfig:ctor()
	self.fields = {"lock", "cost"}
	self.datas = {
		[0] = {0, 0},
		[1] = {1, 2},
		[2] = {2, 4},
		[3] = {3, 6},
		[4] = {4, 8},
		[5] = {5, 10},

	}
end
return equips_baptize_lockConfig
