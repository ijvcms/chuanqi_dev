--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-15 17:14:38
-- 沙巴克
require("app.modules.shabake.model.ShaBaKeModel")
require("app.modules.shabake.model.ShaBaKeAppointModel")
ShaBaKeController = ShaBaKeController or class("ShaBaKeController",BaseController)

function ShaBaKeController:ctor()
	self.roleManager = RoleManager:getInstance()
	ShaBaKeModel:ctor()
	ShaBaKeAppointModel:ctor()
	self:registerProto()
end


function ShaBaKeController:registerProto()
	self:registerProtocal(25000, handler(self, self.onHandle25000))
	self:registerProtocal(25001, handler(self, self.onHandle25001))
	self:registerProtocal(25002, handler(self, self.onHandle25002))
	self:registerProtocal(25003, handler(self, self.onHandle25003))
	self:registerProtocal(25004, handler(self, self.onHandle25004))
	self:registerProtocal(25005, handler(self, self.onHandle25005))
	self:registerProtocal(25006, handler(self, self.onHandle25006))
	self:registerProtocal(25007, handler(self, self.onHandle25007))
	self:registerProtocal(25008, handler(self, self.onHandle25008))
end

function ShaBaKeController:onHandle25000(data)
	print("ShaBaKeController:onHandle25000")
	if data ~= nil then
		ShaBaKeAppointModel:setData(data)
		ShaBaKeAppointModel.officer_id = ShaBaKeModel.officer_id
	end
	GlobalEventSystem:dispatchEvent(ShaBaKeEvent.SBK_OFFICIAL_INFO, {ShaBaKeAppointModel})
end

function ShaBaKeController:onHandle25001(data)
	print("ShaBaKeController:onHandle25001")
	dump(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
	
end

function ShaBaKeController:onHandle25002(data)
	print("ShaBaKeController:onHandle25002")
	dump(data)
 	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end


function ShaBaKeController:onHandle25003(data)
	--[[
		<Packet proto="25003" type="s2c" name="rep_city_reward_info" describe="获取领取界面的奖励信息">
			<Param name="officer_id" type="int32" describe="领取的档次奖励信息 officer_id 官员id"/>
			<Param name="isday" type="int8" describe="是否可以领取每日奖励 1，不能领取， 0可以领取"/>
			<Param name="frist_guild_name" type="string" describe="第一次领取的帮派名称"/>
			<Param name="isfrist" type="int8" describe="是否可以领取 第一次奖励 1，不能领取， 0可以领取"/>
			<Param name="title_player_name" type="string" describe="获取称号的帮主名称"/>
		</Packet>
	]]
	GlobalEventSystem:dispatchEvent(ShaBaKeEvent.SBK_REWARDS_INFO, {data = data})
end

function ShaBaKeController:onHandle25004(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	else
		-- 领取之后重新请求获取数据。
		GameNet:sendMsgToSocket(25003)
	end
end

function ShaBaKeController:onHandle25005(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	else
		-- 领取之后重新请求获取数据。
		GameNet:sendMsgToSocket(25003)
	end
end

-- ShaBaKeModel:ctor()
-- 	self.honorRoleList = {}
-- 	self.occupyGuildName = "帮会名称"
-- 	self.occupyDays = 5
-- 	self.nextTimeNum = os.time()+10000
-- 	self.nextDate = "12月13日"
-- 	self.nextTime = "09:09"
-- end

function ShaBaKeController:onHandle25006(data)
	dump(data)
	if data then
		ShaBaKeModel.occupyGuildName = data.guild_name
		ShaBaKeModel.occupyDays = data.occupy_day
		ShaBaKeModel.nextTimeNum = tonumber(data.next_open_time)
		ShaBaKeModel.honorRoleList = {}
		ShaBaKeModel.officer_id = data.officer_id
		for i=1,#data.city_officer_list do
			local vo = data.city_officer_list[i]
			table.insert(ShaBaKeModel.honorRoleList,{sex = vo.sex,career = vo.career,clothes = vo.guise.clothes,wing = vo.guise.wing,weapon = vo.guise.weapon,id= vo.tplayer_id,name = vo.tname,officeId = vo.officer_id})
		end
	end

	GlobalEventSystem:dispatchEvent(ShaBaKeEvent.UPDATE_HONOR_LIST,{})
	-- if data.result == 0 then 
	-- 	local item
	-- 	self.roleManager.skillDic = {}
	-- 	local careerSkillList = self.roleManager.carrerSkill
	-- 	for i=1,#careerSkillList do
	-- 		item = data.skill_list[i]
	-- 		local skillVO = SkillVO.new()
	-- 		skillVO.id = careerSkillList[i]
	-- 		self.roleManager.skillDic[skillVO.id] = skillVO
	-- 		skillVO:init()
	-- 	end
	-- 	for i=1,#data.skill_list do
	-- 		item = data.skill_list[i]
	-- 		local skillVO = self.roleManager.skillDic[item.skill_id]
	-- 		skillVO.id = item.skill_id
	-- 		skillVO.lv = item.lv
	-- 		skillVO.posKey = item.pos
	-- 		skillVO.autoSet = item.auto_set
	-- 		skillVO:init()
	-- 	end
	-- 	--dump(self.roleManager.skillDic)
	-- 	self.roleManager:updateSkill()
	-- 	if GlobalController:getScene() ~= SCENE_MAIN then
	-- 		GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_MAIN)
	-- 	end
	-- end
end

function ShaBaKeController:onHandle25007(data)
	print("ShaBaKeController:onHandle25007")
	GlobalEventSystem:dispatchEvent(ShaBaKeEvent.SBK_OFFICIAL_UDATAELEFT, {data})
end

function ShaBaKeController:onHandle25008(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	else
		-- 领取之后重新请求获取数据。
		GameNet:sendMsgToSocket(25003)
	end
end