--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-26 11:52:10
--

ActivityController = ActivityController or class("ActivityController", BaseController)

local ActivityProtos = {
	GET_ACTIVITY_INFO = 28001,
	GET_ACTIVITY_SERVICE_INFO = 32012,
	GET_ACTIVITY_SERVICE_REWARD = 32013,
	GET_ACTIVITY_SERVICE_LIST = 32019,
	GET_ACTIVITY_SERVICE_RANK = 32040,--开服活动排行
	GET_ACTIVITY_SERVICE_SHOP = 32041,--开服活动商店
	GET_ACTIVITY_SERVICE_SHOP_BUY = 32042,--开服活动商店购买
}

--构造器
function ActivityController:ctor()
	ActivityController.super.ctor(self)
	
	self:initialization()
end

function ActivityController:initialization()
	self:registerProto()
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------
function ActivityController:requestActivityInfo()
	self:sendDataToServer(ActivityProtos.GET_ACTIVITY_INFO)
end

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------
--销毁
function ActivityController:destory()
	self:unRegisterProto()
	self:clear()
	ActivityController.super.destory(self)
end

--清理
function ActivityController:clear()
	ActivityController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------

function ActivityController:registerProto()
	self:registerProtocal(ActivityProtos.GET_ACTIVITY_INFO, handler(self, self.onHandle_GET_ACTIVITY_INFO))
	self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_INFO, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_INFO))
	self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_REWARD, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_REWARD))

	self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_RANK, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_RANK))
	self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_SHOP, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_SHOP))
	self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_SHOP_BUY, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_SHOP_BUY))

self:registerProtocal(ActivityProtos.GET_ACTIVITY_SERVICE_LIST, handler(self, self.onHandle_GET_ACTIVITY_SERVICE_LIST))

end

function ActivityController:unRegisterProto()
	for _, v in pairs(ActivityProtos) do
		self:unRegisterProtocal(v)
	end
end

function ActivityController:requestActivityService(index)
	GameNet:sendMsgToSocket(32012,{type = index})
end

function ActivityController:requestActivityServiceReward(id)
	GameNet:sendMsgToSocket(32013,{active_service_id = id})
end

function ActivityController:requestActivityServiceList()
	GameNet:sendMsgToSocket(32019)
end

function ActivityController:requestActivityServiceBuy(id,num)
	GameNet:sendMsgToSocket(32042,{id = id,num = num})
end

-- 派发事件。
function ActivityController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function ActivityController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

function ActivityController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对公会信息发生的变化
-- ------------------------------------------------------------------------------------------

function ActivityController:onHandle_GET_ACTIVITY_INFO(data)
	--[[
		<Packet proto="28001" type="s2c" name="rep_get_activity_list" describe="获取活动剩余次数信息">
			<Param name="activity_list"  type="list" sub_type="proto_activity_info"  describe="免费朝拜已经使用的次数"/>
		</Packet>
	]]
	self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_INFO, data.activity_list)
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_INFO(data)
	print("ActivityController:onHandle32012")
	self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO, data)
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_REWARD(data)
	--self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO, data.active_service_list)
	print("ActivityController:onHandle32013")
 
	if data.result == 0 then
		self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD)
	else
		self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	end
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_LIST(data)
	print("ActivityController:onHandle32019")
	self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_LIST, data)
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_RANK(data)
	print("ActivityController:onHandle32040")
	self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO, data)
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_SHOP(data)
	print("ActivityController:onHandle32041")
	dump(data)
	self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO, data)
end

function ActivityController:onHandle_GET_ACTIVITY_SERVICE_SHOP_BUY(data)
	print("ActivityController:onHandle32042")
	dump(data)
	if data.result == 0 then
		self:dispatchEventWith(ActivityEvent.RCV_ACTIVITY_SERVICE_SHOP_BUY, data)
	else
		self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	end
	
end
return ActivityController