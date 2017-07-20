--
-- Author: Yi hanneng
-- Date: 2016-09-23 10:33:46
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local OneTimesView = OneTimesView or class("OneTimesView", BaseView)

function OneTimesView:ctor(winTag, data, winconfig)
	
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

	OneTimesView.super.ctor(self, winTag, data, winconfig)
	self.data = data
	local root = self:getRoot()
	root:setPosition((display.width-960)/2,(display.height-640)/2)
	--self:creatPillar()

	self:init()
end

function OneTimesView:init()

 
	self.currentMenu = nil
	self.btnList = {}
	self.dataList = {}
	self.currentData = nil
	self.currerntItem = nil

	self.time = {}
 
  	self.timeLabel = self:seekNodeByName("timeLabel")
  	self.helpBtn = self:seekNodeByName("helpBtn")
  	self.closeBtn = self:seekNodeByName("closeBtn")
   	self.leftLayer = self:seekNodeByName("leftLayer")

   	self.itemLayer1 = self:seekNodeByName("itemLayer1")
   	self.itemLayer2 = self:seekNodeByName("itemLayer2")
   	self.itemLayer3 = self:seekNodeByName("itemLayer3")

   	for i=1,3 do
   		local btn = self:seekNodeByName("buyBtn"..i)
   		btn:setTouchEnabled(true)
	    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btn:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            self.currerntItem = btn
	            GlobalController.onetimes:requestBuyOnetimes(self.currentData.lv, i)
	        end
	        return true
	    end)
   	end
 
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)


    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(27),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end
        return true
    end)


    self.llistView = SCUIList.new {
        viewRect = cc.rect(0,0,self.leftLayer:getContentSize().width, self.leftLayer:getContentSize().height - 10),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.leftLayer):pos(0, 5)


    local roleManager = RoleManager:getInstance()
   	self.roleInfo = roleManager.roleInfo

    self:buildMenu()
end

function OneTimesView:buildMenu()
 
 	local config = configHelper:getShopOneList()
 	
 	local index = 1
 	local find = false
 	local findIndex = 1
	for i=1,#config do

	  	if self.dataList[config[i].lv] == nil then
 
	    	self.dataList[config[i].lv] = {}
	    	
	    	local item = self.llistView:newItem()
		    local content = require("app.modules.oneTimes.OneTimesMenuItem").new()
		    content:setData(config[i])
		    self.btnList[index] = content
		    item:addContent(content)
		    item:setItemSize(content:getContentSize().width, content:getContentSize().height + 2)
		    self.llistView:addItem(item)
		    
		    if config[i].lv > self.roleInfo.lv and find == false then
		    	find = true
		    	findIndex = index - 1
		    end

		    index = index + 1
	    end

	    table.insert(self.dataList[config[i].lv], config[i])
 
	end

    
    self.llistView:reload()

  --默认打开第一个
  if findIndex == 0 then
  	findIndex = 1
  end

  if find == false and config[#config].lv <= self.roleInfo.lv then
  	find = true
  	findIndex = #self.btnList
  end
 
  if #self.btnList > 0 then	
    self:handleMenuClick(findIndex)
    if findIndex > 7 then
    	self.llistView:scrollTo(0,self.btnList[findIndex]:getParent():getPositionY())
    end
  end
  

end

function OneTimesView:touchListener(event)

    local listView = event.listView
    if "clicked" == event.name then
        local item = event.item:getChildByTag(11)
 		
 		if self.currentMenu ~= item then
 			if item:getData().lv > self.roleInfo.lv then
 				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"达到等级才能查看")
 				return
 			end
 			self:handleMenuClick(event.itemPos)
 		end
 
    end
end

function OneTimesView:handleMenuClick(index)

	if self.currentMenu then
		self.currentMenu:setSelect(false)
	end

	self.btnList[index]:setSelect(true)
  	self.currentMenu = self.btnList[index]
 	
 	self.currentData = self.currentMenu:getData()

	--self:setView(self.currentData.lv)
	----------
	--获取数据
	self:request(self.currentData.lv)
end

