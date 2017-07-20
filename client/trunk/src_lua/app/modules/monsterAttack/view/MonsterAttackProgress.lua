--
-- Author: Yi hanneng
-- Date: 2016-06-27 19:07:20
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local MonsterAttackProgress = MonsterAttackProgress or class("MonsterAttackProgress", function() return display.newNode() end )

function MonsterAttackProgress:ctor()
	self.ccui = cc.uiloader:load("resui/monsterAttackLeft.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function MonsterAttackProgress:init()
	self.itemList = {}
	self.time = 0
	
	self.rankBtn = cc.uiloader:seekNodeByName(self.ccui, "rankBtn")
	self.retractBtn = cc.uiloader:seekNodeByName(self.ccui, "retractBtn")
	self.retractBtn:setScale(-1)
	self.layer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")

	self.bar = cc.uiloader:seekNodeByName(self.ccui, "progressBar")
	self.barLabel = cc.uiloader:seekNodeByName(self.ccui, "progressTxt")
	self.round = cc.uiloader:seekNodeByName(self.ccui, "waveLabel")
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.treasureNum = cc.uiloader:seekNodeByName(self.ccui, "treasureNum")
	self.pointNum = cc.uiloader:seekNodeByName(self.ccui, "pointNum")
	self.rankLabel = cc.uiloader:seekNodeByName(self.ccui, "rankLabel")
	self.btnState = true

	self.retractBtn:setTouchEnabled(true)
	self.retractBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
             if self.btnState then
             	self:hide()	
             else
             	self:show()
             end
 
        end
        return true
    end)

	self.rankBtn:setTouchEnabled(true)
	self.rankBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.rankBtn:setScale(1.1)
        	 
        elseif event.name == "ended" then
        	self.rankBtn:setScale(1)
            
	 		local WinnerReward = require("app.modules.monsterAttack.view.MonsterAttackRank").new()
			WinnerReward:setViewInfo(self.data)
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,WinnerReward)
        end
        return true
    end)
	 
	GlobalEventSystem:addEventListener(MonsterAttackEvent.MONSTER_UPDATE_INFO,handler(self,self.setViewInfo))
end

function MonsterAttackProgress:hide()
	if self.layer then
		--todo
	local action = cc.MoveTo:create(0.3, cc.p(-190, self.layer:getPositionY()))	
    local action2 = cc.CallFunc:create(function() 
	    self.retractBtn:setScale(1)
	    self.btnState = false 
    end)       
    self.layer:stopAllActions()
	self.layer:runAction(transition.sequence({action,action2}))
	end

end

function MonsterAttackProgress:show()
	if self.layer then
	local action = cc.MoveTo:create(0.3, cc.p(0, self.layer:getPositionY()))					
	local action3 = cc.CallFunc:create(function()
		self.retractBtn:setScale(-1)
		self.btnState = true 
	end)     
	self.layer:stopAllActions()  
	self.layer:runAction(transition.sequence({action,action3}))
end

end

function MonsterAttackProgress:setViewInfo(data)

	data = data.data
 	self.data = data
	--设置自己排名和伤害

	--[[
	<Param name="type" type="int8" describe="1副本面板信息 2奖励面板信息胜利 3奖励面板信息失败" /> 
  <Param name="round" type="int8" describe="怪物波数" /> 
  <Param name="box" type="int16" describe="剩余宝箱个数" /> 
  <Param name="time" type="int16" describe="下一波还剩的秒数" /> 
  <Param name="player_rank" type="int16" describe="玩家自己排名" /> 
  <Param name="player_score" type="int32" describe="玩家自己积分" /> 
  <Param name="boss_hp" type="int32" describe="龙柱总血量" /> 
  <Param name="boss_cur_hp" type="int32" describe="龙柱当前血量" /> 
  <Param name="rank_list" type="list" sub_type="proto_attack_city_rank" describe="排名信息" /> 
	--]]
 	self.barLabel:setString(data.boss_cur_hp.."/"..data.boss_hp)
	self.bar:setPercent(data.boss_cur_hp/data.boss_hp*100)
 	self.round:setString(data.round)
 	self.rankLabel:setString(data.player_rank)
 	self.pointNum:setString(data.player_score)
 	self.treasureNum:setString(data.box)
 	
 	if self.cdEventId == nil then
 		self.time = data.time
 		self.timeLabel:setString(StringUtil.convertTime(data.time))
 		self.cdEventId = scheduler.scheduleGlobal(function()

	 	if self.time > 0 then
	 		self.time = self.time - 1
	 	else
	 		self.time = 0
	 	end

	 	self.timeLabel:setString(StringUtil.convertTime(self.time))

	 	if self.time <= 0 then
	 		scheduler.unscheduleGlobal(self.cdEventId)
	        self.cdEventId = nil
	 	end

	    end,1)
 	end


end

function MonsterAttackProgress:destory()
	self.layer:stopAllActions()  
	self:close()
	self:removeSelf()
end

function MonsterAttackProgress:close()
	if self.cdEventId then
		scheduler.unscheduleGlobal(self.cdEventId)
	    self.cdEventId = nil
	end
	GlobalEventSystem:removeEventListener(MonsterAttackEvent.MONSTER_UPDATE_INFO)
end

return MonsterAttackProgress