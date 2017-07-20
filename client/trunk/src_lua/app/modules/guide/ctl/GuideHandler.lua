--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-15 23:58:40
--
local GuideStep = import("..model.GuideStep")
local GuideOperation = import("..model.GuideOperation")
local GuideHandler = class("GuideHandler")

local CURRENT_MODULE_NAME = ...

local HANDLER_REGISTER = {
	[GuideOperation.TYPE_CLICK]   = ".GuideHandler_ClickType",
	[GuideOperation.TYPE_WELCOME] = ".GuideHandler_Welcome",
	[GuideOperation.TYPE_SLIDE]   = ".GuideHandler_SlideType",
	[GuideOperation.TYPE_WAIT]    = "",
}

--
-- Factory Method
--
function GuideHandler.create(controller, step)

	local guideType = step:getOperateDataPkg():getGuideType()
	local handlerName = HANDLER_REGISTER[guideType]
	
	if handlerName then
		if handlerName == "" then
            return GuideHandler.new(controller, step)
        end
		return import(handlerName, CURRENT_MODULE_NAME).new(controller, step)
	else
        assert(false, "GuideHandler 所要创建的类型:" .. guideType .. "不存在！！如不需要Handler请填空字符串！！")
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////

function GuideHandler:ctor(controller, step)
	self._controller = controller
	self._guideStep  = step

	self:onCreate()
end

--
-- 获取引导主控制器。
--
function GuideHandler:getController()
	return self._controller
end

--
-- 获取处理的引导步骤数据。
--
function GuideHandler:getGuideStep()
	return self._guideStep
end

--
-- 获取操作数据。
--
function GuideHandler:getOperateDataPkg()
	local guideStep = self:getGuideStep()
	if guideStep then
		return guideStep:getOperateDataPkg()
	end
end

--
-- 当创建完毕。
--
function GuideHandler:onCreate()
end

--
-- 当接收到外来的引导事件。
--
function GuideHandler:onReceiveEvent(event)
end

--
-- 开始执行处理。
--
function GuideHandler:onExecute()
	local operatePkg = self:getOperateDataPkg()

    -- 关闭窗口选项
    if operatePkg:isBackDesktop() then
        -- 关闭所有窗口，包括底部和顶部的导航菜单栏
        GlobalWinManger:closeAllWindow()
        if GlobalModel.hideNavigation then
            GlobalEventSystem:dispatchEvent(SceneEvent.OPEN_NAV)
        end
        GlobalEventSystem:dispatchEvent(GlobalEvent.HIDE_TOP_NAV_BAR)
    end

-- 打开窗口选项
    local openWindowTags = operatePkg:openWindowTags()
    if openWindowTags then
        -- 遍历 openWindowTags 打开需要的窗口。
        for _, v in ipairs(openWindowTags) do
            if v == "navigation_bar" then
                if not GlobalModel.hideNavigation then
                    GlobalEventSystem:dispatchEvent(SceneEvent.OPEN_NAV)
                end
            elseif v == "top_navigation_bar" then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_TOP_NAV_BAR)
            else
                -- 如果存在这个窗口则打开
                for _, existName in pairs(WinName) do
                    if existName == v then
                        GlobalWinManger:openWin(existName)
                        break
                    end
                end
            end
        end
    end
end

--
-- 结束处理。
--
function GuideHandler:onDeath()
end

--
-- 过滤事件并返回，如果事件被过滤掉则返回nil。
--
function GuideHandler:filterEvent(event)
	if not event then return end
	local identify = event:getIdentify()

	if self._guideStep and self._guideStep:checkIdentify(identify) then
		return event
	end
end

return GuideHandler