function OneTimesView:setView(data)

	if data == nil or data.data == nil then
		return	
	end

	data = data.data

	local info = self.dataList[self.currentData.lv]

	if info then
		for i=1,#info do
			self:createItem(info[i],i,data.state_list[i])
		end
	end
 
	self.endTime = data.expire_time

	self:startTimer()
	
end

function OneTimesView:request(type)
  
	GlobalController.onetimes:requestOnetimesInfo(type)
end

function OneTimesView:onTimerHandler()
	 
	self.endTime = self.endTime - 1
	if self.endTime <= 0 then
		self.endTime = 0
		self:clearTimer()
	end
	self.timeLabel:setString(string.format("%s", StringUtil.convertTime(self.endTime)))
end

function OneTimesView:startTimer()
	self:clearTimer()
 
	if self.endTime > 0 then
		self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
		self:onTimerHandler()
 
	end
end	

function OneTimesView:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end
 
function OneTimesView:open()
	
	GlobalEventSystem:addEventListener(OneTimesEvent.ONETIMES_INFO_LIST,handler(self,self.setView))
	GlobalEventSystem:addEventListener(OneTimesEvent.GET_ONETIMES_REWARDS,function() self.currerntItem:setButtonLabelString("已购买") self.currerntItem:setButtonEnabled(false) end)
	--GlobalController.holiday:requestActivityInfo()
end

function OneTimesView:close()
	GlobalEventSystem:removeEventListener(OneTimesEvent.ONETIMES_INFO_LIST)
	GlobalEventSystem:removeEventListener(OneTimesEvent.GET_ONETIMES_REWARDS)
	self:clearTimer()
end
 
 function OneTimesView:destory()
 	self:close()
 	self.super.destory(self)
 end

function OneTimesView:createItem(info,index,data)

	self["itemLayer"..index]:setVisible(true)
	
	self:seekNodeByName("name"..index):setString(configHelper:getGoodNameByGoodId(info.goods_id))
	self:seekNodeByName("priceOld"..index):setString(info.price_old)
	self:seekNodeByName("priceNow"..index):setString(info.price_now)

	if info.conner_icon and info.conner_icon ~= "" then
		self:seekNodeByName("connorIcon"..index):setVisible(true)
		--self:seekNodeByName("connorIcon"..index):setSpriteFrame(info.conner_icon)
	else
		self:seekNodeByName("connorIcon"..index):setVisible(false)
	end
	
	local btn = self:seekNodeByName("buyBtn"..index)
 
	local quality = configHelper:getGoodQualityByGoodId(info.goods_id)
		    if quality then
		        local color
		        if quality == 1 then            --白
		            color = TextColor.TEXT_W
		        elseif quality == 2 then        --绿
		            color = TextColor.TEXT_G
		        elseif quality == 3 then        --蓝
		            color = TextColor.ITEM_B
		        elseif quality == 4 then        --紫
		            color = TextColor.ITEM_P
		        elseif quality == 5 then        --橙
		            color = TextColor.TEXT_O
		        elseif quality == 6 then        --红
		            color = TextColor.TEXT_R
		        end 
		        if color then
		            self:seekNodeByName("name"..index):setTextColor(color)
		        end
		    end

	local commonItem

 	if self["commonItem"..index] == nil then
 		commonItem = CommonItemCell.new()
 		self["commonItem"..index] = commonItem
 		self:seekNodeByName("itemIcon"..index):addChild(commonItem)
		--commonItem:setScale(0.8)
	else
		commonItem = self["commonItem"..index]
 	end
 
	commonItem:setData(info)
	commonItem:setCount(info.num)
	commonItem:setPosition(self:seekNodeByName("itemIcon"..index):getContentSize().width/2, self:seekNodeByName("itemIcon"..index):getContentSize().height/2)
	
	if data.state == 0 then
		btn:setButtonLabelString("购买")
	 	btn:setButtonEnabled(true)
	elseif data.state == 1 then
		btn:setButtonLabelString("已购买")
		btn:setButtonEnabled(false)
	elseif data.state == 2 then
		btn:setButtonLabelString("已过期")
		btn:setButtonEnabled(false)
	end 
	

end 

return OneTimesView