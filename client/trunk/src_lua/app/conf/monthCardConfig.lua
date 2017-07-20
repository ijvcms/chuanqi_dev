-- 自动生成，请勿修改 
-- 时间：2016/06/30
-- 21102585@qq.com

local monthCardConfig = class("monthCardConfig")
function monthCardConfig:ctor()
	self.fields = {"key", "goods_id", "price", "usefulLife", "des1", "des2"}
	self.datas = {
		[1] = {1, 110151, 30, "有效期30天", "充值30元即可获得300元宝，次日起每天可领取100绑定元宝", "持续30天，总共获得10倍收益！每月只能购买一次哦！"},

	}
end
return monthCardConfig
