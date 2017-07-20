--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-09 15:24:55
--
--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-09 15:13:25
--
SceneManager = SceneManager or {}

function SceneManager:ctor(fightCon)
	self.fightCon = fightCon
    self.sceneTranferArr = {}
    self.npcId  = nil --记录要去的NPCID

    --自动寻路到达的场景
    self.autoAwayToSceneId = nil
    --自动寻路到达的点
    self.autoAwayGrid = nil
    self.mapDic = {}

    self.aberrancePalaceData = {}--变异地宫
end


function SceneManager:killTaskMonsterByResId(monsterId)
    if FightModel:getSelAtkTarVO() then return end
    monsterId = monsterId or TaskManager:getInstance():getCurrentTaskMonsterId()
    local dis = 10000
    local curVO = nil

    local playerVO = self.fightCon:getSelfPlayerModel().vo

    for k,v in pairs(GameSceneModel.monsterVOArr) do
        if v.monster_id == monsterId and v.states ~= RoleActivitStates.DEAD then
            local d = math.sqrt(math.abs(playerVO.mGrid.x - v.mGrid.x) *math.abs(playerVO.mGrid.x - v.mGrid.x) + math.abs(playerVO.mGrid.y - v.mGrid.y)*math.abs(playerVO.mGrid.y - v.mGrid.y))
            if d < dis then
                curVO = v
                dis = d
            end
        end
    end
    if curVO then
        FightModel:setSelAtkTarVO(curVO)
    end
end

--玩家移动到采集物那里
--@param showAutoWayTxt --显示自动寻路文本
function SceneManager:playerMoveToCollectioinItemByVO(vo,showAutoWayTxt)
    local player = self.fightCon:getSelfPlayerModel()
    local rGrid = player.vo.mGrid
    local cGrid = vo.mGrid

    local list = self.fightCon.aStar:find(rGrid,cGrid)
    if list ~= nil  then 
        if vo.npcType ~= NpcType.TRANSFER_POINT then
             table.remove(list, #list)
             table.remove(list, #list)
        end
  
        local backFun =  function()

            local movebackFun =  function()
                GameNet:sendMsgToSocket(11043,{id = vo.id})
                GameNet:sendMsgToSocket(11060,{state = 0})
            end
            local time = configHelper:getCollect_goodsConfigById(vo.monster_id)
            if time then
                time = time.time
                GameNet:sendMsgToSocket(11060,{state = time})
                player:showCollectBar(time,{time = time,isOpen = true,id = 0,tips = "采集中",backFun = movebackFun})
            else
                GameNet:sendMsgToSocket(11060,{state = 3})
                player:showCollectBar(3,{time = 3,isOpen = true,id = 0,tips = "采集中",backFun = movebackFun})
            end
            --player:showCollectBar(1,{time = 3,isOpen = true,id = 0,tips = "采集中",backFun = movebackFun})
            --GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_COLLECT_BAR,{time = 3,isOpen = true,id = 0,tips = "采集中",backFun = movebackFun})
        end
        if #list > 0 then
            if showAutoWayTxt then
                self.autoAwayToSceneId = GameSceneModel.sceneId
                self.autoAwayGrid = cGrid
                GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD,true)
            end

            player:roleMoveTo(list,nil,nil,backFun)
        else
            backFun()
        end
    end
end

