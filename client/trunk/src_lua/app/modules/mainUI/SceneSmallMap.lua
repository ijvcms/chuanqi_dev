--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-03-30 15:00:58
-- 场景小地图
local SceneSmallMap = class("SceneSmallMap", function()
	return display.newNode()
end)

SceneSmallMap.bgContentSize = nil

function SceneSmallMap:ctor(data)
	self.bg = display.newSprite("#scene/scene_mapBg.png")
	self:addChild(self.bg)
	self.bg:setPosition(60.5,33)

    self.curSafeArea = true
    self.safeAreaColor = cc.c3b(85, 213, 40)
    self.notSafeAreaColor = cc.c3b(213, 40, 40)

    self.mapInfoTip = display.newTTFLabel({
        text = "",
        size = 18,color = cc.c3b(255, 254, 211)})
        :align(display.CENTER,0,0)
        :addTo(self)
    self.mapInfoTip:setPosition(59,49)

    self.mapInfoPos = display.newBMFontLabel({
            text = "",
            font = "fonts/bitmapText_22.fnt",
            })
    self.mapInfoPos:setTouchEnabled(false)
    self:addChild(self.mapInfoPos)
    self.mapInfoPos:setPosition(60,17)
    self.mapInfoPos:setAnchorPoint(0.5,0.5)
    self.mapInfoPos:setColor(self.safeAreaColor)

    self:setTouchEnabled(false)
    self.bg:setTouchEnabled(true)
    self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            GlobalWinManger:openWin(WinName.MAP)
        elseif event.name == "began" then
        end
        return true
    end)

    local bgContentSize = self.bg:getContentSize()
    self.bgContentSize = bgContentSize

    -- old allen
	-- local stencil = display.newSprite("#scene_miniMapMask.png")
	-- local holesClipper = cc.ClippingNode:create()
	-- holesClipper:setPosition(-85,-68)
	-- self:addChild(holesClipper)
	-- holesClipper:setStencil(stencil)
 -- 	holesClipper:setInverted(false)
 -- 	holesClipper:setAlphaThreshold(0)
	-- self.mapLay = display.newNode()
	-- holesClipper:addChild(self.mapLay)
    
    -- old allen end
    self.mapLay = display.newNode()
    self:addChild(self.mapLay)
    self.mapLay:setVisible(false)

	-- local miniMapFram = display.newSprite("#scene_miniMapPic.png")
	-- self:addChild(miniMapFram)
	-- miniMapFram:setAnchorPoint(1,1)

    --成就
    -- local achieveBtn = display.newSprite("#scene_achieveBtn.png")
    -- achieveBtn:setTouchEnabled(true)
    -- self:addChild(achieveBtn)
    -- achieveBtn:setPosition(-85+23,-68-59)
    -- achieveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "ended" then
    --         GlobalWinManger:openWin(WinName.MAP)
    --     elseif event.name == "began" then
    --     end
    --     return true
    -- end)

    --邮件
    local emailBtn = display.newSprite("#scene/scene_btnEmail.png")
    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_EMAIL,emailBtn,32,32)
    emailBtn:setTouchEnabled(true)
    self:addChild(emailBtn)
    emailBtn:setPosition(18,-24)
    emailBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		 if event.name == "ended" then
            emailBtn:setScale(1)
             GlobalWinManger:openWin(WinName.MAILWIN)
         elseif event.name == "began" then
            emailBtn:setScale(1.1)
         end
         return true
     end)

    --排行榜
    local rankBtn = display.newSprite("#scene/scene_btnRank.png")
    rankBtn:setTouchEnabled(true)
    self:addChild(rankBtn)
    rankBtn:setPosition(20 + 40,-24)
    --rankBtn:setPosition(-85-41,-68-50)
    rankBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            rankBtn:setScale(1)
            if RoleManager:getInstance().roleInfo.lv >= 15 then
                GlobalWinManger:openWin(WinName.RANKWIN)
            else
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"15级才能查看排名")
            end
        elseif event.name == "began" then
            rankBtn:setScale(1.1)
         end
         return true
     end)

    --新手
    local newhandBtn = display.newSprite("#scene/scene_btnNewHand.png")
    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_STRATEGY,newhandBtn,32,32)
    newhandBtn:setTouchEnabled(true)
    self:addChild(newhandBtn)
    --newhandBtn:setPosition(-85-56,-68+41)
    newhandBtn:setPosition(22 + 40 + 40,-24)
    newhandBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            GlobalWinManger:openWin(WinName.STRATEGYWIN)
            newhandBtn:setScale(1)
        elseif event.name == "began" then
            newhandBtn:setScale(1.1)
        end
        return true
    end)

    --  --福利
    -- local welfareBtn = display.newSprite("#scene/scene_btnWelfare.png")
    -- local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_WELFARE,welfareBtn,32,32)
    -- welfareBtn:setTouchEnabled(true)
    -- self:addChild(welfareBtn)
    -- welfareBtn:setPosition(22,-68)
    -- welfareBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --      if event.name == "ended" then
    --          GlobalWinManger:openWin(WinName.WELFAREWIN)
    --          welfareBtn:setScale(1)
    --      elseif event.name == "began" then
    --         welfareBtn:setScale(1.1)
    --      end
    --      return true
    --  end)


    --self:open()
    self.playList = {}
    self.monsterLabList = {}
    self.npcList = {}
    self.playFreeList = {}
    self.monsterFreeList = {}
    self.npcFreeList = {}

    self:setNodeEventEnabled(true)
