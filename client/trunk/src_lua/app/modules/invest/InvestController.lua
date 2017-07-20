--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 投资控制器
InvestController = InvestController or class("InvestController",BaseController)

function InvestController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function InvestController:registerProto()
	self:registerProtocal(30005,handler(self,self.onHandle30005))
	self:registerProtocal(30006,handler(self,self.onHandle30006))
	self:registerProtocal(30007,handler(self,self.onHandle30007))
end

--充值
function InvestController:onHandle30005(data)
	print("onHandle30005")
	dump(data)
	if data.result == 0 then
		local dec,rmb = RechargeManager:getInstance():getChargeItemData()
--		GlobalModel.isPaying = true
		ChannelAPI:pay(data.order_id, rmb, dec, 0, data.pay_type)
		-- data.order_id
		-- data.pay_type
		--GlobalEventSystem:dispatchEvent(InvestEvent.CHONGZHI, data)
	end
	-- <Param name="order_id" type="string"  describe="订单id"/>
	-- <Param name="result" type="int16" describe="0成功，不是0查看错误码"/>
	-- <Param name="pay_type" type="int8"  describe="支付类型,0默认1支付宝11浩宇"/>
end

--投资计划状态
function InvestController:onHandle30006(data)
	print("onHandle30006")
	dump(data)
	if data then 
		GlobalEventSystem:dispatchEvent(InvestEvent.INVEST_LIST, data)
	end
	-- <Param name="type" type="int16"  describe="投资计划类型"/>
	-- <Param name="state_list" type="list" sub_type="proto_invest_state" describe="状态列表"/>
end
--投资领取
function InvestController:onHandle30007(data)
	print("onHandle30007")
	if data.result == 0  then 
		GlobalEventSystem:dispatchEvent(InvestEvent.GET_INVEST, data)
		GlobalMessage:show("领取成功！")
		--<Param name="result" type="int16"  describe="0成功，大于0 错误码"/>
	end
end



-- <Packet proto="30005" type="c2s" name="req_charge" describe="充值">
-- 				<Param name="key" type="int16"  describe="key id"/>
-- 				<Param name="type" type="int16"  describe="类型，1为投资计划"/>
-- 			</Packet>
-- 			<Packet proto="30005" type="s2c" name="rep_charge" describe="充值">
-- 				<Param name="order_id" type="string"  describe="订单id"/>
-- 				<Param name="result" type="int16" describe="0成功，不是0查看错误码"/>
-- 				<Param name="pay_type" type="int8"  describe="支付类型,0默认1支付宝11浩宇"/>
-- 			</Packet>

-- 			<Packet proto="30006" type="c2s" name="req_invest_state" describe="投资计划状态">
-- 				<Param name="type" type="int16"  describe="投资计划类型，1豪华投资，2至尊投资"/>
-- 			</Packet>
-- 			<Packet proto="30006" type="s2c" name="rep_invest_state" describe="投资计划状态">
-- 				<Param name="type" type="int16"  describe="投资计划类型"/>
-- 				<Param name="state_list" type="list" sub_type="proto_invest_state" describe="状态列表"/>
-- 			</Packet>

-- 			<Packet proto="30007" type="c2s" name="req_invest_get" describe="投资领取">
-- 				<Param name="type" type="int16"  describe="投资计划类型，1豪华投资，2至尊投资"/>
-- 				<Param name="key" type="int16"  describe="key"/>
-- 			</Packet>
-- 			<Packet proto="30007" type="s2c" name="rep_invest_get" describe="投资领取">
-- 				<Param name="result" type="int16"  describe="0成功，大于0 错误码"/>
-- 			</Packet>