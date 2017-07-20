--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 22:52:07
--
RoleUseSkillVO = RoleUseSkillVO or class("RoleUseSkillVO")

function RoleUseSkillVO:ctor()
	self.id = 0            --技能ID
	self.lv = 1
	self.skillID = 0       --技能ID
	self.resID = 0         --资源ID
	self.cd = 1000/1000    --cd时间
	self.mp = 0            --需要的魔法
	self.start = 0         --cd开始时间
	self.endTime = 0       --cd结束时间
	self.precent = 1     --cd百分比

	self.autoType = 0

	self.fightUseType = 1    --技能在战斗中使用类型 1表示直接使用技能，2表示需要选择然后选择位置
	self.skillUnLockCD = true --技能在战斗中是否攻击解锁
	self.fightIsSelect = false  --战斗中是否被选择

	self.posKey = 0
	
	self.skillConfig = nil --请参考skillConfig配置文件
end

function RoleUseSkillVO:init(data)
	if self.skillID == 20300 then
		self.fightUseType = 2
	end
	self.precent = 1
	self.skillUnLockCD = true
end

--设置战斗中是否可用
function RoleUseSkillVO:setSkillLock()
	self.skillUnLockCD = false
	self.start = socket.gettime()
	self.precent = 1
	if self.fightUseType ~= 2 then
		
	else
		RoleManager:getInstance():clearFightSelectSkill(self.skillID)
	end
end

function RoleUseSkillVO:getSkillLock()
 
	return self.skillUnLockCD
end

--是否选中
function RoleUseSkillVO:isOnlySelSkill()
	return (self.fightUseType == 2)
end

--是否选中
function RoleUseSkillVO:setSkillIsSelect()
	if self.fightUseType == 2 then
		self.fightIsSelect = (self.fightIsSelect == false)
	end
end
--获取是否选中
function RoleUseSkillVO:getSkillIsSelect(b)
	return self.fightIsSelect
end

function RoleUseSkillVO:update()
	if self.skillUnLockCD == false then
		self.precent = (socket.gettime() - self.start)/self.cd
		if self.precent >= 1 then
			self.skillUnLockCD = true
		end
	end
end