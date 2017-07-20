--
-- Author: 21102585@qq.com
-- Date: 2014-11-12 14:14:24
--  attackPoint hurtPoint
BaseRole = BaseRole or class("BaseRole",function()
	return display.newNode()
end)

local BaseRoleHpContainer = require("app.gameScene.display.RoleHPBar")

BaseRole.hpContainer = nil

local kEnableAttackEffectUniform = true

function BaseRole:ctor(roleVO)
	self.sendTransferTime = 0
	self:setTouchEnabled(false)
	self.isPause = false
	self.vo = roleVO
	self.activityStates = ""
	self.moveScale = GameSceneModel.moveScale
	self.rideSpeedScale = 1
	--底部效果层
	self.bottomLayer = self:creatLayer()
	self:addChild(self.bottomLayer)
	--中间模型层
	self.modelLayer = self:creatLayer()
	self:addChild(self.modelLayer)
	--角色信息层
	self:createHeadContainer()
	--Buff图标层
	-- self.buffIconLayer = self:creatLayer() 
	-- self.buffIconLayer:pos(0,-15)
	--顶部效果层
	self.topLayer = self:creatLayer() 
	self:addChild(self.topLayer)
	self.curWingDirect = 1
	self.curWeaponDirect = 1
	self.actionIndex = 1 --角色动作Index
	self.roleXScale = 1 --角色X轴缩放
	self.scaleParam = self.vo.scaleParam or 1 --总体缩放z

	self.moveSpeedX = 2 --X轴移动速度
	self.moveSpeedY = 2 --Y轴移动速度

	self.moveEndDispatch = false --移动结束是否派发结束事件
	--角色阴影
	self.shadow = nil	
	--姓名label
	self.nameLabel = nil
	--气血条
	self.hpBarPic = nil

	self.moveTimes = 0 

	self.curOpacity = 255
	self.clothID = 0

	--角色血条宽度
	self.hpBarWidth = 70
	

	self.bodyRec = nil --记录身体范围和大小
	
	--self.skillType = 1
	self.hurtEffDic = {} --受击效果时间字典，防止同一个效果同时播放
	self.buffEffDic = {}
	self.preAttackTime = FightModel:getFTime() --上次攻击的时间
	self.skillInterval = 0+math.random(0,10)/10 --攻击需要的间隔时间
	self.animationSpeed = 1  --动画播放速率
	self.curAnimaSpeed = self.animationSpeed  --当前动画的速率
	self.bodySize = cc.p(50*self.scaleParam,100*self.scaleParam)
	self.isMainPlayer = false
	self.isMainPlayerPet = false
	if self.vo.type == SceneRoleType.PET and self.vo.ownerId == GlobalModel.player_id then
		self.isMainPlayerPet = true
	end

	if self.vo.type == SceneRoleType.PLAYER then 
		if self.vo.id == GlobalModel.player_id then
			self.isMainPlayer = true
			self.hpBarWidth =math.min(70,70)
		else
			 if SysOptionModel:getShowPlaySwitch() then
		
			 else
			 	self:setVisible(false)
			 end
		end
	end

	if self.vo.type == SceneRoleType.PLAYER then
		--self.vo.wing = 5106
		self:setName(self.vo.name)
		if self.vo.pet > 0 then
			self.babyVO = SceneBabyVO.new() 
			self.babyVO.id = self.vo.id
			self.babyVO.modelID = self.vo.pet
			self.babyVO.playID = self.vo.id
			self.babyVO.speed = self.vo.speed
			self.babyVO.pos = {x=self.vo.pos.x,y=self.vo.pos.y}
			self.babyVO.mGrid = {x=self.vo.mGrid.x,y=self.vo.mGrid.y}
			self.babyVO:addToScene()
		end
		if self.vo.id == GlobalModel.player_id and FightModel.isRelive then
			self:playRelive()
			FightModel.isRelive = false
		end
		self:setHP(self.vo.hp,self.vo.mp,0,false,false)
	elseif self.vo.type == SceneRoleType.MONSTER then
		if self.vo.mConf and self.vo.mConf.display == 1 then
			self:setName(self.vo.name)
		end
		--self:setHP(self.vo.hp,self.vo.mp,0,false,false)
	else
		self:setName(self.vo.name)
	end
	if self.isMainPlayer then
		GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_AUTO_ATTACK)
	end

	self.fightControll = GlobalController.fight

	self:creatModel()
	-- self.vo.honorId = 1000
	if self.vo.honorId and self.vo.honorId ~= 0 then
		self:showHonorPic(self.vo.honorId)
	end

	if self.vo.hp <= 0 then
		self:setStates(RoleActivitStates.DEAD)
		--self:playDead(true)
		GlobalController.model:push(self, "playDead", true)
		--GameSceneModel:deleteSceneObjVO(self.vo.id,self.vo.type)
	end
 	
	for i=1,#self.vo.beginBuffList do
		GlobalController.model:push(self, "updateBuff", self.vo.beginBuffList[i])
		--self:updateBuff(self.vo.beginBuffList[i])
	end

	self.posOffset = 18 --位置误差

	--玩家控制姿态
	self.buffPoison = nil --中毒
	self.buffShield = nil --魔法盾
	self.buffDizzy = nil --眩晕
	self.buffFire = nil --烈火
	self.buffStone = nil --石化
	self.buffInvisible = nil --隐身
	self.buffAttAdd = nil --属性加成如防御等
	self.buffCure = nil --治疗
	self.silent = nil  --沉默
	--self.vo.collect_state = 1
	self:showCollectBar(self.vo.collect_state,{time = self.vo.collect_state,isOpen = true,id = 0,tips = "采集中"})
	
end	



--清理
function BaseRole:destory()
	-- if self.tipLabel then
	-- 	self.tipLabel:stopAllActions()
	-- end
	if self.transferPointTimeId then
		GlobalTimer.unscheduleGlobal(self.transferPointTimeId)
		self.transferPointTimeId = nil
	end
	if self.collectBar then
		self.collectBar:destory()
		self:removeChild(self.collectBar)
		self.collectBar = nil
	end
	self.isDestory_ = true
	self:stopAllActions()
	if self.armature then
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
		self.armature = nil
	end	
	if self.armatureWeapon then
		self.armatureWeapon:stopAllActions()
		self.armatureWeapon:getAnimation():stop()
		self.armatureWeapon = nil
	end
	if self.armatureWing then
		self.armatureWing:stopAllActions()
		self.armatureWing:getAnimation():stop()
		self.armatureWing = nil
	end

	if self.armatureGH then
		self.armatureGH:stopAllActions()
		self.armatureGH:getAnimation():stop()
		self.armatureGH = nil
	end
	self:clearAttackEffect()
	self:clearHurtEffect()
	self:clearBuffEffect()
	self.activityStates = ""
	
   	self:clearAutoWayTxt()
   	self:showHonorPic(0)
	self:clearSay()
	if self.shadow then
		FightEffectManager:removeShadowEff(self.shadow)
		self.shadow = nil
	end
	self:clearGHEffect() 
	self:clearRideHaloEff()
	if self.teamIcon then
		if self.teamIcon:getParent() then
			self.teamIcon:getParent():removeChild(self.teamIcon)
		end
		self.teamIcon = nil
	end
	if self.unionIcon then
		if self.unionIcon:getParent() then
			self.unionIcon:getParent():removeChild(self.unionIcon)
		end
		self.unionIcon = nil
	end
	if self.hpContainer then
		if self.hpContainer:getParent() then
			self.hpContainer:getParent():removeChild(self.hpContainer)
		end
		self.hpContainer = nil
	end
	if self.headContainer then
		if self.headContainer:getParent() then
			self.headContainer:getParent():removeChild(self.headContainer)
		end
		self.headContainer = nil
	end
	
	
	if self.babyVO then
		self.babyVO:removeFromScene()
		self.babyVO = nil
	end
	self.isSelected = nil
	ArmatureManager:getInstance():unloadModel(self.clothID)
	ArmatureManager:getInstance():unloadModel(self.vo.weapon)
	ArmatureManager:getInstance():unloadModel(self.vo.wing)
	if self:getParent() then
		self:getParent():removeChild(self)
	end

end


--暂停
function BaseRole:pause()
	self.isPause = true
	if self.armature then
		self.armature:getAnimation():pause()
	end
	if self.armatureWeapon then
		self.armatureWeapon:getAnimation():pause()
	end

	if self.armatureWing then
		self.armatureWing:getAnimation():pause()
	end
	
	if self.ackEffArmature then
		self.ackEffArmature:getAnimation():pause()
	end	
end	

--恢复暂停
function BaseRole:resume()
	self.isPause = false
	if self.armature then
		self.armature:getAnimation():resume()
	end
	if self.armatureWeapon then
		self.armatureWeapon:getAnimation():resume()
	end

	if self.armatureWing then
		self.armatureWing:getAnimation():resume()
	end
	
	if self.ackEffArmature then
		self.ackEffArmature:getAnimation():resume()
	end	
end	
--角色更新
function BaseRole:update(curTime)
	if self.isDestory_ then
		return
	end
	-- for i,v in pairs(self.vo.buffDic) do
	-- 	v:update(curTime)
	-- end
	-- if self.isPause or true then return end
	if self.isPause then return end
	if self.vo.states == RoleActivitStates.STAND or self.vo.states == RoleActivitStates.PRE_ATTACK then
		self.moveTimes = 0
		self:playStand()
	elseif self.vo.states == RoleActivitStates.MOVE then
		self:playMove()	
	elseif self.vo.states == RoleActivitStates.ATTACK then
	elseif self.vo.states == RoleActivitStates.DEAD then
		self:playDead()
	elseif self.vo.states == RoleActivitStates.PAUSE then
		self:playPause()
	elseif self.vo.states == RoleActivitStates.NULL then
		if self.activityStates ~= RoleActivitStates.NULL then
			self.activityStates = RoleActivitStates.NULL
		end
		if socket.gettime() - self.sendTransferTime > 5 then
			self:setStates(RoleActivitStates.STAND)
			self:setRoleVisible(true)
		end
	end

	for i,v in pairs(self.vo.buffDic) do
		v:update(curTime)
	end
end	

function BaseRole:updateAtkSpeed()	
	if self.vo.states == RoleActivitStates.DEAD then return end
	self:setSkillInterval()
	if self.armature  then		
		self.armature:getAnimation():setSpeedScale(self.animationSpeed*(1+self.vo.atkSpeed))
	end	 
	if self.armatureWeapon  then		
		self.armatureWeapon:getAnimation():setSpeedScale(self.animationSpeed*(1+self.vo.atkSpeed))
	end
	if self.armatureWing  then
		self.armatureWing:getAnimation():setSpeedScale(self.animationSpeed*(1+self.vo.atkSpeed))
	end
	
end	

function BaseRole:setSkillInterval(skillId)
	self.skillInterval = (self.vo.skillConfig.interval/1000)/(1+self.vo.atkSpeed) --设置技能需要时间
end

--角色移动外部调用
function BaseRole:roleMoveTo(posList,isdispatchMoveEnd,moveSpeed,moveBackFun)
	--dump(posList)
	if self.vo.states == RoleActivitStates.NULL then
		return
	end
    self:playMoveTo(posList,isdispatchMoveEnd,moveSpeed,moveBackFun)
    if self.isMainPlayer and #posList > 0 then
		GlobalEventSystem:dispatchEvent(SceneEvent.MAP_ROLE_PATH_UPDATE,posList)
		--self:playRelive()
	end
	--ride
end

