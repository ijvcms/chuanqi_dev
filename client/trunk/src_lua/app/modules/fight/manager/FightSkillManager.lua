--
-- Author: 21102585@qq.com
-- Date: 2014-12-17 18:33:44
-- 战斗技能管理器
FightSkillManager = FightSkillManager or {}

function FightSkillManager:ctor()
	self.buffTable = {}  --游戏中所有Buff的表
	self.buffEffect = {} --游戏中记录所有Buff效果的表
end	

--执行技能
--@param roleVO 角色VO
--@param skillConf 技能配置信息
function FightSkillManager:executeSkill(role)
	if self.fightControl == nil then
		self.fightControl = GlobalController.fight
	end
	local vo = role.vo
	local skill = vo.skillConfig
	local fightAtt = vo.fightAtt

	if skill.hasAtk == 1 then
		fightAtt.sEnergy = skill.energy--能量加成值
		fightAtt.sArmor = skill.armor--护甲加成值
		fightAtt.sAtkAir =skill.atkAir --对空攻击加成值
		fightAtt.sAtkLand =skill.atkLand --对地攻击加成值
		fightAtt.sAtk =skill.atk --攻击加成值（所有攻击） ？？？？
		fightAtt.sDef =skill.def --防御加成值
		fightAtt.sBreaks = skill.breaks --破甲加成值
		fightAtt.sHurt = skill.hurt --伤害加成值
		fightAtt.sDisHurt = skill.disHurt --免伤加成值
		fightAtt.sBlood = skill.blood --治疗加成值

		fightAtt.sHit = skill.hit--命中率加成值
		fightAtt.sDodge = skill.dodge--闪避率加成值
		fightAtt.sCrit = skill.crit --暴击率加成值 0表示没有暴击
		fightAtt.sCritPer = skill.critPer --暴击比列如15000表示1.5倍伤害

		fightAtt.sAtkAirRate =skill.atkAirRate --对空攻击加成比率
		fightAtt.sAtkLandRate =skill.atkLandRate --对地攻击加成比率
		fightAtt.sAtkRate =skill.atkRate or 0 --攻击加成比率(增加百分比)/？？？？
		fightAtt.sDefRate =skill.defRate --防御加成比率
		fightAtt.sBreakRate = skill.breakRate --破甲加成比率
		fightAtt.sHurtRate = skill.hurtRate --伤害加成比率(增加百分比)一般是1以上
		fightAtt.sDisHurtRate = skill.disHurtRate --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
		fightAtt.sBloodRate = skill.bloodRate --治疗加成比率
		fightAtt.sAtkSpeed = skill.atkSpeed  --攻击速度加成比率
	end

	-- --执行玩家的Buff 放在玩家受伤害的地方
	-- self:executeBuff(skill.targetBuff,vo.id)
	--执行自己的Buff
	if type(skill.selfBuff) == "table" then
		self:executeBuff(skill.selfBuff,vo.id)
	end
end

--执行Buff列表
--buffList  buffID列表
--targetID  buff执行目标
function FightSkillManager:executeBuff(buffList,targetID)
	for i=1,#buffList do
		local buffConfig = FightBuffConf[buffList[i]]
		if buffConfig then
			FightSkillManager:creatBuff(BuffVO.new(buffConfig,targetID))
		end
	end
end	



function FightSkillManager:update(curTime)
	for k,v in pairs(self.buffTable) do
		v:update(curTime)
	end
end	

