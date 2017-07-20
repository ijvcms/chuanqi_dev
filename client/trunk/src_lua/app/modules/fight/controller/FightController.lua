--
-- Author: 21102585@qq.com
-- Date: 2014-11-11 18:00:30
-- 战斗控制器
require("common.astar.FindPath")

require("app.modules.fight.model.FightModel")
require("app.modules.fight.vo.SceneRoleVO")
require("app.modules.fight.vo.BuffVO")
require("app.modules.fight.vo.RoleBaseAttVO")
require("app.modules.fight.const.FightConst")
require("app.modules.fight.const.FightUtil")
require("app.modules.fight.vo.MonsterVO")
require("app.modules.fight.vo.FightAiVO")
require("app.modules.fight.vo.SkillFlyEffVO")
require("app.modules.fight.vo.SceneRoleBuffVO")
require("app.modules.fight.manager.FightEffectManager")
require("app.modules.fight.manager.FightFormula")
require("app.modules.fight.manager.FightSkillManager")
require("app.modules.fight.const.FightConfig")
require("app.modules.fight.view.SceneItem")
require("app.modules.fight.vo.SceneItemVO")
require("app.modules.fight.view.SceneCollectionItem")
require("app.modules.fight.vo.SceneCollectionItemVO")
require("app.modules.fight.view.SceneNpc")
require("app.modules.fight.vo.SceneNpcVO")
require("app.modules.fight.view.SceneBaby")
require("app.modules.fight.vo.SceneBabyVO")
require("app.modules.fight.view.SceneFireWall")
require("app.modules.fight.vo.SceneFireWallVO")
require("app.modules.fight.manager.SceneManager")
require("app.modules.dailyTask.model.TaskManager")

FightController = FightController or class("FightController", BaseController)
FightStates = {
		
	MOVE_FIGHT_MAP = 3, --移动战斗地图场景
	CREAT_ROLE_MODELS = 4, --创建角色模型
	MOVE = 5,--移动阶段
	FIGHED = 7,--该场战斗结束阶段
	MOVE_END = 8,--移动结束阶段


	INIT = 1,--初始化数据阶段
	LOADING = 2,--加载资源阶段	
	FIGHTING = 6,--战斗阶段
	FIGHT_OVER = 9,--战斗结束
	NULL = 10,--空状态
}


function FightController:ctor()	
	self.scene = nil    --场景
	self.sceneRoleLay = nil --场景角色层

	self.hungUpitemId = 1 --  挂机物品ID

	self.roleNum = 0
	self.monsterNum = 0
	self.playEff = 1
	self.shengEff= 1
	
	self.idNum = 100
	self.isFighting = false --是否战斗中

	FightSkillManager:ctor() --技能管理器
	FightEffectManager:ctor()
	SceneManager:ctor(self)
	
	self.hadOpenSign = false

	self.times = 1

	GlobalEventSystem:addEventListener(WorShipEvent.WSE_UPDATE_INFO,handler(self, self.updateWorShipNpc))

	--self.resDic = {}

	--self.resList = {}  --资源列表
	-- self.soundDic = {} --声音资源列表

	self.chapterId = 0   --关卡ID
	self.chapterType = 0 --关卡类型

	self.fightTimes = 0 --战斗场次
	
	--用来计算战斗中的时间参数
	self.perFrameTime = 0
	self.curFrameTime = 0	
	-- FightModel.fightTime = 0

	--独立游戏添加

	self.npcViewArr = {}  --NPC视图字典  transferPointArr 传送点放这里面
	self.babyViewArr = {}  --baby视图字典 外观宠物 (已删除)
	self.petViewArr = {}  --宠物视图字典
	self.playerViewArr = {}  --玩家视图字典
	self.playerCopyViewArr = {}  --玩家视图字典
	self.monsterViewArr = {} --怪物字典
	self.itemViewArr = {} --物品字典
	self.collectionItemViewArr = {} --采集物品字典
	self.fireWallViewArr = {} --火墙字典
	self.soldierViewArr = {} --士兵字典   = SOLDIER


	self.roleid = 0

	self.isDebug = false   --Debug model
	self.fightStates = FightStates.INIT--FIGHTING

	self.fightModel = FightModel

	self.sceneModel = GameSceneModel
	
	self.fightModel:init()
	self.isLoadComplete = false   --资源加载姿态

	self.aStar = nil
	self.isloading = false

	self.copyInfo = nil   		--副本信息
	self.winnerInfo = nil --胜者为王

	self.maxPlayNum = 0
	self:registerProto()
	self.backSFrameTime = (1000/60)/1000
	self.errorFrameTime = self.backSFrameTime*0.8
	self.curSFrameTime = 0

	if device.platform == "android" then
		self.backSFrameTime = (1000/GAME_FRAME_RATE)/1000
		self.errorFrameTime = self.errorFrameTime*0.8
	end

	self.playIsVisible = true
end

function FightController:setScene(sceneView)
	print(" ===>>> FightController:setScene")
	self.scene = sceneView
	self.sceneRoleLay = self.scene.battle.sceneObjLay
end	

function FightController:getScene()	
	return self.scene
end	


function FightController:initScene(sceneId)
	self.sceneModel:clear()
	FightModel:destory()
	self:destory()
	if self.scene then
		self.scene:close()
	end
	FightSkillManager:destory()
	FightEffectManager:close()

	sceneId = sceneId or 0
	self.sceneModel.sceneId = sceneId
	
	if tonumber(sceneId) == 20404 then
		self.sceneModel.curSceneHideName = true
	else
		self.sceneModel.curSceneHideName = false
	end
	
	local sceneConf = getConfigObject(sceneId,ActivitySceneConf)
    if sceneConf and sceneConf.iscross == 1 then
		self.sceneModel.isInterService = true
	else
		self.sceneModel.isInterService = false
	end

    self.sceneModel.sceneConfig = sceneConf
    self.sceneModel.safeAreaConf = sceneConf.safeArea
    self.sceneModel.sceneName = sceneConf.name or "ERROR"

    local baseMapConfig = SceneManager:getMapConfigById(sceneConf.mapId)
	self.sceneModel.baseMapConfig = baseMapConfig--require("app.conf.map.M"..resMapId.."").new()

	self.aStar = FindPath.new(baseMapConfig.grids)
	self.sceneModel.sceneWidth = baseMapConfig.width
	self.sceneModel.sceneHeight = baseMapConfig.height

	RoleManager:getInstance().nextUseSkillID = nil

    -- local dest_point = self.aStar:createPoint(endPos[1], endPos[2])
    -- local start_point = self.aStar:createPoint(startPos[1], startPos[2])
    -- local _path = self.aStar:findPath(self.sceneDeleget, start_point, dest_point)
    GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_CHANG)
    GlobalWinManger:closeAllWindow()

    
end


--开始战斗
--主要功能，获取我方信息，获取敌方信息
--@param playerList 玩家列表：{roleVO,roleVO,roleVO} roleVO中填充roleID和grid
--@param sceneId  场景ID
--@param sceneType  场景Type
function FightController:playBattle(playerList,sceneId,sceneType,roleId)
	self.maxPlayNum = 0
	self.sceneModel.sceneId = sceneId
   
    RoleManager:getInstance():initSkillList()
	self:stopSchedule()
	
	self.roleid = roleId

	for i=1,#playerList do
		local vo = playerList[i]
		self.sceneModel:AddSceneObjVO(vo.id,vo)
	end

	local data = WorShipManager:getInstance().ws_list
	--添加场景上的NPC
	for k,v in pairs(NpcConf) do
		if self.sceneModel.sceneId == v.sceneId then
			local npc = SceneNpcVO.new() 			
			npc.show = v.show
			npc.name = v.name
			npc.id = v.id
			npc.modelID = v.resId
			--local p = StringUtil.split(v.pos, ",")
			npc.mGrid = {x=tonumber(v.x),y=tonumber(v.y)}
			npc.pos = FightUtil:gridToPoint(npc.mGrid.x,npc.mGrid.y)
			npc.desc = v.desc
			npc.dialogue = v.dialogue
			npc.npcType = v.type
			npc.param = v.param
			npc.order = v.order

			for i=1,#data do
 				if data[i].career == v.career then
 					npc.name = data[i].name
 					if data[i].sex == 2 then
 						npc.modelID = v.girl
 					end
 				end
 			end

			local taskInfo = TaskManager:getInstance():getTaskByNpcId(npc.id)
			if taskInfo ~= nil then
				if taskInfo.state == 2 and npc.id == taskInfo.accept_npc_id then
					--显示有任务可接
					npc.showTaskTip = 2
				elseif taskInfo.state == 1 and npc.id == taskInfo.finish_npc_id then
					--显示有任务奖励可以领
					npc.showTaskTip = 1
				elseif taskInfo.state == 0 and taskInfo.type == 3 and npc.id == taskInfo.accept_npc_id then
					--功勋任务可快速快速
					npc.showTaskTip = 0
				elseif taskInfo.state == 0 and taskInfo.type == 4 and npc.id == taskInfo.finish_npc_id then
					--功勋任务可快速快速
					npc.showTaskTip = 0
				elseif taskInfo.state == 0 and taskInfo.type == 8 and npc.id == taskInfo.finish_npc_id then
					--功勋任务可快速快速
					npc.showTaskTip = 0
				end
			end

			--self:addNpcModel(npc)

			if npc.npcType == NpcType.TRANSFER_POINT then
				self.sceneModel:addTransferPointVO(npc)
			else
				self.sceneModel:AddSceneObjVO(npc.id,npc)
			end
		end
	end
	--添加传送门
	local transferconfig = configHelper:getTransferConfig()
	for k,v in pairs(transferconfig) do
		if self.sceneModel.sceneId == v.fromScene then
			local npc = SceneNpcVO.new() 
			npc.name = v.name
			npc.id = v.id
			npc.modelID = v.res
			local pstr = StringUtil.SubMiddleStr(v.fromPos,"{","}")
			local p = StringUtil.split(pstr[1], ",")
			npc.mGrid = {x=tonumber(p[1]),y=tonumber(p[2])}
			npc.pos = FightUtil:gridToPoint(npc.mGrid.x,npc.mGrid.y)
			npc.npcType = NpcType.TRANSFER_POINT
			npc.lv = v.lvLimit
			npc.powerlimit = v.powerlimit or 0
			npc.guild_lv_limit = v.guild_lv_limit or 0
			--self:addNpcModel(npc)
			self.sceneModel:addTransferPointVO(npc)
		end
	end

	self.fightStates = FightStates.LOADING

	GameNet:sendMsgToSocket(11053, {top = 50})

	-- if #self.playerList >= 1 then
	-- 	self.isLoadComplete = false
	-- 	self:loadRes(isFirst)
	-- else
	-- 	--游戏结束处理
	-- 	self:FightOver()
	-- end
end


local function _checkIsHpMpGameObject(type)
	if not type then return false end
	
	return type == SceneRoleType.PLAYER or 
		   type == SceneRoleType.PLAYERCOPY or 
		   type == SceneRoleType.MONSTER or 
		   type == SceneRoleType.BOSS or 
		   type == SceneRoleType.PET or 
		   type == SceneRoleType.SOLDIER or
		   type == SceneRoleType.BABY
end

