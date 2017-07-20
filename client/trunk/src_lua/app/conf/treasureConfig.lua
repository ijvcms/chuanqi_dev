-- 自动生成，请勿修改 
-- 时间：2015/12/10
-- 21102585@qq.com

local treasureConfig = class("treasureConfig")
function treasureConfig:ctor()
	self.fields = {"id", "scene_id", "boss_id", "floor"}
	self.datas = {
		[1] = {1, 20001, 7101, 1},
		[2] = {2, 20001, 7102, 1},
		[3] = {3, 20001, 7103, 1},
		[4] = {4, 20001, 7104, 1},
		[5] = {5, 20001, 7105, 1},
		[6] = {6, 20008, 7106, 2},
		[7] = {7, 20009, 7107, 3},

	}
end
return treasureConfig
