-- 自动生成，请勿修改 
-- 时间：2017/01/03
-- 21102585@qq.com

local instance_dragonConfig = class("instance_dragonConfig")
function instance_dragonConfig:ctor()
	self.fields = {"id", "description", "stage"}
	self.datas = {
		[1000] = {1000, "消灭1000只怪，刷新二层BOSS", "第一阶段"},
		[2000] = {2000, "消灭2000只怪，刷新三层BOSS", "第二阶段"},
		[3000] = {3000, "消灭3000只怪，刷新二层BOSS", "第三阶段"},
		[4000] = {4000, "消灭4000只怪，刷新三层BOSS", "第四阶段"},
		[999999] = {999999, "大家请尽情刷怪", "阶段结束"},

	}
end
return instance_dragonConfig