--角色移动
function BaseRole:playMoveTo(posList,isdispatchMoveEnd,moveSpeed,moveBackFun)
	--dump(posList)
	if self.vo.states == RoleActivitStates.NULL or self.vo.states == RoleActivitStates.DEAD then
		return
	end
	if self.buffDizzy or self.buffStone then
		self:setStates(RoleActivitStates.STAND)
        return
    end
	self.moveBackFun = moveBackFun
	self.moveEndDispatch = isdispatchMoveEnd
	self.dispatchMoveSpeed = moveSpeed
	self.posList = posList

	if #self.posList > 0 then
		local nextGrid = table.remove(self.posList,1)
	-- 	if self.isMainPlayer then
	-- 	print(self.vo.mGrid.x,self.vo.mGrid.y,nextGrid.x,nextGrid.y)
	-- end

		local nextPos = FightUtil:gridToPoint(nextGrid.x, nextGrid.y)
		if self.newPos == nil or (self.newPos.x ~= nextPos.x or self.newPos.y ~= nextPos.y) then
			self.newPos = nextPos
		else
			if self.vo.states ~= RoleActivitStates.DEAD then
				self:setStates(RoleActivitStates.MOVE)
				self.posOffset = self.vo.speed*1.4
			end
			return
		end
		if self.isMainPlayer then
			local begin = self.vo.mGrid
			local param = {direction = self.vo.direction,begin_point = begin,end_point = nextGrid}
			GameNet:sendMsgToSocket(11002, param)
		end

		local tDis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,self.newPos.x,self.newPos.y)
		local len = tDis/self.vo.speed
		self.moveSpeedX = (self.newPos.x - self.vo.pos.x)/len
		self.moveSpeedY = (self.newPos.y - self.vo.pos.y)/len
		
		--local ang = FightUtil:getAngle(self.vo.pos,cc.p(self.newPos.x,self.newPos.y))
		--self.vo.direction = FightUtil:getDirectByAngle(ang)

		--print(self.vo.mGrid.x,nextGrid.x,self.vo.mGrid.y,nextGrid.y)
		if self.vo.mGrid.x == nextGrid.x and self.vo.mGrid.y == nextGrid.y then
		else
			local ang = FightUtil:getAngleByGrid(self.vo.mGrid,cc.p(nextGrid.x,nextGrid.y))
			self.vo.direction = FightUtil:getDirectByAngle(ang)
			self:setModelActionIndex(self.vo.direction)
		end

		
		--self:setModelActionIndex(self.vo.direction)
		self:setModelScaleX()

		if self.vo.states ~= RoleActivitStates.DEAD then

			self:setStates(RoleActivitStates.MOVE)
			self.posOffset = self.vo.speed*1.4
		end
	end
end


--角色移动
function BaseRole:playMove()
	--if true then return end
	if self.activityStates ~= RoleActivitStates.MOVE then
		self.activityStates = RoleActivitStates.MOVE
	end
	
	local curAct = FightAction.RUN.."_"..self.actionIndex
	if self.armature and self.armature:getAnimation():getCurrentMovementID() ~= curAct then
		if self.vo.modelActSpeed then
			self.armature:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.RUN]*1)
		end
		self.armature:getAnimation():play(curAct)
	end
	if self.armatureWeapon and self.armatureWeapon:getAnimation():getCurrentMovementID() ~= curAct then
		if self.vo.modelActSpeed then
			self.armatureWeapon:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.RUN]*1)
		end
		self.armatureWeapon:getAnimation():play(curAct)
	end	
	if self.armatureWing and self.armatureWing:getAnimation():getCurrentMovementID() ~= curAct then
		if self.vo.modelActSpeed then
			self.armatureWing:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.RUN]*1)
		end
		self.armatureWing:getAnimation():play(curAct)
	end
	
	if self.newPos == nil then
		self.newPos = cc.p(self.vo.pos.x, self.vo.pos.y)
	end	
	--if self:diss(self.vo.pos.x, self.vo.pos.y,self.newPos[1],self.newPos[2]) < 3 then
	if FightUtil:getDistance(self.vo.pos.x, self.vo.pos.y,self.newPos.x, self.newPos.y) < self.posOffset*self.moveScale*self.rideSpeedScale then	
		--self.vo.pos.x = self.newPos[1]
		--self.vo.pos.y = self.newPos[2]

		self:setRolePosition(self.newPos.x, self.newPos.y)

		if self.isMainPlayer then
			
			-- 	local pp = FightUtil:pointToGrid(self.vo.pos.x,self.vo.pos.y)
			-- 	local param = {direction = self.vo.direction,point = {x=pp.x,y=pp.y}}
			-- 	GameNet:sendMsgToSocket(11003, param)
	
			GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_MAP_POS,cc.p(self.vo.pos.x,self.vo.pos.y))
		end

		if #self.posList > 0 then
			self:playMoveTo(self.posList,self.moveEndDispatch,self.dispatchMoveSpeed,self.moveBackFun)
		else
			--只有在战斗状态的时候就让他执行站立状态，否则执行等待状态
			self:setStates(RoleActivitStates.STAND)
			if self.moveEndDispatch then
				--GlobalEventSystem:dispatchEvent(FightEvent.ROLE_MOVE_END,self.vo.id)
				self.moveEndDispatch = false
				self.dispatchMoveSpeed = nil
			end	
			if self.moveBackFun then
				self.moveBackFun()
				self.moveBackFun = nil
			end
			if self.isMainPlayer then
				GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD,false)
				local begin = self.vo.mGrid
			    local param = {direction = self.vo.direction,begin_point = begin,end_point = begin}
			    GameNet:sendMsgToSocket(11002, param)
			end
		end
		
	else
			
			self:setRolePosition(self.vo.pos.x+self.moveSpeedX*self.moveScale*self.rideSpeedScale,self.vo.pos.y+self.moveSpeedY*self.moveScale*self.rideSpeedScale)
			if self.vo.type == SceneRoleType.PLAYER then
				self.moveTimes = self.moveTimes +1
				if self.isMainPlayer == false and self.moveTimes%25 == 0 and self.vo.mounts ~= 0 then
					--屏蔽坐骑 老是显示烦人   zhangshunqiu 
					GlobalController.model:pushModel(self.vo.mounts, self, "changCloth", self.vo.mounts)
					            --self:changCloth(self.vo.mounts)
			    end
 
			    if self.isMainPlayer then
			    	if SysOptionModel.switchMount and self.moveTimes%25 == 0 and self.vo.mounts ~= 0 then
			    		--屏蔽坐骑 老是显示烦人   zhangshunqiu 
			    		GlobalController.model:pushModel(self.vo.mounts, self, "changCloth", self.vo.mounts)
			    		--self:changCloth(self.vo.mounts)
			    	end
		
					if self.clothID == self.vo.mounts and self.vo.mounts ~= 0 then
						if (self.moveTimes)%22 == 1 then
				 			SoundManager:playSoundByType(SoundType.HORSE_RUN)
				 		end
			    	else
			    		-- if (self.moveTimes)%6 == 1 then
				    	-- 	SoundManager:playSoundByType(SoundType.RUN)
				    	-- end

				    	-- if (self.moveTimes)%20 == 1 then
				    	-- 	SoundManager:playSoundByType("00030-2")
				    	-- end

				    	if (self.moveTimes)%6 == 1 then
				    		SoundManager:playSoundByType("00030-3")
				    	end
			    	end
					GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_MAP_POS,cc.p(self.vo.pos.x,self.vo.pos.y))
				end
			end
	end		

end	

local function _udpateTeamPosition(self,xx,yy)
	if not self.teamIcon or not self.headContainer or not self.nameLabel then return end

	local namePos = cc.p(self.headContainer:getPositionX()+16,8+self.headContainer:getPositionY())
	--if self.nameLabel then
--getStringLength
		local size  = self.nameLabel:getContentSize()
		namePos.x = size.width/2 + namePos.x
		namePos.y = size.height + namePos.y
--	end
	self.teamIcon:setLocalZOrder(RoleLayerArr.kTeamLayerId-yy)
	self.teamIcon:setPosition(namePos)
end

local function _updateUnionPosition(self,xx,yy)
	if not self.unionIcon or not self.guildNameLab or not self.headContainer then return end

	local posx,posy = self.guildNameLab:getPosition()
	posx = posx + self.headContainer:getPositionX() 
 	local ww = self.guildNameLab:getContentSize().width
 	self.unionIcon:setPosition(posx+ww/2+15,47 + self.headContainer:getPositionY())
 	self.unionIcon:setLocalZOrder(RoleLayerArr.kUnionLayerId-yy)
end


function BaseRole:updateHeadContainerPosition(xx,yy)
	if self.headContainer then
		self.headContainer:setLocalZOrder(RoleLayerArr.kTopContainerLayerId-yy)
		self.headContainer:setPosition(xx,(self.bodySize.y+20+yy))--*self.scaleParam)
	end

	if self.hpContainer then
		self.hpContainer:updateRolePosition(xx,yy)
	end
	_udpateTeamPosition(self,xx,yy)
	_updateUnionPosition(self,xx,yy)
end

local function _updateAttackEffectPosition(self,xx,yy)
	if not self.ackEffArmature then return end
	if kEnableAttackEffectUniform then
		self.ackEffArmature:setPosition(xx,yy)
	end
	
end

function BaseRole:updateBodyContainerPosition(xx,yy)
	_updateAttackEffectPosition(self,xx,yy)
end


function BaseRole:setRolePosition(xx,yy)
	self.vo.pos.x = xx
	self.vo.pos.y = yy
	self:setPosition(xx,yy)
	self:setLocalZOrder(2000-yy)

	local rGrid= FightUtil:pointToGrid(xx,yy)
	if self.vo.mGrid.x == rGrid.x and self.vo.mGrid.y == rGrid.y then

	else
		GameSceneModel:removeSceneObjPos(self.vo)
		self.vo.mGrid = rGrid
		GameSceneModel:addSceneObjPos(self.vo)
		if self.vo.type == SceneRoleType.PLAYER or self.vo.type == SceneRoleType.MONSTER then --or self.vo.type == SceneRoleType.MONSTER
			GlobalEventSystem:dispatchEvent(SceneEvent.MAP_ROLE_POS_UPDATE,{id = self.vo.id,type = self.vo.type,pos = self.vo.pos,direct = self.vo.direction})
		end
	end

	if self.isMainPlayer then
		local isSafeArea = GameSceneModel:getIsSafeArea(rGrid)
		if GameSceneModel.inSafeArea ~= isSafeArea then
			GameSceneModel.inSafeArea = isSafeArea
			if GameSceneModel.inSafeArea then
				GlobalMessage:show({color = TextColor.TEXT_G, text = "进入安全区域"})
			else
				GlobalMessage:show({color = TextColor.TEXT_R, text = "进入战斗区域"})
			end
		end
		if self.transferPointTimeId then
			GlobalTimer.unscheduleGlobal(self.transferPointTimeId)
			self.transferPointTimeId = nil
		end
		--if socket.gettime() - self.sendTransferTime < 0.2 then
		local transferPointVO = GameSceneModel:isOnTransferPoint(self.vo)
		if transferPointVO and socket.gettime() - self.sendTransferTime > 1  then
			--SceneManager:gotoSceneByNpc(transferPointVO)
			--print("请求 11022 传送阵传送 id = "..transferPointVO.id)
			if FightModel.userYaoGan then
				self:setRoleVisible(false)
				self:setStates(RoleActivitStates.NULL)
				self.sendTransferTime = socket.gettime()
				GameNet:sendMsgToSocket(11022, {id = transferPointVO.id})
			else
				local transferPointFun = function()
					if self.transferPointTimeId then
						GlobalTimer.unscheduleGlobal(self.transferPointTimeId)
						self.transferPointTimeId = nil
					end
					self:setRoleVisible(false)
					self:setStates(RoleActivitStates.NULL)
					self.sendTransferTime = socket.gettime()
					self.posList = {}
					GameNet:sendMsgToSocket(11022, {id = transferPointVO.id})
				end
				if self.transferPointTimeId == nil then
					self.transferPointTimeId = GlobalTimer.scheduleGlobal(transferPointFun, 0.3)
				end
			end
			--GameNet:sendMsgToSocket(11022, {id = transferPointVO.id})
		end
	--end
	end
  	self:setRoleOpacity()

	if self.shadow then
		self.shadow:setPosition(xx,yy)
	elseif self.armatureGHEff then
		self.armatureGHEff:setPosition(xx,yy)
	end

	self:updateHeadContainerPosition(xx,yy)
	self:updateBodyContainerPosition(xx,yy)
end

function BaseRole:setRoleOpacity()
	if GameSceneModel:getMapGridType(self.vo.mGrid) == 2 or self.buffInvisible then
		self:setArmatureOpacity(128)
  	else
  		self:setArmatureOpacity(255)
  	end
end


function BaseRole:setWingZOrder(direct)
	if self.curWingDirect ~= direct and self.armatureWing then
		self.curWingDirect = direct
		if self.curWingDirect == 1 or self.curWingDirect == 2 or self.curWingDirect == 13 or self.curWingDirect == 17 or self.curWingDirect == 8 then
			self.armatureWing:setLocalZOrder(-3)
		else
			self.armatureWing:setLocalZOrder(3)
		end
	end
