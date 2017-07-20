--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-28 21:02:37
-- 游戏场景主UI
local MainSceneUI = class("MainSceneUI", function()
    return display.newNode()
end)

local TopNavigationView = import("app.modules.mainUI.TopNavigationView")
local GoodsUtil = require("app.utils.GoodsUtil")

function MainSceneUI:ctor(data)
    display.addSpriteFrames("resui/mainUIButton.plist", "resui/mainUIButton.png")
    --角色头像
    self.roleHeadUI = require("app.gameScene.view.RoleHeadUI").new()
    self:addChild(self.roleHeadUI)
    self.roleHeadUI:setPosition(0,display.height - 158)

    if self.sceneChatList == nil then
        self.sceneChatList = require("app.gameScene.view.SceneChatList").new(cc.size(228,100))
         self.sceneChatList:setVisible(false)
         --self.sceneChatList:setPosition(display.cx - 114, 102)
         self.sceneChatList:setPosition(0, 222)
         self:addChild(self.sceneChatList)
    end

    --任务
    self.taskUI = require("app.gameScene.view.TaskUI").new()
    self:addChild(self.taskUI)
    self.taskUI:setPosition(0, display.height-158-160)


    if self.bottomExpHpUI == nil then
        self.bottomExpHpUI = require("app.gameScene.view.BottomExpHpUI").new(self)
        self:addChild(self.bottomExpHpUI)
    end

    --聊天
    if self.sceneChatBtn == nil then
        self.sceneChatBtn = require("app.gameScene.view.SceneChatBtn").new()
        self:addChild(self.sceneChatBtn)
        self.sceneChatBtn:setPosition(26,200)
    end

    --右边按钮
    self.rightTopLay = display.newNode()
    self:addChild(self.rightTopLay)
    --self.rightTopLay:setContentSize(cc.size(657, 103))
    self.rightTopLay:setPosition(display.width,display.height)
    --玩家头像
    --[[
    self.roleHeadUI = display.newNode()
    self:addChild(self.roleHeadUI)
    self.roleHeadUI:setContentSize(cc.size(657, 103))
    self.roleHeadUI:setPosition(0,display.height-103)
    --]]
    -- Boss和其他外加的层
    self.playOhterHeadLay = display.newNode()
    self:addChild(self.playOhterHeadLay)
    self.playOhterHeadLay:setContentSize(cc.size(657, 103))
    self.playOhterHeadLay:setPosition(0,display.height-103)
    -- 顶部导航栏
    self.topNavBar = TopNavigationView.new()
    self.rightTopLay:addChild(self.topNavBar)
    --
    self:createUI(GlobalController.fight.copyInfo)

    self.topBtnItemList = {}
    self.topBtnConfig = {
        -- [1] = {win = WinName.SHABAKE,icon = "#scene_sbkBtn.png"},
        -- [2] = {win = WinName.QUALIFYINGWIN,icon = "#scene_qualifyingBtn.png"},
        -- [3] = {win = WinName.DAILYTASKWIN,icon = "#mainUIDailyTask.png"},
        
    }
self.number = 1
    --DEBUG按钮
    if DEBUG ~= 0 then
        self.addItemBtn = display.newSprite("#scene/scene_addGroupBtn.png")
        self:addChild(self.addItemBtn)
        self.addItemBtn:setPosition(20,display.height-20)
        self.addItemBtn:setTouchEnabled(true)
        self.addItemBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
         if  event.name == "ended" then
            --GlobalWinManger:openWin(WinName.CHALLENGEBOSSWIN,{type = 2})
            GlobalWinManger:openWin(WinName.ADDITEMWIN)--SHENGHUANGMJ WinName.NPCTRANSFER
            -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo()) --getDescription
            -- GlobalWinManger:openWin(WinName.INVESTWIN) -- LUCKTURNPLATE2WIN
            GlobalAlert:show("zheng = "..(1/cc.Director:getInstance():getAnimationInterval()))
            --
            -- cc.Director:getInstance():getAnimationInterval()
            self.number = self.number +1
            local str = "<font color='f4e6d5' size='16' opacity='255'>"..self.number.."达到<font color='00ff0d' size='16' opacity='255'>60级以上</font>的玩家可以进入排名，结束时等级排名前3的玩家获得排名奖励，邮件发送。</font>", "<font color='f4e6d5' size='16' opacity='255'>在活动结束时，等级达到45、50、55的玩家可以获得全民奖励，邮件发送。</font>"
        --GlobalController.guide:startGuide(20008, 2)
--SystemNotice:inviteGuildNotice({GuildName = 1,PlayerName = "ffff",GuildId = 1234})

