--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-11-26 10:57:44
-- 小地图

local TabBtnItem = require("app.gameui.TabBtn")
local WorldMapView = import(".WorldMapView")
local MapNpcItem = import(".MapNpcItem")
local MapView = class("MapView", BaseView)

local GoodsUtil = require("app.utils.GoodsUtil")

MapView.TAB_CURRENT_MAP = 1
MapView.TAB_WORLD_MAP = 2

MapView.mapJPG = nil

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function MapView:ctor(winTag,data,winconfig)
	MapView.super.ctor(self,winTag,data,winconfig)
  	self.data = data

    self.sceneId = -1
    self.mapWidth = 0
    self.mapHeight = 0
    self.miniMapWidth = 0
    self.miniMapHeight = 0

    self.curMapBtn = self:seekNodeByName("curMapBtn")
    self.curMapSel = self:seekNodeByName("curMapSel")
    self.worldMapBtn = self:seekNodeByName("worldMapBtn")
    self.worldMapSel = self:seekNodeByName("worldMapSel")
    self.curMapBtn:setTouchEnabled(true)
    self.curMapBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "ended" then
                self:showTabByIndex(MapView.TAB_CURRENT_MAP)
            end
            return true
        end)
    self.worldMapBtn:setTouchEnabled(true)
    self.worldMapBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "ended" then
                self:showTabByIndex(MapView.TAB_WORLD_MAP)
            end
            return true
        end)

    self.rightLay = self:seekNodeByName("rightLay2")
    self.curMapLay = self:seekNodeByName("curMapLay")

    self.listLay = self:seekNodeByName("listLay")
    self.worldLay = self:seekNodeByName("worldLay")
    --self.rightLay = self:seekNodeByName("rightLay")

    self.curSelTabIndex = -1

    self:showTabByIndex(MapView.TAB_CURRENT_MAP)
    self.isCancelRemoveSpriteFrams = true
end

--
-- 显示指定的页视图。
--
function MapView:showTabByIndex(index)
    if self.curSelTabIndex ~= index then
        self.curSelTabIndex = index
        self.worldMapSel:setVisible(false)
        self.curMapSel:setVisible(false)

        self.rightLay:setVisible(false)
        self.worldLay:setVisible(false)
        if MapView.TAB_CURRENT_MAP == index then
            self.curMapSel:setVisible(true)
            self.rightLay:setVisible(true)
            if self.isInitMap then
            else
                self.isInitMap = self:initCurrentMapView()
            end
            self:setWinTitle(GameSceneModel.sceneName)
        else
            self.worldMapSel:setVisible(true)
            self.worldLay:setVisible(true)
            if self.worldView then
            else
                self.worldView = self:initWorldMapView()
            end
            self:setWinTitle("世界")
        end
    end
end

--
-- 初始化当前地图的视图。
--
function MapView:initCurrentMapView()
    self.mapLay = display.newNode()
    self.mapLay:setTouchEnabled(true)
    self.mapLay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            local point = self.mapLay:convertToNodeSpace(cc.p(event.x, event.y))
            local sceneGrid = FightUtil:pointToGrid(point.x/self.scaleX,point.y/self.scaleY)
            self:onMapClick(cc.p(sceneGrid.x,sceneGrid.y))
        end
        return true
    end)
    self.curMapLay:addChild(self.mapLay)
    -- 右边NPC列表 255, 535
    self.npcListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 154, 476),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.listLay)
    self.npcListView:setPosition(4,6)

    self.npcItemList = {}
    self.npcLabList = {}
    self.playList = {}
    self.pathItemList = {}
    self.monsterLabList = {}
    self:startTimer()
    return true
end

--
-- 初始化世界地图视图。
--
function MapView:initWorldMapView()
    local worldMapView = WorldMapView.new()
    self.worldLay:addChild(worldMapView)
    return worldMapView
end


-- ==================================================================================================
-- 队友图标更新