function FightController:updateRoleList()
	-- self.pp=self.pp+1
	-- if self.pp%3 == 0 then
	-- else
	-- 	return
	-- end	
	-- INIT = 1,--初始化数据阶段
	-- LOADING = 2,--加载资源阶段
	-- FIGHTING = 6,--战斗阶段
	-- FIGHT_OVER = 9,--战斗结束
	-- NULL = 10,--空状态
	self.curFrameTime = socket.gettime()

	self.curSFrameTime = self.curFrameTime - self.perFrameTime

	self.backSFrameTime = (self.backSFrameTime*9+self.curSFrameTime)/10
	if self.backSFrameTime < self.errorFrameTime then
		--self:stopSchedule()
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
	end
	-- print(self.backSFrameTime,self.errorFrameTime)
	
	if self.fightStates == FightStates.FIGHTING or self.fightStates == FightStates.MOVE then
		self.isFighting = true
		if self.fightStates == FightStates.FIGHTING then
			self.fightModel.fightTime = self.fightModel.fightTime + self.curSFrameTime
		end
		--if true then return end
		local t = self.times%2
		self.times = self.times +1
		local xx = self.sceneModel.mapX
		local yy = self.sceneModel.mapY

		self.roleNum = 0

		local itemView --显示对象
		local isAdd = false --是否增加
		
		if t == 0 then
		--if true then
	 		-- for k,v in pairs(self.playerViewArr) do	
	 		-- 	self.roleNum = self.roleNum +1		
	 		-- 	v:update(self.fightModel.fightTime)
	 		-- 	-- if FightUtil:getDistance(xx,yy,v.vo.pos.x,v.vo.pos.y) > 600 then
	 		-- 	-- 	v:setRoleVisible(false)
	 		-- 	-- else
	 		-- 	-- 	v:setRoleVisible(true)
	 		-- 	-- end
	 		-- end
	 		--if vo.id == GlobalModel.player_id and vo.type == SceneRoleType.PLAYER then 
	 		for k,v in pairs(self.sceneModel.playerVOArr) do
	 			--if v.id ~= GlobalModel.player_id then
		 			itemView = self.playerViewArr[v.id]
		 			if itemView then
		 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
		 				--itemView:update(self.fightModel.fightTime)
		 				-- if self.playIsVisible then
			 			-- 	if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 500 then
				 		-- 		itemView:setRoleVisible(false)
				 		-- 		--self:deleteRoleModel(v.id,v.type)
				 		-- 	else
				 		-- 		itemView:setRoleVisible(true)
				 		-- 	end
				 		-- end
				 		self.roleNum = self.roleNum +1	
		 			elseif self.times%3 == 0 then
		 				if isAdd == false then
		 					isAdd = true
			 				self:addRoleModel(v)
			 			end
		 			end
		 		--end
	 		end


	 		isAdd = false
	 		self.maxPlayNum = self.roleNum
	 		-- for k,v in pairs(self.petViewArr) do
	 		-- 	v:update(self.fightModel.fightTime)
	 		-- end
	 		for k,v in pairs(self.sceneModel.petVOArr) do
	 			itemView = self.petViewArr[v.id]
	 			if itemView then
	 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
	 				--itemView:update(self.fightModel.fightTime)
	 				if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 600 then
	 					if itemView:isVisible() then
			 				itemView:setRoleVisible(false)
			 			end
		 				--self:deleteRoleModel(v.id,v.type)
		 			elseif itemView:isVisible() == false then
		 				itemView:setRoleVisible(true)
		 			end
	 			elseif self.times%5 == 0 then
	 				if isAdd == false then
	 					isAdd = true
		 				self:addRoleModel(v)
		 			end
	 			end
	 		end

	 		-- for k,v in pairs(self.playerCopyViewArr) do
	 		-- 	v:update(self.fightModel.fightTime)
	 		-- end
	 		isAdd = false
	 		for k,v in pairs(self.sceneModel.playerCopyVOArr) do
	 			itemView = self.playerCopyViewArr[v.id]
	 			if itemView then
	 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
	 				--itemView:update(self.fightModel.fightTime)
	 				-- if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 500 then
		 			-- 	itemView:setRoleVisible(false)
		 			-- 	--self:deleteRoleModel(v.id,v.type)
		 			-- else
		 			-- 	itemView:setRoleVisible(true)
		 			-- end
	 			elseif self.times%7 == 0 then
	 				if isAdd == false then
	 					isAdd = true
		 				self:addRoleModel(v)
		 			end
	 			end
	 		end

	 	end
	 	if t==1 then
	 		self.monsterNum = 0
	 		isAdd = false
	 		for k,v in pairs(self.sceneModel.monsterVOArr) do--monsterVOArr	
	 			itemView = self.monsterViewArr[v.id]
	 			if itemView then
	 				self.monsterNum = self.monsterNum + 1
	 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
	 				--itemView:update(self.fightModel.fightTime)
	 				-- if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 500 then
		 			-- 	itemView:setRoleVisible(false)
		 			-- 	--self:deleteRoleModel(v.id,v.type)
		 			-- else
		 			-- 	itemView:setRoleVisible(true)
		 			-- end
	 			elseif self.times%5 == 0 then
	 				if isAdd == false then
	 					isAdd = true
		 				self:addRoleModel(v)
		 			end
	 			end
	 		end

	 		if self.monsterNum > 0 then
				self.isloading = false
			end
	 		--刷完怪请求服务器获取新的怪点
	 		--场景类型2、3才刷新
	 		
	 		-- if self.sceneModel.sceneConfig.type == 2 or  self.sceneModel.sceneConfig.type == 3 then
 
		 	-- 	if self.monsterNum == 0 and FightModel:getAutoAttackStates() then
		 	-- 		if self.isloading == false then
		 	-- 			self.isloading = true
		 	-- 			GameNet:sendMsgToSocket(11021)
		 	-- 		end
		 	-- 	end
	 		-- end
		end
		if t==0 then
	 		-- for k,v in pairs(self.fireWallViewArr) do		
	 		-- 	v:update(self.fightModel.fightTime)
	 		-- end
	 		isAdd = false
	 		for k,v in pairs(self.sceneModel.fireWallVOArr) do
	 			itemView = self.fireWallViewArr[v.id]
	 			if itemView then
	 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
	 				--itemView:update(self.fightModel.fightTime)
	 				if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 600 then
	 					if itemView:isVisible() then
			 				itemView:setRoleVisible(false)
			 			end
		 			--self:deleteRoleModel(v.id,v.type)
		 			elseif itemView:isVisible() == false then
		 				itemView:setRoleVisible(true)
		 			end
	 			elseif self.times%3 == 0 then
	 				if isAdd == false then
	 					isAdd = true
		 				self:addRoleModel(v)
		 			end
	 			end
	 		end

	 		-- for k,v in pairs(self.soldierViewArr) do	
	 		-- 	v:update(self.fightModel.fightTime)
	 		-- 	if FightUtil:getDistance(xx,yy,v.vo.pos.x,v.vo.pos.y) > 500 then
	 		-- 		v:setRoleVisible(false)
	 		-- 	else
	 		-- 		v:setRoleVisible(true)
	 		-- 	end
	 		-- end

	 		isAdd = false
	 		for k,v in pairs(self.sceneModel.soldierVOArr) do
	 			itemView = self.soldierViewArr[v.id]
	 			if itemView then
	 				GlobalController.model:push(itemView, "update", self.fightModel.fightTime)
	 				--itemView:update(self.fightModel.fightTime)
	 				if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 700 then
	 					if itemView:isVisible() then
			 				itemView:setRoleVisible(false)
			 			end
		 				--self:deleteRoleModel(v.id,v.type)
		 			elseif itemView:isVisible() == false then
		 				itemView:setRoleVisible(true)
		 			end
	 			elseif self.times%6 == 0 then
	 				if isAdd == false then
	 					isAdd = true
		 				self:addRoleModel(v)
		 			end
	 			end
	 		end
		end
		
		if self.times%20 == 0 then
			
			for k,v in pairs(self.sceneModel.npcVOArr) do	
				itemView = self.npcViewArr[v.id]	
	 			if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 700 then
	 				if itemView and itemView:isVisible() then
	 					itemView:setRoleVisible(false)
	 					itemView:pause()
		 				--self:delNpcModel(v.id)
		 			end
	 			else
	 				if itemView then
	 					--itemView:update(self.fightModel.fightTime)
	 					if false == itemView:isVisible() then
		 					itemView:setRoleVisible(true)
		 					itemView:resume()
		 				end
	 				else
	 					self:addNpcModel(v)
	 					break
	 				end
	 			end
	 		end
	 		
	 		for k,v in pairs(self.sceneModel.transferPointArr) do
	 			itemView = self.npcViewArr[v.id]	
	 			if FightUtil:getDistance(xx,yy,v.pos.x,v.pos.y) > 700 then
	 				if itemView and itemView:isVisible() then
	 					itemView:setRoleVisible(false)
		 				--self:delNpcModel(v.id)
		 			end
	 			else
	 				if itemView then
	 					--itemView:update(self.fightModel.fightTime)
	 					if false == itemView:isVisible() then
				 			-- 跨服幻境之城
				 			if self.sceneModel.kfhjRoom_pass == nil or self.sceneModel.kfhjRoom_pass == 1  then
				 				itemView:setRoleVisible(true)
				 			end		 					
		 				end
	 				else
	 					self:addNpcModel(v)
	 					break
	 				end
	 			end

	 			-- 跨服幻境之城
	 			if itemView ~= nil and self.sceneModel.kfhjRoom_pass ~= nil and self.sceneModel.kfhjRoom_pass == 0  then
	 				if true == itemView:isVisible() then
	 					itemView:setRoleVisible(false)
	 				end
	 			end

	 		end
	 	end

		if self.times%120 == 0 then
			ArmatureManager:getInstance():update()
		end
			--self.fightModel.fightTime
		if t==0 then 
			for k,v in pairs(RoleManager:getInstance().fightSkillBaseList) do
				v:update()
			end
			FightSkillManager:update(self.fightModel.fightTime) --更新技能管理器，主要是处理Buff功能
			FightEffectManager:update(socket.gettime()) --更新技能管理器，主要是处理Buff功能
		end
	
	elseif self.fightStates == FightStates.FIGHT_OVER then

	-- elseif self.fightStates == FightStates.LOADING or self.fightStates == FightStates.INIT then
		
	-- elseif self.fightStates == FightStates.NULL then

	end
	self.perFrameTime = self.curFrameTime
end



--暂停
function FightController:pause()

	for k,v in pairs(self.playerCopyViewArr) do
	 	v:pause()	
	end
	for k,v in pairs(self.petViewArr) do	
	 	v:pause()	
	end
	for k,v in pairs(self.playerViewArr) do
	 	v:pause()	 			
	end
	for k,v in pairs(self.monsterViewArr) do
	 	v:pause()	 			
	end
	for k,v in pairs(self.itemViewArr) do
	 	v:pause()	 			
	end
	for k,v in pairs(self.collectionItemViewArr) do
	 	v:pause()	 			
	end
	
	for k,v in pairs(self.npcViewArr) do	
	 	v:pause()	 			
	end
	for k,v in pairs(self.fireWallViewArr) do	 			
	 	v:pause()	 			
	end

	for k,v in pairs(self.soldierViewArr) do	 			
	 	v:pause()	 			
	end

	self.preFightStates = self.fightStates
	self.fightStates = FightStates.NULL
end	

--恢复暂停
function FightController:resume()
	
	for k,v in pairs(self.playerCopyViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.petViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.playerViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.monsterViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.itemViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.collectionItemViewArr) do	 			
	 	v:resume()	
	end
	for k,v in pairs(self.npcViewArr) do	 			
	 	v:resume()	
	end
	
	for k,v in pairs(self.fireWallViewArr) do	 			
	 	v:resume()	
	end

	for k,v in pairs(self.soldierViewArr) do	 			
	 	v:resume()	
	end
	

	self.fightStates = self.preFightStates
end




---------------------战斗流程控制------------------------------------------------------------------------------------

--开启执行帧事件
function FightController:playSchedule()
	-- local listenerFun =  function()
	-- 	self:updateRoleList()
	-- end
	if self.timerId == nil then
		self.times = 1
		self.perFrameTime = socket.gettime()
		--self.timerId = GlobalTimer.scheduleUpdateGlobal(handler(self,self.updateRoleList),0.022)
		self.timerId =  GlobalTimer.scheduleUpdateGlobal(handler(self,self.updateRoleList))
	end
end	

--停止执行帧事件
function FightController:stopSchedule()
	if self.timerId then
		GlobalTimer.unscheduleGlobal(self.timerId)
		self.timerId = nil
	end
	self.isFighting = false
	GlobalController.model:destory()
end

function FightController:setPlayerVisible(b)
	self.playIsVisible = b
	for k,v in pairs(self.playerViewArr) do
		if v.vo.id ~= GlobalModel.player_id and v.vo.type == SceneRoleType.PLAYER then
			v:setRoleVisible(b)
		end
	end
end

--添加场景角色
function FightController:addSceneRole(roleVO)
	if self.sceneRoleLay == nil then return end
	if roleVO.type == SceneRoleType.PLAYER and self.maxPlayNum > 40 and roleVO.id ~= GlobalModel.player_id then
		return
	end
	self.sceneModel:AddSceneObjVO(roleVO.id,roleVO)
	--self.sceneRoleLay = nil
	self:addRoleModel(roleVO)
end

--删除场景角色
function FightController:delSceneRole(roleId,roleType)
	self.sceneModel:deleteSceneObjVO(roleId,roleType)	
	self:deleteRoleModel(roleId,roleType)
end

--删除场景物品
function FightController:delSceneItem(itemId)
	self.sceneModel:deleteSceneObjVO(itemId,SceneRoleType.ITEM)
	self:deleteItemModel(itemId)
end

--删除场景采集物品
function FightController:delSceneCollectionItem(itemId)
	self.sceneModel:deleteSceneObjVO(itemId,SceneRoleType.COLLECTIONITEM)
	self:deleteCollectionItemModel(itemId)
end

--删除场景物品
function FightController:delSceneFireWall(sId)
	self.sceneModel:deleteSceneObjVO(sId,SceneRoleType.FIREWALL)
	self:deleteFireWallModel(sId)
end

