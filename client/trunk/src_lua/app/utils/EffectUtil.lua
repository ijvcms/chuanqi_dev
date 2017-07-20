--
-- Author: Kelvin
-- Date: 2014-04-10 11:39:27
--

local EffectUtil = {}
regObjInGlobal("EffectUtil", EffectUtil)



-- function EffectUtil.newUnlockEff(x, y)
-- 	ResManager:loadResFile("effect_unlock", "ui_effect", 0)
-- 	local node = display.newNode()
-- 	local f1 = display.newSprite("#effect_unlock_00001.png"):addTo(node, 1)
-- 	local f2 = display.newSprite("#effect_unlock_00002.png"):addTo(node, 0)
-- 	f2:setScale(1.4)
-- 	local frames = { display.newSpriteFrame("effect_unlock_00002.png"), display.newSpriteFrame("effect_unlock_00003.png")}
-- 	local animation = display.newAnimation(frames, 0.3)
-- 	transition.playAnimationForever(f2, animation)
-- 	transition.execute(f1, CCFadeIn:create(0.5))
-- 	node:setPosition(ccp(x, y))
-- 	return node
-- end

--播放特效/音效/飘字
--tEff 	特效参数表,{pName = 材质名称,
--		key = 特效动画替换的KEY值,
--		idStart = 特效起始ID,
--		idEnd = 特效结束ID,
--		time = 特效播放时间,
--		parent = 特效添加到的父容器,
--		pos = 位置对象(ccp),
--		convertParent = 转换为世界坐标的父容器
--		loop = 是否不断播放,
--		resKind = resManager里面资源的kind，如果没有则默认是ui_effect}
--		scale = 缩放比
--tSound 	音效参数表,{path = 路径,loop = 是否循环}
--delay 	延迟多久播放
--zorder 	Z深度
--tag 	TAG
function EffectUtil.playOperationEff(tEff ,tSound, delay, zorder, tag)
	local node
	if tEff then
		assert(tEff.parent,"parent is missing!")
		if tEff.pName then
			if tEff.resKind then
				ResManager:loadResFile(tEff.pName, tEff.resKind, 0)
			else
				ResManager:loadResFile(tEff.pName, "ui_effect", 0)
			end
		end
		tEff.idStart = tEff.idStart or 1
		node = display.newSprite(string.format("#" .. tEff.key, tEff.idStart))

		node.clean = function(self)
			transition.stopTarget(self)
			if self:getParent() then
				self:removeSelf()
			end
		end
			
		local frames = display.newFrames(tEff.key, tEff.idStart, tEff.idEnd - tEff.idStart + 1)
		local animation = display.newAnimation(frames, tEff.time and tEff.time / (tEff.idEnd - tEff.idStart + 1))
		if tEff.loop then
			transition.playAnimationForever(node, animation,delay)
			-- node:playAnimationForever(animation)
		else
			transition.playAnimationOnce(node,animation, true,nil,delay)
		end

		if tolua.isnull(tEff.parent) then
			node:clean()
			return nil
		end
		node:align(display.CENTER):scale(tEff.scale or 1):addTo(tEff.parent, zorder, tag)

		if tEff.pos then
			if tEff.convertParent then
				tEff.pos = tEff.convertParent:convertToWorldSpace(tEff.pos)
				tEff.pos = tEff.parent:convertToNodeSpace(tEff.pos)
			end
			node:setPosition(tEff.pos)
		end
	end

	if tSound then
		assert(tSound.path,"path is missing")
		SoundManager:playSound(tSound.path,tSound.loop)
	end

	return node
end



--闪烁对象
--obj 	目标对象
--color 	闪烁颜色
--delay 	闪烁延迟时间/快慢,单位:秒
--times 	闪烁次数,无则不断闪烁
function EffectUtil.flickerObj(obj, color, delay, times)
	assert(obj and tolua.cast(obj, "CCNode"),"obj must not be nil")
	assert(color,"color is nil!")

	local ocolor = obj:getColor()
	delay = delay or 0.5

	local flicker = function(data,dt)
		data.counter = data.counter + 1
		if data.counter >= data.beat then
			data.counter = 0
			data.playTimes = data.playTimes + 1
			
			data.target:setColor(data.colors[data.playTimes % 2 + 1])
			if data.playTimes % 2 == 0 and data.times then
				data.times = data.times - 1
				if data.times <= 0 then
					data.target:unscheduleUpdate()
					-- data.target:removeNodeEventListenersByTag(1001)
					data.target:removeNodeEventListener(data.target.handleFlicker_)
					data.target.handleFlicker_ = nil
				end
			end
		end
	end
	if obj.handleFlicker_ then
		obj:unscheduleUpdate()
		obj:removeNodeEventListener(obj.handleFlicker_)
		obj.handleFlicker_ = nil
	end
	obj.handleFlicker_ = obj:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler({
		target = obj,
		colors = {ocolor,color},
		times = times,
		counter = 0,
		beat = DEFAULT_FPS * delay,
		playTimes = 0,
		}, flicker))
	obj:scheduleUpdate()
end


return EffectUtil