--
-- 每五秒获取队友的位置刷新显示。
--
function MapView:startTimer()
    self:stopTimer()
    GameNet:registerProtocal(11019, function(data)
        self._teamPoints = data.flag_list
        self:invalidateTeamPoints()
    end)

    local function onTimerHandler()
        GameNet:sendMsgToSocket(11019)
    end
    self._timerHandle = scheduler.scheduleGlobal(onTimerHandler, 5)
    onTimerHandler()
end

--
-- 停止计时
--
function MapView:stopTimer()
    if self._timerHandle then
        scheduler.unscheduleGlobal(self._timerHandle)
        GameNet:unRegisterProtocal(11019)
        self._timerHandle = nil
    end
end

--
-- 刷新队友标记
--
function MapView:invalidateTeamPoints()
    if GameSceneModel.curSceneHideName == true then
        return
    end
    local teamPoints = self._teamPoints or {}
    self:removeAllTeamPoints()
    for _, v in pairs(teamPoints) do
        self:addTeamPoint(v.point)
    end
end

--
-- 添加一个队友标记
--
function MapView:addTeamPoint(point)
    local teamPointDisplays = self._teamPointDisplays or {}
    local pointIcon = display.newSprite("#map_mainRole.png")
    teamPointDisplays[#teamPointDisplays + 1] = pointIcon
    self._teamPointDisplays = teamPointDisplays

    local numOfMapColume = GameSceneModel.baseMapConfig.gridColume
    local numOfMapRow    = GameSceneModel.baseMapConfig.gridRow
    local posX = point.x / numOfMapColume * self.miniMapWidth
    local posY = (numOfMapRow - point.y) / numOfMapRow * self.miniMapHeight

    pointIcon:setPosition(posX, posY)
    self.mapLay:addChild(pointIcon, 20000 - posY)
end

--
-- 移除所有的队友标记
--
function MapView:removeAllTeamPoints()
    local teamPointDisplays = self._teamPointDisplays or {}
    for _, v in ipairs(teamPointDisplays) do
        v:removeFromParent()
    end
    self._teamPointDisplays = {}
end

-- end of team
-- --------------------------------------------------------------------------------------------------------


function MapView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item   = self.npcItemList[event.itemPos]
        local vo     = item:getData()
        local voType = item:getItemType()

        if voType == MapNpcItem.TYPE_NPC then
            SceneManager:playerMoveToNPCByVO(vo, true)
        elseif voType == MapNpcItem.TYPE_TRANSFER then
            -- local transferconfig = configHelper:getTransferConfig()
            -- local transfer = transferconfig[vo.id]
            -- dump(vo)
            -- if transfer then

                --local posStr = string.gsub(vo.toPos, "[{|}]", "")
                local pointArr = vo.toPos[1] --string.split(posStr, ",")
                
                SceneManager:playerMoveTo(vo.toScene,cc.p(tonumber(pointArr[1]), tonumber(pointArr[2])),nil,true)
            --end
        elseif voType == MapNpcItem.TYPE_MONSTER then
             SceneManager:playerMoveTo(GameSceneModel.sceneId,vo.point_c,nil,true)
        end

        
        
        --self:onMapClick(vo.mGrid)
        --self:onListClick(self.npcItemList[event.itemPos])
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end
	

function MapView:updateRolePath(data)
    for k,v in pairs(self.pathItemList) do
        self.mapLay:removeChild(v)
        self.pathItemList[k] = nil
    end
    for i=1,#data.data,2 do
        local pos = data.data[i]
        pos = FightUtil:gridToPoint(pos.x, pos.y) 
        local playiocn = display.newSprite("#map_pathPoint.png")
        --local sceneGrid = FightUtil:pointToGrid(point.x/self.scaleX,point.y/self.scaleY)
        self.mapLay:addChild(playiocn,2000-pos.y*self.scaleY)
        playiocn:setPosition(pos.x * self.scaleX,pos.y * self.scaleY)
        self.pathItemList[i] = playiocn
    end
end

--检查是否穿戴了传送戒指
local function _checkHasDressedDeliverRing(self)
    --getGoodsByGoodId
    local roleManager = RoleManager:getInstance()
    if not roleManager.roleInfo  then return end
    local equipList = roleManager.roleInfo.equip
    for _,equipItem in ipairs(equipList or {}) do
        if GoodsUtil.canDeliverByGoodsId(equipItem.goods_id) then
            return true
        end
    end
    return false
end

function MapView:onMapClick(sceneGrid)
    local isValidGird = SceneManager:curSceneGridIsOpen(GameSceneModel.sceneConfig.mapId,sceneGrid)
    if not isValidGird then return end
    --[[
    local deliver = function()
        print("#####传送#####")
    end
    local autoFindPath = function()
        SceneManager:playerMoveTo(GameSceneModel.sceneId,sceneGrid,nil,true)
    end
    --local player = GlobalController.fight:getSelfPlayerModel()
    if _checkHasDressedDeliverRing(self) then
        GlobalMessage:alert({
            title = "传送特戒",
            enterTxt = "传送",
            backTxt = "寻路",
            tipTxt = string.format("\n是否传送至(%i,%i)吗？",sceneGrid.x ,sceneGrid.y),
            enterFun = deliver,
            backFun = autoFindPath,
        })
        return
    end
    ]]--

    SceneManager:playerMoveTo(GameSceneModel.sceneId,sceneGrid,nil,true)
end


function MapView:updateRolePos(data)
    local item
    if data.data.type == SceneRoleType.PLAYER then
        item = self.playList[data.data.id]
    elseif data.data.type == SceneRoleType.MONSTER then
        item = self.monsterLabList[data.data.id]
    elseif data.data.type == SceneRoleType.NPC then

    end
    if item then
        item:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
        item:setRotation(self:getAngleByDirect(data.data.direct))
        --item:setRotation(90)
    end
end

function MapView:getAngleByDirect(direct)
    if direct == 1 then
        return 0
    elseif direct == 2 then
        return -45
    elseif direct == 3 then
        return -90
    elseif direct == 4 then
        return -135
    elseif direct == 5 then
        return 180
    elseif direct == 6 then
        return 135
    elseif direct == 7 then
        return 90
    elseif direct == 8 then
        return 45
    end
    return 0
end

--data.data为VO
function MapView:onMapAddRole(data)
    if data.data.type == SceneRoleType.PLAYER then
        if self.playList[data.data.id] == nil and data.data.id == GlobalModel.player_id then
            local playiocn = display.newSprite("#map_player.png")
            self.mapLay:addChild(playiocn,20000-data.data.pos.y*self.scaleY)
            playiocn:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
            self.playList[data.data.id] = playiocn
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        -- if self.monsterLabList[data.data.id] == nil then
        --     local monsterlabel = display.newTTFLabel({text = data.data.name,
        --       size = 20,color = TextColor.TEXT_R})
        --     :align(display.CENTER,0,0)
        --     --:addTo(self.mapLay)
        --     self.mapLay:addChild(monsterlabel,10000-data.data.pos.y*self.scaleY)
        --     monsterlabel:setPosition(data.data.pos.x*self.scaleX,data.data.pos.y*self.scaleY)
        --     display.setLabelFilter(monsterlabel)
        --     self.monsterLabList[data.data.id] = monsterlabel
        -- end
    elseif data.data.type == SceneRoleType.NPC then

    end
end

function MapView:onMapDelRole(data)
     if data.data.type == SceneRoleType.PLAYER then
        if self.playList[data.data.id] then
            self.mapLay:removeChild(self.playList[data.data.id])
            self.playList[data.data.id] = nil
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        -- if self.monsterLabList[data.data.id] then
        --     self.mapLay:removeChild(self.monsterLabList[data.data.id])
        --     self.monsterLabList[data.data.id] = nil
        -- end
    elseif data.data.type == SceneRoleType.NPC then

    end
end

function MapView:tryReleaseMapTexture()
    if self.mapJPG then
        local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(self.mapJPG)
        if texture and texture:getReferenceCount() == 1 then
            cc.Director:getInstance():getTextureCache():removeTextureForKey(self.mapJPG)
        end
    end
end

--打开 MapView:updateRolePath(list)
function MapView:open(data)
    if self.mapAddRoleEventId == nil then
        self.mapAddRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ADD_ROLE,handler(self,self.onMapAddRole))
    end
    if self.mapDelRoleEventId == nil then
        self.mapDelRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_DEL_ROLE,handler(self,self.onMapDelRole))
    end
    if self.updateRolePosEventId == nil then
        self.updateRolePosEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ROLE_POS_UPDATE,handler(self,self.updateRolePos))
    end

    if self.updateRolePathEventId == nil then
        self.updateRolePathEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ROLE_PATH_UPDATE,handler(self,self.updateRolePath))
    end
  --GlobalEventSystem:dispatchEvent(SceneEvent.MAP_ROLE_PATH_UPDATE,{id = self.vo.id,type = self.vo.type,pos = self.vo.pos})
    --GameSceneModel.sceneId
    self:setWinTitle(GameSceneModel.sceneName)
    
    if self.mapImage then
         self.mapLay:removeChild(self.mapImage)
         self.mapImage = nil
         self:tryReleaseMapTexture()
    end
    self.mapJPG ="map/miniMap/"..GameSceneModel.sceneConfig.minimap..".jpg"
    self.mapImage = display.newSprite(self.mapJPG)
    self.mapImage:setAnchorPoint(cc.p(0, 0))
    self.mapLay:addChild(self.mapImage)

    local sizex,sizey = self.mapImage:getContentSize()
    local maxScale = 580/sizex.width
    if 482/sizex.height < maxScale then
        maxScale = 482/sizex.height
    end
    self.mapLay:setScale(maxScale)
    self.mapLay:setPosition((586-sizex.width*maxScale)/2,(488-sizex.height*maxScale)/2)

    self.sceneId = GameSceneModel.sceneId
    self.mapWidth = GameSceneModel.sceneWidth
    self.mapHeight = GameSceneModel.sceneHeight
    self.miniMapWidth = sizex.width
    self.miniMapHeight = sizex.height
    self.scaleX = self.miniMapWidth/self.mapWidth
    self.scaleY = self.miniMapHeight/self.mapHeight
    -- self.rightListLay:getContentSize(255, 535)
    -- self.uiLay:addChild(self.rightListLay)
    -- self.rightListLay:setPosition(688+123,290)
    self:loadListItems()

    for k,v in pairs(GameSceneModel.playerVOArr) do
        if v.type == SceneRoleType.PLAYER and v.id == GlobalModel.player_id then
            local playiocn = display.newSprite("#map_player.png")
            playiocn:setScale(2)
            self.mapLay:addChild(playiocn,20000-v.pos.y*self.scaleY)
            playiocn:setPosition(v.pos.x*self.scaleX,v.pos.y*self.scaleY)
            self.playList[k] = playiocn
        end
        
    end
