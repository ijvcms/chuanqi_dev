--
-- Author: Yi hanneng
-- Date: 2016-01-11 11:37:13
--
local WorShipView = class("WorShipView", BaseView)
function WorShipView:ctor(winTag,data,winconfig)

	--self:creatPillar()
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  self.bg:setContentSize(display.width, display.height)
  self.bg:setTouchEnabled(true)
  self.bg:setTouchSwallowEnabled(true)
  self:addChild(self.bg)
	WorShipView.super.ctor(self,winTag,data,winconfig)

	self.free_num = 0
	self.jade_num = 0
	self.play_id = 0
 	  self.worshipBtn1 = self:seekNodeByName("btn_free")
  	self.worshipBtn2 = self:seekNodeByName("btn_coin")
  	self.closeBtn = self:seekNodeByName("close")
  	--self.helpBtn = self:seekNodeByName("num1")
  	self.list_1 = self:seekNodeByName("list_1")
  	self.list_2 = self:seekNodeByName("list_2")
  	self.list_3 = self:seekNodeByName("list_3")
  	self.exp_free = self:seekNodeByName("exp_free")
  	self.exp_coin = self:seekNodeByName("exp_coin")
 
  	for i=1,3 do
  		self["list_"..i]:setTouchEnabled(true)
  		self["list_"..i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	 		 if event.name == "began" then
	        elseif event.name == "ended" then
	 			    GameNet:sendMsgToSocket(10011, {player_id = self.data.list[i].player_id})
	        end
        	return true
    	end)

  		self["name"..i] = cc.uiloader:seekNodeByName(self["list_"..i], "name")
  		self["fighting"..i] = cc.uiloader:seekNodeByName(self["list_"..i], "fighting")
  		self["head"..i] = cc.uiloader:seekNodeByName(self["list_"..i], "head")
  		display.newSprite():addTo(self["head"..i], 10, 10):pos(46, 42)
   
  	end
 
 	 
    self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)

 	self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	SoundManager:playClickSound()
        	self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
        	self.closeBtn:setScale(1)
        	GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)

  	self.worshipBtn1:setTouchEnabled(true)
    self.worshipBtn1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	SoundManager:playClickSound()
          self.worshipBtn1:setScale(1.1)
        elseif event.name == "ended" then
          self.worshipBtn1:setScale(1)
        	if self.free_num > 0 then
        		GameNet:sendMsgToSocket(27002,{is_jade = 0})
        	else
        		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您的免费膜拜次数已用完")
        	end
        	
        end
        return true
    end)
 
  	self.worshipBtn2:setTouchEnabled(true)
    self.worshipBtn2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	SoundManager:playClickSound()
          self.worshipBtn2:setScale(1.1)
        elseif event.name == "ended" then
          self.worshipBtn2:setScale(1)
        	if self.jade_num > 0 then
        		local function enterFun()
        			GameNet:sendMsgToSocket(27002,{is_jade = 1})
            	end
 
            	local tipTxt  = "花费30元宝进行膜拜可获得\n"..
							self.worshipInfo.jade_goods[1][3].."点角色经验。\n"..
							"每日仅可进行一次元宝膜拜。" 
          
            	GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipTxt,
	                enterFun = handler(self, enterFun),
	                tipShowMid = true,
            	})

        	else
        		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您的元宝膜拜次数已用完")
        	end

          
        end
        return true
    end)
 
end

function WorShipView:setViewInfo(data)

	self.free_num = data.data.num
	self.jade_num = data.data.jade_num

  if self.free_num <= 0 then
    self.worshipBtn1:setTouchEnabled(false)
    self.worshipBtn1:setButtonEnabled(false)
    cc.uiloader:seekNodeByName(self.worshipBtn1, "Label_43"):setString("已膜拜")
    
  end

  if self.jade_num <= 0 then
    self.worshipBtn2:setTouchEnabled(false)
    self.worshipBtn2:setButtonEnabled(false)
    cc.uiloader:seekNodeByName(self.worshipBtn2, "Label_43"):setString("已膜拜")
  end

end

function WorShipView:updateList(data)

	if data == nil then
		return
	end

	self.data.list = data.data
	data = data.data
	for i=1,#data do
		self["name"..i]:setString(data[i].name)
		self["fighting"..i]:setString(data[i].fight)
		self["head"..i]:getChildByTag(10):setTexture(ResUtil.getRoleHead(data[i].career,data[i].sex))
	end
 
end

function WorShipView:open()
 
	GameNet:sendMsgToSocket(27000)
	GameNet:sendMsgToSocket(27001)
	self.worshipInfo = configHelper:getWorShipInfo(RoleManager:getInstance().roleInfo.lv)
  if self.worshipInfo ~= nil then
    self.exp_free:setString(self.worshipInfo.goods[1][3])
    self.exp_coin:setString(self.worshipInfo.jade_goods[1][3])
  end
  if self.updateEventID == nil then
  	self.updateEventID = GlobalEventSystem:addEventListener(WorShipEvent.WSE_UPDATE_INFO,handler(self,self.updateList))
  end
  if self.WsEventID == nil then
  	self.WsEventID = GlobalEventSystem:addEventListener(WorShipEvent.WSE_INFO,handler(self,self.setViewInfo))
  end

end

function WorShipView:close()
	if self.updateEventID ~= nil then
		GlobalEventSystem:removeEventListenerByHandle(self.updateEventID)
		self.updateEventID = nil
	end
	
	if self.WsEventID ~= nil then
		GlobalEventSystem:removeEventListenerByHandle(self.WsEventID)
		self.WsEventID = nil
	end

end

function WorShipView:destory()
  self:close()
  self.super.destory(self)
end

function WorShipView:checkWorShip(lv)
	local f = configHelper:checkWorShip(lv)
	if f == -1 then
		return true
	elseif f == 0 then
		return false, GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您的等级还不能膜拜")
	elseif f == 1 then
		return false, GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"等级超过可以膜拜等级")
	end
end

return WorShipView