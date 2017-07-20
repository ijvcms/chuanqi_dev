--
-- Author: 21102585@qq.com
-- Date: 2014-12-16 14:49:41
-- 角色基础战斗属性VO
--率都是按照万分来算

RoleBaseAttVO = RoleBaseAttVO or class("RoleVO")
function RoleBaseAttVO:ctor()
	--基础属性，装备+成长	
	self.bEnergy = 0--能量加成值
	self.bArmor = 0--护甲加成值
	self.bAtkAir =0 --对空攻击加成值
	self.bAtkLand =0 --对地攻击加成值
	self.bAtk =0 --攻击加成值（所有攻击） ？？？？
	self.bDef =0 --防御加成值
	self.bBreaks = 0 --破甲加成值
	self.bHurt = 0 --伤害加成值
	self.bDisHurt = 0 --免伤加成值
	self.bBlood = 0 --治疗加成值

	self.bHit = 0--命中率加成值
	self.bDodge = 0--闪避率加成值
	self.bCrit = 0 --暴击率加成值 0表示没有暴击
	self.bCritPer = 0 --暴击比列如15000表示1.5倍伤害

	self.bAtkAirRate =0 --对空攻击加成比率
	self.bAtkLandRate =0 --对地攻击加成比率
	self.bAtkRate =0 --攻击加成比率(增加百分比)/？？？？
	self.bDefRate =0 --防御加成比率
	self.bBreakRate = 0 --破甲加成比率
	self.bHurtRate = 0 --伤害加成比率(增加百分比)一般是1以上
	self.bDisHurtRate = 0 --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
	self.bBloodRate = 1 --治疗加成比率
	self.bAtkSpeed = 0  --攻击速度加成比率	
	
	--被动技能特殊的东西
	--克制功能
	self.bTerran = 0 --对人族克制值
	self.bProtoss = 0 --对神族克制值
	self.bZerg = 0 --对虫族克制值
	self.bMecha = 0 --对机甲克制值
	self.bBiology = 0 --对生物克制值
	self.bGhost = 0 --对幽灵克制值

	self.bTerranRate = 0 --对人族克制率	
	self.bProtossRate = 0 --对神族克制率	
	self.bZergRate = 0 --对虫族克制率	
	self.bMechaRate = 0 --对机甲克制率	
	self.bBiologyRate = 0 --对生物克制率	
	self.bGhostRate = 0 --对幽灵克制率	
	
	--基础属性END	

	--技能	
	self.sEnergy = 0--能量加成值
	self.sArmor = 0--护甲加成值
	self.sAtkAir =0 --对空攻击加成值
	self.sAtkLand =0 --对地攻击加成值
	self.sAtk =0 --攻击加成值（所有攻击） ？？？？
	self.sDef =0 --防御加成值
	self.sBreaks = 0 --破甲加成值
	self.sHurt = 0 --伤害加成值
	self.sDisHurt = 0 --免伤加成值
	self.sBlood = 0 --治疗加成值

	self.sHit = 0--命中率加成值 -----------------------10000
	self.sDodge = 0--闪避率加成值
	self.sCrit = 0 --暴击率加成值 0表示没有暴击
	self.sCritPer = 0 --暴击比列如15000表示1.5倍伤害

	self.sAtkAirRate =0 --对空攻击加成比率
	self.sAtkLandRate =0 --对地攻击加成比率
	self.sAtkRate =0 --攻击加成比率(增加百分比)/？？？？
	self.sDefRate =0 --防御加成比率
	self.sBreakRate = 0 --破甲加成比率
	self.sHurtRate = 0 --伤害加成比率(增加百分比)一般是1以上
	self.sDisHurtRate = 0 --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
	self.sBloodRate = 0 --治疗加成比率
	self.sAtkSpeed = 0  --攻击速度加成比率
	--技能END

	--BUFF属性
	self.buffEnergy = 0--能量加成值
	self.buffArmor = 0--护甲加成值
	self.buffAtkAir =0 --对空攻击加成值
	self.buffAtkLand =0 --对地攻击加成值
	self.buffAtk =0 --攻击加成值（所有攻击） ？？？？
	self.buffDef =0 --防御加成值
	self.buffBreaks = 0 --破甲加成值
	self.buffHurt = 0 --伤害加成值
	self.buffDisHurt = 0 --免伤加成值
	self.buffBlood = 0 --治疗加成值

	self.buffHit = 0--命中率加成值
	self.buffDodge = 0--闪避率加成值
	self.buffCrit = 0 --暴击率加成值 0表示没有暴击
	self.buffCritPer = 0 --暴击比列如15000表示1.5倍伤害

	self.buffAtkAirRate =0 --对空攻击加成比率
	self.buffAtkLandRate =0 --对地攻击加成比率
	self.buffAtkRate =0 --攻击加成比率(增加百分比)/？？？？
	self.buffDefRate =0 --防御加成比率
	self.buffBreakRate = 0 --破甲加成比率
	self.buffHurtRate = 0 --伤害加成比率(增加百分比)一般是1以上
	self.buffDisHurtRate = 0 --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
	self.buffBloodRate = 0 --治疗加成比率
	self.buffAtkSpeed = 0  --攻击速度加成比率	
	--BUFF属性END
	self.buffDizzy = 0 --晕 受到此状态则无法执行任何行动，包括移动与施放技能
	self.buffIce = 0 --冰住  受到此状态则无法执行任何行动，包括移动与施放技能
	self.buffSleep = 0 --睡住
	self.buffInvisible = 0 --隐身  则敌方目标无法作为目标选中拥有该状态的单位
	self.buffUnmatched = 0 --无敌  受到的所有伤害均变为1（包含BUFF带来的持续伤害）
	self.buffSilence = 0 --沉默   无法施放技能
	self.buffNotMove = 0 --禁止移动  无法进行移动
	self.buffVampire = 0 --吸血  造成的伤害均会等量治疗自己
	self.buffControl = 0 --控制  伤害自己单位
	self.buffSame = 0	--黑蜂  只能攻击这个状态的敌人


	self.buffHp = 0
	self.buffHpRate = 0


	self.buffListKey = {}
	--Buff列表
	self.buffList = {} --buff列表  --记录身上所有的Buff
	self.buffTypeDic={} --记录当前身上buff类型的数量

