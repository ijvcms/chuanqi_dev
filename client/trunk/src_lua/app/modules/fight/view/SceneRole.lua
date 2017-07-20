--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-28 09:38:49
-- 角色英雄
--
require("app.modules.fight.view.BaseRole")
SceneRole = SceneRole or class("SceneRole",BaseRole)

-- SceneRole = SceneRole or class("SceneRole",function()
-- 	return display.newNode()
-- end)

function SceneRole:ctor(roleVO)
	SceneRole.super.ctor(self,roleVO)
    self.showGetItemTime = 0
end


--活动场景拾取物品
function SceneRole:gotoGetItem(isAuto)
   
    if FightModel:getFTime() - self.showGetItemTime <= 1.5 and isAuto == false then
        return false
    end
    self.showGetItemTime = FightModel:getFTime()
    local sceneItem
    local isBagRemain = (BagManager:getInstance():getBagRemain() > 0)
    if isAuto == false then
        sceneItem = GlobalController.fight:getCurGridSelfItemModel(self.vo,isBagRemain)
    elseif isAuto then
        sceneItem = GlobalController.fight:getSelfItemModel(self.vo,isBagRemain)
    end
    if sceneItem ~= nil then
            if sceneItem.mGrid.x == self.vo.mGrid.x and sceneItem.mGrid.y == self.vo.mGrid.y then
                if isBagRemain == false and sceneItem.itemType ~= GoodsType.MONEY then
                --if isBagRemain == false then
                    if sBagRemain == false then
                        GlobalMessage:show("背包已满，请及时清理")
                    else
                        GlobalMessage:show("背包已满，无法拾取")
                    end
                    return false
                else
                    --print("",sceneItem.id,sceneItem.itemType,GoodsType.MONEY)
                    GameNet:sendMsgToSocket(11006, {drop_id = sceneItem.id})
                    if sceneItem.itemType == GoodsType.MONEY then
                        SoundManager:playSoundByType(SoundType.PICKUP_MONEY)
                    else
                        SoundManager:playSoundByType(SoundType.PICKUP)
                    end
                    GlobalController.fight:delSceneRole(sceneItem.id,sceneItem.type)
                    return true
                end
            else
                if sBagRemain == false and sceneItem.itemType ~= GoodsType.MONEY then --isBagRemain == false and
                    --if isBagRemain == false then
                    if sBagRemain == false then
                        GlobalMessage:show("背包已满，请及时清理")
                    end
                    return false
                else
                    local backFun = function()
                        if isBagRemain == false and sceneItem.itemType ~= GoodsType.MONEY then
                            -- if isBagRemain == false then
                            GlobalMessage:show("背包已满，无法拾取")
                        else
                            GameNet:sendMsgToSocket(11006, {drop_id = sceneItem.id})
                            if sceneItem.itemType == GoodsType.MONEY then
                                SoundManager:playSoundByType(SoundType.PICKUP_MONEY)
                            else
                                SoundManager:playSoundByType(SoundType.PICKUP)
                            end
                            GlobalController.fight:delSceneRole(sceneItem.id,sceneItem.type)
                        end
                    end

                    local list = GlobalController.fight.aStar:find(self.vo.mGrid,sceneItem.mGrid)
                    if list ~= nil then
                        if #list > 0 then
                            self:roleMoveTo(list,false,10,backFun)
                            return true
                        end
                    end
                    return false
                end
            end
    else
        return false
    end
    return false
end


function SceneRole:setCurSkillLock(skillId)
    local fightSkillBaseList = RoleManager:getInstance().fightSkillBaseList
    local roleUseSkillVo = fightSkillBaseList[skillId]
    if not roleUseSkillVo then
        return
    end
    roleUseSkillVo:setSkillLock()
end

--发送攻击协议
function SceneRole:sendUserSkill(skillId,direction,tarType,tarFlag,tarPoint,sendSign)
    if self.collectBar then
        return
    end
    if self.semdTimeee == nil then
        self.semdTimeee = 0 
    end
    self.semdTimeee = FightModel:getFTime()
     local param = {
                direction = direction,
                skill_id = skillId,
                target_type = tarType,--"目标类型: 1 对象, 2 地面坐标"
                target_flag = tarFlag,
                target_point = tarPoint,
    }
    GameNet:sendMsgToSocket(12002, param)
    self.hurtEffPoint = FightUtil:gridToPoint(tarPoint.x,tarPoint.y)
    if self.isMainPlayer then
        --dump(param)
        print("________SEND SKILL goto",sendSign,skillId,self.semdTimeee)
    end
end

--获取玩家技能VO
function SceneRole:getPlayerSkillLV(skillId)
    local skillLv = 1
    local skillInfo = RoleManager.getInstance():getRoleUseSkillVO(skillId)
    if skillInfo then
        skillLv = skillInfo.lv
    end
end