end

function BaseRole:setWeaponZOrder(direct)
	if self.curWeaponDirect ~= direct and self.armatureWeapon then
		self.curWeaponDirect = direct
		if self.curWeaponDirect == 5 then
			self.armatureWeapon:setLocalZOrder(-1)
		else
			self.armatureWeapon:setLocalZOrder(1)
		end
	end
end

--暂停状态
function BaseRole:playPause()
	if self.activityStates ~= RoleActivitStates.PAUSE then		
	 	self.activityStates = RoleActivitStates.PAUSE
	 	if self.armature and self.armature:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then
	 		self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	 	end	
	 	if self.armatureWeapon and self.armatureWeapon:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then
	 		self.armatureWeapon:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	 	end
	 	if self.armatureWing and self.armatureWing:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then
	 		self.armatureWing:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	 	end
	end
end	

--角色站立
function BaseRole:playStand()	
	
end	


local function _tryAddAttackEffect(self,atkPosition)
	if not self.ackEffArmature then return end
	if not self.curAckEff then return end
	if kEnableAttackEffectUniform then
		FightEffectManager:addAttackEffect(self.ackEffArmature,self.curAckEff,atkPosition == 1)
	else
		if atkPosition == 1 then
		    self.topLayer:addChild(self.ackEffArmature)
		 else
		    self.bottomLayer:addChild(self.ackEffArmature)
		end
	end
end



local function _tryCreateAttackEffect(self,atkEffectType,atkEffectId,modelSpeed,atkPosition)
	if ArmatureManager:getInstance():loadEffect(atkEffectId) then
	    --self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
    end
    self.curAckEff = atkEffectId
    self.ackEffArmature = ccs.Armature:create(atkEffectId)
    if atkEffectType == 2 then
	    self.ackEffArmature:setScaleX(self.roleXScale)
	else
		if tonumber(atkEffectId) ~= 8306 then
			 self.ackEffArmature:setScaleX(self.roleXScale)
		end
	end
	self.ackEffArmature:getAnimation():setSpeedScale(self.animationSpeed)--设置播放速度  
	_tryAddAttackEffect(self,atkPosition)
	local function animationEvent(armatureBack,movementType,movementID)
    	if self.isDestory_ then
            return
        end
    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
    		self:clearAttackEffect()
    	--[[  优化测试代码,可删除
		    if atkEffectType == 2 then
		    	self.ackEffArmature:getAnimation():play("effect_"..self.actionIndex)
		    else
		    	self.ackEffArmature:getAnimation():play("effect")
		    end
		    ]]--
    	end
    end	
   	self.ackEffArmature:getAnimation():setMovementEventCallFunc(animationEvent)

   	--监听帧事件
    -- local function frameEvent(bone,frameEventName,originFrameIndex,currentFrameIndex)    	
    -- 	self.ackEffArmature:getAnimation():setFrameEventCallFunc(function()end)	
    --    	if frameEventName == "hurtPoint" then
    --    		--self:playFlyEffect(skillConf,targerId,targerType)
    --    	end	
   	-- end

    -- self.ackEffArmature:getAnimation():setFrameEventCallFunc(frameEvent)
    if modelSpeed then
		self.ackEffArmature:getAnimation():setSpeedScale(modelSpeed)
	end

    if atkEffectType == 2 then
    	self.ackEffArmature:getAnimation():play("effect_"..self.actionIndex)
    else
    	self.ackEffArmature:getAnimation():play("effect")
    end

    _updateAttackEffectPosition(self,self.vo.pos.x,self.vo.pos.y)
end

--播放攻击效果
--atkAction 攻击动作动画名称
--atkSound 攻击时播放声音
--atkEffect 攻击时发的效果
--atkEffPos 攻击时播放攻击效果的点(可设多个点，点在技能表中取)
function BaseRole:playAttackEffect(skillConf,targerId,targerType,modelSpeed)
 	local ackEffectId = skillConf.atkEff

 	if ackEffectId == "" then
 		--self:playFlyEffect(skillConf,targerId,targerType)
 		return 
 	end

	if self.curAckEff and  ackEffectId ~= self.curAckEff then
		self:clearAttackEffect()
	elseif self.curAckEff then
		if self.ackEffArmature then
			if modelSpeed then
				self.ackEffArmature:getAnimation():setSpeedScale(modelSpeed)
			end
			if skillConf.atkEffType == 2 then
		    	self.ackEffArmature:getAnimation():play("effect_"..self.actionIndex)
		    else
		    	self.ackEffArmature:getAnimation():play("effect")
		    end
			--self.ackEffArmature:getAnimation():play("effect")
			return
		end	
	end	


	_tryCreateAttackEffect(self,skillConf.atkEffType,ackEffectId,modelSpeed,skillConf.atkPosition)
    
    -- local posType = EffPosType[ackEffectId] or 2
    -- if posType == 1 then
    -- 	self.ackEffArmature:setPosition(0,self.bodySize.y/2)
    -- elseif posType == 2 then
    -- 	self.ackEffArmature:setPosition(0,0)
    -- elseif posType == 3 then
    -- 	self.ackEffArmature:setPosition(0,self.bodySize.y)
    -- end
    --self.ackEffArmature:setPosition(0,0)
end

function BaseRole:clearAttackEffect()
	if self.ackEffArmature then
    	self.ackEffArmature:stopAllActions()
		self.ackEffArmature:getAnimation():stop()
		if self.ackEffArmature:getParent() then
			self.ackEffArmature:getParent():removeChild(self.ackEffArmature)
		end
		ArmatureManager:getInstance():unloadEffect(self.curAckEff)
		self.ackEffArmature = nil
		self.curAckEff = nil
	end
end	


function BaseRole:playFlyEffect(skillConf,targerId,targerType)
	local flyEff = skillConf.flyEff
	if flyEff == "" then
		self:playHurt(skillConf,targerId,targerType)
	else
		local param = {targerPos = self.hurtEffPoint,effId = flyEff,skillConf = skillConf,roleId = self.vo.id,roleType = self.vo.type,targerId = targerId,targerType = targerType,backFun = handler(self, self.playHurt)} 
 		GlobalEventSystem:dispatchEvent(FightEvent.PLAY_FLY_EFFECT,param)
 	end
end	


--播放受击效果
--hBodyTopEff 攻击到敌人后，在敌人身上显示的效果
--hBodyFootEff 攻击到敌人后，在敌人脚下显示的效果
--hTopEff 攻击到敌人后，在所有人上方显示效果
--hFootEff 攻击到敌人后，在所有人下方显示的效果
--hEffType 伤害效果类型 1表示只是在单个目标内显示效果，2表示在多个目标内显示效果，3表示在顶层显示大招效果，4表示显示链式效果
function BaseRole:playHurtEffect(skillConf)

	-- if skillConfig.hTopEff and skillConfig.hTopEff ~= "" then
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.PLAY_TOP_EFFECT,{pos = self.vo.pos,effID = skillConfig.hTopEff})
	-- end	
	-- if skillConfig.hFootEff and skillConfig.hFootEff ~= "" then
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.PLAY_FOOT_EFFECT,{pos = self.vo.pos,effID = skillConfig.hFootEff})
	-- end
	--if true then return end
	local topEffId = skillConf.hurtEff--tostring(skillConfig.hBodyTopEff) or ""
	local footEffId = ""--tostring(skillConfig.hBodyFootEff) or ""

	--local pos = self.vo:getRoleConfig().hurtPos

	if topEffId ~= "" then
		local topEff = self.hurtEffDic[topEffId]
		if topEff then
			topEff:getAnimation():play("effect")
		else
			self:creatHurtEffect(topEffId,pos,self.topLayer)
		end			
	end
	
	if footEffId ~= "" then
		local footEff = self.hurtEffDic[footEffId]
		if footEff then
			footEff:getAnimation():play("effect")
		else
			self:creatHurtEffect(footEffId,pos,self.bottomLayer)
		end
	end	   	
end

function BaseRole:creatHurtEffect(effID,pos,parent)
	--ccs.Armature:create(effID)
	if ArmatureManager:getInstance():loadEffect(effID) then
	    --self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
    end

	local hurtEff = ccs.Armature:create(effID)
	--hurtEff:setScaleX(1*self.roleXScale)
		    --hurtEff:setScaleY(1) 
		    -- hurtEff:getAnimation():setSpeedScale(self.animationSpeed)
    local posType = EffPosType[effID] or 1
    if posType == 1 then
    	hurtEff:setPosition(0,self.bodySize.y/2)
    elseif posType == 2 then
    	hurtEff:setPosition(0,0)
    elseif posType == 3 then
    	hurtEff:setPosition(0,self.bodySize.y)
    end 
    parent:addChild(hurtEff)
    hurtEff:stopAllActions()    
    hurtEff:getAnimation():play("effect")
    local function animationEvent(armatureBack,movementType,movementID)
    	if self.isDestory_ then
            return
        end
    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
    		

    		armatureBack:stopAllActions()
    		armatureBack:getAnimation():stop()
    
    		if armatureBack:getParent() then
    			armatureBack:getParent():removeChild(armatureBack)
    		end 
    		ArmatureManager:getInstance():unloadEffect(effID)
    		--ArmatureManager:destoyArmature(armatureBack,effID)
    		self.hurtEffDic[effID] = nil
    		--self:playBuffEffect("308")
    	end
    end	
   	hurtEff:getAnimation():setMovementEventCallFunc(animationEvent)
   	self.hurtEffDic[effID] = hurtEff
end	

--清理受击效果
function BaseRole:clearHurtEffect()	
	for k,v in pairs(self.hurtEffDic) do
		v:stopAllActions()
		v:getAnimation():stop()
		if v:getParent() then
			v:getParent():removeChild(v)
		end	
		ArmatureManager:getInstance():unloadEffect(k)
		self.hurtEffDic[k] = nil
	end	
	self.hurtEffDic = {}
end	


function BaseRole:updateBuff(buff)
	if self.isDestory_ then
		return
	end
	--"buff操作: 1 添加，2 更新，3 删除"
	if buff.operate == 1 or buff.operate == 2 then
		self:playBuff(buff.buff_id,buff.countdown,buff)
	elseif buff.operate == 3 then
		self:clearBuff(buff.buff_id,buff)
	end
    -- <Param name="obj_flag" type="proto_obj_flag" describe="对象唯一标识"/>
    -- <Param name="operate" type="int8" describe="buff操作: 1 添加，2 更新，3 删除"/>
	-- <Param name="buff_id" type="int16" describe="buff id"/>
	-- <Param name="countdown" type="int32" describe="倒计时"/>
	-- effect_id 效果ID 1-减伤  2 属性加成 3烈火效果 4眩晕 5毒 6隐身 7麻痹
end

-- self.buffPoison = nil --中毒
-- 	self.buffShield = nil --魔法盾
-- 	self.buffDizzy = nil --眩晕4眩晕
-- 	self.buffFire = nil --烈火
-- 	self.buffStone = nil --石化 麻痹
-- 	self.buffInvisible = nil --隐身6隐身
--  self.silent = nil --沉默

--根据BuffID执行Buff效果
function BaseRole:playBuff(buffId,countdown,buff)
    -- 处理相关Buff
    local buffConfig = nil
    local buffParam = {
    	buffId = buffId,
    	buffAtt = "",
    	buffValue = 23,
    	buffEffId = "",
    	bType = 1,
    	subType = 2,
    	repel = 1,
    	dispel = 2,
    	duration = countdown or 0,
    	cycle = 2000,
    	beginTime = FightModel:getFTime(),
    	lastTime = FightModel:getFTime(),
    	targetId = self.vo.id,
    	targetType = self.vo.type,
	}
	local buffConfig = configHelper:getBuffConfigById(buffId)
	buffParam.buffEffId = buffConfig.effectbuffid

	if buff.effect_id == 5 then
    	self:setArmatureColor(display.COLOR_RED)
    	self.buffPoison = true
    	buffParam.buffEffId = ""
    elseif buff.effect_id == 4 then
    	--晕
    	self.buffDizzy = true
    	buffParam.buffEffId = ""
    	self:setArmatureColor(display.COLOR_BLUE)
    elseif buff.effect_id == 3 then
    	self.buffFire = true
    	buffParam.buffEffId = ""
    elseif buff.effect_id == 6 then
    	self.buffInvisible = true
    	self:setRoleOpacity()
    	buffParam.buffEffId = ""
    elseif buff.effect_id == 2 then
    	self.buffAttAdd = true
    	buffParam.buffEffId = ""
    elseif buff.effect_id == 1 then
    	--buffParam.buffEffId = ""
    	self.buffShield = true
    	--buffParam.buffEffId = "8205"
    elseif buff.effect_id == 8 then
    	self.buffCure = true
    	buffParam.buffEffId = ""
    elseif buff.effect_id == 11 then
    	self.silent = true
    	--buffParam.buffEffId = ""
    elseif buff.effect_id == 7 then
    	self.buffStone = true
    	self:setArmatureColor(cc.c3b(255, 255, 0))
    	if self.isMainPlayer then
    		GlobalMessage:show("麻痹中，不能操作")
    	end
    end
    local buffVo = SceneRoleBuffVO.new(buffParam,buff)
    self.vo.buffDic[buffId] = buffVo
    if buffParam.buffEffId ~= "" then
    	self:playBuffEffect(buffParam.buffEffId)
	end
