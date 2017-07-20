--
-- Author: 21102585@qq.com
-- Date: 2014-12-30 14:43:34
-- 飞行技能效果VO
SkillFlyEffVO = SkillFlyEffVO or class("SkillFlyEffVO")
FlyEffID = 0
function SkillFlyEffVO:ctor(data,armature,curTime)
	FlyEffID = FlyEffID +1
	self.id = FlyEffID
	self.effId = data.effId
	self.skillId = data.skillId
	self.skillConf = data.skillConf
	self.roleId = data.roleId
	self.roleType = data.roleType
	self.targerId = data.targerId
	self.targerType = data.targerType
	self.targerPos = data.targerPos
	self.backFun = data.backFun
	self.posList = {}
	self.index = 0
	self.len = 0
	self.armature = armature
	--dump(data)
	--print(self.targerId,self.targerType)
	local role = GameSceneModel:getSceneObjVO(self.roleId,self.roleType)
	local target = GameSceneModel:getSceneObjVO(self.targerId,self.targerType)

	if role == nil  then 
	else

		local targetPos
		if target == nil then
			targetPos = self.targerPos
		else
			targetPos = target.pos 
		end
		if targetPos == nil then
			targetPos = role.pos
		end

		local rolePos = role.pos
		local tX = targetPos.x 
		local tY = targetPos.y + 80
		local curX = rolePos.x
		local curY = rolePos.y + 60

		local ang = FightUtil:getAngle(cc.p(curX,curY),cc.p(tX,tY))
		if ang <=0 and ang >= -180 then
			ang = 360-ang
		elseif ang >=0 and ang <=180 then
			ang = 0-ang
		end
		self.armature:setRotation(ang)
	

	while FightUtil:getDistance(curX,curY,tX,tY) > 30 do
		curX = curX+(tX-curX)/2
		curY = curY+(tY-curY)/2
		table.insert(self.posList,{curX,curY})
		
	end
	-- local xiangliang = {x = (targetPos.x - rolePos.x)/5,y = (targetPos.y - rolePos.y)/5}

	-- for i=1,4 do
	-- 	if i == 1 then
	-- 	table.insert(self.posList,{rolePos.x+xiangliang.x*i,rolePos.y+xiangliang.y*i +50+50})
	-- 	end
	-- 	if i == 2 then
	-- 	table.insert(self.posList,{rolePos.x+xiangliang.x*i,rolePos.y+xiangliang.y*i +50+100})
	-- 	end
	-- 	if i == 3 then
	-- 	table.insert(self.posList,{rolePos.x+xiangliang.x*i,rolePos.y+xiangliang.y*i +50+100})
	-- 	end
	-- 	if i == 4 then
	-- 	table.insert(self.posList,{rolePos.x+xiangliang.x*i,rolePos.y+xiangliang.y*i +50+50})
	-- 	end
	-- end
	end
	self.len = #self.posList
end	

function SkillFlyEffVO:clear()
	self.backFun = nil
	self.armature = nil
end

function SkillFlyEffVO:update(curTime)
	if self.index < self.len  then
		self.index = self.index +1
		if self.armature then
			self.armature:setPosition(self.posList[self.index][1],self.posList[self.index][2])
    		--self.topLayer:addChild(buffEffArmature)
    		self.armature:setLocalZOrder(2000-self.posList[self.index][2])
		end
	else
		FightEffectManager:delFlyEffect(self.id,self.effID)
		self.posList = {}
		self.armature = nil
		if self.backFun then
			self.backFun(self.skillConf,self.targerId,self.targerType)
			self.backFun = nil
		end
	end
end