--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, require("app.modules.tips.view.AgreementView").new())
            SystemNotice:showWorldNotice({content = str,priority = 1})
            
            device.openURL("http://www.baidu.com")
            
           --  local NoticeView = import("app.com.systemNotice.view.NoticeView")
           --  local view = NoticeView.new()
           -- self:addChild(view)
           --SystemNotice:popAttValueTips(100,1)
           --GlobalWinManger:openWin(WinName.BUSINESSWIN)
            --self:openCopyReward({})

            -- self:test()

            -- GlobalMessage:alert({
            --   enterTxt = "确定",
            --   backTxt= "取消",
            --   tipTxt = "是否寻路到对应的NPC？hk/n\njashdfkahsdfkahsdfkahdfkadhfkhewui/n\nfhaksdhfkajdhfweufhkad/n\nshfkjahdsfkjahsdfewuihf/n\nkajsdhfkjashdfkjahsdfkj/n\nahsdfkjahd",
            --   enterFun = enterFun,
            --   tipShowMid = true
            -- })

            --GlobalWinManger:openWin(WinName.TIMEACTIVITY)
            --GlobalWinManger:openWin(WinName.INTERSERVISE)
            --GlobalWinManger:openWin(WinName.GVGWIN,{caster_name = "FFFF",fh_vip_num= 3})
         elseif event.name == "began" then
            
         end       
            return true
        end)
    end

    self.isUIHide = false
    self.flyShoesNum = 0 --飞鞋数量

    self.minimap = require("app.modules.mainUI.SceneSmallMap").new()
    self:addChild(self.minimap)
    self.minimap:setPosition(display.width-120,display.height-66)
    self.monsterId = 00

end


function MainSceneUI:test()

end


--场景怪物信息面板
function MainSceneUI:showSceneinfoWin(bool)
    if bool then
        if self.sceneInfo == nil then
            self.sceneInfo = require("app.modules.mainUI.SceneInfoWin").new(self)
            self:addChild(self.sceneInfo)
            self.sceneInfo:setPosition(0,0)
            self.sceneInfo:open()
        end
    else
        if self.sceneInfo then
            self.sceneInfo:destory()
            self:removeChild(self.sceneInfo)
            self.sceneInfo = nil
        end
    end
end

function MainSceneUI:addMonster()
         self.monsterId = self.monsterId +1000
    -- local selfvo = GlobalController.fight:getSelfPlayerModel().vo


    -- local xx = selfvo.pos.x
    -- local yy = selfvo.pos.y
    -- local tipLabel = FightEffectManager:getHurtLabEff(self.monsterId,1,xx,yy)
    -- if tipLabel then
    --     local t = math.random(0,10)/100
    --     if acttype == 1 then
    --         local k = -1
    --         if t > 0.05 then
    --             k = 1
    --         end
    --         transition.execute(tipLabel, cc.MoveBy:create(0.5+t, cc.p(k*30, 150)), {
    --         --delay = 0.15,
    --         easing = "Out",
    --         onComplete = function()
    --             tipLabel:setVisible(false)
    --             FightEffectManager:addHurtLabEff(tipLabel)
    --            -- local pare = self.tipLabel:getParent()
    --            -- if pare ~= nil then               
    --            --       pare:removeChild(tipLabel)
    --            -- end
    --         end,
    --         })
    --     else
    --         transition.execute(tipLabel, cc.MoveBy:create(0.2+t, cc.p(0, 100)), {
    --         delay = 0.15,
    --         --easing = "backOut",
    --         onComplete = function()
    --             tipLabel:setVisible(false)
    --             FightEffectManager:addHurtLabEff(tipLabel)
    --             -- local pare = self.tipLabel:getParent()
    --             -- if pare ~= nil then              
    --             --      pare:removeChild(self.tipLabel)
    --             -- end
    --         end,
    --         })
    --     end
    -- end


    -- if true then return end

    local fight = GlobalController.fight
    local selfvo = fight:getSelfPlayerModel().vo

            local vo = SceneRoleVO.new()


            vo.mGrid = cc.p(selfvo.mGrid.x,selfvo.mGrid.y)
            vo.pos = cc.p(selfvo.pos.x,selfvo.pos.y)
            vo.movePos = cc.p(selfvo.pos.x+math.random(-200,200),selfvo.pos.y+math.random(-200,200))
            vo.id = self.monsterId   --唯一id
            vo.type = SceneRoleType.MONSTER--场景角色类型
            vo.direction = 2  --模型方向
            vo.monster_id = 6015
            vo.hp = 200 --当前气血
            vo.hp_limit = 200
            vo.totalhp = 200 --总气血
            vo.mp = 200
            vo.mp_limit = 200
            
            -- vo.guildId = role.guild_id
            -- vo.teamId = role.team_id
            -- vo.nameColor = role.name_colour

            -- vo.ownerId = role.owner_flag.id

            vo.name = ""
            vo.enmity = nil
            if vo.enmity and vo.enmity.monster_id ~= 0 then
                local mConf = getConfigObject(vo.enmity.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
                vo.enmity.modelID = mConf.resId
            end

            vo:updateBaseInfo()


            fight:addSceneRole(vo)

end


--更新顶部按钮
function MainSceneUI:updateTopBtn()
    local posx = -213 + 110
    for i=#self.topBtnConfig,1,-1 do
        local conf = self.topBtnConfig[i]
        if FunctionOpenManager:getFunctionOpenByWinName(conf.win) then
            local item = self.topBtnItemList[i]
            local isNew = false
            if item == nil then
                isNew = true
                item = display.newSprite(conf.icon)
                self.topBtnItemList[i] = item
                item:setVisible(false)
                item:setPosition(posx-86,-42)
                self.rightTopLay:addChild(item)
                item:setTouchEnabled(true)
                item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                    if event.name == "began" then
                        item:setScale(1.1)
                    elseif event.name == "ended" then
                        item:setScale(1)
                        if FunctionOpenManager:getFunctionOpenByWinName(conf.win) then
                            GlobalWinManger:openWin(conf.win)
                        else
                            FunctionOpenManager:showFunctionOpenTips(conf.win)
                        end
                    end             
                    return true         
                end)
            end
            item:stopAllActions()
            if isNew then
                local action1 = cc.DelayTime:create(0.2)
                local action2 = cc.CallFunc:create(function()
                    item:setVisible(true)
                    item:setScale(0.1)
                end)
                local action3 = cc.ScaleTo:create(0.1, 1, 1)
                item:runAction(transition.sequence({action1,action2,action3}))
            else
                local action1 = cc.MoveTo:create(0.15, cc.p(posx-86,-42))
                item:runAction(action1)
            end
            posx = posx - 86
        end
    end