--添加场景角色，怪物，物品等
function FightController:addRoleModel(roleVO)
	-- self:print("addRoleModel roleId = "..roleVO.id)
	if self.sceneRoleLay == nil then return end
	local viewArr
	if roleVO.type == SceneRoleType.PLAYER then
		viewArr = self.playerViewArr
		if viewArr[roleVO.id] then
			self:deleteRoleModel(roleVO.id,roleVO.type)
		end
		GlobalEventSystem:dispatchEvent(SceneEvent.MAP_ADD_ROLE,roleVO)
		-- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/d5cd58cfa5024519bb96c11b0aeaa13b/
		-- 进入音效音效
		if viewArr[roleVO.id] == nil then
			SoundManager:playSound(SoundType.TRANSFER)
		end
	elseif roleVO.type == SceneRoleType.PET then
		viewArr = self.petViewArr
		if viewArr[roleVO.id] then
			self:deleteRoleModel(roleVO.id,roleVO.type)
		end
	elseif roleVO.type == SceneRoleType.PLAYERCOPY then
		viewArr = self.playerCopyViewArr
		if viewArr[roleVO.id] then
			self:deleteRoleModel(roleVO.id,roleVO.type)
		end
	elseif roleVO.type == SceneRoleType.MONSTER then
		viewArr = self.monsterViewArr
		if viewArr[roleVO.id] then
			self:deleteRoleModel(roleVO.id,roleVO.type)
		end
		GlobalEventSystem:dispatchEvent(SceneEvent.MAP_ADD_ROLE,roleVO)

		-- 怪物攻击进屏幕的时候播放音效（发现音效）
        -- https://tower.im/projects/d3a2760cad124566b4057bd59b3f9a45/todos/90b02757892445fb9b5521782b697139/
        local monster_id = roleVO.monster_id
        if math.random(1,10) > 5 then
	        local discoverSound = configHelper:getMonsterDiscoverSound(monster_id)
	        if discoverSound then
	            SoundManager:playSound(discoverSound)
	        end
	    end
	elseif roleVO.type == SceneRoleType.SOLDIER then
		viewArr = self.soldierViewArr
		if viewArr[roleVO.id] then
			self:deleteRoleModel(roleVO.id,roleVO.type)
		end
	elseif roleVO.type == SceneRoleType.NPC then
		self:addNpcModel(roleVO)
		return
	elseif roleVO.type == SceneRoleType.ITEM then
		self:addItemModel(roleVO)
		return
	elseif roleVO.type == SceneRoleType.COLLECTIONITEM then
		self:addCollectionItemModel(roleVO)
		return
	elseif roleVO.type == SceneRoleType.FIREWALL then
		self:addFireWallModel(roleVO)
		return
	end
	local role = SceneRole.new(roleVO)
    --role:setPosition(roleVO.pos.x,roleVO.pos.y)
    if roleVO.id == GlobalModel.player_id and roleVO.type == SceneRoleType.PLAYER then 
    	self.sceneModel.inSafeArea = self.sceneModel:getIsSafeArea(roleVO.mGrid)
		GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_MAP_POS,cc.p(roleVO.pos.x,roleVO.pos.y))
	end
    self.sceneRoleLay:addChild(role)
    --role:setLocalZOrder(2000-roleVO.pos.y)
    
    if roleVO.movePos and roleVO.pos.x ~= roleVO.movePos.x and roleVO.pos.y ~= roleVO.movePos.y  then
    	--print("FightController:addRoleModel(roleVO)  ")
    	local end_point = FightUtil:pointToGrid(roleVO.movePos.x, roleVO.movePos.y)
    	role:roleMoveTo({end_point})
    end
	viewArr[roleVO.id] = role
end

-- --添加场景BaBy外观宠物
-- function FightController:addBabyModel(vo)
-- 	if self.babyViewArr[vo.id] then
-- 		self:delBabyModel(vo.id,vo.type)
-- 	end
-- 	local item = SceneBaby.new(vo)
-- 	self.sceneRoleLay:addChild(item)
--     --item:setLocalZOrder(2000-vo.pos.y)
--     self.babyViewArr[vo.id] = item
-- end

-- --添加场景BaBy外观宠物
-- function FightController:delBabyModel(id)
-- 	if self.babyViewArr[id] then
-- 		local view = self.babyViewArr[id]
-- 		view:destory()
-- 		self.babyViewArr[id] = nil
-- 	end
-- end

--添加Npc
function FightController:addNpcModel(vo)
	if self.npcViewArr[vo.id] then
		self:delNpcModel(vo.id,vo.type)
	end
	if self.sceneRoleLay then
		local item = SceneNpc.new(vo)
		self.sceneRoleLay:addChild(item)
	    --item:setLocalZOrder(2000-vo.pos.y)
	    self.npcViewArr[vo.id] = item

	    -- 跨服幻境之城 默认传送门隐藏
	    if vo.npcType == NpcType.TRANSFER_POINT then
			if self.sceneModel ~= nil and self.sceneModel.sceneId ~= nil and self.sceneModel.sceneId ~= 0 then
				local conf = configHelper:getCopyInfo(self.sceneModel.sceneId)
				if conf ~= nil and conf.instanceType == 16 then -- 大厅15,小房间16
					item:setRoleVisible(false)
				end
			end
	    end

	end
end

--更新Npc任务标记
function FightController:updateNpcTaskTip(vo)
	if self.sceneModel.npcVOArr[vo.id] then
		self.sceneModel.npcVOArr[vo.id].showTaskTip = vo.showTaskTip
	end
	if self.npcViewArr[vo.id] then
		local item = self.npcViewArr[vo.id]
		item:updateTaskTip(vo.showTaskTip)
    end
end

function FightController:updateWorShipNpc(data)
	data = data.data
	for k,v in pairs(NpcConf) do
		if self.sceneModel.sceneId == v.sceneId  and v.type == 7 then
			local npc = SceneNpcVO.new() 
			npc.show = v.show
			npc.name = v.name
			npc.id = v.id
			npc.modelID = v.resId
			--local p = StringUtil.split(v.pos, ",")
			npc.mGrid = {x=tonumber(v.x),y=tonumber(v.y)}
			npc.pos = FightUtil:gridToPoint(npc.mGrid.x,npc.mGrid.y)
			npc.desc = v.desc
			npc.dialogue = v.dialogue
			npc.npcType = v.type
			npc.param = v.param
			npc.order = v.order
 
 			for i=1,#data do
 				if data[i].career == v.career then
 					npc.name = data[i].name
 					if data[i].sex == 2 then
 						npc.modelID = v.girl
 					end
 				end
 			end

 			self.sceneModel:AddSceneObjVO(npc.id,npc)
			self:addNpcModel(npc)
 
		end

	end
end

--删除Npc
function FightController:delNpcModel(id)
	if self.npcViewArr[id] then
		local view = self.npcViewArr[id]
		view:destory()
		self.npcViewArr[id] = nil
	end
end

--添加场景物品
function FightController:addItemModel(roleVO)
	if self.itemViewArr[roleVO.id] then
		self:deleteItemModel(roleVO.id,roleVO.type)
	end
	local item = SceneItem.new(roleVO)
	self.sceneRoleLay:addChild(item)
    --item:setLocalZOrder(2000-roleVO.pos.y)
    self.itemViewArr[roleVO.id] = item
end

function FightController:addCollectionItemModel(vo)
	if self.collectionItemViewArr[vo.id] then
		self:deleteCollectionItemModel(vo.id,vo.type)
	end
	local item = SceneCollectionItem.new(vo)
	self.sceneRoleLay:addChild(item)
    --item:setLocalZOrder(2000-vo.pos.y)
    self.collectionItemViewArr[vo.id] = item
end


--获取场景显示对象
function FightController:getRoleModel(roleId,roleType)
	-- self:print("getRoleModel roleId = "..roleId)
	if roleType == SceneRoleType.PLAYER then
		return self.playerViewArr[roleId]
	elseif roleType == SceneRoleType.PET then
		return self.petViewArr[roleId]
	elseif roleType == SceneRoleType.PLAYERCOPY then
		return self.playerCopyViewArr[roleId]
	elseif roleType == SceneRoleType.MONSTER then
		return self.monsterViewArr[roleId]
	elseif roleType == SceneRoleType.SOLDIER then
		return self.soldierViewArr[roleId]
	elseif roleType == SceneRoleType.ITEM then
		return self.itemViewArr[roleId]
	elseif roleType == SceneRoleType.COLLECTIONITEM then
		return self.collectionItemViewArr[roleId]
	elseif roleType == SceneRoleType.NPC then
		return self.npcViewArr[roleId]
	end
	return nil
end

function FightController:getSelfPlayerModel()
	return self.playerViewArr[GlobalModel.player_id]
end

--拾取物品相关

--获取玩家自身的物品
function FightController:getSelfItemModel(playVO,isBagRemain)
	local itemVO = nil
	local minGrid = 100000
	if isBagRemain then
		for k,v in pairs(self.itemViewArr) do
			if self:isAutoPickUpDropItem(v.vo) and self:canGetDropItem(playVO,v.vo) then
				local dis = math.abs(v.vo.mGrid.x -playVO.mGrid.x)  +math.abs(v.vo.mGrid.y -playVO.mGrid.y)
				if dis < 20 then
					if itemVO == nil then
						itemVO = v.vo
						minGrid = dis
					elseif itemVO.quality < v.vo.quality then
						itemVO = v.vo
						minGrid = dis
					elseif itemVO.quality == v.vo.quality then
						if dis < minGrid then
							itemVO = v.vo
							minGrid = dis
						end
					end
				end
			end
		end
	else
		for k,v in pairs(self.itemViewArr) do
			--拾取金币
			if self:isAutoPickUpDropItem(v.vo) and self:canGetDropItem(playVO,v.vo) and v.vo.itemType == GoodsType.MONEY  then
				local dis = math.abs(v.vo.mGrid.x -playVO.mGrid.x)  +math.abs(v.vo.mGrid.y -playVO.mGrid.y)
				if dis < minGrid and dis < 20 then
					itemVO = v.vo
					minGrid = dis
				end
			end
		end
	end
	return itemVO
end
--是否可以拾取
function FightController:canGetDropItem(playVO,itemVO)
	--print("canGetDropItem",itemVO.teamId,playVO.teamId)
	if itemVO.teamId == playVO.teamId and itemVO.teamId ~= "0" then
		return true
	elseif itemVO.playID == playVO.id and itemVO.playID ~= "0" then
		return true
	elseif itemVO.teamId == "0" and itemVO.playID == "0" then
		return true
	end
	return false
end


--物品是否自动拾取
function FightController:isAutoPickUpDropItem(itemVO)
	if SysOptionModel.switchPickupMain == false then
		return false
	end
	local pickUpSpType = configHelper:getPickUpSpItemTypeByID(itemVO.itemID)
	if pickUpSpType ~= 0 then
		local curIdCanPickUp = SysOptionModel:getOptionByDefine(DefineOptions["PICK_SP_"..pickUpSpType])
		if curIdCanPickUp then
			return true
		else
			return false
		end
	end
	if itemVO.itemType == GoodsType.PROP or itemVO.itemType == GoodsType.CONSUME or itemVO.itemType == GoodsType.GIFT then
		if itemVO.quality == GoodsQualityType.WHITE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_PROP_WHITE) then
			return true
		elseif itemVO.quality == GoodsQualityType.GREEN and SysOptionModel:getOptionByDefine(DefineOptions.PICK_PROP_GREEN) then
			return true
		elseif itemVO.quality == GoodsQualityType.BLUE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_PROP_BLUE) then
			return true
		elseif itemVO.quality == GoodsQualityType.PURPLE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_PROP_PURPLE) then
			return true
		elseif itemVO.quality >= GoodsQualityType.ORANGE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_PROP_ORANGE) then
			return true
		end
	elseif itemVO.itemType == GoodsType.EQUIP then
		if itemVO.quality == GoodsQualityType.WHITE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_EQUIP_WHITE) then
			return true
		elseif itemVO.quality == GoodsQualityType.GREEN and SysOptionModel:getOptionByDefine(DefineOptions.PICK_EQUIP_GREEN) then
			return true
		elseif itemVO.quality == GoodsQualityType.BLUE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_EQUIP_BLUE) then
			return true
		elseif itemVO.quality == GoodsQualityType.PURPLE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_EQUIP_PURPLE) then
			return true
		elseif itemVO.quality >= GoodsQualityType.ORANGE and SysOptionModel:getOptionByDefine(DefineOptions.PICK_EQUIP_ORANGE) then
			return true
		end
	end

	-- if (itemVO.itemType == GoodsType.PROP or itemVO.itemType == GoodsType.CONSUME or itemVO.itemType == GoodsType.GIFT) and SysOptionModel.switchPickupProp then --道具
	-- 	return true
	-- elseif itemVO.itemType == GoodsType.EQUIP and SysOptionModel.switchPickupEquipMain then --装备
	-- 	if itemVO.quality == GoodsQualityType.WHITE and SysOptionModel.switchPickupEquipW then
	-- 		return true
	-- 	elseif itemVO.quality == GoodsQualityType.GREEN and SysOptionModel.switchPickupEquipG then
	-- 		return true
	-- 	elseif itemVO.quality == GoodsQualityType.BLUE and SysOptionModel.switchPickupEquipB then
	-- 		return true
	-- 	elseif itemVO.quality == GoodsQualityType.PURPLE and SysOptionModel.switchPickupEquipP then
	-- 		return true
	-- 	elseif itemVO.quality == GoodsQualityType.ORANGE and SysOptionModel.switchPickupEquipP then
	-- 		return true
	-- 	end

	-- elseif itemVO.itemType == GoodsType.MONEY and SysOptionModel.switchPickupMoney then --金币
	-- 	return true
	-- end
	return false
end

--获取当前格子的物品
function FightController:getCurGridSelfItemModel(playVO,isBagRemain)
	local rGrid= self:getSelfPlayerModel().vo.mGrid
	for k,v in pairs(self.itemViewArr) do
		if v.vo.mGrid.x == rGrid.x and v.vo.mGrid.y == rGrid.y then
			if self:canGetDropItem(playVO,v.vo) then
				return v.vo
			else
				GlobalMessage:show("没有拾取权限")
				return nil
			end
		end
	end
	return nil
end

--拾取物品相关 END


--删除场景上的显示对象
function FightController:deleteItemModel(roleId)
	if self.itemViewArr[roleId] then
		local view = self.itemViewArr[roleId]
		view:destory()
		self.itemViewArr[roleId] = nil
	end
end
--删除场景上的显示对象
function FightController:deleteCollectionItemModel(id)
	if self.collectionItemViewArr[id] then
		local view = self.collectionItemViewArr[id]
		view:destory()
		self.collectionItemViewArr[id] = nil
	end
end

--添加场景火墙
function FightController:addFireWallModel(vo)
	if self.fireWallViewArr[vo.id] then
		self:deleteRoleModel(vo.id,vo.type)
	end
	--dump(vo)
	local item = SceneFireWall.new(vo)
	self.sceneRoleLay:addChild(item)
    --item:setLocalZOrder(2000-vo.pos.y-200)
    self.fireWallViewArr[vo.id] = item
end
--删除场景火墙
function FightController:deleteFireWallModel(sId)
	local view = self.fireWallViewArr[sId]
	if view then
		view:destory()
		self.fireWallViewArr[sId] = nil
	end
