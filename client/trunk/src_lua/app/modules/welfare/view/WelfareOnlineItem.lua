--
-- Author: Yi hanneng
-- Date: 2016-04-22 10:21:32
--

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local WelfareOnlineItem = WelfareOnlineItem or class("WelfareOnlineItem", UIAsynListViewItemEx)

function WelfareOnlineItem:ctor(loader, layoutFile)
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
    self:setNodeEventEnabled(true)
end

function WelfareOnlineItem:onCleanup()
	self:destory()
end

function WelfareOnlineItem:init()

	self.itemList = {}
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.timingLabel = cc.uiloader:seekNodeByName(self.ccui, "timingLabel")
	self.btnGet = cc.uiloader:seekNodeByName(self.ccui, "btnGet")

	self.btnGet:setTouchEnabled(true)
	self.btnGet:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnGet:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnGet:setScale(1.0)

            if self.clickfun then
            	self.clickfun(self)
            end

         end     
        return true
    end)

    self._change_handle = GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, function()
    	self:invalidateData()
	end)

end

function WelfareOnlineItem:setData(data)

	if data == nil then
		return 
	end
	self.data = data
	self.timeLabel:setString(data.condition_text)
	--[[
	for i=1,#data.reward do
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = data.reward[i][1],is_bind = data.reward[i][2]})
		commonItem:setCount(data.reward[i][3])
		self.ccui:addChild(commonItem, 10, 10)
		commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 20)
	end
	--]]
	---------------
 
    if #self.itemList > 0 then

        for i=#self.itemList,#data.reward + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#data.reward do
            if self.itemList[i] == nil then
                local commonItem = CommonItemCell.new()
				commonItem:setData({goods_id = data.reward[i][1],is_bind = data.reward[i][2]})
				commonItem:setCount(data.reward[i][3])
				self.itemList[#self.itemList + 1] = commonItem
				self.ccui:addChild(commonItem, 10, 10)
				commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 10)
            else
            	self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = data.reward[i][1],is_bind = data.reward[i][2]})
                self.itemList[i]:setCount(data.reward[i][3])
            end
 
        end
    else
        for i=1,#data.reward do
			local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = data.reward[i][1],is_bind = data.reward[i][2]})
			commonItem:setCount(data.reward[i][3])
			self.itemList[#self.itemList + 1] = commonItem
			self.ccui:addChild(commonItem, 10, 10)
			commonItem:setPosition(i*(commonItem:getContentSize().width + 25) - 40 , commonItem:getContentSize().height/2 + 10)
		end
    end
 
    self:invalidateData()
 	
end

function WelfareOnlineItem:getData()
	return self.data
end

function WelfareOnlineItem:setState(flag)

	if flag then
		self.btnGet:setButtonLabelString("领取")
		self.btnGet:setButtonEnabled(true)
	else
		self.btnGet:setButtonLabelString("已领取")
		self.btnGet:setButtonEnabled(false)
	end

end

function WelfareOnlineItem:invalidateData()
	local data = self:getData()
	if data then
 
		-- 0未领取 1已领取 2 条件未达到，无法领取
		local itemState = GlobalController.welfare:GetRewardState(data.key)
		if itemState == 0 then
			self.btnGet:setButtonEnabled(true)
			self.btnGet:setButtonLabelString("领取")
			self.timingLabel:setString(string.format("%s", StringUtil.convertTime(0)))
			self:clearTimer()
		elseif itemState == 1 then
			self.btnGet:setButtonEnabled(false)
			self.btnGet:setButtonLabelString("已领取")
			self.timingLabel:setString(string.format("%s", StringUtil.convertTime(0)))
			self:clearTimer()
		elseif itemState == 2 then
			self.btnGet:setButtonEnabled(false)
			self.btnGet:setButtonLabelString("未获得")
		end
	end

	self:startTimer()
end

function WelfareOnlineItem:onTimerHandler()
	 
	self.endTime = self.endTime - 1
	if self.endTime <= 0 then
		self.endTime = 0
		self:clearTimer()
	end
	self.timingLabel:setString(string.format("%s", StringUtil.convertTime(self.endTime)))
end

function WelfareOnlineItem:startTimer()
	self:clearTimer()

	self.endTime = self.data.value - GlobalController.welfare:GetOnlineTime()
	if self.endTime > 0 then
		self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
		self:onTimerHandler()
 
	end
end	

function WelfareOnlineItem:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end


function WelfareOnlineItem:setItemClick(func)
	self.clickfun = func

end

function WelfareOnlineItem:destory()
	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
	self:clearTimer()
end

return WelfareOnlineItem