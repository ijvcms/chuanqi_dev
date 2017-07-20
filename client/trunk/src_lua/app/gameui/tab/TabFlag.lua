--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 18:26:06
--
local TabFlag = class("TabFlag")

function TabFlag:ctor(flag)
	assert(flag ~= nil, "TabFlag::ctor - flag can't be nil!!")
	self._tabFlag = flag
end

--
-- 获取标识
--
function TabFlag:GetTabFlag()
	return self._tabFlag
end

--
-- 自动判断标识是否相同并调用相应的匹配方法。
--
function TabFlag:CompareFlagWithCalling(flag)
	local isMatch = flag == self._tabFlag
	if isMatch then
		self:Match()
	else
		self:UnMatch()
	end
	return isMatch
end

--
-- 标识匹配
--
function TabFlag:Match()
	assert(false, "TabFlag::Match - Never should to here.")
end

--
-- 标识不匹配
--
function TabFlag:UnMatch()
	assert(false, "TabFlag::UnMatch - Never should to here.")
end

return TabFlag