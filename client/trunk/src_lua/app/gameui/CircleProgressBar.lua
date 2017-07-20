--
-- Author: zhangshunqiu
-- Date: 2015-02-04 16:46:53
-- 圆形进度条

--data格式
--{percent = 0,bgImage = "res/publicUI/reward_day_green@2x.png",barImage = "res/publicUI/reward_day_orange@2x.png",scale = 1}
--用法 
--crile:setPercent(value)
--crile:autoToPercent(60,1)
local CircleProgressBar = class("CircleProgressBar", function()
	return display.newNode()
end)


function CircleProgressBar:ctor(data)	
	self.data = data or {}
	self:createBar()
end

--创建进度条
function CircleProgressBar:createBar()
	local bgImage = self.data.bgImage or "#scene/scene_skillCDRoundBg.png"
	local barImage = self.data.barImage or "#scene/scene_skillCDRound.png"
	local bgColor = self.data.bgColor
	local barColor = self.data.barColor

	local scale = self.data.scale or 1
	self.percent = self.data.percent or 0
	local isReverse = self.data.isReverse or false --是否反转，正常是顺时针，反转是逆时钟

	local bg = display.newSprite(bgImage)
	bg:setPosition(0,0)
	self:addChild(bg)
	bg:setTouchEnabled(false)
	bg:setTouchSwallowEnabled(false)
	bg:setTouchCaptureEnabled(true)
	if bgColor then
		bg:setColor(bgColor)
	end
	--bg:setAnchorPoint(0.5,0.5)

	self.progress = display.newProgressTimer(barImage, display.PROGRESS_TIMER_RADIAL)
	self.progress:setPosition(0,0)	
	self.progress:setTouchEnabled(false)
	self.progress:setTouchSwallowEnabled(false)
	self.progress:setTouchCaptureEnabled(true)
	self:addChild(self.progress)
	self.progress:setReverseDirection(isReverse)
	self.progress:setPercentage(self.percent)
    self:scale(scale)
    if barColor then
    	self.progress:setColor(barColor)
    end
end

--设置当前进度
--@param value 当前百分比 [0-100]
function CircleProgressBar:setPercent(value)
	value = math.min(100,math.max(0,value))
	self.percent = value
	if self.progress then
		self.progress:setPercentage(self.percent)
	end
end	

--滚动到当前进度
--@param number value 当前百分比 [0-100]
--@param number time  需要的事件 秒
function CircleProgressBar:autoToPercent(value,time)
	value = math.min(100,math.max(0,value))
	local to2 = cc.ProgressTo:create(time, value);
    self.progress:runAction(to2);
	self.percent = value	
end

--清理
function CircleProgressBar:destory()
end	


return CircleProgressBar