--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 16:12:30
-- 场景物品

SceneItem = SceneItem or class("SceneItem",function()
	return display.newNode()
end)

function SceneItem:ctor(roleVO)
	self.isPause = false
	self.vo = roleVO
	self.activityStates = ""
	
	--中间模型层
	self.modelLayer = self:creatLayer()
	self:addChild(self.modelLayer)
	
	self.actionIndex = 1 --角色动作Index
	self.roleXScale = 1 --角色X轴缩放
	self.scaleParam = roleVO.scaleParam or 1 --总体缩放
	self.isPic = true
	--姓名label
	self.nameLabel = nil
	
	self.animationSpeed = 0.9  --动画播放速率
	self.curAnimaSpeed = self.animationSpeed  --当前动画的速率
	if self.vo.type == SceneRoleType.ITEM then
		self:setName(self.vo.name)
	else
		--self:setName(self.vo.name)
	end
 	self.fightControll = GlobalController.fight

 	if self.vo.belongTime > 0 then
 		--活动场景中经过一段时间后把归属设空
 		local action1 = cc.DelayTime:create(self.vo.belongTime)
 		local action2 = cc.CallFunc:create(function() 
 			self.vo.playID = "0"
 			self.vo.teamId = "0"
 		 end)
 		local action4 = transition.sequence({action1,action2})
 		self:runAction(action4)
 	end


 	-- local action = cc.MoveTo:create(0.1+(i *0.05), cc.p(pos[1],pos[2])) 
  --           if i == #curCoinList then
  --               local action2 = cc.CallFunc:create(function() self.isMouseEnable = true end)                     
  --               local action11 = transition.sequence({action,action2})
  --               item:runAction(action11)                
  --           else
  --               item:runAction(action)
  --           end 

  --           local action2 = cc.DelayTime:create(0.5)
  --   			local action3 = cc.CallFunc:create(backFun)
  --   			local action4 = transition.sequence({action2,action3})
  --   			self:runAction(action4)

    GlobalController.model:push(self, "creatModel")
	SoundManager:playSoundByType(SoundType.DROP_BOX)
end

function SceneItem:moveToRole()
	SoundManager:playSoundByType(SoundType.PICKUP)
	local role = GlobalController.fight:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
	if role then
		local pos = cc.p(role.vo.pos.x,role.vo.pos.y+60)
		local action1 = cc.MoveTo:create(0.25, pos)
		local action2 = cc.CallFunc:create(function() 
			GlobalController.fight:delSceneItem(self.vo.id)
			end)
		local action4 = transition.sequence({action1,action2})
		self:runAction(action4)
	end
end	


--清理
function SceneItem:destory()
	self.isDestory_ = true
	self:stopAllActions()	
	if self.armature then
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
	end
	self.activityStates = ""
	if not self.isPic then
		ArmatureManager:getInstance():unloadModel(self.vo.modelID)
	end
	if self:getParent() then
		self:getParent():removeChild(self)
	end	
end


--暂停
function SceneItem:pause()
	self.isPause = true
	if self.armature then
		self.armature:getAnimation():pause()
	end
end	

--恢复暂停
function SceneItem:resume()
	self.isPause = false
	if self.armature then
		self.armature:getAnimation():resume()
	end
end	
--角色更新
function SceneItem:update(curTime)
	
end	

function SceneItem:setRolePosition(xx,yy)
	self.vo.pos.x = xx
	self.vo.pos.y = yy
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)

	if GameSceneModel:getMapGridType(self.vo.mGrid) == 2 then
		self:setArmatureOpacity(160)
  	else
  		self:setArmatureOpacity(255)
  	end
end

----------------------------------------

