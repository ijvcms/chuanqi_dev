--
-- Author: 21102585@qq.com
-- Date: 2014-12-15 16:39:55
-- 战斗动画管理器，用来管理动画的创建和消除

ArmatureManager = ArmatureManager or class("ArmatureManager")

ArmatureManager.mapEffectID2Callbacks = {}  --新的接口异步加载保持的effect动画-->(key-->callback)
ArmatureManager.mapModelID2Callbacks = {}  --新的接口异步记载保持的model动画--->(key-->callback)
ArmatureManager.mapNode2ListenerRecord = {} --记录是否已经添加了监听

local function _addEffectRefrence(self,effectID)
	if not effectID then return end
	effectID = tostring(effectID)
	if self.effectUrlDic[effectID] == nil then
		self.effectUrlDic[effectID] = 0
	end
	self.effectUrlDic[effectID] = self.effectUrlDic[effectID] +1
	self.effectTimeDic[effectID] = self.fightModel:getFTime()
end

local function _deleteEffectRefrence(self,effectID)
	effectID = tostring(effectID)
	if self.effectUrlDic[effectID] then
		self.effectUrlDic[effectID] = self.effectUrlDic[effectID] - 1
	end
end

local function _addModelRefrence(self,modelID)
	if not modelID then return end
	modelID = tostring(modelID)
	if self.modelUrlDic[modelID] == nil then
		self.modelUrlDic[modelID] = 0
	end
	self.modelUrlDic[modelID] = self.modelUrlDic[modelID] +1
	self.modelTimeDic[modelID] = self.fightModel:getFTime()
end

local function _deleteModelRefrence(self,modelID)
	modelID = tostring(modelID)
	if self.modelUrlDic[modelID] then
		self.modelUrlDic[modelID] = self.modelUrlDic[modelID] - 1
	end
end

--functions的iskindof有问题,暂时根据cc.Node里面的函数来判断
local function isNodeInstance(obj)
	if not obj then return false end
	return obj.setNodeEventEnabled and obj.setKeypadEnabled and obj.setTouchEnabled
end


function ArmatureManager:addNodeCancelListener(key)
	if not key then return end
	if self.mapNode2ListenerRecord[key] then return end
	self.mapNode2ListenerRecord[key] = true
	local typeKey = type(key)
	if typeKey == "userdata" then
		if isNodeInstance(key) then
			local keyHandle = nil
			keyHandle = key:addNodeEventListener(cc.NODE_EVENT,function(event)
				local name = event.name
				if name == "cleanup" then
					key:removeNodeEventListener(keyHandle)
					self:cancelAsyLoadEffectByKey(key)
					self:cancelAsyLoadModelByKey(key)
					self.mapNode2ListenerRecord[key] = false
				end
			end)
		end
	end
end

function ArmatureManager:ctor()	

	self.existResID = {}
	self.fileInstance = cc.FileUtils:getInstance()
	--self.fileInstance:isFileExist(ResUtil.getModel(modelID))

	self.ArmatureList = {}

	self.fightModel = FightModel
	self.armatureDataManager = ccs.ArmatureDataManager:getInstance()

	self.modelUrlDic = {}
	self.modelTimeDic = {}

	self.effectUrlDic = {}
	self.effectTimeDic = {}

	self.petShowUrlDic = {}
	self.petShowTimeDic = {}

	self.asyncBackFunDic = {}
	self.tt= 0

	self.wingCanchDic = {}
	self.wingCanchNum = 0

	self.weaponCanchDic = {}
	self.weaponCanchNum = 0

	self.clothesCanchDic = {}
	self.clothesCanchNum = 0


	self.mapEffectID2Callbacks = {}
	self.mapNode2ListenerRecord = {}
	self.mapModelID2Callbacks = {}

end

function ArmatureManager:getInstance()
	if self.Instance==nil then
		self.Instance = ArmatureManager.new()
	end
	return self.Instance
end


