--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-28 21:02:37
-- 游戏对象场景
local SceneMainView = class("SceneMainView", function() return display.newNode() end)
function SceneMainView:ctor()
    self.touchBtnDic = {}  --多点触摸记录触目的是那个点
    self.sceneId = -1 
    self.yaoganXX = 0
    self.yaoganYY = 0

    --地图块
    --self.mapBlock = require("common.scene.SceneMapBlockLayOld").new()
    self.mapBlock = require("common.scene.SceneMapBlockLay").new()
    self.mapBlock:setAnchorPoint(cc.p(0,0))
    self:addChild(self.mapBlock)
    self.mapBlock:setTouchEnabled(true)

    --战斗层
    self.battle = require("app.gameScene.display.SceneObjView").new()
    -- self.battle.id = self.data.id
    self:addChild(self.battle)
    self.battle:setParantView(self)

    -- --场景上的效果
    -- self.effLay = display.newNode()
    -- self.effLay:setTouchEnabled(false)
    -- self:addChild(self.effLay)



    self.ctrlLay = display.newNode()
    self.ctrlLay:setTouchEnabled(true)
    self.ctrlLay:setTouchSwallowEnabled(false)
    self:addChild(self.ctrlLay)

    self.touchLay = display.newNode()
    self.touchLay:setContentSize(display.width, display.height)
    self.touchLay:setTouchEnabled(true)
    self.touchLay:setTouchSwallowEnabled(false)
    self:addChild(self.touchLay)

    self.touchLay:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    self.touchLay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        self:onSceneTouch(event)
        return true
    end)


    self.sceneUI = require("app.gameScene.view.MainSceneUI").new()
    self:addChild(self.sceneUI)
    self.sceneUI:open()

    -- self.uiLay = display.newNode()
    -- self.uiLay:setTouchEnabled(false)
    -- self:addChild(self.uiLay)

    -- local function onShockScene(view)
    --     self:showHitRedWarn()
    -- end
    -- GlobalEventSystem:addEventListener(FightEvent.VIBRATION_SCENE,onShockScene)
    -- GlobalEventSystem:addEventListener(FightEvent.SHOW_FIGHT_RESULT,handler(self, self.showResult))

    local showResureg = function(data)
        self:onShowResureg(data.data)
    end
    GlobalEventSystem:addEventListener(FightEvent.SHOW_RESURGE,showResureg)

    self.sceneRoleId = 0
    self.clickTime = socket.gettime()
    
    self.yaogan= display.newNode()
    --self.yaogan:setPosition(130,120+60)
    self.ctrlLay:addChild(self.yaogan)

    self.yaoganLay = display.newNode()
    self.yaogan:addChild(self.yaoganLay)

    self.yaoganBg=  display.newSprite("#scene/scene_ygBg.png")
    self.yaoganLay:addChild(self.yaoganBg)
    self.yaoganBg:setAnchorPoint(0.5,0.5)

    self.yaoganBall =  display.newSprite("#scene/scene_ygPic.png")
    self.yaoganLay:addChild(self.yaoganBall)
    self.yaoganBall:setAnchorPoint(0.5,0.5)
    self.yaoganLay:setPosition(75,75)
    self.yaoganBall:setOpacity(60)
    self.yaoganBg:setVisible(false)

    self.yaogan:setPosition(48,78)
    self.yaogan:setContentSize(222, 238)
    --self.yaoganLay:setVisible(false)
    --self.yaogan:setTouchEnabled(true)
    self.yaogan:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
                local role = GlobalController.fight:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
                if role ~= nil and role.vo.states == RoleActivitStates.MOVE then 
                    --role:setStates(RoleActivitStates.STAND)
                end        
                self.yaoganBall:setOpacity(255)
                self.yaoganBg:setVisible(true)
                --设置遥感
                local point = self.yaoganLay:convertToNodeSpace(cc.p(event.x, event.y))
                FightModel.userYaoGan = true
                self.yaoganXX = point.x
                self.yaoganYY = point.y

                self.yaoganLay:setPosition(self.yaogan:convertToNodeSpace(cc.p(event.x, event.y)))

                -- if math.sqrt(point.x*point.x+point.y*point.y) < 30 then
                --     self.yaoganBall:setPosition(point.x,point.y)
                -- else
                --     local scale = 30/math.sqrt(point.x*point.x+point.y*point.y)
                --     self.yaoganBall:setPosition(point.x*scale,point.y*scale)
                --     --self.yaoganBall:setPosition(xx,yy)
                -- end

                self.yaoGanNX = nil
                self.yaoGanNY = nil
                -- if self.yaoganTimerId == nil then
                --     self.yaoganTimerId = GlobalTimer.scheduleUpdateGlobal(handler(self,self.PlayYaoGan))
                --     self.yaoganLay:setVisible(true)
                -- end

                return true
        elseif event.name == "moved" then
            self.yaoganBall:setOpacity(255)
            self.yaoganBg:setVisible(true)
            FightModel.userYaoGan = true
            local point = self.yaoganLay:convertToNodeSpace(cc.p(event.x, event.y))
            self.yaoganXX = point.x
            self.yaoganYY = point.y
            if math.sqrt(point.x*point.x+point.y*point.y) < 30 then
                self.yaoganBall:setPosition(point.x,point.y)
            else
                local scale = 30/math.sqrt(point.x*point.x+point.y*point.y)
                self.yaoganBall:setPosition(point.x*scale,point.y*scale)
            end
	    if self.yaoganTimerId == nil then
                    self.yaoganTimerId = GlobalTimer.scheduleUpdateGlobal(handler(self,self.PlayYaoGan))
                    self.yaoganLay:setVisible(true)
            end
        elseif event.name == "ended" then
                self.yaoganBall:setOpacity(60)
                self.yaoganBg:setVisible(false)
            self.yaoganBall:setPosition(0,0)
            FightModel.userYaoGan = false
            if self.yaoganTimerId then
                 GlobalTimer.unscheduleGlobal(self.yaoganTimerId)
                 self.yaoganTimerId = nil
            end
        end       
        return true
    end)

    self.touchPointList = {}   --记录触摸点
    self.isSceneUIhide = false --场景UI是否隐藏，用来记录手势