end


function SceneSmallMap:onCleanup()
    self:destory()
end

function SceneSmallMap:tryReleaseMapTexture(texturePath)
    if texturePath then
        local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(texturePath)
        if texture and texture:getReferenceCount() == 1 then
            cc.Director:getInstance():getTextureCache():removeTextureForKey(texturePath)
        end
    end
end

function SceneSmallMap:open()
    self:close()
    local tmp
    if self.mapJPG then
        tmp = self.mapJPG
    end
    self.mapJPG = "map/miniMap/"..GameSceneModel.sceneConfig.minimap..".jpg"
	if self.mapImage then
        self.mapImage:setTexture(self.mapJPG)
    else
        self.mapImage = display.newSprite(self.mapJPG)
        self.mapLay:addChild(self.mapImage)
	end
    self:tryReleaseMapTexture(tmp)
    self.mapImage:setAnchorPoint(cc.p(0, 0))
    local contentSize = self.mapImage:getContentSize()
    self.mapLay:setPosition((652-contentSize.width)/2,(535-contentSize.height)/2)

    -- self.mapImage:setVisible(false)

    self.sceneId = GameSceneModel.sceneId
    self.mapWidth = GameSceneModel.sceneWidth
    self.mapHeight = GameSceneModel.sceneHeight
    self.miniMapWidth = contentSize.width
    self.miniMapHeight = contentSize.height

    self.scaleX = self.miniMapWidth/self.mapWidth
    self.scaleY = self.miniMapHeight/self.mapHeight

    if self.updateRolePosEventId == nil then
        self.updateRolePosEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ROLE_POS_UPDATE,handler(self,self.updateRolePos))
    end
    if self.mapAddRoleEventId == nil then
        self.mapAddRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ADD_ROLE,handler(self,self.onMapAddRole))
    end
    if self.mapDelRoleEventId == nil then
        self.mapDelRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_DEL_ROLE,handler(self,self.onMapDelRole))
    end

    for k,v in pairs(GlobalController.fight.playerViewArr) do
        if v.vo.type == SceneRoleType.PLAYER and v.vo.id == GlobalModel.player_id then
            if nil == self.myIcon then
                self.myIcon = display.newSprite("#scene/scene_pointPlay.png")
                self.mapLay:addChild(self.myIcon,20000-v.vo.pos.y*self.scaleY)
            end 
            self.myIcon:setPosition(v.vo.pos.x*self.scaleX,v.vo.pos.y*self.scaleY)
            self:updateMapLayerPositionByPalyer(v.vo.pos)
        else
            local playiocn
            if #self.playFreeList > 0 then
                playiocn = table.remove(self.playFreeList)
                self.mapLay:addChild(playiocn,20000-v.vo.pos.y*self.scaleY)
                playiocn:release()
            else
                playiocn = display.newSprite("#scene/scene_pointUser.png")
                self.mapLay:addChild(playiocn,20000-v.vo.pos.y*self.scaleY)
            end
            playiocn:setPosition(v.vo.pos.x*self.scaleX,v.vo.pos.y*self.scaleY)
            self.playList[k] = playiocn
        end
        
    end
    
    self:updateNpc()
    self:updateMonster()

    
