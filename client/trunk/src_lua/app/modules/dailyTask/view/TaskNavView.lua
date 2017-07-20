--
-- Author: Yi hanneng
-- Date: 2016-01-05 15:53:57
--
require("app.modules.dailyTask.model.TaskManager")
local TaskNavView = TaskNavView or class("TaskNavView", function()
    return display.newNode()
end)

function TaskNavView:ctor(width,height)

	self.width = width
	self.height = height
	self.itemList = {}
	self.btnState = true -- true:为打开状态 false:隐藏状态
	self.noTask = false
	self.preLoadList = {}
	self.isLoading = false
	self.isFighting = false
	self.temData = nil
	self.currentTaskType = nil
	self.ListView = SCUIList.new {
        viewRect = cc.rect(0,0,230, height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self):pos(0, 0)
 	
	self:open()
 
end

function TaskNavView:open()

	GlobalEventSystem:addEventListener(TaskEvent.NAV_UPDATE,handler(self,self.delay))
	GlobalEventSystem:addEventListener(TaskEvent.NAV_UPDATE_OVER,handler(self,self.handlerNoTask))
	--GlobalEventSystem:addEventListener(TaskEvent.NAV_HIDE,handler(self,self.hide))
	--GlobalEventSystem:addEventListener(TaskEvent.NAV_SHOW,handler(self,self.show))
	local data = TaskManager:getInstance():getTaskList()

	if nil ~= data then
		self:setData(data)
	end
end

function TaskNavView:close()
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_UPDATE)
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_UPDATE_OVER)
	--GlobalEventSystem:removeEventListener(TaskEvent.NAV_HIDE)
	--GlobalEventSystem:removeEventListener(TaskEvent.NAV_SHOW)
end

function TaskNavView:setData(data)
 
 	local i = 1
 	for k,v in pairs(data) do
 		--功能开放
 		local isNext = false
 		if v.type == 1 and FunctionOpenManager:getFunctionOpenById(FunctionOpenType.MainTask) == false then
			isNext = true
		elseif v.type == 3 and FunctionOpenManager:getFunctionOpenById(FunctionOpenType.Meritorious_task) == false then
			isNext = true
		end
		--功能开放
		--if isNext == false then
	 		local item = self.ListView:newItem()
			local content = require("app.modules.dailyTask.view.TaskItem").new(cc.size(self.width - 4,58))
			content:setData(v)
			item:addContent(content)
	        item:setItemSize(self.width - 4,59)
			--self.itemList[i] = content
			table.insert(self.itemList, content)

			if #self.itemList > 1 then
				table.sort(self.itemList, function(a,b) return a:getData().type < b:getData().type end )
			end
			
			local pos = self:findPos(content)
			self.ListView:addItem(item,pos)
			i = i + 1
	 		local npcVO
		 	if v.state == 2 and (v.type == 1 or v.type == 5 or v.type == 6 or v.type == 7 )  then
				npcVO = GameSceneModel:getSceneObjVO(v.accept_npc_id,SceneRoleType.NPC)
				if npcVO ~= nil then
					npcVO.isTask = 1
				end
			elseif v.state == 1 and (v.type == 1 or v.type == 5 or v.type == 6 or v.type == 7 )  then
				npcVO = GameSceneModel:getSceneObjVO(v.finish_npc_id,SceneRoleType.NPC)
				if npcVO ~= nil then
					npcVO.isTask = 1
				end
			elseif v.type == 3 or v.type == 8 then
				npcVO = GameSceneModel:getSceneObjVO(v.accept_npc_id,SceneRoleType.NPC)
				if npcVO ~= nil then
					npcVO.isTask = 1
				end
			end
		--end
 	end
 	
	self.ListView:reload()

	self.noTask = false

	self:updateOver()

end

