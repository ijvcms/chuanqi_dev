--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-07 14:22:32
--

local GuideNotifyEvent = import(".GuideNotifyEvent")
local GuideNotifyEventPool = class("GuideNotifyEventPool")

--[[
	引导通知事件对象缓存池
	================
		此缓存池缓存了针对于引导事件的对象。
		由于某些地方频繁的抛出此事件，所以为了避免频繁的创建，特将此对象缓存。
]]

function GuideNotifyEventPool:ctor()
	self._pool = {}
end

function GuideNotifyEventPool:toPool(item)
	if item then
		self._pool[#self._pool + 1] = item
	end
end

function GuideNotifyEventPool:fromPool()
	if #self._pool > 0 then
		return table.remove(self._pool)
	end
	return GuideNotifyEvent.new()
end

function GuideNotifyEventPool:clear()
	local __removePool = self._pool
	self._pool = {}

	for _, v in ipairs(__removePool) do
		v:destory()
	end
end

return GuideNotifyEventPool