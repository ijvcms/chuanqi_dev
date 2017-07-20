
--
-- Author: 21102585@qq.com
-- Date: 2017-6-16 10:59:16
-- 战斗模块
local SceneObjView = class("SceneObjView", BaseView)

function SceneObjView:ctor(winTag,data,winconfig)
	SceneObjView.super.ctor(self,winTag,data,winconfig)
    self.fightController = GlobalController.fight
    self.resList = {
      
    }

    self.loadingView = nil
    --底部效果层
    self.bottomLay = self:creatLayer()
    self:addChild(self.bottomLay)
    --战斗层
    self.sceneObjLay = self:creatLayer()
    self:addChild(self.sceneObjLay)
    --顶部效果层
    self.topLay = self:creatLayer()
    self:addChild(self.topLay)
     
    self.fightEffManager = FightEffectManager
    self.fightEffManager:setLay(self.bottomLay,self.topLay,self.sceneObjLay)
    
    --self.mouseClickEffUrl = "effect/mouseClick/mouseClick.ExportJson"
    local function onShowMouseClickEff(view) 
        if view.data then
            self:showClickEff(view.data.x,view.data.y)
        end
    end
    GlobalEventSystem:addEventListener(FightEvent.SHOW_MOUSE_CLICK_EFF,onShowMouseClickEff)


    --self.ackEffArmature:getAnimation():play("effect")
    --self.ackEffArmature:setPosition(0,0) 

    
    -- local action5 = cc.DelayTime:create(1.25)
    -- local action6 = cc.CallFunc:create(function () GlobalEventSystem:dispatchEvent(FightEvent.VIBRATION_SCENE) end)       
    -- self:runAction(transition.sequence({action5,action6}))  
    self.loadingType = 1
end

