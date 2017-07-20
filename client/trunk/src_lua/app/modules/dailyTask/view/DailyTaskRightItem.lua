--
-- Author: Yi hanneng
-- Date: 2016-04-05 19:37:40
--
local DailyTaskRightItem = DailyTaskRightItem or class("DailyTaskRightItem", function() return display.newNode()end)

function DailyTaskRightItem:ctor()

	self.ccui = cc.uiloader:load("resui/goalWin_3.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function DailyTaskRightItem:init()

	self.activegoal = cc.uiloader:seekNodeByName(self.ccui, "activegoal")
	self.btnget = cc.uiloader:seekNodeByName(self.ccui, "btnget")
	self.goodsshow = cc.uiloader:seekNodeByName(self.ccui, "goodsshow")
 	
 	self.btnget:setTouchEnabled(true)
	self.btnget:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	        self.btnget:setScale(1.1)
	        SoundManager:playClickSound()
	    elseif event.name == "ended" then
	        self.btnget:setScale(1)
	        if self.data.finish == 1 then
	          self:getReward()
	        elseif self.data.finish == 2 then
	          GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"已经领取过!")
	        elseif self.data.finish == 0 then
	          GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"积分不够!")
	        end
	    end
	      return true
	  end)
 
end

function DailyTaskRightItem:setData(data)
	
	if data == nil then
		return
	end

	self.data = data

	self.activegoal:setString(data.des)

	if data.goods then
		for i=1,#data.goods do
		    local commonItem = CommonItemCell.new()
		    commonItem:setData({goods_id = data.goods[i][1]})
		    commonItem:setCount(data.goods[i][3])
		    self.ccui:addChild(commonItem, 10, 10)
		    commonItem:setPosition(i*(commonItem:getContentSize().width+15) + self.activegoal:getPositionX() - commonItem:getContentSize().width/2,self.activegoal:getPositionY() - commonItem:getContentSize().height + 16)
		end
	end

	if self.data.finish == 1 then
	    self.btnget:setButtonEnabled(true)
	elseif self.data.finish == 2 then
	    self.btnget:setButtonEnabled(false)
	    self.btnget:setButtonLabelString("已领取")
	elseif self.data.finish == 0 then
	    self.btnget:setButtonEnabled(false)

	end
end

function DailyTaskRightItem:getData()
	return self.data
end

function DailyTaskRightItem:getReward()
  GameNet:sendMsgToSocket(19001, {player_id = RoleManager.Instance.roleInfo.player_id, active = self.data.need_active})
  self.data.finish = 2
  self.btnget:setButtonEnabled(false)
  self.btnget:setButtonLabelString("已领取")
end

return DailyTaskRightItem