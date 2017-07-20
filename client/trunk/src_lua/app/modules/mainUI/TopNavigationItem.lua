--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-25 16:39:58
--

local TopNavigationItem = class("TopNavigationItem", function()
	return display.newNode()
end)

function TopNavigationItem:setData(data)
	self:setScale(0.95)
	self._data = data
	self:invalidateData()
	self:setCascadeOpacityEnabled(true)

	if data.function_id == 40 then-- 开服活动
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE,self,22,22)
	elseif data.function_id == 19 then -- 日常活动
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVITY_DAILY,self,22,22)
	elseif data.function_id == 41 then -- 限时活动
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_TIME,self,22,22)
	elseif data.function_id == 22 then -- 挂机
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_HOOK,self,22,22)
	elseif data.function_id == 16 then -- 沙巴克
		--local btnTips = BaseTipsBtn.new(BtnTipsType.BIN_SBK,self,22,22)
	elseif data.function_id == 15 then -- 首充
		local btnTips = BaseTipsBtn.new(BtnTipsType.BIN_FIRST_CHARGR,self,22,22)
	elseif data.function_id == 27 then -- 下载奖励
		local btnTips = BaseTipsBtn.new(BtnTipsType.BIN_DOWNLOAD,self,22,22)
	elseif data.function_id == 17 then -- 今日目标
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_DAILY_TARGET,self,22,22)
	elseif data.function_id == 89 then
		local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_MERGE_ACTIVITY,self,22,22)
	end
	if data.function_id == 15 then
		self:showEffect("activityEffect")
	end
 
	if data.function_id == 70 then
		--self:showEffect("luckMoney_Effect")
		SoundManager:playSound(SoundType.HONG_BAO)
	end
	

	if data.function_id > 62 and  data.function_id < 68 then
		self:showEffect("luckMoney_Effect")
		SoundManager:playSound(SoundType.HONG_BAO)
	end
	
	if self.nodeEventId == nil then
		self.nodeEventId = self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	end
end

function TopNavigationItem:onNodeEvent(data)
    if data.name == "exit" then
    	self:close()
    end
end

function TopNavigationItem:close()
	self:clearEffect()
	if self.nodeEventId then
		self:removeNodeEventListenersByEvent(cc.NODE_EVENT)
		self.nodeEventId = nil
	end
end

function TopNavigationItem:showEffect(actionName)
	self.curGHEffID = actionName
	if ArmatureManager:getInstance():loadEffect(self.curGHEffID) then
		self.armatureEff = ccs.Armature:create(self.curGHEffID)
		--self.armatureEff:stopAllActions()    
    	self.armatureEff:getAnimation():play("effect")
    	self:addChild(self.armatureEff)
    	self.armatureEff:setLocalZOrder(1)
    	--self.armatureEff:setPosition(self.vo.pos.x,self.vo.pos.y)
    	--self:addChild(self.armatureEff)
    else
    	self.curGHEffID = nil
    	self.armatureEff = nil
	end
end

function TopNavigationItem:clearEffect()
	if self.armatureEff then
		self.armatureEff:getAnimation():stop()
		--self.armatureGHEff:stopAllActions()
		if self.curGHEffID then
			ArmatureManager:getInstance():unloadEffect(self.curGHEffID)
		end
		if self.armatureEff:getParent() then
			self.armatureEff:getParent():removeChild(self.armatureEff)
		end	
		self.armatureEff = nil
	end
end

--菜单位置
function TopNavigationItem:getRow()
	return self._data.position or 1
end


function TopNavigationItem:invalidateData()
	self:removeAllChildren()

	if self._data then
		local icon = display.newSprite("#" .. self._data.icon)
		self:addChild(icon)

		if self._data.btn_type == 2 then
			local effectBg = display.newSprite("#scene/scene_shade.png"):addTo(self)
			if self._data.time ~= "" then
 				local tip = display.newSprite("#scene/scene_coming.png"):addTo(self)
				--tip:setPosition(tip:getContentSize().width/2, tip:getContentSize().height/2)

				local txt = display.newBMFontLabel({
			            text = self._data.time,
			            font = "fonts/bitmapText_22.fnt",
			            })
			    txt:setTouchEnabled(false)
			    self:addChild(txt)
			    txt:setPosition(0,icon:getPositionY() - icon:getContentSize().height/2 - 10)
			    txt:setAnchorPoint(0.5,0.5)
			    txt:setColor(cc.c3b(0, 255, 13))
			    --txt:setScale(0.9)


				 -- local txt = display.newTTFLabel({
			  --       text = self._data.time,
			  --   --font = "Marker Felt",
			  --       size = 16,
			  --       align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
				 --   }):addTo(self)
				 -- txt:setColor(cc.c3b(0, 255, 13))
				 -- txt:setPositionY(icon:getPositionY() - icon:getContentSize().height/2 - 10)

				 --effectBg:setPosition(icon:getPositionX() + effectBg:getContentSize().width/2,icon:getPositionY() - effectBg:getContentSize().height/2)
				  effectBg:setPositionY(txt:getPositionY())
			else
				self:showEffect("scene_underwayEffect")
				if self.armatureEff then
					self.armatureEff:setPositionY(icon:getPositionY() - icon:getContentSize().height/2 - 10 )
					effectBg:setPositionY(self.armatureEff:getPositionY())
					effectBg:setLocalZOrder(-2)
				end
			end
		end

		--行会宣战
		if  self._data.function_id == 72  or self._data.function_id == 82  or self._data.function_id == 84 then
			self:showEffect("scene_underwayEffect")
			if self.armatureEff then
				local effectBg = display.newSprite("#scene/scene_shade.png"):addTo(self)
				self.armatureEff:setPositionY(icon:getPositionY() - icon:getContentSize().height/2 - 10 )
				effectBg:setPositionY(self.armatureEff:getPositionY())
				effectBg:setLocalZOrder(-2)
			end
		end

		icon:setTouchEnabled(true)
		icon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "ended" then
				SoundManager:playClickSound()
				icon:setScale(1)
				if self._data.function_id == 28 then --点击攻略时发送
					GameNet:sendMsgToSocket(9001,{id = 10,num = 0})
				elseif self._data.function_id == 15 then
					self:clearEffect()
				end

				if self._handler then
					self._handler(self._data)
				end
			elseif event.name == "began" then
				icon:setScale(1.1)
			end
			return true
		end)
	end
end

function TopNavigationItem:setOnItemClickeHandler(handler)
	self._handler = handler
end

return TopNavigationItem