end

function MainSceneUI:setSceneUIHide(bool)
    if bool ~= self.isUIHide then
        self.isUIHide = bool
        if self.isUIHide then
            self:playHideUIAction(self.rightTopLay,display.width,display.height+200)
            --self:playHideUIAction(self.otherRoleHead,400,display.height - 35+200)
            self:playHideUIAction(self.roleHeadUI,0,display.height-103+200)
            --self:playHideUIAction(self.addItemBtn,40,display.height-150+200)
        else
            self:playShowUIAction(self.rightTopLay,display.width,display.height)
            --self:playShowUIAction(self.otherRoleHead,400,display.height - 35)
            self:playShowUIAction(self.roleHeadUI,0,display.height-103)
            --self:playShowUIAction(self.addItemBtn,40,display.height-150)
        end
    end
end
--场景UI隐藏动作
function MainSceneUI:playHideUIAction(display,xx,yy)
    display:stopAllActions()
    local action1 = cc.MoveTo:create(0.2, cc.p(xx,yy))
    local action2 = cc.CallFunc:create(function() 
        display:setVisible(false) 
            end)
    local action4 = transition.sequence({action1,action2})
    display:runAction(action4)
end
--场景UI显示动作
function MainSceneUI:playShowUIAction(display,xx,yy)
    display:stopAllActions()
    display:setVisible(true) 
    local action1 = cc.MoveTo:create(0.2, cc.p(xx,yy))
    local action4 = transition.sequence({action1})
    display:runAction(action4)
end
 

--计时器更新
function MainSceneUI:update()
    local curSelAtkTarVO = FightModel:getSelAtkTarVO()
    if self.AberrancePalaceTips then
        self.AberrancePalaceTips:setVisible(self.topNavBar:getIsHide())
    end
    if curSelAtkTarVO and curSelAtkTarVO.states ~= RoleActivitStates.DEAD then
        if curSelAtkTarVO.mConf and curSelAtkTarVO.mConf.type == 3 then
            self:showTargetHead(curSelAtkTarVO)
        else
            if self.selTarId ~= curSelAtkTarVO.id then
                self.selTarId = curSelAtkTarVO.id
            end

            if GameSceneModel.sceneId == 20404 then
                self:showTargetHead(curSelAtkTarVO,true)
            else
                self:showTargetHead(curSelAtkTarVO)
            end
            
        end
    else
        if self.sceneTargetHead then
            self.sceneTargetHead:setVisible(false)
        end
    end
end


function MainSceneUI:showTargetHead(vo)
    if self.sceneTargetHead == nil then
        self.sceneTargetHead = require("app.gameScene.view.TargetHead").new("resui/targetHead.ExportJson","")
        self.playOhterHeadLay:addChild(self.sceneTargetHead)
        self.sceneTargetHead:setPosition(240,38)
    end
    self.sceneTargetHead:setData(vo)
    self.sceneTargetHead:setVisible(true)
end

function MainSceneUI:showFunctionOpenPrize(data)
    if data.data.isOpen == true then
        if self.functionOpenTipsBtn == nil then
            self.functionOpenTipsBtn = require("app.modules.mainUI.FunctionOpenTipsBtn").new()
            self:addChild(self.functionOpenTipsBtn)
            self.functionOpenTipsBtn:setPosition(display.width - 64,display.height - 144)
            --self.functionOpenTipsBtn:setScale(0.9)
        end
        self.functionOpenTipsBtn:open(data.data.conf,data.data.hasPrize)

        if GameSceneModel.sceneConfig.showExit == 0 then
            self.functionOpenTipsBtn:setVisible(true)
        else
            self.functionOpenTipsBtn:setVisible(false)
        end
    else
        if self.functionOpenTipsBtn then
            self.functionOpenTipsBtn:destory()
            self:removeChild(self.functionOpenTipsBtn)
            self.functionOpenTipsBtn = nil
        end
    end
end

--boss释放必杀技能提示
function MainSceneUI:bossSkillTips(data)
     if data.data.isOpen == true then
        local bossSkillTipsView = require("app.modules.mainUI.BossReleaseSkillTips").new()
        self:addChild(bossSkillTipsView)
        bossSkillTipsView:setPosition(display.cx,200)
        bossSkillTipsView:open(data.data.id)
    end
