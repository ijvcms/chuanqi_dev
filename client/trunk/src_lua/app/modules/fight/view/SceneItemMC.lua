
--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 16:12:30
-- 场景物品

SceneItemMC = SceneItemMC or class("SceneItemMC",function()
	return display.newNode()
end)

SceneItemMC.isDestory_ = false

function SceneItemMC:ctor(roleVO)
	self.isDestory_ = false
	self:setTouchEnabled(false)
	self.isPause = false
	self.vo = roleVO
	self.activityStates = ""
	
	--中间模型层
	self.modelLayer = self:creatLayer() 
	self:addChild(self.modelLayer)
	
	self.actionIndex = 1 --角色动作Index
	self.roleXScale = 1 --角色X轴缩放
	self.scaleParam = roleVO.scaleParam or 1 --总体缩放

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
	self:creatModel()
end	


--清理
function SceneItemMC:destory()
	self.isDestory_ = true
	if self.armature then
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
	end
	self.activityStates = ""
	ArmatureManager:getInstance():unloadModel(self.vo.modelID)
	if self:getParent() then
		self:getParent():removeChild(self)
	end	
end


--暂停
function SceneItemMC:pause()
	self.isPause = true
	if self.armature then
		self.armature:getAnimation():pause()
	end
end	

--恢复暂停
function SceneItemMC:resume()
	self.isPause = false
	if self.armature then
		self.armature:getAnimation():resume()
	end
end	
--角色更新
function SceneItemMC:update(curTime)
	
end	

function SceneItemMC:setRolePosition(xx,yy)
	self.vo.pos.x = xx
	self.vo.pos.y = yy
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)
end

----------------------------------------

--创建模型
function SceneItemMC:creatModel(modelID)
	local xxOffSet = 0
	if modelID == nil then
		xxOffSet = 2000
	end	
	modelID = tostring(modelID or self.vo.modelID)
	self.bodySize = cc.p(30,60)
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
function SceneItemMC:setModelScaleX()
	if self.armature  then
		self.armature:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
	end	
end	

--设置名字
function SceneItemMC:setName(name)
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
		local color = TextColor.ROLENAME
		-- if self.vo.group == FightGroupType.ONE then
		-- 	color = display.COLOR_RED
		-- end
		if self.vo.type == SceneRoleType.PLAYER then
			--color = display.COLOR_RED
		end
		self.nameLabel = display.newTTFLabel({text = name,size = 24,color = color})
        	:align(display.CENTER_TOP,0,0)
        	:addTo(self)
        	:pos(0,40)
   	 	self.nameLabel:setTouchEnabled(false)
   	 	self.nameLabel:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
    	self.nameLabel:enableOutline(cc.c4b(1,1,0,1),3)
    	self.nameLabel:enableGlow(cc.c4b(1,1,0,1))
	end

	self.nameLabel:setString(name)
end	


function SceneItemMC:containsPoint(point)
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
 --    return cc.rectContainsPoint(rect, pt)
end

function SceneItemMC:setArmatureOpacity(value)
	if self.armature then
		self.armature:setOpacity(value)
	end
end	

--
function SceneItemMC:setRoleVisible(b)
	self:setVisible(b)
end

function SceneItemMC:setPos(p)
	self.vo.pos = p
	self:setPosition(p)
end	

function SceneItemMC:getPos()
	return self:getPosition()
end

function SceneItemMC:setStates(states)
	self.vo.states = states	
end

function SceneItemMC:getStates()
	return self.vo.states
end

function SceneItemMC:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	--layer:setAnchorPoint(0,0)
	return layer
end	
