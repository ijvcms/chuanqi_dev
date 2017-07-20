--
-- Author: Yi hanneng
-- Date: 2016-03-02 09:26:54
--

--[[
－－－－－－－－－－－－－－未知暗殿－－－－－－－－－－－－－
--]]

local DarkHouseView = DarkHouseView or class("DarkHouseView", BaseView)

function DarkHouseView:ctor(winTag,data,winconfig)
	--self:creatPillar()\
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
	  self.bg:setContentSize(display.width, display.height)
	  self:setTouchEnabled(true)
	  self:setTouchSwallowEnabled(true)
	  self:addChild(self.bg)
	DarkHouseView.super.ctor(self,winTag,data,winconfig)
	local root = self:getRoot()
  	root:setPosition((display.width-960)/2,(display.height-640)/2)

  	self:init()

end

function DarkHouseView:init()
 
  	self.openTime1 = self:seekNodeByName("openTime1")
  	self.openTime2 = self:seekNodeByName("openTime2")
 
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
	      	    GameNet:sendMsgToSocket(32008, {active_id = self.activity_id})
	        end
 				 
	        end     
	        return true
    end)

end

function DarkHouseView:setViewInfo(data)
	if data == nil then
 
		data = configHelper:getDarkHouseGoods(1)
	end

	self.activity_id = data.activity_id
	self.openTime1:setString(data.open_time1)
  	self.openTime2:setString(data.open_time2)
 
	for i=1,#data.drop_list do
		
	  		local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = data.drop_list[i][1],is_bind = data.drop_list[i][2]})
			commonItem:setCount(data.drop_list[i][3])
			self:seekNodeByName("Item"..i):addChild(commonItem, 10,10)
			commonItem:setPosition(self:seekNodeByName("Item"..i):getContentSize().width/2, self:seekNodeByName("Item"..i):getContentSize().height/2)
			commonItem:setScale(0.8)
	
  	end

end

function DarkHouseView:open()
	self:setViewInfo(nil)
end

function DarkHouseView:close()
end

return DarkHouseView