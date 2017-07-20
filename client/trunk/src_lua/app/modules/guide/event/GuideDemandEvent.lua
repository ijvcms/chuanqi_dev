--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-18 17:31:58
--
local GuideDemandEvent = class("GuideDemandEvent")

function GuideDemandEvent:ctor(mark)
	-- demand data
	self._guideMark = mark

	-- self attr
	self._isProcessed = false
end

--
-- 是否已被处理。
--
function GuideDemandEvent:processed() self._isProcessed = true end
function GuideDemandEvent:isProcessed() return self._isProcessed end

--
-- 获得标记对象
--
function GuideDemandEvent:getGuideMark() return self._guideMark end

return GuideDemandEvent