end	

function RoleBaseAttVO:destory()
	for _,v in pairs(self.buffList) do
		FightSkillManager:deleteBuff(v)
		-- self.buffList[v.id] = nil
		-- self.buffListKey[v.bId] = nil
	end
	self.buffList = {}
	self.buffListKey = {}
	self.buffTypeDic={}
	self:updateBuff()
end

--是否存在某个技能
function RoleBaseAttVO:hasBuff(bId)
	if self.buffListKey[bId] then
		return true
	end	
	return false
end	
--添加BUff数值
function RoleBaseAttVO:addBuff(buff)
	self.buffList[buff.id] = buff
	self.buffListKey[buff.bId] = buff.id
	if self.buffTypeDic[buff.bType] == nil then
		self.buffTypeDic[buff.bType] = 1
	else
		self.buffTypeDic[buff.bType] = self.buffTypeDic[buff.bType] +1	
	end	
	self:updateBuff()
end

--删除Buff数值
function RoleBaseAttVO:delectBuff(buff)
	self.buffListKey[buff.bId] = nil
	self.buffList[buff.id] = nil

	if self.buffTypeDic[buff.bType] == nil then		
		self.buffTypeDic[buff.bType] = self.buffTypeDic[buff.bType] -1
	end	
	self:updateBuff()
end

