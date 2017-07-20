-- 自动生成，请勿修改 
-- 时间：2017/01/16
-- 21102585@qq.com

local guild_activity_bossConfig = class("guild_activity_bossConfig")
function guild_activity_bossConfig:ctor()
	self.fields = {"id", "monster_id", "guild_lv", "open_time", "close_time", "act_id"}
	self.datas = {
		[1] = {1, 7321, 2, "00:00", "23:40", 1},
		[2] = {2, 7322, 4, "00:00", "23:40", 2},
		[3] = {3, 7323, 6, "00:00", "23:40", 3},
		[4] = {4, 7324, 8, "00:00", "23:40", 6},
		[5] = {5, 7325, 10, "00:00", "23:40", 7},

	}
end
return guild_activity_bossConfig