end

--显示采集条
function MainSceneUI:showCollectionBar(bool,data)
    self.visibleCollectionBar = bool
    if self.visibleCollectionBar then
        if self.collectionLay == nil then
            self.collectionLay = require("app.modules.mainUI.CollectionProgressBar").new()
            self:addChild(self.collectionLay)
            self.collectionLay:setPosition(display.cx,display.cy)
        end
        self.collectionLay:open(data)
    else
        if self.collectionLay then
            self.collectionLay:destory()
            self:removeChild(self.collectionLay)
            self.collectionLay = nil
        end
        FightModel.pauseAutoAtk = false
    end
end



-- 副本ui
function MainSceneUI:initCopyUI()
    if self.copyLayer then
        self.copyLayer:destory()
        self.copyLayer = nil
    end
    self.copyLayer = require("app.modules.copy.view.CopyTip").new()
    self:addChild(self.copyLayer)
    self.copyLayer:setPosition(0, self.roleHeadUI:getPositionY()  - self.copyLayer:getContentSize().height)
    self.copyLayer:setView(GlobalController.fight.copyInfo)
end
--副本计算结果
function MainSceneUI:openCopyReward(data)

    local copyReward = require("app.modules.copy.view.CopyRewardView").new()
    copyReward:setViewInfo(data)

    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,copyReward)
end

--屠龙大会ui

function MainSceneUI:initDragonUI()
    if self.dragonLayer then
        self.dragonLayer:destory()
        self.dragonLayer = nil
    end
    self.dragonLayer = require("app.modules.dragon.view.DragonList").new()
    self:addChild(self.dragonLayer)
    self.dragonLayer:setPosition(0, self.roleHeadUI:getPositionY() - 255 - self.dragonLayer:getContentSize().height)
    
end
--胜者为王
function MainSceneUI:initWinnerUI()
    if self.winnerLayer then
        self.winnerLayer:destory()
        self.winnerLayer = nil
    end
    self.winnerLayer = require("app.modules.winner.view.WinnerList").new()
    self:addChild(self.winnerLayer)
    self.winnerLayer:setPosition(0, self.roleHeadUI:getPositionY() - 255 - self.winnerLayer:getContentSize().height)
 
end

--怪物攻城
function MainSceneUI:initMonsterAttackUI()
    if self.monsterAttackLayer then
        self.monsterAttackLayer:destory()
        self.monsterAttackLayer = nil
    end
    self.monsterAttackLayer = require("app.modules.monsterAttack.view.MonsterAttackProgress").new()
    self:addChild(self.monsterAttackLayer)
    self.monsterAttackLayer:setPosition(0, self.roleHeadUI:getPositionY() - 158 - self.monsterAttackLayer:getContentSize().height)
 
end

--个人boss副本
function MainSceneUI:initBossCopyUI()
    if self.bossCopyLayer then
        self.bossCopyLayer:destory()
        self.bossCopyLayer = nil
    end
    self.bossCopyLayer = require("app.modules.copy.view.BossCopyProgress").new()
    self:addChild(self.bossCopyLayer)
    self.bossCopyLayer:setPosition(0, self.roleHeadUI:getPositionY() - 158 - self.bossCopyLayer:getContentSize().height)
 
end

-- 跨服幻境之城
function MainSceneUI:initDreamlandUI()
    if self.dreamlandLayer then
        self.dreamlandLayer:close()
        self.dreamlandLayer = nil
        if self.topNavBar then
            self.topNavBar:setDreamlandTipsView(nil)
        end
    end
    self.dreamlandLayer = require("app.modules.dreamland.view.DreamlandBattleTip").new()
    self:addChild(self.dreamlandLayer)
    self.dreamlandLayer:setPosition(display.width - self.dreamlandLayer:getContentSize().width - 180.0, display.height - self.dreamlandLayer:getContentSize().height)
    if self.topNavBar then
        self.topNavBar:setDreamlandTipsView(self.dreamlandLayer)
        --self.dreamlandLayer:setVisible(self.topNavBar:getIsHide())
    end
   -- self.dreamlandLayer:open()

end

function MainSceneUI:createUI(data)

    if self.copyLayer then
        self.copyLayer:destory()
        self.copyLayer = nil
    end

    if self.dragonLayer then
        self.dragonLayer:destory()
        self.dragonLayer = nil
    end

    if self.winnerLayer then
        self.winnerLayer:destory()
        self.winnerLayer = nil
    end

    if self.monsterAttackLayer then
        self.monsterAttackLayer:destory()
        self.monsterAttackLayer = nil
    end

    if self.bossCopyLayer then
        self.bossCopyLayer:destory()
        self.bossCopyLayer = nil
    end

    if self.dreamlandLayer then
        self.dreamlandLayer:close()
        self.dreamlandLayer = nil
        if self.topNavBar then
            self.topNavBar:setDreamlandTipsView(nil)
        end
    end
    if data and data.flag == 1 then
        GlobalEventSystem:dispatchEvent(TaskEvent.NAV_HIDE)
        if data.tag then
            if data.tag == 5 then
                self:initDragonUI()
            elseif data.tag == 7 then
                self:initWinnerUI()
            elseif data.tag == 8 then
                self:initMonsterAttackUI()
            elseif data.tag == 9 then
                self:initBossCopyUI()
            elseif data.tag == 15 or data.tag == 16 or data.tag == 17 or data.tag == 18 then
                -- 跨服幻境之城 15大厅 16房间
                self:initDreamlandUI()
                -- 显示组队
                GlobalEventSystem:dispatchEvent(TaskEvent.NAV_SHOW)
            else
                self:initCopyUI()
            end
        end
    else
        GlobalEventSystem:dispatchEvent(TaskEvent.NAV_SHOW)
  
    end 

