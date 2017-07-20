--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:47:45
--
--
local ExchangeReceiveView = ExchangeReceiveView or class("ExchangeReceiveView", BaseView)

function ExchangeReceiveView:ctor(winTag,data,winconfig)
	self.ccui = cc.uiloader:load("resui/exchangeGetWin.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
   	self:setNodeEventEnabled(true)
end

function ExchangeReceiveView:init()

	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.getAllBtn = cc.uiloader:seekNodeByName(self.ccui, "getAllBtn")
	self.getBtn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
	self.bg = cc.uiloader:seekNodeByName(self.ccui, "layerBg")

	self.amountLabel:setString("")
	--[[
	self.listView = SCUIList.new {
        viewRect = cc.rect(0,0,self.bg:getContentSize().width - 4, self.bg:getContentSize().height - 10),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.bg):pos(1, 5)
	--]]

    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0,0,self.bg:getContentSize().width - 4, self.bg:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.bg:getContentSize().width - 4, self.bg:getContentSize().height - 10))
            --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(1, 5)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/exchangeGetItem.ExportJson", "app.modules.exChange.view.ExchangeReceiveItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    self.listView:onTouch(handler(self, self.touchListener))
    self.bg:addChild(self.listView)

	self.helpBtn:setTouchEnabled(true)
	self.getAllBtn:setTouchEnabled(true)
	self.getBtn:setTouchEnabled(true)

	--self.itemList = {}
	self.count = 0
 
	self.getAllBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.getAllBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.getAllBtn:setScale(1.0)
	          	
	          	if self.count > 0 then
	          		self.allGet = true
	          		GameNet:sendMsgToSocket(33010,{id = 0})
	          	else
	          		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有物品可以领取")
	          	end
		   
	        end     
	        return true
    end)

    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.getBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.getBtn:setScale(1.0)

	            if not self.lastClickItem then
	            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请选择物品")
	            	return
	            end
	 
	            self.allGet = false
 
		        GameNet:sendMsgToSocket(33010,{id = self.lastClickItem:getData().id})
	            
	        end     
	        return true
    end)

    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.helpBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.helpBtn:setScale(1.0)
	             local function enterFun()
 
					end
	            
					GlobalMessage:alert({
						enterTxt = "确定",
						backTxt= "取消",
						tipTxt = configHelper:getRuleByKey(7),
						enterFun = handler(self, enterFun),
						tipShowMid = true,
						hideBackBtn = true,
					})
	        end     
	        return true
    end)
   

end

function ExchangeReceiveView:touchListener(event)
	local listView = event.listView

    if "clicked" == event.name then

    	local item = event.item:getChildByTag(11)

    	if item ~= self.lastClickItem then
    		if  self.lastClickItem then
    			self.lastClickItem:setSelect(false)
    		end
    		
    		self.currentPos = event.itemPos
        	self.lastClickItem = item
	 		item:setSelect(true)
	 		
    	end
 	
    elseif "moved" == event.name then
 
    elseif "ended" == event.name then
  
    end
end

function ExchangeReceiveView:initViewInfo()
	self:open()
	GameNet:sendMsgToSocket(33003)
end

function ExchangeReceiveView:setListData(data)
	if data == nil then
		return
	end

	self.currentPos = 0
	self.lastClickItem = nil
 
	data = data.data
	self.rankListAdapter:setData(data)
	self.amountLabel:setString(#data)
	self.count = #data

	--[[

	for i=1,#self.itemList do
		self.listView:removeItem(self.itemList[i]:getParent())
	end

	self.itemList = {}
	self.currentPos = 0
	self.lastClickItem = nil

	data = data.data
 	for i=1,#data do
 
		local item = self.listView:newItem()
		local content = require("app.modules.exChange.view.ExchangeReceiveItem").new()
		content:setData(data[i])
		item:addContent(content)
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
	    self.itemList[#self.itemList + 1] = content
		self.listView:addItem(item)

	end
 
	self.listView:reload()
	self.amountLabel:setString(#self.itemList)
	--]]
end

function ExchangeReceiveView:handlerReceiveFee(data)

	if data == nil then
		return 
	end

	if data.data.result == 0 then
		
		if self.allGet then
			GameNet:sendMsgToSocket(33007,{id = 0})

		elseif self.lastClickItem then
			GameNet:sendMsgToSocket(33007,{id = self.lastClickItem:getData().id })
		end

		return
	end

	local function enterFun()

		if self.allGet then
			GameNet:sendMsgToSocket(33007,{id = 0})

		elseif self.lastClickItem then
			GameNet:sendMsgToSocket(33007,{id = self.lastClickItem:getData().id })
		end

	end
	               
	local tipTxt = "领取过期物品需要支付"..data.data.result.."金币作为手续费，确认领取吗？"
		           
	GlobalMessage:alert({
		enterTxt = "确定",
		backTxt= "取消",
		tipTxt = tipTxt,
		enterFun = handler(self, enterFun),
		tipShowMid = true,
	})

end
 
function ExchangeReceiveView:receiveSuccess(data)

	if self.allGet then
		--[[
		for i=1,#self.itemList do
			self.listView:removeItem(self.itemList[i]:getParent())
		end
		self.itemList = {}
		--]]
		self.currentPos = 0
		self.lastClickItem = nil
 		self.rankListAdapter:clearData()
		self.listView:removeAllItems()
		self.amountLabel:setString(self.count)
	else
 
		if self.currentPos > 0 then
			--table.remove(self.itemList,self.currentPos)
			--self.listView:removeItem( self.lastClickItem:getParent() )
			self.lastClickItem:setSelect(false)
			self.rankListAdapter:removeData(self.currentPos)
			self.rankListAdapter:syncData(true)

			self.currentPos = 0
			self.lastClickItem = nil
			self.count = self.count - 1
		end
		--self.listView:reload()
		self.amountLabel:setString(self.count)
	end
end

function ExchangeReceiveView:open()
	GlobalEventSystem:addEventListener(ExChangeEvent.RECEIVEVIEW_INFO,handler(self,self.setListData))
	GlobalEventSystem:addEventListener(ExChangeEvent.RECEIVE_FEE,handler(self,self.handlerReceiveFee))
	GlobalEventSystem:addEventListener(ExChangeEvent.RECEIVEVIEW_RECEIVE_SUCCESS,handler(self,self.receiveSuccess))
end

function ExchangeReceiveView:close()
	GlobalEventSystem:removeEventListener(ExChangeEvent.RECEIVEVIEW_INFO)
	GlobalEventSystem:removeEventListener(ExChangeEvent.RECEIVEVIEW_RECEIVE_SUCCESS)
	GlobalEventSystem:removeEventListener(ExChangeEvent.RECEIVE_FEE)
	--[[
	for i=1,#self.itemList do
		self.listView:removeItem(self.itemList[i]:getParent())
	end
	self.itemList = {}
	--]]
	self.currentPos = 0
	self.lastClickItem = nil
 
end

function ExchangeReceiveView:destory()
	self:close()
	self.super.destory(self)
end

return ExchangeReceiveView
--]]