end


-- 根据BuffID执行Buff效果
function BaseRole:clearBuff(buffId,buff)
	if self.isDestory_ then
		return
	end
     -- 处理相关Buff
    local buffEffParam = self.vo.buffDic[buffId]
    if buffEffParam then
   		self:clearBuffEffectByID(buffEffParam.buffEffId)
		self.vo.buffDic[buffId] = nil  
		if buff.effect_id == 5 then
			self:setArmatureColor(display.COLOR_WHITE)
			self.buffPoison = nil
		elseif buff.effect_id == 4 then
	    	--晕
	    	self.buffDizzy = nil
	    	self:setArmatureColor(display.COLOR_WHITE)
	    elseif buff.effect_id == 3 then
	    	self.buffFire = nil
	    elseif buff.effect_id == 6 then
	    	self.buffInvisible = nil
	    	self:setRoleOpacity()
	    elseif buff.effect_id == 1 then
	    	self.buffShield = nil
	    elseif buff.effect_id == 2 then
	    	self.buffAttAdd = nil
	    elseif buff.effect_id == 8 then
	    	self.buffCure = nil
	    elseif buff.effect_id == 11 then
    		self.silent = nil
	    elseif buff.effect_id == 7 then
	    	self.buffStone = nil
	    	self:setArmatureColor(display.COLOR_WHITE)
	    end
    end
end

--角色Buff效果
function BaseRole:playBuffEffect(buffEffId)
	if buffEffId == "" then
		return
	end
	local buffEff = self.buffEffDic[buffEffId]
	if buffEff then
		buffEff:getAnimation():play("effect")
		return
	end

	ArmatureManager:getInstance():loadEffect(buffEffId)
    local effArmature = ccs.Armature:create(buffEffId)
    -- effArmature:setScaleX(1)
    -- effArmature:setScaleY(1)
    -- effArmature:getAnimation():setSpeedScale(1)
    effArmature:setPosition(0,0)
    self.topLayer:addChild(effArmature)

    effArmature:stopAllActions()


    --  local function animationEvent(armatureBack,movementType,movementID)
    -- 	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
    -- 		self:clearBuffEffectByID(buffEffId)
    -- 	end
    -- end
   	-- effArmature:getAnimation():setMovementEventCallFunc(animationEvent)



    effArmature:getAnimation():play("effect")

   	self.buffEffDic[buffEffId] = effArmature
end	

--清理Buff效果By id
function BaseRole:clearBuffEffectByID(buffEffId)
	local eff = self.buffEffDic[buffEffId]
	if eff then
		eff:stopAllActions()
		eff:getAnimation():stop()		
		if eff:getParent() then
			eff:getParent():removeChild(eff)
		end	
		ArmatureManager:getInstance():unloadEffect(buffEffId)
		self.buffEffDic[buffEffId] = nil
	end
end	

--清理Buff效果
function BaseRole:clearBuffEffect()
	for k,v in pairs(self.buffEffDic) do
		v:stopAllActions()
		v:getAnimation():stop()
		if v:getParent() then
			v:getParent():removeChild(v)
		end	
		ArmatureManager:getInstance():unloadEffect(k)
		self.buffEffDic[k] = nil
	end
	self.buffEffDic = {}
end	

--角色攻击
function BaseRole:playAttack(targerId,skillId)
	
end

--执行伤害
function BaseRole:playHurt(targerId)

end

--变形
function BaseRole:playDeformation(modelID)
	local manager = ccs.ArmatureDataManager:getInstance()
	local adress = ResUtil.getModel(modelID)
    manager:removeArmatureFileInfo(adress)
    manager:addArmatureFileInfo(adress)

	self:creatModel(modelID)
    self:setStates(RoleActivitStates.PAUSE)
end	


--角色死亡
function BaseRole:playDead(isGotoAndPause)
    if self.isDestory_ then
		return
	end
	if self.armature and self.activityStates ~= RoleActivitStates.DEAD then
		self.activityStates = RoleActivitStates.DEAD
		if self.vo.type == SceneRoleType.PLAYER then
			--GlobalController.model:push(self, "changCloth", self.vo.modelID)
            self:changCloth(self.vo.modelID)
        end
		self:setLocalZOrder(0-self.vo.pos.y)
		if self.armatureWing then
			self.armatureWing:setLocalZOrder(-3)
		end
		if isGotoAndPause then
			self.armature:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)
			if 	self.armatureWeapon then
				-- self.armatureWeapon:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)
				-- self.armatureWeapon:getAnimation():gotoAndPause(17)	
				self.armatureWeapon:getAnimation():stop()
			end

			if 	self.armatureWing then
				--self.armatureWing:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)	
				self.armatureWing:getAnimation():stop()
			end

			if 	self.armature then
				self.armature:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)	
				self.armature:getAnimation():gotoAndPause(17)
			end

			if self.shadow then 
				self.shadow:setVisible(false)
			end	
			if self.armatureGHEff then
				self.armatureGHEff:setVisible(false)
			end
			self:setHeadContainerVisible(false)
			self:clearAttackEffect()
			self:clearHurtEffect()
			self:clearBuffEffect()
			return
		end
		local selAtkTarVO =  FightModel:getSelAtkTarVO()
		if selAtkTarVO and selAtkTarVO.id == self.vo.id and selAtkTarVO.type == self.vo.type then
			FightModel:setSelAtkTarVO(nil)
		end

		local voType = self.vo.type
		if voType == SceneRoleType.PLAYER then
			if self.vo.sex == RoleSex.MAN then
				SoundManager:playSoundByType(SoundType.DEAD_MAN)
			else
				SoundManager:playSoundByType(SoundType.DEAD_WOMAN)
			end
		end

		-- 怪物死亡的时候播放音效
		-- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/90b02757892445fb9b5521782b697139/
		if voType == SceneRoleType.MONSTER or voType == BOSS then
			local monster_id = self.vo.monster_id
			local deathSound = configHelper:getMonsterDeathSound(monster_id)
			if deathSound then
				SoundManager:playSound(deathSound)
			end
		end

		if self.vo.modelActSpeed then
			self.armature:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.DEAD])
		end
		self.armature:getAnimation():setSpeedScale(1)
		self.armature:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)
		if 	self.armatureWeapon then
			-- if self.vo.modelActSpeed then
			-- 	self.armatureWeapon:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.DEAD])
			-- end
			-- self.armatureWeapon:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)	

			self.armatureWeapon:getAnimation():stop()
		end

		if 	self.armatureWing then
			-- if self.vo.modelActSpeed then
			-- 	self.armatureWing:getAnimation():setSpeedScale(self.vo.modelActSpeed[FightAction.DEAD])
			-- end
			-- self.armatureWing:getAnimation():play(FightAction.DEAD.."_"..self.actionIndex)	
			self.armatureWing:getAnimation():stop()
		end


		--监听完成事件
    	local function animationEvent(armatureBack,movementType,movementID)
    		if self.isDestory_ then
                return
            end
        	local id = movementID        	
        	if movementType == ccs.MovementEventType.loopComplete or movementType == ccs.MovementEventType.complete then
            	armatureBack:getAnimation():setMovementEventCallFunc(function()end)        	            	
          
          
            	self.armature:getAnimation():stop() --停止动画
            	if self.armatureWeapon then
            		self.armatureWeapon:getAnimation():stop() --停止动画
            	end
            	if self.armatureWing then
            		self.armatureWing:getAnimation():stop() --停止动画
            	end
				if self.shadow then 
					self.shadow:setVisible(false)
				end	
				if self.armatureGHEff then
					self.armatureGHEff:setVisible(false)
				end
				self:setHeadContainerVisible(false)
				self:clearAttackEffect()
				self:clearHurtEffect()
				self:clearBuffEffect()

				self:setArmatureColor(display.COLOR_WHITE)
				self.vo.buffDic = {}
				self.buffPoison = nil
				self.buffDizzy = nil
				self.buffFire = nil
				self.buffInvisible = nil
				self.buffShield = nil
				self.buffAttAdd = nil
				self.buffCure = nil
				self.silent = nil
				self.buffStone = nil
				self.vo.beginBuffList = {}

				if self.vo.type == SceneRoleType.MONSTER then
					local action1 = cc.DelayTime:create(3)
			 		local action2 = cc.CallFunc:create(function()
			 			GlobalController.fight:delSceneRole(self.vo.id,self.vo.type)
			 			end)
			 		local action4 = transition.sequence({action1,action2})
			 		self:runAction(action4)
			 	elseif self.isMainPlayer then
			 		if GlobalWinManger:getIsOpen(WinName.RESURGE) == false and GameSceneModel.sceneId ~= 20017 then
				 		GameNet:sendMsgToSocket(10010,{caster_name = ""})
				 	end
				end
				--GlobalController.fight:deleteRoleModel(self.vo.id,self.vo.type)




        	elseif movementType == ccs.MovementEventType.start then       
        	 --todo       	
        	end
    	end
    	self.armature:getAnimation():setMovementEventCallFunc(animationEvent)
	end	
end


-- 播放升级动画  
-- 没有清理
function BaseRole:playUpgrade()
	-- res\effect\8201\8201.ExportJson 
	if self.upGradeEff then
		self.upGradeEff:getAnimation():play("effect")
		return
	end
	ArmatureManager:getInstance():loadEffect("shengji")
	self.upGradeEff = ccs.Armature:create("shengji")
    self.topLayer:addChild(self.upGradeEff)
	self.upGradeEff:stopAllActions()

	local function animationEvent(armatureBack,movementType,movementID)
		if self.isDestory_ then
            return
        end
    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
    		--self:clearBuffEffectByID(buffEffId)
    		self.upGradeEff:stopAllActions()
			self.upGradeEff:getAnimation():stop()		
			if self.upGradeEff:getParent() then
				self.upGradeEff:getParent():removeChild(self.upGradeEff)
			end	
			self.upGradeEff = nil
			ArmatureManager:getInstance():unloadEffect("shengji")
    	end
    end
   	self.upGradeEff:getAnimation():setMovementEventCallFunc(animationEvent)
   	self.upGradeEff:getAnimation():play("effect")
end


-- 播放复活动画  
-- 没有清理
function BaseRole:playRelive()
	-- res\effect\8201\8201.ExportJson
	if self.reliveEff then
		self.reliveEff:getAnimation():play("effect")
		return
	end
	local b = ArmatureManager:getInstance():loadEffect("fuhuo")
	self.reliveEff = ccs.Armature:create("fuhuo")
    self.topLayer:addChild(self.reliveEff)
	--self.reliveEff:stopAllActions()
	local function animationEvent(armatureBack,movementType,movementID)
		if self.isDestory_ then
            return
        end
    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
    		--self:clearBuffEffectByID(buffEffId)
    		self.reliveEff:stopAllActions()
			self.reliveEff:getAnimation():stop()
			if self.reliveEff:getParent() then
				self.reliveEff:getParent():removeChild(self.reliveEff)
			end	
			self.reliveEff = nil
			ArmatureManager:getInstance():unloadEffect("fuhuo")
    	end
    end
   	self.reliveEff:getAnimation():setMovementEventCallFunc(animationEvent)
   	self.reliveEff:getAnimation():play("effect")
end