--创建Buff
function FightSkillManager:creatBuff(buffVO)
	local targetView = self.fightControl:getRoleModel(buffVO.targetId)
	if targetView == nil then return end
	local vo = targetView.vo	
	if vo.fightAtt:hasBuff(buffVO.bId) then
		return
	end

	-- local canAdd = true
	-- for _,v in pairs(vo.fightAtt) do
	-- 	if buffVO.subType == v.subType then
	-- 		if buffVO.level > v.level then
	-- 			self:clearBuff(v)	
	-- 		else
	-- 			canAdd = false
	-- 		end
	-- 		break
	-- 	end	
	-- 	if buffVO.bType == 3 and v.bType == 3 then
	-- 		if FightUtil:hasSubNum(buffVO.repel,v.subType) == false then
				
	-- 		else
	-- 			canAdd = false	
	-- 		end	
	-- 		break
	-- 	end	
	-- end

	-- if canAdd == false then return end

	FightSkillManager.buffTable[buffVO.id] = buffVO	

	if buffVO.bType == 1 then
		local buffIcon =  display.newSprite("res/icon/buff/101000.png")
		targetView.buffIconLayer:addChild(buffIcon)
		buffIcon:setScale(1)
		--buffIcon:setContentSize(18, 18)
	 	buffIcon:pos(0, 0)

	 	FightSkillManager.buffEffect[buffVO.id] = buffIcon

	 	local childers = targetView.buffIconLayer:getChildren()	 	
	 	for i=1,#childers do
	 		childers[i]:pos((i-1)*20,0)
	 		--childers[i]:pos((i-1)*20 - (targetView.hpBarWidth/2)+10,0)
	 	end
	 --    self.hpBarPic:addTo(self.tipLayer)
	else
		if buffVO.buffRes ~= "" then
			local buffEffArmature = ArmatureManager:getInstance():creatArmature(buffVO.buffRes)--ccs.Armature:create(hurtEffectId)
			buffEffArmature:setScaleX(1*vo.roleDirection)
	    	buffEffArmature:setScaleY(1) 
	    	--buffEffArmature:getAnimation():setSpeedScale(self.animationSpeed)

	    	local pos = vo:getRoleConfig().buffPos
	    	buffEffArmature:setPosition(pos[1][1],pos[1][2])
	    	targetView.topLayer:addChild(buffEffArmature)
	    	buffEffArmature:stopAllActions()    
	    	buffEffArmature:getAnimation():play("effect")
	    	FightSkillManager.buffEffect[buffVO.id] = buffEffArmature
		end
	end	

	vo.fightAtt:addBuff(buffVO)
	
	if buffVO.buffAtt == "buffInvisible" then --隐身Buff特殊处理		
		targetView:setArmatureOpacity(50)
	elseif buffVO.buffAtt == "buffControl" then --控制Buff特殊处理
		--self:changRoleGroup(targetView)
	end	
end	

--清理BUff效果，他不但要清除Buff还要还原Buff的特殊处理，
--只能在BuffVO中调用
function FightSkillManager:clearBuff(buffVO)
	self:deleteBuff(buffVO)
	--隐身Buff特殊处理
	local targetView = self.fightControl:getRoleModel(buffVO.targetId)
	if targetView ~= nil then 
		if buffVO.buffAtt == "buffInvisible" then
			targetView:setArmatureOpacity(255)
		elseif buffVO.buffAtt == "buffControl" then
			--self:changRoleGroup(targetView)
		end		
	end
end	

--删除Buff，
function FightSkillManager:deleteBuff(buffVO)
	local onlyId = buffVO.id --buff 唯一ID
	local buffArmature = FightSkillManager.buffEffect[onlyId]
	if buffArmature then
		local parent = buffArmature:getParent()
		if buffVO.bType == 1 then		
			if parent then    		
		    	parent:removeChild(buffArmature)
		    	local childers = parent:getChildren()
		 		for i=1,#childers do
		 			childers[i]:pos((i-1)*20,0)
	 				--childers[i]:pos((i-1)*20 - (targetView.hpBarWidth/2)+10,0)
	 			end
		    end 
		    FightSkillManager.buffEffect[onlyId] = nil
		else
			if buffArmature then		
				buffArmature:stopAllActions()
		    	buffArmature:getAnimation():stop()
		    	if parent then    		
		    		parent:removeChild(buffArmature)
		    	end 
		    	FightSkillManager.buffEffect[onlyId] = nil
			end
		end
	end
	
	FightSkillManager.buffTable[onlyId] = nil
	
	local roleVo = GameSceneModel:getSceneObjVO(buffVO.targetId)
	if roleVo then
		roleVo.fightAtt:delectBuff(buffVO)
	end
