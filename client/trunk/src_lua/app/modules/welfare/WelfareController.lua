--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 15:22:02
--

WelfareController = WelfareController or class("WelfareController", BaseController)

local MonitorTask = import(".ctl.MonitorTask")
local WelfareData = import(".model.WelfareData")
local FirstRechargeView = import(".view.FirstRechargeView")

local WelfareProtos = {
	GET_REWARDS_STATE    = 32001, -- 获得奖励状态（是否领取）。
	GET_ONLINE_TIME      = 32002, -- 获取玩家的在线时长。
	DO_RECEIVE_REWARD    = 32003, -- 领取这个奖励。
	UPDATE_REWARDS_STATE = 32004, -- 更新奖励列表状态。
	GET_FIRST_GOODS_LIST = 32005, -- 获取首冲奖励列表。
	GET_SIGN_LIST = 32014, -- 获取签到列表。
	DO_SIGN = 32015, -- 签到。
	DO_SIGN2 = 32016,--补签
	GET_SIGN_REWARDS = 32017,--领取签到奖励
	GET_MONTHCARD_INFO = 30003,--获取月卡信息
	GET_MONTHCARD = 30004,--领取月卡奖励

}

--构造器
function WelfareController:ctor()
	WelfareController.super.ctor(self)
	
	self:initialization()
	self.isFirst = false
end

function WelfareController:initialization()
	self._welfareData = WelfareData.new()
	self:registerProto()

	-- 进度条加载完毕
	-- 注意，此事件将会在被调用一次之后被清除掉，所以不确定返回登陆界面再次进入是否会重新初始化本模块。
	local handle = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING, function()
		--self._welfareData = WelfareData.new()
		if GlobalModel.firstInitScene == false then
			self.isFirst = true
			self:RequestGetOnlineTime()
			self:RequestGetRewardsState()
		end
		--GlobalEventSystem:removeEventListenerByHandle(handle)
		--handle = nil 
	end)
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------
--
-- 获取奖励信息的状态。
--
function WelfareController:GetRewardState(reward_id)
	return self._welfareData:getRewardState(reward_id)
end

--
-- 获取当前的在线时间。
--
function WelfareController:GetOnlineTime()
	return self._welfareData:getOnlineTime() or 0
end

-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------

function WelfareController:OpenFirstRechargeView()
	FirstRechargeView:new():show()
end

-- 设置奖励信息的状态。
function WelfareController:SetRewardState(reward_id, state, dontEvent)
	self._welfareData:setRewardState(reward_id, state)

	-- 可领取
	-- 主场景内
	-- if state == 0 and GlobalController.curScene == SCENE_MAIN then
	-- 	local putonTips = import("app.modules.bag.view.putOnTips").new()
	-- 	local reward_item = configHelper:getWelfareRewardById(reward_id)
	-- 	local goodsItem = {}
	-- 	table.merge(goodsItem, reward_item.goods_info)
	-- 	goodsItem.key = reward_id
	-- 	putonTips:setData(goodsItem)
	-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,putonTips)  
	-- end--取消弹出提示

	if not dontEvent then
		self:dispatchEventWith(WelfareEvent.CHANGE_REWARDS_STATE)
	end
end

-- 获得奖励状态（是否领取）。
function WelfareController:RequestGetRewardsState()
	self:sendDataToServer(WelfareProtos.GET_REWARDS_STATE)
end

-- 获取玩家的在线时长。
function WelfareController:RequestGetOnlineTime()
	self:sendDataToServer(WelfareProtos.GET_ONLINE_TIME)
end

-- 领取这个奖励。
function WelfareController:RequestReceiveReward(reward_id)
	--[[
		<Packet proto="32003" type="c2s" name="req_get_active_reward" describe="领取活动奖励">
			<Param name="key" type="int16"  describe="key id"/>
		</Packet>
	]]
	self:sendDataToServer(WelfareProtos.DO_RECEIVE_REWARD, {key = checknumber(reward_id)})
end

-- 获取首冲奖励列表。
function WelfareController:RequestGetFirstGoodsList()
	self:sendDataToServer(WelfareProtos.GET_FIRST_GOODS_LIST)
end

--销毁
function WelfareController:destory()
	self:unRegisterProto()
	self:clear()
	WelfareController.super.destory(self)