--玩家移动到NPC那里
--@param showAutoWayTxt --显示自动寻路文本
function SceneManager:playerMoveToNPCByVO(npcVO,showAutoWayTxt)
    local player = self.fightCon:getSelfPlayerModel()
    local rGrid = player.vo.mGrid
    local cGrid = npcVO.mGrid

    local list = self.fightCon.aStar:find(rGrid,cGrid)
    if list ~= nil  then 
        if npcVO.npcType ~= NpcType.TRANSFER_POINT then
            table.remove(list, #list)
            table.remove(list, #list)
        end
  
        local backFun =  function()
            if npcVO.npcType == NpcType.OPEN_WIN  or  npcVO.npcType == NpcType.WORSHIP_WIN then --直接打开界面
                if npcVO.param == "" then
                    GlobalAlert:show("该功能暂未开放")
                else
                    
                    if npcVO.param == WinName.NPCTRANSFER then
                        GlobalWinManger:openWin(npcVO.param,npcVO)
                    else
                        if npcVO.isTask == 1 then
                            GlobalWinManger:openWin(WinName.NPCDIALOG,npcVO)
                        else
                            if npcVO.npcType == NpcType.WORSHIP_WIN then
                                local f = configHelper:checkWorShip(RoleManager:getInstance().roleInfo.lv)
                                if f == 0 then
                                    GlobalAlert:show("您的等级还不能膜拜")
                                    return
                                elseif f == 1 then
                                    GlobalAlert:show("等级超过可以膜拜等级")
                                    return
                                end
                            end
                            if FunctionOpenManager:getFunctionOpenByWinName(npcVO.param) then
                                --装备打造
                                if npcVO.param == "equipProduWin" then
                                    GlobalWinManger:openWin(npcVO.param,1)
                                else
                                    GlobalWinManger:openWin(npcVO.param)
                                end
                            else
                                FunctionOpenManager:showFunctionOpenTips(npcVO.param)
                            end
                        end
                        
                    end
                end
            elseif npcVO.npcType == NpcType.HANGUP then --跳去挂机场景
                -- if FunctionOpenManager:getFunctionOpenById(FunctionOpenType.HangUp) then
                --     local sceneId = (RoleManager:getInstance().roleInfo.hookSceneId or 10001)
                --     GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(sceneId)})
                -- else
                --     FunctionOpenManager:showFunctionOpenTips(FunctionOpenType.HangUp)
                -- end
            elseif npcVO.npcType == NpcType.OPEN_DIALOG then --打开对话框
                GlobalWinManger:openWin(WinName.NPCDIALOG,npcVO)
            elseif npcVO.npcType == NpcType.TRANSFER_NPC then --传送NPC，直接跳到场景
                if npcVO.param ~= "" then
                    GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(npcVO.param)})
                end
            elseif npcVO.npcType == NpcType.TRANSFER_POINT then
                --传送点处理在
                --BaseRole:setRolePosition(xx,yy)-
            end
            --SCENE_OBJECT 场景对象不处理
        end
        if #list > 0 then
            if showAutoWayTxt then
                self.autoAwayToSceneId = GameSceneModel.sceneId
                self.autoAwayGrid = cGrid
                GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD,true)
            end

            player:roleMoveTo(list,nil,nil,backFun)
        else
            backFun()
        end
    end
end

--通过传送点跳去新场景
function SceneManager:gotoSceneByNpc(npcVO)
    if npcVO == nil then return end
    if npcVO.param == "" then
        GlobalAlert:show("该场景暂未开放")
    else
        GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(npcVO.param)})
    end
end



--玩家移动到NPC
function SceneManager:playerMoveToNPC(npcId,showAutoWayTxt)
    --local player = self.fightCon:getSelfPlayerModel()
    local npcConf = NpcConf[npcId]
    if npcConf then
        local sceneId = npcConf.sceneId
        --local p = StringUtil.split(npcConf.pos, ",")
        local offsetY = math.random(-1,1)
        if offsetY == 0 then
            offsetY = -1
        end
        p = {x=tonumber(npcConf.x)+math.random(-1,1),y=tonumber(npcConf.y)+offsetY}
        self:playerMoveTo(sceneId,p,{type = 1,npcId = npcId},showAutoWayTxt)
    end
end