end

function SceneSmallMap:updateNpc()
    for k,v in pairs(GameSceneModel.npcVOArr) do
        if v.npcType~= 5 and v.show == 1 and self.npcList[v.id] == nil then
            local npciocn
            if #self.npcFreeList > 0 then
                npciocn = table.remove(self.npcFreeList)
                self.mapLay:addChild(npciocn,10000-v.pos.y*self.scaleY)
                npciocn:release()
            else
                npciocn = display.newSprite("#scene/scene_pointNpc.png")
                self.mapLay:addChild(npciocn,10000-v.pos.y*self.scaleY)
            end
            npciocn:setPosition(v.pos.x*self.scaleX,v.pos.y*self.scaleY)
            self.npcList[v.id] = npciocn
        end
    end
end

function SceneSmallMap:updateMonster()
    for k,v in pairs(GlobalController.fight.monsterViewArr) do
        if self.npcList[v.vo.id] == nil then
            local masteriocn
            if #self.monsterFreeList > 0 then
                masteriocn = table.remove(self.monsterFreeList)
                self.mapLay:addChild(masteriocn,10000-v.vo.pos.y*self.scaleY)
                masteriocn:release()
            else
                masteriocn = display.newSprite("#scene/scene_pointMaster.png")
                self.mapLay:addChild(masteriocn,10000-v.vo.pos.y*self.scaleY)
            end
            masteriocn:setPosition(v.vo.pos.x*self.scaleX,v.vo.pos.y*self.scaleY)
            self.monsterLabList[v.vo.id] = masteriocn
        end
    end
end

function SceneSmallMap:updateMapLayerPositionByPalyer(position)
    if not position then return end
    local x = 0-position.x*self.scaleX
    local y = 0-position.y*self.scaleY
    x = math.min(-self.bgContentSize.width/2,x)
    y = math.min(-self.bgContentSize.height/2,y)
    x = math.max(x,-self.miniMapWidth + self.bgContentSize.width/2)
    y = math.max(y,-self.miniMapHeight + self.bgContentSize.height/2)

    self.mapLay:setPosition(x,y)
    local p = FightUtil:pointToGrid(position.x,position.y)
    self.mapInfoTip:setString(GameSceneModel.sceneName)
    self.mapInfoPos:setString("("..p.x..","..p.y..")")

    if self.curSafeArea ~= GameSceneModel.inSafeArea then
        self.curSafeArea = GameSceneModel.inSafeArea
        if self.curSafeArea then
            self.mapInfoPos:setColor(self.safeAreaColor)
        else
            self.mapInfoPos:setColor(self.notSafeAreaColor)
        end
    end
end

function SceneSmallMap:updateRolePos(data)

    local item
    if data.data.type == SceneRoleType.PLAYER then
        if  data.data.id == GlobalModel.player_id then
            item = self.myIcon
        else
            item = self.playList[data.data.id]
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        item = self.monsterLabList[data.data.id]
    elseif data.data.type == SceneRoleType.NPC then
        item = self.npcList[data.data.id]
    end
    if item then
        item:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
        if data.data.type == SceneRoleType.PLAYER and GlobalModel.player_id == data.data.id then
            self:updateMapLayerPositionByPalyer(data.data.pos)
        end
    end
end

