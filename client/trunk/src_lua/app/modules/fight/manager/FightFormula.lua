--
-- Author: 21102585@qq.com
-- Date: 2014-12-16 11:03:57
-- 战斗公式

FightFormula = FightFormula or {}

--战斗计算公式
--@param selfVO 攻击方VO
--@param enemyVO 被攻击方VO
--@param skill 使用的技能
function FightFormula:damageCalculation(selfVO,enemyVO,isDoctor)
	--clone()
	--是否命中	
	math.randomseed(socket.gettime())	
	local hasHitRate = true
	if (selfVO.hit - enemyVO.dodge - math.random(0,10000)) < 0 and selfVO.group ~= enemyVO.group then
		hasHitRate = false
		return 0,false
	end	
	local selfAtt = selfVO

	local enemyAtt = enemyVO
	
	--当前攻击力
	local curAtk = 0
	local atkAddRate = 0
	local atkAdd = 0
	if enemyVO.roleConfig.moveType == 1 then
		curAtk = selfAtt.atkLand*(1+selfAtt.atkLandRate)*(1+selfAtt.atkRate)+selfAtt.atk
	else
		curAtk = selfAtt.atkAir*(1+selfAtt.atkAirRate)*(1+selfAtt.atkRate)+selfAtt.atk
	end		

	--计算暴击值，没有暴击是1
	local isCrit = false --是否暴击
	local curCrit = 1

	if selfAtt.crit - math.random(0,10000) > 0 then
		curCrit = 1.5 + selfAtt.critPer or 0
		curCrit = math.max(1.5,curCrit)
		isCrit = true
	end	
	--伤害浮动系数
	local hurtRange = 1--math.random(900,1100)/1000
	--能量伤害
	local energyHurt = math.max(math.min(selfAtt.energy/100,2),0.2)
	--防守方护甲免伤
	local armorHurt = math.max(math.min(1-((enemyAtt.armor-100)/100),2),0.2)
	--伤害类型系数 爆炸型，啥子型等
	local hurtCoefficient = 1

	--克制关系计算
	
	local kzHurtValue = 0 --增加伤害值   raceType 种族类型 1人，2神，3虫  armorType 装甲类型 1机械 2生物 3幽灵
	local kzHurtRate = 0 --增加伤害比率

	local raceType = enemyVO.roleConfig.raceType
	local armorType = enemyVO.roleConfig.armorType

	if raceType == 1 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bTerran
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bTerranRate + (selfAtt.roleConfig.terran or 0)
	elseif raceType == 2 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bProtoss
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bProtossRate + (selfAtt.roleConfig.protoss or 0)
	elseif raceType == 3 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bZerg
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bZergRate + (selfAtt.roleConfig.zerg or 0)
	end

	if armorType == 1 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bMecha 
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bMechaRate+(selfAtt.roleConfig.mecha or 0)
	elseif armorType == 2 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bBiology
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bBiologyRate +(selfAtt.roleConfig.biology or 0)
	elseif armorType == 3 then
		kzHurtValue = kzHurtValue + selfAtt.fightAtt.bGhost
		kzHurtRate = kzHurtRate + selfAtt.fightAtt.bGhostRate+(selfAtt.roleConfig.ghost or 0)
	end
		
	if isDoctor then
		--治疗量=（(攻击方攻击力*技能伤害百分比+技能伤害附加）*暴击比例*伤害浮动系数*（攻击方能量伤害）*（攻击方治疗加成比）+攻击方治疗加成值）*被治疗方受到治疗效果加成比+被治疗方受到治疗效果加成值
		local hpValue = ((curAtk*(selfAtt.fightAtt.sHurtRate+1)+selfAtt.fightAtt.sHurt)*curCrit*hurtRange*energyHurt*(1+selfAtt.bloodRate)+selfAtt.blood)*(1+enemyAtt.bloodRate)+enemyAtt.blood
		--hpValue = hpValue*(1+kzHurtRate) + kzHurtValue
		return 	0-hpValue,isCrit
	end	

	--计算伤害
	--普通伤害=（攻击方攻击-（防守方防御-破甲值），若攻击方攻击<（10/9）*（防守方防御-破防值），则普通伤害=攻击方攻击的10%；如果破甲值>防守方防御，则破甲值=防守方防御
	local comHurt = 0 --普通伤害
	local breaks = selfAtt.breaks*(selfAtt.breakRate+1) --破甲值
	if curAtk < ((enemyAtt.def-breaks)*10)/9 then
		comHurt = curAtk /10
	elseif breaks > enemyAtt.def then
		breaks = enemyAtt.def
	else	
		comHurt = curAtk - enemyAtt.def + selfAtt.breaks
	end	
	--实际伤害=(普通伤害*技能百分比+技能附加）*暴击比例*伤害类型系数*伤害浮动系数*（攻击方能量伤害）*（防守方护甲免伤）*（攻击方伤害加成比）*（1-防守方免伤率）+攻击方伤害加成值-防守方技能免伤值
	local hurtValue = (comHurt*(selfAtt.fightAtt.sHurtRate/10000+1)+selfAtt.fightAtt.sHurt)*curCrit*hurtCoefficient*hurtRange*energyHurt*armorHurt*(1+selfAtt.hurtRate)*(1-enemyAtt.disHurtRate)+selfAtt.hurt-enemyAtt.disHurt
	--hurtValue = math.max(hurtValue*(1+kzHurtRate) + kzHurtValue,1)
	hurtValue = hurtValue*(1+kzHurtRate/10000) + kzHurtValue/10000
	-- print(selfVO.roleId,hurtValue,kzHurtRate,kzHurtValue)
	return hurtValue,isCrit
end


-- self.atk = self.fightAtt:getAtk()
	-- self.energy = self.fightAtt:getEnergy() --能量
	-- self.armor = self.fightAtt:getArmor() --护甲
	-- self.atkAir = self.fightAtt:getAtkAir() --对空攻击
	-- self.atkLand = self.fightAtt:getAtkLand() --对地攻击
	-- self.def = self.fightAtt:getDef() --防御
	-- self.breaks = self.fightAtt:getBreaks()   --破甲
	-- self.hurt = self.fightAtt:getHurt() --伤害
	-- self.disHurt = self.fightAtt:getDisHurt() --免伤
	-- self.blood = self.fightAtt:getBlood() --治疗

	-- self.hit = self.fightAtt:getHit()--命中率
	-- self.dodge = self.fightAtt:getDodge()--闪避率
	-- self.crit = self.fightAtt:getCrit() --暴击率
	-- self.critPer = self.fightAtt:getCritPer() --暴击比列1.5倍伤害

	-- self.atkAirRate =self.fightAtt:getAtkAirRate() --对空攻击加成比率
	-- self.atkLandRate =self.fightAtt:getAtkLandRate() --对地攻击加成比率
	-- self.atkRate =self.fightAtt:getAtkRate() --攻击加成比率(增加百分比)/？？？？
	-- self.defRate =self.fightAtt:getDefRate() --防御加成比率
	-- self.breakRate = self.fightAtt:getBreakRate() --破甲加成比率
	-- self.hurtRate = self.fightAtt:getHurtRate() --伤害加成比率(增加百分比)一般是1以上
	-- self.disHurtRate = self.fightAtt:getDisHurtRate() --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
	-- self.bloodRate = self.fightAtt:getBloodRate() --治疗加成比率