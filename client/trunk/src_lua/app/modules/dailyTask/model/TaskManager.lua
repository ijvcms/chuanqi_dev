--
-- Author: Yi hanneng
-- Date: 2016-01-05 15:13:29
--
 
TaskManager = TaskManager or class("TaskManager", BaseManager)

function TaskManager:ctor()
	TaskManager.Instance = self
	self.taskList = {}
end

function TaskManager:getInstance()
	if nil == TaskManager.Instance then
		TaskManager.new()
	end
	return TaskManager.Instance
end
--获取任务列表
function TaskManager:handlerTaskList(data)

	local info

	self.taskList = {}

	for i=1,#data.navigate_task_list do
 
		info = require("app.modules.dailyTask.model.TaskInfo").new()
		info.id = data.navigate_task_list[i].task_id
		--dump(info.id,"================>")
		local config = configHelper:getTask(info.id)
		info.type  = config.type_id
		--dump(config,"==============>")
		info.accept_npc_id  = config.accept_npc_id
		info.finish_npc_id = config.finish_npc_id
		info.accept_des = config.accept_dec
		info.accept_info = config.accept_info
		info.finish_des = config.finish_dec
		info.finish_info = config.finish_info
		info.needNum = config.neednum
		info.currentNum = data.navigate_task_list[i].now_num
		info.name = config.name
		info.sort_id = config.sort_id
		info.sceneId = config.sceneId
		info.pos = config.pos
		info.active_npc = config.active_npc
		info.openinstance = config.openinstance
		info.tool = config.tool
		info.effect = config.effect
		info.btn_effect = config.btn_effect
		if RoleManager:getInstance().roleInfo.career == 1000 then
			info.rewardList = config.goods_zhanshi
		elseif RoleManager:getInstance().roleInfo.career == 2000 then
			info.rewardList = config.goods_fashi
		elseif RoleManager:getInstance().roleInfo.career == 3000 then
			info.rewardList = config.goods_daoshi
		end

		info.exRewardList = config.goods_extra
		info.goods_extra_probability = config.goods_extra_probability
			
		info.state = data.navigate_task_list[i].state  --0:任务进行中；1:任务完成；2:任务接取状态
		info.des = config.active_des 
		info.showTip = config.active_txt

		self.taskList[info.id] = info
 		 
	end

end

function TaskManager:updateTaskTip(npcVo,showTaskTip,isTask)
	if npcVo == nil then return end
	if showTaskTip then
		npcVo.showTaskTip = showTaskTip
		local view = GlobalController.fight:getRoleModel(npcVo.id,SceneRoleType.NPC)
		if view then
			view:updateTaskTip(npcVo.showTaskTip)
		end
	end
	if isTask then
		npcVo.isTask = isTask
	end
end


