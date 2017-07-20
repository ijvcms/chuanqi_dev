--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-26 16:51:50
--
local ActivityData = class("ActivityData")

function ActivityData:ctor(metaData)
	self._data = metaData
	self:initialization()
end

function ActivityData:initialization()
	local func_id = self:getFunctionId()
	self._functionConfig = configHelper:getFunctionConfigById(func_id)
end



function ActivityData:getId() return self._data.id end

function ActivityData:getType() return self._data.type end

function ActivityData:getFunctionId() return self._data.function_id end

function ActivityData:isHightYield() return self._data.is_high_yield == 1 end

function ActivityData:getIconSpriteFrame() return self._data.icon_file end

function ActivityData:getTextSpriteFrame() return self._data.text_file end

function ActivityData:getDescribeHTML() return self._data.describe end

function ActivityData:getButtonLabel() return self._data.btn_label end

function ActivityData:getTargetWindow() return self._data.target_window end

function ActivityData:isShowNum() return self._data.is_show_num == 1 end

function ActivityData:hasSkip() return self._data.skip end

-- 返回是否开放
function ActivityData:isOpen()
	return self:getOpenState() == 0
end

-- 返回开放等级
function ActivityData:getOpenLevel()
	return self._functionConfig.lv
end

-- 返回开放条件文字
function ActivityData:getConditionText()
	local state = self:getOpenState()
	local text = nil
	if state == 1 then
		text = self._functionConfig.describe
	end
	return text or ""
end

-- 等级不足返回1，正常返回0
function ActivityData:getOpenState()
	if RoleManager:getInstance().roleInfo.lv < self:getOpenLevel() then
		return 1
	end
	return 0
end

return ActivityData

