-- 自动生成，请勿修改 
-- 时间：2016/11/14
-- 21102585@qq.com

local equips_soul_plusConfig = class("equips_soul_plusConfig")
function equips_soul_plusConfig:ctor()
	self.fields = {"key", "modulus", "name"}
	self.datas = {
		[0] = {0, 0, "无"},
		[1] = {1, 0.15, "黄铜"},
		[2] = {2, 0.3, "白银"},
		[3] = {3, 0.4, "黄金"},
		[4] = {4, 0.5, "铂金"},
		[5] = {5, 0.6, "钻石"},
		[6] = {6, 0.7, "红钻"},
		[7] = {7, 0.8, "皇冠"},

	}
end
return equips_soul_plusConfig
