--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-18 14:24:51
--

local GuideMark = import("..model.GuideMark")
local GuideDemandEvent = import(".GuideDemandEvent")
local GuideEventDispatcher = class("GuideEventDispatcher")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function GuideEventDispatcher:ctor()
	self:initialization()
end

function GuideEventDispatcher:initialization()
	local dispatcher = {}
	cc(dispatcher):addComponent("components.behavior.EventProtocol"):exportMethods()

	self._dispatcher  = dispatcher
	self._demandQueue = {}
	self._handles = {}
end

--
-- 增加一个需求事件监听处理函数，每当有引导需要散发需求的时候将会触发这个处理函数。
--
function GuideEventDispatcher:addDemandEventListener(listener)
	-- event cache first.
	local handle = self._dispatcher:addEventListener(GuideEvent.GUIDE_DEMAND_EVENT, listener)
	self:invokeTargetHandlerFromQueue()
	self._handles[#self._handles + 1] = handle
	return handle
end

--
-- 根据监听时返回的handle值移除这个事件处理函数。
--
function GuideEventDispatcher:removeDemandEventByHandle(eventHandle)
	self._dispatcher:removeEventListener(eventHandle)
end

--
-- 广播一个需求。
--
function GuideEventDispatcher:broadcastDemand(mark)
	local guideMark = mark
	if type(mark) == 'string' then
		guideMark = GuideMark.new(mark)
	end

	local demandEvent = GuideDemandEvent.new(guideMark)
	self._dispatcher:dispatchEvent({name = GuideEvent.GUIDE_DEMAND_EVENT, data = demandEvent})

	if not demandEvent:isProcessed() then
		self:pushDemandEventToQueue(demandEvent)
	end
end

--
-- 从缓存队列中移除指定mark的事件（如果有的话）。
--
function GuideEventDispatcher:removeFromQueueByMark(mark)
	if not mark or #self._demandQueue == 0 then return end
	local removeList = {}

	-- Each event queue invoke the handler.
	for _, v in ipairs(self._demandQueue) do
		if v:getGuideMark():getMark() == mark then
			removeList[#removeList + 1] = v
		end
	end

	self:removeFromQueueByList(removeList)
end


--
-- 延迟100毫秒对一个handler执行调用所有缓存的需求事件。
--
function GuideEventDispatcher:invokeTargetHandlerFromQueue(handler)
	if #self._demandQueue == 0 then return end
	return scheduler.performWithDelayGlobal(function()
		local removeList = {}

		-- Each event queue invoke the handler.
		for _, v in ipairs(self._demandQueue) do
			self._dispatcher:dispatchEvent({name = GuideEvent.GUIDE_DEMAND_EVENT, data = v})
			if v:isProcessed() then
				removeList[#removeList + 1] = v
			end
		end

		self:removeFromQueueByList(removeList)
	end, 0.1)
end

--
-- 只有一个事件没有得到处理的时候才能调用此方法。
-- 将一个需求事件缓存之，以便再新增监听时对其进行延迟广播。
--
function GuideEventDispatcher:pushDemandEventToQueue(demandEvent)
	self._demandQueue[#self._demandQueue + 1] = demandEvent
end

--
-- 从队列中移除列表中的事件。
--
function GuideEventDispatcher:removeFromQueueByList(listOfQueue)
	-- Remove processed event from queue.
	for _, v in ipairs(listOfQueue) do
		local removeIdx = table.indexof(self._demandQueue, v)

		if removeIdx then
			table.remove(self._demandQueue, removeIdx)
		end
	end
end

--
-- 清除当前所有的需求监听处理函数。
--
function GuideEventDispatcher:clear()
	local handles = self._handles
	self._handles = {}
	for _, handle in ipairs(handles) do
		self:removeDemandEventByHandle(handle)
	end
end

return GuideEventDispatcher