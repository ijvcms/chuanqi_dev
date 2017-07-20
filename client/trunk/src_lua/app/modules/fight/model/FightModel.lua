--
-- Author: 21102585@qq.com
-- Date: 2014-11-11 18:00:30
-- 战斗模型

FightModel = FightModel or {}

function FightModel:ctor()
end

FightModel.COLOR_WHITE = cc.c3b(255, 255, 255)
FightModel.COLOR_BLACK = cc.c3b(0, 0, 0)
FightModel.COLOR_RED   = cc.c3b(255, 0, 0)
FightModel.COLOR_GREEN = cc.c3b(0, 255, 0)
FightModel.COLOR_BLUE  = cc.c3b(0, 0, 255)
FightModel.COLOR_RED2   = cc.c3b(238, 88, 77)

FightModel.COLOR_CRIT = cc.c3b(220, 27, 5)
FightModel.COLOR_MISS = cc.c3b(245, 237, 70)
FightModel.COLOR_HURT = cc.c3b(220, 27, 5)
FightModel.COLOR_TREAT = cc.c3b(0, 198, 0)

function FightModel:init()
    self.isInit = false  --是否初始化
    self.userYaoGan = false
    --self.isPetAtk = true --是否宠物攻击
    self.fightTime = 0 --战斗时间，战斗中的技能间隔时间，ai时间都是通过这个时间来计算
    
    self.selAtkTarVO = nil --当前选择的攻击目标VO
    self.selAtkTarId = 0
    self.selAtkTarType= 0

    --技能自动战斗状态
    self.autoAttackStates = true --是否开启自动攻击
    self.pauseAutoAtk = false --是否暂停自动攻击
    self.autoWayStates = false --自动寻路状态


    self.isRelive = false

    self.atkByDefaultSkill = false   --使用默认技能攻击 1.选了两次目标后实施攻击，2。点击默认技能后实施

    self.shaBakeGuildId = "0"        --当前占领的沙巴克帮会ID
    self.shaBakeGuildName = "" --当前占领的沙巴克帮会名称
    self.shaBaKeActivityOpen = false --当前沙巴克活动是否开启

    self.enemyIdList = {}   --仇人列表

    self.corpsId = "" --军团ID
end

--设置宠物攻击状态
-- function FightModel:setPetAtk(b)
--     self.isPetAtk = b
-- end
-- --获取宠物攻击状态
-- function FightModel:getPetAtk()
--     return self.isPetAtk
-- end

--设置选择目标
function FightModel:setSelAtkTarVO(vo)
    if self.selAtkTarVO then
        local mode = GlobalController.fight:getRoleModel(self.selAtkTarVO.id,self.selAtkTarVO.type)
        if mode then
            mode:setSelect(false)
        end
    end
    self.selAtkTarVO = vo
    if self.selAtkTarVO then
        local mode = GlobalController.fight:getRoleModel(self.selAtkTarVO.id,self.selAtkTarVO.type)
        if mode then
            mode:setSelect(true)
            self.selAtkTarId = self.selAtkTarVO.id
            self.selAtkTarType= self.selAtkTarVO.type
        end
    end
end
--获取选择目标
function FightModel:getSelAtkTarVO()
    if self.selAtkTarVO and self.selAtkTarId ~= 0 then
        local vo = GameSceneModel:getSceneObjVO(self.selAtkTarId,self.selAtkTarType)
        if vo and vo.states ~= RoleActivitStates.DEAD then
            FightModel:setSelAtkTarVO(vo)
            return self.selAtkTarVO
        else
            self.selAtkTarId = 0
            FightModel:setSelAtkTarVO(nil)
            return nil
        end
    end
    return nil
end

--更改选择目标
function FightModel:changSelAtkTarVO()
    local selfVO = GameSceneModel:getPlayerVO()
    local pkMode = RoleManager:getInstance():getPKMode()
    local exclouldId = "0"
    if self:getSelAtkTarVO() then
        exclouldId = self:getSelAtkTarVO().id
    end
    local enemyVO,dis = self:getPlayerAtkTar(pkMode,selfVO,exclouldId)
    if enemyVO == nil then
        self.selAtkTarId = 0
    end
    self:setSelAtkTarVO(enemyVO)
end

