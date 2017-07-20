--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-16 00:52:26
--

--[[
	引导处理者 - 点击类型的引导。
]]

local GuideHandler = import(".GuideHandler")
local GuideView_ClickType = import("..view.GuideView_ClickType")
local GuideHandler_ClickType = class("GuideHandler_ClickType", GuideHandler)

--
-- 当创建完毕。
--
function GuideHandler_ClickType:onCreate()
end

function GuideHandler_ClickType:onReceiveEvent(event)
	local event = self:filterEvent(event)
	if not event then return end

	if event:getType() == event.TYPE_DEMAND_BACK then
		self:handleDemandData(event:getData())
	end
end

function GuideHandler_ClickType:onExecute()
	if self:checkDemand() then
		--
		-- 执行父类的处理操作。
		--
		GuideHandler_ClickType.super.onExecute(self)

		self._view = GuideView_ClickType.new(self, self:getGuideStep())
		self._view:show()
		self:getController():showGuideView(self._view)
	else
		-- 如果不满足将会请求需求，并等待反馈事件。
		local operatePkg = self:getOperateDataPkg()
		self:getController():requestDemand(operatePkg:getTargetMark())
	end
end

function GuideHandler_ClickType:onDeath()
	if self._view then
		self._view:close()
	end
end

--
-- 检查需求是否满足，满足返回true, 否则将返回false
--
function GuideHandler_ClickType:checkDemand()
    local operatePkg = self:getOperateDataPkg()
    return operatePkg:getTargetRect() ~= nil
end


function GuideHandler_ClickType:handleDemandData(data)
    local rect = data
    local operatePkg = self:getOperateDataPkg()
    operatePkg:setTargetRect(rect)
    operatePkg:setPosition(cc.p(rect.x + rect.width * .5, rect.y - 10))
    self:onExecute()
end

--
-- 过滤事件并返回，如果事件被过滤掉则返回nil。
--
function GuideHandler_ClickType:filterEvent(event)
	local operatePkg = self:getOperateDataPkg()

	if operatePkg:getTargetType() == operatePkg.AUTO then
		-- 自动类型，需要判断这个事件的mark是否对当前的处理流程有关系。
		local eventMark = event:getIdentify()
		local selfOptions = GUIMR.GetMarkOptions(operatePkg:getTargetMark())

		if selfOptions then
			local selfMarkType  = GUIMR.GetMarkOptionType(selfOptions)

			-- 如果自身的标记类型为OMT_AUTO_CLICK_BAG（自动点击背包）
			if selfMarkType == GUIMR.OMT_AUTO_CLICK_BAG then
                 dump(goods_id_list)
				-- 循环遍历物品ID列表，比较MARK值，如果匹配得上则说明可以处理。
				local goods_id_list = GUIMR.GetMarkOptionList(selfOptions)
				for _, v in ipairs(goods_id_list) do
					if tonumber(v, 10) == eventMark then
						return event
					end
				end
			elseif selfMarkType == GUIMR.OMT_AUTO_CLICK_NAV then
				if tonumber(GUIMR.GetMarkOptionList(selfOptions)[1], 10) == eventMark then
					return event
				end
			else
				-- TODO:... 其他标记类型
			end
		end
	end
	return GuideHandler_ClickType.super.filterEvent(self, event)
end

return GuideHandler_ClickType