end

function MainSceneUI:open()
    --GlobalEventSystem:dispatchEvent(SceneEvent.RESET_NAV_CHILD)
    if self.onResetNavChildEventId then
        self.onResetNavChildEventId = GlobalEventSystem:addEventListener(SceneEvent.RESET_NAV_CHILD,function(data)
            if self.bottomExpHpUI then
                self.bottomExpHpUI:resetCurItem()
            end
        end)
    end

    --显示导航栏
    if self.showNavigationEventHandler == nil then
        self.showNavigationEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NAVIGATION, function(data)
            self:onShowNavigation(data.data)
        end)
    end

    --显示装备二级菜单
    if self.showNavigationSubEventHandler == nil then
        self.showNavigationSubEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NAVIGATION_EQUIP_SUB, function(data)
            self:onShowEquipSubMenuView()
        end)
    end
 
    if self.updateTimeEventId == nil then
        self.updateTimeEventId =  GlobalTimer.scheduleGlobal(handler(self,self.update),0.5)
    end
 
    if self.onSceneUIHideEventId == nil then
        local function onSceneUIHide(data)
            self:setSceneUIHide(data.data)
        end
        self.onSceneUIHideEventId = GlobalEventSystem:addEventListener(SceneEvent.SCENE_UI_HIDE,onSceneUIHide)
    end

    if self.showCollectionEventId == nil then
        local function onShowCollectionBar(data)
            self:showCollectionBar(data.data.isOpen,data.data)
        end
        self.showCollectionEventId = GlobalEventSystem:addEventListener(SceneEvent.SHOW_COLLECT_BAR,onShowCollectionBar)
    end

    if self.bossReleaseSkillEventId == nil then
        self.bossReleaseSkillEventId = GlobalEventSystem:addEventListener(SceneEvent.BOSS_SKILL_TIPS,handler(self,self.bossSkillTips))
    end

    if self.functionOpenPrizeEventId == nil then
        self.functionOpenPrizeEventId = GlobalEventSystem:addEventListener(SceneEvent.FUNCTION_OPEN_PRIZE_TIPS,handler(self,self.showFunctionOpenPrize))
    end

    if self.gvgTimeEventId == nil then
        --self.gvgTimeEventId = GlobalEventSystem:addEventListener(GvgEvent.GVG_CHANG_TIME,handler(self,self.showLuangDouTime))
    end
   
    -- GameNet:sendMsgToSocket(13012)
    -- GameNet:sendMsgToSocket(13013)
    -- GameNet:sendMsgToSocket(13006)

    ActiveSceneUI = self

    if self.functionOpenEventId == nil then
        self.functionOpenEventId = GlobalEventSystem:addEventListener(GlobalEvent.UPDATE_FUNCTION_OPEN,handler(self,self.updateTopBtn))
    end
    self:updateTopBtn()

    if self.showautoRoadEventId == nil then
        self.showautoRoadEventId = GlobalEventSystem:addEventListener(SceneEvent.SHOW_AUTO_ROAD,handler(self,self.showAutoRoad))
    end
    if self.AutoFightingEventId == nil then
        self.AutoFightingEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_AUTO_ATTACK,handler(self,self.showAutoFighting))
    end

    if self.copyEntercopyEventId == nil then
        self.copyEntercopyEventId = GlobalEventSystem:addEventListener(CopyEvent.COPY_ENTERCOPY, function(data)
            self:createUI(data.data)
            end)
    end

    --打开签到界面
    if not GlobalController.fight.hadOpenSign and FunctionOpenManager:getFunctionOpenByWinName(WinName.SIGNWIN) then
         local function onOpenSign(data)
            GlobalEventSystem:removeEventListenerByHandle(self.openSignEventId)
            self.openSignEventId = nil
            GlobalController.fight.hadOpenSign = true

            local today = tonumber(os.date("%d"))
            data = data.data
   
            local find = false
            for i=1,#data.sign_list do
                if today == data.sign_list[i] then
                    find = true
                    break
                end
            end
          
            if not find  then
                GlobalWinManger:openWin(WinName.WELFAREWIN)
            end

        end

        if self.openSignEventId == nil then
            self.openSignEventId = GlobalEventSystem:addEventListener(GlobalEvent.OPEN_SIGN,onOpenSign)
        end
        --GameNet:sendMsgToSocket(32006)
        --GlobalController.welfare:requestSignList()
    end

    self:onShowNavigation({visible = false})
end