end	


function FightSkillManager:destory()
	FightSkillManager.buffTable = {}
	for k,v in pairs(self.buffEffect) do
		if v.getAnimation and v:getAnimation() then
			v:stopAllActions()
    		v:getAnimation():stop()
    	end
    	if v:getParent() then
    		v:getParent():removeChild(v)
    	end 
    	FightSkillManager.buffEffect[k] = nil
	end
end	

--暂停
function FightSkillManager:pause()
  for k,v in pairs(self.buffEffect) do		
    	v:getAnimation():pause()
	end
end 

--恢复暂停
function FightSkillManager:resume()
  for k,v in pairs(self.buffEffect) do		
    	v:getAnimation():resume()
	end 
end 


--[[
  @description spline曲线插值
  @param ratio 插入点时间在总时间中的比
  @param p0,p1 <--> p2,p3
  @return 对应时间的值
]]
function FightSkillManager:splineInsertTimeValue(ratio,p0,p1,p2,p3)
	local t = ratio;
	local res = 0.5 * (
			(2 * p1)
			+ (-p0 + p2) * t
			+ (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t
			+ (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t
		);
	return res;
end

--[[
  @description 贝塞尔曲线n次插值
  @param ratio 插入点时间在总时间中的比
  @param controlPoints 控制点数组（至少3个点）{0,100,200,300...}头尾分别为起点，终点
]]
function FightSkillManager:bezierInsertTimeValue(ratio,controlPoints)
	local t = ratio;
	local cp = controlPoints;
	if t == nil or cp == nil then
		return nil;
	end
		
	local power = #cp - 1;--几次贝塞尔曲线
	if power < 2 then
		return nil;
	end

	local res = 0;
	for i=0,power do
		if type(cp[i+1]) ~= "number" then
			return nil;
		end

		if i == 0 then
			res = res + cp[i+1] * math.pow(1 - t,power);
		elseif i == power then
			res = res + cp[i+1] * math.pow(t,power);
		else
			res = res + power * cp[i+1] * math.pow(t,i) * math.pow(1-t,power-i);
		end
	end
	
	return res;
end


	
--第1位，BUFF性质  1:良性  2:恶性  3:中性
--第2-3位，BUFF计算方式  00:无需计算  01:直接加值  02:直接加成
--第4-5位，BUFF效果类型 01 对空攻击 02 对地攻击 03 对地对空攻击 04 防御 05 护甲 06 能量 07命中率 08 暴击率 09 破甲比率 10 暴击伤害加成比例
--						11 伤害 12 免伤害 13 一次气血加成,15持续性加血 16一次性吸血,17持续性吸血  18增加攻速 19减少攻速
--						21 伤害加成 22免伤加成
--第6位，相同BUFF的唯一标识

--   对空攻击增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--    对地攻击增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--    所有攻击增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--    防御增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--    护甲增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--   能量增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}
--   命中率增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}万分制
--    暴击率增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}万分制
--   破甲比率增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,1000}万分制
--    暴击伤害加成比例增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,200}百分制
--   伤害增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,200}
--   免伤害增加 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,200}
--   治疗气血增加 {命中概率, 持续时间, 是否驱散,是否替换,值,间隔时间}  如 {100,0,1,1,200,0} --一次性增加气血
--   治疗气血增加 {命中概率, 持续时间, 是否驱散,是否替换,值,间隔时间}  如 {100,12000,1,1,200,5000} --持续性增加气血
--   吸血 {命中概率, 持续时间, 是否驱散,是否替换,值,间隔时间}  如 {100,0,1,1,200,0} --一次性吸血
--   持续性吸血 {命中概率, 持续时间, 是否驱散,是否替换,值,间隔时间}  如 {100,12000,1,1,200,2000} --一次性吸血
--   增加攻速 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,120} --增加攻速 大于100是加攻速，小于是减速
--   减少攻速 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,80} --减少攻速
--   伤害加成 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,150}
--   免伤加成 {命中概率, 持续时间, 是否驱散,是否替换,值}  如 {100,12000,1,1,50}