function BaseRole:addFilter()
	local function addArmatrueFilter(armature)
		local bones = armature:getChildren()
		for _, v in ipairs(bones) do
			if v.getDisplayRenderNode then
				local displayNode = v:getDisplayRenderNode()

				if displayNode then
					if displayNode:getGLProgram() == cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP") then
						local filter = filter.newFilter("GRAY")
					    filter:initSprite(nil)
					    displayNode:setGLProgramState(filter:getGLProgramState()) --使用
					end
				end

			end
		end
	end

	if self.armature then
		addArmatrueFilter(self.armature)
	end
	if self.armatureWeapon then
		addArmatrueFilter(self.armatureWeapon)
	end	
	if self.armatureWing then
		addArmatrueFilter(self.armatureWing)
	end
end

function BaseRole:setMountsUP(b)
	if b then
		if self.vo.mounts ~= 0 then
			GlobalController.model:pushModel(self.vo.mounts, self, "changCloth", self.vo.mounts)
			--self:changCloth(self.vo.mounts)
		else
			print("no RIDE")
		end
	else
		if self.vo.modelID ~= 0 then
			GlobalController.model:pushModel(self.vo.modelID, self, "changCloth", self.vo.modelID)
			--self:changCloth(self.vo.modelID)
		else

		end
	end
end

function BaseRole:changCloth(modelID,isSync)
	if GameSceneModel.curSceneHideName or self.isDestory_  then
		return
	end
	modelID = ArmatureManager:getInstance():existModelRes(modelID,1,self.vo,self.isMainPlayer,(self.isMainPlayer or self.isMainPlayerPet))

	if self.clothID == modelID then return end
	ArmatureManager:getInstance():unloadModel(self.clothID)
	self.clothID = modelID
	local speedScale = configHelper.mountSpeedConfig.datas[self.clothID]
	if speedScale then
		SoundManager:playSoundByType(SoundType.UP_HORSE)
		self.rideSpeedScale = speedScale.speed/100
		if self.armatureWeapon then
            self.armatureWeapon:setVisible(false)
        end  
        if self.armatureWing then
            self.armatureWing:setVisible(false)
        end

        if self.vo.rideHalo ~= 0 and self.vo.rideHalo ~= "" then
        	self:createRideHalo()
        end
	else
		self.rideSpeedScale = 1
		if self.armatureWeapon then
            self.armatureWeapon:setVisible(true)
        end  
        if self.armatureWing then
            self.armatureWing:setVisible(true)
        end
           self:clearRideHaloEff()
	end
	local function backFun(armatureData,mid)
			if self.vo and armatureData and tostring(mid) == tostring(self.clothID) and not self.isDestory_ then
				if self.armature == nil then
					self.armature = ccs.Armature:create(self.clothID)
					--self.armatureWing:setPosition(0,0)
					self.modelLayer:addChild(self.armature)
			    else
			    	local bb = self.armature:init(self.clothID)
			    	self.armature:updateOffsetPoint()
			    	self.armature:updateOffsetPoint()
				end
				self.armature:getAnimation():setSpeedScale(self.animationSpeed)
			    self.armature:stopAllActions()
			    self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)

			    local posx,posy = self.vo:getPosition()
			    self:setRolePosition(posx,posy)  
				self:setModelScaleX()
			end
	end
	if isSync then
		ArmatureManager:getInstance():loadModel(self.clothID)
		if self.armature then
			self.armature:init(self.clothID)
			self.armature:updateOffsetPoint()

			self.armature:getAnimation():setSpeedScale(self.animationSpeed)
			self.armature:stopAllActions()
			if self.vo.modelActSpeed then  
	            self.armature:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
	        end
			self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)

			local posx,posy = self.vo:getPosition()
			self:setRolePosition(posx,posy)  
			self:setModelScaleX()
		end
	else
		ArmatureManager:getInstance():loadModel(self.clothID,backFun)
	end
end


----------------------------------------

function BaseRole:createModelBoay(modelID)
	if self.isDestory_ then
		return
	end
	local xxOffSet = 0
	if modelID == nil then
		xxOffSet = 2000
	end
	local modelRect = ModeRectConfig.datas[tonumber(self.clothID)]
	if modelRect then
		self.bodySize = cc.p(modelRect[3]*self.scaleParam,modelRect[2]*self.scaleParam)
	else
		self.bodySize = cc.p(50*self.scaleParam,85*self.scaleParam)
	end
	
	if self.clothID ~="" then
		local function backFun(armatureData,mid)
			if self.vo and armatureData and mid == self.clothID and not self.isDestory_ then
				if self.armature == nil then
					self.armature = ccs.Armature:create(self.clothID)
					--self.armatureWing:setPosition(0,0)
					self.modelLayer:addChild(self.armature)
			    else
			    	self.armature:init(self.clothID)
			    	self.armature:updateOffsetPoint()
				end
				self.armature:getAnimation():setSpeedScale(self.animationSpeed)
			    self.armature:stopAllActions()    
			    if self.vo.modelActSpeed then  
		            self.armature:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
		        end
			    self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
			    local posx,posy = self.vo:getPosition()
			    self:setRolePosition(posx,posy)  
				self:setModelScaleX()
			end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		end
		ArmatureManager:getInstance():loadModel(self.clothID,backFun)
		if self.vo.type == SceneRoleType.MONSTER and self.vo.mConf.type == 2 then
			self:creatGHEffect(false)
			if  self.shadow then
				FightEffectManager:removeShadowEff(self.shadow)
				self.shadow = nil
			end
		else
			if not self.shadow then
				self.shadow = FightEffectManager:addShadowEff()
			end
            self.shadow:setPosition(self.vo.pos.x,self.vo.pos.y)
		end
	end
end

function BaseRole:creatModelWeapon()
	if self.isDestory_ then
		return
	end
	if self.vo.weapon ~="" and self.vo.weapon ~= 0 then
    	self.vo.weapon = ArmatureManager:getInstance():existModelRes(tostring(self.vo.weapon),3,self.vo,(self.isMainPlayer or self.isMainPlayerPet))
    	local function backFun(armatureData)
    		if self.vo and armatureData and not self.isDestory_ then
				if self.armatureWeapon == nil then
					self.armatureWeapon = ccs.Armature:create(self.vo.weapon)
					--self.armatureWeapon:setPosition(0,0)
					self.modelLayer:addChild(self.armatureWeapon)
			    else
			    	self.armatureWeapon:init(self.vo.weapon)
				end
				self.armatureWeapon:getAnimation():setSpeedScale(self.animationSpeed)
			    self.armatureWeapon:stopAllActions()    
			    if self.vo.modelActSpeed then  
	                self.armatureWeapon:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])
	            end
			    self.armatureWeapon:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
			    self.armatureWeapon:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
			    self:setWeaponZOrder(self.vo.direction)
			end
		end
		ArmatureManager:getInstance():loadModel(self.vo.weapon,backFun)
	end
end

function BaseRole:createModelWing()
	if self.isDestory_ then
		return
	end
	if self.vo.wing and self.vo.wing ~="" and self.vo.wing ~= 0 then
		self.vo.wing = ArmatureManager:getInstance():existModelRes(tostring(self.vo.wing),2,self.vo,(self.isMainPlayer or self.isMainPlayerPet))
		local function backFun(armatureData)
			if self.vo and armatureData and not self.isDestory_ then
				if self.armatureWing == nil then
					self.armatureWing = ccs.Armature:create(self.vo.wing)
					--self.armatureWing:setPosition(0,0)
					self.modelLayer:addChild(self.armatureWing,-3)
			    else
			    	self.armatureWing:init(self.vo.wing)
				end
				self.armatureWing:getAnimation():setSpeedScale(self.animationSpeed)
			    self.armatureWing:stopAllActions()   
			    if self.vo.modelActSpeed then  
		            self.armatureWing:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
		        end 
			    self.armatureWing:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
			    self.armatureWing:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
			    self:setWingZOrder(self.vo.direction)
			end
		end
		ArmatureManager:getInstance():loadModel(self.vo.wing,backFun)
	end
end

--创建光环
function BaseRole:createRideHalo()
	if self.rideHaloEff then
		self.clearRideHaloEff()
	end
	if ArmatureManager:getInstance():loadEffect(self.vo.rideHalo) then
		self.rideHaloEff = ccs.Armature:create(self.vo.rideHalo)
		--self.armatureGHEff:stopAllActions()    
    	self.rideHaloEff:getAnimation():play("effect")
    	--GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_SHADOW, self.armatureGHEff)
    	--self.rideHaloEff:setPosition(self.vo.pos.x,self.vo.pos.y)
    	self:addChild(self.rideHaloEff)
    	self.rideHaloEff:setLocalZOrder(-8)
	end

end
function BaseRole:clearRideHaloEff()
	if self.rideHaloEff then
		self.rideHaloEff:getAnimation():stop()
		--self.armatureGHEff:stopAllActions()
		if self.vo.rideHalo then
			ArmatureManager:getInstance():unloadEffect(self.vo.rideHalo)
		end
		if self.rideHaloEff:getParent() then
			self.rideHaloEff:getParent():removeChild(self.rideHaloEff)
		end	
		self.rideHaloEff = nil
	end
end	


--创建模型
function BaseRole:creatModel(modelID)
    if self.isDestory_ then
		return
	end
	self.clothID = ArmatureManager:getInstance():existModelRes(tostring(modelID or self.vo.modelID),1,self.vo)
	self:setModelActionIndex(self.vo.direction)
	GlobalController.model:pushModel(self.clothID, self, "createModelBoay", self.clothID)
	--self:createModelBoay(modelID)
  
    --武器
    GlobalController.model:pushModel(self.vo.weapon, self, "creatModelWeapon")
    --self:creatModelWeapon()
   
    GlobalController.model:pushModel(self.vo.wing, self, "createModelWing")
    --self:createModelWing()
	
	--self:setWingZOrder(self.vo.direction)
	local posx,posy = self.vo:getPosition()
    self:setRolePosition(posx,posy)  
	--self:setModelScaleX()

end

--添加光环
function BaseRole:creatGHEffect(isSelect)
	if self.armatureGHEff then
		self:clearGHEffect()
	end
	if isSelect then
		self.curGHEffID = "ringSelect"
	else
		self.curGHEffID = "ring"
	end 
	if ArmatureManager:getInstance():loadEffect(self.curGHEffID) then
		self.armatureGHEff = ccs.Armature:create(self.curGHEffID)
		--self.armatureGHEff:stopAllActions()    
    	self.armatureGHEff:getAnimation():play("effect")
    	GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_SHADOW, self.armatureGHEff)
    	self.armatureGHEff:setPosition(self.vo.pos.x,self.vo.pos.y)
    	--self:addChild(self.armatureGHEff)
    else
    	self.curGHEffID = nil
    	self.armatureGHEff = nil
	end
end
--删除光环
function BaseRole:clearGHEffect()
	if self.armatureGHEff then
		self.armatureGHEff:getAnimation():stop()
		--self.armatureGHEff:stopAllActions()
		if self.curGHEffID then
			ArmatureManager:getInstance():unloadEffect(self.curGHEffID)
		end
		if self.armatureGHEff:getParent() then
			self.armatureGHEff:getParent():removeChild(self.armatureGHEff)
		end	
		self.armatureGHEff = nil
	end
end	

--设置模型动作索引和X缩放
function BaseRole:setModelActionIndex(direct)
	local actionIndex,xScale = FightUtil:getActionByDirect(direct)
	self.actionIndex = actionIndex
	self.roleXScale = xScale
	self:setWingZOrder(self.vo.direction)
	self:setWeaponZOrder(self.vo.direction)
end

--设置模型缩放
function BaseRole:setModelScaleX()
	if self.armature  then
		self.armature:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
		self:updateNameAndHpPos()
	end	
	if self.armatureWeapon then
		self.armatureWeapon:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
	end

	if self.armatureWing then
		self.armatureWing:setScale(self.scaleParam * self.roleXScale, self.scaleParam)
	end
end	


--显示归属掉落
function BaseRole:setDropOwner()
	if self.dropOwnerLab then
		if self.vo.dropOwner and self.vo.dropOwner.name ~= "" then
		    self.dropOwnerLab:setString("归属:"..self.vo.dropOwner.name)
		else
		    self.dropOwnerLab:setString("归属:无")
		end
	end
end

