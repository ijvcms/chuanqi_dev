-- 自动生成，请勿修改 
-- 时间：2016/05/18
-- 21102585@qq.com

local guild_donationConfig = class("guild_donationConfig")
function guild_donationConfig:ctor()
	self.fields = {"key", "content", "consume_type", "consume_value", "vip_limit", "contribution", "guild_exp", "guild_capital"}
	self.datas = {
		[1] = {1, "初级", 1, 100000, 0, 100, 100, 100},
		[2] = {2, "中级", 2, 10, 1, 200, 200, 200},
		[3] = {3, "高级", 2, 50, 2, 1000, 1000, 1000},

	}
end
return guild_donationConfig
