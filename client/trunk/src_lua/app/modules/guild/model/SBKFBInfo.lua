--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 22:08:48
--
local SBKFBInfo = class("SBKFBInfo")

function SBKFBInfo:ctor(data)
	self._data = data
	self._startTime = os.time()
end

--
-- 获取结束剩余时间字符串。
--
function SBKFBInfo:getCountdownTimeStr()
	local surplusTime = self:getCountdownTime()
	return StringUtil.convertTime(surplusTime)
end

function SBKFBInfo:getCountdownTime()
	-- 剩余时间减去 接收到的时和现在的间隔时间。
	return self:getSurplusTime() - (os.time() - self._startTime)
end

function SBKFBInfo:getCurrentTime()
	-- 没有时区的时间戳
	return os.time()-- - os.date("*t", 0).hour * 60 * 60
end

function SBKFBInfo:getState()
	return self:getCountdownTime() <= 0 and 0 or self._data.state
end

function SBKFBInfo:getSBKGuildName() return self._data.sbk_name == "" and "【暂无占领】" or self._data.sbk_name end
function SBKFBInfo:getEnterLowLevel() return self._data.lv end
function SBKFBInfo:getSurplusTime() return self._data.timestamp end

return SBKFBInfo