--创建模型
function SceneItem:creatModel(modelID)
	if self.isDestory_ then
		return 
	end
	local xxOffSet = 0
	if modelID == nil then
		xxOffSet = 2000
	end	
	modelID = tostring(modelID or self.vo.modelID)
	self.bodySize = cc.p(30,60)
	if self.isPic then
		self.image = display.newSprite(ResUtil.getGoodsSmallIcon(modelID))
		self:addChild(self.image)
	else
		if ArmatureManager:getInstance():loadModel(modelID) then
		if self.armature == nil then
			self.armature = ccs.Armature:create(modelID)
			self.modelLayer:addChild(self.armature)
	    else
	    	self.armature:init(modelID)
		end
		--self.armature:setTouchEnabled(false)
	    --设置播放速度
	    self.armature:getAnimation():setSpeedScale(self.animationSpeed)
	    self.armature:stopAllActions()
	    self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	    end
	end
    --self.armature:setColor(display.COLOR_RED)
    --self.armature:getAnimation():play("killall")

	local posx,posy = self.vo:getPosition()
    self:setRolePosition(posx,posy)  
	self:setModelScaleX()
    -- self.armature:setTouchEnabled(true)
    -- self.armature:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
    --           if event.name == "began" then             
    --              
    --           elseif event.name == "ended" then             
                 
    --           end
    --           return true
    --       end)
end	


--设置模型缩放
function SceneItem:setModelScaleX()
	if self.armature  then
		self.armature:setScale(self.roleXScale * self.scaleParam, self.scaleParam)
	end	
end	

--设置名字
function SceneItem:setName(name)
	local color
	local showName = true
    if self.vo.quality == GoodsQualityType.WHITE then            --白
        color = TextColor.TEXT_W
        showName = false
    elseif self.vo.quality == GoodsQualityType.GREEN then        --绿
        color = TextColor.TEXT_G
        showName = true
    elseif self.vo.quality == GoodsQualityType.BLUE then        --蓝
        color = TextColor.ITEM_B
        showName = true
    elseif self.vo.quality == GoodsQualityType.PURPLE then        --紫
        color = TextColor.ITEM_P
        showName = true
    elseif self.vo.quality == GoodsQualityType.ORANGE then        --橙
        color = TextColor.TEXT_O
        showName = true
    end 
    if showName then
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
			local color = display.COLOR_RED--TextColor.ROLENAME
			-- if self.vo.group == FightGroupType.ONE then
			-- 	color = display.COLOR_RED
			-- end
			if self.vo.type == SceneRoleType.PLAYER then
				--color = display.COLOR_RED
			end
			self.nameLabel = display.newTTFLabel({text = name,size = 12,color = color})
	        	:align(display.CENTER_TOP,0,0)
	        	:addTo(self)
	        	:pos(0,30)
	   	 	self.nameLabel:setTouchEnabled(false)
	   	 -- 	self.nameLabel:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
	    	-- self.nameLabel:enableOutline(cc.c4b(1,1,0,1),3)
	    	-- self.nameLabel:enableGlow(cc.c4b(1,1,0,1))
		end

	    local color
	    if self.vo.quality == GoodsQualityType.WHITE then            --白
	        color = TextColor.TEXT_W
	    elseif self.vo.quality == GoodsQualityType.GREEN then        --绿
	        color = TextColor.TEXT_G
	    elseif self.vo.quality == GoodsQualityType.BLUE then        --蓝
	        color = TextColor.ITEM_B
	    elseif self.vo.quality == GoodsQualityType.PURPLE then        --紫
	        color = TextColor.ITEM_P
	    elseif self.vo.quality == GoodsQualityType.ORANGE then        --橙
	        color = TextColor.TEXT_O
	    end 
	    if color then
	        self.nameLabel:setColor(color)
	    end

		self.nameLabel:setString(name)
	end
end	


function SceneItem:containsPoint(point)
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

function SceneItem:setArmatureOpacity(value)
	if self.armature then
		self.armature:setOpacity(value)
	end
	if self.image then 
		self.image:setOpacity(value)
	end
end	

--
function SceneItem:setRoleVisible(b)
	self:setVisible(b)
end

function SceneItem:setPos(p)
	self.vo.pos = p
	self:setPosition(p)
end	

function SceneItem:getPos()
	return self:getPosition()
end


function SceneItem:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	--layer:setAnchorPoint(0,0)
	return layer
end	
