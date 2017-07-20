--自动释放某些技能 
--比如:隐身技能
local AutoUseSpecialSkillListener = class("AutoUseSpecialSkillListener",function()
	return display.newNode()
end)

local kHideSelfSkills = {51200}

AutoUseSpecialSkillListener.localData = nil
AutoUseSpecialSkillListener.skillListenerHandIds = nil

AutoUseSpecialSkillListener.scheduleTimeId = nil
AutoUseSpecialSkillListener.hasNoEmemyTimes = 0

function AutoUseSpecialSkillListener:ctor()
    self.localData = RoleManager:getInstance().roleInfo.autoDrugOption
	self:setNodeEventEnabled(true)
	self.skillListenerHandIds = {}
	self:updateSkill()
end

function AutoUseSpecialSkillListener:onEnterTransitionFinish()
	self:registerEvent()
end

function AutoUseSpecialSkillListener:onCleanup()
	self:unregisterEvent()
end

function AutoUseSpecialSkillListener:registerEvent()


	local updateSkillListHandleId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_SKILL_LIST, handler(self,self.updateSkill))
	local initSkillListHandleId = GlobalEventSystem:addEventListener(SkillEvent.INIT_SKILL_LIST_COMPELETE, handler(self,self.updateSkill))

	table.insert(self.skillListenerHandIds,updateSkillListHandleId)
	table.insert(self.skillListenerHandIds,initSkillListHandleId)

end

local function _getCanReleaseSkill(self)
	--隐身戒指
	for _,hideSelfSkillId in ipairs(kHideSelfSkills) do
		local canUse = RoleManager:getInstance():canUseSkillById(hideSelfSkillId)
		if canUse then
			local roleUseSkillVo = RoleManager:getInstance():getFightUseSkill(hideSelfSkillId)
			local isUnLockCd = roleUseSkillVo:getSkillLock()
			if isUnLockCd then
				return hideSelfSkillId
			end
		end
	end

	return nil
end

function AutoUseSpecialSkillListener:schedueUpdateFunction()
	

	local skillId = _getCanReleaseSkill(self)
	if not skillId then return end
    
	local fightModel = GlobalController.fight.fightModel
    if not fightModel then return end

    local selfRoleModel = GlobalController.fight:getSelfPlayerModel()
    if not selfRoleModel then return end
    local skillConfig = fightModel:getSkillConfig(skillId)
    selfRoleModel:usePlayerSkillForExtenal(skillConfig,true)
end

local function _isOpenUpdate(self)
	for _,hideSelfSkillId in ipairs(kHideSelfSkills) do
		local canUse = RoleManager:getInstance():canUseSkillById(hideSelfSkillId)
		if canUse then
			return true
		end
	end
	return false
end

function AutoUseSpecialSkillListener:startTimer()

	if self.scheduleTimeId then return end
	self.scheduleTimeId =  GlobalTimer.scheduleGlobal(function()
		self:schedueUpdateFunction()
	end,2)
end

function AutoUseSpecialSkillListener:stopTimer()
	if self.scheduleTimeId then
		GlobalTimer.unscheduleGlobal(self.scheduleTimeId)
		self.scheduleTimeId = nil
	end
end

function AutoUseSpecialSkillListener:updateSkill()
	local isOpen = _isOpenUpdate(self)
	if isOpen then
		self:startTimer()
	else
		self:stopTimer()
	end
end

function AutoUseSpecialSkillListener:unregisterEvent()
	for _,listenerId in ipairs(self.skillListenerHandIds or {}) do
		GlobalEventSystem:removeEventListenerByHandle(listenerId)
	end
	self.skillListenerHandIds = {}
	if self.scheduleTimeId then
		GlobalTimer.unscheduleGlobal(self.scheduleTimeId)
	end
	self:stopTimer()
	
end

return AutoUseSpecialSkillListener