end

function FightController:deleteRoleModel(roleId,roleType)
	-- self:print("deleteRoleModel roleId = "..roleId)

	local viewArr
	if roleType == SceneRoleType.PLAYER then
		viewArr = self.playerViewArr

		GlobalEventSystem:dispatchEvent(SceneEvent.MAP_DEL_ROLE,{id = roleId,type = roleType})
	elseif roleType == SceneRoleType.PET then
		viewArr = self.petViewArr
	elseif roleType == SceneRoleType.PLAYERCOPY then
		viewArr = self.playerCopyViewArr
	elseif roleType == SceneRoleType.MONSTER then
		viewArr = self.monsterViewArr
		GlobalEventSystem:dispatchEvent(SceneEvent.MAP_DEL_ROLE,{id = roleId,type = roleType})
	elseif roleType == SceneRoleType.SOLDIER then
		viewArr = self.soldierViewArr
	elseif roleType == SceneRoleType.ITEM then
		self:deleteItemModel(roleId,roleType)
		return
	elseif roleType == SceneRoleType.COLLECTIONITEM then
		self:deleteCollectionItemModel(roleId,roleType)
		return
	elseif roleType == SceneRoleType.NPC then
		self:delNpcModel(roleId,roleType)
		return
	elseif roleType == SceneRoleType.FIREWALL then
		self:deleteFireWallModel(roleId,roleType)
		return
	end

	if viewArr[roleId] then
		local view = viewArr[roleId]
		view:destory()
		viewArr[roleId] = nil
	end


	-- for k,v in pairs(self.monsterViewArr) do
	-- 	return
	-- end

	


	-- local groupOneNum = 0
	-- local groupTwoNum = 0
	-- for k,v in pairs(self.playerViewArr) do
	-- 	if v.vo.group == FightGroupType.ONE then
	-- 		groupOneNum = groupOneNum +1
	-- 	else
	-- 		groupTwoNum = groupTwoNum +1
	-- 	end
	-- end


	-- if groupTwoNum == 0 then
	-- 	--v:playWin(true)
	-- 	GlobalMessage:show("恭喜你，你胜利了")
	-- 	self.fightStates = FightStates.FIGHT_OVER
	--  	self:stopSchedule()
	--  	-- if self.isDebug == false then 
	--  	--     GameNet:sendMsgToSocket(15002,{type=self.chapterType,id =self.chapterId,battleResult=1})
	--  	-- end
	-- elseif groupOneNum == 0 then
	-- 	GlobalMessage:show("很遗憾，你失败了")
	--  	self.fightStates = FightStates.FIGHT_OVER
	--  	self:stopSchedule()
	-- end

end


--清理
function FightController:clear()
	self.isFighting = false
	FightSkillManager:destory()

	for k,v in pairs(self.playerCopyViewArr) do	 			
	 	v:destory()	 
	 	self.playerCopyViewArr[k] = nil			
	end
	self.playerCopyViewArr = {}
	for k,v in pairs(self.petViewArr) do	 			
	 	v:destory()	 
	 	self.petViewArr[k] = nil			
	end
	self.petViewArr ={}
	for k,v in pairs(self.playerViewArr) do	 			
	 	v:destory()	 
	 	self.playerViewArr[k] = nil			
	end
	self.playerViewArr ={}
	for k,v in pairs(self.monsterViewArr) do	 			
	 	v:destory()	 
	 	self.monsterViewArr[k] = nil
	end
	self.monsterViewArr ={}

	for k,v in pairs(self.soldierViewArr) do	 			
	 	v:destory()	 
	 	self.soldierViewArr[k] = nil			
	end
	self.soldierViewArr ={}

	for k,v in pairs(self.npcViewArr) do	 			
	 	v:destory()	 
	 	self.npcViewArr[k] = nil			
	end
	self.npcViewArr ={}
	for k,v in pairs(self.itemViewArr) do	
	 	v:destory()	 
	 	self.itemViewArr[k] = nil			
	end
	self.itemViewArr ={}

	for k,v in pairs(self.collectionItemViewArr) do	
	 	v:destory()	 
	 	self.collectionItemViewArr[k] = nil			
	end
	self.collectionItemViewArr ={}
	

	for k,v in pairs(self.fireWallViewArr) do	 			
	 	v:destory()	 
	 	self.fireWallViewArr[k] = nil
	end
	self.fireWallViewArr ={}


	self:stopHangUpSchedule()
	self:stopSchedule()
	self.times = 1 
	--GlobalEventSystem:removeEventListener(FightEvent.ROLE_MOVE_END)
end	



--销毁
function FightController:destory()	
	--self.scene = nil
	self:clear()
	FightModel.isInit = false

	if not ArmatureManager:getInstance().clear then
		return
	end
	ArmatureManager:getInstance():clear()
	-- local manager = ccs.ArmatureDataManager:getInstance()
 --    for _,v in pairs(self.resList) do
	-- 	manager:removeArmatureFileInfo(v)
	-- end

	-- for k,v in pairs(self.resDic) do
	-- 	manager:removeArmatureFileInfo(k)
	-- end
	-- self.resDic = {}
	-- for k,v in pairs(self.soundDic) do
	-- 	audio.unloadSound(v)
	-- end
end	

function FightController:print(str,key)
	
end


function FightController:FightOver()
	self.fightStates = FightStates.FIGHT_OVER
end	



--协议相关----------------------
function FightController:registerProto()
	-- 跨服幻境之城 - 场景背景图片加载信息 (服务器会在11001前主动推送)
	self:registerProtocal(11101,handler(self,self.onHandle11101))
	-- 跨服幻境之城 - 幻境之城玩家通关信息
	self:registerProtocal(11102,handler(self,self.onHandle11102))

	self:registerProtocal(11001,handler(self,self.onHandle11001))
	self:registerProtocal(11002,handler(self,self.onHandle11002))
--	self:registerProtocal(11003,handler(self,self.onHandle11003))
	self:registerProtocal(11004,handler(self,self.onHandle11004))
	self:registerProtocal(11005,handler(self,self.onHandle11005))
	self:registerProtocal(11006,handler(self,self.onHandle11006))
	self:registerProtocal(11007,handler(self,self.onHandle11007))
	self:registerProtocal(11008,handler(self,self.onHandle11008))
	self:registerProtocal(11009,handler(self,self.onHandle11009))
	self:registerProtocal(11011,handler(self,self.onHandle11011))
	self:registerProtocal(11012,handler(self,self.onHandle11012))

	self:registerProtocal(11018,handler(self,self.onHandle11018))
	self:registerProtocal(11020,handler(self,self.onHandle11020))
	self:registerProtocal(11021,handler(self,self.onHandle11021))
	self:registerProtocal(11022,handler(self,self.onHandle11022))
	self:registerProtocal(11023,handler(self,self.onHandle11023))
	self:registerProtocal(11027,handler(self,self.onHandle11027))

	self:registerProtocal(11040,handler(self,self.onHandle11040))
	self:registerProtocal(11041,handler(self,self.onHandle11041))

	self:registerProtocal(11043,handler(self,self.onHandle11043))

	self:registerProtocal(11047,handler(self,self.onHandle11047))
	self:registerProtocal(11052,handler(self,self.onHandle11052))
    self:registerProtocal(11053,handler(self,self.onHandle11053))
    self:registerProtocal(11054,handler(self,self.onHandle11054))
    self:registerProtocal(11055,handler(self,self.onHandle11055))

    self:registerProtocal(11061,handler(self,self.onHandle11061))

	self:registerProtocal(12002,handler(self,self.onHandle12002))
	self:registerProtocal(12010,handler(self,self.onHandle12010))

	self:registerProtocal(13001,handler(self,self.onHandle13001))
	self:registerProtocal(13002,handler(self,self.onHandle13002))
	self:registerProtocal(13003,handler(self,self.onHandle13003))
	self:registerProtocal(13004,handler(self,self.onHandle13004))
	self:registerProtocal(13005,handler(self,self.onHandle13005))
	self:registerProtocal(13007,handler(self,self.onHandle13007))
	self:registerProtocal(13008,handler(self,self.onHandle13008))
	self:registerProtocal(13009,handler(self,self.onHandle13009))
	self:registerProtocal(13010,handler(self,self.onHandle13010))
	self:registerProtocal(13006,handler(self,self.onHandle13006))
	self:registerProtocal(13011,handler(self,self.onHandle13011))
	self:registerProtocal(13012,handler(self,self.onHandle13012))
	self:registerProtocal(13013,handler(self,self.onHandle13013))
	self:registerProtocal(13014,handler(self,self.onHandle13014))
	self:registerProtocal(13015,handler(self,self.onHandle13015))
	self:registerProtocal(13016,handler(self,self.onHandle13016))
	self:registerProtocal(13017,handler(self,self.onHandle13017))
	self:registerProtocal(13018,handler(self,self.onHandle13018))
	self:registerProtocal(13019,handler(self,self.onHandle13019))
	--self:registerProtocal(13020,handler(self,self.onHandle13020))
	
	self:registerProtocal(13021,handler(self,self.onHandle13021))
	self:registerProtocal(13022,handler(self,self.onHandle13022))
	self:registerProtocal(13024,handler(self,self.onHandle13024))
	self:registerProtocal(13023,handler(self,self.onHandle13023))
	self:registerProtocal(13025,handler(self,self.onHandle13025))
    --动态表情
	self:registerProtocal(18009,handler(self,self.onHandle18009))

	self:registerProtocal(22003,handler(self,self.onHandle22003))

end	

-- 跨服幻境之城 - 场景背景图片加载信息 (服务器会在11001前主动推送)
function FightController:onHandle11101(data)
	--print("===> respond 11101 req_scene_pic")
	--dump(data)
	if data == nil then return end
	self.scene_pic = data.scene_pic -- 场景背景图片信息 0是默认用场景本身的图片，不为0调用对应图片信息

	-- 跨服幻境之城 如果有怪尸体没消失就切换地图时,阴影没删除
	for k,v in pairs(self.monsterViewArr) do	
		self:delSceneRole(v.vo.id,v.vo.type) 		
		if v.destory ~= nil then	
	 		v:destory()	 
	 	end
	 	self.monsterViewArr[k] = nil
	end

end

-- 跨服幻境之城 - 幻境之城玩家通关信息
function FightController:onHandle11102(data)
	if data == nil then return end
	-- 保存通关信息
	self.sceneModel:setKfhjRoomPass(data.room_pass) -- 当前房间状态  0 该场景还未通关，1，该场景已经通关

	-- 传送门显示隐藏(这里不会执行,传送阵还未创建)
	if self.sceneModel.transferPointArr ~= nil then
		if #self.sceneModel.transferPointArr > 0 then
			if self.sceneModel.kfhjRoom_pass == 0 then
				-- print(" ================ 隐藏传送门 =================== ")
				-- 隐藏传送门
				for _,v in pairs(self.sceneModel.transferPointArr) do
					local itemView = self.npcViewArr[v.id]	
					if itemView ~= nil then
						itemView:setRoleVisible(false)
					end
				end
			elseif self.sceneModel.kfhjRoom_pass == 1 then
				--print(" ================ 显示传送门 =================== ")
				-- 显示传送门
				for _,v in pairs(self.sceneModel.transferPointArr) do
					local itemView = self.npcViewArr[v.id]	
					if itemView ~= nil then
						itemView:setRoleVisible(false)
					end
				end
			end
		end
	end

    -- 获取玩家幻境之城的点亮信息
    GlobalController.dreamland:req_get_hjzc_plyaer_info()

end

