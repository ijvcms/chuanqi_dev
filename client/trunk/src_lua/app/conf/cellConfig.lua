-- 自动生成，请勿修改 
-- 时间：2016/09/08
-- 21102585@qq.com

local cellConfig = class("cellConfig")
function cellConfig:ctor()
	self.fields = {"key", "min_lv", "max_lv", "cell"}
	self.datas = {
		[1] = {1, 1, 49, 50},
		[2] = {2, 50, 59, 60},
		[3] = {3, 60, 64, 70},
		[4] = {4, 65, 69, 80},
		[5] = {5, 70, 74, 90},
		[6] = {6, 75, 99999, 100},

	}
end
return cellConfig