-- 获取自动攻击状态 zsq
-- notPause 是否不需要暂停信息
function FightModel:getAutoAttackStates(notPause)
    if notPause  then return self.autoAttackStates end
    if self.pauseAutoAtk or self.autoWayStates then
        return false
    end
    return self.autoAttackStates
end

--设置自动攻击状态 zsq
function FightModel:setAutoAttackStates(bool)
    if self.autoAttackStates == bool then
        return
    end
    self.autoAttackStates = bool
    GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_AUTO_ATTACK)
end


function FightModel:getSkillConfig(skillId,skillLv)
    skillLv = skillLv or 1
    --return FightSkillConf[skillId+skillLv]
    -- if getConfigObject(skillId+skillLv,SkillConf) == nil then
    --     print("FightModel:getSkillConfig = ",skillId+skillLv)
    -- end
    return getConfigObject(skillId+skillLv,SkillConf)

end

function FightModel:getSkillUiConfig(id,lv)
    lv = lv or 1
    return getConfigObject(id+lv,SkillUIConf)
end

--获取自己的战斗宠物VO
function FightModel:getSelfFightPet()
    for k,v in pairs(GameSceneModel.petVOArr) do
        if v.ownerId == GlobalModel.player_id then
            return v
        end
    end
    return nil
end
    

--获得战斗时间
function FightModel:getFTime()
    return self.fightTime
end  


function FightModel:clear()
    self.userYaoGan = false
    self.pauseAutoAtk = false
    self:setSelAtkTarVO(nil)
    self.selAtkTarVO = nil
    self:setAutoAttackStates(false)
end  

function FightModel:destory()
    self:clear()
end  


--判断是否是攻击对象
function FightModel:isAtkTarger(tarType,atkVO,targerVO)
    if tarType == SkillTargerType.MONSTER then --怪物
        return (atkVO.type ~= targerVO.type)
    elseif tarType == SkillTargerType.PARTNER then --伙伴
        return (atkVO.id ~= targerVO.id and atkVO.type == targerVO.type)
    elseif tarType == SkillTargerType.SELF then --自己
        return (atkVO.id == targerVO.id and atkVO.type == targerVO.type)
    end
    return false
end

--获取场景伤害列表
--skillId 技能ID
--atkVO  攻击者VO
--targerVO 目标VO
function FightModel:getHurtList(skillId,atkVO,targerVO)
    local tarList = {}--{id= enemyVO.id,type = enemyVO.type}
    local skill = FightModel:getSkillConfig(skillId)
    local targerType = skill.tarType
    local rangeType = skill.rangeType
    if targerType == SkillTargerType.SELF then -- 目标自己
        table.insert(tarList,{id= atkVO.id,type = atkVO.type})
        return tarList
    end

    if rangeType == SkillAtkRangeType.R_SINGLE then --单体
        table.insert(tarList,{id= targerVO.id,type = targerVO.type})
        return tarList
    elseif rangeType == SkillAtkRangeType.R_N_GROUP then --近身群体
        local rangeId = skill.rangeId
        local range 
        if #SkillRange[rangeId] >1 then
            range = SkillRange[rangeId][atkVO.direction]
        else
            range = SkillRange[rangeId][1]
        end
        table.insert(tarList,{id= targerVO.id,type = targerVO.type})
        for i=1,#range do
            local xx = atkVO.mGrid.x+range[i][1]
            local yy = atkVO.mGrid.y+range[i][2]
        
            local play = GameSceneModel:getSceneObjPos({x=xx,y=yy})
            if play then
            for k,v in pairs(play) do
                if v.states ~= RoleActivitStates.DEAD and self:isAtkTarger(targerType,atkVO,v) then
                    if targerVO.id ~= v.id then
                        table.insert(tarList,{id= v.id,type = v.type})
                    end
                end
            end
            end
        end
        return tarList
    elseif rangeType == SkillAtkRangeType.R_F_GROUP then --远程群体
        local rangeId = skill.rangeId
        local range = SkillRange[rangeId][1]
        -- if #SkillRange[rangeId] >1 then
        --     range = SkillRange[rangeId][atkVO.direction]
        -- else
        --     range = SkillRange[rangeId][1]
        -- end
        table.insert(tarList,{id= targerVO.id,type = targerVO.type})
        for i=1,#range do
            local xx = targerVO.mGrid.x+range[i][1]
            local yy = targerVO.mGrid.y+range[i][2]
            local play = GameSceneModel:getSceneObjPos({x=xx,y=yy})
            if play then
              
            for k,v in pairs(play) do
                if v.states ~= RoleActivitStates.DEAD and self:isAtkTarger(targerType,atkVO,v) then
                    if targerVO.id ~= v.id then
                        table.insert(tarList,{id= v.id,type = v.type})
                    end
                end
            end
            end
        end
        return tarList
    end
