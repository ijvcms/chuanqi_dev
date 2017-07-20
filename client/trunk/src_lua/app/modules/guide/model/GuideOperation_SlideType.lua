--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-19 10:33:03
--

--[[
	此类归属于Model目录下，说明他是一个数据/值对象。
	引导操作数据 - 滑动类型的引导。
]]
local GuideOperation = import(".GuideOperation")
local GuideOperation_SlideType = class("GuideOperation_SlideType", GuideOperation)

--
-- 初始化方法。
--
function GuideOperation_SlideType:initialization()
end

function GuideOperation_SlideType:getPositionType()
	return tonumber(self:getGuideBody().position_type) or 1
end

function GuideOperation_SlideType:getStartPoint()
	-- 如果已经转换过或者赋值过，直接返回这个点
	if self.start_point_c then
		return self.start_point_c
	end

	local point_str = self:getGuideBody().start_point
	local pos_type = self:getPositionType()
	self.start_point_c = self:convertPointByString(point_str, pos_type)

	return self.start_point_c
end

function GuideOperation_SlideType:getEndPoint()
	-- 如果已经转换过或者赋值过，直接返回这个点
	if self.end_point_c then
		return self.end_point_c
	end

	local point_str = self:getGuideBody().end_point
	local pos_type = self:getPositionType()
	self.end_point_c = self:convertPointByString(point_str, pos_type)

	return self.end_point_c
end

function GuideOperation_SlideType:getTargetRect()
	-- 如果已经转换过或者赋值过，直接返回这个矩形
	if self.target_rect_c then
		return self.target_rect_c
	end

	local rect_str = self:getGuideBody().target_rect
	local pos_type = self:getPositionType()
	self.target_rect_c = self:convertRectangleByString(rect_str, pos_type)

	return self.target_rect_c
end


return GuideOperation_SlideType