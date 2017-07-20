--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-27 22:40:06
-- 场景角色VO
SceneRoleVO = SceneRoleVO or class("SceneRoleVO")

RoleCareer = {
	WARRIOR = 1000, --战士
	MAGE = 2000, --法师
	TAOIST = 3000,--道士
}

SkillPrior = {
	[10800] = 2,--战士逐日
	[10500] = 1,--战士烈火
	[20400] = 2,--法师摩法盾
	[20300] = 1,--法师火墙

	[30600] = 4,--道士神兽
	[30800] = 4,--道士骷髅
	[30200] = 3,--道士治疗
	[30500] = 2,--道士防御
	[30300] = 1,--道士毒
}


function SceneRoleVO:getRoleModelID(clothes,sex)

	-- if true then return sex.."10" end

	-- if true then return tostring(110) end
	
	if clothes == "" or clothes == 0 then
		return sex.."10"
	end
	if clothes == 101 then
		clothes = 102
	end
	return sex..clothes
end

--获取武器ID男的是3，
function SceneRoleVO:getRoleWeaponID(weapon,sex)
	-- if true then return (sex+2).."10" end
	-- if true then return tostring(111) end
	if weapon == "" or weapon == 0 then
		return 0
	end
	return (sex+2)..weapon
	--return (sex+2).."10"
end