function ArmatureManager:getFreeMemory()
	--if true then return 0 end
	if os.getFreeMemory then
		return os.getFreeMemory()
	end
	return 20
end

function ArmatureManager:addModelCacheDic(modelId,mtype)
	if mtype == 1 then
		if self.clothesCanchDic[modelId] == nil then
			self.clothesCanchNum = self.clothesCanchNum +1
		end
		self.clothesCanchDic[modelId] = self.fightModel:getFTime()
	elseif mtype == 2 then
		if self.wingCanchDic[modelId] == nil then
			self.wingCanchNum = self.wingCanchNum +1
		end
		self.wingCanchDic[modelId] = self.fightModel:getFTime()
	elseif mtype == 3 then
		if self.weaponCanchDic[modelId] == nil then
			self.weaponCanchNum = self.weaponCanchNum +1
		end
		self.weaponCanchDic[modelId] = self.fightModel:getFTime()
	end
end


function ArmatureManager:delectModelCacheDic(modelId,type)
	if mtype == 1 then
		self.clothesCanchDic[modelId] = nil
		self.clothesCanchNum = self.clothesCanchNum -1
	elseif mtype == 2 then
		self.wingCanchDic[modelId] = nil
		self.wingCanchNum = self.clothesCanchNum -1
	elseif mtype == 3 then
		self.weaponCanchDic[modelId] = nil
		self.weaponCanchNum = self.clothesCanchNum -1
	end
end

--是否存在模型资源
--modelID模型ID
--type 模型类型 1表示身体和坐骑，2表示翅膀，3表示武器
function ArmatureManager:existModelRes(modelID,mtype,vo,refersh)
	if self.armatureDataManager:getArmatureData(modelID) then
		return modelID
	end
	local exist = self.fileInstance:isFileExist(ResUtil.getModel(modelID))
	if  (self.existResID[modelID] or exist) and self:getFreeMemory() > 19 then
		self.existResID[modelID] = true
		return modelID
	else
		if refersh and exist then
			return modelID
		end
		-- if self:getFreeMemory() < 16 then
		-- 	self:resClear(modelID)
		-- end
		if mtype == 1 then
			if vo.type == SceneRoleType.PLAYER or vo.type == SceneRoleType.PLAYERCOPY then
				if vo.career == RoleCareer.WARRIOR then --战士
					if vo.sex == RoleSex.MAN then
						return "1102"
					else
						return "2102"
					end
				elseif vo.career == RoleCareer.MAGE then --法师
					if vo.sex == RoleSex.MAN then
						return "1202"
					else
						return "2202"
					end
				elseif vo.career == RoleCareer.TAOIST then --道士
					if vo.sex == RoleSex.MAN then
						return "1302"
					else
						return "2302"
					end
				end
			elseif vo.type == SceneRoleType.MONSTER then
				return "7554" 
			elseif vo.type == SceneRoleType.PET then
				return "7554"
			end
			return "7554"
		elseif mtype == 2 then
			return "5102"
		elseif mtype == 3 then
			if vo.type == SceneRoleType.PLAYER or vo.type == SceneRoleType.PLAYERCOPY then
				if vo.career == RoleCareer.WARRIOR then --战士
					if vo.sex == RoleSex.MAN then
						return "3111"
					else
						return "4111"
					end
				elseif vo.career == RoleCareer.MAGE then --法师
					if vo.sex == RoleSex.MAN then
						return "3211"
					else
						return "4211"
					end
				elseif vo.career == RoleCareer.TAOIST then --道士
					if vo.sex == RoleSex.MAN then
						return "3311"
					else
						return "4311"
					end
				end
			end
		elseif mtype == 4 then
		end
	end
	return modelID
end

function ArmatureManager:preLoadModel(modelID)
	_addModelRefrence(self,modelID)
	self.modelTimeDic[modelID] = 0
end

--卸载 模型
function ArmatureManager:unloadModel(modelID)
	_deleteModelRefrence(self,modelID)
end