--切换场景 ，进入场景
--获取当前场景信息
--GameNet:sendMsgToSocket(11001, {scene_id = 10003})
function FightController:onHandle11001(data)
	print("===> respond 11001 req_enter_scene")
	--dump(data)
	self:stopHangUpSchedule()
	if data.result == 0 then
		--进入场景
		self.sceneModel.sceneId = data.scene_id
		local mapConf = getConfigObject(self.sceneModel.sceneId,ActivitySceneConf)
    	-- 跨服幻境之城(使用服务器下发的地图资源)
    	if mapConf ~= nil and self.scene_pic ~= nil then
    		if self.scene_pic ~= "0" and self.scene_pic ~= "" then
    			mapConf.mapId = tonumber(self.scene_pic)
    			mapConf.minimap = tonumber(self.scene_pic)
    		end
    	end

		-- 跨服幻境之城, 小房间不显示回城按钮
		local is_show_home_btn = true

		--
    	if mapConf ~= nil  then
			if mapConf.type == 3  then
				local instance_type = configHelper:getCopyInfo(data.scene_id).instanceType

				-- 跨服幻境之城, 小房间不显示回城按钮
    			if instance_type == 16 then 
    				is_show_home_btn = false	
	    		end

				if instance_type == 1
					or instance_type == 5
					or instance_type == 7
					or instance_type == 8
					or instance_type == 9
					or instance_type == 15 -- 跨服幻境之城(大厅)
					or instance_type == 16 -- 跨服幻境之城(房间)
					or instance_type == 17 -- 幻境之城(大厅)
					or instance_type == 18 -- 幻境之城(房间)
				then
					self.copyInfo = {flag = 1,tag = configHelper:getCopyInfo(data.scene_id).instanceType}
					GlobalEventSystem:dispatchEvent(CopyEvent.COPY_ENTERCOPY,self.copyInfo)
				end		
				if instance_type == 16 or instance_type == 18 then
				else
					self.sceneModel.kfhjRoom_pass = 1
				end
			else
				self.copyInfo = {flag = 0}
				GlobalEventSystem:dispatchEvent(CopyEvent.COPY_ENTERCOPY,self.copyInfo)		 
			end
		end

		-- 跨服幻境之城, 小房间不显示回城按钮
		if self:getScene() ~= nil then -- getScene == FightWin
    		if self:getScene().homeBtnLay ~= nil then
    			self:getScene().homeBtnLay:setVisible(is_show_home_btn)	
    		end
    	end
	
		self:initScene(self.sceneModel.sceneId)
		local item
		local playerList = {} 
		for i=1,#data.player_list do  --玩家，玩家拷贝
			local role = data.player_list[i]
			local vo = SceneRoleVO.new()
			vo.mGrid = role.begin_point
			vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
			vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
			vo.id = role.obj_flag.id  --唯一id
			vo.type = role.obj_flag.type--场景角色类型
			vo.direction = role.direction  --模型方向
			vo.name = role.name
			vo.sex = role.sex 
			vo.career = role.career
			vo.lv = role.lv

			vo.hp = role.cur_hp --当前气血
			vo.hp_limit = role.hp
			vo.totalhp = role.hp --总气血
			vo.mp = role.cur_mp
			vo.mp_limit = role.mp
			vo.weapon = role.guise.weapon
			vo.clothes = role.guise.clothes
			vo.wing = role.guise.wing
			vo.pet = role.guise.pet
			vo.mounts = role.guise.mounts
			vo.rideHalo = role.guise.mounts_aura

			vo.guildId = role.guild_id
			vo.guildName = role.guild_name
			vo.teamId = role.team_id
			vo.corpsId = role.legion_id
			vo.corpsName = role.legion_name
			vo.nameColor = role.name_colour
			vo.honorId = role.career_title

			vo.collect_state = role.collect_state

			vo.server_name = role.server_name
			if vo.id == GlobalModel.player_id then
				FightModel.corpsId = vo.corpsId
			end
			--buff
			for i=1,#role.buff_list do
				local buff = role.buff_list[i]
				buff.obj_flag = role.obj_flag
				buff.operate = 1
				table.insert(vo.beginBuffList,buff)
			end
			vo.petNum = role.pet_num
			--buff end

			vo:updateBaseInfo()
			table.insert(playerList,vo)
			if vo.id == GlobalModel.player_id and vo.type == SceneRoleType.PLAYER then
		    	self.sceneModel.inSafeArea = self.sceneModel:getIsSafeArea(vo.mGrid)
				GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_MAP_POS,cc.p(vo.pos.x,vo.pos.y))
			end
		end
		--data.monster_list = {1,2,3}

		for i=1,#data.monster_list do --怪物 ，宠物，
			local role = data.monster_list[i]
			local vo

			if role.obj_flag.type == SceneRoleType.COLLECTIONITEM then

				vo = SceneCollectionItemVO.new()
				vo.mGrid = role.begin_point
				vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
				vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
				vo.id = role.obj_flag.id   --唯一id
				vo.type = role.obj_flag.type--场景角色类型
				vo.direction = role.direction  --模型方向
				vo.monster_id = role.monster_id
				vo:updateBaseInfo()
				table.insert(playerList,vo)
			else
				vo = SceneRoleVO.new()
				vo.mGrid = role.begin_point
				vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
				vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
				vo.id = role.obj_flag.id   --唯一id
				vo.type = role.obj_flag.type--场景角色类型
				vo.direction = role.direction  --模型方向
				vo.monster_id = role.monster_id
				vo.hp = role.cur_hp --当前气血
				vo.hp_limit = role.hp
				vo.totalhp = role.hp --总气血
				vo.mp = role.cur_mp
				vo.mp_limit = role.mp
				
				vo.guildId = role.guild_id
				vo.teamId = role.team_id
				vo.corpsId = role.legion_id
				vo.nameColor = role.name_colour

				vo.ownerId = role.owner_flag.id
				--vo.isBoss = role.is_boss
				vo.name = role.name
				vo.enmity = role.enmity
				vo.dropOwner = role.drop_owner

				vo.server_name = role.server_name

				if vo.enmity and vo.enmity.monster_id ~= 0 then
					local mConf = getConfigObject(vo.enmity.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
					vo.enmity.modelID = mConf.resId
				end
				--buff
				for i=1,#role.buff_list do
					local buff = role.buff_list[i]
					buff.obj_flag = role.obj_flag
					buff.operate = 1
					table.insert(vo.beginBuffList,buff)
				end
				--buff end
				vo:updateBaseInfo()
				table.insert(playerList,vo)
			end
		end
		for i=1,#data.drop_list do
			item = data.drop_list[i]
			local vo = SceneItemVO.new()
			vo.mGrid = item.point
			vo.pos = FightUtil:gridToPoint(item.point.x,item.point.y)
			vo.id = item.obj_flag.id  --唯一id
			vo.type = item.obj_flag.type--场景角色类型
			vo.num = item.num --物品数量
			vo.playID = item.player_id
			vo.itemID = item.goods_id
			vo.belongTime = item.time_out
			vo.teamId = item.team_id
			vo:updateBaseInfo()
			table.insert(playerList,vo)
		end

		local vo
		--火墙
		for i=1,#data.fire_wall_list do
			item = data.fire_wall_list[i]
			vo = SceneFireWallVO.new()
			vo.mGrid = item.point
			vo.pos = FightUtil:gridToPoint(vo.mGrid.x,vo.mGrid.y)
			vo.id = item.obj_flag.id
			--vo.type = item.obj_flag.type
			vo.duration = 20
			vo:updateBaseInfo()
			table.insert(playerList,vo)
		end
		GlobalController.fight:playBattle(playerList,self.sceneModel.sceneId)

	else
		local selfModel = self:getSelfPlayerModel()
		selfModel:setStates(RoleActivitStates.STAND)
		selfModel:setRoleVisible(true)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

--开始移动
function FightController:onHandle11002(data)
	--print("onHandle11002 -"..data.obj_flag.id,data.end_point.x,data.end_point.y)
	if self.isFighting == false then return end
	if self.sceneModel:getMapGridIsOpen(data.end_point) == false then return end
	--if true then --data.result == 0 then
	local roleFlag = data.obj_flag
	local vo = self.sceneModel:getSceneObjVO(roleFlag.id,roleFlag.type)
	if vo then
		local startPos = FightUtil:gridToPoint(data.begin_point.x,data.begin_point.y)
		vo.movePos = FightUtil:gridToPoint(data.end_point.x,data.end_point.y)
		local model = self:getRoleModel(roleFlag.id,roleFlag.type)
		if model and model.vo.states ~= RoleActivitStates.DEAD then
			if FightUtil:getDistance(vo.pos.x,vo.pos.y,startPos.x,startPos.y) > 150 then
				model:setRolePosition(startPos.x,startPos.y)
			end
			model:roleMoveTo({data.end_point})
		else
			vo.pos = startPos
		end
	end
end

-- --移动同步
-- function FightController:onHandle11003(data)
-- 	--print("onHandle11003 -"..data.obj_flag.id,data.end_point.x,data.end_point.y)
-- 	if self.isFighting == false then return end
-- 	if self.sceneModel:getMapGridIsOpen(data.end_point) == false then return end
-- 	--if true or data.result == 0 then
-- 	local roleFlag = data.obj_flag
-- 	local vo = self.sceneModel:getSceneObjVO(roleFlag.id,roleFlag.type)
-- 	if vo then
-- 		local startPos = FightUtil:gridToPoint(data.point.x,data.point.y)
-- 		vo.movePos = FightUtil:gridToPoint(data.end_point.x,data.end_point.y)
-- 		local model = self:getRoleModel(roleFlag.id,roleFlag.type)
-- 		if model then
-- 			if FightUtil:getDistance(vo.pos.x,vo.pos.y,startPos.x,startPos.y) > 150 then
-- 				model:setRolePosition(startPos.x,startPos.y)
-- 				model:setStates(RoleActivitStates.STAND)
-- 			end
-- 			if data.point.x ~= data.end_point.x and data.point.y ~= data.end_point.y then
-- 			--print("FightController:onHandle11003(data)")
-- 		    	model:roleMoveTo({{vo.movePos.x,vo.movePos.y}})
-- 		    end
-- 		else
-- 			vo.pos = startPos
-- 		end
-- 	end
-- end

--对象离屏
function FightController:onHandle11004(data)
	--print("onHandle11004 -"..#data.obj_list)
	--dump(data.obj_list)
	--if true then --data.result == 0 then
	local playerList = {} 
	for i=1,#data.obj_list do
		local roleFlag = data.obj_list[i]
		self:delSceneRole(roleFlag.id,roleFlag.type)
	end
	--else
	--end
end

--对象进屏
function FightController:onHandle11005(data)
	if self.sceneModel.baseMapConfig then--data.result == 0 then
		--local playerList = {} 
		for i=1,#data.player_list do --玩家，玩家拷贝，玩家
			local role = data.player_list[i]
			local vo = SceneRoleVO.new()
			vo.mGrid = role.begin_point
			vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
			vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
			vo.id = role.obj_flag.id  --唯一id
			vo.type = role.obj_flag.type--场景角色类型
			vo.direction = role.direction  --模型方向
			vo.name = role.name
			vo.sex = role.sex 
			vo.career = role.career
			vo.lv = role.lv

			vo.hp = role.cur_hp --当前气血
			vo.hp_limit = role.hp
			vo.totalhp = role.hp --总气血
			vo.mp = role.cur_mp
			vo.mp_limit = role.mp
			vo.weapon = role.guise.weapon
			vo.clothes = role.guise.clothes
			vo.wing = role.guise.wing
			vo.pet = role.guise.pet
			vo.mounts = role.guise.mounts
			vo.rideHalo = role.guise.mounts_aura

			vo.guildId = role.guild_id
			vo.guildName = role.guild_name
			vo.teamId = role.team_id
			vo.corpsId = role.legion_id
			vo.corpsName = role.legion_name
			vo.nameColor = role.name_colour
			vo.honorId = role.career_title
			vo.collect_state = role.collect_state

			vo.server_name = role.server_name
			--buff
			for i=1,#role.buff_list do
				local buff = role.buff_list[i]
				buff.obj_flag = role.obj_flag
				buff.operate = 1
				table.insert(vo.beginBuffList,buff)
			end
			vo.petNum = role.pet_num
			--buff end
			vo:updateBaseInfo()
			--table.insert(playerList,vo)
			--self:addSceneRole(vo)
			if vo.id == GlobalModel.player_id then
				FightModel.corpsId = vo.corpsId
				self:deleteRoleModel(vo.id,vo.type)
				self.sceneModel:AddSceneObjVO(vo.id,vo)	
				self:addRoleModel(vo)
			else
				self:deleteRoleModel(vo.id,vo.type)
				self.sceneModel:AddSceneObjVO(vo.id,vo)
			end
		end
		--召唤怪也在这里
		for i=1,#data.monster_list do 
			local role = data.monster_list[i]
			local vo
			if role.obj_flag.type == SceneRoleType.COLLECTIONITEM then
				vo = SceneCollectionItemVO.new()
				vo.mGrid = role.begin_point
				vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
				vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
				vo.id = role.obj_flag.id   --唯一id
				vo.type = role.obj_flag.type--场景角色类型
				vo.direction = role.direction  --模型方向
				vo.monster_id = role.monster_id
				vo:updateBaseInfo()
				self:addSceneRole(vo)
			else
				vo = SceneRoleVO.new()
				vo.mGrid = role.begin_point
				vo.pos = FightUtil:gridToPoint(role.begin_point.x,role.begin_point.y)
				vo.movePos = FightUtil:gridToPoint(role.end_point.x,role.end_point.y)
				vo.id = role.obj_flag.id  --唯一id
				vo.type = role.obj_flag.type--场景角色类型
				vo.direction = role.direction  --模型方向
				vo.monster_id = role.monster_id
				vo.hp = role.cur_hp --当前气血
				vo.hp_limit = role.hp
				vo.totalhp = role.hp --总气血
				vo.mp = role.cur_mp
				vo.mp_limit = role.mp

				vo.guildId = role.guild_id
				vo.teamId = role.team_id
				vo.corpsId = role.legion_id
				vo.nameColor = role.name_colour

				vo.ownerId = role.owner_flag.id
				--vo.isBoss = role.is_boss
				vo.name = role.name
				vo.enmity = role.enmity
				vo.dropOwner = role.drop_owner
				vo.server_name = role.server_name

				if vo.enmity and vo.enmity.monster_id ~= 0 then
					local mConf = getConfigObject(vo.enmity.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
					vo.enmity.modelID = mConf.resId
				end
				--buff
				for i=1,#role.buff_list do
					local buff = role.buff_list[i]
					buff.obj_flag = role.obj_flag
					buff.operate = 1
					table.insert(vo.beginBuffList,buff)
				end
				--buff end

				vo:updateBaseInfo()
				self:deleteRoleModel(vo.id,vo.type)
				self.sceneModel:AddSceneObjVO(vo.id,vo)
				--self:addSceneRole(vo)	
			end
		end

		for i=1,#data.drop_list do
			local item = data.drop_list[i]
			local vo = SceneItemVO.new()
			vo.pos = FightUtil:gridToPoint(item.point.x,item.point.y)
			vo.mGrid = item.point
			vo.id = item.obj_flag.id  --唯一id
			vo.type = item.obj_flag.type--场景角色类型
			vo.num = item.num --物品数量
			vo.playID = item.player_id
			vo.itemID = item.goods_id
			vo.belongTime = item.time_out
			vo.teamId = item.team_id
			vo:updateBaseInfo()
			self:addSceneRole(vo)
			--self.sceneModel:AddSceneObjVO(vo.id,vo)	
		end

		local vo
		--火墙
		for i=1,#data.fire_wall_list do
			local item = data.fire_wall_list[i]
			vo = SceneFireWallVO.new()
			vo.mGrid = item.point
			vo.pos = FightUtil:gridToPoint(vo.mGrid.x,vo.mGrid.y)
			vo.id = item.obj_flag.id
			--vo.type = item.obj_flag.type
			vo.duration = 20
			vo:updateBaseInfo()
			--self:addSceneRole(vo)
			self.sceneModel:AddSceneObjVO(vo.id,vo)
		end

	else
	end
end

--"拾取掉落"
function FightController:onHandle11006(data)
	if data.result == 0 then
		--SoundManager:playSoundByType(SoundType.PICKUP)
	else
		--GlobalMessage:show("背包已满，拾取失败")
	end
end

--活动中直接 伤害 如火墙和毒
function FightController:onHandle11008(data)
	local tarModel
    local tarVo
    for i=1,#data.harm_list do
    	local vo = data.harm_list[i]
        tarModel = self:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
        if tarVo and _checkIsHpMpGameObject(tarVo.type) then
        	tarVo.hp = vo.cur_hp
        	tarVo.mp = vo.cur_mp
        	tarModel = self:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        	if tarModel then
	            if vo.harm_status == 1 then--伤害状态: 1 miss, 2 普通, 3 暴击"/>
	                tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value,false,false,vo.harm_status) --cur_mp
	            elseif vo.harm_status == 3 then
	                tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value,true,false,vo.harm_status)
	            elseif vo.harm_status == 2 then
	                tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.harm_value,false,false,vo.harm_status)
	            end
        	end
        end
    end