function SceneRoleVO:updateBaseInfo()
	if self.career == RoleCareer.WARRIOR then
		self.modelID = self:getRoleModelID(self.clothes,self.sex)--"1103"
		self.weapon = self:getRoleWeaponID(self.weapon,self.sex)--"2101"
		self.skillAIList = RoleManager:getInstance().AISkillList
		self.defaultSkill = 10100
	elseif self.career == RoleCareer.MAGE then
		self.modelID = self:getRoleModelID(self.clothes,self.sex)--"1203"
		self.weapon = self:getRoleWeaponID(self.weapon,self.sex)--"2201"
		self.skillAIList = RoleManager:getInstance().AISkillList
		self.defaultSkill = 20100
	elseif self.career == RoleCareer.TAOIST then
		self.modelID = self:getRoleModelID(self.clothes,self.sex)--"1303"
		self.weapon = self:getRoleWeaponID(self.weapon,self.sex)--"2301"
		self.skillAIList = RoleManager:getInstance().AISkillList
		self.defaultSkill = 30100
	end
	self.modelActSpeed = configHelper:getModelActionSpeed(self.career)

	if conditions then
		--todo
	end
	if self.monster_id ~= 0 then
		self.mConf = getConfigObject(self.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
		self.modelID = self.mConf.resId
		if self.name == "" then
			self.name = self.mConf.name
		end
		self.lv = self.mConf.lv
		-- self.atk = mConf.atk
		-- self.hp = mConf.hp
		-- self.def = mConf.def
		-- self.mp = mConf.mp
		-- self.defaultSkill = mConf.skillId 
		self.defaultSkill = self.mConf.hookSkill[1]
	end
	-- self.totalhp = self.hp
	-- self.hp_limit = self.hp
	if self.type == 2 then
		self.speed = 5
	end

	if GameSceneModel.curSceneHideName == true then
		if self.type == SceneRoleType.PLAYER then
			if self.sex == RoleSex.MAN then
				if self.career == RoleCareer.WARRIOR then
					self.modelID = "1104"
					self.weapon = "3102"
				elseif self.career == RoleCareer.MAGE then
					self.modelID = "1204"
					self.weapon = "3204"
				elseif self.career == RoleCareer.TAOIST then
					self.modelID = "1304"
					self.weapon = "3313"
				end
			else
				if self.career == RoleCareer.WARRIOR then
					self.modelID = "2104"
					self.weapon = "3102"
				elseif self.career == RoleCareer.MAGE then
					self.modelID = "2204"
					self.weapon = "3204"
				elseif self.career == RoleCareer.TAOIST then
					self.modelID = "2304"
					self.weapon = "3313"
				end
			end
			self.wing = ""

			if self.id ~= GlobalModel.player_id then
				self.name = "神秘人"
			end
		elseif self.type == SceneRoleType.PET or self.type == SceneRoleType.BABY then
			if self.ownerId ~= GlobalModel.player_id then
				self.name = "神秘人宠物"
			end
		end
	end
end


function SceneRoleVO:ctor()
	self.id = 10003  --唯一id
	self.type = SceneRoleType.PLAYER --场景角色类型
	self.ownerId = 0
	self.parentId = 0
	self.direction = 1 --模型方向
	self.name = ""
	self.sex = RoleSex.MAN
	self.career = 0
	self.lv = 1
	self.hp = 100 --当前气血
	self.hp_limit = 1000
	self.totalhp = self.hp_limit --总气血
	self.mp = 100
	self.mp_limit = 1000

	self.weapon = ""
	self.clothes = "10"
	self.wing = 0  --翅膀外观ID
	self.pet = 0   --宠物外观ID
	self.mounts = 0 --坐骑
	self.rideHalo = 0

	self.mGrid = nil    --当前所在地图格子cc.p(x,y) or {x= 1,y = 1}
	self.pos = nil 		--当前位置cc.p(x,y),实际位置
	self.movePos = nil 	-- 移动位置cc.p(x,y),实际位置
	
	self.monster_id = 0 --怪物模板id，用来读取怪物的属性
	self.mConf = nil --怪物配置信息
	self.isBoss = 0 --是否是boss
	self.enmity = nil --boss仇恨目标 {obj_flag,name,career,sex,monster_id,modelID}
	self.dropOwner = nil --掉落归属

	self.roleId = 1  --角色ID 如所有机枪兵有个ID
	
	self.group = FightGroupType.ONE     	--当前所在的阵营，见FightGroupType
	self.modelID = "1103" --"1101"--"500"   --模型ID

	self.speed = 12--1.3*(display.width/1024)*6    --移动速度
	self.states = RoleActivitStates.STAND --RoleActivitStates.PAUSE---RoleActivitStates.STAND     --当前角色的状态，见RoleConst表
	
	self.atk = 0--攻击力
	self.def = 0
	self.scaleParam = 1

	--pk相关
	self.guildId = "0"    --帮会ID
	self.guildName = ""   --帮会名称
	self.teamId = "0"     --队伍ID
	self.corpsId = "0"    --军团
	self.corpsName = ""   --军团名称
	self.nameColor = 1    --1，2，3，4是白黄红灰色
	self.honorId = 0      --荣誉称号ID


	--控制技能相关
	self.atkDis = 100         -- 攻击距离是多少格子(像素0)
	self.atkspeed = 2         
	self.defaultSkill = 10100 -- 默认技能
	self.skillId = 0          -- 当前使用的技能
	self.skillAIList = {}     -- 技能AI列表   怪物 和宠物
	self.aIIndex = 0          -- 技能AI播放索引
	--控制技能相关 END

	--buff
	self.beginBuffList = {} --初始化Buff列表
	--buff
	self.buffDic = {}        --buff字典
	self.petNum = 0          --宠物数量
	self.server_name = ""    -- 服务器ID

	self.modelActSpeed = nil

	self.collect_state = 0
end

--根据NameColor获取玩家的颜色值，怪物不用
function SceneRoleVO:getNameColor(cnameColor)
	if not GameSceneModel.isInterService then
	    if FightModel.shaBaKeActivityOpen then
		    if FightModel.shaBakeGuildId ~= "0" and FightModel.shaBakeGuildId == self.guildId then
			    return TextColor.ROLE_B
		    else
			    --self.guildNameLab:setString(name)
		    end
	    end
	    --行会宣战
	    if GlobalController.guild.fight_guild_id and GlobalController.guild.fight_guild_id ~= 0 and GlobalController.guild.fight_guild_id == self.guildId then
			return cc.c3b(227, 47, 216)
	    else
			--self.guildNameLab:setString(name)
	    end
    end
	local color = TextColor.ROLE_W
	if cnameColor == 2 then
		color = TextColor.ROLE_Y
	elseif cnameColor == 3 then
		color = TextColor.ROLE_R
	elseif cnameColor == 4 then
		color = TextColor.ROLE_GRAY
	end
	return color
end

--是否与身上的效果排斥
-- self.buffPoison = nil --中毒
-- 	self.buffShield = nil --魔法盾
-- 	self.buffDizzy = nil --眩晕
-- 	self.buffFire = nil --烈火
-- 	self.buffStone = nil --石化
-- 	self.buffInvisible = nil --隐身
function SceneRoleVO:hasRejection(skillId,player,isAutoAtkStates)
	local b = false
	if skillId == 20400 and player.buffShield then
		b = true
	elseif (skillId == 10500 and player.buffFire) or isAutoAtkStates == false then
		b = true
	elseif skillId == 30400 and player.buffInvisible then-- 群隐身
		b = true
	elseif skillId == 30200 and (player.buffCure or player.vo.hp > player.vo.hp_limit*0.7) then--群治疗
		b = true
	elseif skillId == 30500 and player.buffAttAdd then-- 群防御
		b = true
	elseif skillId == 30300 then-- 群毒
		local selVO = FightModel:getSelAtkTarVO()
		if selVO then
			local tar = GlobalController.fight:getRoleModel(selVO.id,selVO.type)
			if tar and tar.buffPoison then
				b = true
			end
		end
	elseif skillId == 20300 then -- 火墙？？
		local selTar = FightModel:getSelAtkTarVO()
		if selTar then
			local isOK = false
			for k,v in pairs(GameSceneModel.fireWallVOArr ) do
				--print(math.abs(v.mGrid.x - selTar.mGrid.x ),math.abs(v.mGrid.y - selTar.mGrid.y ))
				if math.abs(v.mGrid.x - selTar.mGrid.x )<2 and math.abs(v.mGrid.y - selTar.mGrid.y )<2 then
					isOK = true
					break
				end
			end
			if isOK then 
				b = true
			end
		else
			b = true
		end
		--b = true
	elseif skillId == 10 and player.buffShield then
		b = true 
	elseif (skillId == 30600 or skillId == 30800 ) and ( self.petNum >0 or FightModel:getSelfFightPet()) then --神兽
		--FightModel:getSelfFightPet()要用在挂机中
		b = true
	end
	return b
end

--是否有自动释放技能 SkillPrior
function SceneRoleVO:getAutoSkill(isAutoAtkStates)
	local player = GlobalController.fight:getSelfPlayerModel()
	local roleManager = RoleManager:getInstance()
	local roleCurMp = RoleManager:getInstance().roleInfo.cur_mp
	local autoSkill = 0
	local halfAutoSkill = 0
    local skills = roleManager.autoSkill
	for k,v in pairs(skills) do
		if v.mp and  v:getSkillLock() and v.mp < roleCurMp and self:hasRejection(v.id,player,isAutoAtkStates) == false then
			if v.autoType == 3 then
				if autoSkill == 0 then
					autoSkill = v.id
				elseif SkillPrior[v.id] and SkillPrior[v.id] > SkillPrior[autoSkill] then
					autoSkill = v.id
				end
			elseif isAutoAtkStates and v.autoType == 4 then
				if halfAutoSkill == 0 then
					halfAutoSkill = v.id
				elseif SkillPrior[v.id] and SkillPrior[v.id] > SkillPrior[halfAutoSkill] then
					halfAutoSkill = v.id
				end
			end
		end
	end

	if autoSkill ~= 0 then
		self.skillId = autoSkill
	elseif halfAutoSkill ~= 0 then
		self.skillId = halfAutoSkill
	end

	if self.skillId and self.skillId ~= 0 then
		local skillConfig = FightModel:getSkillConfig(self.skillId)
		self.atkDis = skillConfig.atkDis*SceneGridRect.width--+SceneGridRect.width/2
		self.atkspeed = skillConfig.cd/1000
	end
	return self.skillId
end

--获取玩家下一个自动释放技能
function SceneRoleVO:getUseAutoSkill(skillId)
	local player = GlobalController.fight:getSelfPlayerModel()
    local roleCurMp = RoleManager:getInstance().roleInfo.cur_mp
	local roleManager = RoleManager:getInstance()

	local autoSkill = 0
	local groupSkill = 0
	local singleSkill = 0

	-- for k,v in pairs(roleManager.autoSkill) do
	-- 	if v:getSkillLock() and v.mp < roleCurMp and self:hasRejection(v.id,player) == false then
	-- 		autoSkill = v.id
	-- 	end
	-- end
	if (self.skillId == nil or self.skillId == 0) and GlobalController.skill.autoGroupSkillSwitch then
		for k,v in pairs(roleManager.groupSkill) do
			if v:getSkillLock() and v.mp < roleCurMp and self:hasRejection(v.id,player) == false then
				groupSkill = v.id
				break
			end
		end
	end

	if self.skillId == nil or self.skillId == 0 then
		for k,v in pairs(roleManager.singleSkill) do
			if v:getSkillLock() and v.mp < roleCurMp and self:hasRejection(v.id,player) == false then
				singleSkill = v.id
				break
			end
		end
	end

	if autoSkill ~= 0 then
		self.skillId = autoSkill
	else
		self.skillId = singleSkill
		if self.skillId == 0 then
			self.skillId = groupSkill
		elseif groupSkill ~= 0 then
			--搜索周围是否有两个或以上目标
			local tarVO = FightModel:getSelAtkTarVO() or FightModel:getMinDisEnemy( GameSceneModel:getPlayerVO())
			if FightModel:hasNearbyTwoEnemy(RoleManager:getInstance():getPKMode(),player.vo,tarVO) then
				self.skillId = groupSkill
			end
		end
	end


	if self.skillId == 0 then
		self.skillId = RoleManager:getInstance():getCarrerDefSkill()
	end
	if self.skillId and self.skillId ~= 0 then
		local skillConfig = FightModel:getSkillConfig(self.skillId)
		self.atkDis = skillConfig.atkDis*SceneGridRect.width--+SceneGridRect.width/2
		self.atkspeed = skillConfig.cd/1000
	end
	return self.skillId
end


function SceneRoleVO:getUseSkill(skillId)
	if self.skillId == self.defaultSkill then
		return self.skillId
	end
	if self.skillAIList == nil or #self.skillAIList == 0 then
		self.skillId = self.defaultSkill
	else
		self.aIIndex = self.aIIndex +1
		if self.aIIndex > #self.skillAIList then
			self.aIIndex = 1
		end
		self.skillId = self.skillAIList[self.aIIndex]
	end
	local skillConfig = FightModel:getSkillConfig(self.skillId)
	self.atkDis = skillConfig.atkDis*SceneGridRect.width--+SceneGridRect.width/2
	self.atkspeed = skillConfig.cd/1000
	return self.skillId
end

function SceneRoleVO:setUseSkill(skillId)
	self.skillId = skillId
	local skillConfig = FightModel:getSkillConfig(self.skillId)
	self.atkDis = skillConfig.atkDis*SceneGridRect.width--+SceneGridRect.width/2
	self.atkspeed = skillConfig.cd/1000
	return self.skillId
end

function SceneRoleVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneRoleVO:clear()
	--self.fightAtt:destory()
end	