---------------------------------新的异步加载model接口开始---------------------------------------------------------------------------

local function _tryCreateModelCallback(self,key,modelId,callback)
	if not key then return end
	local modelCallbacks =  self.mapModelID2Callbacks[modelId]
	local ret = false
	if not modelCallbacks then
		ret = true
		modelCallbacks = {}
		self.mapModelID2Callbacks[modelId] = modelCallbacks
	end
	modelCallbacks[key] = callback
	return ret
end


local function _loadArmatureModelDataCompelete(self,modelID)
	local armatureData = self.armatureDataManager:getArmatureData(modelID)
	if not armatureData then return end
	local modelCallbacks = self.mapModelID2Callbacks[modelID]
	if not modelCallbacks then return end

	for key,callback in pairs(modelCallbacks or {}) do
		callback(key)
	end		
	self.mapModelID2Callbacks[modelID] = nil

--	GlobalTimer.performWithDelayGlobal(function()
		
	--end,3.0)

	
end

function ArmatureManager:asyLoadModelByKey(modelID,callback,key)
	modelID = tostring(modelID)
	_addModelRefrence(self,modelID)
	if callback then
		local armature = self.armatureDataManager:getArmatureData(modelID)
		if armature and self.asyncBackFunDic[modelID] == nil then
			callback(key)
		else
			local function dataLoaded(armatureId, armatureData)
				_loadArmatureModelDataCompelete(self,modelID)
				self.modelTimeDic[modelID] = self.fightModel:getFTime()
			end
			self:addNodeCancelListener(key)
			local needLoad = _tryCreateModelCallback(self,key,modelID,callback)
			if needLoad then
				if self:isPvr(modelID) then
					--print(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID))
					self.armatureDataManager:addArmaturefoAsync(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID),ResUtil.getModel(modelID), modelID, dataLoaded)
				else
					self.armatureDataManager:autoAddArmaturefoAsync(ResUtil.getModel(modelID), modelID, dataLoaded)
				end
			end
		end
		return true
	end


	if self.armatureDataManager:getArmatureData(modelID) == nil then
		if self:isPvr(modelID) then
			self.armatureDataManager:addArmatureFileInfo(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID), ResUtil.getModel(modelID))
		else
			self.armatureDataManager:addArmatureFileInfo(ResUtil.getModel(modelID))
		end
	end
	-- local ff = manager:addArmatureFileInfo("model/500/500.ExportJson")
	-- dump(manager:getArmatureDatas())
	-- print(manager:getAnimationData("500"))
	-- print(manager:getArmatureData("500"))
	return (self.armatureDataManager:getArmatureData(modelID) ~= nil)
end


function ArmatureManager:cancelAsyLoadModelByKey(key)
	for modelID,modelCallbacks in pairs(self.mapModelID2Callbacks or {}) do
		modelCallbacks[key] = nil
	end

end
---------------------------------新的异步加载model接口结束---------------------------------------------------------------------------


