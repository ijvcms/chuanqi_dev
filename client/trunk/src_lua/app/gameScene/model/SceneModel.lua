--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-13 23:16:21
-- 场景模型 GameSceneModel
local SceneModel = class("SceneModel")

function SceneModel:ctor( )
	self:init()
end
--GameSceneModel
function SceneModel:init()
    
	self.moveScale = (40/GAME_FRAME_RATE) --移动速度倍数

	self.mapX = 0                    --地图中心位置X
    self.mapY = 0                    --地图中心位置Y
    self.sceneWidth = 0
    self.sceneHeight = 0

    self.sceneId = 0                 --当前地图ID
    self.sceneName = ""              --场景名称
    self.sceneConfig = nil           --场景配置信息
    self.baseMapConfig = nil         --地图基础配置信息
   
    self.safeAreaConf = nil          --安全区配置 {{{56,49},{80,65}}}
    self.inSafeArea = true           --是否在安全区

    self.curSceneHideName = false    --当前场景是否隐藏名称
    self.isInterService = true  --是否跨服场景

    -- 跨服幻境之城  当前房间状态  0 该场景还未通关，1，该场景已经通关
    self.kfhjRoom_pass = nil  

    self.sceneObjPosDic = {}  --地图格子字典，记录当前格子内的角色

    self.fireWallGridDic = {}  --地图火墙格子字典，记录当前格子内的火墙

    --场景对象VO
    self.npcVOArr = {}     --npc
    self.petVOArr = {}     --宠物
    self.playerVOArr = {}  --玩家
    self.playerCopyVOArr = {} --玩家拷贝
    self.monsterVOArr = {}    --怪物
    self.itemVOArr = {}       --场景物品
    self.collectionItemVOArr = {} --场景采集物
    self.fireWallVOArr = {}       --火墙
    self.soldierVOArr = {}  -- 士兵SOLDIER
    self.transferPointArr = {} --传送点数据
end


--获取玩家自身的队伍ID
function SceneModel:getPlayerTeamId()
	local vo = self.playerVOArr[GlobalModel.player_id]
    if vo then
        return vo.teamId
    end
    return "0"
end

--获取玩家自身的VO GameSceneModel:getPlayerVO
function SceneModel:getPlayerVO()
    return self.playerVOArr[GlobalModel.player_id]
end

--添加传送点
function SceneModel:addTransferPointVO(npcVo)
    self.transferPointArr[npcVo.id] = npcVo
end
--是否在传送点上
function SceneModel:isOnTransferPoint(vo)
	local play = RoleManager:getInstance().roleInfo
	local guildInfo = RoleManager:getInstance().guildInfo
    for k,v in pairs(self.transferPointArr) do
        if FightUtil:getDistance(v.pos.x,v.pos.y,vo.pos.x,vo.pos.y) < 40 then
            if play.lv >= v.lv then
                if play.fighting >= v.powerlimit then
                    if guildInfo then
                        if guildInfo.guild_lv >= v.guild_lv_limit then
                            -- 跨服幻境之城 未通关(服务器下发),不传送
                            if GameSceneModel.kfhjRoom_pass ~= nil then
                                if GameSceneModel.kfhjRoom_pass == 0 then
                                    return nil
                                end
                            end
                            return v
                        else
                            GlobalAlert:show("此场景需要帮会"..v.guild_lv_limit.."级才能进入")
                            return nil
                        end
                    else    
                        -- 跨服幻境之城 未通关(服务器下发),不传送
                        if GameSceneModel.kfhjRoom_pass ~= nil then
                            if GameSceneModel.kfhjRoom_pass == 0 then
                                return nil
                            end
                        end
                        return v
                    end
                else
                    if FightUtil:getDistance(v.pos.x,v.pos.y,vo.pos.x,vo.pos.y) < 10 then
                        GlobalAlert:show("此场景需要"..v.powerlimit.."战力才能进入")
                        return nil
                    end
                end
            elseif FightUtil:getDistance(v.pos.x,v.pos.y,vo.pos.x,vo.pos.y) < 10 then
                GlobalAlert:show("此场景需要"..v.lv.."级才能进入")
                return nil
            end
        end
    end
    return nil
