-- 自动生成，请勿修改 
-- 时间：2016/10/12
-- 21102585@qq.com

local dreamland_rankConfig = class("dreamland_rankConfig")
function dreamland_rankConfig:ctor()
	self.fields = {"id", "type", "des", "pic", "goods"}
	self.datas = {
		[1] = {1, 1, "", "rank1.png", {{110318,0,5}}},
		[2] = {2, 1, "", "rank2.png", {{110318,0,4}}},
		[3] = {3, 1, "", "rank3.png", {{110318,0,3}}},
		[4] = {4, 1, "第4名", "", {{110318,0,1}}},
		[5] = {5, 1, "第5名", "", {{110318,0,1}}},
		[6] = {6, 1, "第6名", "", {{110318,0,1}}},
		[7] = {7, 2, "", "rank1.png", {{110008,0,1500}}},
		[8] = {8, 2, "", "rank2.png", {{110008,0,800}}},
		[9] = {9, 2, "", "rank3.png", {{110008,0,500}}},

	}
end
return dreamland_rankConfig
