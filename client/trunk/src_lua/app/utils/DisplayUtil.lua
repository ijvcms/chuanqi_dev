--
-- Author: Evans
-- Date: 2013-12-14 11:01:20
--
local DisplayUtil = {}
regObjInGlobal("DisplayUtil",DisplayUtil)
socket = require "socket"

--用UI的坐标系去定位
function DisplayUtil.posUI( target,x,y,parent )
	-- display.align(target, display.TOP_LEFT)

	if parent then
		-- display.align(parent, display.TOP_LEFT)
		target:pos(x, -y)
	else
		local p = CCDirector:sharedDirector():convertToUI(CCPoint(x,y))
		target:pos(p.x, p.y)
	end
	
	return target
end

local STR_MATCH_RGB = {"#","0x","ox"}

--将"#FFFFFF","0XFFFFFF"或"FFFFFF"转换为CCC3颜色对象
function DisplayUtil.convertToCCC3(v)
	if not v then
		return cc.c3b(0, 0, 0)
	end

	v = tostring(v)
	local s,e
	--找颜色值开始下标
	for _,strMatch in ipairs(STR_MATCH_RGB) do
		s,e = string.find(v, strMatch)
		if e then
			break
		end
	end

	e = (e and e + 1) or 1

	local function getRGB( str )
		if string.len(str) == 1 then
			str = string.rep(str, 6)
		elseif string.len(str) == 2 then
			str = "0000" .. str
		elseif string.len(str) == 3 then
			local r = string.sub(str, 1,1)
			local g = string.sub(str, 2,2)
			local b = string.sub(str, 3,3)
			local t = {r,r,g,g,b,b}
			str = table.concat(t)
		elseif string.len(str) == 4 then
			str = "00" .. str
		end
		return tonumber(string.sub(str, 1,2),16),tonumber(string.sub(str, 3,4),16),tonumber(string.sub(str, 5,6),16)
	end

	v = string.sub(v,e)
	return cc.c3b(getRGB(v))
end

--type_ == 1   将   180  秒   转换成   03：00
--type_ == 2   转换成 03分00秒
--type_ == 3    返回 分  秒
function DisplayUtil:convertToTime(time, type_, format)
	time = checkint(time)
	type_ = type_ or 1

	local str
	local sec,min,hour,day = 0,0,0,0
	local flagSec,flagMin,flagHour,flagDay

	if type_ == 1 or type_ == 3 then
		flagSec,flagMin,flagHour,flagDay = "",":",":","-"
	elseif type_ == 2 then
		flagSec,flagMin,flagHour,flagDay = LANG.SECOND,
			LANG.MINUTE,LANG.HOUR,LANG.DAY
	end

	str = format or ("$2" .. flagMin .. "$1" .. flagSec)
	sec = time % 60
	-- str = sec .. flagSec

	if time >= 60 then
		-- str = "$2" .. flagMin .. str
		min = math.floor(time / 60) --总分钟数

		if min >= 60 then
			if not format then
				str = "$3" .. flagHour .. str
			end
			
			hour = math.floor(min / 60) --总小时数

			if hour >= 24 then
				if not format then
					str = "$4" .. flagDay .. str
				end
				day = math.floor(hour / 24)
			end
		end
	end



	if type_ == 3 then
		return min,sec
	else
		min = min % 60
		hour = hour % 24
		sec = string.format("%02d", sec)
		min = string.format("%02d", min)
		hour = string.format("%02d", hour)
		return StringUtil.replaceKeyVal(str,{sec,min,hour,day})
	end



	-- type_ = type_ or 1
	-- local min_ = math.floor(leftTime / 60)
	-- local sec_ = math.floor(leftTime % 60)
	-- if checkint(min_) < 10 then
	-- 	min_ = "0"..min_
	-- end
	-- if checkint(sec_) < 10 then
	-- 	sec_ = "0"..sec_
	-- end
	-- if type_ == 2 then
	-- 	return min_..LANG.MINUTE..sec_..LANG.SECONDS
	-- end
	-- if type_ == 3 then
	-- 	return min_, sec_
	-- end
	-- return min_..":"..sec_
end

--检测是否需要改变播放频率
-- function DisplayUtil:checkInterval(num_, attackRectType, action)
--     if attackRectType == 2 then
--     	if action ~= nil then
--     		if action == "attack1" or action == "attack2" or action == "attack3" or action == "attack4" then
--     			return self:checkNum(num_)
--     		end
--     	else
--     		return self:checkNum(num_)
--     	end
--     end
--     return num_
-- end

-- function DisplayUtil:checkNum(num_)
-- 	local num = num_ + 1
--     return num
-- end

