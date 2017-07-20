--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-06-30 14:24:58
-- 连连看动画管理器
local sharedDirector         = cc.Director:getInstance()
local sharedTextureCache     = cc.Director:getInstance():getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local sharedAnimationCache   = cc.AnimationCache:getInstance()

local McManager = McManager or class("McManager")
function McManager:ctor()
	self:initConfig()
end

function McManager:initConfig()
	self.animationCache = {}
	self.animationKeyCache = {}
	self.spriteFrameCache = {}
end

function McManager:getAnimation(key,imageList,time)	
	if self.animationCache[key] and display.getAnimationCache(key) then

	else
		self.animationKeyCache[key] = imageList
		local frames = {}
		for i=1,#imageList do
			print(imageList[i])
			local frame = sharedSpriteFrameCache:getSpriteFrame(imageList[i])
			if not frame then
        		printError("McManager:getAnimation() - invalid frameName %s", tostring(frameName))
    		else
    			
    			self.spriteFrameCache[imageList[i]] = true
    		end
    		frames[i] = frame
		end
		time = time or 1/20
		local animation = display.newAnimation(frames, time)
		display.setAnimationCache(key, animation)
		self.animationCache[key] = true
	end
	return display.getAnimationCache(key)
end

function McManager:removeAnimationCache(key)	
	display.removeAnimationCache(key)
	local list = self.animationKeyCache[key]
	if list then
		for i=1,#list do
			display.removeSpriteFrameByImageName(list[i])
			self.spriteFrameCache[list[i]] = nil
		end
	end
	self.animationCache[key] = nil
	self.animationKeyCache[key] = nil
end


function McManager:addSpriteFrames(plistFilename, image, handler)
	display.addSpriteFrames(plistFilename, image, handler)
end

function McManager:removeSpriteFramesWithFile(plistFilename, imageName)
	display.removeSpriteFramesWithFile(plistFilename, imageName)
end



function McManager:removeSpriteFrameByImageName(key)
	display.removeSpriteFrameByImageName(list[i])
	self.spriteFrameCache[list[i]] = nil
end

function McManager:destory()
	for k,v in pairs(self.animationKeyCache) do
		for i=1,#v do
			display.removeSpriteFrameByImageName(v[i])
			self.spriteFrameCache[v[i]] = nil
		end
		self.animationKeyCache[k] = nil
	end

	self.animationCache = {}
	self.animationKeyCache = {}
	self.spriteFrameCache = {}
	display.removeUnusedSpriteFrames()
end

function McManager:playAnimationForever(target, animation, delay)
	return transition.playAnimationForever(target, animation, delay)
end

function McManager:playAnimationOnce(target, animation, removeWhenFinished, onComplete, delay)
	return transition.playAnimationOnce(target, animation, removeWhenFinished, onComplete, delay)
end

--停止一个正在执行的动作
function McManager:removeAction(action)
	transition.removeAction(action)
end

--停止一个显示对象上所有正在执行的动作
function McManager.stopTarget(target)
    transition.stopTarget(action)
end

-- 暂停显示对象上所有正在执行的动作
function McManager.pauseTarget(target)
    transition.pauseTarget(target)
end

return McManager

-- display.newSpriteFrame(frameName)
-- display.newAnimation(frames, time)

-- display.setAnimationCache(name, animation)

-- display.getAnimationCache(name)
-- display.removeAnimationCache(name)

-- display.removeUnusedSpriteFrames()

-- display.removeSpriteFrameByImageName(imageName)