function BaseRole:setNameVisible(visible)
	if not self.nameLabel then return end
	self.nameLabel:setVisible(visible)
end

function BaseRole:setTeamIconVisible(visible)
	if not self.teamIcon then return end
	self.teamIcon:setVisible(visible)
end

function BaseRole:setUnionIconVisible(visible)
	if not self.unionIcon then return end
	self.unionIcon:setVisible(visible)
end

function BaseRole:setHpVisible(visible)
	if self.hpContainer then
		self.hpContainer:setVisible(visible)
	end
	if self.hpBarBg then
		self.hpBarBg:setVisible(visible)
		self.hpBarPic:setVisible(visible)
	end
end

function BaseRole:setAttackEffectVisible(visible)
	if self.ackEffArmature then
		self.ackEffArmature:setVisible(visible)
	end
end

--设置名字
function BaseRole:setName(name)
	--if true then return end
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
		local color = TextColor.ROLE_W
		local size = 20
		-- if self.vo.group == FightGroupType.ONE then
		-- 	color = display.COLOR_RED
		-- end
		if self.vo.type == SceneRoleType.PLAYER then
			color = self:getNameColor(self.vo.nameColor)
		elseif self.vo.type == SceneRoleType.MONSTER then
			--todo TEXT_GRAY
			--if self.vo.isBoss > 0 then
			if self.vo.mConf.type == 3 then --boss
				color = TextColor.MONSTER_R
				size = 20

				self.dropOwnerLab = display.newTTFLabel({align = cc.TEXT_ALIGNMENT_CENTER,text = "",size = size,color = TextColor.ROLE_Y})
		        	:align(display.CENTER_BOTTOM,0,0)
		        	:addTo(self.headContainer)
		        	:pos(0,-30)
		   	 	self.dropOwnerLab:setTouchEnabled(false)
		   	 -- 	self.dropOwnerLab:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
		    	-- self.dropOwnerLab:enableOutline(cc.c4b(1,1,0,1),3)
		    	-- self.dropOwnerLab:enableGlow(cc.c4b(1,1,0,1))

		    	self:setDropOwner()

			elseif self.vo.mConf.type == 2 then --精英
				color = TextColor.MONSTER_Y
				size = 18
			elseif self.vo.mConf.type == 1 then 
				color = TextColor.MONSTER_W
				size = 18
			end
		elseif self.vo.type == SceneRoleType.PET then
			color = FightUtil:getPetNameColorByLv(self.vo.lv)
		end
		self.nameLabel = display.newTTFLabel({align = cc.TEXT_ALIGNMENT_CENTER,text = name,size = size,color = color})
        	:align(display.CENTER_BOTTOM,0,0)
        	:addTo(self.headContainer)
        	:pos(0,14)
   	 	self.nameLabel:setTouchEnabled(false)
   	 -- 	self.nameLabel:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
    	-- self.nameLabel:enableOutline(cc.c4b(1,1,0,1),3)
    	-- self.nameLabel:enableGlow(cc.c4b(1,1,0,1))
	end
	-- if GameSceneModel.curSceneHideName == true and self.vo.id ~= GlobalModel.player_id then
	-- 	self.nameLabel:setString("神秘人")
	-- else
	-- 	self.nameLabel:setString(name)
	-- end
	if GameSceneModel.isInterService and (self.vo.type == SceneRoleType.PLAYER or self.vo.type == SceneRoleType.PET) then
		self.nameLabel:setString("S"..self.vo.server_name.." "..name)
	else
		self.nameLabel:setString(name)
	end
	self:updateGuildName()
	self:updateTeamIcon()
	self:updateScene32107NameColor()
end

function BaseRole:updateScene32107NameColor()
	if GameSceneModel.sceneId == 32107 then
		--print("GGGGGG",self.vo.corpsId,self.vo.id,FightModel.corpsId)
		if self.vo.corpsId ~= FightModel.corpsId then
			self.nameLabel:setColor(TextColor.ROLE_R)
			if self.guildNameLab then
				self.guildNameLab:setColor(TextColor.ROLE_R)
			end
		else
			self.nameLabel:setColor(TextColor.ROLE_W)
			if self.guildNameLab then
				self.guildNameLab:setColor(TextColor.ROLE_W)
			end
		end
	end
end

function BaseRole:updateTeamIcon()
	local playerteamId = GameSceneModel:getPlayerTeamId()
	if GlobalModel.player_id ~= self.vo.id and playerteamId ~= "0" and playerteamId == self.vo.teamId then
	--if true then
		if self.teamIcon == nil then
			self.teamIcon = display.newSprite("#scene/scene_teamFlag.png")
			self.teamIcon:setScale(0.55)
			GlobalEventSystem:dispatchEvent(FightEvent.ADD_TEAM_ICON,self.teamIcon)
			

		    
		   -- local namePos = cc.p(16,8)
			--if self.nameLabel then
			--	local size  = self.nameLabel:getContentSize()
			--	namePos.x = size.width/2 + namePos.x
			--	namePos.y = size.height + namePos.y
			--end
			--self.teamIcon:setLocalZOrder(21000-yy)
			--self.teamIcon:setPosition(namePos)
			--self.headContainer:addChild(self.teamIcon)
		    
		end
		_udpateTeamPosition(self,self.vo.pos.x, self.vo.pos.y)
	else

		if self.teamIcon and self.teamIcon:getParent()  then
			self.teamIcon:getParent():removeChild(self.teamIcon)
			self.teamIcon = nil
		end
	end
end


function BaseRole:createHeadContainer()
	if self.headContainer == nil then
		self.headContainer = display.newNode()
		GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_TOP_CONTAINER,self.headContainer)
	end
	
	return self.headContainer
end

function BaseRole:createHpContainer()
	if not self.hpContainer then
		self.hpContainer = BaseRoleHpContainer.new(self.vo)
		GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_HP_CONTAINER,self.hpContainer)
	end
	return self.hpContainer
end

--更新结盟标示
function BaseRole:updateUnionIcon()
	if RoleManager:getInstance():getHasUnion(self.vo.guildId) and self.guildNameLab then
	--if true then
		
		if self.unionIcon == nil then
			self.unionIcon = display.newSprite("#scene/scene_allianceTxt.png")
			--self.unionIcon:setScale(0.55)
		    --self.headContainer:addChild(self.unionIcon)
		    GlobalEventSystem:dispatchEvent(FightEvent.ADD_UNION_ICON,self.unionIcon)
		end
		
		_updateUnionPosition(self,self.vo.pos.x, self.vo.pos.y)
	--	local posx,posy = self.guildNameLab:getPosition()
 	--	local ww = self.guildNameLab:getContentSize().width
 	--	self.unionIcon:setPosition(posx+ww/2+15,47)
	else

		if self.unionIcon and self.unionIcon:getParent() then
			self.unionIcon:getParent():removeChild(self.unionIcon)
			self.unionIcon = nil
		end
	end
end

--设置名字
function BaseRole:updateGuildName()
	local name
	name = self.vo.guildName
	if name and name ~= "" then
		if GameSceneModel.curSceneHideName == true and self.vo.id ~= GlobalModel.player_id then
			if self.guildNameLab then
				self.headContainer:removeChild(self.guildNameLab)
				self.guildNameLab = nil
			end
			return
		end
		if self.guildNameLab == nil then
			local color = self:getNameColor(self.vo.nameColor)
			local size = 16
			self.guildNameLab = display.newTTFLabel({align = cc.TEXT_ALIGNMENT_CENTER,text = name,size = size,color = color})
	        	:align(display.CENTER_BOTTOM,0,0)
	        	:addTo(self.headContainer)
	        	:pos(0,36)
	   	 	self.guildNameLab:setTouchEnabled(false)
	   	 -- 	self.guildNameLab:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
	    	-- self.guildNameLab:enableOutline(cc.c4b(1,1,0,1),3)
	    	-- self.guildNameLab:enableGlow(cc.c4b(1,1,0,1))
		end
		if GameSceneModel.isInterService or FightModel.shaBakeGuildId == "0" or FightModel.shaBakeGuildId ~= self.vo.guildId then
			self.guildNameLab:setString(name)
		else
			self.guildNameLab:setString("(沙城)"..name)
		end
		
	else
		if self.guildNameLab then
			self.headContainer:removeChild(self.guildNameLab)
			self.guildNameLab = nil
		end
	end

	self:updateUnionIcon()
end	

--更新名称颜色
function BaseRole:updateNameColor()--nameColor
	local color = self:getNameColor(self.vo.nameColor)
	if self.vo.type == SceneRoleType.PET then
		color = FightUtil:getPetNameColorByLv(self.vo.lv)
	end
	if self.nameLabel then
		self.nameLabel:setColor(color)
	end
	if self.guildNameLab then
		self.guildNameLab:setColor(color)
	end
	self:updateScene32107NameColor()
	--self.vo.nameColor
	--1，2，3，4是白黄红灰色
end

function BaseRole:getNameColor(ctype)
	return self.vo:getNameColor(ctype)
end
--说话
--@param str 说话内容
--@param time 说话的时间
function BaseRole:say(str,time)
	if self.vo.states == RoleActivitStates.DEAD then return end
	time = time or 1
	if self.talkView and self.sayLabel then 
		self.sayLabel:setString(str)
		if self.talkTimerId then
			GlobalTimer.unscheduleGlobal(self.talkTimerId)	
			self.talkTimerId = nil
			self.talkTimerId =  GlobalTimer.scheduleGlobal(function() self:clearSay() end,time)
		end	
	end
	self.talkView = self:creatLayer()
	self.talkView:setAnchorPoint(0,0)
	self:addChild(self.talkView)

	self.talkBg = display.newScale9Sprite("#scene/scene_roleSaybg.png")
	--self.talkBg:setOpacity(90)    
    self.talkBg:addTo(self.talkView)    

    self.sayLabel = cc.ui.UILabel.new({text = str, size = 18, color = display.COLOR_WHITE})
        :align(display.LEFT_TOP,0,0)
        :addTo(self.talkView)
        :pos(0,0)
    self.sayLabel:setWidth(180)
    self.sayLabel:setAnchorPoint(0,0)
    self.sayLabel:setTouchEnabled(false)

    local lableSize = self.sayLabel:getContentSize()
    local hh = math.max(lableSize.height + 42,82)
    self.sayLabel:pos(12,hh - lableSize.height - 12)
    self.talkBg:setContentSize(214,hh)
    self.talkBg:setAnchorPoint(0,0)
    self.talkBg:pos(0, 0)

    if self.armature == nil then
    	self.bodyRec = DefBodyRect
    end	    
    if self.bodyRec == nil then
		self.bodyRec = self.armature:getBoundingBox()
	end
	local yy = self.bodyRec.height + self.bodyRec.y
	self.talkView:pos(-107, yy)

	if self.talkTimerId == nil then
		self.talkTimerId =  GlobalTimer.scheduleGlobal(function() self:clearSay() end,time)
	end	
end

function BaseRole:showFace(faceId, sec)
	sec = sec or 3
	if self.faceTimerId then
		self:hideFace()
	end
	self.faceTimerId =  GlobalTimer.scheduleGlobal(handler(self, self.hideFace), sec)
	self.faceId = faceId
	ArmatureManager:getInstance():loadEffect(faceId)
    self.quickFace = ccs.Armature:create(faceId)
    self.headContainer:addChild(self.quickFace, 999)
    self.quickFace:getAnimation():play("effect")
end

function BaseRole:hideFace()
	GlobalTimer.unscheduleGlobal(self.faceTimerId)
	self.faceTimerId = nil
	self.quickFace:getAnimation():stop()
	self.quickFace:removeSelf()
	ArmatureManager:getInstance():unloadEffect(self.faceId)
end

function BaseRole:containsPoint(point)
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

function BaseRole:setSelect(b)
	
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
	elseif self.armatureGHEff then
		self:creatGHEffect(b)
	end
end


function BaseRole:clearSay()
	if self.talkTimerId then 
    	GlobalTimer.unscheduleGlobal(self.talkTimerId)
		self.talkTimerId = nil
	end
	if self.sayLabel then
		self.sayLabel = nil
	end	
	if self.talkView then 
		self:removeChild(self.talkView)
		self.talkView = nil
	end	
end

--兵种id
function BaseRole:getRoleId()
	return self.vo.roleId
end

--得到血量
function BaseRole:getcurHP()
	return self.vo.hp