--由外部调用的接口,不改变usePlayerSkill原来的接口
function SceneRole:usePlayerSkillForExtenal(skillConf,isForced)
    if not self:canUseSkill() then
        return false
    end
    self:usePlayerSkill(skillConf, isForced)
end

--使用玩家技能
-- {"id", "name", "lv", "type", "costMp", "cd", "atkDis", "tarType", "range", "effect", "rangeId", "rangeType", "hurtEffType", "atkEffType", "atkAct", "atkSound", "hurtSound", "atkEff", "flyEff", "hurtEff", "key"}
-- @param skillConf 技能配置
-- @param isForced 是否强制使用技能
function SceneRole:usePlayerSkill(skillConf,isForced)

    if RoleManager:getInstance():getFightSkillUseByPoint(skillConf.id) and RoleManager:getInstance().nextUseSkillPoint then
        --如果在活动场景并且是点击选择坐标技能
        -- local param = {
        --     direction = self.vo.direction,
        --     skill_id = skillConf.id,
        --     target_type = 2,--"目标类型: 1 对象, 2 地面坐标"
        --     target_flag = {id = 0,type = 0},
        --     target_point = {x=RoleManager:getInstance().nextUseSkillPoint.x,y=RoleManager:getInstance().nextUseSkillPoint.y},
        -- }
        -- GameNet:sendMsgToSocket(12002, param)
        if RoleManager:getInstance().nextUseSkillPoint == nil then
            local selTar = FightModel:getSelAtkTarVO()
            if selTar then
                RoleManager:getInstance().nextUseSkillPoint = selTar.mGrid
            else
                RoleManager:getInstance().nextUseSkillPoint =  GameSceneModel:getPlayerVO().mGrid
            end
        end
       
        self:sendUserSkill(skillConf.id,self.vo.direction,2,{id = 0,type = 0},{x=RoleManager:getInstance().nextUseSkillPoint.x,y=RoleManager:getInstance().nextUseSkillPoint.y},"UseByPoint")
        self.skillInterval = 2
        self.preAttackTime = FightModel:getFTime()
        self:setCurSkillLock(skillConf.id)
        RoleManager:getInstance().nextUseSkillPoint = nil
        return true
    end


    --FightModel:getSelAtkTarVO()

    local enemyVO
    local dis = 10000
    if skillConf.tarType == SkillTargerType.SELF then
        enemyVO =  GameSceneModel:getPlayerVO()
        dis = 0
    elseif skillConf.tarType == SkillTargerType.PARTNER then
        enemyVO =  GameSceneModel:getPlayerVO()
        dis = 0

        -- if FightModel:getSelAtkTarVO() then
        --     enemyVO = FightModel:getSelAtkTarVO()
        --     dis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,enemyVO.pos.x,enemyVO.pos.y)
        -- else
        --     enemyVO = FightModel:getMinDisPartner(self.vo)
        --     dis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,enemyVO.pos.x,enemyVO.pos.y)
        -- end
    elseif FightModel:getSelAtkTarVO() then
        enemyVO = FightModel:getSelAtkTarVO()
        dis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,enemyVO.pos.x,enemyVO.pos.y)
    else
        enemyVO = FightModel:getMinDisEnemy(self.vo)
        if enemyVO then
            dis = FightUtil:getDistance(self.vo.pos.x,self.vo.pos.y,enemyVO.pos.x,enemyVO.pos.y)
            FightModel:setSelAtkTarVO(enemyVO)
        end
    end
    if enemyVO then
        if self.isMainPlayer then
            print("usePlayerSkill1 = ",enemyVO,dis - 48,self.vo.atkDis)
        end
        if dis - 48 <= self.vo.atkDis then
            --能够打到
            if math.abs(self.vo.pos.x - enemyVO.pos.x)>10 or math.abs(self.vo.pos.y - enemyVO.pos.y)>10 then
                local ang = FightUtil:getAngle(self.vo.pos,enemyVO.pos)
                if self.vo.id ~= enemyVO.id then
                    self.vo.direction =FightUtil:getDirectByAngle(ang)
                end
            end

            -- 活动场景发送攻击协议
            -- 活动场景才这样，挂机场景要在伤害时才请求
            --if FightModel.sceneType == SceneType.ACTIVITY then
                local tarPoint = enemyVO.pos
                local cGrid= FightUtil:pointToGrid(tarPoint.x,tarPoint.y)
                -- local param = {
                --     direction = self.vo.direction,
                --     skill_id = skillConf.id,
                --     target_type = 1,--"目标类型: 1 对象, 2 地面坐标"
                --     target_flag = {id= enemyVO.id,type = enemyVO.type},
                --     target_point = {x=cGrid.x,y=cGrid.y},
                -- }
                -- GameNet:sendMsgToSocket(12002, param)
                self:sendUserSkill(skillConf.id,self.vo.direction,1,{id= enemyVO.id,type = enemyVO.type},{x=cGrid.x,y=cGrid.y},"UseHasTarget")
                -- if self.isMainPlayer then
                --     print("________SEND SKILL enemyVO.id = "..enemyVO.id,enemyVO.states,skillConf.id,cGrid.x,cGrid.y)
                -- end
                self.skillInterval = 2
                self.preAttackTime = FightModel:getFTime()
            -- else
    
            --     if self.vo.skillId == 10500 then
            --         GlobalController.model:push(self, "playAttack", enemyVO.id,enemyVO.type,99900,self:getPlayerSkillLV(self.vo.skillId))
            --         --self:playAttack(enemyVO.id,enemyVO.type,99900,self:getPlayerSkillLV(self.vo.skillId))
            --     else
            --         GlobalController.model:push(self, "playAttack", enemyVO.id,enemyVO.type,skillConf.id,self:getPlayerSkillLV(self.vo.skillId))
            --         --self:playAttack(enemyVO.id,enemyVO.type,skillConf.id,self:getPlayerSkillLV(self.vo.skillId))
            --     end
            -- end
            if self.vo.skillId == 99900 then
                self.skillInterval = 0.1
                self:setCurSkillLock(10500)
            else
                self:setCurSkillLock(skillConf.id)
            end
            -- 发送攻击协议END
            --self.vo.skillId = 0
            return true
        elseif (isForced and skillConf.search == 0) then
                if self.isMainPlayer then
                 print("usePlayerSkill2 = ",isForced,skillConf.search)
                end
            --强制播放技能
            --if  FightModel.sceneType == SceneType.ACTIVITY then
                local cGrid = self:getSkillNotTarPos(skillConf,self.vo)

                -- local cGrid= FightUtil:pointToGrid(pos.x,pos.y)
                -- local param = {
                --         direction = self.vo.direction,
                --         skill_id = skillConf.id,
                --         target_type = 2,--"目标类型: 1 对象, 2 地面坐标"
                --         target_flag = {id= 0,type = 0},
                --         target_point = {x=cGrid.x,y=cGrid.y},
                -- }
                -- GameNet:sendMsgToSocket(12002, param)
                self:sendUserSkill(skillConf.id,self.vo.direction,2,{id= 0,type = 0},{x=cGrid.x,y=cGrid.y},"UseIsForced")

                -- if self.isMainPlayer then
                --     print("________SEND SKILL qiangzhi = ",skillConf.id,cGrid.x,cGrid.y)
                -- end
                self.skillInterval = 2
                self.preAttackTime = FightModel:getFTime()
                self:setCurSkillLock(skillConf.id)
            --end
            return true
        elseif self.preAttack and FightModel:getAutoAttackStates() == false then

            if self.isMainPlayer then
             print("usePlayerSkill3 = ",self.preAttack)
            end
            local cGrid = self:getSkillNotTarPos(skillConf,self.vo)

            --local cGrid= FightUtil:pointToGrid(pos.x,pos.y)
            -- local param = {
            --         direction = self.vo.direction,
            --         skill_id = skillConf.id,
            --         target_type = 2,--"目标类型: 1 对象, 2 地面坐标"
            --         target_flag = {id= 0,type = 0},
            --         target_point = {x=cGrid.x,y=cGrid.y},
            -- }
            -- GameNet:sendMsgToSocket(12002, param)
            self:sendUserSkill(skillConf.id,self.vo.direction,2,{id= 0,type = 0},{x=cGrid.x,y=cGrid.y},"UseNoTarget")

            -- if self.isMainPlayer then
            --     print("________SEND SKILL no target = ",skillConf.id,cGrid.x,cGrid.y)
            -- end
            self.skillInterval = 2
            self.preAttackTime = FightModel:getFTime()
            self:setCurSkillLock(skillConf.id)

        else

            --距离太远的时候跑过去
            local fightCon = GlobalController.fight
            local nodePoint = enemyVO.pos
            local cGrid= FightUtil:pointToGrid(nodePoint.x,nodePoint.y)

            local rGrid= FightUtil:pointToGrid(self.vo.pos.x,self.vo.pos.y)
            --走像素
            --self:roleMoveTo({{self.vo.pos.x +(nodePoint.x -self.vo.pos.x)/4,self.vo.pos.y +(nodePoint.y -self.vo.pos.y)/4}})
            
            --if true then return end
            --走格子
            local list = fightCon.aStar:find(rGrid,cGrid)
            if list then
                local len = #list -- math.floor(self.vo.atkDis/(SceneGridRect.width*1.4))
                local arr = {}
                if len >= 3 then
                    len = 3
                end
            
            --for i=2,math.max(2,math.floor(len/2)) do 
            --其中有一个情况，距离上打不到但是寻路又不走，这就造成一直站着

            if self.isMainPlayer then
                print("usePlayerSkill4 = ",len)
            end
                if false and len == 2 then
                    table.insert(arr, list[2])
                else
                    for i=1,math.floor(len) do 
                        local p = FightUtil:gridToPoint(list[i].x,list[i].y)
                        local diss = FightUtil:getDistance(nodePoint.x,nodePoint.y,p.x,p.y)

            if self.isMainPlayer then
                print("usePlayerSkill6 = ",diss,nodePoint.x,nodePoint.y,p.x,p.y)
            end
                        if diss >= 32 then
                            table.insert(arr, list[i])
                            if diss < self.vo.atkDis then
                                break
                            end
                        else
                            break
                        end
                    end
                end
            if self.isMainPlayer then
                print("usePlayerSkill5 = ",#arr)
            end
                self:roleMoveTo(arr)
                --走格子 END
            else
                -- print("SceneRole:usePlayerSkill  roleMoveTo search Path ERROR")
                --self:roleMoveTo(arr)
            end
            return false
        end
    else
        --没有敌人的时候
        self:gotoGetItem(true)
        --强制播放技能
        if isForced then
            local cGrid = self:getSkillNotTarPos(skillConf,self.vo)

            --local cGrid= FightUtil:pointToGrid(pos.x,pos.y)
            -- local param = {
            --         direction = self.vo.direction,
            --         skill_id = skillConf.id,
            --         target_type = 2,--"目标类型: 1 对象, 2 地面坐标"
            --         target_flag = {id= 0,type = 0},
            --         target_point = {x=cGrid.x,y=cGrid.y},
            -- }
            -- GameNet:sendMsgToSocket(12002, param)
            self:sendUserSkill(skillConf.id,self.vo.direction,2,{id= 0,type = 0},{x=cGrid.x,y=cGrid.y},"UseNoTarget")

            -- if self.isMainPlayer then
            --     print("________SEND SKILL no target = ",skillConf.id,cGrid.x,cGrid.y)
            -- end
            self.skillInterval = 2
            self.preAttackTime = FightModel:getFTime()
            self:setCurSkillLock(skillConf.id)
        end
        return true
    end
end

function SceneRole:canUseSkill()
    if self.buffDizzy or self.buffStone or self.silent or self.collectBar or self.transferPointTimeId then
        return false 
    end
    local isDead = self.vo.states == RoleActivitStates.DEAD  --死亡状态
    if isDead then return false end
    return FightModel:getFTime()-self.preAttackTime < self.skillInterval --时间间隔
end

function SceneRole:playStand()
	if self.vo.states == RoleActivitStates.DEAD then return end
    if self.armature and self.activityStates ~= RoleActivitStates.STAND then
        local curAct = FightAction.STAND.."_"..self.actionIndex
        if self.armature:getAnimation():getCurrentMovementID() ~= curAct then  
            if self.vo.modelActSpeed then  
                self.armature:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
            end
            self.armature:getAnimation():play(curAct)
        end
        if self.armatureWeapon and self.armatureWeapon:getAnimation():getCurrentMovementID() ~= curAct then    
            if self.vo.modelActSpeed then  
                self.armatureWeapon:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
            end
            self.armatureWeapon:getAnimation():play(curAct)
        end
        if self.armatureWing and self.armatureWing:getAnimation():getCurrentMovementID() ~= curAct then 
            if self.vo.modelActSpeed then  
                self.armatureWing:getAnimation():setSpeedScale(self.vo.modelActSpeed["stand"])     
            end
            self.armatureWing:getAnimation():play(curAct)
        end
        if self.backPos then
            self:setRolePosition(self.backPos.x,self.backPos.y)
            self.backPos = nil
        end
        self.activityStates = RoleActivitStates.STAND
    end
	if FightModel:getFTime()-self.preAttackTime < self.skillInterval then
        -- if self.armature and self.activityStates ~= RoleActivitStates.STAND then
        --     self.activityStates = RoleActivitStates.STAND

        --     local curAct = FightAction.STAND.."_"..self.actionIndex
        --     if self.armature:getAnimation():getCurrentMovementID() ~= curAct then        
        --         self.armature:getAnimation():play(curAct)
        --     end
        --     if self.armatureWeapon and self.armatureWeapon:getAnimation():getCurrentMovementID() ~= curAct then        
        --         self.armatureWeapon:getAnimation():play(curAct)
        --     end
        --     if self.armatureWing and self.armatureWing:getAnimation():getCurrentMovementID() ~= curAct then        
        --         self.armatureWing:getAnimation():play(curAct)
        --     end
        --     if self.backPos then
        --         self:setRolePosition(self.backPos.x,self.backPos.y)
        --         self.backPos = nil
        --     end
        -- end
    	return
    else
        self.activityStates = RoleActivitStates.STAND
    	--设置这个时间的目的是让他在没有事情做得时候隔多久去看看有没有事情做
    	--如果有事情做一定要设回来
        self.skillInterval = 0.5
        self.preAttackTime = FightModel:getFTime()

        if self.vo.states == RoleActivitStates.PRE_ATTACK then
            self.preAttack = true
            self:setStates(RoleActivitStates.STAND)
        else
            self.preAttack = false
        end
	end 
    
    if self.buffDizzy or self.buffStone or self.silent then
        return
    end
    if self.collectBar or self.transferPointTimeId then
        return
    end
    local isRole = false
    if self.isMainPlayer then

        isRole = true
    end
    local isautoMonster = false
    
    local isPet = false
    
    --self:usePlayerSkill(skillConf)

    --技能释放原则
    --怪物和宠物一帮只有一个技能或者一连串技能，所以先判断敌人再放技能
    --角色需要判断周围有什么怪，需要放什么技能，然后根据
    if isRole then
        local isAutoAtkStates = FightModel:getAutoAttackStates()
    if self.isMainPlayer then
     --print("stand1 = ",isAutoAtkStates,self.skillInterval)
    end
       -- if FightModel.sceneType == SceneType.ACTIVITY then
            
            if isAutoAtkStates then
                if self:gotoGetItem(true) then
                    return
                end
            else
                self:gotoGetItem(false)
            end
        --end
        if RoleManager:getInstance().nextUseSkillID ~= nil then
            if self.isMainPlayer then
            -- print("stand2 = ",RoleManager:getInstance().nextUseSkillID)
            end
            --使用主动技能
            self.vo:setUseSkill(RoleManager:getInstance().nextUseSkillID)
            if self:usePlayerSkill(FightModel:getSkillConfig(RoleManager:getInstance().nextUseSkillID),true) then
              
                RoleManager:getInstance().nextUseSkillID = nil
                self.vo.skillId = 0
            else

            end
        elseif self.vo:getAutoSkill(isAutoAtkStates) ~= 0 then
            if self.isMainPlayer then
            -- print("stand3 = ",self.vo.skillId)
            end
            if self:usePlayerSkill(FightModel:getSkillConfig(self.vo.skillId),false) then
           
                self.vo:setUseSkill(self.vo.skillId)
                self.vo.skillId = 0
            else

            end
            --todo
        elseif isAutoAtkStates then
            --自动状态下使用自动技能
            SceneManager:killTaskMonsterByResId() --自动状态下寻找是否有任务怪需要打

            self.vo.skillId = self.vo:getUseAutoSkill()

            if self.isMainPlayer then
              --  print("stand4 = ",self.vo.skillId)
            end

            if self:usePlayerSkill(FightModel:getSkillConfig(self.vo.skillId),false) then
            
                self.vo:setUseSkill(self.vo.skillId)
                self.vo.skillId = 0
            else

            end
        elseif FightModel.atkByDefaultSkill and FightModel:getSelAtkTarVO() and isAutoAtkStates == false then
            if self.isMainPlayer then
               -- print("stand5 = ")
            end
            --非自动战斗的情况下，如果有选中的人则用普通攻击打死他
            self.vo.skillId = RoleManager:getInstance():getCarrerDefSkill()
            self.vo:setUseSkill(self.vo.skillId)
            if self:usePlayerSkill(FightModel:getSkillConfig(self.vo.skillId)) then
                
                self.vo.skillId = 0
            end
        else
            if self.isMainPlayer then
               -- print("stand6 = ")
            end
        end
        
    end

    if isPet then
        local ower =  GameSceneModel:getPlayerVO()
        if math.abs(ower.mGrid.x - self.vo.mGrid.x) + math.abs(ower.mGrid.y - self.vo.mGrid.y) >12 then
                local list = GlobalController.fight.aStar:find(self.vo.mGrid,ower.mGrid,true)
                self:roleMoveTo(list)
                return
        end

        local enemyVO,dis = FightModel:getMinDisEnemy(self.vo)
        if enemyVO then
            if self.vo.skillId == 0 then
                local pp =  self.vo:getUseSkill()
            end
            if dis <= self.vo.atkDis then
                local ang = FightUtil:getAngle(self.vo.pos,enemyVO.pos)
                self.vo.direction =FightUtil:getDirectByAngle(ang)
                --self:playAttack(enemyVO.id,enemyVO.type,self.vo.skillId,self:getPlayerSkillLV(self.vo.skillId))
                GlobalController.model:push(self, "playAttack", enemyVO.id,enemyVO.type,self.vo.skillId,self:getPlayerSkillLV(self.vo.skillId))
                self.vo.skillId = 0
            else
                if math.random(0,1000) >200 then
                    local fightCon = GlobalController.fight
                    local nodePoint = enemyVO.pos
                    local cGrid= FightUtil:pointToGrid(nodePoint.x,nodePoint.y)

                    local rGrid= FightUtil:pointToGrid(self.vo.pos.x,self.vo.pos.y)
                    --走像素
                    --self:roleMoveTo({{self.vo.pos.x +(nodePoint.x -self.vo.pos.x)/4,self.vo.pos.y +(nodePoint.y -self.vo.pos.y)/4}})

                   
                    --走格子
                    local list = fightCon.aStar:find(rGrid,cGrid)
                    table.remove(list, #list)
                    self:roleMoveTo(list)
                    --走格子 END
                end
            end
        else
            

        end
    end
end



--角色普通攻击
function SceneRole:playAttack(targerId,targerType,skillId,skillLv)

    if self.isDestory_ then
        return
    end
    if self.vo.states ~= RoleActivitStates.STAND and self.vo.states ~= RoleActivitStates.PRE_ATTACK then return end
    self:setStates(RoleActivitStates.ATTACK)
    if self.vo.states == RoleActivitStates.DEAD then return end
    if self.armature and self.activityStates ~= RoleActivitStates.ATTACK then
        self.backPos = nil
        local tarVo = GameSceneModel:getSceneObjVO(targerId,targerType)

        if tarVo and SceneRoleType.MONSTER == self.vo.type and self.vo.monster_id == 7402 then --大刀的ID
            --if self.hurtList and #self.hurtList >0 then
                self.backPos = cc.p(self.vo.pos.x,self.vo.pos.y)
                local xxAdd = tarVo.pos.x - self.vo.pos.x
                local yyAdd = tarVo.pos.y - self.vo.pos.y

                local scale = math.sqrt(64*64/(xxAdd*xxAdd+yyAdd*yyAdd))
                self:setRolePosition(tarVo.pos.x-xxAdd*scale,tarVo.pos.y-yyAdd*scale)
            --end
        end
        if tarVo and (self.vo.pos.x ~= tarVo.pos.x or self.vo.pos.y ~= tarVo.pos.y) then
            local ang = FightUtil:getAngle(self.vo.pos,tarVo.pos)
            self.vo.direction =FightUtil:getDirectByAngle(ang)
            self:setModelActionIndex(self.vo.direction)
            self:setModelScaleX()
        end
        if self.vo.type == SceneRoleType.PLAYER then
            --GlobalController.model:push(self, "changCloth", self.vo.modelID)
            self:changCloth(self.vo.modelID)
        end

        skillLv = skillLv or 1
        --self:setModelActionIndex(self.vo.direction)
        --self:setModelScaleX()
        if skillId == 10500 then
            self.skillInterval = 0.2
        else
            self.skillInterval = 1.0
        end
        -- if self.isMainPlayer then
        --         print("________PLAY SKILL  playAttack",skillId,self.skillInterval)
        -- end
        --self.vo.atkspeed
        self.preAttackTime = FightModel:getFTime() --设置当前攻击时间
        -- local skillConfig = self.vo.skillConfig
       self.activityStates = RoleActivitStates.ATTACK
        -- if skillConfig.atkAction == "" or skillConfig.atkAction == nil then
        --     self:setStates(RoleActivitStates.STAND)
        --     if skillConfig.sType == 10 then
        --         self:say("操，技能居然没有配攻击动作")
        --     end 
        --     return
        -- end
        local skillConf = FightModel:getSkillConfig(skillId,skillLv)
        local attackAct = skillConf.atkAct--FightAction.ATTACK
        if attackAct == "" then

            self:playAttackEffect(skillConf,targerId,targerType)
            self:playFlyEffect(skillConf,targerId,targerType)
            if self.vo.states == RoleActivitStates.ATTACK then
                self:setStates(RoleActivitStates.STAND)
                self.activityStates = RoleActivitStates.STAND
            end 
            return
        end
        local function animationEvent(armatureBack,movementType,movementID)
            if self.isDestory_ then
                return
            end
            if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
                armatureBack:getAnimation():setMovementEventCallFunc(function()end)
                -- armatureBack:getAnimation():setFrameEventCallFunc(function()end)                
                if self.vo.states == RoleActivitStates.ATTACK then
                    self:setStates(RoleActivitStates.STAND)
                end    
            elseif movementType == ccs.MovementEventType.start then

            end
        end
        self.armature:getAnimation():setMovementEventCallFunc(animationEvent)
        --监听帧事件
        local function frameEvent(bone,frameEventName,originFrameIndex,currentFrameIndex)  
            --print("playAttackEffect",self.vo.id)
            if frameEventName == "attack" then
                self.armature:getAnimation():setFrameEventCallFunc(function()end)

                -- self.vo:updateFightAtt()
                -- self:updateAtkSpeed()

                -- if skillConfig.atkEffect ~= "" then  
                --     self:playAttackEffect(skillConfig.atkEffect,skillConfig.atkEffPos,targerId)
                -- else                   
                --     self:playHurt(targerId)
                -- end 
                -- if skillConfig.vibration == 1 then
                --     GlobalEventSystem:dispatchEvent(FightEvent.VIBRATION_SCENE)
                -- end 
                --self:playAttackEffect(skillConf,targerId,targerType)
                --self:playHurt(targerId,targerType)
                self:playFlyEffect(skillConf,targerId,targerType)
            end 
        end
        self.armature:getAnimation():setFrameEventCallFunc(frameEvent) 
        
        local modelSpeed = 1
        if self.vo.modelActSpeed then  
            modelSpeed = self.vo.modelActSpeed[attackAct]*modelSpeed or modelSpeed    
        end

        self:playAttackEffect(skillConf,targerId,targerType,modelSpeed)  --效果和动作同步 
        
        self.armature:getAnimation():setSpeedScale(modelSpeed)
        self.armature:getAnimation():play(attackAct.."_"..self.actionIndex)--skillConfig.atkAction)
        if self.armatureWeapon then
            self.armatureWeapon:getAnimation():setSpeedScale(modelSpeed)
            self.armatureWeapon:getAnimation():play(attackAct.."_"..self.actionIndex)
        end  
        if self.armatureWing then
            self.armatureWing:getAnimation():setSpeedScale(modelSpeed)
            self.armatureWing:getAnimation():play(attackAct.."_"..self.actionIndex)
        end

        local atkSound = skillConf.atkSound or "hit"--"s_atkDef"
        if atkSound and atkSound ~= "" then
            SoundManager:playSound(atkSound)
        else
            local voType = self.vo.type
            -- 怪物攻击的时候播放音效
            -- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/90b02757892445fb9b5521782b697139/
            if voType == SceneRoleType.MONSTER or voType == SceneRoleType.BOSS then
                local monster_id = self.vo.monster_id
                local attckSound = configHelper:getMonsterAttckSound(monster_id)
                if attckSound then
                    SoundManager:playSound(attckSound)
                end
            end
        end
    end 
end	


--执行伤害
function SceneRole:playHurt(skillConf,targerId,targerType)
    if self.vo == nil or self.vo.states == RoleActivitStates.DEAD then return end
        -- if self.isMainPlayer then
        --             print("________SEND SKILL END = playHurt",skillConf.id)
        -- end
        local hurtRoleList = {}
        local hurtPos = cc.p(self.vo.pos.x+50,self.vo.pos.y+50)
        local tarModel
        local tarVo
        -- if self.hurtList and #self.hurtList >0 then
        --     for i=1,#self.hurtList do
        --         local vo = self.hurtList[i]
        --         tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        --         tarVo = GameSceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
        --         if tarModel and tarVo then
        --             if vo.harm_status == 1 then--伤害状态: 1 miss, 2 普通, 3 暴击"/>
        --                 tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value, false,self.vo.type) --cur_mp
        --             elseif vo.harm_status == 3 then
        --                 tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value, true,self.vo.type)
        --             elseif vo.harm_status == 2 then
        --                 tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value, false,self.vo.type)
        --             end
        --             --tarModel:playHurtEffect(skillId)
        --             --table.insert(hurtRoleList,{id= vo.obj_flag.id,type = vo.obj_flag.type})
        --         end
        --     end
        --     self.hurtList = nil
        -- else
            
        -- end
        -- if self.targetList and #self.targetList > 0 then
        --     for i=1,#self.targetList do
        --         local v = self.targetList[i]
        --         table.insert(hurtRoleList,{id= v.id,type = v.type})
        --     end
        --     self.targetList = nil
        -- end
        -- if self.move_list  and #self.move_list >0 then
        --     for i=1,#self.move_list do
        --         local vo = self.move_list[i]
        --         tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        --         if tarModel then
        --             local p = FightUtil:gridToPoint(vo.end_point.x,vo.end_point.y)
        --             tarModel:playCollision({p.x,p.y})
        --         end
        --     end
        --     self.move_list = nil
        -- end
        

        -- if self.knockback_list and #self.knockback_list >0 then
        --     for i=1,#self.knockback_list do
        --         local vo = self.knockback_list[i]
        --         tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        --         if tarModel then
        --             local p = FightUtil:gridToPoint(vo.end_point.x,vo.end_point.y)
        --             tarModel:playBeCollision({p.x,p.y})
        --         end
        --     end
        --     self.knockback_list = nil
        -- end
        
        -- if self.cureList and #self.cureList >0 then
        --         for i=1,#self.cureList do
        --             local vo = self.cureList[i]
        --             tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        --             tarVo = GameSceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
        --             if tarModel and tarVo then
        --                 tarModel:setHP(vo.cur_hp,vo.cur_mp,0-vo.add_hp,false)
        --             end
        --         end
        --         self.cureList = nil
        -- end

        -- if self.buffList and #self.buffList > 0 then
        --     for i=1,#self.buffList do
        --         local buff = self.buffList[i]
        --         tarModel = GlobalController.fight:getRoleModel(buff.obj_flag.id,buff.obj_flag.type)
        --         tarVo = GameSceneModel:getSceneObjVO(buff.obj_flag.id,buff.obj_flag.type)
        --         if tarModel and tarVo then
        --             tarModel:updateBuff(self.buffList[i])
        --         end
        --     end
        --     self.buffList = nil
        -- end

            local enemyVO = GameSceneModel:getSceneObjVO(targerId,targerType)
        
            if self.isMainPlayer then
                GameNet:sendMsgToSocket(12010, {})
                -- if self.isMainPlayer then
                --     print("________SEND SKILL END = ",skillConf.id)
                -- end
            end
    
            --print(targerId,targerType)
            local target = GlobalController.fight:getRoleModel(targerId,targerType)
            local hurtRoleList = {}
            if target then
                table.insert(hurtRoleList,target)
            end
            local hurtPos
            if enemyVO then
                hurtPos = cc.p(enemyVO.pos.x,enemyVO.pos.y)
            elseif self.hurtEffPoint then
                hurtPos = self.hurtEffPoint
                self.hurtEffPoint = nil
            end
            -- 显示 技能效果
            if skillConf and skillConf.hurtEff ~= "" then
                if skillConf.hurtEffType == SkillAtkType.SINGLE or skillConf.hurtEffType == SkillAtkType.MULTIPLAYER then
                    for k,v in pairs(hurtRoleList) do
                        v:playHurtEffect(skillConf)
                    end
                    if #hurtRoleList == 0 then
                        GlobalEventSystem:dispatchEvent(FightEvent.PLAY_TOP_EFFECT,{pos = hurtPos,effID = skillConf.hurtEff})
                    end
                elseif skillConf.hurtEffType == SkillAtkType.GROUP_SURFACE then
                    if hurtPos then
                        GlobalEventSystem:dispatchEvent(FightEvent.PLAY_FOOT_EFFECT,{pos = hurtPos,effID = skillConf.hurtEff})
                    end
                elseif skillConf.hurtEffType == SkillAtkType.GROUP_SKY then
                    if hurtPos then
                        GlobalEventSystem:dispatchEvent(FightEvent.PLAY_TOP_EFFECT,{pos = hurtPos,effID = skillConf.hurtEff})
                    end
                elseif skillConf.hurtEffType == SkillAtkType.GROUP_FIRE then
                    --火墙的处理
                end
            end

            if skillConf.hurtSound ~= "" then
                SoundManager:playSound(skillConf.hurtSound)
            else
                -- 怪物受击的时候播放音效
                -- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/90b02757892445fb9b5521782b697139/
                if targerType == SceneRoleType.MONSTER then
                    local monster_id = self.vo.monster_id
                    local hurtSound = configHelper:getMonsterHurtSound(monster_id)
                    if hurtSound then
                        SoundManager:playSound(hurtSound)
                    end
                end
            end



            -- local selfBuff = FightModel:getSkillConfig(skillId).selfBuff
            -- if selfBuff and #selfBuff > 0 then
            --     for i=1,#selfBuff do
            --         local buffId = selfBuff[i]
            --         if self.vo.buffDic[10001] == nil then
            --             self:playBuff(10001,2000)
            --         end
            --     end
            -- end
        --   local _,_,str= string.find("{format_,text}", "{([^}]+)}")
        --   local list = StringUtil.split(str, ",")