end



--场景触摸事件
-- "<var>" = {
-- [LUA-print] -     "mode"  = 1
-- [LUA-print] -     "name"  = "moved"
-- [LUA-print] -     "phase" = "targeting"
-- [LUA-print] -     "prevX" = 179
-- [LUA-print] -     "prevY" = 275.99996948242
-- [LUA-print] -     "x"     = 183
-- [LUA-print] -     "y"     = 277.99996948242
-- [LUA-print] - }

function SceneMainView:dispatchSceneTouch(event)
    if self.touchBtnDic[event.id] then
        self.touchBtnDic[event.id]:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
        if self.yaoganEventId == event.id and event.name == "moved" then
            self.isSceneClick = false
        elseif self.yaoganEventId == event.id and event.name == "moved" then

        end
    else
        if event.name == "began" then
            if  self.yaogan and self.yaogan:isVisible() and cc.rectContainsPoint(self.yaogan:getBoundingBox(), cc.p(event.x,event.y)) then
                self.touchBtnDic[event.id] = self.yaogan
                self.yaogan:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
                self.yaoganEventId = event.id
                --self.isSceneClick = true
            end
            if  self.skillView and self.skillView:isVisible() and self.skillView:containePoint(cc.p(event.x,event.y)) then
                self.touchBtnDic[event.id] = self.skillView
                self.skillView:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
                self.isSceneClick = false 
            end

            if  self.sceneUI.skillView and self.sceneUI.skillView:isVisible() and self.sceneUI.skillView:containePoint(cc.p(event.x,event.y)) then
                self.touchBtnDic[event.id] = self.sceneUI.skillView
                self.sceneUI.skillView:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
                self.isSceneClick = false
            end
        end
    end
end

