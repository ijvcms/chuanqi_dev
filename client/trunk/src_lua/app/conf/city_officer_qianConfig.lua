-- 自动生成，请勿修改 
-- 时间：2015/12/24
-- 21102585@qq.com

local city_officer_qianConfig = class("city_officer_qianConfig")
function city_officer_qianConfig:ctor()
	self.fields = {"id", "officer_id", "name"}
	self.datas = {
		[1] = {1, 2, "副城主"},
		[2] = {2, 3, "大臣"},
		[3] = {3, 3, "大臣"},
		[4] = {4, 3, "大臣"},

	}
end
return city_officer_qianConfig