--玩家移动到Monster 怪物
function SceneManager:playerMoveToMonster(sceneId,pos,monsterId,showAutoWayTxt)
    showAutoWayTxt = showAutoWayTxt or true
    if sceneId == nil then
        sceneId = GameSceneModel.sceneId
        local player = self.fightCon:getSelfPlayerModel()
        local dis = 1000
        for k,v in pairs(GameSceneModel.monsterVOArr) do
            if v.monster_id == monsterId and v.states ~= RoleActivitStates.DEAD then
                local curdis = FightUtil:getDistance(v.pos.x,v.pos.y,player.vo.pos.x,player.vo.pos.y)
                if curdis < dis then
                    dis = curdis
                    pos = v.mGrid
                end
            end
        end
    end
    --print("SceneManager:playerMoveToMonster",sceneId,pos,showAutoWayTxt,FightModel.autoWayStates)
    if sceneId and pos then
        self:playerMoveTo(sceneId,pos,{type = 2,monsterId = monsterId},showAutoWayTxt)
    end
end


--玩家移动到藏宝图
function SceneManager:playerMoveToBaoCang(sceneId,pos,id,showAutoWayTxt)
    showAutoWayTxt = showAutoWayTxt or true
    if sceneId and pos then
        self:playerMoveTo(sceneId,pos,{type = 10,id = id},showAutoWayTxt)
    end
end

--玩家移动到位置
--@param sceneId 场景Id
--@param pos   坐标点 cc.p GameSceneModel.sceneId
function SceneManager:playerMoveTo(sceneId,pos,param,showAutoWayTxt)
    -- local playerVO = self.fightCon:getSelfPlayerModel().vo
    -- if playerVO == nil or (playerVO.states ~= RoleActivitStates.STAND and playerVO.states ~= RoleActivitStates.MOVE) then
    --     return
    -- end
    self.npcId = nil
    local curSceneId = GameSceneModel.sceneId
    showAutoWayTxt = showAutoWayTxt or false
    if showAutoWayTxt then
        self.autoAwayToSceneId = sceneId
        self.autoAwayGrid = pos
    end
    if sceneId == curSceneId then --当前场景中
        self.sceneTranferArr = {}
        table.insert(self.sceneTranferArr,1,{id = 0,pos = pos,toScene=sceneId,curScene = sceneId,param= param})
        --print("SceneManager:playerMoveTo",sceneId,pos,showAutoWayTxt,FightModel.autoWayStates)
        self:playRunSceneTransfer(showAutoWayTxt)
    else
        local transferconfig = configHelper:getTransferConfig()
        self.transferSceneDic = {}
        for k,v in pairs(transferconfig) do
            if self.transferSceneDic[v.fromScene] == nil then
                self.transferSceneDic[v.fromScene] = {}
            end
            table.insert(self.transferSceneDic[v.fromScene],{id = v.id,toScene = v.toScene})
        end
        self.searchSceneIdDic = {}
        self:searchTransferList(curSceneId,sceneId,param)
        if self.sceneTranferArr then
            table.insert(self.sceneTranferArr,1,{id = 0,pos = pos,toScene=sceneId,curScene = sceneId,param= param})
            self:playRunSceneTransfer(showAutoWayTxt)
        else
            GlobalAlert:show("该场景不能寻路")
        end
    end
end








--玩家移动到某坐标点,只用在同场景，只在这里用，外部不要调用
function SceneManager:playerMoveToPos(mGrid,showAutoWayTxt,backFun)
    local player = self.fightCon:getSelfPlayerModel()
    local list = nil
    if mGrid ~= nil then
        list = self.fightCon.aStar:find(player.vo.mGrid,mGrid)
    end
    if list == nil then
        GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD, false)
        return
    end
    showAutoWayTxt = showAutoWayTxt or false
    GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD, showAutoWayTxt)
    --临时加上 让其不要继续打
    player.vo.skillId = 0
    RoleManager:getInstance().nextUseSkillID = nil
    FightModel.atkByDefaultSkill = false
    if #list > 0 then
        player:roleMoveTo(list,nil,nil,backFun)
    else
        GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD, false)
        if backFun ~= nil then
            backFun()
        end
    end
end