end

--"buff变更"
function FightController:onHandle11007(data)
	local tarModel
    local tarVo
	if #data.buff_list ~= 0 then
		for i=1,#data.buff_list do
			local buffvo = data.buff_list[i]
            tarModel = self:getRoleModel(buffvo.obj_flag.id,buffvo.obj_flag.type)
            tarVo = self.sceneModel:getSceneObjVO(buffvo.obj_flag.id,buffvo.obj_flag.type)
            if tarVo then
            	if tarModel then
            		GlobalController.model:push(tarModel, "updateBuff", buffvo)
            		--tarModel:updateBuff(buffvo)
            	else
            		local item
            		if buffvo.operate == 1 or buffvo.operate == 2 then
	            		for i=1,#tarVo.beginBuffList do
	            			item = tarVo.beginBuffList[i]
	            			if item.buff_id == buffvo.buff_id then
	            				tarVo.beginBuffList[i] = buffvo
	            				break
	            			end
	            		end
	            	elseif buffvo.operate == 3 then
	            		for i=1,#tarVo.beginBuffList do
	            			item = tarVo.beginBuffList[i]
	            			if item.buff_id == buffvo.buff_id then
	            				table.remove(tarVo.beginBuffList,i)
	            				break
	            			end
	            		end
	            	end
            	end
            end
		end
	end
end

--获取世界boss刷新时间
function FightController:onHandle11009(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.GET_BOSS_REFRESH_TIME,data.refresh_list)
end
--对象更新 场景属性更新
function FightController:onHandle11011(data)
	if data.player_list then
		for i=1,#data.player_list do
			local item = data.player_list[i]
			local vo = self.sceneModel:getSceneObjVO(item.obj_flag.id,item.obj_flag.type)
			if vo then
				local tarModel = self:getRoleModel(item.obj_flag.id,item.obj_flag.type)
				vo.guildId = item.guild_id
				
				if vo.teamId ~= item.team_id then
					vo.teamId = item.team_id 
					for k,v in pairs(self.playerViewArr) do
						tarModel = self:getRoleModel(v.vo.id,v.vo.type)
						if tarModel then
							tarModel:updateTeamIcon()
						end
					end
					for k,v in pairs(self.petViewArr) do
						tarModel = self:getRoleModel(v.vo.id,v.vo.type)
						if tarModel then
							tarModel:updateTeamIcon()
						end
					end
				end
				if vo.nameColor ~= item.name_colour then
					vo.nameColor = item.name_colour
					if tarModel then
						tarModel:updateNameColor()
					end
				end
                
                if vo.guildName ~= item.guild_name or vo.corpsName ~= item.legion_name then
					vo.guildName = item.guild_name
					vo.corpsName = item.legion_name
					if tarModel then
						tarModel:updateGuildName()
					end
				end
				if vo.corpsId ~= item.legion_id then
					vo.corpsId = item.legion_id
					if vo.id == GlobalModel.player_id then
						FightModel.corpsId = vo.corpsId
						self:updateScene32107NameColor()
					else
						if tarModel then
							tarModel:updateScene32107NameColor()
						end
					end
				end

				if vo.honorId ~= item.career_title then
					vo.honorId = item.career_title
					if tarModel then
						tarModel:showHonorPic(vo.honorId)
					end
				end
				if vo.petNum ~= item.pet_num then
					vo.petNum = item.pet_num
				end
				if vo.collect_state ~= item.collect_state then
					vo.collect_state = item.collect_state
					if tarModel then
						tarModel:showCollectBar(vo.collect_state)
					end
				end
			end
		end
	end
end

--显示复活动画，用在复活芥子上
function FightController:onHandle11012(data)
	if data then
		local tarMode = self:getRoleModel(data.obj_flag.id,data.obj_flag.type)
		if tarMode then
			GlobalMessage:show("复活戒指生效，原地复活")
			tarMode:playRelive()
		end
	end
end

--获取沙城活动信息">
function FightController:onHandle11018(data)
	if data then
	    FightModel.shaBakeGuildName = data.guild_name
	    if data.guild_id ~= FightModel.shaBakeGuildId and data.guild_id ~= "0" then
	    	if self.isfirstgetshabake == nil then
	    		self.isfirstgetshabake = true
	    	else
	    		GlobalMessage:show("帮会 "..FightModel.shaBakeGuildName.." 占领了沙城")
	    	end
	    end
	    FightModel.shaBakeGuildId = data.guild_id

	    if data.activity == 1 then
		    FightModel.shaBaKeActivityOpen = true
		    GlobalMessage:show("沙城争霸活动开启")
		else
			if FightModel.shaBaKeActivityOpen == true then
				GlobalMessage:show("沙城争霸活动结束")
			end
			FightModel.shaBaKeActivityOpen = false
		end
		self:updateShabakeRoleStates()
	end
end



--所有的气血变化
function FightController:onHandle11020(data)
	if self.isFighting == false then return end
	--print("onHandle11020")
	if data.obj_list then
		local isShowMp = false
		for k,v in pairs(data.obj_list) do
			local vo = self.sceneModel:getSceneObjVO(v.obj_flag.id,v.obj_flag.type)
			if vo  and _checkIsHpMpGameObject(vo.type) then
				--print("onHandle11020",v.hp,v.cur_hp,v.obj_flag.id,v.obj_flag.type)
				vo.hp = v.cur_hp --当前气血
				vo.hp_limit = v.hp
				vo.totalhp = v.hp --总气血
				if v.cur_mp and vo.mp > v.cur_mp then
					isShowMp = true
				end
				vo.mp = v.cur_mp
				vo.mp_limit = v.mp 
				--local tarModel = self:getRoleModel(v.obj_flag.id,v.obj_flag.type)
				if true then
					-- <Param name="cause" type="int8" describe="变更原因: 0 其他原因, 1 技能造成, 2 自身恢复, 3 换装, 4 升级, 5 吃药"/>
					local showTip = false
					if GlobalModel.player_id == v.obj_atk.id or GlobalModel.player_id == v.obj_flag.id or v.harm_status == 4 then
						showTip = true
					end
					if v.obj_flag.type == 1 and v.mp_change ~= 0 and v.hp_change == 0 and v.harm_status == 5 then
						if showTip and isShowMp then
							local tarModel = self:getRoleModel(v.obj_flag.id,v.obj_flag.type)
							if tarModel then
								tarModel:showMpTips(math.abs(v.mp_change))
							end
						end
					else
						local tarModel = self:getRoleModel(v.obj_flag.id,v.obj_flag.type)
						--print("11020",tarModel,v.harm_status,v.hp_change,v.mp_change)
						if tarModel then
							if v.cause == 1 then
								if v.harm_status == 1 then--伤害状态: 1 miss, 2 普通, 3 暴击,4反弹"/>
				                	tarModel:setHP(v.cur_hp,v.cur_mp,v.hp_change,false,showTip,v.harm_status) --cur_mp
					            elseif v.harm_status == 3 then
					                tarModel:setHP(v.cur_hp,v.cur_mp,v.hp_change,true,showTip,v.harm_status)
					            elseif v.harm_status == 4 then
					                tarModel:setHP(v.cur_hp,v.cur_mp,v.hp_change,true,showTip,v.harm_status)
					            elseif v.harm_status == 2 then
					                tarModel:setHP(v.cur_hp,v.cur_mp,v.hp_change,false,showTip,v.harm_status)
					            else
					            	tarModel:setHP(v.cur_hp,v.cur_mp,v.hp_change,false,showTip,v.harm_status)
					            end
							else
								tarModel:updateHp(v.cur_hp,v.hp)
							end
						end
					end
				end

			end
		end
	end
end

--获取场景哪存活某个怪物坐标
function FightController:onHandle11021(data)
	SceneManager:playerMoveTo(self.sceneModel.sceneId,data.point)
end
--传送阵
function FightController:onHandle11022(data)
	if data.result == 0 then
		--self:getSelfPlayerModel():setVisible(false)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
		if self:getSelfPlayerModel() then
			self:getSelfPlayerModel():setRoleVisible(true)
		end
	end
end
--更新boss仇恨列表
function FightController:onHandle11023(data)
	-- <Param name="obj_flag" type="proto_obj_flag" describe="对象唯一标识"/>
	-- 			<Param name="enmity" type="proto_enmity" describe="仇恨目标"/>
	local vo = self.sceneModel:getSceneObjVO(data.obj_flag.id,data.obj_flag.type)
	if vo then
		if data.enmity.monster_id ~= 0 then
			local mConf = getConfigObject(data.enmity.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
			data.enmity.modelID = mConf.resId
		end
		vo.enmity = data.enmity
		vo.dropOwner = data.drop_owner
		local tarModel = self:getRoleModel(data.obj_flag.id,data.obj_flag.type)
		if tarModel then
			tarModel:setDropOwner()
		end
	end
end

--更新玩家宠物信息
function FightController:onHandle11027(data)
	if data.pet_list then
		for i=1,#data.pet_list do
			local item = data.pet_list[i]
			local vo = self.sceneModel:getSceneObjVO(item.obj_flag.id,item.obj_flag.type)
			if vo then
				vo.guildId = item.guild_id
				if vo.teamId ~= item.team_id then
					vo.teamId = item.team_id 
					local tarModel = self:getRoleModel(item.obj_flag.id,item.obj_flag.type)
					if tarModel then
						tarModel:updateTeamIcon()
					end
				end
				vo.corpsId = item.legion_id
				if vo.nameColor ~= item.name_colour then
					vo.nameColor = item.name_colour
					local tarModel = self:getRoleModel(item.obj_flag.id,item.obj_flag.type)
					if tarModel then
						tarModel:updateNameColor()
					end
				end
			end
		end
	end
end

function FightController:onHandle11040(data)
	if data.player_id_list then
		for i=1,#data.player_id_list do
			self.fightModel.enemyIdList[data.player_id_list[i]] = true
		end
	end
end

function FightController:onHandle11041(data)
	if data.del_player_id then
		self.fightModel.enemyIdList[data.del_player_id] = nil
	end
	if data.add_player_id then
		self.fightModel.enemyIdList[data.add_player_id] = true
	end
end

function FightController:onHandle11043(data)
	if data.result == 0  then
		GlobalMessage:show("采集成功")
	elseif data.result == 7 then
		GlobalMessage:show("背包已满，请清理再试")
	else
		GlobalMessage:show("采集失败")
	end
end

--
function FightController:onHandle11052(data)
	if data.warning_id then
		GlobalEventSystem:dispatchEvent(SceneEvent.BOSS_SKILL_TIPS, {isOpen = true,id = data.warning_id})
	end
end

--获取跨服倒计时时间
function FightController:onHandle11047(data)
	if data.left_time  then
		GlobalEventSystem:dispatchEvent(SceneEvent.INTER_SERVICE_TIME_UPDATE,{num = data.left_time})
	end
end

--获取场景资源列表
-- <Param name="weapon_list" type="list" sub_type="int32" describe="武器外观list"/>
-- <Param name="clothes_list" type="list" sub_type="int32" describe="衣服外观list"/>
-- <Param name="wing_list" type="list" sub_type="int32" describe="翅膀外观list"/>
function FightController:onHandle11053(data)
	if data.weapon_list then
		self.resCancheWeaponIdDic = data.weapon_list
		self.resCancheClothesIdDic = data.clothes_list
		self.resCancheWingIdDic = data.wing_list
		self.resMansterIdDic = data.monster_list
	end
	if self.scene then
		self.scene:open()
	end
end

--火龙神殿杀怪数量
function FightController:onHandle11054(data)
	if data.kill_num then
		GlobalEventSystem:dispatchEvent(SceneEvent.HUOLONG_COPY_TIPS,data.kill_num)
	end
end

--获取地图是否开放
function FightController:onHandle11055(data)
	if data.map_info_list then
		GlobalEventSystem:dispatchEvent(SceneEvent.GET_MAP_ISOPEN,data.map_info_list)
	end
end

--获取变异地宫Boss击杀数量
function FightController:onHandle11061(data)
	print("FightController:onHandle11061")
	dump(data)
	SceneManager.aberrancePalaceData = data
	GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_ABERRANCE_DATA,data)
