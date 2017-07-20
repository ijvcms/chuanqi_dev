--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-12-03 
-- 交易控制器
TradeController = TradeController or class("TradeController",BaseController)

function TradeController:ctor()	
	TradeController.Instance = self
	self:initProtocal()
end

function TradeController:getInstance()
	if TradeController.Instance==nil then
		TradeController.new()
	end
	return TradeController.Instance
end

function TradeController:initProtocal( )
	--我方发起交易
	self:registerProtocal(20001,handler(self,self.onHandle20001))
	--收到交易邀请
	self:registerProtocal(20002,handler(self,self.onHandle20002))
	--我方反馈交易请求(同意or拒绝)
	self:registerProtocal(20003,handler(self,self.onHandle20003))
	--我方取消交易
	self:registerProtocal(20004,handler(self,self.onHandle20004))
	--我方变更交易数据
	self:registerProtocal(20005,handler(self,self.onHandle20005))
	--对方变更交易数据
	self:registerProtocal(20006,handler(self,self.onHandle20006))
	--我方确认交易
	self:registerProtocal(20007,handler(self,self.onHandle20007))
	--交易失败
	self:registerProtocal(20008,handler(self,self.onHandle20008))
	--交易成功
	self:registerProtocal(20009,handler(self,self.onHandle20009))
end

function TradeController:onHandle20001(data)
	print("onHandle20001")
	if data.result == 0 then 		--我方发起的交易被对方同意了
		local node = require("app.modules.trade.view.TradeView").new(data.player_name,data.player_lv)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function TradeController:onHandle20002(data)
	--收到交易邀请
	print("onHandle20002")
	local player_id = data.player_id 		--交易发起人id
	local player_name = data.player_name 	--交易发起人名称
	local player_lv = data.player_lv 		--交易发起人等级
	if GlobalController.fight:getScene().loading then 			--如果loading界面正在显示,那么等loading完再显示
		self.eventForNewTrade = nil 
		local function onShow()
			SystemNotice:newTradeNotice({peerPlayerId = player_id,peerPlayerName = player_name,peerPlayerLv = player_lv})
			GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
			self.eventForNewTrade = nil 
		end
		self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
	else
		SystemNotice:newTradeNotice({peerPlayerId = player_id,peerPlayerName = player_name,peerPlayerLv = player_lv})
	end
end

function TradeController:onHandle20003(data)
	print("onHandle20003")
	if data.result == ERR_COMMON_SUCCESS then 		--我方同意交易邀请
		local node = require("app.modules.trade.view.TradeView").new(data.player_name,data.player_lv)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function TradeController:onHandle20004(data)
	print("onHandle20004")
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function TradeController:onHandle20005(data)
	print("onHandle20005")
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function TradeController:onHandle20006(data)
	print("onHandle20006")
	GlobalEventSystem:dispatchEvent(TradeEvent.GET_B_TRADE_INFO,data)
end

function TradeController:onHandle20007(data)
	print("onHandle20007")
	--我方确认交易出错
	if data.result ~= 0 then
		-- GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result,"交易失败!"))
		GlobalEventSystem:dispatchEvent(TradeEvent.GET_FAIL_TRADE)
	end
end

function TradeController:onHandle20008(data)
	print("onHandle20008")
	--交易失败
	GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result,"交易失败!"))
	GlobalEventSystem:dispatchEvent(TradeEvent.GET_FAIL_TRADE)
end

function TradeController:onHandle20009(data)
	print("onHandle20009")
	if data.result == ERR_COMMON_SUCCESS then 		--交易成功
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result,"交易成功!"))
		GlobalEventSystem:dispatchEvent(TradeEvent.GET_SUCCESS_TRADE)
	elseif data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end






