--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-22 17:36:09
-- 角色管理器

RoleManager = RoleManager or class("RoleManager",BaseManager)

local RoleCareerTypes = require("app.modules.role.vo.RoleCareerTypes")

function RoleManager:ctor()	
	RoleManager.Instance=self
	self.roleInfo = RoleInfoVO.new()	--主角相关信息
	self.wealth = RoleWealthVO.new()
	self.guildInfo = RoleGuildInfoVO.new()
	self.corpsInfo = RoleCorpsInfoVO.new()

	self.skillDic = {}  --技能字典 SkillVO

	self.fightSkillBaseList = {}    --战斗中技能基础列表 RoleUseSkillVO
	self.useSkillList = {}
	self.nextUseSkillID = nil      -- 手动点击下一个技能
	self.nextUseSkillLV = nil      -- 手动点击下一个技能级别
	self.nextUseSkillPoint = nil   -- 手动点击下一个技能释放点，如果需要的话

	self.autoSkill = {}   --自动释放技能 RoleUseSkillVO
	self.singleSkill = {} --单攻 RoleUseSkillVO
	self.groupSkill = {}  --群攻 RoleUseSkillVO

	self.carrerDefSkill = 0 --当前职业默认技能

	self.buffData = {}
end


--RoleManager:getInstance():getCanSetUnion() 
--GlobalController.fight:updateUnionStates()
--是否可以设置结盟
function RoleManager:getCanSetUnion(guildId)
	if guildId ~= "" and guildId ~= 0 and guildId ~= "0" and guildId ~= self.guildInfo.guild_id and (self.guildInfo.position == 1 or self.guildInfo.position == 2) then
		return true
	end
	if guildId ~= "" and guildId ~= self.guildInfo.guild_id and ((GameSceneModel.sceneId >= 32122 and GameSceneModel.sceneId <= 32125) or (GameSceneModel.sceneId >= 32109 and GameSceneModel.sceneId <= 32111) or(GameSceneModel.sceneId >= 31002 and GameSceneModel.sceneId <= 31004) or (GameSceneModel.sceneId >= 32104 and GameSceneModel.sceneId <= 32106)) and (self.guildInfo.position == 1 or self.guildInfo.position == 2)  then
		return true
	end
	return false
end

--获取结盟者信息
function RoleManager:getUnionGuildInfo(guildId)
	return self.guildInfo.unionInfo[guildId]
end

--获取是否结盟
function RoleManager:getHasUnion(guildId)
	if self.guildInfo.union[guildId]  then
		return true
	end
	if self.guildInfo.union[guildId] and ((GameSceneModel.sceneId >= 32122 and GameSceneModel.sceneId <= 32125) or (GameSceneModel.sceneId >= 32109 and GameSceneModel.sceneId <= 32111) or (GameSceneModel.sceneId >= 31002 and GameSceneModel.sceneId <= 31004) or (GameSceneModel.sceneId >= 32104 and GameSceneModel.sceneId <= 32106)) then
		return true
	end
	return false
end

--是否跨服
function RoleManager:isInterServer()
	if (GameSceneModel.sceneId >= 32122 and GameSceneModel.sceneId <= 32125) or (GameSceneModel.sceneId >= 32109 and GameSceneModel.sceneId <= 32111) or (GameSceneModel.sceneId >= 31002 and GameSceneModel.sceneId <= 31004) or (GameSceneModel.sceneId >= 32104 and GameSceneModel.sceneId <= 32106) then
		return true
	end
	return false
end

function RoleManager:getRoleUseSkillVO(skillId)
	return self.fightSkillBaseList[skillId]
end

function RoleManager:getSkillEnableLearnById(bookId)
	for k,v in pairs(self.skillDic) do
		if v.isLearn == false and v.conf.bookId == bookId then
			return true
		end
	end
	return false
end