function SceneObjView:showClickEff(xx,yy)
    if self.mouseClickEff == nil then
        -- local aManager = ccs.ArmatureDataManager:getInstance()
        -- if aManager:getArmatureData("mouseClick") == nil then
        --     ArmatureManager:getInstance():loadEffect("mouseClick")
        --     --aManager:addArmatureFileInfo(self.mouseClickEffUrl)
        -- end
        ArmatureManager:getInstance():loadEffect("mouseClick")
        self.mouseClickEff = ccs.Armature:create("mouseClick")
        self.sceneObjLay:addChild(self.mouseClickEff)
        self.mouseClickEff:stopAllActions()
        self.mouseClickEff:getAnimation():stop()
        local function animationEvent(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
                --armatureBack:getAnimation():setMovementEventCallFunc(function()end)
                if self.mouseClickEff then
                    self.mouseClickEff:stopAllActions()
                    self.mouseClickEff:getAnimation():stop()
                    self.mouseClickEff:setVisible(false)
                end
            end
        end 
        self.mouseClickEff:getAnimation():setMovementEventCallFunc(animationEvent)
    end
    self.mouseClickEff:setVisible(true)
    self.mouseClickEff:getAnimation():play("effect")
    self.mouseClickEff:setPosition(xx,yy)
    self.mouseClickEff:setLocalZOrder(2000-yy)
end

function SceneObjView:initRoles()
    local resDic = {}
    local sceneModel = GameSceneModel
    local sceneId = sceneModel.sceneId
    local mapX = sceneModel.mapX
    local mapY = sceneModel.mapY

    self:stopAllActions()
    local roleArr = {}
    for k,v in pairs(sceneModel.playerVOArr) do
        table.insert(roleArr,v)
    end
    local playerVo = sceneModel:getPlayerVO()
    mapX = playerVo.pos.x
    mapY = playerVo.pos.y
    for k,v in pairs(sceneModel.playerCopyVOArr) do
        table.insert(roleArr,v)
    end
    for k,v in pairs(sceneModel.monsterVOArr) do
        table.insert(roleArr,v)
    end
    for k,v in pairs(sceneModel.itemVOArr) do
        table.insert(roleArr,v)
    end

    for k,v in pairs(sceneModel.collectionItemVOArr) do
        table.insert(roleArr,v)
    end

    for k,v in pairs(sceneModel.npcVOArr) do
        if FightUtil:getDistance(mapX,mapY,v.pos.x,v.pos.y) < 1600 then
            resDic[tostring(v.modelID)] = true
        end
        table.insert(roleArr,v)
    end
    for k,v in pairs(sceneModel.transferPointArr) do
        if FightUtil:getDistance(mapX,mapY,v.pos.x,v.pos.y) < 1600 then
            resDic[tostring(v.modelID)] = true
        end
        table.insert(roleArr,v)
    end
    for k,v in pairs(sceneModel.petVOArr) do
        table.insert(roleArr,v)
    end
    for k,v in pairs(sceneModel.fireWallVOArr) do
        table.insert(roleArr,v)
    end
    local len = table.getn(roleArr)
    self.listIndex = 1

    if self.parentView then
        self.parentView:setVisible(false)
    end
    self.loadingType = 1
    -- local confResList = configHelper.getInstance():getScenePreLoadingBySceneId(sceneId)
    -- for i=1,table.getn(confResList) do
    --     resDic[tostring(confResList[i])] = true
    -- end
    local resList = {}

    if self.fightController.resMansterIdDic then
        for i=1,#self.fightController.resMansterIdDic do
            table.insert(resList,tostring(self.fightController.resMansterIdDic[i]))
        end
    end

    if self.fightController.resCancheWeaponIdDic then
        for i=1,#self.fightController.resCancheWeaponIdDic do
            resDic[tostring(self.fightController.resCancheWeaponIdDic[i])] = true
        end
    end
    if self.fightController.resCancheClothesIdDic then
        for i=1,#self.fightController.resCancheClothesIdDic do
            resDic[tostring(self.fightController.resCancheClothesIdDic[i])] = true
        end
    end
    if self.fightController.resCancheWingIdDic then
        for i=1,#self.fightController.resCancheWingIdDic do
            resDic[tostring(self.fightController.resCancheWingIdDic[i])] = true
        end
    end

    --ArmatureManager:getInstance():clear(resDic)
    for k,v in pairs(resDic) do
        table.insert(resList,k)
    end

     resDic = nil
    local resLen = table.getn(resList)
    local manager = ccs.ArmatureDataManager:getInstance()

    local beginLen = math.floor((resLen+len)/2)
    if beginLen > 50 then
        beginLen = 50
    elseif beginLen < 10 then
        beginLen = 10
    end
    local beginIndex = 3

    local listenerFun =  function()
        if self.loadingType == 1 then
            if beginIndex < beginLen then
                beginIndex = beginIndex +1
                GlobalEventSystem:dispatchEvent(GlobalEvent.UPDATE_SCENE_LOADING,(beginIndex)/(resLen+len+beginLen))
            else
                self.loadingType =2
            end
            return
        end

        if self.loadingType == 2 or self.loadingType == 3 then

            if self.loadingType == 2 and table.getn(resList) > 0 then
                self.loadingType = 3
                local resID = table.remove(resList,1)
                local function backFun(armatureData,num)
                    self.loadingType = 2
                end
                if cc.FileUtils:getInstance():isFileExist(ResUtil.getModel(resID)) and ArmatureManager:getInstance():getFreeMemory()>10 then
                    ArmatureManager:getInstance():loadModel(resID,backFun)
                else
                    backFun(nil)
                end

                GlobalEventSystem:dispatchEvent(GlobalEvent.UPDATE_SCENE_LOADING,(resLen-table.getn(resList)+beginLen)/(resLen+len+beginLen))
            elseif self.loadingType == 3 then
            else
                self.loadingType = 10
            end
            return
        end

-- local function backFun(armatureData,num)
--             if self.vo and armatureData  then
--                 if self.armature == nil then
--                     self.armature = ccs.Armature:create(modelID)
--                     --self.armatureWing:setPosition(0,0)
--                     self.modelLayer:addChild(self.armature)
--                 else
--                     self.armature:init(modelID)
--                 end
--                 self.armature:getAnimation():setSpeedScale(self.animationSpeed)
--                 self.armature:stopAllActions()    
--                 self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)