end	


--获取技能没有目标时任意给的位置
--空放时除了自己为目标，其它都是根据攻击距离来获取目标
function SceneRole:getSkillNotTarPos(skillConfig,atkVO)
    local targerType = skillConfig.tarType
    local curGrid = atkVO.mGrid
  
    if targerType == SkillTargerType.SELF then --目标自己
        return curGrid
    else
        local dis = skillConfig.atkDis
        local newGrid 
        if atkVO.direction == 1 then
            newGrid = cc.p(curGrid.x,curGrid.y+dis)
        elseif atkVO.direction == 2 then
            newGrid = cc.p(curGrid.x+math.floor(dis*0.7),curGrid.y+math.floor(dis*0.7))
        elseif atkVO.direction == 3 then
            newGrid = cc.p(curGrid.x+dis,curGrid.y)
        elseif atkVO.direction == 4 then
            newGrid = cc.p(curGrid.x+math.floor(dis*0.7),curGrid.y-math.floor(dis*0.7))
        elseif atkVO.direction == 5 then
            newGrid = cc.p(curGrid.x,curGrid.y-dis)
        elseif atkVO.direction == 6 then
            newGrid = cc.p(curGrid.x-math.floor(dis*0.7),curGrid.y-math.floor(dis*0.7))
        elseif atkVO.direction == 7 then
            newGrid = cc.p(curGrid.x-dis,curGrid.y)
        elseif atkVO.direction == 8 then
            newGrid = cc.p(curGrid.x-math.floor(dis*0.7),curGrid.y+math.floor(dis*0.7))
        end
        return newGrid
    end

    return curGrid
    -- if rangeType == SkillAtkRangeType.R_SINGLE then --单体 根据距离格子内
        
    -- elseif rangeType == SkillAtkRangeType.R_N_GROUP then --近身群体
        
    -- elseif rangeType == SkillAtkRangeType.R_F_GROUP then --远程群体
        
    -- end
end