end


--添加场景对象
function SceneModel:AddSceneObjVO(sid,sVO)
    if sVO.type == SceneRoleType.PLAYER then
        self.playerVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.PLAYERCOPY then   
        self.playerCopyVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.PET then    
        self.petVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.MONSTER then
        self.monsterVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.SOLDIER then
        self.soldierVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.NPC then
        self.npcVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.ITEM then
        self.itemVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.COLLECTIONITEM then
        self.collectionItemVOArr[sid] = sVO
    elseif sVO.type == SceneRoleType.FIREWALL then
        self.fireWallVOArr[sid] = sVO
    end
end 

--删除场景对象 GameSceneModel:deleteSceneObjVO
function SceneModel:deleteSceneObjVO(roleId,roleType)
    if roleType == SceneRoleType.PLAYER then
        GameSceneModel:removeSceneObjPos(self.playerVOArr[roleId])
        self.playerVOArr[roleId] = nil
    elseif roleType == SceneRoleType.PLAYERCOPY then    
        GameSceneModel:removeSceneObjPos(self.playerCopyVOArr[roleId])
        self.playerCopyVOArr[roleId] = nil
    elseif roleType == SceneRoleType.PET then    
        GameSceneModel:removeSceneObjPos(self.petVOArr[roleId])
        self.petVOArr[roleId] = nil
    elseif roleType == SceneRoleType.MONSTER then
        GameSceneModel:removeSceneObjPos(self.monsterVOArr[roleId])
        self.monsterVOArr[roleId] = nil
    elseif roleType == SceneRoleType.SOLDIER then
        self.soldierVOArr[roleId] = nil
    elseif roleType == SceneRoleType.NPC then
        self.npcVOArr[roleId] = nil
    elseif roleType == SceneRoleType.ITEM then
        self.itemVOArr[roleId] = nil
    elseif roleType == SceneRoleType.COLLECTIONITEM then
        self.collectionItemVOArr[roleId] = nil
    elseif roleType == SceneRoleType.FIREWALL then
        self.fireWallVOArr[roleId] = nil
    end
    if self.selAtkTarVO and self.selAtkTarVO.type == roleType and self.selAtkTarVO.id == roleId then
        self:setSelAtkTarVO(nil) --self.selAtkTarVO = nil
    end
end 

--获取场景对象VO GameSceneModel:getSceneObjVO(id,SceneRoleType.PLAYER)
function SceneModel:getSceneObjVO(id,sType)
    if SceneRoleType.PLAYER == sType then
        return self.playerVOArr[id]
    elseif SceneRoleType.PLAYERCOPY == sType then
        return self.playerCopyVOArr[id]
    elseif SceneRoleType.PET == sType then
        return self.petVOArr[id]
    elseif SceneRoleType.MONSTER == sType then
        return self.monsterVOArr[id]
    elseif SceneRoleType.SOLDIER == sType then
        return self.soldierVOArr[id]
    elseif SceneRoleType.ITEM == sType then
        return self.itemVOArr[id]
    elseif SceneRoleType.COLLECTIONITEM == sType then
        return self.collectionItemVOArr[id]
    elseif SceneRoleType.NPC == sType then
        return self.npcVOArr[id]
    elseif SceneRoleType.FIREWALL == sType then
        return self.fireWallVOArr[id]
    end
    return nil
end


-- 跨服幻境之城
function SceneModel:setKfhjRoomPass(room_pass)
    self.kfhjRoom_pass = room_pass
end

--获取是否在安全区
function SceneModel:getIsSafeArea(p)
    if self.safeAreaConf and self.safeAreaConf[1] then
        for i=1,#self.safeAreaConf do
            local p1 = self.safeAreaConf[i][1]
            local p2 = self.safeAreaConf[i][2]
            if p.x >= p1[1] and p.x <= p2[1] and p.y >= p1[2] and p.y <= p2[2] then
                return true
            end
        end
    end
    return false
end