--                 local posx,posy = self.vo:getPosition()
--                 self:setRolePosition(posx,posy)  
--                 self:setModelScaleX()
--             end
--         end
--         ArmatureManager:getInstance():loadModel(modelID,backFun)


        if self.loadingType ~= 10 then return end

        local v = roleArr[self.listIndex]
        if v == nil then
            return
        end
        -- local role = SceneRole.new(v)
        -- role:setPosition(v.pos.x,v.pos.y)
        -- self.sceneObjLay:addChild(role,v.pos.y)
        -- role:setLocalZOrder(2000-v.pos.y)

        if v.type == SceneRoleType.NPC then
            if FightUtil:getDistance(mapX,mapY,v.pos.x,v.pos.y) < 1200 then
                self.fightController:addRoleModel(v)
            end
        else
            self.fightController:addRoleModel(v)
        end
        
        GlobalEventSystem:dispatchEvent(GlobalEvent.UPDATE_SCENE_LOADING,(self.listIndex+resLen+beginLen)/(resLen+len+beginLen))
        
        if len == self.listIndex then
            GlobalTimer.unscheduleGlobal(self.timerIds)
            GlobalController.fight:playSchedule()
            self.timerIds = nil
            if self.parentView and self.parentView.sceneUI and self.parentView.sceneUI.minimap then
                self.parentView.sceneUI.minimap:open()
            end
           
            GlobalEventSystem:dispatchEvent(GlobalEvent.UPDATE_SCENE_LOADING,1)
            
            local action0 = cc.DelayTime:create(0.3)
            local action11 = cc.CallFunc:create(function()
                --模型创建完成执行开始战斗
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SCENE_LOADING,false)
                if self.parentView then
                    self.parentView:setVisible(true)
                end
                if sceneId == 31002 then
                    GlobalEventSystem:dispatchEvent(SceneEvent.BOSS_SKILL_TIPS, {isOpen = true,id = "全场怪物被杀数量达到阶段目标时刷新特定怪物"})
                end
                if sceneId == 20017 then
                    self:showCountDownWin()
                else
                    self.fightController.fightStates = FightStates.FIGHTING
                end

                -- 跨服幻境之城 切换场景人物不要乱跑! -By:gxg.2017.1.22
                local is_dreamland = false
                local instance_conf = configHelper:getCopyInfo(sceneId)
                if instance_conf ~= nil then
                    if instance_conf.instanceType ~= nil and instance_conf.instanceType == 16 then
                        is_dreamland = true
                    end
                end
                if not is_dreamland and sceneId ~= 32115 then
                    SceneManager:playRunSceneTransfer(true)
                end

                local bgMusic = getConfigObject(sceneId,ActivitySceneConf).music
                GameNet:sendMsgToSocket(11038)
                
                SoundManager:playMusic(bgMusic,true)

                if not GlobalModel.isGaming then
                    -- 登陆进入游戏进度条完毕，把这个标识设置为true，代表刚进入游戏，已经在开始游戏中。
                    GlobalModel.isGaming = true
                    GlobalEventSystem:dispatchEvent(GlobalEvent.ENTER_GAME)
                end
                if GlobalModel.firstInitScene == false then
                    GlobalModel.firstInitScene = true
                    GameNet:sendMsgToSocket(32037, {})
                end
                GameNet:sendMsgToSocket(11037)
                if GameSceneModel.isInterService then
                     --GameNet:sendMsgToSocket(11047)
                end
            end) 
            self:runAction(transition.sequence({action0,action11}))

        end
        self.listIndex = self.listIndex + 1
    end
    if self.timerIds == nil then
        self.timerIds =  GlobalTimer.scheduleUpdateGlobal(listenerFun)
    end
end    


function SceneObjView:showCountDownWin()
    local QualifyingCountDownView = import("app.modules.qualifying.view.QualifyingCountDownView")

    -- 使用
    local view = QualifyingCountDownView:new()
    view:Start()
    view:SetOnCompleteCallback(function(ref)
        -- 这里处理
        self.fightController.fightStates = FightStates.FIGHTING
        ref:Destory()
    end)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, view)
end


function SceneObjView:setParantView(view)
    self.parentView = view
end

function SceneObjView:open()
    SceneObjView.super.open(self)
end

local function _removeEvent(self)
    if self.timerIds then 
        GlobalTimer.unscheduleGlobal(self.timerIds)
        self.timerIds = nil
    end 
end

--关闭界面
function SceneObjView:close()
    if self.mouseClickEff and self.mouseClickEff:getParent() then
        self.mouseClickEff:getAnimation():setMovementEventCallFunc(function()end)
        self.mouseClickEff:stopAllActions()
        self.mouseClickEff:getAnimation():stop()
        self.mouseClickEff:getParent():removeChild(self.mouseClickEff)
        self.mouseClickEff = nil
    end
    SceneObjView.super.close(self)
    _removeEvent(self)
    --ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self.mouseClickEffUrl)
end

--清理界面
function SceneObjView:destory()
    _removeEvent(self)
    self:stopAllActions()
    for _,resItem in ipairs(self.resList or {}) do
         display.removeSpriteFrameByImageName(resItem) 
    end
    self.resList = {}
    GlobalEventSystem:removeEventListener(FightEvent.SHOW_MOUSE_CLICK_EFF)
    
    if self.mouseClickEff then
        self.mouseClickEff = nil
    end
    --ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self.mouseClickEffUrl)

    SceneObjView.super.destory(self)
    -- if self.battle ~= nil then
    --    self.battle:destory()
    -- end
    -- self.fightEffManager:destory()
end  


return SceneObjView