function TaskNavView:updateViewItem(data)
 
	data = data.data
	if self.noTask == true then
		self.ListView:removeAllItems()
		self.itemList = {}
	end
	local item = self:getItemById(data.id)
	
	if nil ~= item then
		info = item:getData()
		--移除或更新
		if data.state == 3 then--提交了，删除任务
			self.currentTaskType = info.type
			self:removeItemById(info.id)
			self.ListView:removeItem(item:getParent(),true)
			self.ListView:reload()
		else
			item:setData(data)
			local trigger_type = GlobalController.guide:getTriggerType()
			if  trigger_type ~= TriggerType.TASK_FINISH and trigger_type ~= TriggerType.TASK_ACCEPT then --如果有完成任务后或开始任务引导，停止自动任务
				self:autoRun(data,true)
			end
			
		end

	else
		--添加
		local item = self.ListView:newItem()
		local content = require("app.modules.dailyTask.view.TaskItem").new(cc.size(self.width - 4,58))
		content:setData(data)
		item:addContent(content)
        item:setItemSize(self.width - 4,59)
		--self.itemList[#self.itemList+1] = content
		table.insert(self.itemList, content)
		if #self.itemList > 1 then
			table.sort(self.itemList, function(a,b) return a:getData().type < b:getData().type end )
		end
		--table.sort(self.itemList, function(a,b)return a.type < b.type end)
		local pos = self:findPos(content)
		self.ListView:addItem(item,pos)
		--self.ListView:reload()
		self.noTask = false
		local trigger_type = GlobalController.guide:getTriggerType()
		if trigger_type ~= TriggerType.TASK_FINISH and trigger_type ~= TriggerType.TASK_ACCEPT  then --如果有完成任务后或开始任务引导，停止自动任务
		    self:autoRun(data,false)
		end

		self.ListView:reload()

	end
	
	self.isLoading = false
	if self.preLoadList and #self.preLoadList > 0 then
		self:delay(nil)
	end
 
end

function TaskNavView:findPos(item)
	if self.itemList then
	for i=1,#self.itemList do
		if item == self.itemList[i] then
			return i
		end
	end
	end
	return #self.itemList
end

function TaskNavView:delay(data)
 
 	if not self.preLoadList then
		self.preLoadList = {}
	end

	if self.isLoading and data ~= nil then
		table.insert(self.preLoadList,data)
	else
		self.isLoading = true
		if #self.preLoadList > 0 then
			self:updateViewItem(self.preLoadList[1])
			table.remove(self.preLoadList,1)
		else
			if data ~= nil then
				self:updateViewItem(data)
			end
		end
		
	end

end

function TaskNavView:handlerNoTask()
	local action5 = cc.DelayTime:create(2.0)
	local action6 = cc.CallFunc:create(function() self:updateOver() end)       
 	self:runAction(transition.sequence({action5,action6}))
end

function TaskNavView:updateOver()

	if self.itemList and #self.itemList == 0 then
		self.noTask = true
		local item = self.ListView:newItem()
		local content = require("app.modules.dailyTask.view.TaskItem").new(cc.size(self.width - 4,58))
		local info = require("app.modules.dailyTask.model.TaskInfo").new()
		info.name = "<font color='0xfbfb9f' size='22' opacity='255'>暂无任务</font>"
		content:setData(info)
		item:addContent(content)
        item:setItemSize(self.width - 4,59)
		--self.itemList[#self.itemList+1] = content
		table.insert(self.itemList, content)
		self.ListView:addItem(item)
		self.ListView:reload()
	end

end


function TaskNavView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item =self.itemList[event.itemPos]

        if item ~= nil and item.data ~= nil then
        	local data  = item:getData()
        	GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_TASK_NAVIGATE)
        	self.isTouch = true
        	self.currentTaskType = data.type
	        self:autoRun(data,true)

        end
    -- elseif "ended" == event.name then
    -- 	print(self.ListView.container:getContentSize().height)
    -- 	local arr = self.ListView.container:getChildren()

    -- 	for i=1,#arr do
    -- 		--print(self.ListView:isItemInViewRect(arr[i]))
    -- 		print(arr[i]:isVisible(),self.ListView:isItemInViewRect(arr[i]))
    -- 		if self.ListView:isItemInViewRect(arr[i]) == false then
    -- 			arr[i]:setVisible(false)
    -- 		end
    -- 	end
    -- elseif "began" == event.name then
    -- 	local arr = self.ListView.container:getChildren()

    -- 	for i=1,#arr do
    -- 		-- --print(self.ListView:isItemInViewRect(arr[i]))
    -- 		-- print(arr[i]:isVisible(),self.ListView:isItemInViewRect(arr[i]))
    -- 		-- if self.ListView:isItemInViewRect(arr[i]) == false then
    -- 		-- 	arr[i]:setVisible(false)
    -- 		-- end
    -- 		arr[i]:setVisible(true)
    -- 	end
    end
    -- dump(event)
end


function TaskNavView:getItemById(id)
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil then
				if self.itemList[i]:getData() and self.itemList[i]:getData().id == id then
					return self.itemList[i]
				end
			end
		end
	end
	return nil
end

function TaskNavView:removeItemById(id)
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil then
				if self.itemList[i]:getData() and self.itemList[i]:getData().id == id then
					table.remove(self.itemList,i)
					break 
				end
			end
		end
	end
end

function TaskNavView:findMainTaskData()
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil and self.itemList[i]:getData() and self.itemList[i]:getData().type == 1 then
				return self.itemList[i]:getData()
			end
		end
	end

	return nil
end

function TaskNavView:getTaskDataByType(type)
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil and self.itemList[i]:getData() and self.itemList[i]:getData().type == type then
				return self.itemList[i]:getData()
			end
		end
	end

	return nil
end
--任务自动化
--状态2:未接，1:已经完成，但没提交。0:就是做任务过程中
function TaskNavView:autoRun(data,click)

	-- if self.isFighting == true then
	-- 	self.temData = data
	-- 	local action5 = cc.DelayTime:create(2.0)
	-- 	local action6 = cc.CallFunc:create(function() self:autoRun(self.temData) self.isFighting = false print("2秒") end)       
 -- 		self:runAction(transition.sequence({action5,action6}))
	-- 	return
	-- end

	--优先主线
	--[[
	if click == false and data.type ~= 1 and self.itemList then
		local info = self.itemList[1]:getData()
		if info ~= nil then
			data = info
		end
	end
--]]
	--先做同类型任务
 	if click == false and data.type ~= self.currentTaskType then

		local info = self:getTaskDataByType(self.currentTaskType)
		if info ~= nil then
			data = info
		else
			--没有同类型任务就优先主线
			if self.itemList then
				info = self.itemList[1]:getData()
				if info ~= nil then
					data = info
					self.currentTaskType = data.type
				end
			end
		end
	end
	
	if data then
		print("TaskNavView:autoRun ( data.state = ",data.state)
		if data.state == 2 then
			SceneManager:playerMoveToNPC(data.accept_npc_id,true)
		elseif data.state == 1 then
			TaskManager:getInstance():setCurrentTaskMonsterId(0)
			local playerVO = GlobalController.fight:getSelfPlayerModel().vo
    		if playerVO and (playerVO.states == RoleActivitStates.STAND or playerVO.states == RoleActivitStates.MOVE) then
        		SceneManager:playerMoveToNPC(data.finish_npc_id,true)
        	else
   		 
   				local action5 = cc.DelayTime:create(0.5)
				local action6 = cc.CallFunc:create(function() SceneManager:playerMoveToNPC(data.finish_npc_id,true) end)       
 				self:runAction(transition.sequence({action5,action6}))
    		 end
		elseif data.state == 0 then
			print("TaskNavView:autoRun(",data.sort_id)
			local pos = string.split(data.pos, ",")
			if data.sort_id == 9 or data.sort_id == 13  then
				--杀怪或收集材料
				TaskManager:getInstance():setCurrentTaskMonsterId(data.tool)
				self.isFighting = true
				if data.currentNum == 0 or self.isTouch then
					SceneManager:playerMoveToMonster(data.sceneId,cc.p(pos[1],pos[2]),data.tool)
				end
			elseif data.sort_id == 10 then
				--任务途中引导到npc
				SceneManager:playerMoveToNPC(data.active_npc,true)
			elseif data.sort_id == 12 then
				--副本处理
				local info = StringUtil.split(data.openinstance, ",")
				if info[1] == "win" then
				--剧情副本
					local sceneConfig = getConfigObject(data.sceneId,ActivitySceneConf)
			    	if sceneConfig.story_reward == "" or sceneConfig.story_reward == nil then
				        local alertView = GlobalMessage:alert({
						    enterTxt = "确定",
						    backTxt= "取消",
						    tipTxt = data.showTip,
						    enterFun = function() GameNet:sendMsgToSocket(11024,{id = info[2]}) end,
						    tipShowMid = true,
					    })
				    else
				    	GlobalWinManger:openWin(WinName.COPYPRIZETIPS,{sceneId = data.sceneId,id = tonumber(info[2]),sendtype = 2})
				    end


				    if DEBUG == 1  and AUTO == 1 then
                        require("framework.scheduler").performWithDelayGlobal(function() 
                        	alertView:close()
                            GameNet:sendMsgToSocket(11024,{id = info[2]})
                        end, 0.4)
                    end
				else
				--普通副本窗口
					GlobalWinManger:openWin(info[1])
				end
			end
    	end
  	end

  	self.isTouch = false
end
 
return TaskNavView