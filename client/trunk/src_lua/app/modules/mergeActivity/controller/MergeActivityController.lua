--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 14:29:26
-- 合服活动控制器
require("app.modules.mergeActivity.model.MergeActivityModel")
MergeActivityController = MergeActivityController or class("MergeActivityController", BaseController)

function MergeActivityController:ctor()
	MergeActivityController.Instance = self
	self.model = MergeActivityModel:getInstance()
	self:initProtocal()
	self.typeID = 0
	self.activeServiceId = 0
end

function MergeActivityController:getInstance()
	if nil == MergeActivityController.Instance then
		MergeActivityController.new()
	end
	return MergeActivityController.Instance
end

function MergeActivityController:initProtocal()
	self:registerProtocal(38012,handler(self,self.onHandle38012))
	self:registerProtocal(38013,handler(self,self.onHandle38013))
	self:registerProtocal(38019,handler(self,self.onHandle38019))
	self:registerProtocal(38040,handler(self,self.onHandle38040))
	self:registerProtocal(38041,handler(self,self.onHandle38041))
	self:registerProtocal(38042,handler(self,self.onHandle38042))
	self:registerProtocal(38043,handler(self,self.onHandle38043))
end

function MergeActivityController:send38012(typeId)
	--if self.isBackData = false then return end
		self.typeID = typeId
		self.isBackData = false
		GameNet:sendMsgToSocket(38012, {type = typeId})
	--end
end

function MergeActivityController:send38013(active_service_id,typeID)
	--if self.isBackData = false then return end
		self.typeID = typeID
		self.activeServiceId = active_service_id
		self.isBackData = false
		GameNet:sendMsgToSocket(38013, {active_service_id = active_service_id})
	--end
end

-- 获取开服活动相关列表
--GameNet:sendMsgToSocket(38012, {type = type})
function MergeActivityController:onHandle38012(data)
	-- <Param name="begin_time" type="int32" describe="活动开启时间"/>
	-- <Param name="end_time" type="int32" describe="活动结束时间"/>
	-- <Param name="my_value" type="int32" describe="自己的值"/>
	-- <Param name="active_service_list" type="list" sub_type="proto_active_service_info" describe="道具列表"/>
	self.model:setActivityTypeData(self.typeID,data)
	GlobalEventSystem:dispatchEvent(MergeActivityEvent.UPDATE_MERGE_ACTIVITY_DATA)
end
-- 领取开服活动奖励
--GameNet:sendMsgToSocket(38013, {active_service_id = active_service_id})
function MergeActivityController:onHandle38013(data)
	if data.result == 0 then
		GlobalMessage:show("领取成功！")
		GlobalEventSystem:dispatchEvent(MergeActivityEvent.GET_MERGE_PRIZE_SUCCESS,data.active_service_id)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

-- 获取开服活动类型列表
--GameNet:sendMsgToSocket(38019)
function MergeActivityController:onHandle38019(data)
	if data.type_info_list then
		self.model:setActivityTypeInfo(data.type_info_list)
		GlobalEventSystem:dispatchEvent(MergeActivityEvent.UPDATE_ACTIVITY_TYPE)
	end
end

-- 获取服务器排名活动列表 38012返回
function MergeActivityController:onHandle38040(data)
	self.model:setActivityTypeData(self.typeID,data)
	GlobalEventSystem:dispatchEvent(MergeActivityEvent.UPDATE_MERGE_ACTIVITY_DATA)
	-- <Param name="my_rank" type="int16" describe="我的排名"/>
	-- 			<Param name="my_lv" type="string" describe="我的等级"/>
	-- 			<Param name="begin_time" type="int32" describe="活动开启时间"/>
	-- 			<Param name="end_time" type="int32" describe="活动结束时间"/>
	-- 			<Param name="rank_list" type="list" sub_type="proto_active_service_rank_info" describe="道具列表"/>
end

-- 获取服务器排名活动列表 38012返回
function MergeActivityController:onHandle38041(data)
	self.model:setActivityTypeData(self.typeID,data)
	GlobalEventSystem:dispatchEvent(MergeActivityEvent.UPDATE_MERGE_ACTIVITY_DATA)
	-- <Param name="begin_time" type="int32" describe="活动开启时间"/>
	-- 			<Param name="end_time" type="int32" describe="活动结束时间"/>
	-- 			<Param name="goods_list" type="list" sub_type="proto_active_shop" describe="道具列表"/>

end

-- 购买活动活动商品列表物品信息
-- GameNet:sendMsgToSocket(38019,{id = id,num = num})
function MergeActivityController:onHandle38042(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
		return
	end
	GlobalEventSystem:dispatchEvent(MergeActivityEvent.UPDATE_MERGE_SHOP_DATA, data.active_shop_info)
	-- <Param name="result"  type="int32"  describe="返回 大于0表示错误吗，等于0表示成功"/>
	-- 			<Param name="active_shop_info"  type="proto_active_shop"  describe="刷新商品信息"/>
end

-- 刷新红点信
function MergeActivityController:onHandle38043(data)
	print("MergeActivityController:onHandle38043")
	--BtnTipManager:setKeyValue(BtnTipsType["BIN_AUTO_DRINK"..i], 1)
	--<Param name="list_id"  type="int32"  describe="分页id"/>
end


			
		
			
			
			
			
		
		

-- --获取合服商店配置
-- function ConfigHelper:getActiveServiceMergeShop()
--  	return self.active_service_merge_shopConfig.datas
-- end

-- --获取合服类型配置
-- function ConfigHelper:getActiveServiceMergeType()
--  	return self.active_service_merge_typeConfig.datas
-- end

-- --获取合服类型配置
-- function ConfigHelper:getActiveServiceMerge(id)
--  	return self.active_service_mergeConfig.datas[id]
-- end

