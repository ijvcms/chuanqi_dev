--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-08-28 14:31:03
-- 场景角色Buff

SceneRoleBuffVO = SceneRoleBuffVO or class("SceneRoleBuffVO")

function SceneRoleBuffVO:ctor(data,buff)	
	self.buff = buff
	self.buffId = data.buffId

	self.buffAtt = data.buffAtt --Buff对应的属性Key
	self.buffValue = data.buffValue --buff属性对应的值
	self.buffEffId = data.buffEffId --Buff效果资源ID
	
	self.bType = data.bType --buff类型 1-加属性，2-气血相关，3-控制类
	self.subType = data.subType --控制技能只能是1-9中间，其他的都是三位数，前两位表示类型，后一位表示是Buff（0）还是debuff（1）

	self.repel = data.repel --buff排斥类型 0表示不排斥任何类型
	self.dispel = data.dispel --是否可以驱散 0否1可以	
	-- self.hit = configTab[1] --命中率  (扩展)

	self.duration = data.duration or 0 --持续时间 单位毫秒
	self.cycle = data.cycle or 0 --周期  单位毫秒，只有气血类用得上

	self.beginTime = data.beginTime or FightModel:getFTime() --开始时间  为了暂停功能这里只能用战斗时间来计算
	self.lastTime = self.beginTime --上一次执行时间
	
	self.targetId = data.targetId or 0 --执行的目标ID
	self.targetType = data.targetType or 0 --执行的目标ID
	self.effect = nil --显示的效果，可以是动画也可以是图片
end	

--更新Buff
function SceneRoleBuffVO:update(curTime)
	if curTime >= self.beginTime + self.duration then
		local role = GlobalController.fight:getRoleModel(self.targetId,self.targetType)
		if role then
			-- role:clearBuffEffectByID(self.buffEffId)
			-- role.vo:buffDic[self.buffId] = nil
			--self.buffEffId
			GlobalController.model:push(role, "clearBuff", self.buffId, self.buff)
			--role:clearBuff(self.buffId,self.buff)
		end
	end	
end




-- --销毁Buff
-- function BuffVO:destory()
-- 	FightSkillManager:deleteBuff(self)
-- end