--跳转场景
function MainSceneUI:changScene()

    self:showSkillView()
    
    if GameSceneModel.sceneConfig.hide and self.topNavBar then
        if GameSceneModel.sceneConfig.hide == 0 then
            self.topNavBar:setBtnVisible(true)
        else
            self.topNavBar:setBtnVisible(false)
        end
    elseif  self.topNavBar then
        self.topNavBar:setBtnVisible(false)
    end

    if GameSceneModel.sceneConfig.showExit == 0 then
        if self.functionOpenTipsBtn then
            self.functionOpenTipsBtn:setVisible(true)
        end
        self:showLeaveSceneBtn(false)
    else
        if self.functionOpenTipsBtn then
            self.functionOpenTipsBtn:setVisible(false)
        end
        self:showLeaveSceneBtn(true)
    end
    
    if GameSceneModel.isInterService then
        if self.interServiceTimeBtn == nil then
            self.interServiceTimeBtn = require("app.modules.mainUI.InterServiceTimeBtn").new()
            self:addChild(self.interServiceTimeBtn)
            self.interServiceTimeBtn:setPosition(display.width-240,display.height-190)
        end
        self.interServiceTimeBtn:open()
        --GlobalEventSystem:dispatchEvent(SceneEvent.INTER_SERVICE_TIME_UPDATE,{num = 2222})
        if self.taskUI then
            self.taskUI:showTeamView()
        end
        if self.topNavBar then
            -- 跨服副本,右上方只显示商城?
            self.topNavBar:hideBtnExceptIdList({21})
        end
    else
        if self.interServiceTimeBtn then
            self.interServiceTimeBtn:destory()
            self:removeChild(self.interServiceTimeBtn)
            self.interServiceTimeBtn = nil
        end
        if self.topNavBar then
            self.topNavBar:showAllBtnList()
        end
    end
    if (GameSceneModel.sceneId >= 31002 and GameSceneModel.sceneId <= 31004) or  (GameSceneModel.sceneId >= 32109 and GameSceneModel.sceneId <= 32111) or GameSceneModel.sceneId == 32108 then
        self:showHouLongTips(true)
    else
        self:showHouLongTips(false)
    end
    if RoleManager:getInstance():isInterServer() then
        GameNet:sendMsgToSocket(10017,{push_list={17092}})
        self:showUnionMermberBtn(true)
    else
        self:showUnionMermberBtn(false)
    end

    if GameSceneModel.sceneId == 32115 then
        if self.topNavBar then
            -- 跨服副本,右上方只显示商城?
            self.topNavBar:hideBtnExceptIdList({21})
        end
    end

    if (GameSceneModel.sceneId >= 32122 and GameSceneModel.sceneId <= 32125) then
        self:showAberrancePalaceTips(true)
        if self.topNavBar then
            self.topNavBar:hideBtnExceptIdList({21})
        end
    else
        self:showAberrancePalaceTips(false)
    end


    -- if GameSceneModel.sceneId == 32107 then
    --     self:showLuangDouView(true)
    --     self.taskUI:hide()
    -- else
    --     self:showLuangDouView(false)
    --     self.taskUI:show()
    -- end
end

--显示离开副本按钮
function MainSceneUI:showLeaveSceneBtn(bool)
    if bool then
        if self.leaveSceneBtn == nil then
            self.leaveSceneBtn = display.newSprite("#scene/scene_returnBackBtn.png")
            self:addChild(self.leaveSceneBtn)
            self.leaveSceneBtn:setPosition(display.width - 57,display.height - 140)
            self.leaveSceneBtn:setTouchEnabled(true)
            self.leaveSceneBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
             if  event.name == "ended" then
                self.leaveSceneBtn:setScale(1)
                if GameSceneModel.sceneConfig.exit_confirm and GameSceneModel.sceneConfig.exit_confirm == 1 then
                    GlobalMessage:alert({
                        enterTxt = "确定",
                        backTxt = "返回",
                        tipTxt = "         是否确定离开副本\n(部分场景离开后将不会保留掉落物品)",
                        enterFun = handler(self, self.backCopyScene),
                     -- backFun = gotoScene,
                    })  
                else
                    self:backCopyScene()
                end
             elseif event.name == "began" then
                self.leaveSceneBtn:setScale(1.1)
             end       
                return true
            end)
        end
        self.leaveSceneBtn:setVisible(true)
    else
        if self.leaveSceneBtn then
            self.leaveSceneBtn:setVisible(false)
        end
    end
end
--退出副本场景
function MainSceneUI:backCopyScene()
    GameNet:sendMsgToSocket(11016)
    GlobalController.guide:notifyEventWithConfirm(CLICK_MAIN_QUIT)
end

--乱斗倒计时
function MainSceneUI:showLuangDouTime(data)
    if self.luangdouTimeView == nil then
        self.luangdouTimeView = require("app.modules.gvg.GvgLuangdouTime").new()
        self:addChild(self.luangdouTimeView)
        self.luangdouTimeView:setPosition(display.width/2,display.height/2-100)    
    end
    self.luangdouTimeView:open(data.data)
end