function RoleManager:updateSkill(skillId)
	if skillId == nil then
		self.useSkillList = {}
		self.singleSkill ={}
		self.groupSkill = {}
		self.autoSkill ={}
		for k,v in pairs(self.skillDic) do
			if v.lv > 0 then
				local fightSkillVO = self.fightSkillBaseList[v.id]
				local skillConf = FightModel:getSkillConfig(v.id,v.lv)
				fightSkillVO.mp = skillConf.costMp
				fightSkillVO.cd = skillConf.cd/1000
				fightSkillVO.posKey = v.posKey
				fightSkillVO.lv = v.lv
				fightSkillVO.autoType = v.conf.autoType
				fightSkillVO.skillConfig = skillConf

				if  v.posKey > 0 then
					table.insert(self.useSkillList,fightSkillVO)
				end
				if v.conf.autoType == 1 and v.autoSet == 1 then --自动单攻
					table.insert(self.singleSkill,fightSkillVO)
				elseif v.conf.autoType == 2 and v.autoSet == 1 then --自动群攻
					table.insert(self.groupSkill,fightSkillVO)
				elseif (v.conf.autoType == 3 or v.conf.autoType == 4) and v.autoSet == 1 then --自动释放技能
					table.insert(self.autoSkill,fightSkillVO)
				end
			end
		end
	else

		local skillVO = self.skillDic[skillId]
		local sceneSkillVO = self.fightSkillBaseList[skillId]
		
		if skillVO and sceneSkillVO then
			sceneSkillVO.posKey = skillVO.posKey
			sceneSkillVO.autoType = skillVO.conf.autoType
			if skillVO.lv ~= sceneSkillVO.lv then
				local skillConf = FightModel:getSkillConfig(skillVO.id,skillVO.lv)
				sceneSkillVO.mp = skillConf.costMp
				sceneSkillVO.cd = skillConf.cd/1000
				sceneSkillVO.skillConfig = skillConf
			end

			self.useSkillList = {}
			self.singleSkill ={}
			self.groupSkill = {}
			self.autoSkill ={}
			for k,v in pairs(self.skillDic) do
				if v.lv > 0 then
					local fightSkillVO = self.fightSkillBaseList[v.id]

					if  v.posKey > 0 then
						table.insert(self.useSkillList,fightSkillVO)
					end
					if v.conf.autoType == 1 and v.autoSet == 1 then --自动单攻
						table.insert(self.singleSkill,fightSkillVO)
					elseif v.conf.autoType == 2 and v.autoSet == 1 then --自动群攻
						table.insert(self.groupSkill,fightSkillVO)
					elseif (v.conf.autoType == 3 or v.conf.autoType == 4) and v.autoSet == 1 then --自动释放技能
						table.insert(self.autoSkill,fightSkillVO)
					end
				end
			end

		end
	end
end



function RoleManager:init()
	self.carrerSkill2 = {}
	self.autoSkill2 = {}
	self.autoSkill = {}
	self.singleSkill2 = {}
	self.groupSkill2 = {}
	self.AISkillList2 = {}
	self.tempDic = {}
	for k,v in pairs(SkillTreeConf) do
		if v.career == self.roleInfo.career or v.career == RoleCareerTypes.AllJobs then
			if self.tempDic[v.id] == nil then
				self.tempDic[v.id] = true
				table.insert(self.carrerSkill2,v)
				if v.autoType >0 then
					table.insert(self.AISkillList2,v)
					if v.autoType == 1 then
						table.insert(self.singleSkill2,v)
					elseif v.autoType == 2 then
						table.insert(self.groupSkill2,v)
					elseif v.autoType == 3 or v.autoType == 4  then
						table.insert(self.autoSkill2,v)
					end
				end
			end
			if v.lv == 1 and v.bookId == 0 then
				self.carrerDefSkill = v.id
			end
		end
	end
	local onsortFun = function (a,b)
		if a.list < b.list then
			return true
		else
			return false
		end
	end
	table.sort(self.carrerSkill2, onsortFun)
	table.sort(self.AISkillList2, onsortFun)
	table.sort(self.autoSkill2, onsortFun)
	table.sort(self.singleSkill2, onsortFun)
	table.sort(self.groupSkill2, onsortFun)

	self.carrerSkill = {}
	for i=1,#self.carrerSkill2 do
		table.insert(self.carrerSkill,self.carrerSkill2[i].id)
	end
	self.AISkillList = {}
	for i=1,#self.AISkillList2 do
		table.insert(self.AISkillList,self.AISkillList2[i].id)
	end
	self.autoSkill = {}
	for i=1,#self.autoSkill2 do
		table.insert(self.autoSkill,self.autoSkill2[i].id)
	end
	self.singleSkill = {}
	for i=1,#self.singleSkill2 do
		table.insert(self.singleSkill,self.singleSkill2[i].id)
	end
	self.groupSkill = {}
	for i=1,#self.groupSkill2 do
		table.insert(self.groupSkill,self.groupSkill2[i].id)
	end

	self.carrerSkill2 = nil
	self.autoSkill2 = nil
	self.singleSkill2 = nil
	self.groupSkill2 = nil
	self.AISkillList2 = nil
	self.tempDic = nil

	-- self.carrerSkill = {
 --        [1000] = {10100,10200,10300,10400,10500,10600,10700,10800},
 --        [2000] = {20100,20200,20300,20400,20500,20600,20700,20800,20900,21000},
 --        [3000] = {30100,30200,30300,30400,30500,30600,30700,30800},
 --    }
	-- if self.roleInfo.career == RoleCareer.WARRIOR then
	-- 	self.autoSkill = {}              --自动释放技能
	-- 	self.singleSkill = {10200,10100} --单攻
	-- 	self.groupSkill = {10300,10400}  --群攻
	-- elseif self.roleInfo.career == RoleCareer.MAGE then
	-- 	self.autoSkill = {}              --自动释放技能
	-- 	self.singleSkill = {20100,20200} --单攻
	-- 	self.groupSkill = {20300,20800}  --群攻
	-- elseif self.roleInfo.career == RoleCareer.TAOIST then
	-- 	self.autoSkill = {30200}          --自动释放技能
	-- 	self.singleSkill = {30100}        --单攻
	-- 	self.groupSkill = {30300}         --群攻
	-- end
    
 --    --挂机场景技能
 --    self.AISkillList = {
 --        [1000] = {10300,10400,10600},--10200
 --        [2000] = {20200,20300,20400,20500,20600},--{20200,20300,20400,20500,20600},
 --        [3000] = {30200,30300,30500},--{30200,30300,30500},
 --    }

    local fightBaseSkillList  = self.carrerSkill
    for i=1,#fightBaseSkillList do
    	local skillConf = FightModel:getSkillConfig(fightBaseSkillList[i])
        local vo = RoleUseSkillVO.new()

        vo.id = fightBaseSkillList[i]
        vo.skillID = fightBaseSkillList[i]
        vo.resID = fightBaseSkillList[i]
        vo.cd = skillConf.cd/1000
        vo.lv = skillConf.lv
        vo.mp = skillConf.costMp

        vo.skillConfig = skillConf
        
        --table.insert(self.fightSkillBaseList,vo)
        self.fightSkillBaseList[fightBaseSkillList[i]] = vo
        vo:init()
    end
