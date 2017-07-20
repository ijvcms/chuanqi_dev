--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 17:10:20
--

--[[
    新手引导模块控制器
	================
		整体模式采用元数据+解释器来进行引导操作。

		数据配置结构详见：
		https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/docs/abdd9b345bd840498aa0e62de5c3f8cd/

		使 用 方 法
		----------
			本控制器作为新手引导整个模块的外部接口类，已经注册在GlobalController中，因此，可以直接
			使用GlobalController.guide来进行访问。

		确 认 操 作 【对一个引导操作进行确认，以便引导步骤进入下一步】
		----------
			如需对一个操作进行确认，以便当前的引导能够继续下一个引导操作，请使用如下代码:
				-- GUIDE CONFIRM
				GlobalController.guide:notifyEventWithConfirm(operate_id)

			其中operate_id代表这个操作的ID，可从数据配置表的操作表内得到这个操作ID，如果当前引导对
			这个操作确认感兴趣的话，将会进入下一个引导操作，如果已经是引导序列中的最后操作了，那么就会
			停止引导，引导结束。

		响 应 需 求 【有时一个引导操作可能会请求外部模块的数据，外部模块应当监听并响应这个需求】
		----------
			首先，如果确定某个引导操作需要外部模块提供数据（例如目标的动态位置），那么这个外部模块，应当
			使用如下的代码来进行监听：
				GlobalEventSystem:addEventListener(GuideEvent.GUIDE_DEMAND_EVENT, handler(event))

			其中mark属性，代表了这个需求的标志，外部模块应当拿这个标志进行比较过滤，然后再决定是否响应这个需求。
			一旦外部模块通过验证并确定需要反馈这个需求的一些数据，就可以通过如下的代码来进行：
				local backEvent = GlobalController.guide:createEventWithDemandBack(mark)
				backEvent:setData(demand_data)
				GlobalController.guide:notifyEvent(backEvent)

			其中，mark应当是你接收到需求事件的时候得到的mark值。setData方法把你搜集到的需求数据装入这个事件中。
			最后通过notifyEvent方法来把这个反馈通知给当前的引导处理器。引导处理器会把它交给正在处理这个操作的视图
			类中。

			mark值应当协定好，它代表了这个需求如何被响应，以及引导模块如何解析该数据提供了一个唯一的标志。
			通过该标志，在写引导时我们就能够协定好数据结构，以便解析并显示正确的引导视图。

			注意：外部模块可以通过这个需求事件来进行处理一些额外的操作，并不是每个需求都会被响应的，那是因为
			引导在处理这个操作的时候，仅仅把这个操作通知给了外部模块，以便外部模块可以对此做出调整。
]]

GuideController = GuideController or class("GuideController", BaseController)

-- 操作ID常量
GUIOP = import(".model.GuideOperateIds")

-- Mark工具，用于确认ID常量的动态形式（例如物品）
GUIMR = import(".model.GuideMarkUtils")

local GuideProcessor       = import(".ctl.GuideProcessor")
local GuideTriggerManager  = import(".ctl.GuideTriggerManager")
local GuideNotifyEventPool = import(".event.GuideNotifyEventPool")
local GuideEventDispatcher = import(".event.GuideEventDispatcher")

local GuideProtos = {
	RECORD_STEP_ID = 11026, -- 记录步骤ID。
}

function GuideController:ctor()
	self:initialization()
end

function GuideController:initialization()
	self._eventPool       = GuideNotifyEventPool.new()
	self._triggerManager  = GuideTriggerManager.new()
	self._eventDispatcher = GuideEventDispatcher.new()
	self._record_list = {}

	self:registerProto()

	-- 进度条加载完毕
	-- 注意，此事件将会在被调用一次之后被清除掉，所以不确定返回登陆界面再次进入是否会重新初始化本模块。
	local handle = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING, function()
		-- 引导触发 - 当进入游戏的时候
		-- Start_of_Guide --------------
        GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.FIRST_IN_GAME, {
        	current_lv = RoleManager:getInstance().roleInfo.lv,
        	current_exp = RoleManager:getInstance().roleInfo.exp,
        })
        -- End_of_Guide --------------

		GlobalEventSystem:removeEventListenerByHandle(handle)
		handle = nil 
	end)
end

-- ==========================================================================================
-- Public Query Interface.
-- ------------------------------------------------------------------------------------------
function GuideController:getCurrentStepId()
	if self._processor then
		return self._processor:getCurrentStepId()
	end
end

--
--触发类型
--
function GuideController:getTriggerType()
	if self._processor then
		return self._processor:getTriggerType()
	end
end


-- ==========================================================================================
-- Public Function menbers.
-- ------------------------------------------------------------------------------------------
function GuideController:updateFrom10003(player_info)
	self._record_list = player_info.guide_step_list or {}
end

-------------------------------------------
-- MARK Trigger & Starting guide & stop

function GuideController:getTriggerManager()
	return self._triggerManager
end

