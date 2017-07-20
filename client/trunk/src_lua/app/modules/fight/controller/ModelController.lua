--场景精灵加载控制器
--用最简单的形式有序加载
--by shine
--2016-08-22

ModelController = ModelController or class("ModelController")


function ModelController:ctor()
	self.modelList = {}
	self.funsList = {}
	self.argsList = {}
	self.modelRefLsit = {} --保证不被清理
	self.effectRefList = {}
	self.handle = require("framework.scheduler").scheduleUpdateGlobal(handler(self, self.update_))
	self.fIndex = 1
	self.max = 0
end

function ModelController:update_()
	local stime = socket.gettime()
	self.fIndex = 1
	while self.fIndex <= self.max do
		
		local model = self.modelList[self.fIndex]
	    local fun = self.funsList[self.fIndex]
	    local args = self.argsList[self.fIndex]
	    local mRef = self.modelRefLsit[self.fIndex]
	    local eRef = self.effectRefList[self.fIndex]
	    if  not model.isDestory_ and model:getReferenceCount() > 1 and model[fun] then
	    	if socket.gettime() - stime > 0.02 and not model.isMainPlayer and fun ~= "creatModel" and fun ~= "createModelBoay" and fun ~= "creatModelWeapon" then
	    	else
	    		model[fun](model, unpack(args))
	    	end
	    end
	    if mRef ~= 0 and mRef ~= "" then
		    ArmatureManager:getInstance():unloadModel(mRef)
	    end
	    if eRef ~= 0 and eRef ~= "" then
		    ArmatureManager:getInstance():unloadEffect(eRef)
	    end
	    model:release()
	    self.fIndex = self.fIndex + 1
	end
	self.max = 0
end



function ModelController:push_(modelId, effectId, cls, funName, ...)
	--cls[funName](cls,  ...)
	cls:retain()
	if modelId ~= 0 and modelId ~= "" then
		ArmatureManager:getInstance():preLoadModel(modelId)
	end
	if effectId ~= 0 and effectId ~= "" then
		ArmatureManager:getInstance():preLoadEffect(effectId)
	end
	self.max = self.max + 1
	self.modelRefLsit[self.max] = modelId
	self.effectRefList[self.max] = effectId
	self.modelList[self.max] = cls
	self.funsList[self.max] = funName
	self.argsList[self.max] = {...}
	
end

function ModelController:push(cls, funName, ...)
	self:push_(0, 0, cls, funName, ...)
end

function ModelController:pushModel(id, cls, funName, ...)
	self:push_(id, 0, cls, funName, ...)
end

function ModelController:pushEffect(id, cls, funName, ...)
	self:push_(0, id, cls, funName, ...)
end



function ModelController:destory()
	require("framework.scheduler").unscheduleGlobal(self.handle)
	local models =  self.modelList
	self.modelList = {}
	self.funsList = {}
	self.argsList = {}
	for i = 1, self.max do
		local id = self.modelRefLsit[i]
		if id ~= 0 and id ~= "" then
		    ArmatureManager:getInstance():unloadModel(id)
	    end
	    id = self.effectRefList[i]
	    if id ~= 0 and id ~= "" then
		    ArmatureManager:getInstance():unloadEffect(id)
	    end
	    models[i]:release()
	end
	self.modelRefLsit = {}
	self.effectRefList = {}
	self.fIndex = 1
	self.max = 0
	self.handle = require("framework.scheduler").scheduleUpdateGlobal(handler(self, self.update_))
end