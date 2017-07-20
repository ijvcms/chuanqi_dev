-- 自动生成，请勿修改 
-- 时间：2017/01/03
-- 21102585@qq.com

local instance_dragon_nativeConfig = class("instance_dragon_nativeConfig")
function instance_dragon_nativeConfig:ctor()
	self.fields = {"id", "description", "stage"}
	self.datas = {
		[1000] = {1000, "消灭1000只怪，刷新终极BOSS", "第一阶段"},
		[2000] = {2000, "消灭2000只怪，刷新终极BOSS", "第二阶段"},
		[999999] = {999999, "大家请尽情刷怪", "阶段结束"},

	}
end
return instance_dragon_nativeConfig