--检测武器类型
-- function DisplayUtil:checkWeaponType(actor_)
--     if checkint(actor_:getValue("weapon_type")) == ITEM.ID_EQ_SPEAR then--武器类型，2为枪
--         return 2
--     end
--     return 1--攻击区域类型，  1为正常，2为更长一些
-- end

--检测需要不需要打得更远一点
-- function DisplayUtil:checkPos(x_, y_, isRight, attackRectType, effect_x, effect_y)
-- 	if effect_x == nil then
-- 		effect_x = 0
-- 	end
-- 	if effect_y == nil then
-- 		effect_y = 0
-- 	end
--     if attackRectType == 2 then
--         if isRight == true then
--             return x_ - FIGHT_QIANG_ATTACK_X - effect_x, y_ + effect_y
--         else
--             return x_ + FIGHT_QIANG_ATTACK_X + effect_x, y_ + effect_y
--         end
--     end
--     if isRight == true then
--         return x_ - effect_x, y_ + effect_y
--     else
--         return x_ + effect_x, y_ + effect_y
--     end
--     return x_, y_
-- end

--将弧度转换成角度
function DisplayUtil.toAngle(radian)
	return 180 / math.pi * radian
end


--将角度转换成弧度
function DisplayUtil.toRadian(angle)
	return math.pi / 180 * angle
end


--对齐
--对齐完后是否更新位置
function DisplayUtil.align(target, align, x, y, update)
	local oap = target:getAnchorPoint()
	if type(align) == "number" then
		display.align(target, align, x, y)
	else
		target:setAnchorPoint(align)
    	if x and y then target:setPosition(x, y) end
	end
	
	if update then
		local ap = target:getAnchorPoint()
		local x,y
		local w,h
		-- if target:getComponent("MUIProtocol") then
		-- 	w,h = target:getLayoutSize()
		-- 	x,y = target:getPos()
		-- else
			local size = target:getCascadeBoundingBox()
			w,h = size.width,size.height
			x,y = target:getPositionX(),target:getPositionY()
		-- end

		local ox = (ap.x - oap.x) * w
		local oy = (ap.y - oap.y) * h

		x = x + ox
		y = y + oy

		-- if target.posOri_ then
		-- 	target.posOri_ = {x,y}
		-- end
		-- if target.sourceProps_ then
		-- 	local table = target.sourceProps_
		-- 	table.x = table.x and (table.x + ox) or nil
		-- 	table.y = table.y and (table.y + oy) or nil

		-- 	table.centerX = table.centerX and (table.centerX + ox) or nil
		-- 	table.centerY = table.centerY and (table.centerY + oy) or nil

		-- 	table.left = table.left and (table.left + ox) or nil
		-- 	table.right = table.right and (table.right + ox) or nil

		-- 	table.top = table.top and (table.top + oy) or nil
		-- 	table.bottom = table.bottom and (table.bottom + oy) or nil
		-- end

		target:pos(x,y)
	end

	return target
end


timePerform_ = {}
function DisplayUtil.markTime(flag)
	if IS_RELEASE then
		return
	end
	timePerform_[flag] = socket.gettime()
end

function DisplayUtil.computeTime(flag)
	if IS_RELEASE then
		return
	end
	if not timePerform_ or not timePerform_[flag] then
		-- print("未记录时间")
		return
	end
	local time = (socket.gettime() - timePerform_[flag]) * 1000
	-- if time >= 5 then
		printInfo(">>>>>>>>>>%s:%s", flag, time)
	-- end

	-- timePerform_[flag] = nil
end

--获得对象的中心点
function DisplayUtil.getCenterPoint(obj)
	return DisplayUtil.getObjPoint(obj)
end



--获取对象指定位置的位置
function DisplayUtil.getObjPoint(obj,p)
	p = p or display.CENTER
	p = display.ANCHOR_POINTS[p]
	local w,h
	if obj:getComponent("MUIProtocol") then
		w,h = obj:getLayoutSize()
	else
		local size = obj:getCascadeBoundingBox().size
		w,h = size.width,size.height
	end

	local ap = obj:getAnchorPoint()
	local x,y = obj:getPos()

	return ccp((p.x - ap.x) * w, (p.y - ap.y) * h)
end

--获得对象缩放后的位置
--obj 目标对象
--scale 目标缩放比
--cscale 当前缩放比
function DisplayUtil.getObjPos(obj, scale, cscale)
	scale = scale or 1
	-- local ox,oy = obj:getOriginPos()
	local os = cscale or obj:getScale()
	local ox,oy = obj:getPosition()
	local ow,oh = obj:getContentSize().width, obj:getContentSize().height
	local ap = obj:getAnchorPoint()
	
	local dw = (scale - os) * ow
	local dh = (scale - os) * oh

	return ox + (ap.x - 0.5) * dw,oy + (ap.y - 0.5) * dh