function SceneMainView:onSceneTouch(event)
        if event.name == "began" then --接受第一个点
            self.setMount = false
            self.setSceneInfoWin = false
            self.isSceneClick = true
            for id, point in pairs(event.points) do
                self.touchPointList[point.id] = {bx = point.x,by=point.y,ex=-1,ey=-1,id = point.id,state = "began",mode = 1,name = "began",x = point.x, y = point.y}
                self:dispatchSceneTouch(self.touchPointList[point.id])
            end
        elseif event.name == "added" then --接受第2,3个点 同begin
            self.isSceneClick = false
            for id, point in pairs(event.points) do
                self.touchPointList[point.id] = {bx = point.x,by=point.y,ex=-1,ey=-1,id = point.id,state = "began",mode = 1,name = "began",x = point.x,y= point.y}
                self:dispatchSceneTouch(self.touchPointList[point.id])
            end
        elseif event.name == "moved" then  --移动的点
            for id, point in pairs(event.points) do
                local p = self.touchPointList[point.id]
                if p then
                    p.ex = point.x
                    p.ey = point.y
                    p.state = "moved"

                    p.name = "moved"
                    p.x = point.x
                    p.y= point.y
                    self:dispatchSceneTouch(p)
                end
            end
            -- 屏蔽双手收拢和放开控制UI
            -- local p0 = self.touchPointList["0"]
            -- local p1 = self.touchPointList["1"]
            -- if p0 and p1 and p0.state == "moved" and p1.state == "moved" then
            --     local disb = FightUtil:getDistance(p0.bx,p0.by,p1.bx,p1.by) 
            --     local dise = FightUtil:getDistance(p0.ex,p0.ey,p1.ex,p1.ey)
            --     if disb+30 <= dise then
            --         if self.isSceneUIhide == false then
            --              self.isSceneUIhide = true
            --              GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_UI_HIDE,self.isSceneUIhide)
            --         end
            --     elseif disb > dise +30 then
            --         if self.isSceneUIhide then
            --             self.isSceneUIhide = false
            --             GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_UI_HIDE,self.isSceneUIhide)
            --         end
            --     end
            -- end

            -- 屏蔽双手向上和向下控制坐骑上和下
            local p0 = self.touchPointList["0"]
            local p1 = self.touchPointList["1"]
            --if p0 and p1 and p0.state == "moved" and p1.state == "moved" then
            if p0 and p0.state == "moved" then
                --if p0.y > p0.by +60 and p1.y > p1.by +60 then
                if self.setMount == false then
                    if p0.y > p0.by +120 then --and p1.y > p1.by +60 then
                        --向上
                        local fightCon = GlobalController.fight
                        local role = fightCon:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
                        if role and role.vo.states == RoleActivitStates.STAND then
                            role:setMountsUP(true)
                            self.isSceneClick = false
                            self.setMount = true
                        end
                    --elseif p0.y < p0.by -60 and p1.y < p1.by -60 then
                    elseif p0.y < p0.by -120 then --and p1.y < p1.by -60 then
                        --向下
                        local fightCon = GlobalController.fight
                        local role = fightCon:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
                        if role and role.vo.states == RoleActivitStates.STAND then
                            role:setMountsUP(false)
                            self.isSceneClick = false
                            self.setMount = true
                        end
                    end
                end
                if self.setSceneInfoWin == false then
                    if p0.x > p0.bx +250 then 
                        --向右
                        if self.sceneUI then
                            self.sceneUI:showSceneinfoWin(true)
                            self.isSceneClick = false
                            self.setSceneInfoWin = true
                        end
                    elseif p0.x < p0.bx -250 then
                        --向左
                        if self.sceneUI then
                            self.sceneUI:showSceneinfoWin(false)
                            self.isSceneClick = false
                            self.setSceneInfoWin = true
                        end
                    end
                end
            end
        elseif event.name == "removed" then --点离开
            for id, point in pairs(event.points) do
                local p = self.touchPointList[point.id]
                if p then
                    p.name = "ended"
                    p.x = point.x
                    p.y= point.y
                end
                self:dispatchSceneTouch(p)
                self.touchPointList[point.id] = nil
                self.touchBtnDic[point.id] = nil
            end
        elseif event.name == "ended" or event.name == "cancelled" then --最后一个点离开
            --处理点击
            local p0 = self.touchPointList["0"]
            if p0 and self.isSceneClick then --p0.state == "began" then 有时候会有移动
                self:sceneClickHandler(p0.bx,p0.by)
            end
            for id, point in pairs(event.points) do
                local p = self.touchPointList[point.id]
                if p then
                    p.name = "ended"
                    p.x = point.x
                    p.y= point.y
                end
                self:dispatchSceneTouch(p)
                self.touchPointList[point.id] = nil
                self.touchBtnDic[point.id] = nil
            end
            self.touchPointList = {}
            GlobalEventSystem:dispatchEvent(SceneEvent.HIDE_NAV)
        end
    return true