end

------------战斗使用模式和选择目标和选择技能相关
-- 默认技能 self.defSkill = RoleManager:getInstance():getCarrerDefSkill()
--GlobalController.fight:
-- 魔法值  RoleManager:getInstance().roleInfo.cur_mp
--FightModel:getSkillConfig(skillId,skillLv)
--self.vo.mp <= RoleManager:getInstance().roleInfo.cur_mp
--RoleManager:getRoleUseSkillVO(skillId)
--

function FightModel:getMinDisEnemy(roleVO)
    local enemyVO = nil
    local dis = 1000
    local curDis = 0
    if roleVO.type == SceneRoleType.MONSTER then
        --如果是怪物
        for k,v in pairs(GameSceneModel.playerVOArr) do
            if v.states ~= RoleActivitStates.DEAD then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,roleVO.pos.x,roleVO.pos.y)
                if curDis < dis and curDis < 1000 then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
        return enemyVO,dis
    elseif roleVO.type == SceneRoleType.PLAYER then
        --如果是人类，只会是本人所以首先获取玩家本人信息然后根据PK模式来判断
        local pkMode = RoleManager:getInstance():getPKMode()
        local enemyVO,dis = self:getPlayerAtkTar(pkMode,roleVO)
        return enemyVO,dis
    elseif roleVO.type == SceneRoleType.PET then
        local pkMode = RoleManager:getInstance():getPKMode()
        local enemyVO,dis = self:getPlayerAtkTar(pkMode,roleVO)
        return enemyVO,dis
    end
    return enemyVO,dis
end


function FightModel:getMinDisPartner(roleVO)
    local enemyVO = nil
    local dis = 1000
    local curDis = 0
    if roleVO.type == SceneRoleType.MONSTER then
        --如果是怪物
        for k,v in pairs(GameSceneModel.monsterVOArr) do
            if v.states ~= RoleActivitStates.DEAD and roleVO.id ~= v.id and v.mConf.type ~= MonsterType.LZ then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,roleVO.pos.x,roleVO.pos.y)
                if curDis < dis and curDis < 1000 then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
    elseif roleVO.type == SceneRoleType.PLAYER then
        --如果是人类，只会是本人所以首先获取玩家本人信息然后根据PK模式来判断
        local pkMode = RoleManager:getInstance():getPKMode()
        for k,v in pairs(GameSceneModel.playerVOArr) do
            if v.states ~= RoleActivitStates.DEAD and roleVO.id ~= v.id and  self:curPlayerCanPK(pkMode,roleVO,v) == false then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,roleVO.pos.x,roleVO.pos.y)
                if curDis < dis and curDis < 1000  then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
    end
    if enemyVO == nil then
        return roleVO,0
    end
    return enemyVO,dis
end

