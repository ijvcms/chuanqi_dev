--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-20 18:23:03
-- 场景NPC

SceneNpc = SceneNpc or class("SceneNpc",function()
	return display.newNode()
end)


function SceneNpc:ctor(roleVO)
	self:setTouchEnabled(false)
	self.isPause = false
	self.vo = roleVO
	self.activityStates = ""
	
	--中间模型层
	self.modelLayer = self:creatLayer()
	self:addChild(self.modelLayer)
	if self.headContainer == nil then
		self.headContainer = display.newNode()
		GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_TOP_CONTAINER,self.headContainer)
	end
	
	self.actionIndex = 1 --角色动作Index
	self.roleXScale = 1 --角色X轴缩放
	self.scaleParam = roleVO.scaleParam or 1 --总体缩放
	--姓名label
	self.nameLabel = nil

	self.isSceneElement = false

	if self.vo.npcType == 5 then --是场景物品类型
		self.isSceneElement = true
	end

	self.animationSpeed = 0.9  --动画播放速率
	self.curAnimaSpeed = self.animationSpeed  --当前动画的速率
 	self.fightControll = GlobalController.fight

	--self:creatModel()
	GlobalController.model:pushModel(self.vo.modelID, self, "creatModel")
	if self.isSceneElement == false then
		self:setName(self.vo.name)
	end
	self:updateTaskTip(roleVO.showTaskTip)
end


--清理
function SceneNpc:destory()
	self.isDestory_ = true
	if self.shadow then
		FightEffectManager:removeShadowEff(self.shadow)
		self.shadow = nil
	end 
	if self.headContainer then
		if self.headContainer:getParent() then
			self.headContainer:getParent():removeChild(self.headContainer)
		end
		self.headContainer = nil
	end
	self:stopAllActions()
	if self.armature then
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
	end
	self.activityStates = ""
	self.isSelected = nil
	ArmatureManager:getInstance():unloadModel(self.vo.modelID)
	if self:getParent() then
		self:getParent():removeChild(self)
	end	
end


--暂停
function SceneNpc:pause()
	self.isPause = true
	if self.armature then
		self.armature:getAnimation():pause()
	end
end	

--恢复暂停
function SceneNpc:resume()
	self.isPause = false
	if self.armature then
		self.armature:getAnimation():resume()
	end
end	
--角色更新
function SceneNpc:update(curTime)
	
end	

function SceneNpc:setRolePosition(xx,yy)
	self.vo.pos.x = xx
	self.vo.pos.y = yy
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)
	if GameSceneModel:getMapGridType(self.vo.mGrid) == 2 then
		self:setArmatureOpacity(160)
  	else
  		self:setArmatureOpacity(255)
  	end

  	if self.shadow then
		self.shadow:setPosition(xx,yy)
	end
	if self.headContainer then
		self.headContainer:setPosition(xx,(yy+self.bodySize.y+20))
	end
end

----------------------------------------

--创建模型
function SceneNpc:creatModel(modelID)
	if self.isDestory_ then
		return
	end
	local xxOffSet = 0
	if modelID == nil then
		xxOffSet = 2000
	end	
	modelID = tostring(modelID or self.vo.modelID)
	local modelRect = ModeRectConfig.datas[tonumber(modelID)]
	if modelRect then
		--self.bodySize = cc.p(modelRect[3]*self.scaleParam,modelRect[2]*self.scaleParam)
		self.bodySize = cc.p(50*self.scaleParam,120*self.scaleParam)
	else
		self.bodySize = cc.p(50*self.scaleParam,120*self.scaleParam)
	end
	
	if modelID ~="" then
		local function backFun(armatureData,num)
			if self.vo and armatureData and not self.isDestory_ then
				if self.armature == nil then
					self.armature = ccs.Armature:create(modelID)
					--self.armatureWing:setPosition(0,0)
					self.modelLayer:addChild(self.armature)
			    else
			    	self.armature:init(modelID)
				end
				self.armature:getAnimation():setSpeedScale(self.animationSpeed)
			    self.armature:stopAllActions()    
			    if self.isSceneElement then
			    	self.armature:getAnimation():play("effect")
			    else
			    	self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
			   	end
				local posx,posy = self.vo:getPosition()
			    self:setRolePosition(posx,posy)  
				self:setModelScaleX()
			end
		end
		ArmatureManager:getInstance():loadModel(modelID,backFun)
		if self.isSceneElement == false then
			if not self.shadow then
				self.shadow = FightEffectManager:addShadowEff()
			end
	    end
	end

	-- if ArmatureManager:getInstance():loadModel(modelID) then
	-- 	if self.armature == nil then
	-- 		self.armature = ccs.Armature:create(modelID)
	-- 		self.modelLayer:addChild(self.armature)
	--     else
	--     	self.armature:init(modelID)
	-- 	end
	-- 	--self.armature:setTouchEnabled(false)
	--     --设置播放速度
	--     self.armature:getAnimation():setSpeedScale(self.animationSpeed)
	--     self.armature:stopAllActions()
	--     if self.isSceneElement then
	--     	self.armature:getAnimation():play("effect")
	--     else
	--     	self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	--    	end
	--     if self.isSceneElement == false then
	-- 	    self.shadow = display.newSprite("ui/fight/roleShadow.png")   
	-- 		-- self.shadow:setVisible(false)     
	--     	GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_SHADOW,self.shadow)
	--     end
	-- end


	
    --self.armature:setColor(display.COLOR_RED)
    --self.armature:getAnimation():play("killall")   
	--local posx,posy = self.vo:getPosition()
    --self:setRolePosition(posx,posy)  
	--self:setModelScaleX()
    -- self.armature:setTouchEnabled(true)
    -- self.armature:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
    --           if event.name == "began" then             
    --              
    --           elseif event.name == "ended" then             
                 
    --           end
    --           return true
    --       end)