end

--场景点击事件
function SceneMainView:sceneClickHandler(xx,yy)

            if  socket.gettime() - self.clickTime < 0.2 then return end
            self.clickTime = socket.gettime()
            local player = GlobalController.fight:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
            if player == nil or player.vo.states == RoleActivitStates.DEAD then return end

            local fightCon = GlobalController.fight
            local nodePoint = self.battle:convertToNodeSpace(cc.p(xx, yy))
            -- table.insert(self.pointt, {nodePoint.x,nodePoint.y})
            -- if #self.pointt > 50 then
            --     for i=1,#self.pointt do
            --         print("{"..math.floor(self.pointt[i][1])..","..math.floor(self.pointt[i][2]).."},")
            --     end
            -- end
            --print(nodePoint.x,nodePoint.y)

            local cGrid= FightUtil:pointToGrid(nodePoint.x,nodePoint.y)
            --如果有选中的技能，则玩家点击场景就是在放技能
            local fightSelSkill = RoleManager:getInstance():getFightSelectSkill()
            if fightSelSkill and fightSelSkill:getSkillLock() then

                RoleManager:getInstance().nextUseSkillID = fightSelSkill.skillID
                RoleManager:getInstance().nextUseSkillPoint = cGrid
                return
            end




            local yy = 100000
            local curRoleVo = nil
            for k,v in pairs(fightCon.monsterViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy then
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.soldierViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy then
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.playerViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy and v.vo.id ~= GlobalModel.player_id then
                    -- v:setSelect(true)
                    -- return
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.playerCopyViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy and v.vo.id ~= GlobalModel.player_id then
                    -- v:setSelect(true)
                    -- return
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.npcViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy then
                    -- v:setSelect(true)
                    -- return
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.petViewArr) do
                if v:containsPoint(nodePoint) and v.vo.pos.y < yy then
                    -- v:setSelect(true)
                    -- return
                    yy = v.vo.pos.y
                    curRoleVo = v.vo
                end
            end

            for k,v in pairs(fightCon.collectionItemViewArr) do

                if v:containsPoint(nodePoint) and v.vo.pos.y < yy then
                    SceneManager:playerMoveToCollectioinItemByVO(v.vo)
                    return
                end
            end
            
            
            FightModel.atkByDefaultSkill = false
            local curSelAtkTarVO = FightModel:getSelAtkTarVO()
            if curRoleVo and curSelAtkTarVO then
                if curRoleVo and curSelAtkTarVO.id == curRoleVo.id and curRoleVo.type == curSelAtkTarVO.type then
                    --如果是同一个人
                    FightModel.atkByDefaultSkill = true
                else
                    --todo
                    local role = fightCon:getRoleModel(curSelAtkTarVO.id,curSelAtkTarVO.type)
                    if role then
                        role:setSelect(false)
                    end
                    FightModel:setSelAtkTarVO(nil)
                end
            end

             if curRoleVo then
                if curRoleVo.type ~= SceneRoleType.NPC then
                    FightModel:setSelAtkTarVO(curRoleVo)
                    -- local role = fightCon:getRoleModel(curRoleVo.id,curRoleVo.type)--setSelAtkTarVO已经有这个代码
                    -- role:setSelect(true)
                end
                if curRoleVo.type == SceneRoleType.NPC then
                    SceneManager:playerMoveToNPCByVO(curRoleVo)
                end
                return true
            end
            local cPoint= FightUtil:gridToPoint(cGrid.x,cGrid.y)
            
            if GameSceneModel:getMapGridIsOpen(cGrid) then
                GlobalEventSystem:dispatchEvent(FightEvent.SHOW_MOUSE_CLICK_EFF,cPoint)
            end

            if player == nil then
                player = GlobalController.fight:getRoleModel(1,SceneRoleType.PLAYER)
            end

            if player == nil then return end
            local xx,yy = player:getPosition()
            local rGrid= FightUtil:pointToGrid(xx,yy)
       
            if fightSelSkill == nil then
                SceneManager:playerMoveTo(GameSceneModel.sceneId,cGrid)
                self:clearCollectBar(player)
            end

               
