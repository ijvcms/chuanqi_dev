--
-- Author: Yi hanneng
-- Date: 2016-03-10 09:51:43
--
local WinnerReward = WinnerReward or class("WinnerReward", function() return display.newNode() end )

function WinnerReward:ctor(winTag,data,winconfig)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

  	self.itemList = {}

	self.ccui = cc.uiloader:load("resui/WinnerReward.ExportJson")
  	self:addChild(self.ccui)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
   	self:init()
end

function WinnerReward:init()

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.rankLabel = cc.uiloader:seekNodeByName(self.ccui, "rankLabel")
	
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            if self:getParent() then
    				--self:setVisible(false)
    				self:removeSelfSafety()
  				end	        
			end     
	        return true
    end)

	--NodeEvent
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end


function WinnerReward:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    	
    end
end

function WinnerReward:registerEvent()
	GlobalEventSystem:addEventListener(WinnerEvent.WINNER_OPEN_REWARD,handler(self,self.setViewInfo))
end

function WinnerReward:unregisterEvent()
	GlobalEventSystem:removeEventListener(WinnerEvent.WINNER_OPEN_REWARD)
end


function WinnerReward:setViewInfo(data)
	--设置自己排名和伤害
	if data then 
		self.rankLabel:setString(data.rank)
		--设置奖励信息
		self:createRewardItem(data.rank)
	end
end

function WinnerReward:createRewardItem(rank)

	local data = configHelper:getWinnerRewardByRank(rank)

	for i=1,#data do
		
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = data[i][1],is_bind = data[i][2]})
		commonItem:setCount(data[i][3])
		table.insert(self.itemList,commonItem)
		self.ccui:addChild(commonItem)
		commonItem:setPosition(82*i + 100, 70)
	end
end
--销毁
function WinnerReward:destory()
	self:unregisterEvent()
	for k,v in pairs(self.itemList) do
		v:destory()
	end
	self.itemList = {}
end
 
return WinnerReward