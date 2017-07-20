--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:08:31
--

--
-- Replace XXXXX to your module name.
--
XXXXXController = XXXXXController or class("XXXXXController", BaseController)

local XXXXXProtos = {
	CREATE_TEAM = 21000,
}

--构造器
function XXXXXController:ctor()
	XXXXXController.super.ctor(self)
	
	self:initialization()
end

function XXXXXController:initialization()
	self:registerProto()
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------
--销毁
function XXXXXController:destory()
	self:unRegisterProto()
	self:clear()
	XXXXXController.super.destory(self)
end

--清理
function XXXXXController:clear()
	XXXXXController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------

function XXXXXController:registerProto()
	-- self:registerProtocal(XXXXXProtos.CREATE_TEAM, handler(self, self.onHandle_CREATE_TEAM))
end

function XXXXXController:unRegisterProto()
	for _, v in pairs(XXXXXProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function XXXXXController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function XXXXXController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

function XXXXXController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对XXXX信息发生的变化
-- ------------------------------------------------------------------------------------------

function XXXXXController:onHandle_CREATE_TEAM(data)
end

return XXXXXController