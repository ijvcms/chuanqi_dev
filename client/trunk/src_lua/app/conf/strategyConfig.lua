-- 自动生成，请勿修改 
-- 时间：2016/07/22
-- 21102585@qq.com

local strategyConfig = class("strategyConfig")
function strategyConfig:ctor()
	self.fields = {"key", "sort1", "name1", "sort2", "name2", "function_id"}
	self.datas = {
		[1] = {1, 1, "升级之路", 1001, "升级之路", 0},
		[2] = {2, 2, "高手进阶", 2001, "快速升级", 0},
		[3] = {3, 2, "高手进阶", 2002, "装备获取", 0},
		[4] = {4, 2, "高手进阶", 2003, "战力提升", 0},
		[5] = {5, 2, "高手进阶", 2004, "赚钱之道", 0},
		[6] = {6, 3, "特色内容", 3001, "特色玩法", 0},
		[7] = {7, 3, "特色内容", 3002, "高级宠物", 0},
		[8] = {8, 3, "特色内容", 3003, "套装展示", 78},

	}
end
return strategyConfig