-- 加载模型
function ArmatureManager:loadModel(modelID,backFun)
	modelID = tostring(modelID)
	_addModelRefrence(self,modelID)
	if backFun then
		local armature = self.armatureDataManager:getArmatureData(modelID)
		if armature and self.asyncBackFunDic[modelID] == nil then
			backFun(armature,modelID)
		else
			local function dataLoaded(armatureId, armatureData)
				--if percent >= 1 then
					if self.asyncBackFunDic[modelID] and #self.asyncBackFunDic[modelID] > 0 then
						for i=1,#self.asyncBackFunDic[modelID] do
							if self.asyncBackFunDic[modelID][i] then
								self.asyncBackFunDic[modelID][i](armatureData, modelID)
							end
						end
					end
					self.modelTimeDic[modelID] = self.fightModel:getFTime()
					self.asyncBackFunDic[modelID] = nil
				--end
			end

			local loading = false
			if self.asyncBackFunDic[modelID] == nil then
				self.asyncBackFunDic[modelID] = {}
				loading = true
			end
			table.insert(self.asyncBackFunDic[modelID],backFun)
			if loading then
				if self:isPvr(modelID) then
					--print(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID))
					self.armatureDataManager:addArmaturefoAsync(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID),ResUtil.getModel(modelID), modelID, dataLoaded)
				else
					self.armatureDataManager:autoAddArmaturefoAsync(ResUtil.getModel(modelID), modelID, dataLoaded)
				end
			end
		end
		return true
	end


	if self.armatureDataManager:getArmatureData(modelID) == nil then
		if self:isPvr(modelID) then
			self.armatureDataManager:addArmatureFileInfo(ResUtil.getModelImg(modelID),ResUtil.getModelPlist(modelID), ResUtil.getModel(modelID))
		else
			self.armatureDataManager:addArmatureFileInfo(ResUtil.getModel(modelID))
		end
	end
	-- local ff = manager:addArmatureFileInfo("model/500/500.ExportJson")
	-- dump(manager:getArmatureDatas())
	-- print(manager:getAnimationData("500"))
	-- print(manager:getArmatureData("500"))
	return (self.armatureDataManager:getArmatureData(modelID) ~= nil)
end




function ArmatureManager:preLoadEffect(effectID)
	_addEffectRefrence(self,effectID)
	self.effectTimeDic[effectID] = 0
end


--卸载 效果
function ArmatureManager:unloadEffect(effectID)
	_deleteEffectRefrence(self,effectID)
end



-- 加载效果
function ArmatureManager:loadEffect(effectID, callback)
	effectID = tostring(effectID)
	_addEffectRefrence(self,effectID)
	local url = ResUtil.getEffect(effectID)
	local ret = false
	if self.armatureDataManager:getArmatureData(effectID) == nil then
		if self:isPvr(effectID) then
			if callback then
				self.armatureDataManager:addArmaturefoAsync(ResUtil.getEffectPVRImg(effectID), ResUtil.getEffectPlist(effectID), url, effectID, callback)
			else
				self.armatureDataManager:addArmatureFileInfo(ResUtil.getEffectPVRImg(effectID),ResUtil.getEffectPlist(effectID),url)
			end
		else
			if callback then
				self.armatureDataManager:autoAddArmaturefoAsync(url, effectID, callback)
			else
				self.armatureDataManager:addArmatureFileInfo(url)
			end
		end
		ret = self.armatureDataManager:getArmatureData(effectID) ~= nil
	else
		if callback then
			callback(effectID)
	    end
		ret = true
	end
	return ret
end

---------------------------------新的异步加载effct接口开始---------------------------------------------------------------------------

local function _loadArmatureEffectDataCompelete(self,effectID)
	local armatureData = self.armatureDataManager:getArmatureData(effectID)
	if not armatureData then return end
	local effectCallbacks = self.mapEffectID2Callbacks[effectID]
	if not effectCallbacks then return end
	for key,callback in pairs(effectCallbacks or {}) do
		callback(key)
	end
	self.mapEffectID2Callbacks[effectID] = nil
	--GlobalTimer.performWithDelayGlobal(function()
		
	--end,3.0)
	
end

local function _tryCreateEffectCallback(self,key,effectID,callback)
	local effectCallbacks =  self.mapEffectID2Callbacks[effectID]
	local ret = false
	if not effectCallbacks then
		ret = true
		effectCallbacks = {}
		self.mapEffectID2Callbacks[effectID] = effectCallbacks
	end
	effectCallbacks[key] = callback
	return ret
end