end

--清理
function WelfareController:clear()
	self:stopMonitorTasks()
	self._welfareData = nil
	WelfareController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------
-- 开始运行监测任务。
function WelfareController:startMonitorTasks()
	self:stopMonitorTasks()

	local tasks = {}
	local state_list = self._welfareData:getRewardsState()
	for _, v in ipairs(state_list) do
		local task = MonitorTask.create(v.key, v.state)
		if task then
			task:setOnDeathCallBack(handler(self, self.onTaskDeath))
			tasks[#tasks + 1] = task
		end
	end

	self._tasks = {}
	table.merge(self._tasks, tasks)

	for _, v in ipairs(tasks) do v:onRun() end
end

-- 停止运行监测任务。
function WelfareController:stopMonitorTasks()
	if self._tasks then
		for _, v in ipairs(self._tasks) do
			v:onDeath()
		end
	end
	self._tasks = nil
end

-- 当一个任务结束，需要移除对其的引用。
function WelfareController:onTaskDeath(task)
	if self._tasks then
		table.removebyvalue(self._tasks, task)
	end
end

function WelfareController:registerProto()
	self:registerProtocal(WelfareProtos.GET_REWARDS_STATE    , handler(self, self.onHandle_GET_REWARDS_STATE))
	self:registerProtocal(WelfareProtos.GET_ONLINE_TIME      , handler(self, self.onHandle_GET_ONLINE_TIME))
	self:registerProtocal(WelfareProtos.DO_RECEIVE_REWARD    , handler(self, self.onHandle_DO_RECEIVE_REWARD))
	self:registerProtocal(WelfareProtos.UPDATE_REWARDS_STATE , handler(self, self.onHandle_UPDATE_REWARDS_STATE))
	self:registerProtocal(WelfareProtos.GET_FIRST_GOODS_LIST , handler(self, self.onHandle_GET_FIRST_GOODS_LIST))
	self:registerProtocal(WelfareProtos.GET_SIGN_LIST , handler(self, self.onHandle_GET_SIGN_LIST))
	self:registerProtocal(WelfareProtos.DO_SIGN , handler(self, self.onHandle_DO_SIGN))
	self:registerProtocal(WelfareProtos.DO_SIGN2 , handler(self, self.onHandle_DO_SIGN2))
	self:registerProtocal(WelfareProtos.GET_SIGN_REWARDS , handler(self, self.onHandle_GET_SIGN_REWARDS))

	self:registerProtocal(WelfareProtos.GET_MONTHCARD , handler(self, self.onHandle_GET_MONTHCARD))
	self:registerProtocal(WelfareProtos.GET_MONTHCARD_INFO , handler(self, self.onHandle_GET_MONTHCARD_INFO))



end
 
function WelfareController:unRegisterProto()
	for _, v in pairs(WelfareProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function WelfareController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function WelfareController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

function WelfareController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对奖励信息发生的变化
-- ------------------------------------------------------------------------------------------
-- 获得奖励状态（是否领取）。
function WelfareController:onHandle_GET_REWARDS_STATE(data)
	self._welfareData:setRewardsState(data.info_list)
	self:dispatchEventWith(WelfareEvent.CHANGE_REWARDS_STATE)
	self:startMonitorTasks()
	--先弹出每日奖励，再弹出福利签到页面
	if self.isFirst == true then
		self.isFirst = false
		local config = configHelper:getWelfareRewardsByType(1)
		for i=1,#config do
			local itemState = GlobalController.welfare:GetRewardState(config[i].key)
			if itemState == 0 and RoleManager:getInstance().roleInfo.lv >= 10 then
				GlobalWinManger:openWin(WinName.SEVENLOGINWIN)
				return 
			end
		end
		GlobalController.welfare:requestSignList()
	end
end

-- 获取玩家的在线时长。
function WelfareController:onHandle_GET_ONLINE_TIME(data)
	self._welfareData:setOnlineTime(data.times)
	self:dispatchEventWith(WelfareEvent.CHANGE_ONLINE_TIME)
end

-- 领取这个奖励。
function WelfareController:onHandle_DO_RECEIVE_REWARD(data)
	--[[
		<Packet proto="32003" type="s2c" name="rep_get_active_reward" describe="领取活动奖励">
			<Param name="key" type="int16"  describe="key id"/>
			<Param name="result"  type="int16"  describe="0 领取成，不为0领取失败,错误码"/>
		</Packet>
	]]

	if data.result ~= 0 then
		self:handleResultCode(data.result)
		return
	end
 
	self:SetRewardState(data.key, 1)
    --统计领取在线奖励
	GlobalAnalytics:Reward(data.key)
end

-- 更新奖励列表状态。
function WelfareController:onHandle_UPDATE_REWARDS_STATE(data)

	local updateList = data.info_list
	for _, v in ipairs(updateList) do
		self:SetRewardState(v.key, v.state, true)
	end

	self:dispatchEventWith(WelfareEvent.CHANGE_REWARDS_STATE)
end

-- 获取首冲奖励列表。
function WelfareController:onHandle_GET_FIRST_GOODS_LIST(data)
	local goods_list = data.goods_list
	self:dispatchEventWith(WelfareEvent.GET_FIRST_GOODS_LIST, goods_list)
end

function WelfareController:requestSignList()
	GameNet:sendMsgToSocket(32014)
end

function WelfareController:requestDoSign()
	GameNet:sendMsgToSocket(32015)
end

function WelfareController:requestDoSign2()
	GameNet:sendMsgToSocket(32016)
end

function WelfareController:requestSignRewards(days)
	GameNet:sendMsgToSocket(32017,{days = days})
end

function WelfareController:requestMonthCardInfo()
	GameNet:sendMsgToSocket(30003)
end

function WelfareController:requestGetMonthCard()
	GameNet:sendMsgToSocket(30004)
end

--[[
- <Packet proto="32014" type="s2c" name="rep_sign_list" describe="领取开服活动奖励">
  <Param name="sign_list" type="list" sub_type="int8" describe="签到日期列表" /> 
  <Param name="reward_list" type="list" sub_type="int8" describe="已领取奖励日期列表" /> 
  <Param name="count" type="int8" describe="剩余补签次数" /> 
  </Packet>

	GET_SIGN_LIST = "GET_SIGN_LIST", -- 获取首冲奖励
	DO_SIGN = "DO_SIGN", -- 获取首冲奖励
	DO_SIGN2 = "DO_SIGN2", -- 获取首冲奖励
	GET_SIGN_REWARDS = "GET_SIGN_REWARDS", -- 获取首冲奖励

--]]
function WelfareController:onHandle_GET_SIGN_LIST(data)
	print("onHandle_GET_SIGN_LIST")
	--dump(data)
	self:dispatchEventWith(WelfareEvent.GET_SIGN_LIST,data)
	--每天首次登陆打开
	GlobalEventSystem:dispatchEvent(GlobalEvent.OPEN_SIGN,data) 

end

function WelfareController:onHandle_DO_SIGN(data)
	print("onHandle_DO_SIGN")
	--dump(data)
	
	if data.result == 0 then
		self:dispatchEventWith(WelfareEvent.DO_SIGN,data)
	else
		self:handleResultCode(data.result)
	end
end

function WelfareController:onHandle_DO_SIGN2(data)
	print("onHandle_DO_SIGN2")
	--dump(data)
	if data.result == 0 then
		self:dispatchEventWith(WelfareEvent.DO_SIGN2,data)
	else
		self:handleResultCode(data.result)
	end
end

function WelfareController:onHandle_GET_SIGN_REWARDS(data)
	print("onHandle_GET_SIGN_REWARDS")
	--dump(data)
	if data.result == 0 then
		self:dispatchEventWith(WelfareEvent.GET_SIGN_REWARDS,data)
	else
		self:handleResultCode(data.result)
	end
end


function WelfareController:onHandle_GET_MONTHCARD(data)
	print("onHandle_GET_MONTHCARD")
	--dump(data)
	if data.result == 0 then
		self:dispatchEventWith(WelfareEvent.GET_MONTHCARD,data)
	else
		self:handleResultCode(data.result)
	end
	
end

function WelfareController:onHandle_GET_MONTHCARD_INFO(data)
	print("onHandle_GET_MONTHCARD_INFO")
	--dump(data)
 	self:dispatchEventWith(WelfareEvent.GET_MONTHCARD_INFO,data)
 
end

return WelfareController