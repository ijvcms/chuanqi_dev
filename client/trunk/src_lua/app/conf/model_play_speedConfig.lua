-- 自动生成，请勿修改 
-- 时间：2016/09/08
-- 21102585@qq.com

local model_play_speedConfig = class("model_play_speedConfig")
function model_play_speedConfig:ctor()
	self.fields = {"id", "attack", "attack1", "stand", "walk", "dead"}
	self.datas = {
		[1000] = {1000, 1.3, 1, 1, 1, 1},
		[2000] = {2000, 1, 1, 1, 1, 1},
		[3000] = {3000, 1, 1, 1, 1, 1},

	}
end
return model_play_speedConfig