function ArmatureManager:asyLoadEffectByKey(effectID,callback,key)
	effectID = tostring(effectID)
	_addEffectRefrence(self,effectID)
	local url = ResUtil.getEffect(effectID)
	local ret = false
	if self.armatureDataManager:getArmatureData(effectID) == nil then
		local loadArmatureDataCompelete = function()
			_loadArmatureEffectDataCompelete(self,effectID)
		end

		local loadPvrRes = function(self)
			if callback then
				self:addNodeCancelListener(key)
				local needLoad = _tryCreateEffectCallback(self,key,effectID,callback)
				if needLoad then
					self.armatureDataManager:addArmaturefoAsync(ResUtil.getEffectPVRImg(effectID), ResUtil.getEffectPlist(effectID), url, effectID, loadArmatureDataCompelete)
				end
			else
				self.armatureDataManager:addArmatureFileInfo(ResUtil.getEffectPVRImg(effectID),ResUtil.getEffectPlist(effectID),url)
			end
		end

		local loadNormalRes = function(self)
			if callback then
				self:addNodeCancelListener(key)
				local needLoad = _tryCreateEffectCallback(self,key,effectID,callback)
				if needLoad then
					self.armatureDataManager:autoAddArmaturefoAsync(url, effectID, loadArmatureDataCompelete)
				end
			else
				self.armatureDataManager:addArmatureFileInfo(url)
			end
		end

		if self:isPvr(effectID) then
			loadPvrRes(self)
		else
			loadNormalRes(self)
		end

		ret = self.armatureDataManager:getArmatureData(effectID) ~= nil
	else
		if callback then
			callback(effectID)
	    end
		ret = true
	end
	return ret

end


function ArmatureManager:cancelAsyLoadEffectByKey(key)
	for effectID,effectCallbacks in pairs(self.mapEffectID2Callbacks or {}) do
		effectCallbacks[key] = nil
	end
end

function ArmatureManager:asyLoadEffect(effectID)
	effectID = tostring(effectID)
	local url = ResUtil.getEffect(effectID)
	local ret = false
	if self.effectUrlDic[effectID] == nil then
		self.effectUrlDic[effectID] = 0
	end
	if self.armatureDataManager:getArmatureData(effectID) == nil then
		if self:isPvr(effectID) then
			self.armatureDataManager:addArmatureFileInfoAsyncEx(ResUtil.getEffectPVRImg(effectID), ResUtil.getEffectPlist(effectID), url)
		else
			self.armatureDataManager:autoAddArmatureFileInfoAsyncEx(url)
		end
	end
	self.effectUrlDic[effectID] = self.effectUrlDic[effectID] +1
	self.effectTimeDic[effectID] = self.fightModel:getFTime()
end

---------------------------------新的异步加载effect接口结束---------------------------------------------------------------------------



-- 加载宠物内观动画
function ArmatureManager:loadPetShow(petId)
	local url = ResUtil.getPetShow(petId)
	if self.petShowUrlDic[url] == nil then
		self.petShowUrlDic[url] = 0
	end
	if self.armatureDataManager:getArmatureData(petId.."pet") == nil then
		self.armatureDataManager:addArmatureFileInfo(url)
	end
	self.petShowUrlDic[url] = self.petShowUrlDic[url] +1
	self.petShowTimeDic[url] = self.fightModel:getFTime()
	-- local ff = manager:addArmatureFileInfo("500.ExportJson")
	-- dump(manager:getArmatureDatas())
	-- print(manager:getAnimationData("500"))
	-- print(manager:getArmatureData("500"))
	return (self.armatureDataManager:getArmatureData(petId.."pet") ~= nil)
end

--卸载宠物内观动画
function ArmatureManager:unloadPetShow(petId)
	local url = ResUtil.getPetShow(petId)
	if self.petShowUrlDic[url] then
		self.petShowUrlDic[url] = self.petShowUrlDic[url] - 1
	end
end


function ArmatureManager:update()
	self.tt = self.tt +1
	if self.tt%30 == 0 and self:getFreeMemory() < 31 then
		self:resClear()
	end
	-- self.tt = self.tt +1
	-- --print(self.tt%20)
	-- if self.tt%550 == 0 then
	-- 	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- 	--dump(self.armatureDataManager:getArmatureDatas())
	-- 	print(self.fightModel:getFTime())
	-- end
	-- -- if self.tt%10 == 0 then
	-- -- 	--cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- -- 	dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
	-- -- end