end

--遥感
function SceneMainView:PlayYaoGan()
    local fightCon = GlobalController.fight
    local role = fightCon:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
    --print("PlayYaoGan",role.vo.states,role,self.yaoganXX,self.yaoganYY)
    if role == nil or role.vo.states == RoleActivitStates.PRE_ATTACK or role.vo.states == RoleActivitStates.DEAD or role.vo.states == RoleActivitStates.ATTACK then 
        return 
    end
    if self.yaoganXX == 0 and self.yaoganYY == 0 then
        return
    end
    
    self.setSceneInfoWin = true
    local playerVO = role.vo

    local ang = (cc.pToAngleSelf(cc.p(self.yaoganXX,self.yaoganYY))*180)/math.pi
    local direct = FightUtil:getDirectByAngle(ang)
   
    local nextGrid = cc.p(playerVO.mGrid.x,playerVO.mGrid.y)
    if direct == 1 then
        nextGrid.y = nextGrid.y+1
    elseif direct == 2 then
        nextGrid.y = nextGrid.y+1
        nextGrid.x = nextGrid.x+1
    elseif direct == 3 then
        nextGrid.x = nextGrid.x+1
    elseif direct == 4 then
        nextGrid.y = nextGrid.y-1
        nextGrid.x = nextGrid.x+1
    elseif direct == 5 then
        nextGrid.y = nextGrid.y-1
    elseif direct == 6 then
        nextGrid.y = nextGrid.y-1
        nextGrid.x = nextGrid.x-1
    elseif direct == 7 then
        nextGrid.x = nextGrid.x-1
    elseif direct == 8 then
        nextGrid.y = nextGrid.y+1
        nextGrid.x = nextGrid.x-1
    end
    
    if GameSceneModel:getMapGridIsOpen(nextGrid) and (self.yaoGanNX ~= nextGrid.x or self.yaoGanNY ~= nextGrid.y)  then
        self.yaoGanNX = nextGrid.x
        self.yaoGanNY = nextGrid.y
        FightModel:setAutoAttackStates(false)
        role:roleMoveTo({nextGrid})
        self:clearCollectBar(role)
        GlobalEventSystem:dispatchEvent(SceneEvent.HIDE_NAV)
    end
end

function SceneMainView:clearCollectBar(player)
    if player.collectBar then
        GameNet:sendMsgToSocket(11060,{state = 0})
        player:showCollectBar(0)
    end
    GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_COLLECT_BAR,{isOpen = false})
end

 
--打开界面
function SceneMainView:open()
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SCENE_LOADING,true)

    local fightModel = FightModel

    self.yaogan:setVisible(true)
    --self:showSkillView()
    self:showActivitySceneUI()

   

    if self.mapBlock then
        local param = {
            fightScene = self.battle,
            mapId = GameSceneModel.sceneId,
            mapW = GameSceneModel.sceneWidth,
            mapH = GameSceneModel.sceneHeight,
           -- screenW = 640,
           -- screenH = 960,
        }
        self.mapBlock:open(param)
    end

    if self.battle then
        self.battle:open()
        self.battle:setContentSize(cc.size(GameSceneModel.sceneWidth, GameSceneModel.sceneHeight))
        self.battle:initRoles()
    end
    if self.relativeView then
        self.relativeView:destory()
        self.relativeView:setVisible(false)
        --self.relativeView = nil
    end
    self:openSound()
    self.sceneId = GameSceneModel.sceneId
end


--关闭界面
function SceneMainView:close()

    if self.battle then
        self.battle:close()
    end
    self.mapBlock:destory()
    GlobalController.model:destory()
    self:closeSound()
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SCENE_LOADING,true)

    -- GlobalController.fight:destory()
    -- FightModel:clear()
    FightModel.userYaoGan = false
    if self.yaoganTimerId then
        GlobalTimer.unscheduleGlobal(self.yaoganTimerId)
        self.yaoganTimerId = nil
    end
    if self.shocktimers then
        GlobalTimer.unscheduleGlobal(self.shocktimers)
        self.shocktimers = nil
    end
    -- if self.hitRedWarn then
    --     self.effLay:removeChild(self.hitRedWarn)
    --     self.hitRedWarn = nil
    -- end
