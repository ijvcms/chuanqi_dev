--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 幸运转盘控制器
TreasureController = TreasureController or class("TreasureController",BaseController)

function TreasureController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()
	self.is_open = 0 
	self.curBuyItemId = 0

	self.bugTimes = 0 --剩余购买次数
	self.refreshTime = 100 --剩余刷新时间（秒）
	self.refreshNeedJade = 1000 --刷新神秘商店需要的元宝
	self.shopList= {}
end


function TreasureController:registerProto()
	self:registerProtocal(16100,handler(self,self.onHandle16100))
	self:registerProtocal(16101,handler(self,self.onHandle16101))
	self:registerProtocal(16102,handler(self,self.onHandle16102))
end

-- <Param name="mystery_shop_id" type="int16" describe="神秘商品id"/>
-- 			<Param name="goods_id" type="int32" describe="道具id"/>
-- 			<Param name="is_bind" type="int8" describe="是否绑定 0非绑 1绑定"/>
-- 			<Param name="num" type="int32" describe="数量"/>
-- 			<Param name="curr_type" type="int8" describe="货币类型"/>
-- 			<Param name="price" type="int32" describe="出售价格"/>
-- 			<Param name="vip" type="int16" describe="vip等级限制"/>
-- 			<Param name="is_buy" type="int8" describe="1 已经被购买，0还未购买"/>

function TreasureController:onHandle16100(data)
	-- <Param name="mystery_shop_list" type="list" sub_type="proto_mystery_shop" describe="神秘商人物品列表"/>
	-- 			<Param name="count" type="int16" describe="剩余购买次数"/>
	-- 			<Param name="ref_time" type="int32" describe="剩余刷新时间（秒）"/>
	-- 			<Param name="need_jade" type="int32" describe="刷新神秘商店需要的元宝"/>
	if data then
		self.is_open = data.is_open
		self.bugTimes = data.count
		self.refreshTime = data.ref_time
		self.refreshNeedJade = data.need_jade
		self.shopList = data.mystery_shop_list
		for i=1,#data.mystery_shop_list do
			
		end

		GlobalEventSystem:dispatchEvent(TreasureEvent.UPDATE_SHOP_LIST,  {is_open = self.is_open,list = self.shopList,bugTimes = self.bugTimes,refreshTime = self.refreshTime,refreshNeedJade = self.refreshNeedJade})
	end
end

function TreasureController:onHandle16101(data)
	if data.result == 0 then 
		GlobalMessage:show("购买成功")
		GlobalEventSystem:dispatchEvent(TreasureEvent.BUY_SUCCESS,  {})
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
		--GlobalMessage:show("今天可购买次数已经用完，请明天再来")
	end
end

function TreasureController:onHandle16102(data)
	if data.result == 0 then 
		self.shopList = data.mystery_shop_list
		GlobalEventSystem:dispatchEvent(TreasureEvent.UPDATE_SHOP_LIST,  {list = self.shopList})
	else
		GlobalMessage:show("刷新失败")
	end
end
