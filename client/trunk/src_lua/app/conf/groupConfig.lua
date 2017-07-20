-- 自动生成，请勿修改 
-- 时间：2016/09/02
-- 21102585@qq.com

local groupConfig = class("groupConfig")
function groupConfig:ctor()
	self.fields = {"key", "exp", "member_limit"}
	self.datas = {
		[1] = {1, 9000, 40},
		[2] = {2, 20000, 45},
		[3] = {3, 60000, 50},
		[4] = {4, 130000, 55},
		[5] = {5, 9999999999, 60},

	}
end
return groupConfig