end

--获取技能数组 技能UI界面使用
function RoleManager:getSkillArr()
	local arr = {}
	for k,v in pairs(self.skillDic) do
		table.insert(arr,v)
	end
	table.sort(arr, function (a,b)
		if a.conf.list < b.conf.list then
			return true
		else
			return false
		end
	end)
	return arr
end

--获取技能数组,过滤掉全职业通用的技能(一般为一些不需要技能ui界面操作的技能)
function RoleManager:getSkillArrWithOutAllJobs()
	local arr = {}
	for k,vo in pairs(self.skillDic) do
		local isSkillAllJobUse = vo.conf.career == RoleCareerTypes.AllJobs
		if not isSkillAllJobUse then
			table.insert(arr,vo)
		end
	end
	table.sort(arr, function (a,b)
		if a.conf.list < b.conf.list then
			return true
		else
			return false
		end
	end)
	return arr
end


function RoleManager:getCarrerDefSkill()
	return self.carrerDefSkill
	-- if self.roleInfo.career == RoleCareer.WARRIOR then
	-- 	return 10100
	-- elseif self.roleInfo.career == RoleCareer.MAGE then
	-- 	return 20100
	-- elseif self.roleInfo.career == RoleCareer.TAOIST then
	-- 	return 30100
	-- end
	-- return 10100
end


--初始化技能列表
function RoleManager:initSkillList()
	for k,v in ipairs(self.useSkillList) do
		v.fightIsSelect = false
	end
	self.nextUseSkillID = nil
end

--获取战斗中玩家选中的需要释放的技能
function RoleManager:getFightSelectSkill()
	for k,v in ipairs(self.useSkillList) do
		if v.fightIsSelect then
			return v
		end
	end
end

--获取战斗使用技能是否释放for坐标点
function RoleManager:getFightSkillUseByPoint(skillid)
	local ret = false
	local useSkill = self:getFightUseSkill(skillid)
	if useSkill then
		return useSkill.fightUseType == 2
	end
	return false
end

--获取战斗使用技能VO
function RoleManager:getFightUseSkill(skillid)
	return self.fightSkillBaseList[skillid]
end
--清理其他选中的技能
function RoleManager:clearFightSelectSkill(skillid)
	for k,v in ipairs(self.useSkillList) do
		if v.skillID ~= skillid then
			v.fightIsSelect = false
		end
	end
end

--提供一个可以使用某技能的判断接口,要不然每次都要遍历useSkillList
function RoleManager:canUseSkillById(skillId)
	if not skillId then return false end
	local roleUseSkillVo = self.fightSkillBaseList[skillId]
	if not roleUseSkillVo then return false end
	return roleUseSkillVo.posKey > 0 and roleUseSkillVo.lv > 0
end

--获取PK模式
function RoleManager:getPKMode()
	return self.roleInfo.pkMode
end

function RoleManager:getInstance()
	if RoleManager.Instance==nil then
		RoleManager.new()
	end
	return RoleManager.Instance
end

function RoleManager:checkBuff(buff_id)
 
	if self.buffData == nil  or self.buffData.buff_list == nil or buff_id == nil then
		return false
	end
 	
	for i=1,#self.buffData.buff_list do
		if tonumber(buff_id) == tonumber(self.buffData.buff_list[i].buff_id) then
			return true
		end
	end

	return false

end
