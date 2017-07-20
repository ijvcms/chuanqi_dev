-- 自动生成，请勿修改 
-- 时间：2016/05/18
-- 21102585@qq.com

local goods_typeConfig = class("goods_typeConfig")
function goods_typeConfig:ctor()
	self.fields = {"key", "type", "sub_type", "cd_time", "cd"}
	self.datas = {
		[1] = {1, 4, 3, 2, 5},
		[2] = {2, 4, 2, 1, 1},
		[3] = {3, 4, 5, 2, 5},

	}
end
return goods_typeConfig
