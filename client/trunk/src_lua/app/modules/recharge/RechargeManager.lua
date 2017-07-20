--
-- Author: Yi hanneng
-- Date: 2016-01-26 09:54:19
--
RechargeManager = RechargeManager or class("RechargeManager", BaseManager)

function RechargeManager:ctor()
	RechargeManager.instance = self
	self.chargeList = {}
	self:setList()
end

function RechargeManager:getInstance()
	if RechargeManager.instance == nil then
		RechargeManager.new()
	end
	return RechargeManager.instance
end

function RechargeManager:setList()
	self.chargeList = configHelper:getChargeList()
end

--需要充值的信息
function RechargeManager:setChargeItemData(data)
	self.data = data;
end

function RechargeManager:getChargeItemData()
	--local gold = self.data.jade--元宝
	local dec = self.data.jade .. "元宝"-- 描述，跟各平台后台配置要一致
	-- if self.data.finish then
	-- 	gold = gold + self.data.common_giving
 --        dec = dec .. self.data.common_desc
	-- else
	-- 	gold = gold + self.data.first_giving --首冲
	-- 	dec = dec .. self.data.giving_desc
	-- end
	return dec, self.data.rmb, self.data.number
end

function RechargeManager:getList()
	return self.chargeList
end

function RechargeManager:handlerChargetList(data)
	GlobalEventSystem:dispatchEvent(RechargeEvent.RECHARGE_LIST,{key_list = data.key_list})
end