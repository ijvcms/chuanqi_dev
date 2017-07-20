--
-- Author: Yi hanneng
-- Date: 2016-02-26 10:21:59
--
local SaleInfo = SaleInfo or class("SaleInfo")

function SaleInfo:ctor()
	self.sale_id = 0
	self.goods_id = 0
	self.jade = 0
	self.num = 0
	self.time = 0
	self.lv = 0
	self.state = 0 -- 状态 1 已退出，2 出售成功，3 表示已下架,4 已购买
	self.timeLabel = ""
	self.name = ""
end
 
return SaleInfo