function GuideController:startGuideWithTrigger(triggerData)
	if triggerData and triggerData.guide_step then
		local guide_step = checknumber(triggerData.guide_step)

		if guide_step ~= 0 then
			self:startGuide(guide_step, triggerData.type)
			GlobalEventSystem:dispatchEvent(SceneEvent.OPEN_NAV)
		end
	end
end

function GuideController:startGuide(step_id, trigger_type)
	self:stopGuide()

	-- 没有处理过此步骤才会进行引导。
	--test zhangshunqiu
	if not self:isRecordStep(step_id) then
		self:recordStep(step_id)
		self._processor = GuideProcessor.new(self, step_id, trigger_type)
		self._processor:start()
	end
end

function GuideController:stopGuide()
	if self._processor then
		self._processor:clear()
		self._processor = nil
	end
end

-------------------------------------------
-- MARK Guide Events & notify

--
-- 创建一个通知事件。
--
function GuideController:createEvent()
	return self._eventPool:fromPool()
end

--
-- 创建一个需求反馈事件。
--
function GuideController:createEventWithDemandBack(mark)
	local event = self:createEvent()
	event:setType(event.TYPE_DEMAND_BACK)
	event:setIdentify(mark)
	return event
end

--
-- 根据操作标识确认这个操作已经完成。
--
function GuideController:notifyEventWithConfirm(identify)
	local event = self:createEvent()
	event:setType(event.TYPE_CONFIRM)
	event:setIdentify(identify)
	self:notifyEvent(event)
end

function GuideController:isInterestedIn(identify)
	if self._processor then
		return self._processor:isInterestedIn(identify)
	end
	return false
	
end

--
-- 通知当前的引导流程。
-- @param guideEvent 通知事件。
-- @param isAutoDestory 是否默认在通知完毕之后销毁此事件，默认为true。
--
function GuideController:notifyEvent(guideEvent, isAutoDestory)
	if not guideEvent then return end
	isAutoDestory = isAutoDestory == nil and true or isAutoDestory
	self:notifyProcessor(guideEvent)

	if isAutoDestory then
		guideEvent:recycle()
		self._eventPool:toPool(guideEvent)
	end
end



function GuideController:addDemandEventListener(listener)
	return self._eventDispatcher:addDemandEventListener(listener)
end

function GuideController:removeDemandEventByHandle(handle)
	self._eventDispatcher:removeDemandEventByHandle(handle)
end

-------------------------------------------
-- MARK Guide Handler & Processor Request
function GuideController:showGuideView(view)
	self:dispatchEventWith(GlobalEvent.SHOW_BOX, view)
end

function GuideController:requestDemand(demand_mark)
	self._eventDispatcher:broadcastDemand(demand_mark)
end

-------------------------------------------
-- MARK Destory & clear

--销毁
function GuideController:destory()
	self:unRegisterProto()
	self:clear()
	GuideController.super.destory(self)
end

--清理
function GuideController:clear()
	self:stopGuide()
	self._eventDispatcher:clear()
	GuideController.super.clear(self)
end

-- ==========================================================================================
-- Private Function menbers.
-- ------------------------------------------------------------------------------------------
function GuideController:recordStep(step_id)
	--[[
		<Packet proto="11026" type="c2s" name="req_get_guide_state" describe="获取npc状态">
			<Param name="guide_step_id" type="int32" describe="新手步数信息"/>
		</Packet>
	]]
	self:sendDataToServer(GuideProtos.RECORD_STEP_ID, {guide_step_id = checknumber(step_id)})
	table.insert(self._record_list, checknumber(step_id))
end

-- 是否已经引导过此步骤
function GuideController:isRecordStep(step_id)
	if not step_id then return false end
	return table.indexof(self._record_list, checknumber(step_id))
end

-- 把通知传递给当前的处理者
function GuideController:notifyProcessor(guideEvent)
	if self._processor then
		self._processor:handleGuideEvent(guideEvent)
	end
end

-- 注册服务端业务数据回调
function GuideController:registerProto()
	self:registerProtocal(GuideProtos.RECORD_STEP_ID, handler(self, self.onHandle_RECORD_STEP_ID))
end

-- 取消业务数据的回调监听
function GuideController:unRegisterProto()
	for _, v in pairs(GuideProtos) do
		self:unRegisterProtocal(v)
	end
end

-- 派发事件。
function GuideController:dispatchEventWith(type, data)
	GlobalEventSystem:dispatchEvent(type, data)
end

-- 发送数据至服务器。
function GuideController:sendDataToServer(protoId, data)
	GameNet:sendMsgToSocket(protoId, data)
end

-- 处理错误代码。
function GuideController:handleResultCode(resultCode)
	self:dispatchEventWith(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(resultCode))
end

-- ==========================================================================================
-- Receive data change from server & handle data & diapatch events
-- 接收服务端针对排位赛信息发生的变化
-- ------------------------------------------------------------------------------------------

function GuideController:onHandle_RECORD_STEP_ID(data)
	--[[
		<Packet proto="11026" type="s2c" name="rep_get_guide_state" describe="获取npc状态">
			<Param name="result" type="int16" describe="结果: 1 已经做过了该新手,0 还未做过该新手"/>
		</Packet>
	]]
	-- 不做任何处理
end