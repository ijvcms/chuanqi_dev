--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-11 20:29:10
--

--[[
	此类归属于Model目录下，说明他是一个数据/值对象。
	引导操作数据 - 点击类型的引导。
]]
local GuideOperation = import(".GuideOperation")
local GuideOperation_ClickType = class("GuideOperation_ClickType", GuideOperation)

GuideOperation_ClickType.ABSOLUTE = 1
GuideOperation_ClickType.AUTO     = 2

--
-- 初始化方法。
--
function GuideOperation_ClickType:initialization()
	self._targetBody = self:getGuideBody().target_body_data
end

function GuideOperation_ClickType:getTargetType()
	return self:getGuideBody().target_type
end

function GuideOperation_ClickType:getTargetMark()
	return self._targetBody.target_mark
end

function GuideOperation_ClickType:getDescribe()
	return self._targetBody.describe
end

function GuideOperation_ClickType:getDirection()
	return tonumber(self._targetBody.direction) or 1
end

function GuideOperation_ClickType:getPositionType()
	return tonumber(self._targetBody.position_type) or 1
end

function GuideOperation_ClickType:getPosition()
	-- 如果已经转换过或者赋值过，直接返回这个点
	if self._targetBody.position_c then
		return self._targetBody.position_c
	end

	local point_str = self._targetBody.position
	local pos_type = self:getPositionType()
	self._targetBody.position_c = self:convertPointByString(point_str, pos_type)

	return self._targetBody.position_c
end

function GuideOperation_ClickType:getTargetRect()
	-- 如果已经转换过或者赋值过，直接返回这个矩形
	if self._targetBody.target_rect_c then
		return self._targetBody.target_rect_c
	end

	local rect_str = self._targetBody.target_rect
	local pos_type = self:getPositionType()
	self._targetBody.target_rect_c = self:convertRectangleByString(rect_str, pos_type)

	return self._targetBody.target_rect_c
end

-- for GuideOperation_ClickType.AUTO
function GuideOperation_ClickType:setPosition(point)
	self._targetBody.position_c = point
end

-- for GuideOperation_ClickType.AUTO
function GuideOperation_ClickType:setTargetRect(rect)
	self._targetBody.target_rect_c = rect
end

function GuideOperation_ClickType:checkIdentify(identify)
	local isMatch = self:getTargetMark() == identify
	return isMatch or GuideOperation_ClickType.super.checkIdentify(self, identify)
end

return GuideOperation_ClickType