--跨场景走路，只有在跨场景寻路中用到，其他地方不要用
--传送点之间走动
--SceneObjView里面有调用
function SceneManager:playRunSceneTransfer(showAutoWayTxt)
    if self.sceneTranferArr and #self.sceneTranferArr > 0 then
        self.npcId = nil
        local curSceneId = GameSceneModel.sceneId
        for i=#self.sceneTranferArr,1,-1 do
             local vo = self.sceneTranferArr[i]
             if vo.curScene == curSceneId then
                if #self.sceneTranferArr == 1 then
                    if vo.param then
                        if vo.param.type == 1 then-- npc
                            local npcVO = GameSceneModel:getSceneObjVO(vo.param.npcId,SceneRoleType.NPC)
                            if npcVO then
                                self.npcId  = vo.param.npcId
                                self:playerMoveToNPCByVO(npcVO,showAutoWayTxt)
                            end
                        elseif vo.param.type == 2 then --manster
                            self:playerMoveToPos(vo.pos,showAutoWayTxt)
                            FightModel:setAutoAttackStates(true)
                        elseif vo.param.type == 10 then
                            local backFun =  function()
                                local movebackFun =  function()
                                    GameNet:sendMsgToSocket(14051, {id = tostring(vo.param.id)})
                                end
                                GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_COLLECT_BAR,{time = 3,isOpen = true,id = 0,tips = "挖掘中",backFun = movebackFun})
                            end
                            self:playerMoveToPos(vo.pos,showAutoWayTxt,backFun)
                        end
                    else
                         self:playerMoveToPos(vo.pos,showAutoWayTxt)
                    end
                else
                    self:playerMoveToPos(vo.pos,showAutoWayTxt)
                end
                return
            else
                table.remove(self.sceneTranferArr,#self.sceneTranferArr)
            end
        end 
    end
end

--
function SceneManager:clearTranferArr()
    self.sceneTranferArr = {}
end

--更新传送点，去掉无用的地图以及地图上的点
function SceneManager:updateTranferArrByFlyShoe()
    for i=#self.sceneTranferArr,2,-1 do
        table.remove(self.sceneTranferArr,#self.sceneTranferArr)
    end
    if #self.sceneTranferArr == 1 and self.sceneTranferArr[1].param then
    else
        table.remove(self.sceneTranferArr,1)
    end
end

--搜索场景跳转点用
function SceneManager:searchTransferList(bSceneId,eSceneId,param,object)
    self.searchSceneIdDic[bSceneId] = true
    if self.transferSceneDic[bSceneId] then
        for k,v in pairs(self.transferSceneDic[bSceneId]) do
            local curObj = {parent = object,id = v.id,toScene=v.toScene,curScene = bSceneId}
            if v.toScene == eSceneId then
                self.sceneTranferArr = {}
                local transferconfig = configHelper:getTransferConfig()
                while(curObj ~= nil) do
                    local config = transferconfig[curObj.id]
                    local pstr = StringUtil.SubMiddleStr(config.fromPos,"{","}")
                    local p = StringUtil.split(pstr[1], ",")

                    table.insert(self.sceneTranferArr,{id = curObj.id,pos = {x=tonumber(p[1]),y=tonumber(p[2])},toScene=curObj.toScene,curScene = curObj.curScene,param= param})
                    curObj = curObj.parent
                end
            else
                if self.searchSceneIdDic[v.toScene] == nil then
                    self:searchTransferList(v.toScene,eSceneId,param,curObj)
                end
            end
        end
    else
        
    end
   
end

function SceneManager:getMapConfigById(sceneId)
    if self.mapDic[sceneId] == nil then
        self.mapDic[sceneId] = require("app.conf.map.M"..sceneId.."").new()
    end
    return self.mapDic[sceneId]
end

function SceneManager:curSceneGridIsOpen(sceneId,pos)
    local gridDic = self:getMapConfigById(sceneId).grids
    if gridDic and gridDic[pos.y] and gridDic[pos.y][pos.x] then
        local value = gridDic[pos.y][pos.x]
        if value == 0 then
            return true
        end
   end
   return false
end

function SceneManager:destory()
    self.mapDic = {}
end