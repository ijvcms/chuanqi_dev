--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-06 15:25:35
-- 火墙

SceneFireWall = SceneFireWall or class("SceneFireWall",function()
	return display.newNode()
end)
SceneFireWall.grid = {
	{0,0},{0,1},{0,-1},{1,0},{-1,0},{-1,-1},{-1,1},{1,-1},{1,1}
}

SceneFireWall.isDestory_ = false

function SceneFireWall:ctor(fireWallVO)
	self.isDestory_ = false
	self:setTouchEnabled(false)
	self.isPause = false
	self.vo = fireWallVO
	self.activityStates = ""
	
	--中间模型层
	self.modelLayer = self:creatLayer() 
	self:addChild(self.modelLayer)
	
	self.actionIndex = 1 --角色动作Index
	self.roleXScale = 1 --角色X轴缩放
	self.scaleParam = fireWallVO.scaleParam or 1 --总体缩放
	self.isPic = false
	--姓名label
	self.nameLabel = nil
	
	self.animationSpeed = 1  --动画播放速率
	
 	self.fightControll = GlobalController.fight

 	self.armatureList = {}  --动画列表
 	self.posList = {}       --位置坐标列表

	--self:creatModel()
	GlobalController.model:pushModel(self.vo.modelID, self, "creatModel")
end

--
-- function SceneFireWall:moveToRole()
-- 	local role = GlobalController.fight:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
-- 	if role then
-- 		local pos = cc.p(role.vo.pos.x,role.vo.pos.y+60)
-- 		local action1 = cc.MoveTo:create(0.25, pos)
-- 		local action2 = cc.CallFunc:create(function() 
-- 			GlobalController.fight:delSceneFireWall(self.vo.id)
-- 			end)
-- 		local action4 = transition.sequence({action1,action2})
-- 		self:runAction(action4)
-- 	end
-- end	


--清理
function SceneFireWall:destory()
	self.isDestory_ = true
	for k,v in pairs(self.posList) do
		GameSceneModel:removeFireWallGrid(v)
	end			   	
	self.posList = nil
	self:stopAllActions()
	for k,v in pairs(self.armatureList) do
		v:stopAllActions()
		v:getAnimation():stop()
		self.armatureList[k] = nil
	end
	-- if self.armature then
	-- 	self.armature:stopAllActions()
	-- 	self.armature:getAnimation():stop()
	-- end
	self.activityStates = ""
	ArmatureManager:getInstance():unloadEffect(self.vo.modelID)
	if self:getParent() then
		self:getParent():removeChild(self)
	end
end

--暂停
function SceneFireWall:pause()
	self.isPause = true
	-- if self.armature then
	-- 	self.armature:getAnimation():pause()
	-- end
	for k,v in pairs(self.armatureList) do
		v:getAnimation():pause()
	end
end	

--恢复暂停
function SceneFireWall:resume()
	self.isPause = false
	-- if self.armature then
	-- 	self.armature:getAnimation():resume()
	-- end
	for k,v in pairs(self.armatureList) do
		v:getAnimation():resume()
	end
end

--角色更新
function SceneFireWall:update(curTime)
	if curTime > self.vo.endTime then
		-- 时间到就消失
		--self.fightControll:delSceneRole(self.vo.id,self.vo.type)
		return
	end
end	

--
function SceneFireWall:setRolePosition(xx,yy)
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
function SceneFireWall:creatModel(modelID)
	if self.isDestory_ or self.isDestory_ == nil then
		return
	end
	local xxOffSet = 0
	if modelID == nil then
		xxOffSet = 2000
	end	
	modelID = tostring(modelID or self.vo.modelID)
	if self.isPic then
		self.image = display.newSprite(ResUtil.getGoodsSmallIcon(modelID))
		self:addChild(self.image)
	else
		local callback = function()
		    if self.isDestory_ or self.isDestory_ == nil then
		    	return
		    end
		    -- if self.armature == nil then
			-- 	self.armature = ccs.Armature:create(modelID)
			-- 	self.modelLayer:addChild(self.armature)
		 	--    else
		 	--    	self.armature:init(modelID)
			--  end
			-- self.armature:setTouchEnabled(false)
		 	--    --设置播放速度
		 	--    self.armature:getAnimation():setSpeedScale(self.animationSpeed)
		 	--    self.armature:stopAllActions()
		 	--    self.armature:getAnimation():play("effect")
		 	local cGrid = self.vo.mGrid
			--for i=1,#SceneFireWall.grid do
			for i=1,1 do
				local pp = SceneFireWall.grid[i]
				local cPoint = {x=cGrid.x+pp[1],y=cGrid.y+pp[2]}
				if GameSceneModel:getGridFireWall(cPoint) ~= true then
					if i == 1 or i >= 6 then
				    	local armature = ccs.Armature:create(modelID)
				    	self.modelLayer:addChild(armature)
				    	armature:getAnimation():setSpeedScale(self.animationSpeed)
					    armature:stopAllActions()
					    armature:getAnimation():play("effect")
					    armature:setPosition(pp[1]*SceneGridRect.width,0-pp[2]*SceneGridRect.height)
					   	table.insert(self.armatureList,armature)
				   	end
				   	table.insert(self.posList,cPoint)
				   	GameSceneModel:addFireWallGrid(cPoint)
			   	end
		    end
	    end
	    ArmatureManager:getInstance():loadEffect(modelID, callback)
	end
    --self.armature:setColor(display.COLOR_RED)
    --self.armature:getAnimation():play("killall")   
  
	local posx,posy = self.vo:getPosition()
    self:setRolePosition(posx,posy)
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


--设置模型缩放
function SceneFireWall:setModelScaleX()
	-- if self.armature  then
	-- 	self.armature:setScaleX(self.scaleParam*self.roleXScale)
	-- 	self.armature:setScaleY(self.scaleParam)
	-- end	
	for k,v in pairs(self.armatureList) do
		v:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
	end
end	


function SceneFireWall:setArmatureOpacity(value)
	-- if self.armature then
	-- 	self.armature:setOpacity(value)
	-- end

	for k,v in pairs(self.armatureList) do
		v:setOpacity(value)
	end
end	

--
function SceneFireWall:setRoleVisible(b)
	self:setVisible(b)
end

function SceneFireWall:setPos(p)
	self.vo.pos = p
	self:setPosition(p)
end	

function SceneFireWall:getPos()
	return self:getPosition()
end


function SceneFireWall:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	--layer:setAnchorPoint(0,0)
	return layer
end	