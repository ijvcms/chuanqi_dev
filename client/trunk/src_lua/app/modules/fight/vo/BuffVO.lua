--
-- Author: 21102585@qq.com
-- Date: 2014-12-18 17:56:36
-- BUFF效果 VO

BuffVO = BuffVO or class("BuffVO")
BuffID = 1

function BuffVO:ctor(configTab,targetId,curTime)	
	
	self.id = BuffID +1  --唯一ID
	BuffID = BuffID +1
	self.bId = configTab.bId --buff的Id
	self.buffAtt = configTab.buffAtt --Buff对应的属性Key
	self.buffValue = configTab.buffValue --buff属性对应的值
	self.buffRes = configTab.buffRes --Buff效果资源ID
	
	self.bType = configTab.bType --buff类型 1-加属性，2-气血相关，3-控制类
	self.subType = configTab.subType --控制技能只能是1-9中间，其他的都是三位数，前两位表示类型，后一位表示是Buff（0）还是debuff（1）

	self.repel = configTab.repel --buff排斥类型 0表示不排斥任何类型
	self.dispel = configTab.dispel --是否可以驱散 0否1可以	
	-- self.hit = configTab[1] --命中率  (扩展)

	self.duration = configTab.duration/1000 or 0 --持续时间 单位毫秒
	self.cycle = configTab.cycle/1000 or 0 --周期  单位毫秒，只有气血类用得上

	self.beginTime = curTime or FightModel:getFTime() --开始时间  为了暂停功能这里只能用战斗时间来计算
	self.lastTime = self.beginTime --上一次执行时间
	
	self.targetId = targetId or 0 --执行的目标ID

	self.effect = nil --显示的效果，可以是动画也可以是图片
end	

--更新Buff
function BuffVO:update(curTime)
	if self.cycle > 0 and curTime > self.lastTime+ self.cycle then
		--每隔多久执行一次 ，一般只有气血是这样的
		self.lastTime = curTime
		local targetView = GlobalController.fight:getRoleModel(self.targetId)
		if targetView then 
				
		else
			FightSkillManager:clearBuff(self)
			return
		end
	end
	if curTime >= self.beginTime + self.duration then
		FightSkillManager:clearBuff(self)	
	end	
end




-- --销毁Buff
-- function BuffVO:destory()
-- 	FightSkillManager:deleteBuff(self)
-- end