--联盟按钮
function MainSceneUI:showLuangDouView(bool)
    if bool then
        if self.luangdouView == nil then
            self.luangdouView = require("app.modules.gvg.GvgLeftView").new()
            self:addChild(self.luangdouView)
            self.luangdouView:setPosition(0,display.height - 410)
            
        end
        self.luangdouView:open()
    else
        if self.luangdouView then
            self.luangdouView:close()
             self:removeChild(self.luangdouView)
            self.luangdouView = nil
        end
    end
end

--联盟按钮
function MainSceneUI:showUnionMermberBtn(bool)
    if bool then
        if self.unionBtn == nil then
            self.unionBtn = display.newSprite("#btn_union.png")
            self:addChild(self.unionBtn)
            self.unionBtn:setPosition(264,400)
            self.unionBtn:setTouchEnabled(true)
            self.unionBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                 if  event.name == "ended" then
                    GlobalWinManger:openWin(WinName.UNIONWIN)
                 elseif event.name == "began" then
                    
                 end       
                    return true
                end)
        end
    else
        if self.unionBtn then
            self:removeChild(self.unionBtn)
            self.unionBtn = nil
        end
    end
end

function MainSceneUI:showAberrancePalaceTips(bool)
    if bool then
        if self.AberrancePalaceTips == nil then
            self.AberrancePalaceTips = require("app.modules.mainUI.AberrancePalaceTips").new()
            self:addChild(self.AberrancePalaceTips)
            --self.AberrancePalaceTips:setPosition(self.taskUI:getContentSize().width/2 - 24, self.roleHeadUI:getPositionY() + 72)
        end
        GlobalEventSystem:dispatchEvent(GlobalEvent.HIDE_TOP_NAV_BAR)
        self.AberrancePalaceTips:open()
    else
        if self.AberrancePalaceTips then
            self.AberrancePalaceTips:destory()
            self:removeChild(self.AberrancePalaceTips)
            self.AberrancePalaceTips = nil
        end
    end
    --self.AberrancePalaceTips = require("app.modules.mainUI.AberrancePalaceTips").new()
    --self:addChild(self.AberrancePalaceTips)
   -- self.AberrancePalaceTips:setPosition(self.taskUI:getContentSize().width/2 - 24, self.roleHeadUI:getPositionY() + 72)

end

function MainSceneUI:showHouLongTips(bool)
    if bool then
        if self.huolongTipsView == nil then
            self.huolongTipsView = require("app.modules.mainUI.HuolongCopyTip").new()
            self:addChild(self.huolongTipsView)
            self.huolongTipsView:setPosition(display.width - 340,display.height)
            if self.topNavBar then
                self.topNavBar:setHuoLongTipsView(self.huolongTipsView)
                self.huolongTipsView:setVisible(self.topNavBar:getIsHide())
            end
        end
        self.huolongTipsView:open()
    else
        if self.huolongTipsView then
            self.huolongTipsView:destory()
             self:removeChild(self.huolongTipsView)
            self.huolongTipsView = nil
            if self.topNavBar then
                self.topNavBar:setHuoLongTipsView(nil)
            end
        end
    end
end
function MainSceneUI:onShowNavigation(param)
    if self.bottomExpHpUI then
        if param.visible then
            self.bottomExpHpUI:setViewVisible(true)
        else
            self.bottomExpHpUI:setViewVisible(false)
        end
    end
end

function MainSceneUI:onShowEquipSubMenuView()
    if self.bottomExpHpUI then
        self.bottomExpHpUI:showEquipSubMenuView()
    end
end



--显示技能
function MainSceneUI:showSkillView()
    if self.skillView == nil then
        self.skillView = require("app.gameScene.view.SceneSkillUI").new()
        self:addChild(self.skillView)
        local pos 
        if GlobalModel.hideNavigation == false then
            pos = display.width + 225
        else
            pos = display.width - 10
        end
        self.skillView:setPosition(pos, 42)
        --self.otherBtnLyr:setPosition(display.width - 20, pos)
    end
    --self.otherBtnLyr:setVisible(true)
    self.skillView:open()
end
--显示技能
function MainSceneUI:closeSkillView()
    if self.skillView then
        self.skillView:destory()
        self:removeChild(self.skillView)
        self.skillView = nil
    end
    --self.otherBtnLyr:setVisible(false)
end
-- 更新技能位置，如下移动和上移动
function MainSceneUI:updateSkillViewPos()
    local pos 
    if GlobalModel.hideNavigation == false then
        pos = cc.p(display.width +225,42)
    else
        pos = cc.p(display.width -10,42)
    end
    if self.skillView then
        self.skillView:stopAllActions()
        local action1 = cc.MoveTo:create(0.15, pos)
        self.skillView:runAction(action1)
    end
    if self.skillView then
        local action1 = cc.MoveTo:create(0.15, pos)
        --self.otherBtnLyr:stopAllActions()
        --self.otherBtnLyr:runAction(action1)
    end
end

