--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:47:15
--

--[[]]
local ExchangeStorageRackView = ExchangeStorageRackView or class("ExchangeStorageRackView", BaseView)

function ExchangeStorageRackView:ctor(winTag,data,winconfig)
	self.ccui = cc.uiloader:load("resui/exchangeShelfWin.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function ExchangeStorageRackView:init()

	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.offBtn = cc.uiloader:seekNodeByName(self.ccui, "offBtn")
	self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")

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

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/exchangeShelfItem.ExportJson", "app.modules.exChange.view.ExchangeStorageItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    self.listView:onTouch(handler(self, self.touchListener))
    self.bg:addChild(self.listView)
 
	self.helpBtn:setTouchEnabled(true)
	self.offBtn:setTouchEnabled(true)

	--self.itemList = {}
	self.lastClickItem = nil
	 
	self.currentPos = 0
	self.count = 0

	self.offBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.offBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.offBtn:setScale(1.0)
	           
	            if self.lastClickItem then
	            	GameNet:sendMsgToSocket(33006,{sale_id = self.lastClickItem:getData().sale_id})
	            else
	            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请选择物品")
	            end
	            --
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
						tipTxt = configHelper:getRuleByKey(6),
						enterFun = handler(self, enterFun),
						tipShowMid = true,
						hideBackBtn = true,
					})
	        end     
	        return true
    end)

    

end

function ExchangeStorageRackView:initViewInfo()
	self:open()
	GameNet:sendMsgToSocket(33002)
end
--设置列表
function ExchangeStorageRackView:setListData(data)

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
		local content = require("app.modules.exChange.view.ExchangeStorageItem").new()
		content:setData(data[i])
		item:addContent(content)
	    item:setItemSize(self.bg:getContentSize().width - 4, content:getContentSize().height)
	    self.itemList[#self.itemList + 1] = content
		self.listView:addItem(item)

	end
 
	self.listView:reload()
	
	self.amountLabel:setString(#self.itemList)
	--]]
end
--下架成功
function ExchangeStorageRackView:downSuccess()

	if self.currentPos > 0 then
		--table.remove(self.itemList,self.currentPos)
		--self.listView:removeItem(self.lastClickItem:getParent())

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

function ExchangeStorageRackView:touchListener(event)
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

function ExchangeStorageRackView:open()
	GlobalEventSystem:addEventListener(ExChangeEvent.STORAGEVIEW_INFO,handler(self,self.setListData))
	GlobalEventSystem:addEventListener(ExChangeEvent.STORAGEVIEW_DOWN_SUCCESS,handler(self,self.downSuccess))
	
end

function ExchangeStorageRackView:close()
	GlobalEventSystem:removeEventListener(ExChangeEvent.STORAGEVIEW_INFO)
	GlobalEventSystem:removeEventListener(ExChangeEvent.STORAGEVIEW_DOWN_SUCCESS)
	--[[
	for i=1,#self.itemList do
		self.listView:removeItem(self.itemList[i]:getParent())
	end
	self.itemList = {}
	--]]
	self.currentPos = 0
	self.lastClickItem = nil
end

return ExchangeStorageRackView

--]]