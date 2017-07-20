--
-- Author: Yi hanneng
-- Date: 2016-07-27 19:47:34
--

--[[
---------------------个人boss副本-----------------
--]]
local BossCopyView = BossCopyView or class("BossCopyView", BaseView)

function BossCopyView:ctor(winTag,data,winconfig)
	--self:creatPillar()\
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
	  self.bg:setContentSize(display.width, display.height)
	  self:setTouchEnabled(true)
	  self:setTouchSwallowEnabled(true)
	  self:addChild(self.bg)
	BossCopyView.super.ctor(self,winTag,data,winconfig)
	local root = self:getRoot()
  	root:setPosition((display.width-960)/2,(display.height-640)/2)

  	self:init()

end

function BossCopyView:init()
 
  	self.remainingTime = self:seekNodeByName("remainingTime")
  	 
	self.enterBtn = self:seekNodeByName("enterBtn")
  	self.closeBtn = self:seekNodeByName("closeBtn")
  
	self.closeBtn:setTouchEnabled(true)
	self.enterBtn:setTouchEnabled(true)
	 
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            GlobalWinManger:closeWin(self.winTag)
	        end     
	        return true
    end)

    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.enterBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	        self.enterBtn:setScale(1.0)

	        if  self.activity_id then
	        	dump(self.activity_id)
	      	    GameNet:sendMsgToSocket(32008, {active_id = self.activity_id})
	        end
 				 
	        end     
	        return true
    end)

end

function BossCopyView:setViewInfo(data)
	if data == nil then 
		data = configHelper:getDarkHouseGoods(6)
	end
 
	self.activity_id = data.activity_id
	--self.openTime1:setString(data.open_time1)
	--self.openTime2:setString(data.open_time2)
  
	for i=1,#data.drop_list do
		
	  	local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = data.drop_list[i][1],is_bind = data.drop_list[i][2]})
		commonItem:setCount(data.drop_list[i][3])
		self:seekNodeByName("Item"..i):addChild(commonItem, 10,10)
		commonItem:setPosition(commonItem:getContentSize().width/2 + 1, commonItem:getContentSize().height/2 + 2)
		commonItem:setScale(0.8)
	
  	end

end

function BossCopyView:setTimeInfo(data)
	self.remainingTime:setString(StringUtil.convertTime(data.data.instance_left_time))
end

function BossCopyView:open()
	 
	GlobalEventSystem:addEventListener(CopyEvent.COPY_BOSS_INFO,handler(self,self.setTimeInfo))
	GameNet:sendMsgToSocket(10016)
	self:setViewInfo(nil)
end

function BossCopyView:close()
	GlobalEventSystem:removeEventListener(CopyEvent.COPY_BOSS_INFO)
end

function BossCopyView:destory()
	self:close()
	BossCopyView.super.destory(self)
end

return BossCopyView