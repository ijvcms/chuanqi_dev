-- 自动生成，请勿修改 
-- 时间：2017/01/15
-- 21102585@qq.com

local guildConfig = class("guildConfig")
function guildConfig:ctor()
	self.fields = {"key", "exp", "member_limit"}
	self.datas = {
		[1] = {1, 9000, 40},
		[2] = {2, 20000, 45},
		[3] = {3, 60000, 50},
		[4] = {4, 130000, 55},
		[5] = {5, 260000, 60},
		[6] = {6, 520000, 65},
		[7] = {7, 1040000, 70},
		[8] = {8, 2080000, 75},
		[9] = {9, 4160000, 80},
		[10] = {10, 9999999999, 85},

	}
end
return guildConfig
