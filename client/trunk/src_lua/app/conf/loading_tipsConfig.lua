-- 自动生成，请勿修改 
-- 时间：2016/08/08
-- 21102585@qq.com

local loading_tipsConfig = class("loading_tipsConfig")
function loading_tipsConfig:ctor()
	self.fields = {"id", "key"}
	self.datas = {
		[1] = {1, "采集中"},
		[2] = {2, "挖掘中"},
		[3] = {3, "解锁中"},

	}
end
return loading_tipsConfig
