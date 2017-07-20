--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-11 20:22:18
--
local GuideOperation = class("GuideOperation")

GuideOperation.TYPE_CLICK   = 1
GuideOperation.TYPE_WELCOME = 2
GuideOperation.TYPE_SLIDE   = 3
GuideOperation.TYPE_WAIT    = 4

local CURRENT_MODULE_NAME = ...

local MODEL_REGISTER = {
    [GuideOperation.TYPE_CLICK]   = ".GuideOperation_ClickType",
    [GuideOperation.TYPE_WELCOME] = "",
    [GuideOperation.TYPE_SLIDE]   = ".GuideOperation_SlideType",
    [GuideOperation.TYPE_WAIT]    = "",
}

--
-- Factory Method
--
function GuideOperation.create(operate_data)
    local guide_type  = operate_data.guide_type
    local handlerName = MODEL_REGISTER[guide_type]
    
    if handlerName then
        if handlerName == "" then
            return GuideOperation.new(operate_data)
        end
        return import(handlerName, CURRENT_MODULE_NAME).new(operate_data)
    else
        assert(false, "GuideOperation 所要创建的类型:" .. guide_type .. "不存在！！如不需要Model请填空字符串！！")
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GuideOperation:ctor(operate_data)
	self._operate_data = deepcopy(operate_data)
    self:initialization()
end

--
-- 初始化方法。
--
function GuideOperation:initialization()
end

--
-- 返回操作的唯一ID。
--
function GuideOperation:getOperateId()
	return self._operate_data.id
end

--
-- 获取引导类型。
--
function GuideOperation:getGuideType()
	return self._operate_data.guide_type
end

--
-- 获取引导操作元数据。
--
function GuideOperation:getGuideBody()
	return self._operate_data.guide_body_data
end

--
-- 本操作是否需要回到桌面。
--
function GuideOperation:isBackDesktop()
    return checknumber(self._operate_data.back_desktop) == 1
end

--
-- 获取本操作需要打开的窗口列表。
--
function GuideOperation:openWindowTags()
    local windowTag = self._operate_data.open_window
    if windowTag ~= 0 and windowTag ~= "no_open_window" and windowTag ~= "" then
        return string.split(windowTag, "|")
    end
end

--
-- 传入一个identity，判断这个identity是否是本操作感兴趣的一个标识。
--
function GuideOperation:checkIdentify(identify)
	return self:getOperateId() == identify
end

-- ///////////////////////////////////////////////////////////////////////////////
-- Utils -------------
-- 九点定位和点、矩形转换。

local maxW = display.width
local maxH = display.height
local cx   = display.cx
local cy   = display.cy
local TRANSFORM_COORD_BASE = {
    cc.p(0, maxH), cc.p(cx, maxH), cc.p(maxW, maxH),
    cc.p(0, cy),   cc.p(cx, cy),   cc.p(maxW, cy),
    cc.p(0, 0),    cc.p(cx, 0),    cc.p(maxW, 0),
}

--
-- 将一个点和这个点的9点坐标索引转换为对应的坐标位置。
--
local function transform9Point(type, point)
    local baseCoord = TRANSFORM_COORD_BASE[type]
    if baseCoord then
        point.x = point.x + baseCoord.x
        point.y = point.y + baseCoord.y
    end
end

--
-- 传入一个字符串，返回这个字符串所代表的点。
--
function GuideOperation:convertPointByString(pointStr, posType)
    if pointStr and pointStr ~= "" then
        local arr = string.split(pointStr, ",")
        local point = cc.p(tonumber(arr[1]), tonumber(arr[2]))
        transform9Point(posType, point)
        return point
    end    
end

--
-- 传入一个字符串，返回这个字符串所代表的矩形区域。
--
function GuideOperation:convertRectangleByString(rectStr, posType)
    if rectStr and rectStr ~= "" then
        local arr = string.split(rectStr, ",")
        local rect = cc.rect(tonumber(arr[1]), tonumber(arr[2]), tonumber(arr[3]), tonumber(arr[4]))
        transform9Point(posType, rect)
        rect.y = rect.y - rect.height
        return rect
    end
end

return GuideOperation