end

function ArmatureManager:resClear(modelId)
	--local resType = configHelper:getModelType(modelId)
	
	local t = self.fightModel:getFTime()
	local pic,texture
	for k,v in pairs(self.modelUrlDic) do
		if v <= 0 and t - self.modelTimeDic[k] > 60 then
			self.armatureDataManager:removeArmatureFileInfo(ResUtil.getModel(k))
			self.modelTimeDic[k] = nil
			self.modelUrlDic[k] = nil

			if self:isPvr(k) then
				pic = ResUtil.getModelImg(k)
				texture = cc.Director:getInstance():getTextureCache():getTextureForKey(pic)
				if  texture and texture:getReferenceCount() == 1 then --没有其他使用时才删除，防止崩毁
					cc.Director:getInstance():getTextureCache():removeTextureForKey(pic)
				end
			end
		end
	end

	for k,v in pairs(self.effectUrlDic) do
		if v <= 0 and t - self.effectTimeDic[k] > 60 then
			self.armatureDataManager:removeArmatureFileInfo(ResUtil.getEffect(k))
			self.effectTimeDic[k] = nil
			self.effectUrlDic[k] = nil
			if self:isPvr(k) then
				pic = ResUtil.getEffectPVRImg(k)
				texture = cc.Director:getInstance():getTextureCache():getTextureForKey(pic)
				if texture and texture:getReferenceCount() == 1 then
					cc.Director:getInstance():getTextureCache():removeTextureForKey(pic)
				end
			end
		end
	end
	
	for k,v in pairs(self.petShowUrlDic) do
		if v <= 0 and t - self.petShowTimeDic[k] > 70 then
			self.armatureDataManager:removeArmatureFileInfo(k)
			self.petShowTimeDic[k] = nil
			self.petShowUrlDic[k] = nil
			if self:isPvr(k) then
				cc.Director:getInstance():getTextureCache():removeTextureForKey(ResUtil.getEffectPVRImg(k))
			end
		end
	end
end




