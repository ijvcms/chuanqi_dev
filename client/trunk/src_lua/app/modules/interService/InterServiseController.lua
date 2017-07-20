--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-04 15:33:41
-- 跨服战控制器
--
InterServiseController = InterServiseController or class("InterServiseController",BaseController)

function InterServiseController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function InterServiseController:registerProto()
	-- self:registerProtocal(36000,handler(self,self.onHandle36000))
	-- self:registerProtocal(36001,handler(self,self.onHandle36001))
	-- self:registerProtocal(36002,handler(self,self.onHandle36002))
	-- self:registerProtocal(36003,handler(self,self.onHandle36003))
end

function InterServiseController:onHandle36000(data)
	dump(data.log_lists)
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

function InterServiseController:onHandle36002(data)
	dump(data.log_lists)
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

function InterServiseController:onHandle36001(data)
	--dump(data)
	if data.result == 0 then 
		local item
		local data = {idList = data.lottery_id_list,goods_info = data.goods_list,equips_info = data.equip_list}
		GlobalEventSystem:dispatchEvent(LuckDrawEvent.LUCKDRAW_GET, data)
	end
end