function SceneSmallMap:onMapAddRole(data)
    if data.data.type == SceneRoleType.PLAYER then
        if self.playList[data.data.id] == nil  then
            if data.data.id == GlobalModel.player_id then
                if nil == self.myIcon then
                    self.myIcon = display.newSprite("#scene/scene_pointPlay.png")
                    self.mapLay:addChild(self.myIcon,20000-data.data.pos.y*self.scaleY)
                end 
                self:updateRolePos(data)
            else
                local playiocn
                if #self.playFreeList > 0 then
                    playiocn = table.remove(self.playFreeList)
                    self.mapLay:addChild(playiocn,20000-data.data.pos.y*self.scaleY)
                    playiocn:release()
                else
                    playiocn = display.newSprite("#scene/scene_pointUser.png")
                    self.mapLay:addChild(playiocn,20000-data.data.pos.y*self.scaleY)
                end
                playiocn:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
                self.playList[data.data.id] = playiocn
            end
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        if self.monsterLabList[data.data.id] == nil then
            local monsterlabel
            if #self.monsterFreeList > 0 then
                monsterlabel = table.remove(self.monsterFreeList)
                self.mapLay:addChild(monsterlabel,10000-data.data.pos.y*self.scaleY)
                monsterlabel:release()
            else
                monsterlabel = display.newSprite("#scene/scene_pointMaster.png")
                self.mapLay:addChild(monsterlabel,10000-data.data.pos.y*self.scaleY)
            end
            monsterlabel:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
            self.monsterLabList[data.data.id] = monsterlabel
        end
    elseif data.data.type == SceneRoleType.NPC then
        if self.npcList[data.data.id] == nil then
            local npciocn
            if #self.npcFreeList > 0 then
                npciocn = table.remove(self.npcFreeList)
                self.mapLay:addChild(npciocn,10000-data.data.pos.y*self.scaleY)
                npciocn:release()
            else
                npciocn = display.newSprite("#scene/scene_pointNpc.png")
                self.mapLay:addChild(npciocn,10000-data.data.pos.y*self.scaleY)
            end
            npciocn:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
            self.npcList[data.data.id] = npciocn
        end
    end
end

function SceneSmallMap:onMapDelRole(data)
     if data.data.type == SceneRoleType.PLAYER then
        if self.playList[data.data.id] then
            local playicon = self.playList[data.data.id]
            playicon:retain()
            table.insert(self.playFreeList, playicon)
            self.mapLay:removeChild(playicon)
            self.playList[data.data.id] = nil
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        if self.monsterLabList[data.data.id] then
            local monstericon = self.monsterLabList[data.data.id]
            monstericon:retain()
            table.insert(self.monsterFreeList, monstericon)
            self.mapLay:removeChild(monstericon)
            self.monsterLabList[data.data.id] = nil
        end
    elseif data.data.type == SceneRoleType.NPC then
        if self.npcList[data.data.id] then
            local npcicon = self.npcList[data.data.id]
            npcicon:retain()
            table.insert(self.npcFreeList, npcicon)
            self.mapLay:removeChild(npcicon)
            self.npcList[data.data.id] = nil
        end
    end
end

function SceneSmallMap:close()
	if self.updateRolePosEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateRolePosEventId)
        self.updateRolePosEventId = nil
    end
    if self.mapAddRoleEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.mapAddRoleEventId)
        self.mapAddRoleEventId = nil
    end
    if self.mapDelRoleEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.mapDelRoleEventId)
        self.mapDelRoleEventId = nil
    end

    for k,v in pairs(self.playList or {}) do
        v:retain()
        table.insert(self.playFreeList, v)
        self.mapLay:removeChild(v)
    end
    for k,v in pairs(self.monsterLabList or {}) do
        v:retain()
        table.insert(self.monsterFreeList, v)
        self.mapLay:removeChild(v)
    end
    for k,v in pairs(self.npcList or {}) do
        v:retain()
        table.insert(self.npcFreeList, v)
        self.mapLay:removeChild(v)
    end
    self.playList = {}
    self.monsterLabList = {}
    self.npcList = {}
    self:tryReleaseMapTexture(self.mapJPG)
    
end

function SceneSmallMap:destory()
    self:close()
    for _,playFreeItem in ipairs(self.playFreeList or {}) do
        if playFreeItem:getReferenceCount() == 1 then
            playFreeItem:release()
        end
    end

    for _,monsterFreeItem in ipairs(self.monsterFreeList or {}) do
        if monsterFreeItem:getReferenceCount() == 1 then
            monsterFreeItem:release()
        end
    end

    for _,npcFreeItem in ipairs(self.npcFreeList or {}) do
        if npcFreeItem:getReferenceCount() == 1 then
            npcFreeItem:release()
        end
    end
    self.playFreeList = {}
    self.monsterFreeList = {}
    self.npcFreeList = {}

end

return SceneSmallMap