end

function MapView:loadListItems()
    -- --------------------------------------------------------
    -- Start --- Data Source
    local function getNpcItemList()
        local filterList = {}
        local orgList = GameSceneModel.npcVOArr

        for _, v in pairs(orgList) do
            if v.npcType < 10 and v.npcType ~= 5 then
                filterList[#filterList + 1] = v
            end
        end
        return filterList
    end

    local function getTransferItemList()
        return configHelper:getMapTransferListBySceneId(GameSceneModel.sceneId)
    end

    local function getMapMonsterItemList()
        return configHelper:getMapMonsterListBySceneId(GameSceneModel.sceneId)
    end
    -- End -- Data Source
    -- --------------------------------------------------------

    local function getItemDataPosition(type, itemData)
        if type == MapNpcItem.TYPE_NPC then
            return itemData.pos
        elseif type == MapNpcItem.TYPE_TRANSFER then
            return FightUtil:gridToPoint(itemData.fromPos_c.x, itemData.fromPos_c.y)
        elseif type == MapNpcItem.TYPE_MONSTER then
            return FightUtil:gridToPoint(itemData.point_c.x, itemData.point_c.y)
        end
    end


    local function loadListItems(type, items,isSort)

        local arr = items
        if isSort then
         arr = self:sortListById(items)
        end
        for i=1,#arr do
            local content = MapNpcItem.new()
            local item = self.npcListView:newItem()
            content:setItemType(type)
            content:setData(arr[i])
            item:addContent(content)
            item:setItemSize(152, 46)
            self.npcListView:addItem(item)
            self.npcItemList[#self.npcItemList + 1] = content
        end
        -- for _, v in pairs(items) do
        --     local content = MapNpcItem.new()
        --     local item = self.npcListView:newItem()
        --     content:setItemType(type)
        --     content:setData(v)
        --     item:addContent(content)
        --     item:setItemSize(238, 59)
        --     self.npcListView:addItem(item)
        --     self.npcItemList[#self.npcItemList + 1] = content
        -- end
    end

    local function loadMapLabels(ctype, items)
        local color
        if ctype == MapNpcItem.TYPE_NPC then
            color = SceneColorType.NPC
        elseif ctype == MapNpcItem.TYPE_TRANSFER then
            color = SceneColorType.TRANSFER
        elseif ctype == MapNpcItem.TYPE_MONSTER then
            color = SceneColorType.MANSTER
        else
            color = SceneColorType.NPC
        end    
        for _, v in pairs(items) do
            local point = getItemDataPosition(ctype, v)
            local npclabel = display.newTTFLabel({text = v.name, size = 18,color = color})
            :align(display.CENTER,0,0)
            :addTo(self.mapLay, 10000 - point.y * self.scaleY)

            npclabel:setPosition(point.x * self.scaleX, point.y * self.scaleY)
            display.setLabelFilter(npclabel)
            self.npcLabList[#self.npcLabList + 1] = npclabel
        end
    end

    local function loadItems(type, items,isSort)
        local showItems = {}
        for _, v in pairs(items) do
            if v.show == 1 then
                showItems[#showItems + 1] = v
            end
        end

        loadListItems(type, showItems,isSort)
        loadMapLabels(type, items)
    end
    --print("MapNpcItem.TYPE_NPC")
    loadItems(MapNpcItem.TYPE_NPC,      getNpcItemList(),true)
    --print("MapNpcItem.TYPE_TRANSFER")
    loadItems(MapNpcItem.TYPE_TRANSFER, getTransferItemList())
    --print("MapNpcItem.TYPE_MONSTER")
    loadItems(MapNpcItem.TYPE_MONSTER,  getMapMonsterItemList())

    self.npcListView:reload()
end


function MapView:sortListById(arr)
    local backarr = {}
    for k,v in pairs(arr) do
        table.insert(backarr,v)
    end

    table.sort(backarr,function(a,b) return a.order<b.order end)
    return backarr
end


--关闭
function MapView:close()
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
    if self.updateRolePathEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateRolePathEventId)
        self.updateRolePathEventId = nil
    end
    self:tryReleaseMapTexture()
    
end	

--销毁
function MapView:destory()
    self:close()
    self:stopTimer()
    self.npcItemList = {}
    self.npcLabList = {}
    self.playList = {}
    self.pathItemList = {}
    self.monsterLabList = {}
    MapView.super.destory(self)
end
return MapView