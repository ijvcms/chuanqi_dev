--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 18:48:54
--
local GuildFBInfo = class("GuildFBInfo")

function GuildFBInfo:ctor(data)
	self._data = data
end

-- 1、已开启， 2、未开启
function GuildFBInfo:getState()
	local currentTime = self:getCurrentTime()
	if currentTime >= self:getStartTime() and currentTime < self:getEndTime() then
		return 1
	end
	return 2
end

--
-- 获取结束剩余时间字符串。
--
function GuildFBInfo:getCountdownTimeStr()
	local surplusTime = self:getEndTime() - self:getCurrentTime()
	return StringUtil.convertTime(surplusTime)
end

function GuildFBInfo:getCurrentTime()
	-- 没有时区的时间戳
	return os.time()-- - os.date("*t", 0).hour * 60 * 60
end

function GuildFBInfo:getLayerNumer() return self._data.num end
function GuildFBInfo:getEnterLowLevel() return self._data.lv end
function GuildFBInfo:getStartTime() return self._data.open_time end
function GuildFBInfo:getEndTime() return self._data.close_time end

return GuildFBInfo