function ArmatureManager:creatArmature(armaturename,armatureUrl)
	local armature 
	if self.ArmatureList[Armaturename] ~= nil and #self.ArmatureList[Armaturename] >0 then
		armature = table.remove(self.ArmatureList[Armaturename],1)
		--print(Armaturename,armature,self.ArmatureList[Armaturename])
		--print(armature,#self.ArmatureList,GlobalController.fight.playEff)
		--armature:init(Armaturename)
	else
		armature = ccs.Armature:create(Armaturename)
		GlobalController.fight.playEff = GlobalController.fight.playEff+1
		--print("creat",GlobalController.fight.playEff)

	end	 
	
	return armature
end	

function ArmatureManager:destoyArmature(armature,key)
	-- GlobalController.fight.shengEff=GlobalController.fight.shengEff + 1
	-- print(GlobalController.fight.shengEff)

	armature:stopAllActions()
    armature:getAnimation():stop()
    --table.insert(self.ArmatureList,armature)
    armature:retain()
    if armature:getParent() then
    	armature:getParent():removeChild(armature)
    end 
    if self.ArmatureList[key] == nil then
    	self.ArmatureList[key] = {}
    end	
    table.insert(self.ArmatureList[key],armature)
    --armature:release()
end	


function ArmatureManager:clear(exceptDic)
	self.tt = 1
	self.asyncBackFunDic = {}
	local t = self.fightModel:getFTime()
	local pic,texture
	for k,v in pairs(self.modelUrlDic or {}) do
			if v <= 0 and (not self.modelTimeDic[k] or t - self.modelTimeDic[k] > 10 ) then
				self.armatureDataManager:removeArmatureFileInfo(ResUtil.getModel(k))
				self.modelTimeDic[k] = nil
				self.modelUrlDic[k] = nil
				if self:isPvr(k) then
					pic = ResUtil.getModelImg(k)
					texture = cc.Director:getInstance():getTextureCache():getTextureForKey(pic)
					if  texture and texture:getReferenceCount() == 1 then --没有其他使用时才删除，防止崩毁
						cc.Director:getInstance():getTextureCache():removeTextureForKey(pic)
					end
				end
			end
		end

		for k,v in pairs(self.effectUrlDic or {}) do
			if v <= 0 and (not self.effectTimeDic[k] or  t - self.effectTimeDic[k] > 10)then
				self.armatureDataManager:removeArmatureFileInfo(ResUtil.getEffect(k))
				self.effectTimeDic[k] = nil
				self.effectUrlDic[k] = nil
				if self:isPvr(k) then
					pic = ResUtil.getEffectPVRImg(k)
					texture = cc.Director:getInstance():getTextureCache():getTextureForKey(pic)
					if texture and texture:getReferenceCount() == 1 then
						cc.Director:getInstance():getTextureCache():removeTextureForKey(pic)
					end
				end
			end
		end
	-- for k,v in pairs(self.modelUrlDic) do
	-- 	if exceptDic == nil or exceptDic[k] == nil then
	-- 		self.armatureDataManager:removeArmatureFileInfo(ResUtil.getModel(k))
	-- 		self.modelTimeDic[k] = nil
	-- 		self.modelUrlDic[k] = nil
	-- 	else
		
	-- 	end
	-- end
	-- self.modelTimeDic = {}
	-- self.modelUrlDic = {}
	-- for k,v in pairs(self.effectUrlDic) do
	-- 	if exceptDic == nil or exceptDic[k] == nil then
	-- 		self.armatureDataManager:removeArmatureFileInfo(k)
	-- 		self.effectTimeDic[k] = nil
	-- 		self.effectUrlDic[k] = nil
	-- 	else
			
	-- 	end
	-- end
	-- self.effectTimeDic = {}
	-- self.effectUrlDic = {}
	-- for k,v in pairs(self.petShowUrlDic) do
	-- 	if exceptDic == nil or exceptDic[k] == nil then
	-- 		self.armatureDataManager:removeArmatureFileInfo(k)
	-- 		self.petShowTimeDic[k] = nil
	-- 		self.petShowUrlDic[k] = nil
	-- 	else
			
	-- 	end
	-- end
	-- self.petShowTimeDic = {}
	-- self.petShowUrlDic = {}

	GlobalController.fight.playEff = 0
	for k,v in pairs(self.ArmatureList or {}) do
		for _,item in ipairs(v or {}) do
			item:release()
		end
	end
	self.ArmatureList = {}
end

function ArmatureManager:isPvr(modelID)
	return true
	--configHelper.pvrResConfig.datas[modelID]
end

function ArmatureManager:destory()
	self.asyncBackFunDic = {}
	-- for k,v in pairs(self.modelUrlDic) do
	-- 	self.armatureDataManager:removeArmatureFileInfo(k)
	-- 	self.modelTimeDic[k] = nil
	-- 	self.modelUrlDic[k] = nil
	-- end
	-- self.modelTimeDic = {}
	-- self.modelUrlDic = {}
	-- for k,v in pairs(self.effectUrlDic) do
	-- 	self.armatureDataManager:removeArmatureFileInfo(k)
	-- 	self.effectTimeDic[k] = nil
	-- 	self.effectUrlDic[k] = nil
	-- end
	-- self.effectTimeDic = {}
	-- self.effectUrlDic = {}
	-- for k,v in pairs(self.petShowUrlDic) do
	-- 	self.armatureDataManager:removeArmatureFileInfo(k)
	-- 	self.petShowTimeDic[k] = nil
	-- 	self.petShowUrlDic[k] = nil
	-- end
	-- self.petShowTimeDic = {}
	-- self.petShowUrlDic = {}

	GlobalController.fight.playEff = 0
	for k,v in pairs(self.ArmatureList) do
		for i=1,#v do
		v[i]:release()
		end
	end
	self.ArmatureList = {}
end	