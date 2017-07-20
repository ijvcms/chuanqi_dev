--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:42:52
--

ExchangeViewTag = {
	BUY = 1,
	SALE = 2,
	STORAGE = 3,
	RECEIVE = 4,
}

local ExchangeView = ExchangeView or class("ExchangeView", BaseView)

function ExchangeView:ctor(winTag,data,winconfig)
	ExchangeView.super.ctor(self,winTag,data,winconfig)
  	self:init()
end

function ExchangeView:init()

	self.tags = {}
	self.layer = {}
	self.currentIndex = 0

	self.value1 = self:seekNodeByName("value1") 
	self.value2 = self:seekNodeByName("value2") 
	self.coin1 = self:seekNodeByName("coin1")
	self.coin2 = self:seekNodeByName("coin2")

	self.mainLay = self:seekNodeByName("mainBg")

  	self.tags[1] = self:seekNodeByName("buyTag")
  	self.tags[2] = self:seekNodeByName("sellTag")
  	self.tags[3] = self:seekNodeByName("shelfTag")
  	self.tags[4] = self:seekNodeByName("getTag")
 	
 	local dd = BaseTipsBtn.new(BtnTipsType.BTN_SALE,self.tags[4],8,62-8)
  	for i=1,#self.tags do
  		self.tags[i]:setTouchEnabled(true)
		self.tags[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "began" then
		            SoundManager:playClickSound()
		        elseif event.name == "ended" then
		            for i=1,#self.tags do
		            	cc.uiloader:seekNodeByName(self.tags[i], "selected"):setVisible(false)
		            end
		            cc.uiloader:seekNodeByName(self.tags[i], "selected"):setVisible(true)
		            self:handlerTagClick(i)
		        end     
		        return true
	    end)
  	end

	self.coin1:setTouchEnabled(true)
	self.coin2:setTouchEnabled(true)

    self.coin1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.coin1:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	        self.coin1:setScale(1.0)
 				GlobalWinManger:openWin(WinName.RECHARGEWIN) 
	        end     
	        return true
    end)

    self.coin2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	             self.coin2:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	        	self.coin2:setScale(1.0)
	 			GlobalWinManger:openWin(WinName.STOREWIN) 
	        end     
	        return true
    end)
 
    self:handlerTagClick(1)
    self:refreshCoin()
end

--标签点击
function ExchangeView:handlerTagClick(index)
 
	if self.currentIndex == index then
		return
	end

	if self.currentIndex ~= 0 then
		self.layer[self.currentIndex]:setVisible(false)
		self.layer[self.currentIndex]:close()

		--self.layer[self.currentIndex]:setTouchEnabled(false)
	end
	self.currentIndex = index
  
	if self.layer[index] then
		self.layer[index]:setVisible(true)

	else
		if index == ExchangeViewTag.BUY then
			self.layer[index] = require("app.modules.exChange.view.ExchangeBuyView").new()
		elseif index == ExchangeViewTag.SALE then   
			self.layer[index] = require("app.modules.exChange.view.ExchangeSaleView").new()
		elseif index == ExchangeViewTag.STORAGE then  
			self.layer[index] = require("app.modules.exChange.view.ExchangeStorageRackView").new()
		elseif index == ExchangeViewTag.RECEIVE then 
			self.layer[index] = require("app.modules.exChange.view.ExchangeReceiveView").new()                
		end

		self.mainLay:addChild(self.layer[index])
		
	end
	--self.layer[self.currentIndex]:setTouchEnabled(true)
	self.layer[index]:initViewInfo()
end

--刷新金币
function ExchangeView:refreshCoin()
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    local wealthInfo = roleManager.wealth
    --金锭(元宝值)
    self:setCoinValue(1, wealthInfo.jade or 0)
    --金币
    self:setCoinValue(2, wealthInfo.coin or 0)
end

--设置金币数
--coinType:金币类型 
--value:金币数
function ExchangeView:setCoinValue(coinType,value)
    local coinLabel
    if coinType == 1 then               --元宝
        coinLabel = self.value1
    elseif coinType == 2 then           --金币
        coinLabel = self.value2
    end
    if coinLabel then
        coinLabel:setString(value)
    end
end

function ExchangeView:open()
	if self.updateWealthEventId == nil then
		self.updateWealthEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,handler(self,self.refreshCoin))
	end
end

function ExchangeView:close()
	if self.updateWealthEventId then
       	GlobalEventSystem:removeEventListenerByHandle(self.updateWealthEventId)
        self.updateWealthEventId = nil
    end
	self.layer = {}
	display.removeSpriteFramesWithFile("resui/exchangeWin0.plist", "resui/exchangeWin0.png")
end

function ExchangeView:destory()
	self:close()
	self.super.destory(self)

end

return ExchangeView