end

--清理界面
function SceneMainView:destory()

    if self.battle then
        self.battle:destory()
    end
    self.touchBtnDic = {}
    self:closeActivitySceneUI()
    self:close()
    if self.result ~= nil then
      --self.result:close()
      --self.result:destory()
    end 

    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SCENE_LOADING,false)

  

    -- GlobalEventSystem:removeEventListener(FightEvent.VIBRATION_SCENE)
    -- GlobalEventSystem:removeEventListener(FightEvent.SHOW_FIGHT_RESULT)

    GlobalEventSystem:removeEventListener(FightEvent.SHOW_RESURGE)
    --  if self.updateHomeEventId then
    --     GlobalEventSystem:removeEventListenerByHandle(self.updateHomeEventId)
    --     self.updateHomeEventId = nil
    -- end
    GlobalController.fight.sceneRoleLay = nil
    -- GlobalEventSystem:removeEventListenerByHandle(self.uiShowId)
    -- GlobalEventSystem:removeEventListenerByHandle(self.uiHideId)
    -- GlobalEventSystem:removeEventListenerByHandle(self.progressId)
    
end  


function SceneMainView:onCloseClick()
    if self.pause == nil or self.pause == 0 then 
        GlobalController.fight:pause()
        self.pause = 1
    else
        self.pause = 0
        GlobalController.fight:resume()
    end
  -- for k,v in pairs(GlobalController.fight.roleGroup1ViewArr) do       
  --   if v.vo.roleId == 1 then
  --     v:playultimate(10002001)
      
  --   end
  -- end
    GlobalWinManger:closeWin(self.winTag)
end	

function SceneMainView:openSound()
    --audio.playMusic("sound/sound_scene_2.mp3", true)--背景音乐，只能是一个
    audio.setMusicVolume(0.3)
    -- audio.preloadSound("sound/sound_a_1.mp3") 
    -- audio.preloadSound("sound/sound_a_2.mp3") 
    -- audio.preloadSound("sound/sound_win.mp3") 
    -- audio.preloadSound("sound/sound_d_1.mp3")
    -- audio.preloadSound("sound/sound_a_3.mp3")
    -- audio.preloadSound("sound/sound_a_4.mp3")  
end  

function SceneMainView:closeSound()
    audio.stopMusic(true)
    audio.stopAllSounds()
    -- audio.unloadSound("sound/sound_a_1.mp3")
    -- audio.unloadSound("sound/sound_a_2.mp3")
    -- audio.unloadSound("sound/sound_win.mp3")
    -- audio.unloadSound("sound/sound_d_1.mp3")
    -- audio.unloadSound("sound/sound_a_3.mp3")
    -- audio.unloadSound("sound/sound_a_4.mp3")
end


--震动场景
function SceneMainView:shockScene()
    self.shockPoint = {{10,10},{0,0},{-10,-10},{0,0},{10,10},{-10,-10},{0,0}}
    local listenerFun =  function()
        local len = table.getn(self.shockPoint) 
        if len <= 0 then
            GlobalTimer.unscheduleGlobal(self.shocktimers)
            self.shocktimers = nil
            return
        end 
        self.mapBlock:setPosition(cc.p(self.shockPoint[1][1],self.shockPoint[1][2]))
        table.remove(self.shockPoint,1)
    end
    if self.shocktimers == nil then    
        self.shocktimers =  GlobalTimer.scheduleUpdateGlobal(listenerFun)
    end
end

--显示  FightEvent.VIBRATION_SCENE
-- function SceneMainView:showHitRedWarn()
--     if self.hitRedWarn == nil then
--         self.hitRedWarn = display.newScale9Sprite("common/warnRedpic.png", 0, 0, cc.size(display.width,display.height))
--         self.hitRedWarn:setAnchorPoint(cc.p(0, 0))
--         --self.hitRedWarn:setPosition(display.width,display.height)
--         self.effLay:addChild(self.hitRedWarn)
--     end