end

--得到总血量
function BaseRole:getTotalHP()
	return self.vo.totalhp
end

function BaseRole:showMpTips(addMp,isCrit,atkType)
	local str = ""
	str = str..":"..tostring(addMp)
	local xx = self.vo.pos.x
  	local yy = self.vo.pos.y
  	local tipLabel = FightEffectManager:getHurtLabEff(str,3,xx-20,yy+self.bodySize.y)
	if self.isMainPlayer and self.vo.type == SceneRoleType.PLAYER then
		if self.collectBar then
	        GameNet:sendMsgToSocket(11060,{state = 0})
	        self:showCollectBar(0)
	    end
	end
  	if tipLabel then
	    local t = math.random(0,10)/100
	    if acttype == 1 then
		    local k = -1
		    if t > 0.05 then
		    	k = 1
		    end
	    	transition.execute(tipLabel, cc.MoveBy:create(0.4, cc.p(0, 100)), {
		    --delay = 0.15,
		    easing = "Out",
		    onComplete = function()
		    	tipLabel:setVisible(false)
		    	FightEffectManager:addHurtLabEff(tipLabel)
		       -- local pare = self.tipLabel:getParent()
		       -- if pare ~= nil then       		
		       -- 		pare:removeChild(tipLabel)
		       -- end
		    end,
			})
	    else
	    	transition.execute(tipLabel, cc.MoveBy:create(0.4, cc.p(0, 100)), {
		    delay = 0.15,
		    --easing = "backOut",
		    onComplete = function()
		    	tipLabel:setVisible(false)
		    	FightEffectManager:addHurtLabEff(tipLabel)
		        -- local pare = self.tipLabel:getParent()
		        -- if pare ~= nil then       		
		        -- 		pare:removeChild(self.tipLabel)
		        -- end
		    end,
			})
	    end
	end
end
--显示提示信息
function BaseRole:showHpTips(addHp,isCrit,atkType)
	if self.armature== nil or addHp == nil then return end
	if self.armature == nil then
		self.bodyRec = DefBodyRect
	end
	if self.bodyRec == nil then
    	self.bodyRec = self.armature:getBoundingBox()
    end
    --self:showMpTips(addHp)
    isCrit = isCrit or false
	local yy = self.bodySize.y--self.bodyRec.height + self.bodyRec.y 
	local color
	local str = ""
	-- if isCrit then
	-- 	str = "被暴 "
	-- end	
	local fontSize = 24
	addHp = math.round(addHp)
	local acttype = 1
	if addHp < 0 then
		str = str..":"..tostring(0-addHp)--str.."-"..tostring(0-addHp)
		font =  1--"fonts/num_style_fight.fnt"
		-- if self.vo.type == SceneRoleType.PLAYER then
		-- 	if self.vo.sex == RoleSex.MAN then
		-- 		SoundManager:playSoundByType(SoundType.HURT_MAN)
		-- 	else
		-- 		SoundManager:playSoundByType(SoundType.HURT_WOMAN)
		-- 	end
		-- end
		if self.isMainPlayer and self.vo.type == SceneRoleType.PLAYER then
			if self.collectBar then
		        GameNet:sendMsgToSocket(11060,{state = 0})
		        self:showCollectBar(0)
		    end
			--GlobalEventSystem:dispatchEvent(FightEvent.VIBRATION_SCENE)
		end
		if self.vo.type == SceneRoleType.PLAYER and self.vo.states ~= RoleActivitStates.MOVE then
            GlobalController.model:pushModel(self.vo.modelID, self, "changCloth", self.vo.modelID)
            --self:changCloth(self.vo.modelID)
        end
		acttype = 1
	elseif addHp > 0 then
		str = str .. ":"..tostring(addHp)--str .. "+"..tostring(addHp)
		font = 2--"fonts/roleHpNumGreenFont.fnt"
		acttype = 2
	elseif addHp == 0 then
		str = ";<=>?" --sp
		font = 1--"fonts/num_style_fight.fnt"
		acttype = 3
	end	
	if isCrit then
		str = "@ABCD"..str--bj
		font = 1--"fonts/num_style_fight.fnt"
	end

	if atkType == 4 then
		str = "EFGHI"..":"..tostring(0-addHp) --sp
		font = 1--"fonts/num_style_fight.fnt"
		acttype = 1
	end

    -- GlobalEventSystem:dispatchEvent(FightEvent.ADD_ROLE_HURT_LAB,self.shadow)

	-- if self.tipLabel == nil then
	-- 	self.tipLabel = display.newBMFontLabel({
	--     	text = "",
	--     	font = font,
	--    	 	x = 0,
	--     	y = yy,
	-- 		})
	--   	self:addChild(self.tipLabel,10000)
	--   	self.tipLabel:setOpacity(180)
	--   	self.tipLabel:setTouchEnabled(false)
 --  	end
 --  	--self.tipLabel:setScale(1.4)
 --  	self.tipLabel:setPosition(0,yy)
 --  	self.tipLabel:setString(str)
 --  	self.tipLabel:setVisible(true)
 --  	self.tipLabel:stopAllActions()

 	local xx = self.vo.pos.x
  	local yy = self.vo.pos.y
  	local tipLabel = FightEffectManager:getHurtLabEff(str,font,xx-20,yy+self.bodySize.y)

  	if tipLabel then
	    local t = math.random(0,10)/100
	    if acttype == 1 then
		    local k = -1
		    if t > 0.05 then
		    	k = 1
		    end
	    	transition.execute(tipLabel, cc.MoveBy:create(0.3, cc.p(0, 100)), {
		    --delay = 0.15,
		    easing = "Out",
		    onComplete = function()
		    	tipLabel:setVisible(false)
		    	FightEffectManager:addHurtLabEff(tipLabel)
		       -- local pare = self.tipLabel:getParent()
		       -- if pare ~= nil then       		
		       -- 		pare:removeChild(tipLabel)
		       -- end
		    end,
			})
	    else
	    	transition.execute(tipLabel, cc.MoveBy:create(0.3, cc.p(0, 100)), {
		    delay = 0.15,
		    --easing = "backOut",
		    onComplete = function()
		    	tipLabel:setVisible(false)
		    	FightEffectManager:addHurtLabEff(tipLabel)
		        -- local pare = self.tipLabel:getParent()
		        -- if pare ~= nil then       		
		        -- 		pare:removeChild(self.tipLabel)
		        -- end
		    end,
			})
	    end
	end
end	

--设置血量
--atkType 攻击者类型
function BaseRole:setHP(curHp, curMp,addHp,isCrit,showTips,atkType)
	if self.nameLabel == nil then
		self:setName(self.vo.name)
	end
	--if self.vo.states == RoleActivitStates.DEAD then return end
	if addHp and showTips then
		self:showHpTips(addHp,isCrit,atkType)
	end	
	local totalHp = self.vo.totalhp
	if curHp > totalHp then
		curHp = totalHp 
	end	
	if curHp < 0 then
		curHp = 0
	end
 	self:updateHp(curHp,totalHp)
end

function BaseRole:oldUpdateHpContainer(curHp,totalHp)
	if self.hpBarPic == nil then
		local hpBarBg = display.newSprite("#scene/scene_mbloodBg.png")
	    local bgW = self.hpBarWidth+2
	    hpBarBg:setContentSize(bgW, 8)
	    local rect = hpBarBg:getTextureRect()
	    hpBarBg:setScale(bgW / rect.width, 8 / rect.height)
	    --self:addChild(node)
	    hpBarBg:addTo(self.headContainer)
	    hpBarBg:setAnchorPoint(0,0.5)
	    hpBarBg:setPosition(-bgW / 2, 5)
	    self.headContainer:setPosition(self.vo.pos.x,(self.bodySize.y+self.vo.pos.y))
	    self.hpBarBg = hpBarBg
	    --hpBarBg:setPosition(0,9)

	    --self.hpBarClippingRegion = cc.ClippingRegionNode:create()
	    --self.hpBarClippingRegion:setAnchorPoint(0,0)
	    --self.hpBarClippingRegion:setPosition(0-self.hpBarWidth/2,-3+5)
	    --self.hpBarClippingRegion:setPosition(0-self.hpBarWidth/2,-3+9)
	   --self:addChild(self.hpBarClippingRegion)
	    self.hpBarPic =  display.newSprite("#scene/scene_mbloodHp.png")
	    rect = self.hpBarPic:getTextureRect()
	    self.hpScale = self.hpBarWidth / rect.width
	    self.hpBarPic:setScale(self.hpScale, 6 / rect.height)
	    self.hpBarPic:setAnchorPoint(0,0)
	    self.hpBarPic:addTo(self.headContainer)
	    self.hpBarPic:setPosition(hpBarBg:getPositionX(),0)
	    

	    --GlobalEventSystem:dispatchEvent(FightEvent.PLAY_TOP_EFFECT,self.hpBarPic)
	    -- self.bloodRect = cc.rect(0, 0, (curHp /totalHp)*self.hpBarWidth, 6)

	    -- self.buffIconLayer:pos(self.hpBarWidth/2 +13,0)
	end
	-- self.bloodRect.width = (curHp /totalHp)*self.hpBarWidth
	-- self.hpBarClippingRegion:setClippingRegion(self.bloodRect)

	self.hpBarPic:setScaleX(curHp /totalHp * self.hpScale)
end

function BaseRole:newUpdateHpContainer(curHp,totalHp)
	if not self.hpContainer then
		self:createHpContainer()
	end
	self.hpContainer:updateHp(curHp,totalHp)
end

--更新气血
function BaseRole:updateHp(curHp,totalHp)
	self:newUpdateHpContainer(curHp, totalHp)
	--self:oldUpdateHpContainer(curHp,totalHp)
	--[[
	--if true then return end
	if self.hpBarPic == nil then
	    local hpBarBg = display.newSprite("#scene_roleBloodBarBg.png")
	    local bgW = self.hpBarWidth+2
	    hpBarBg:setContentSize(bgW, 8)
	    local rect = hpBarBg:getTextureRect()
	    hpBarBg:setScale(bgW / rect.width, 8 / rect.height)
	    --self:addChild(node)
	    hpBarBg:addTo(self.headContainer)
	    hpBarBg:setAnchorPoint(0,0.5)
	    hpBarBg:setPosition(-bgW / 2, 5)
	    self.headContainer:setPosition(self.vo.pos.x,(self.bodySize.y+10+self.vo.pos.y))
	    --hpBarBg:setPosition(0,9)

	    --self.hpBarClippingRegion = cc.ClippingRegionNode:create()
	    --self.hpBarClippingRegion:setAnchorPoint(0,0)
	    --self.hpBarClippingRegion:setPosition(0-self.hpBarWidth/2,-3+5)
	    --self.hpBarClippingRegion:setPosition(0-self.hpBarWidth/2,-3+9)
	   --self:addChild(self.hpBarClippingRegion)
	    self.hpBarPic =  display.newSprite("#scene_roleBloodBar.png")
	    rect = self.hpBarPic:getTextureRect()
	    self.hpScale = self.hpBarWidth / rect.width
	    self.hpBarPic:setScale(self.hpScale, 6 / rect.height)
	    self.hpBarPic:setAnchorPoint(0,0)
	    self.hpBarPic:addTo(self.headContainer)
	    self.hpBarPic:setPosition(hpBarBg:getPositionX() + 1,1)

	    --GlobalEventSystem:dispatchEvent(FightEvent.PLAY_TOP_EFFECT,self.hpBarPic)
	    -- self.bloodRect = cc.rect(0, 0, (curHp /totalHp)*self.hpBarWidth, 6)

	    -- self.buffIconLayer:pos(self.hpBarWidth/2 +13,0)
	end
	-- self.bloodRect.width = (curHp /totalHp)*self.hpBarWidth
	-- self.hpBarClippingRegion:setClippingRegion(self.bloodRect)

	self.hpBarPic:setScaleX(curHp /totalHp * self.hpScale)
]]--
	self.vo.hp = curHp
	if curHp <= 0 then
		self:setStates(RoleActivitStates.DEAD)
	end
	-- --魔法值不显示
	-- if self.vo.type == SceneRoleType.PLAYER and false then
	-- 	--魔法值
	-- 	if self.mpBarPic == nil then
	-- 	    local mpBarBg = display.newScale9Sprite("#scene_roleBloodBarBg.png")
	-- 	    mpBarBg:setContentSize(self.hpBarWidth+2, 8)
	-- 	    mpBarBg:addTo(self.headContainer)

	-- 	    self.mpBarClippingRegion = cc.ClippingRegionNode:create()
	-- 	    self.mpBarClippingRegion:setAnchorPoint(0,0)
	-- 	    self.mpBarClippingRegion:setPosition(0-self.hpBarWidth/2,-3)
	-- 	    self.headContainer:addChild(self.mpBarClippingRegion)

	-- 	    self.mpBarPic =  display.newScale9Sprite("#scene_roleMBloodBar.png")
	-- 	    self.mpBarPic:setContentSize(self.hpBarWidth, 6)
	-- 	    self.mpBarPic:setAnchorPoint(0,0)
	-- 	    --self.mpBarPic:setColor(cc.c3b(3, 147, 247))

	-- 	    self.mpBarPic:addTo(self.mpBarClippingRegion)
	-- 	    self.mbloodRect = cc.rect(0, 0, 0, 6)
	-- 	end

	-- 	curMp = math.min(self.vo.mp_limit,math.max(curMp,0))
	-- 	self.mbloodRect.width = (curMp /self.vo.mp_limit)*self.hpBarWidth
	-- 	self.mpBarClippingRegion:setClippingRegion(self.mbloodRect)
	-- 	self.vo.mp = curMp
	-- end
