-- 自动生成，请勿修改 
-- 时间：2016/10/12
-- 21102585@qq.com

local city_officerConfig = class("city_officerConfig")
function city_officerConfig:ctor()
	self.fields = {"id", "num", "name", "isshow", "day_reward_goods", "frist_reward_goods", "every_reward_goods"}
	self.datas = {
		[1] = {1, 1, "城主", 1, {{110009,0,500000},{110088,1,1},{110049,1,3}}, {{110008,0,5000}}, {{305010,1,1}}},
		[2] = {2, 1, "副城主", 0, {{110009,0,300000},{110085,1,1},{110049,1,2}}, {}, {}},
		[3] = {3, 3, "大臣", 0, {{110009,0,200000},{110083,1,1},{110049,1,1}}, {}, {}},
		[4] = {4, 999, "成员", 0, {{110009,0,50000},{110081,1,1}}, {}, {}},

	}
end
return city_officerConfig
