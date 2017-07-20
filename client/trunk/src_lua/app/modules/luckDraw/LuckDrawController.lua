--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 幸运抽奖控制器
LuckDrawController = LuckDrawController or class("LuckDrawController",BaseController)

function LuckDrawController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function LuckDrawController:registerProto()
	self:registerProtocal(36000,handler(self,self.onHandle36000))
	self:registerProtocal(36001,handler(self,self.onHandle36001))
	self:registerProtocal(36002,handler(self,self.onHandle36002))
	self:registerProtocal(36003,handler(self,self.onHandle36003))
end

function LuckDrawController:onHandle36000(data)
	--dump(data.log_lists)
	if data.log_lists then
		local loglist= {}
		--倒序
		for i=#data.log_lists,1,-1 do
			table.insert(loglist,data.log_lists[i])
		end
		GlobalEventSystem:dispatchEvent(LuckDrawEvent.LUCKDRAW_TIP_UPDATE,  {list = loglist,isLate = 0})
		-- <Param name="id" type="int64" describe="日志id"/>
		-- <Param name="name" type="string" describe="领取玩家的名称"/>
		-- <Param name="lottery_id" type="int32" describe="抽奖id"/>
	end
end

function LuckDrawController:onHandle36002(data)
	--dump(data.log_lists)
	if data.log_lists then
		local item
		for i=1,#data.log_lists do
			
		end
		GlobalEventSystem:dispatchEvent(LuckDrawEvent.LUCKDRAW_TIP_UPDATE, {list = data.log_lists,isLate = 1})
		-- <Param name="id" type="int64" describe="日志id"/>
		-- <Param name="name" type="string" describe="领取玩家的名称"/>
		-- <Param name="lottery_id" type="int32" describe="抽奖id"/>
	end
end

function LuckDrawController:onHandle36001(data)
	--dump(data)
	if data.result == 0 then 
		local item
		local data = {idList = data.lottery_id_list,goods_info = data.goods_list,equips_info = data.equip_list}
		GlobalEventSystem:dispatchEvent(LuckDrawEvent.LUCKDRAW_GET, data)
	end
end


-- function LuckDrawController:onHandle35003(data)
-- 	if data.result == 0 then 
-- 		local item
-- 		local careerSkillList = self.roleManager.carrerSkill
-- 		for i=1,#careerSkillList do
-- 			item = data.skill_list[i]
-- 			local skillVO = SkillVO.new()
-- 			skillVO.id = careerSkillList[i]
-- 			self.roleManager.skillDic[skillVO.id] = skillVO
-- 			skillVO:init()
-- 		end
-- 	end
-- end

