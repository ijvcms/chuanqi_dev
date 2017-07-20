--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 幸运转盘控制器
LuckTurnPlateController = LuckTurnPlateController or class("LuckTurnPlateController",BaseController)

function LuckTurnPlateController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function LuckTurnPlateController:registerProto()
	self:registerProtocal(35000,handler(self,self.onHandle35000))
	self:registerProtocal(35001,handler(self,self.onHandle35001))
	self:registerProtocal(35002,handler(self,self.onHandle35002))
	self:registerProtocal(35003,handler(self,self.onHandle35003))
end

function LuckTurnPlateController:onHandle35000(data)
	if data.log_lists then
		local loglist= {}
		--倒序
		for i=#data.log_lists,1,-1 do
			table.insert(loglist,data.log_lists[i])
		end
		GlobalEventSystem:dispatchEvent(LuckTurnPlateEvent.TURNPLATE_TIP_INIT,  {list = data.lottery_goods_list,beginTime = data.begin_time,endTime = data.end_time,timesOne = data.num1_need_jade,timesTen = data.num10_need_jade})
		GlobalEventSystem:dispatchEvent(LuckTurnPlateEvent.TURNPLATE_TIP_UPDATE,  {list = loglist,isLate = 0})
		-- <Param name="id" type="int64" describe="日志id"/>
		-- <Param name="name" type="string" describe="领取玩家的名称"/>
		-- <Param name="lottery_id" type="int32" describe="抽奖id"/>
	end
end

function LuckTurnPlateController:onHandle35002(data)
	if data.log_lists then
		local item
		for i=1,#data.log_lists do
			
		end
		GlobalEventSystem:dispatchEvent(LuckTurnPlateEvent.TURNPLATE_TIP_UPDATE, {list = data.log_lists,isLate = 1})
		-- <Param name="id" type="int64" describe="日志id"/>
		-- <Param name="name" type="string" describe="领取玩家的名称"/>
		-- <Param name="lottery_id" type="int32" describe="抽奖id"/>
	end
end

function LuckTurnPlateController:onHandle35001(data)
	if data.result == 0 then 
		local item
		local data = {idList = data.lottery_id_list,goods_info = data.goods_list,equips_info = data.equip_list}
		GlobalEventSystem:dispatchEvent(LuckTurnPlateEvent.TURNPLATE_GET, data)
	end
end


-- function LuckTurnPlateController:onHandle35003(data)
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

