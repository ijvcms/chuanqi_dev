--
-- Author: zhangshunqiu
-- Date: 2015-02-04 15:39:56
-- 进度条
local ProgressBar = class("ProgressBar", function()
	return display.newNode()
end)


function ProgressBar:ctor(data)
	data= data or {}
	self.style = data.style or 2
	local bgColor = data.bgColor or display.BG_COLOR_WHITE
	local leftColor = data.leftColor or display.BG_COLOR_GREEN
	local rightColor = data.rightColor or display.BG_COLOR_YELLOW
	self.width = data.width or 300
	local height = data.height or 20
	self.percent = data.percent or 20
	self.leftBar = nil
	self.rightBar = nil
	self.bg = nil

	if self.style == 1 then
		self:creatStyle1(self.width,height,leftColor,rightColor,bgColor)
	elseif self.style == 2 then
		self:creatStyle2(self.width,height,leftColor,rightColor,bgColor)
	end 
end


function ProgressBar:setPercent(value,ismove)
	self.percent = value
	if self.style == 1 then
		if ismove == nil then
			ismove = true
		end	
		self:setPercent1(value,ismove)
	elseif self.style == 2 then
		self:setPercent2(value)
	end	
	
end	

--清理
function ProgressBar:destory()
end	

--内部函数 创建样式1
function ProgressBar:creatStyle1(width,height,leftColor,rightColor,bgColor)
	local bg = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = bgColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(bg)	

	self.rightBar = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = rightColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(self.rightBar)

	self.leftBar = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = leftColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(self.leftBar)

	local p = self.percent/100
	-- self.leftBar:setWidth(50)
	self.leftBar:setScaleX(p)
	-- self.rightBar:setScaleX(1-p)
	-- self.rightBar:setPositionX(self.width*p)
end
----内部函数,设置样式1的进度
function ProgressBar:setPercent1(value,ismove,time)
	time = time or 0.5
	self.percent = value
	local p = self.percent/100
	--self.leftBar:setScaleX(p)
	-- if self.rightBar then 
	-- 	self.rightBar:setScaleX(1-p)
	-- 	self.rightBar:setPositionX(self.width*p)
	-- end	
	if ismove then
		transition.scaleTo(self.leftBar, {scaleX = p, time = time})
	else
		self.leftBar:setScaleX(p)
	end
end	

--样式1END

----内部函数 创建样式2
function ProgressBar:creatStyle2(width,height,leftColor,rightColor,bgColor)
	local bg = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = bgColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(bg)	

	self.rightBar = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = rightColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(self.rightBar)

	self.leftBar = display.newRect(cc.rect(0, 0, width, height),
        {fillColor = leftColor, borderColor = cc.c4f(1,1,1,1), borderWidth = 0})
	self:addChild(self.leftBar)

	local p = self.percent/100
	-- self.leftBar:setWidth(50)
	self.leftBar:setScaleX(p)
	self.rightBar:setScaleX(-1)
	self.rightBar:setPositionX(self.width)
end
----内部函数,设置样式2的进度
function ProgressBar:setPercent2(value,time)
	time = time or 0.5
	self.percent = value
	local p = self.percent/100
	--self.leftBar:setScaleX(p)
	-- if self.rightBar then 
	-- 	self.rightBar:setScaleX(1-p)
	-- 	self.rightBar:setPositionX(self.width*p)
	-- end	
	self.leftBar:setScaleX(0)
	self.rightBar:setScaleX(0)
	transition.scaleTo(self.leftBar, {scaleX = p, time = time})
	transition.scaleTo(self.rightBar, {scaleX = p-1, time = time})
end
--样式2END



return ProgressBar