end

-- function DisplayUtil.dumpRect(rect, ...)
-- 	if not rect then
-- 		return
-- 	end
-- 	local ori = rect.origin
-- 	local size = rect.size
-- 	local param = {...}
-- 	if #param > 0 then
-- 		for i,v in ipairs(param) do
-- 			if type(v) ~= "string" then
-- 				param[i] = tostring(v)
-- 			end
-- 			-- param[i] = tostring(v)
-- 			-- if type(v) == "boolean" then
-- 			-- 	v = v and "true" or "false"
-- 			-- end
-- 		end
-- 		param = table.concat(param,",")
-- 	else
-- 		param = ""
-- 	end
-- 	printInfo("rect info--->origin:%s,%s  size:%s,%s  %s",ori.x,ori.y,size.width,size.height,param)
-- end

--有否显示的父对象,全部父对象显示才返回true
function DisplayUtil.hasVisibleParents(target)
	-- local target = self.target_

	local parent = target

	local visible
	while parent do
		visible = parent:isVisible()
		if not visible then
			return false
		end
		parent = parent:getParent()
	end
	return true
end


--转换语言包内容
function DisplayUtil.parseLabel(label)
    if label and string.trim(label) ~= "" then
        if string.find(label, "+") then
            local keys = string.split(label, "+")
            for i,v in ipairs(keys) do
                if string.find(v, "&") then
                    local lbl,str = unpack(string.split(v, "&"))
                    assert(LANG[lbl],string.format("LANG [%s] not exist!", lbl))
                    keys[i] = LANG[lbl] .. str
                else
                    assert(LANG[v],string.format("LANG [%s] not exist!", v))
                    keys[i] = LANG[v]
                end
            end
            
            label = table.concat(keys)
        elseif string.find(label, "&") then
            local lbl,str = unpack(string.split(label, "&"))
            if lbl and string.trim(lbl) ~= "" then
                assert(LANG[lbl],string.format("LANG [%s] not exist!", lbl))
                lbl = LANG[lbl]
            else
                lbl = ""
            end
            
            label = lbl .. str
        else
            assert(LANG[label],string.format("LANG [%s] not exist!", label))
            label = LANG[label]
        end
    else
        label = ""
    end

    return label
end


--将图片扩展为按钮
function DisplayUtil.extendToBtn(img,clickHandler)
    img:setNodeEventEnabled(true)
    local funcToBtn = function(self,cHandler)
        self:setTouchEnabled(true)
        -- self:addTouchEventListener(handler(self, DisplayUtil.onImgTouch_,clickHandler))
        self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler({target = self,cHandler = cHandler}, DisplayUtil.onImgTouch_))
    end

    local of1 = img.onEnter
    img.onEnter = function(self)
        if of1 then
            of1(self)
        end
        funcToBtn(self,clickHandler)
    end

    local of2 = img.onExit
    img.onExit = function(self)
        if of2 then
         of2(self)
        end
        self:setTouchEnabled(false)
        -- self:removeTouchEventListener()
        self:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    end

    if not img:isTouchEnabled() and img:isRunning() then
        funcToBtn(img,clickHandler)
        -- img:setTouchEnabled(true)
        -- img:addTouchEventListener(handler(img, DisplayUtil.onImgTouch_,clickHandler))
        -- img:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler({target = img,cHandler = clickHandler}, DisplayUtil.onImgTouch_))
    end
end

function DisplayUtil.onImgTouch_(data,evt)
    -- print(img:getUIName())
    local img = data.target
    local clickHandler = data.cHandler
    if evt.name == "began" then
        return true
    elseif evt.name == "ended" and cc.rectContainsPoint(img:getCascadeBoundingBox(), ccp(evt.x, evt.y)) then
        clickHandler()
    end
end

--扩展sprite
function DisplayUtil.extendSprite(sprite)
    if sprite.hasSizeExtend_ then
        return sprite
    end
    local of = sprite.setContentSize
    sprite.setContentSize = function(self,size)
        local width,height = size.width,size.height

        
        local boundingSize = self:getContentSize()
        -- local sx = width / (boundingSize.width / self:getScaleX())
        local sx = width / boundingSize.width
        -- local sy = height / (boundingSize.height / self:getScaleY())
        local sy = height / boundingSize.height
       
        self:setScaleX(sx)
        self:setScaleY(sy)

        self.hasSizeExtend_ = true
        -- of(self,size)
        return self
    end

    return sprite
end

--创建扩展sprite
function DisplayUtil.newExtendSprite(url,x,y)
    return DisplayUtil.extendSprite(display.newSprite(url, x, y))
end

return DisplayUtil