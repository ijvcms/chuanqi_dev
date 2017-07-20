--
-- Author: 21102585@qq.com
-- Date: 2014-11-12 14:14:24
--怪物图形
BaseMonster = BaseMonster or class("BaseMonster",function()
	return display.newNode()
end)

function BaseMonster:ctor(monsterVO)
	self.vo = monsterVO
	self.activityStates = ""
	--底部效果层
	self.bottomLayer = self:creatLayer() 
	self:addChild(self.bottomLayer)
	--中间模型层
	self.modelLayer = self:creatLayer() 
	self:addChild(self.modelLayer)
	--顶部效果层
	self.topLayer = self:creatLayer() 
	self:addChild(self.topLayer)

	-- self:creatModel()

	self.chat = cc.ui.UILabel.new({text = "", size = fontsize, color = display.COLOR_BLACK})
    :align(display.CENTER_TOP,0,0)
   	:pos(0,90)
   	:addTo(self.topLayer)

   	self.index = 1
end

function BaseMonster:creatModel()
	-- if self.vo.id >= 117  then
	-- 	self.armature = ccs.Armature:create("Hero")
	-- 	self.armature:setScaleY(1)
	-- else
		self.armature = ccs.Armature:create("DemoPlayer")
		self.armature:setScaleY(0.1)
	-- end
	
    self:setPosition(self.vo:getPosition())
    self.modelLayer:addChild(self.armature)
    self.armature:stopAllActions()

    self:setModelScaleX()

    self.armature:getAnimation():play("stand")
end

function BaseMonster:setModelScaleX()
	-- if self.armature and self.vo.direction ~= math.round(self.armature:getScaleX()*10) then 
		-- if self.vo.id >= 117 then
			-- self.armature:setScaleX(-1)
		-- else
			--todo
			self.armature:setScaleX(-0.1*self.vo.direction)
		-- end
	-- end	
end	

function BaseMonster:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	-- layer:setAnchorPoint(0,0)
	return layer
end

function BaseMonster:action(style)
	-- print("怪物动作")
	self.index = self.index + 1

	if style == 1 then
		self.armature:getAnimation():play("stand")
		self.chat:setString("我是菜B"..self.index)
	elseif style ==2 then
		self.chat:setString("")
	elseif style ==3 then
		-- self.chat:setString("")
		self.armature:getAnimation():play("walk")
	end
end

function BaseMonster:update()
	--print(self.vo.states)
	-- if self.vo.states == RoleActivitStates.STAND then
	-- 	self:playStand()
	-- end
	-- if self.vo.states == RoleActivitStates.MOVE then
	-- 	self:playMove()
	-- end
	-- if self.vo.states == RoleActivitStates.ATTACK then
	-- end
	-- if self.vo.states == RoleActivitStates.DEAD then
	-- 	self:playDead()
	-- end

	-- if self.vo.states == RoleActivitStates.PAUSE then
	-- 	-- self.vo.states = RoleActivitStates.STAND
	-- 	-- self:playStand()
	-- end

end