--更新Buff值
function RoleBaseAttVO:updateBuff()
	self.buffEnergy = 0--能量加成值
	self.buffArmor = 0--护甲加成值
	self.buffAtkAir =0 --对空攻击加成值
	self.buffAtkLand =0 --对地攻击加成值
	self.buffAtk =0 --攻击加成值（所有攻击） ？？？？
	self.buffDef =0 --防御加成值
	self.buffBreaks = 0 --破甲加成值
	self.buffHurt = 0 --伤害加成值
	self.buffDisHurt = 0 --免伤加成值
	self.buffBlood = 0 --治疗加成值

	self.buffHit = 0--命中率加成值
	self.buffDodge = 0--闪避率加成值
	self.buffCrit = 0 --暴击率加成值 0表示没有暴击
	self.buffCritPer = 0 --暴击比列如15000表示1.5倍伤害

	self.buffAtkAirRate =0 --对空攻击加成比率
	self.buffAtkLandRate =0 --对地攻击加成比率
	self.buffAtkRate =0 --攻击加成比率(增加百分比)/？？？？
	self.buffDefRate =0 --防御加成比率
	self.buffBreakRate = 0 --破甲加成比率
	self.buffHurtRate = 0 --伤害加成比率(增加百分比)一般是1以上
	self.buffDisHurtRate = 0 --免伤加成比率(减少百分比)0表示不免伤 1表示全部免伤
	self.buffBloodRate = 0 --治疗加成比率
	self.buffAtkSpeed = 0  --攻击速度加成比率	
	--特殊技能
	self.buffDizzy = 0 --晕 受到此状态则无法执行任何行动，包括移动与施放技能
	self.buffIce = 0 --冰住  受到此状态则无法执行任何行动，包括移动与施放技能
	self.buffSleep = 0 --睡住
	self.buffInvisible = 0 --隐身  则敌方目标无法作为目标选中拥有该状态的单位
	self.buffUnmatched = 0 --无敌  受到的所有伤害均变为1（包含BUFF带来的持续伤害）
	self.buffSilence = 0 --沉默   无法施放技能
	self.buffNotMove = 0 --禁止移动  无法进行移动
	self.buffVampire = 0 --吸血  造成的伤害均会等量治疗自己
	self.buffControl = 0 --控制  伤害自己单位
	self.buffSame = 0	--黑蜂  只能攻击这个状态的敌人


	self.buffHp = 0
	self.buffHpRate = 0

	local key
	for k,v in pairs(self.buffList) do
		key = v.buffAtt		
		self[key] = self[key]+v.buffValue
	end	
end		
	

function RoleBaseAttVO:getEnergy()
	return self.buffEnergy + self.sEnergy + self.bEnergy
end
function RoleBaseAttVO:getArmor()
	return self.buffArmor + self.sArmor + self.bArmor
end	
function RoleBaseAttVO:getAtkAir()
	return self.buffAtkAir + self.sAtkAir + self.bAtkAir
end
function RoleBaseAttVO:getAtkLand()
	return self.buffAtkLand + self.sAtkLand + self.bAtkLand
end
function RoleBaseAttVO:getAtk()
	return self.buffAtk + self.sAtk + self.bAtk
end
function RoleBaseAttVO:getDef()
	return self.buffDef + self.sDef + self.bDef
end
function RoleBaseAttVO:getBreaks()
	return self.buffBreaks + self.sBreaks + self.bBreaks
end
function RoleBaseAttVO:getHurt()
	return self.buffHurt  + self.bHurt ----不要加上技能的
end
function RoleBaseAttVO:getDisHurt()
	return self.buffDisHurt + self.bDisHurt --不要加上技能的
end
function RoleBaseAttVO:getBlood()
	return self.buffBlood  + self.bBlood  --不要加上技能的
end
function RoleBaseAttVO:getHit()
	return (self.buffHit + self.sHit + self.bHit)
end
function RoleBaseAttVO:getDodge()
	return (self.buffDodge + self.sDodge + self.bDodge)
end
function RoleBaseAttVO:getCrit()
	return (self.buffCrit + self.sCrit + self.bCrit)
end

function RoleBaseAttVO:getCritPer()
	return (self.buffCritPer + self.sCritPer + self.bCritPer)/10000
end
function RoleBaseAttVO:getAtkAirRate()
	return (self.buffAtkAirRate + self.sAtkAirRate + self.bAtkAirRate)/10000
end
function RoleBaseAttVO:getAtkLandRate()
	return (self.buffAtkLandRate + self.sAtkLandRate + self.bAtkLandRate)/10000
end
function RoleBaseAttVO:getAtkRate()
	return (self.buffAtkRate + self.sAtkRate + self.bAtkRate)/10000
end
function RoleBaseAttVO:getDefRate()
	return (self.buffDefRate + self.sDefRate + self.bDefRate)/10000
end
function RoleBaseAttVO:getBreakRate()
	return (self.buffBreakRate + self.sBreakRate + self.bBreakRate)/10000
end
function RoleBaseAttVO:getHurtRate()
	return (self.buffHurtRate  + self.bHurtRate)/10000 --不要加上技能的
end
function RoleBaseAttVO:getDisHurtRate()
	return (self.buffDisHurtRate + self.bDisHurtRate)/10000 --不要加上技能的
end
function RoleBaseAttVO:getBloodRate()
	return (self.buffBloodRate  + self.bBloodRate)/10000 --不要加上技能的
end
function RoleBaseAttVO:getAtkSpeed()
	return (self.buffAtkSpeed  + self.sAtkSpeed + self.bAtkSpeed)/10000 --不要加上技能的
end






