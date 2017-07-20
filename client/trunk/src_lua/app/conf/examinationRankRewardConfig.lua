-- 自动生成，请勿修改 
-- 时间：2016/08/05
-- 21102585@qq.com

local examinationRankRewardConfig = class("examinationRankRewardConfig")
function examinationRankRewardConfig:ctor()
	self.fields = {"id", "reward_list"}
	self.datas = {
		[1] = {1, {{110109,1,1},{110003,1,50},{110219,1,50}}},
		[2] = {2, {{110109,1,1},{110003,1,40},{110219,1,40}}},
		[3] = {3, {{110109,1,1},{110003,1,30},{110219,1,30}}},
		[4] = {4, {{110003,1,20},{110219,1,20}}},
		[5] = {5, {{110219,1,10}}},

	}
end
return examinationRankRewardConfig