--获取一个玩家可以攻击目标
--@pk模式 pkMode
--@selfVO
--@排除ID excludeID
function FightModel:getPlayerAtkTar(pkMode,selfVO,excludeID)
    excludeID = excludeID or "0"
    local playerVO = selfVO
    -- if selfVO.type == SceneRoleType.PLAYER then
    --     playerVO = selfVO
    -- elseif selfVO.type == SceneRoleType.PET then
    --     playerVO = self:getRoleVO(selfVO.ownerId,SceneRoleType.PLAYER)--如果是宠物根据主人属性判断是否能够PK
    -- end

    local enemyVO = nil
    local dis = 1000
    local curDis = 0
        for k,v in pairs(GameSceneModel.monsterVOArr) do
            if v.states ~= RoleActivitStates.DEAD and playerVO.id ~= v.id and excludeID ~= v.id and v.mConf.type ~= MonsterType.LZ then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,playerVO.pos.x,playerVO.pos.y)
                if curDis < dis and curDis < 1000 then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
        for k,v in pairs(GameSceneModel.playerVOArr) do
            if v.states ~= RoleActivitStates.DEAD and playerVO.id ~= v.id and excludeID ~= v.id and  self:curPlayerCanPK(pkMode,playerVO,v) then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,playerVO.pos.x,playerVO.pos.y)
                if curDis < dis and curDis < 1000  then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
         for k,v in pairs(GameSceneModel.playerCopyVOArr) do
            if v.states ~= RoleActivitStates.DEAD and playerVO.id ~= v.id and excludeID ~= v.id and  self:curPlayerCanPK(pkMode,playerVO,v) then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,playerVO.pos.x,playerVO.pos.y)
                if curDis < dis and curDis < 1000  then
                    dis = curDis
                    enemyVO = v
                end
            end
        end

        for k,v in pairs(GameSceneModel.petVOArr) do
            if v.states ~= RoleActivitStates.DEAD and playerVO.id ~= v.ownerId and excludeID ~= v.id and self:curPlayerCanPK(pkMode,playerVO,v) then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,playerVO.pos.x,playerVO.pos.y)
                if curDis < dis and curDis < 1000 then
                    dis = curDis
                    enemyVO = v
                end
            end
        end
    return enemyVO,dis
end


--判断当前玩家是否可以PK
function FightModel:curPlayerCanPK(pkMode,selfVO,tarVO)
    if tarVO then
        if pkMode == FightModelType.PEACE then --和平
            return false
        elseif pkMode == FightModelType.GOODEVIL then --善恶
            return tarVO.nameColor > 2 
        elseif pkMode == FightModelType.TEAM then --组队
            if "0" == selfVO.teamId then
                return true
            end
            return selfVO.teamId ~= tarVO.teamId
        elseif pkMode == FightModelType.UNION then --联盟
            if "0" == selfVO.guildId then
                return true
            end
            return (selfVO.guildId ~= tarVO.guildId and RoleManager:getInstance():getHasUnion(tarVO.guildId) == false)
        elseif pkMode == FightModelType.GUILD then --行会
            if "0" == selfVO.guildId then
                return true
            end
            return (selfVO.guildId ~= tarVO.guildId and RoleManager:getInstance():getHasUnion(tarVO.guildId) == false)
        elseif pkMode == FightModelType.CORPS then --军团
            if "0" == selfVO.corpsId then
                return true
            end
            return selfVO.corpsId ~= tarVO.corpsId
        elseif pkMode == FightModelType.ALL then --全体
            return true
        elseif pkMode == FightModelType.ENEMY then --仇人
            if self.enemyIdList[tarVO.id] then
                return true
            end
            return false
        end

        
    end
    return false
end

--判断是否有两个敌人在一起
function FightModel:hasNearbyTwoEnemy(pkMode,selfVO,tarVO)
    if tarVO then
        for k,v in pairs(GameSceneModel.monsterVOArr) do
            if v.states ~= RoleActivitStates.DEAD and tarVO.id ~= v.id and v.mConf.type ~= MonsterType.LZ then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,tarVO.pos.x,tarVO.pos.y)
                if curDis < 96 then
                   return true
                end
            end
        end
        for k,v in pairs(GameSceneModel.playerVOArr) do
            if v.states ~= RoleActivitStates.DEAD and self:curPlayerCanPK(pkMode,selfVO,v) and tarVO.id ~= v.id and v.id ~= selfVO.id  then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,tarVO.pos.x,tarVO.pos.y)
                if curDis < 96  then
                     return true
                end
            end
        end

        for k,v in pairs(GameSceneModel.petVOArr) do
            if v.states ~= RoleActivitStates.DEAD and self:curPlayerCanPK(pkMode,selfVO,v) and tarVO.id ~= v.id and tarVO.id ~= v.ownerId and v.ownerId ~= selfVO.id then
                curDis = FightUtil:getDistance(v.pos.x,v.pos.y,tarVO.pos.x,tarVO.pos.y)
                if curDis < 96 then
                     return true
                end
            end
        end
    end
    return false
end


------------战斗使用模式和选择目标和选择技能相关END