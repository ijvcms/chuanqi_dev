--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-18 18:33:31
--
local GuideMark = class("GuideMark")

function GuideMark:ctor(mark)
	self._mark = mark
	self._isDynamic = false
	self._options = nil
	self._optionType = nil
	self._optionList = nil
	self:initialization()
end

function GuideMark:initialization()
	local options = GUIMR.GetMarkOptions(self._mark)
	if options then
		self._isDynamic = true
		self._options = options
		self._optionType = GUIMR.GetMarkOptionType(options)
		self._optionList = GUIMR.GetMarkOptionList(options)
	end
end

--
-- 获得标记字符串。
--
function GuideMark:getMark() return self._mark end

function GuideMark:isIntrestedIn(win) 
	return tonumber(self._optionList[1], 10) == GUIMR.OMT_NAV_OPS[win]
end

--
-- 获得选项类型
--
function GuideMark:getOptionType() return self._optionType end

--
-- 获得选项列表
--
function GuideMark:getOptionList() return self._optionList end

--
-- 判断此标记是否为动态标记（即包含选项）
--
function GuideMark:isDynamic() return self._isDynamic end

return GuideMark