--获取地图格子类型0可走 1不可走 2可走透明
function SceneModel:getMapGridType(point)
    if self.baseMapConfig and self.baseMapConfig.grids[point.y] then
        return self.baseMapConfig.grids[point.y][point.x]
    end
    return 1
end
--当前地图是否存在该格子
function SceneModel:getHasMapGrid(p)
    if self.baseMapConfig then
        if p.y > 0 and p.x > 0 and p.y <= self.baseMapConfig.gridRow and p.x <= self.baseMapConfig.gridColume then
            return true
        end
    end
    return false
end
--获取地图格子是否可行走
function SceneModel:getMapGridIsOpen(point)
    if self.baseMapConfig and self.baseMapConfig.grids[point.y] and self.baseMapConfig.grids[point.y][point.x] ~= 1 then
        return true
    end
    return false
end
-- 废除
--获取当前格子是否可以行走，是否被怪物占用（已没有用，以前用在挂机）
function SceneModel:getCurGridMove(x,y)
    if self.baseMapConfig.grids[y] == nil or self.baseMapConfig.grids[y][x] == nil or self.baseMapConfig.grids[y][x] == 1 then 
        return false
    end
    local key = string.format("%d%d",x,y)
    if self.sceneObjPosDic[key] then
        for k,v in pairs(self.sceneObjPosDic[key]) do
            return false
        end
    end
    return true
end


--记录火墙格子
function SceneModel:addFireWallGrid(p)
    local key = string.format("%d%d",p.x,p.y)
    if self.fireWallGridDic[key] == nil then
        self.fireWallGridDic[key] = {}
    end
    self.fireWallGridDic[key] = true
end
--移除火墙格子
function SceneModel:removeFireWallGrid(p)
    local key = string.format("%d%d",p.x,p.y)
    if self.fireWallGridDic[key] then
        self.fireWallGridDic[key] = nil
    end
end
--获取当前格子是否有火墙
function SceneModel:getGridFireWall(p)
    local key = string.format("%d%d",p.x,p.y)
    return self.fireWallGridDic[key]
end


--记录场景对象位置格子
function SceneModel:addSceneObjPos(vo) 
    local key = string.format("%d%d",vo.mGrid.x,vo.mGrid.y)
    if self.sceneObjPosDic[key] == nil then
        self.sceneObjPosDic[key] = {}
    end
    self.sceneObjPosDic[key][vo.id] = vo
end
--删除场景对象位置格子
function SceneModel:removeSceneObjPos(vo)
    if vo then
        local key = string.format("%d%d",vo.mGrid.x,vo.mGrid.y)
        if self.sceneObjPosDic[key] then
            self.sceneObjPosDic[key][vo.id] = nil
        end
    end
end
--获取当前位置的场景对象
function SceneModel:getSceneObjPos(p)
    local key = string.format("%d%d",p.x,p.y)
    return self.sceneObjPosDic[key]
end




function SceneModel:clear()
    self.sceneObjPosDic = {}
    self.fireWallGridDic = {}

    for _,v in pairs(self.petVOArr) do
        v:clear()
    end
    self.petVOArr = {}

    for _,v in pairs(self.playerVOArr) do
        v:clear()
    end
    self.playerVOArr = {}

    for _,v in pairs(self.playerCopyVOArr) do
        v:clear()
    end
    self.playerCopyVOArr = {}
    
    for _,v in pairs(self.monsterVOArr) do
        v:clear()
    end
    self.monsterVOArr = {}
    for _,v in pairs(self.soldierVOArr) do
        v:clear()
    end
    self.soldierVOArr = {}

    for _,v in pairs(self.itemVOArr) do
        v:clear()
    end
    self.itemVOArr = {}
    for _,v in pairs(self.collectionItemVOArr) do
        v:clear()
    end
    self.collectionItemVOArr = {}
    for _,v in pairs(self.npcVOArr) do
        v:clear()
    end
    self.npcVOArr = {}

    for _,v in pairs(self.fireWallVOArr) do
        v:clear()
    end
    self.fireWallVOArr = {}

    self.transferPointArr = {}
end

function SceneModel:destory()
    self:clear()
end 
--GameSceneModel
return SceneModel