end


function BaseRole:showHonorPic(honorId)
	if self.honorId ~= honorId and honorId ~= 0 and self.headContainer and GameSceneModel.curSceneHideName == false and GameSceneModel.isInterService == false then
		self.honorId = honorId
		-- ArmatureManager:getInstance():loadEffect("honor"..honorId)
		-- self.honorArmature=  ccs.Armature:create("honor"..honorId)
  --   	self.headContainer:addChild(self.honorArmature)
  --   	self.honorArmature:setPosition(0,115)
  --  	 	self.honorArmature:setTouchEnabled(false)
  --  	 	self.honorArmature:getAnimation():play("effect")
        display.addImageAsync(ResUtil.getHonorIcon(honorId), function(texture)
        	if self.honorArmature or self.honorId == 0 then
        		return
        	end
			self.honorArmature = display.newSprite(texture)
   	 	    self.headContainer:addChild(self.honorArmature)
   	 	    self.honorArmature:setPosition(0,80)
		end)

  		
   	else
   	 	if self.honorArmature then
   -- 	 		self.honorArmature:stopAllActions()
			-- self.honorArmature:getAnimation():stop()	
			if self.honorArmature:getParent() then
				self.honorArmature:getParent():removeChild(self.honorArmature)
			end	
	   		self.honorArmature = nil
	  --  		ArmatureManager:getInstance():unloadEffect(ResUtil.getHonorIcon(self.honorId))
	   		self.honorId = 0

   	 	end
	end
end

function BaseRole:showCollectBar(collectState,data)
	if collectState > 0 then
		if self.collectBar == nil then
			self.collectBar = require("app.gameScene.view.RoleCollectionBar").new()--RoleCollectionBar
			self:addChild(self.collectBar)
			self.collectBar:setPosition(-36,60)
			self.collectBar:open(data or {time = collectState,isOpen = true,id = 0,tips = "采集中"})
		end
	else
		if self.collectBar then
			self.collectBar:destory()
			self:removeChild(self.collectBar)
			self.collectBar = nil
		end
	end
end

-- --显示寻路中
-- function BaseRole:showAutoWayTxt(bool)
-- -- 	if bool and self.autoWayTxt == nil then
-- -- 		--[[
-- --    	 	ArmatureManager:getInstance():loadEffect("zidongxunlu")
-- -- 		self.autoWayTxt=  ccs.Armature:create("zidongxunlu")
-- --     	self.headContainer:addChild(self.autoWayTxt)
-- --     	self.autoWayTxt:setPosition(0,-display.height/2 + 30)
-- --    	 	self.autoWayTxt:setTouchEnabled(false)
-- --    	 	self.autoWayTxt:getAnimation():play("effect")
-- --    	 	--self:clearAutoFightingTxt()
-- -- --]]
-- --    	 	GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_PLAYER_AUTO_RUN,{show = true})
-- --    	elseif bool == false then
-- --    		--self:clearAutoWayTxt()
-- --    		GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_PLAYER_AUTO_RUN,{show = false})
-- -- 	end
-- end
-- 清除寻路中文本
function BaseRole:clearAutoWayTxt()
	if self.autoWayTxt then
   		self.autoWayTxt:stopAllActions()
		self.autoWayTxt:getAnimation():stop()	
		if self.autoWayTxt:getParent() then
			self.autoWayTxt:getParent():removeChild(self.autoWayTxt)
		end	
   		self.autoWayTxt = nil
   		ArmatureManager:getInstance():unloadEffect("zidongxunlu")
   	end
end

--更新名字和血量位置
function BaseRole:updateNameAndHpPos()
	-- if self.armature == nil then 
	-- 	self.bodyRec = DefBodyRect
	-- end
	-- if self.bodyRec == nil then
	-- 	self.bodyRec = self.armature:getBoundingBox()
	-- end
	
	-- local yy = self.bodyRec.height + self.bodyRec.y	
	--if self.headContainer then
	--	self.headContainer:pos(self.vo.pos.x,(self.bodySize.y+30+self.vo.pos.y))--*self.scaleParam)
	--end

	self:updateHeadContainerPosition(self.vo.pos.x, self.vo.pos.y)

end	

--是否可以移动,Buff控制是否可以移动
function BaseRole:canMoveByBuff()
	local fightAtt = self.vo.fightAtt
	if fightAtt.buffDizzy>0 or fightAtt.buffIce>0 or fightAtt.buffSleep>0 or fightAtt.buffNotMove>0 then
		return false
	end
	return true	
end

--Buff控制是否可以释放技能
function BaseRole:canSkillByBuff()
	local fightAtt = self.vo.fightAtt
	if fightAtt.buffDizzy>0 or fightAtt.buffIce>0 or fightAtt.buffSleep>0 or fightAtt.buffSilence>0 then
		return false
	end
	return true	  
end	

-- 	[10240] = {bId=10240,bType=3,buffAtt="buffDizzy",  buffValue=1,   desc="晕 受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
-- 	[10240] = {bId=10240,bType=3,buffAtt="buffIce",  buffValue=1,   desc="冰住  受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
-- 	[10250] = {bId=10250,bType=3,buffAtt="buffSleep",  buffValue=1,   desc="睡住",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
-- [10260] = {bId=10260,bType=3,buffAtt="buffInvisible",  buffValue=1,   desc="隐身  则敌方目标无法作为目标选中拥有该状态的单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
--	[10270] = {bId=10270,bType=3,buffAtt="buffUnmatched",  buffValue=1,  desc="无敌  受到的所有伤害均变为1（包含BUFF带来的持续伤害）",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
--	[10280] = {bId=10280,bType=3,buffAtt="buffSilence",  buffValue=1,   desc="沉默   无法施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
--	[10290] = {bId=10290,bType=3,buffAtt="buffNotMove",  buffValue=1,   desc="禁止移动  无法进行移动",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
--	[10300] = {bId=10300,bType=3,buffAtt="buffVampire",  buffValue=1,   desc="吸血  造成的伤害均会等量治疗自己",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
--[10320] = {bId=10320,bType=3,buffAtt="buffSame",  buffValue=1,   desc="黑蜂  只能攻击这个状态的敌人",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
	

--[10310] = {bId=10310,bType=3,buffAtt="buffControl",  buffValue=1,   desc="控制  伤害自己单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,refresh=0,stack=0,},
	

function BaseRole:setArmatureOpacity(value)
	if value ~= self.curOpacity and self.armature then
		if self.armature:getOpacity() ~= value then
			self.curOpacity = value
			self.armature:setOpacity(value)
		end
		if self.armatureWeapon and self.armatureWeapon:getOpacity() ~= value then
			self.armatureWeapon:setOpacity(value)
		end
		if self.armatureWing and self.armatureWing:getOpacity() ~= value then
			self.armatureWing:setOpacity(value)
		end
	end
end


function BaseRole:setArmatureColor(value)
	if self.armature and self.armature:getColor() ~= value then
		self.armature:setColor(value)
		-- for k,v in pairs(self.armature:getBoneDic()) do
		-- 	local displayNode = v:getDisplayRenderNode()
		-- 	if displayNode then
		-- 		displayNode:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
		-- 	end
		-- end
		-- --self.sp:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
		-- --self.armature:setFilter(filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1}))
	end
	if self.armatureWeapon and self.armatureWeapon:getColor() ~= value  then
		self.armatureWeapon:setColor(value)
	end
	if self.armatureWing and self.armatureWing:getColor() ~= value  then
		self.armatureWing:setColor(value)
	end
end


function BaseRole:setHeadContainerVisible(visible)
	if self.headContainer then
		self.headContainer:setVisible(visible)
	end
	if self.hpContainer then
		self.hpContainer:setVisible(visible)
	end
end

--
function BaseRole:setRoleVisible(b)
	self:setVisible(b)
	if self.shadow then
		self.shadow:setVisible(b)
	end
	if self.armatureGHEff then
		self.armatureGHEff:setVisible(b)
	end
	if self.vo.states ~= RoleActivitStates.DEAD then
		self:setHeadContainerVisible(b)
	end
end

function BaseRole:setPos(p)
	self.vo.pos = p
	self:setPosition(p)
end	

function BaseRole:getPos()
	return self:getPosition()
end

function BaseRole:setStates(states)
	self.vo.states = states	
end

function BaseRole:getStates()
	return self.vo.states
end	

function BaseRole:setAnimationSpeed(value)
	if self.animationSpeed ~= value then
		self.animationSpeed = value
	else
		return
	end	
	if self.armature then
		self.armature:getAnimation():setSpeedScale(value)--设置播放速度
	end
	if self.armatureWeapon then
		self.armatureWeapon:getAnimation():setSpeedScale(value)--设置播放速度
	end
	if self.armatureWing then
		self.armatureWing:getAnimation():setSpeedScale(value)--设置播放速度
	end
	if self.ackEffArmature then
		self.ackEffArmature:getAnimation():setSpeedScale(value)--设置播放速度
	end
	if self.hurtEffArmature then
		self.hurtEffArmature:getAnimation():setSpeedScale(value)--设置播放速度
	end
end	

function BaseRole:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	-- self:addChild(layer)
	-- layer:pos(0, 0)
	--layer:setAnchorPoint(0,0)
	return layer
end	


--播放冲撞
function BaseRole:playCollision(pos)
	if self.isDestory_ then
		return
	end
	self.posList = {}
	self.newPos = pos

	local tDis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,self.newPos.x,self.newPos.y)
	local len = tDis/20
	self.moveSpeedX = (self.newPos.x - self.vo.pos.x)/len
	self.moveSpeedY = (self.newPos.y - self.vo.pos.y)/len
	if self.moveSpeedX ~=0 or self.moveSpeedY ~= 0 then
		local ang = FightUtil:getAngle(self.vo.pos, self.newPos)
		self.vo.direction =FightUtil:getDirectByAngle(ang)
	end
		
	self:setModelActionIndex(self.vo.direction)
	self:setModelScaleX()

	if self.vo.states ~= RoleActivitStates.DEAD then
		self:setStates(RoleActivitStates.MOVE)
		self.posOffset = 20
	end

end

--播放被冲撞
function BaseRole:playBeCollision(pos)
	if self.isDestory_ then
		return
	end
	self.posList = {}
	self.newPos = pos

	local tDis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,self.newPos.x,self.newPos.y)
	local len = tDis/16
	self.moveSpeedX = (self.newPos.x - self.vo.pos.x)/len
	self.moveSpeedY = (self.newPos.y - self.vo.pos.y)/len
	if self.moveSpeedX ~=0 or self.moveSpeedY ~= 0 then
		local ang = FightUtil:getAngle(self.newPos, self.vo.pos)
		self.vo.direction =FightUtil:getDirectByAngle(ang)
	end
		
	 self:setModelActionIndex(self.vo.direction)
	 self:setModelScaleX()

	if self.vo.states ~= RoleActivitStates.DEAD then
		self:setStates(RoleActivitStates.MOVE)
		self.posOffset = 16
	end
end