-- 刷新任务列表
function TaskManager:udpateTaskList(data)

	local info
 	local acceptNpc
 	local finishNpc

 	local acceptNpcVO
 	local finishNpcVO
	for i=1,#data.navigate_task_list do

		info = nil
		info = self:getTaskById(data.navigate_task_list[i].task_id)

		if nil ~=  info then
			acceptNpcVO = GameSceneModel:getSceneObjVO(info.accept_npc_id,SceneRoleType.NPC)
			finishNpcVO = GameSceneModel:getSceneObjVO(info.finish_npc_id,SceneRoleType.NPC)
			--状态3为删除；其他状态只需要更新任务状态和数量
			--0:任务进行中；1:任务完成；2:任务接取状态；3:删除
			if data.navigate_task_list[i].state == 3 then
			 	
				info.state = data.navigate_task_list[i].state
				self.taskList[data.navigate_task_list[i].task_id] = nil

				self:updateTaskTip(acceptNpcVO,-1,0)

				self:updateTaskTip(finishNpcVO,-1,0)

				GlobalEventSystem:dispatchEvent(TaskEvent.NAV_UPDATE, info)		
			else
			 
				if  data.navigate_task_list[i].state ~= info.state or data.navigate_task_list[i].now_num  ~= info.currentNum then
	 			
				if data.navigate_task_list[i].state == 0 then
					--飘数量变化动画
					local str
					if info.showTip ~= nil and info.showTip ~= "" then
						str = StringUtil.replaceKeyVal(info.showTip, data.navigate_task_list[i].now_num.."/"..info.needNum)
						GlobalMessage:show(str)	
					end
					self:updateTaskTip(acceptNpcVO,-1)
			 
				elseif data.navigate_task_list[i].state == 1 then
					--飘完成动画
					self:updateTaskTip(acceptNpcVO,-1,0)

					self:updateTaskTip(finishNpcVO,1,1)
					--self:playEffect("completetask")
					
				elseif data.navigate_task_list[i].state == 2 then
					--接取任务
					self:updateTaskTip(acceptNpcVO,2)
				end

				if info.type == 3 then
					if acceptNpcVO ~= nil then
						acceptNpcVO.isTask = 1
					end
				end

				info.state = data.navigate_task_list[i].state
				info.currentNum = data.navigate_task_list[i].now_num
				self.taskList[info.id].state = data.navigate_task_list[i].state
				self.taskList[info.id].currentNum = data.navigate_task_list[i].now_num

				GlobalEventSystem:dispatchEvent(TaskEvent.NAV_UPDATE, info)

				end
			end

		else
 
			info = require("app.modules.dailyTask.model.TaskInfo").new()
			info.id = data.navigate_task_list[i].task_id
			local config = configHelper:getTask(info.id)
			 
			info.type  = config.type_id
			info.accept_npc_id  = config.accept_npc_id
			info.finish_npc_id = config.finish_npc_id
			info.accept_des = config.accept_dec
			info.accept_info = config.accept_info
			info.finish_des = config.finish_dec
			info.finish_info = config.finish_info
			info.needNum = config.neednum
			info.currentNum = data.navigate_task_list[i].now_num
			info.name = config.name
			info.sort_id = config.sort_id
			info.sceneId = config.sceneId
			info.pos = config.pos

			if RoleManager:getInstance().roleInfo.career == 1000 then
				info.rewardList = config.goods_zhanshi
			elseif RoleManager:getInstance().roleInfo.career == 2000 then
				info.rewardList = config.goods_fashi
			elseif RoleManager:getInstance().roleInfo.career == 3000 then
				info.rewardList = config.goods_daoshi
			end

			info.exRewardList = config.goods_extra
			info.goods_extra_probability = config.goods_extra_probability
			
			info.state = data.navigate_task_list[i].state  --0:任务进行中；1:任务完成；2:任务接取状态
			info.des = config.active_des
			info.showTip = config.active_txt
			info.active_npc = config.active_npc
			info.openinstance = config.openinstance
			info.tool = config.tool
			info.effect = config.effect
            info.btn_effect = config.btn_effect
			self.taskList[info.id] = info

			acceptNpcVO = GameSceneModel:getSceneObjVO(info.accept_npc_id,SceneRoleType.NPC)
			finishNpcVO = GameSceneModel:getSceneObjVO(info.finish_npc_id,SceneRoleType.NPC)
			GlobalEventSystem:dispatchEvent(TaskEvent.NAV_UPDATE, info)
			--type 1:主线任务，4:日常任务，3:功勋任务,5 6 行会任务，周常任务			
			if info.type == 3 then

				self:updateTaskTip(acceptNpcVO,1)
				
				if info.state == 2 then
					self:updateTaskTip(acceptNpcVO,2)
				elseif info.state == 1 then
					self:updateTaskTip(acceptNpcVO,-1)

					self:updateTaskTip(finishNpcVO,1)
				elseif info.state == 0 then
					self:updateTaskTip(acceptNpcVO,-1,0)

					self:updateTaskTip(finishNpcVO,0,1)
		 
				end
			 	 
					 
			else 
				if info.state == 2 then
					self:updateTaskTip(acceptNpcVO,2,1)
				elseif info.state == 1 then
					self:updateTaskTip(finishNpcVO,1,1)
				elseif info.state == 0 then
					self:updateTaskTip(acceptNpcVO,-1,0)
					self:updateTaskTip(finishNpcVO,1,1)
				end
			end

		end
 
	end
	
	if #self.taskList == 0 then
		GlobalEventSystem:dispatchEvent(TaskEvent.NAV_UPDATE_OVER)
	end
	
end
 
--获取任务信息
function TaskManager:getTaskById(id)
	if self.taskList and self.taskList[id] then
		return self.taskList[id]
	end
	return nil
end
--获取任务列表
function TaskManager:getTaskList()
	return self.taskList
end

function TaskManager:getTaskByNpcId(npcId)
	for k,v in pairs(self.taskList) do
		if v.accept_npc_id == npcId or v.finish_npc_id == npcId then
			return v
		end
	end
	return nil
end

function TaskManager:getCurrentTaskMonsterId()
	return self.CurrentTaskMonsterId or 0
end

function TaskManager:setCurrentTaskMonsterId(id)
	self.CurrentTaskMonsterId = id
end

function TaskManager:playEffect(action)
 	if GlobalController.fight:getSelfPlayerModel().topLayer then 
		ArmatureManager:getInstance():loadEffect(action)
		local effArmature = ccs.Armature:create(action)
		effArmature:setScaleX(1)
	    effArmature:setScaleY(1) 
	    effArmature:getAnimation():setSpeedScale(1)
	    GlobalController.fight:getSelfPlayerModel().topLayer:addChild(effArmature)
	    effArmature:setPosition(0,135)
	    effArmature:stopAllActions()
	    effArmature:getAnimation():play("effect")

	    local function animationEvent(armatureBack,movementType,movementID)
	    	if movementType == ccs.MovementEventType.loopComplete or  movementType == ccs.MovementEventType.complete then
	    		armatureBack:getAnimation():setMovementEventCallFunc(function()end)
	    		armatureBack:stopAllActions()
	    		armatureBack:getAnimation():stop()
	    		if armatureBack:getParent() then
	    			armatureBack:getParent():removeChild(armatureBack)
	          ArmatureManager:getInstance():unloadEffect(effectID)
	    		end
	    	end
	    end	
	   	effArmature:getAnimation():setMovementEventCallFunc(animationEvent)  
 	end
end