end	


function SceneNpc:setSelect(b)
    if self.shadow then
		if b ~= self.isSelected then--防止重复设置状态
			if b then
			    self.shadow = FightEffectManager:showSelection(self.shadow)
		    else
			    self.shadow = FightEffectManager:hideSelection(self.shadow)
		    end
		    self.isSelected = b
		end
		self.shadow:setPosition(self.vo.pos.x,self.vo.pos.y)
	end

end



--设置模型缩放
function SceneNpc:setModelScaleX()
	if self.armature  then
		self.armature:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
	end	
end	

--设置名字
function SceneNpc:setName(name)
	if self.headContainer then
		if self.nameLabel == nil then
			--self.nameLabel = cc.ui.UILabel.new({text = name, size = 16, color = display.COLOR_RED})

	-- 		local label = UILabel:newTTFLabel({
	--     		text = "Hello, World\n您好，世界",
	--     		font = "Arial",
	--     		size = 64,
	--     		color = cc.c3b(255, 0, 0), -- 使用纯红色
	--     		align = cc.ui.TEXT_ALIGN_LEFT,
	--     		valign = cc.ui.TEXT_VALIGN_TOP,
	--     		dimensions = cc.size(400, 200)
	-- 		})

			self.nameLabel = display.newTTFLabel({text = name,size = 20,color = TextColor.NPC_G})
	        	:align(display.CENTER_TOP,0,0)
	        	:addTo(self.headContainer)
	        	:pos(0,0)
	   	 	self.nameLabel:setTouchEnabled(false)
	   	 -- 	self.nameLabel:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
	    	-- self.nameLabel:enableOutline(cc.c4b(1,1,0,1),3)
	    	-- self.nameLabel:enableGlow(cc.c4b(1,1,0,1))
		end

		self.nameLabel:setString(name)
	end
end	


function SceneNpc:containsPoint(point)
	if not self.bodySize then
		return false
	end
	if self.isSceneElement then --是场景物品类型
		return false
	end
	local xx = self.vo.pos.x
	local yy = self.vo.pos.y
	if point.x < xx +(self.bodySize.x/2) and point.x > xx -(self.bodySize.x/2) then
		if point.y > yy and point.y < yy + self.bodySize.y then
			return true
		end 
	end
	-- if self.armature then
	-- 	return cc.rectContainsPoint(self.armature:getBoundingBox(), point)
	-- 	--return self.armature:getBoneAtPoint(point.x,point.y)
	-- end
	return false
	-- local rect = cc.rect(rc.x, rc.y, rc.width, rc.height)
 	-- return cc.rectContainsPoint(rect, pt)
end

function SceneNpc:setArmatureOpacity(value)
	if self.armature then
		self.armature:setOpacity(value)
	end
end	

--
function SceneNpc:setRoleVisible(b)
	self:setVisible(b)
	if self.shadow then
		self.shadow:setVisible(b)
	end
	-- 跨服幻境之城(隐藏传送阵名字)
	if self.nameLabel then
		self.nameLabel:setVisible(b)
	end

end

function SceneNpc:setPos(p)
	self.vo.pos = p
	self:setPosition(p)
end	

function SceneNpc:getPos()
	return self:getPosition()
end


function SceneNpc:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	--layer:setAnchorPoint(0,0)
	return layer
end	

function SceneNpc:updateTaskTip(flag)
	if self.taskTip ~= nil then
		self.taskTip:removeSelf()
		self.taskTip = nil
	end
	if flag ~= -1 then
		if flag == 1 then
			--todo
			if self.headContainer then
				self.taskTip = display.newSprite("#scene/scene_npcStatusWen.png"):pos(0,20)
				self.headContainer:addChild(self.taskTip)
			end
		elseif flag == 2 then
			if self.headContainer then
				self.taskTip = display.newSprite("#scene/scene_npcStatusTan.png"):pos(0,20)
				self.headContainer:addChild(self.taskTip)
			end
		elseif flag == 0 then
		end


 
	end
end