end



--更新沙巴克活动中角色占领状态
function FightController:updateShabakeRoleStates()
	for k,v in pairs(self.playerViewArr) do
		v:updateGuildName()
		v:updateNameColor()
	end
end


function FightController:updateScene32107NameColor()
	for k,v in pairs(self.playerViewArr) do
		v:updateScene32107NameColor()
	end
end

--更新结盟信息
function FightController:updateUnionStates()
	for k,v in pairs(self.playerViewArr) do
		v:updateUnionIcon()
	end
end

-- 战斗中使用技能
function FightController:onHandle12002(data)
	local roleFlag = data.caster_flag
	-- if data.result == 1406 then
	-- 	print("-------skill Back11 onHandle12002",data.result,roleFlag.id,roleFlag.type)
	-- end
	--dump(data)
	if data.result == 0 then
		if self.isFighting == false then return end
		local roleFlag = data.caster_flag
		local model = self:getRoleModel(roleFlag.id,roleFlag.type)
		local vo = self.sceneModel:getSceneObjVO(roleFlag.id,roleFlag.type)
		
		-- if roleFlag.type == 1 then
		-- 	--print("-------skill Back22 onHandle12002")
		-- end
		if model and vo then
			local curPos = FightUtil:gridToPoint(data.caster_point.x,data.caster_point.y)
			if FightUtil:getDistance(vo.pos.x,vo.pos.y,curPos.x,curPos.y) > 180 then
				model:setRolePosition(curPos.x,curPos.y)
			end
			-- if vo.direction ~= data.direction then
			-- 	vo.direction = data.direction
			-- 	model:setModelActionIndex(vo.direction)
			-- end
			--如果两个技能太快并且网络延迟大的时候，后一个技能会覆盖前一个技能
			--if data.caster_flag.type == SceneRoleType.PLAYER then return end

			if data.target_type == 1 then
				--攻击对象目标
				--model.cureList = data.cure_list
				--model.buffList = data.buff_list
				--model.move_list = data.move_list
				--model.knockback_list = data.knockback_list
				--model.targetList = data.target_list
				model.hurtEffPoint = FightUtil:gridToPoint(data.target_point.x,data.target_point.y)
				model:playAttack(data.target_flag.id,data.target_flag.type,data.skill_id,data.skill_lv)
				--GlobalController.model:push(model, "playAttack", data.target_flag.id,data.target_flag.type,data.skill_id,data.skill_lv)
			elseif data.target_type == 2 then
				-- 地面坐标
				--model.move_list = data.move_list
				--model.knockback_list = data.knockback_list
				model.hurtEffPoint = FightUtil:gridToPoint(data.target_point.x,data.target_point.y)
				model:playAttack(0,1,data.skill_id,data.skill_lv)
				--GlobalController.model:push(model, "playAttack", 0,1,data.skill_id,data.skill_lv)
			end
		end
	else
		if data.result ~= 1404 and data.result ~= 1406 then
			GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
		end
	end
end

--触发非伤害型技能动作
function FightController:onHandle12010(data)
	if self.isFighting == false then return end
	local tarVo
	local tarModel
	local vo
	if data.knockback_list and #data.knockback_list > 0 then
		for i=1,#data.knockback_list do
            vo = data.knockback_list[i]
            tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
            if tarVo then
            	tarModel = self:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
            	local p = FightUtil:gridToPoint(vo.end_point.x,vo.end_point.y)
            	if tarModel then
            		GlobalController.model:push(tarModel, "playBeCollision", p)
            		--tarModel:playBeCollision({p.x,p.y})
            	else
            		tarVo.movePos = p
            	end
            end
        end
	end
	if data.move_list  and #data.move_list >0 then
        for i=1,#data.move_list do
            vo = data.move_list[i]
            tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
           	if tarVo then
        		tarModel = self:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
        		local p = FightUtil:gridToPoint(vo.end_point.x,vo.end_point.y)
        		if tarModel then
        			GlobalController.model:push(tarModel, "playCollision", p)
        			--tarModel:playCollision({p.x,p.y})
        		else
        			tarVo.movePos = p
        		end
        	end
        end
    end
	if data.buff_list and #data.buff_list > 0 then
        for i=1,#data.buff_list do
			local buffvo = data.buff_list[i]
            tarVo = self.sceneModel:getSceneObjVO(buffvo.obj_flag.id,buffvo.obj_flag.type)
            if tarVo then
            	tarModel = self:getRoleModel(buffvo.obj_flag.id,buffvo.obj_flag.type)
            	if tarModel then
            		GlobalController.model:push(tarModel, "updateBuff", buffvo)
            		--tarModel:updateBuff(buffvo)
            	else
            		local item
            		if buffvo.operate == 1 or buffvo.operate == 2 then
	            		for i=1,#tarVo.beginBuffList do
	            			item = tarVo.beginBuffList[i]
	            			if item.buff_id == buffvo.buff_id then
	            				tarVo.beginBuffList[i] = buffvo
	            				break
	            			end
	            		end
	            	elseif buffvo.operate == 3 then
	            		for i=1,#tarVo.beginBuffList do
	            			item = tarVo.beginBuffList[i]
	            			if item.buff_id == buffvo.buff_id then
	            				table.remove(tarVo.beginBuffList,i)
	            				break
	            			end
	            		end
	            	end
            	end
            end
		end
        
    end


    -- if data.target_list and #data.target_list > 0 then
    --         for i=1,#data.target_list do
    --             local v = data.target_list[i]
    --             table.insert(hurtRoleList,{id= v.id,type = v.type})
    --         end

    --     end

	-- <Packet proto="12010" type="s2c" name="rep_trigger_skill" describe="触发非伤害型技能效果">
	-- 			<Param name="target_list" type="list" sub_type="proto_obj_flag" describe="目标列表"/>
	-- 			<Param name="buff_list" type="list" sub_type="proto_buff_operate" describe="buff列表"/>
	-- 			<Param name="move_list" type="list" sub_type="proto_point_change" describe="移动列表"/>
	-- 			<Param name="knockback_list" type="list" sub_type="proto_point_change" describe="击退列表"/>
	-- 		</Packet>
end





function FightController:creatSelfVO(useOldPos)
	local playerInfo = RoleManager:getInstance().roleInfo
	
	local vo = SceneRoleVO.new()
	vo.mGrid = cc.p(math.floor(self.sceneModel.baseMapConfig.gridColume/2),math.floor(self.sceneModel.baseMapConfig.gridRow/2))
	vo.pos = FightUtil:gridToPoint(math.floor(self.sceneModel.baseMapConfig.gridColume/2),math.floor(self.sceneModel.baseMapConfig.gridRow/2))
	vo.direction = RoleDirect.DOWN  --模型方向
	if useOldPos then
		local curRoleVO = self.sceneModel:getSceneObjVO(playerInfo.player_id,SceneRoleType.PLAYER)
		if curRoleVO then
			vo.pos = curRoleVO.pos
			vo.direction = curRoleVO.direction
		end
	end
	vo.movePos = vo.pos

	vo.id = playerInfo.player_id  --唯一id
	vo.type = SceneRoleType.PLAYER--场景角色类型
	
	vo.name = playerInfo.name
	vo.sex = playerInfo.sex 
	vo.career = playerInfo.career
	vo.lv = playerInfo.lv

	vo.hp = playerInfo.hp --当前气血
	vo.hp_limit = playerInfo.hp
	vo.totalhp = playerInfo.hp --总气血
	vo.mp = playerInfo.mp
	vo.mp_limit = playerInfo.mp

	vo.weapon = playerInfo.weapon
	vo.clothes = playerInfo.clothes
	vo.wing = playerInfo.wing
	vo.pet = playerInfo.pet

	local guildInfo = RoleManager:getInstance().guildInfo

	vo.guildId = guildInfo.guild_id
	--vo.guildName = guildInfo.guild_name
	--vo.teamId = role.team_id
	vo.nameColor = playerInfo.nameColor
	vo.honorId = playerInfo.honorId

	vo:updateBaseInfo()
	return vo
end

-- 挂机进入挂机地图
-- GameNet:sendMsgToSocket(13001, {scene_id = 1})
function FightController:onHandle13001(data)
	-- if data.result == 0 then
	-- 	self.sceneModel.sceneId = data.scene_id
	-- 	self:initScene(self.sceneModel.sceneId)
	-- 	FightModel.bossCountDown = false
	-- 	local vo = self:creatSelfVO(false)
	-- 	GlobalController.fight:playBattle({vo},self.sceneModel.sceneId)
	-- 	GameNet:sendMsgToSocket(13002)
	-- else
	-- end
end

-- 挂机获取场景刷怪信息
-- GameNet:sendMsgToSocket(13002)
function FightController:onHandle13002(data)
	-- if FightModel.sceneType ~= SceneType.HANGUP then
	-- 	return
	-- end
	-- if true then--data.result == 0 then
	-- 	--data.monster_list
	-- 	--data.monster_type  --刷怪类型: 1 小怪, 2 boss
	-- 	if data.monster_type == 2 then
	-- 		FightModel.bossCountDown = true--getConfigObject(self.sceneModel.sceneId,HookSceneConf)
	-- 	else
	-- 		FightModel.bossCountDown = false
	-- 	end
	-- 	local roleVo = self:creatSelfVO(true)
	-- 	self:addSceneRole(roleVo)
	-- 	-- --for j=1,30 do
	-- 	-- for i=1,30 do
	-- 	-- 	local item = {}
	-- 	-- 	local vo = SceneFireWallVO.new()
	-- 	-- 	local mainRoleVo = self.sceneModel:getSceneObjVO(RoleManager:getInstance().roleInfo.player_id,SceneRoleType.PLAYER)
	-- 	-- 	--vo.mGrid = item.grid or cc.p(mainRoleVo.mGrid.x,mainRoleVo.mGrid.y)
	-- 	-- 	vo.mGrid = item.grid or cc.p(math.random(mainRoleVo.mGrid.x - 10,mainRoleVo.mGrid.x+10),math.random(mainRoleVo.mGrid.y - 8,mainRoleVo.mGrid.y+8))
	-- 	-- 	vo.pos = FightUtil:gridToPoint(vo.mGrid.x,vo.mGrid.y)
	-- 	-- 	vo.id = i*100
	-- 	-- 	--vo.type = item.obj_flag.type
	-- 	-- 	vo.duration = i+10

	-- 	-- 	vo:updateBaseInfo()
	-- 	-- 	self:addSceneRole(vo)
	-- 	-- end
	-- 	for i=1,#data.monster_list do
	-- 		local role = data.monster_list[i]
	-- 		local vo = SceneRoleVO.new()
	-- 		--挂机生成角色坐标,让其居中地图
	-- 		vo.pos = cc.p(math.random(self.fightModel.sceneConfig.width/2-270,self.fightModel.sceneConfig.width/2+270),math.random(self.fightModel.sceneConfig.height/2-210,self.fightModel.sceneConfig.height/2+210))--self:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
	-- 		vo.movePos = vo.pos
	-- 		vo.mGrid = FightUtil:pointToGrid(vo.pos.x,vo.pos.y)
			
	-- 		vo.ownerId = role.owner_flag.id

	-- 		vo.guildId = role.guild_id
	-- 		vo.teamId = role.team_id
	-- 		vo.corpsId = role.legion_id
	-- 		vo.nameColor = role.name_colour

	-- 		vo.id = role.obj_flag.id  --唯一id
	-- 		vo.type = role.obj_flag.type--场景角色类型 --SceneRoleType.PET
			
	-- 		-- if i<30 then
	-- 		-- --测试宠物
	-- 		-- 	vo.ownerId = GlobalModel.player_id
	-- 		-- 	vo.type = SceneRoleType.PET
	-- 		-- end

	-- 		vo.direction = RoleDirect.DOWN  --模型方向
	-- 		vo.monster_id = role.monster_id
	-- 		vo.hp = role.cur_hp --当前气血
	-- 		vo.hp_limit = role.hp
	-- 		vo.totalhp = role.hp --总气血
	-- 		vo.mp = role.cur_mp
	-- 		vo.mp_limit = role.mp
	-- 		vo:updateBaseInfo()
	-- 		self:addSceneRole(vo)
	-- 	end
	-- 	--end
	-- else

	-- end
end

-- 挂机释放技能
-- 
function FightController:onHandle13003(data)
	-- if FightModel.sceneType ~= SceneType.HANGUP then
	-- 	return
	-- end
	-- if true then --data.result == 0 then
	-- 	local tarModel
 --        local tarVo
 --        for i=1,#data.harm_list do
 --        	local vo = data.harm_list[i]
            
 --            tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
 --            tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
 --            if tarModel and tarVo then
	--             if vo.harm_status == 1 then--伤害状态: 1 miss, 2 普通, 3 暴击/>
	--                 tarModel:setHP(vo.cur_hp,vo.cur_mp,0-vo.harm_value,false,true) --cur_mp
	--             elseif vo.harm_status == 3 then
	--                 tarModel:setHP(vo.cur_hp,vo.cur_mp,0-vo.harm_value,true,true)
	--             elseif vo.harm_status == 2 then
	--                 tarModel:setHP(vo.cur_hp,vo.cur_mp,0-vo.harm_value,false,true)
	--             end
 --        	end
 --            --tarModel:playHurtEffect(skillId)
 --        end
 --        for i=1,#data.cure_list do
 --        	local vo = data.cure_list[i]
 --            tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
 --            tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
 --            if tarModel and tarVo then
	--             tarModel:setHP(vo.cur_hp,vo.cur_mp,vo.add_hp,false,true)
 --        	end
 --        end
 --        for i=1,#data.buff_list do
 --        	local vo = data.buff_list[i]
 --            tarModel = GlobalController.fight:getRoleModel(vo.obj_flag.id,vo.obj_flag.type)
 --            tarVo = self.sceneModel:getSceneObjVO(vo.obj_flag.id,vo.obj_flag.type)
 --            if tarModel and tarVo then
	--             --tarModel:updateBuff(vo)
	--             GlobalController.model:push(tarModel, "updateBuff", vo)
 --        	end
 --        end
	-- else

	-- end
