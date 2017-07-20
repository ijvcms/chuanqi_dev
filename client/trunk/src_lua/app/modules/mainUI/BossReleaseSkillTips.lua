--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-22 10:19:10
-- boss释放技能提示信息

local BossReleaseSkillTips = class("BossReleaseSkillTips", function()
	return display.newNode()
end)

function BossReleaseSkillTips.create(param)
	return BossReleaseSkillTips.new(param)
end

function BossReleaseSkillTips:ctor(param)
 	self.redBg = display.newSprite("#scene/scene_popTipsBg.png")
    self:addChild(self.redBg)
    self.redBg:setTouchEnabled(false)
    self.redBg:setPosition(0,10)

    self.timeNumLab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>")
    self:addChild(self.timeNumLab)
    self.timeNumLab:setPosition(0,0)
    self:setVisible(true)
    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
    self.isdestory = false
end

function BossReleaseSkillTips:onNodeEvent(data)
    if data.name == "exit" then
    	self:destory()
    end
end

function BossReleaseSkillTips:open(id)
	self.conf = configHelper:getMonsterWarningById(id)
	self.time = 1
	if self.conf then
		self.tipsStr = self.conf.concent or "释放必杀技"
	else
		self.tipsStr = id or "id"
	end
	self:setTime(self.time)
	--self.timeNumLab:setString(self.tipsStr)
	self.timeNumLab:renderXml("<font color='0xFFFFFF' size='20' opacity='255'>"..self.tipsStr.."</font>")
	local size  = self.timeNumLab:getContentSize()
	self.timeNumLab:setPosition(0-size.width/2,0)
end

function BossReleaseSkillTips:setTime(data)
	if self.isdestory then return end
	if self.time > 0 then
		if self.timerId == nil then
	        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.destory),self.time)
	    end
	    self:setVisible(true)
	else
		self:destory()
	end
end

function BossReleaseSkillTips:destory()
	if self.isdestory then return end
	self.isdestory = true
	if self.timerId then
	 	GlobalTimer.unscheduleGlobal(self.timerId)
	 	self.timerId = nil
	end
	self:removeSelf()
end

return BossReleaseSkillTips