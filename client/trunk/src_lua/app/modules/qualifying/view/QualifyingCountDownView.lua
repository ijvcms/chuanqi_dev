--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-18 15:04:07
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local QualifyingCountDownView = class("QualifyingCountDownView", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 100))
end)

local RESOURCE_PLIST = "resui/qualifyingCountDown.plist"
local RESOURCE_PNG   = "resui/qualifyingCountDown.png"


function QualifyingCountDownView:ctor()
	self:initialization()
end

--[[
	使用方法：
		-- 先导入：
		local QualifyingCountDownView = import("app.modules.qualifying.view.QualifyingCountDownView")

		-- 使用
		local view = QualifyingCountDownView:new()
		view:Start()
		view:SetOnCompleteCallback(function(ref)
			-- 这里处理
			ref:Destory()
		end)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, view)
]]

----------------------------------------------------------------------------------------
--  导出方法，你只需要调用这几个方法即可。

--
-- 开始执行。
--
function QualifyingCountDownView:Start()
	self:clearTimer()
	self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
	self:onTimerHandler()
end

--
-- 设置指定完毕之后将会调用到的回调函数。
-- 你所指定的回调方法将会被执行并且传入一个参数，那个参数就是这个类实例。
--
function QualifyingCountDownView:SetOnCompleteCallback(callback)
	self._callback = callback
end

--
-- 销毁。
--
function QualifyingCountDownView:Destory()
	self:clearTimer()
	self:removeFromParent()
	display.removeSpriteFramesWithFile(RESOURCE_PLIST, RESOURCE_PNG)
end



----------------------------------------------------------------------------------------
-- 内部方法
function QualifyingCountDownView:initialization()
	display.addSpriteFrames(RESOURCE_PLIST, RESOURCE_PNG)
	self:initComponents()
	
end

function QualifyingCountDownView:initComponents()
	local sprites = {"#countdown_3.png", "#countdown_2.png", "#countdown_1.png", }
	self._sprites = sprites
end

--
-- 清除计时器。
--
function QualifyingCountDownView:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

--
-- 移除当前场景上的精灵。
--
function QualifyingCountDownView:removeCurrentSprite()
	if self._currentSprite then
		self._currentSprite:removeFromParent()
		self._currentSprite = nil
	end
end

--
-- 添加一个精灵到当前的场景上。
--
function QualifyingCountDownView:addCurrentSprite(sprite)
	if sprite then
		self._currentSprite = sprite
		sprite:center()
		self:addChild(sprite)
	end
end

--
-- 获取下一个精灵。
--
function QualifyingCountDownView:getNextSprite()
	local sprites = self._sprites
	if sprites and #sprites > 0 then
		local textureName = table.remove(sprites, 1)
		return display.newSprite(textureName)
	end
	return nil
end

--
-- 计时器处理方法。
--
function QualifyingCountDownView:onTimerHandler()
	self:removeCurrentSprite()
	local nextSprite = self:getNextSprite()
	if nextSprite then
		self:addCurrentSprite(nextSprite)
	else
		self:onComplete()
	end
end

--
-- 执行完毕。
--
function QualifyingCountDownView:onComplete()
	self:clearTimer()
	if self._callback then
		self._callback(self)
	end
end

return QualifyingCountDownView