function MainSceneUI:close()
    if self.sceneTargetHead then
        self.sceneTargetHead:destory()
        self.sceneTargetHead = nil
    end
    if self.luangdouTimeView then
        self.luangdouTimeView:close()
        self.luangdouTimeView = nil
    end
     if self.luangdouView then
            self.luangdouView:close()
             self:removeChild(self.luangdouView)
            self.luangdouView = nil
    end
    if self.interServiceTimeBtn then
        self.interServiceTimeBtn:destory()
        self:removeChild(self.interServiceTimeBtn)
        self.interServiceTimeBtn = nil
    end
    self:showAberrancePalaceTips(false)
    self:showHouLongTips(false)
    self:showCollectionBar(false,0)
    self:showSceneinfoWin(false)

    self:showFunctionOpenPrize({data = {isOpen = false}})
    
    if self.minimap then
        self.minimap:close()
    end
    if self.taskUI then
        self.taskUI:close()
    end

    if self.sceneAutoEff then
        self.sceneAutoEff:close()
    end

    if self.showNavigationEventHandler then
        GlobalEventSystem:removeEventListenerByHandle(self.showNavigationEventHandler)
        self.showNavigationEventHandler = nil
    end
    if self.showNavigationSubEventHandler then
        GlobalEventSystem:removeEventListenerByHandle(self.showNavigationSubEventHandler)
        self.showNavigationSubEventHandler = nil
    end
    if self.showCollectionEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.showCollectionEventId)
        self.showCollectionEventId = nil
    end
    if self.bossReleaseSkillEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.bossReleaseSkillEventId)
        self.bossReleaseSkillEventId = nil
    end
    if self.functionOpenPrizeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.functionOpenPrizeEventId)
        self.functionOpenPrizeEventId = nil
    end

    if self.copyEntercopyEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.copyEntercopyEventId)
        self.copyEntercopyEventId = nil
    end
    if self.openSignEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.openSignEventId)
        self.openSignEventId = nil
    end

    if self.openHandUpEventId == nil then
        GlobalEventSystem:removeEventListenerByHandle(self.openHandUpEventId)
         self.openHandUpEventId = nil
    end

    if self.showautoRoadEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.showautoRoadEventId)
        self.showautoRoadEventId = nil
    end
    if self.functionOpenEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.functionOpenEventId)
        self.functionOpenEventId = nil
    end

    if self.updateTimeEventId then
        GlobalTimer.unscheduleGlobal(self.updateTimeEventId)
        self.updateTimeEventId = nil
    end
 
    if self.onSceneUIHideEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.onSceneUIHideEventId)
        self.onSceneUIHideEventId = nil
    end

    if self.AutoWayEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.AutoWayEventId)
        self.AutoWayEventId = nil
    end

    if self.AutoFightingEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.AutoFightingEventId)
        self.AutoFightingEventId = nil
    end

    if self.copyLayer then
        self.copyLayer:close()
    end
    if self.taskNav then
        self.taskNav:close()
        self.taskNav:removeSelf()
    end

    if self.roleHeadUI then
        self.roleHeadUI:close()
        self.roleHeadUI = nil
    end
    if self.sceneChatBtn then
        self.sceneChatBtn:destory()
        self.sceneChatBtn = nil
    end

    if self.sceneChatList then
        self.sceneChatList:destory()
        self.sceneChatList = nil
    end

    if self.bottomExpHpUI then
        self.bottomExpHpUI:destory()
        self.bottomExpHpUI:removeSelf()
        --self:removeChild(self.bottomExpHpUI)
        self.bottomExpHpUI = nil
    end

    -- 跨服幻境之城
    if self.dreamlandLayer then
        self.dreamlandLayer:close()
        self.dreamlandLayer = nil
        if self.topNavBar then
            self.topNavBar:setDreamlandTipsView(nil)
        end
    end

    if self.monsterAttackLayer then
        self.monsterAttackLayer:close()
        self.monsterAttackLayer = nil
    end

    if self.bossCopyLayer then
        self.bossCopyLayer:close()
        self.bossCopyLayer = nil
    end

    if self.winnerLayer then
        self.winnerLayer:close()
        self.winnerLayer = nil
    end

    if self.dragonLayer then
        self.dragonLayer:close()
        self.dragonLayer = nil
    end
    self:closeSkillView()
end

function MainSceneUI:destory()
    self:close()
end

-- 显示自动战斗
function MainSceneUI:showAutoFighting(data)
    if FightModel:getAutoAttackStates(true) then
        if self.sceneAutoEff == nil then
            self.sceneAutoEff = require("app.gameScene.view.SceneAutoTipEff").new()
            self:addChild(self.sceneAutoEff)
            self.sceneAutoEff:setPosition(display.cx,236)
        end
        self.sceneAutoEff:setVisible(true)
        self.sceneAutoEff:showAutoFighting()
    else
        if self.sceneAutoEff then
            self.sceneAutoEff:showAutoFighting()
        end
    end
end
--显示自动寻路
function MainSceneUI:showAutoRoad(data)
    if data.data then
        FightModel.autoWayStates = true
        if self.sceneAutoEff == nil then
            self.sceneAutoEff = require("app.gameScene.view.SceneAutoTipEff").new()
            self:addChild(self.sceneAutoEff)
            self.sceneAutoEff:setPosition(display.cx,236)
        end
        self.sceneAutoEff:setVisible(true)
        self.sceneAutoEff:showAutoWay()
    else
        FightModel.autoWayStates = false
        if self.sceneAutoEff then
            self.sceneAutoEff:showAutoWay()
        end
    end
end

return MainSceneUI