--     self.shockPoint = {4,16,64,128,192,255,224,192,160,128,64,16,4,0}
--     self.hitRedWarn:setOpacity(0)
--     local listenerFun =  function()
--         local len = table.getn(self.shockPoint) 
--         if len <= 0 then
--             GlobalTimer.unscheduleGlobal(self.shocktimers)
--             self.shocktimers = nil
--             if self.hitRedWarn then
--                 self.effLay:removeChild(self.hitRedWarn)
--                 self.hitRedWarn = nil
--             end
--             return
--         end 
--         self.hitRedWarn:setOpacity(self.shockPoint[1])
--         table.remove(self.shockPoint,1)
--     end
--     if self.shocktimers == nil then
--         self.shocktimers =  GlobalTimer.scheduleUpdateGlobal(listenerFun)
--     end
-- end


function SceneMainView:showResult(data)
    -- --结果层
    -- self.result = require("app.modules.fight.view.FightResult").new(data)
    -- self.result:open()
    -- self.uiLay:addChild(self.result, 2)
end


--显示活动场景UI
function SceneMainView:showActivitySceneUI()
    -- if self.sceneUI == nil then
    --     self.sceneUI = require("app.gameScene.view.MainSceneUI").new()
    --     self.uiLay:addChild(self.sceneUI)
    --     self.sceneUI:open()

    --     -- self.addRoleBtn = require("app.modules.mainUI.scenePeopleTest").new()
    --     -- self.uiLay:addChild(self.addRoleBtn)
    --     -- self.addRoleBtn:setPosition(300,400)
    -- end
    self.sceneUI:changScene()
end
function SceneMainView:closeActivitySceneUI()
    if self.sceneUI then
        self.sceneUI:destory()
        self:removeChild(self.sceneUI)
        self.sceneUI = nil
    end
end

-- --显示技能
-- function SceneMainView:showSkillView()
--     if self.skillView == nil then
--         self.skillView = require("app.gameScene.view.SceneSkillUI").new()
--         self.ctrlLay:addChild(self.skillView)
--         local pos 
--         if GlobalModel.hideNavigation == false then
--             pos = 165
--         else
--             pos = 115
--         end
--         self.skillView:setPosition(display.width - 20, pos)
--         self.otherBtnLyr:setPosition(display.width - 20, pos)
--     end
--     self.otherBtnLyr:setVisible(true)
--     self.skillView:open()
-- end
-- --显示技能
-- function SceneMainView:closeSkillView()
--     if self.skillView then
--         self.skillView:destory()
--         self:removeChild(self.skillView)
--         self.skillView = nil
--     end
--     self.otherBtnLyr:setVisible(false)
-- end
-- -- 更新技能位置，如下移动和上移动
-- function SceneMainView:updateSkillViewPos()
--     local pos 
--     if GlobalModel.hideNavigation == false then
--         pos = cc.p(display.width - 20,165)
--     else
--         pos = cc.p(display.width - 20,115)
--     end
--     if self.skillView then
--         self.skillView:stopAllActions()
--         local action1 = cc.MoveTo:create(0.15, pos)
--         self.skillView:runAction(action1)
--     end
--     if self.skillView then
--         local action1 = cc.MoveTo:create(0.15, pos)
--         self.otherBtnLyr:stopAllActions()
--         self.otherBtnLyr:runAction(action1)
--     end
-- end

--显示复活页面
function SceneMainView:onShowResureg(data)
    if GameSceneModel.sceneId == 32107 then
        GlobalWinManger:openWin(WinName.GVGFUHUOWIN,data)
    else
        GlobalWinManger:openWin(WinName.RESURGE,data)
    end

    -- if self.relativeView == nil then
    --     local relativeRect = require("app.modules.fight.view.FightResurgeView")
    --     self.relativeView = relativeRect.new(data)
    --     --self.relativeView:setPosition(display.cx,display.cy)
    --     self.uiLay:addChild(self.relativeView)
    -- end
    --  GlobalWinManger:closeWin(self.winTag)
    -- self.relativeView:init(data)
    -- self.relativeView:open()
    -- self.relativeView:setVisible(true)
end

return SceneMainView