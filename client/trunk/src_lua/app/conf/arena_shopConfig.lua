-- 自动生成，请勿修改 
-- 时间：2016/05/18
-- 21102585@qq.com

local arena_shopConfig = class("arena_shopConfig")
function arena_shopConfig:ctor()
	self.fields = {"key", "limit_count", "goods_id", "reputation"}
	self.datas = {
		[1] = {1, 10, 110049, 10},
		[2] = {2, 100, 110078, 2},
		[3] = {3, 10, 110055, 20},
		[4] = {4, 10, 110079, 10},

	}
end
return arena_shopConfig