end

-- 回合结果
function FightController:onHandle13004(data)
	-- if FightModel.sceneType ~= SceneType.HANGUP then
	-- 	return
	-- end
	-- if data.status == 0 then
	-- 	-- if FightModel.bossCountDown then
	-- 	-- 	local view  = require("app.modules.fight.view.hangUp.HangUpResult").new({isWin = false})
	--  --        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)  
	--  --    end
	-- 	-- 输了
	-- 	self:pauseHangUpMonster()
	-- elseif data.status == 1 then
	-- 	-- if FightModel.bossCountDown then
	-- 	-- 	local view  = require("app.modules.fight.view.hangUp.HangUpResult").new({isWin = true})
	--  --        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)  
	--  --    end
	-- 	-- 赢了
	-- elseif data.status == 2 then
	-- 	-- 等待
	-- 	self:pauseHangUpMonster()
	-- end
	-- self.hangUpNextTime = data.next_time
	-- if self.hangUpNextTime > 0 then
	-- 	local listenerFun =  function()
	-- 		self.hangUpNextTime = self.hangUpNextTime -1
	-- 		GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_TIME,self.hangUpNextTime)
		
	-- 		if self.hangUpNextTime < 0 then
	-- 			self:stopHangUpSchedule()
	-- 			self:getHangUpMonster()
	-- 		end
	-- 	end
	-- 	if self.hangUpTimeId == nil then
	-- 		self.hangUpTimeId =  GlobalTimer.scheduleGlobal(listenerFun,1)
	-- 	end
	-- else
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_TIME,-1)
	-- 	self:stopHangUpSchedule()
	-- 	self:getHangUpMonster()
	-- end
end
function FightController:stopHangUpSchedule()
	if self.hangUpTimeId then
		GlobalTimer.unscheduleGlobal(self.hangUpTimeId)
		self.hangUpTimeId = nil
	end
end
--暂停场景上的怪
function FightController:pauseHangUpMonster()
	-- -- 暂停场景上的怪
	-- for k,v in pairs(self.playerViewArr) do
	-- 	v:setStates(RoleActivitStates.PAUSE)
	-- end
	-- for k,v in pairs(self.monsterViewArr) do
	-- 	v:setStates(RoleActivitStates.PAUSE)
	-- end
	-- --暂停火墙
	-- for k,v in pairs(self.fireWallViewArr) do
	-- 	v:setStates(RoleActivitStates.PAUSE)
	-- end
	-- --暂停宠物
	-- for k,v in pairs(self.petViewArr) do
	-- 	v:setStates(RoleActivitStates.PAUSE)
	-- end
end

function FightController:getHangUpMonster()
	-- -- 清理场景上的怪
	-- for k,v in pairs(self.monsterViewArr) do
	-- 	self:delSceneRole(v.vo.id,v.vo.type)
	-- end
	-- --清理火墙
	-- for k,v in pairs(self.fireWallViewArr) do
	-- 	self:delSceneRole(v.vo.id,v.vo.type)
	-- end
	-- --清理宠物
	-- for k,v in pairs(self.petViewArr) do
	-- 	self:delSceneRole(v.vo.id,v.vo.type)
	-- end

	-- if self.nextHangUpSceneId ~= nil and self.nextHangUpSceneId ~= self.sceneModel.sceneId then
	-- 	--如果有切换场景需求则切换场景
	-- 	GameNet:sendMsgToSocket(13001, {scene_id = self.nextHangUpSceneId})
	-- 	self.nextHangUpSceneId = nil 
	-- else
	-- 	--直接获取下一轮怪
	-- 	GameNet:sendMsgToSocket(13002)
	-- end

	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_SHOW_TIP,{key = "clear"})
end

--"产生掉落"
function FightController:onHandle13005(data)
	-- if FightModel.sceneType ~= SceneType.HANGUP then
	-- 	return
	-- end
	-- local monsterID = data.obj_flag.id
	-- local monster = self:getRoleModel(monsterID,SceneRoleType.MONSTER)
	-- if monster then
	-- 	for i=1,#data.drop_list do
	-- 		self.hungUpitemId = self.hungUpitemId +1
	-- 		local item = data.drop_list[i]
	-- 		local vo = SceneItemVO.new()
	-- 		local grid = {}--FightUtil:pointToGrid(monster.vo.pos.x, monster.vo.pos.y)
	-- 		grid.x = math.random(monster.vo.mGrid.x-3,monster.vo.mGrid.x+3)
	-- 		grid.y = math.random(monster.vo.mGrid.y-3,monster.vo.mGrid.y+3)
	-- 		vo.mGrid = grid
	-- 		vo.pos = FightUtil:gridToPoint(grid.x,grid.y)
	-- 		vo.id = self.hungUpitemId  --唯一id
	-- 		--vo.type = SceneRoleType.ITEM
	-- 		vo.num = item.num --物品数量
	-- 		vo.monsterID = monsterID
	-- 		vo.itemID = item.goods_id

	-- 		vo.playID = item.player_id
	-- 		vo.belongTime = item.time_out

	-- 		vo.teamId = item.team_id
	-- 		vo:updateBaseInfo()
	-- 		self:addSceneRole(vo)
	-- 	end
	-- end
end

-- 挑战Boss
function FightController:onHandle13007(data)
	-- if data.result == 0 then
		
	-- 	if self.sceneModel.sceneId ~= data.scene_id then
	-- 		self.nextHangUpSceneId = data.scene_id
	-- 		RoleManager:getInstance().roleInfo.hookSceneId = data.scene_id
	-- 	end
 --    	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_SHOW_TIP,{key = "killBoss",sceneId = data.scene_id})
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.CHANG_HANGUP_SCENE)
	-- end
end

-- 切换挂机场景(等待回合结束)
function FightController:onHandle13008(data)
	-- if data.result == 0 then
	-- 	if self.sceneModel.sceneId ~= data.scene_id then
	-- 		self.nextHangUpSceneId = data.scene_id
	-- 		RoleManager:getInstance().roleInfo.hookSceneId = data.scene_id
	-- 	end
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_SHOW_TIP,{key = "switchScene",sceneId = data.scene_id})
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.CHANG_HANGUP_SCENE)
	-- end
end

--获取离线报告
function FightController:onHandle13009(data)
	-- if data.hook_report then
	-- 	self:showHangUpReport(data.hook_report)
	-- 	-- local report = data.hook_report
	-- 	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_REPORT)
	-- end
end

--快速挂机
function FightController:onHandle13010(data)
	--if data.hook_report then
	--	self:showHangUpReport(data.hook_report)
		-- local report = data.hook_report
		-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_REPORT)
	--end
end
function FightController:showHangUpReport(data)
	-- local hangUpReport = require("app.modules.fight.view.hangUp.FightFastResultView").new({})
	-- hangUpReport:setData(data)
	-- GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,hangUpReport)
end

--获取boss可用挑战次数
function FightController:onHandle13006(data)
	-- RoleManager:getInstance().roleInfo.challengeBossJade = data.need_jade --购买次数需要元宝
	-- RoleManager:getInstance().roleInfo.challengeBossNum = data.challenge_num --可挑战次数
	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_CHALLENGE_NUM)
end

--购买boss挑战次数
function FightController:onHandle13011(data)
	-- if data.result == 0 then
	-- 	RoleManager:getInstance().roleInfo.challengeBossJade = data.need_jade --购买次数需要元宝
	-- 	RoleManager:getInstance().roleInfo.challengeBossNum = data.challenge_num --可挑战次数
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_CHALLENGE_NUM)
	-- end
end

--获取挂机统计
function FightController:onHandle13012(data)
	-- local param = {drop = data.drop_rate,exp = data.hour_exp_gain,killNum = data.hour_kill_num,coin = data.hour_coin_gain}
	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_STATISTICS,param)
end
 
--获取当前体力
function FightController:onHandle13013(data)
	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_ENERGY,data)
end

--购买体力
function FightController:onHandle13014(data)
	-- if data.result == 0 then
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_UPDATE_TIMES)
	-- else
	-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE, ErrorCodeInfoFormat(data.result))
	-- end
end

--"获取挂机星级列表
function FightController:onHandle13015(data)
	-- if data.hook_star_reward_list then
	-- 	FightModel.chapterReward = data.hook_star_reward_list
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_UPDATE_CHAPTER_REWARD)
	-- end
	-- if data.hook_star_list then
	-- 	GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_UPDATE_STAR,data.hook_star_list)
	-- end
end
--更新挂机星级
function FightController:onHandle13016(data)
	-- GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_UPDATE_STAR,{data.hook_star})
end

--"回合结果 弹出结果信息: 0 战斗失败, 1 战斗胜利
function FightController:onHandle13017(data)
	-- if data.status == 0 then
	-- 	local view  = require("app.modules.fight.view.hangUp.HangUpResult").new({isWin = false,sceneId = data.scene_id})
	--     GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
	-- elseif data.status == 1 then
	-- 	local view  = require("app.modules.fight.view.hangUp.HangUpResult").new({isWin = true,sceneId = data.scene_id})
	--     GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
	-- end
end

--添加挂机场景对象 例如宠物
function FightController:onHandle13018(data)
	-- for i=1,#data.hook_obj_list do
	-- 		local role = data.hook_obj_list[i]
	-- 		local vo = SceneRoleVO.new()
	-- 		--挂机生成角色坐标,让其居中地图
	-- 		vo.pos = cc.p(math.random(self.fightModel.sceneConfig.width/2-270,self.fightModel.sceneConfig.width/2+270),math.random(self.fightModel.sceneConfig.height/2-210,self.fightModel.sceneConfig.height/2+210))--self:getRoleModel(GlobalModel.player_id,SceneRoleType.PLAYER)
	-- 		vo.movePos = vo.pos
	-- 		vo.mGrid = FightUtil:pointToGrid(vo.pos.x,vo.pos.y)
			
	-- 		vo.ownerId = role.owner_flag.id

	-- 		vo.guildId = role.guild_id
	-- 		vo.teamId = role.team_id
	-- 		vo.nameColor = role.name_colour

	-- 		vo.id = role.obj_flag.id  --唯一id
	-- 		vo.type = role.obj_flag.type--场景角色类型
			
	-- 		vo.direction = RoleDirect.DOWN  --模型方向
	-- 		vo.monster_id = role.monster_id
	-- 		vo.hp = role.cur_hp --当前气血
	-- 		vo.hp_limit = role.hp
	-- 		vo.totalhp = role.hp --总气血
	-- 		vo.mp = role.cur_mp
	-- 		vo.mp_limit = role.mp
	-- 		vo:updateBaseInfo()
	-- 		self:addSceneRole(vo)
	-- end
end

--添加挂机火墙
function FightController:onHandle13019(data)
	-- for i=1,#data.hook_fire_wall_list do
	-- 	local item = data.hook_fire_wall_list[i]
	-- 	local vo = SceneFireWallVO.new()
	-- 	local mainRoleVo = self.sceneModel:getSceneObjVO(RoleManager:getInstance().roleInfo.player_id,SceneRoleType.PLAYER)
	-- 	vo.mGrid = item.point or cc.p(mainRoleVo.mGrid.x,mainRoleVo.mGrid.y)
	-- 	vo.pos = FightUtil:gridToPoint(vo.mGrid.x,vo.mGrid.y)
	-- 	vo.id = item.obj_flag.id
	-- 	vo.type = item.obj_flag.type
	-- 	vo.duration = item.duration
	-- 	vo.interval = item.interval

	-- 	vo:updateBaseInfo()
	-- 	self:addSceneRole(vo)
	-- end
end


--火墙攻击  无返回
function FightController:onHandle13021(data)
	--data.fire_wall_attack_list
end

function FightController:onHandle13022(data)
	-- if data.result == 0 then
	-- 	GlobalMessage:show("领取章节奖励成功！")
	-- end
end

function FightController:onHandle13023(data)
	-- if data.hook_star_reward then
	-- 	for k,v in pairs(FightModel.chapterReward) do
	--         if v.chapter == data.hook_star_reward.chapter then
	--             v.star = data.hook_star_reward.star
	--             v.step_list = data.hook_star_reward.step_list
	--             break
	--         end
	--     end
	--     GlobalEventSystem:dispatchEvent(FightEvent.HANGUP_UPDATE_CHAPTER_REWARD)
	-- end
end
function FightController:onHandle13024(data)
	-- if data.result == 0 then
	-- 	GlobalMessage:show("领取首通奖励成功")
	-- end
end

function FightController:onHandle13025(data)
	--if data.result == 0 then
		--GlobalMessage:show("领取首通奖励成功")
	--end
end
function FightController:onHandle22003(data)
	--if data.result == 0 then
		--GlobalMessage:show("领取首通奖励成功")
	--end
end

--动态表情
function FightController:onHandle18009(data)
	local roleFlag = data.obj_flag
	local model = self:getRoleModel(roleFlag.id,roleFlag.type)
	if model then
		model:showFace(data.content)
	end
end







