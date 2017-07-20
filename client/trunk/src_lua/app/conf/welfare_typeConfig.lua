-- 自动生成，请勿修改 
-- 时间：2016/02/29
-- 21102585@qq.com

local welfare_typeConfig = class("welfare_typeConfig")
function welfare_typeConfig:ctor()
	self.fields = {"id", "name", "is_open"}
	self.datas = {
		[1] = {1, "7天登陆礼包", 1},
		[2] = {2, "在线礼包", 1},

	}
end
return welfare_typeConfig
