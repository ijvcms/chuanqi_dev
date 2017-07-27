--
-- Author: Yi hanneng
-- Date: 2016-04-16 15:25:20
--
local OpenServeActivityView = OpenServeActivityView or class("OpenServeActivityView", BaseView)

function OpenServeActivityView:ctor(winTag, data, winconfig)
	OpenServeActivityView.super.ctor(self, winTag, data, winconfig)
	self:init()
end

function OpenServeActivityView:init()

-------------------
--tab
    self.tabList = {}
    self.lastClickTab = nil
    self.tabIndex = 0
    self.tabList[1] = self:seekNodeByName("topBtn1")
    self.tabList[2] = self:seekNodeByName("topBtn2") 

    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_UI,self.tabList[1],self.tabList[1]:getContentSize().width - 8,self.tabList[1]:getContentSize().height - 8)
    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_UI_RANK,self.tabList[2],self.tabList[2]:getContentSize().width - 8,self.tabList[2]:getContentSize().height - 8)   

    self.advTextImg = self:seekNodeByName("advTextImg")
  	self.timeLabel = self:seekNodeByName("timeLabel")
  	self.rightLayer = self:seekNodeByName("rightLayer")
  	self.closeBtn = self:seekNodeByName("btnClose")
  	self.titlePanel = self:seekNodeByName("titlePanel")
  	self.leftLayer = self:seekNodeByName("leftLayer")

    for i=1,#self.tabList do
      self.tabList[i]:setTouchEnabled(true)
      self.tabList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              SoundManager:playClickSound()
          elseif event.name == "ended" then
              self:clickTab(i)
          end
          return true
      end)
    end
------------
  	self.btnList = {}
    self.btnMap = {}
  	self.menuConfig = {}
    self.configList = {}
   
  local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 6))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(5,4)
  
    self.rankListAdapter2 = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/serveExpItem.ExportJson", "app.modules.activity.view.OpenServeExpItem", 6, handler(self, self.onClickItem))
    self.listView:setAdapter(self.rankListAdapter2)
    self.rightLayer:addChild(self.listView)


  local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.leftLayer:getContentSize().width - 10 , self.leftLayer:getContentSize().height - 10)}
    self.llistView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.llistView:setContentSize(cc.rect(0,0,self.leftLayer:getContentSize().width - 10 , self.leftLayer:getContentSize().height - 10))
    self.llistView:onTouch(handler(self, self.touchListener))
    self.llistView:setPosition(12,5)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.activity.view.OpenServeActivityMenuItem", 6, handler(self, self.onClickItem))
    self.llistView:setAdapter(self.rankListAdapter)
    self.leftLayer:addChild(self.llistView)

end

function OpenServeActivityView:clickTab(index)

  if self.tabIndex == index then
    return
  end

  self.tabIndex = index

  if self.lastClickTab ~= nil then
    self.lastClickTab:setSpriteFrame("com_labBtn4.png")
  end

  self.lastClickTab = self.tabList[index]
  self.lastClickTab:setSpriteFrame("com_labBtn4Sel.png")

  if self.menuConfig and self.menuConfig[index] then
    self:buildMenu(self.menuConfig[index])
  else
    if self.lastView ~= nil then
      self.lastView:setVisible(false)
    end
    self.currentIndex = 0
    self.rankListAdapter:clearData()
  end
  
  GameNet:sendMsgToSocket(32043,{list_id = index})

end

function OpenServeActivityView:handleMenuData(data)
    if data == nil then
      return 
    end
    data = data.data
    -- data.type_info_list = {

    -- }
    -- for i=1,15 do
    --   table.insert(data.type_info_list,{type_id=i,state = 1})
    -- end
    for i=1,#data.type_info_list do
      local config = configHelper:getServiceActivityTypeConfig(data.type_info_list[i].type_id)
      
      if config ~= nil then
        if self.menuConfig[config.list_id] == nil then
            self.menuConfig[config.list_id] = {}
        end
        config.state = data.type_info_list[i].state
        table.insert(self.menuConfig[config.list_id], config)
      end
      self.configList[data.type_info_list[i].type_id] = configHelper:getServiceActivityConfig(data.type_info_list[i].type_id)
    end
    --排序
    for i=1,#self.menuConfig do
      if #self.menuConfig[i] > 1 then
         table.sort(self.menuConfig[i],function(a,b) return a.sort < b.sort end)
      end
    end
    ---------------------
    self:clickTab(1)
end

function OpenServeActivityView:buildMenu(data)

  if data == nil then
    return 
  end
 
  self.rankListAdapter:setData(data)
  local firstItem = self.llistView:getFirstItem()
  
  if firstItem then
    local item = firstItem:getChildByTag(11)

      if item ~= self.lastClick then
        if  self.lastClick then
          self.lastClick:setSpriteFrame("com_labBtn4.png")
        end
        self.lastClick = item
        self.lastClick:setSpriteFrame("com_labBtn4Sel.png")
      end
      self:onClick(self.lastClick:getData())
  end
 
end

function OpenServeActivityView:touchListener(event)

    local listView = event.listView
    if "clicked" == event.name then

      local item = event.item:getChildByTag(11)

      if item ~= self.lastClick then
        
        if  self.lastClick then
          self.lastClick:setSpriteFrame("com_labBtn4.png")
        end
          
        self.lastClick = item
        self.lastClick:setSpriteFrame("com_labBtn4Sel.png")

        self:onClick(self.lastClick:getData())
      
      end
 
   
    end
end
 
function OpenServeActivityView:onClick(data)
  --self.btnList[index]:setSpriteFrame("serveActivity_btnSelected.png")
  --self.lastClick = self.btnList[index]
  if self.currentIndex == data.id then
    return
  end
  
  self.currentIndex = data.id

  self:handleView()
 
	--self.advLabel:setString(self.menuConfig[index].name)
	GlobalController.activity:requestActivityService(self.currentIndex)


end

function OpenServeActivityView:handleView()
 
  local config = configHelper:getServiceActivityTypeConfig(self.currentIndex)
  if config.title_img ~= "" then
    self.advTextImg:setSpriteFrame(config.title_img)
  end
  
  self.timeLabel:setString("")
  self.titlePanel:setVisible(true)

  if self.lastView ~= nil then
      self.lastView:setVisible(false)
      if self.lastView ~= self.listView then
        self.lastView:close()
      end
  end

  if self.currentIndex == 7 then

    if self.RechargeGiftView == nil then
        self.RechargeGiftView = require("app.modules.activity.view.RechargeGiftView").new():addTo(self.rightLayer)
    end

    self.RechargeGiftView:open()
    self.lastView = self.RechargeGiftView
    self.lastView:setVisible(true)
    
  elseif self.currentIndex == 8 then

    if self.OpenServeAngPaoView == nil then
      self.OpenServeAngPaoView = require("app.modules.activity.view.OpenServeAngPaoView").new():addTo(self.rightLayer)
      self.OpenServeAngPaoView:setPosition(-6, -6)
    end

    self.OpenServeAngPaoView:open()
    self.lastView = self.OpenServeAngPaoView
    self.lastView:setVisible(true)
    self.titlePanel:setVisible(false)

  elseif self.currentIndex == 9 then
 
    if self.OpenServeBossView == nil then
      self.OpenServeBossView = require("app.modules.activity.view.OpenServeBossView").new():addTo(self.rightLayer)
      self.OpenServeBossView:setPosition(-6, -6)
    end

    self.OpenServeBossView:open()
    self.lastView = self.OpenServeBossView
    self.lastView:setVisible(true)
    self.titlePanel:setVisible(false)

  elseif self.currentIndex == 2 or self.currentIndex == 5 then
    
    if self.OpenServeShopView == nil then
      self.OpenServeShopView = require("app.modules.activity.view.OpenServeShopWin").new(self.rightLayer:getContentSize().width,self.rightLayer:getContentSize().height):addTo(self.rightLayer)
      self.OpenServeShopView:setPosition(0, 2)
    end

    self.OpenServeShopView:open()
    self.lastView = self.OpenServeShopView
    self.lastView:setVisible(true)
    
  elseif self.currentIndex == 4 or self.currentIndex == 6 then
    
   if self.OpenServeSMShopView == nil then
      self.OpenServeSMShopView = require("app.modules.activity.view.OpenServeSMShopWin").new():addTo(self.rightLayer)
      self.OpenServeSMShopView:setPosition(-6, -6)
    end

    self.OpenServeSMShopView:open()
    self.lastView = self.OpenServeSMShopView
    self.lastView:setVisible(true)
    self.titlePanel:setVisible(false)

  elseif self.currentIndex == 3 then
  
    self.listView:removeAllItems()
    self.listView:onCleanup()
    self.rankListAdapter2:setFile("resui/serveShopItem.ExportJson")
    self.rankListAdapter2:setItemClass("app.modules.activity.view.OpenServeSMShopItem")
    self.lastView = self.listView
    self.lastView:setVisible(true)
  elseif self.currentIndex >= 10 and self.currentIndex <= 15 then
    
    if self.OpenRankView == nil then
      self.OpenRankView = require("app.modules.activity.view.OpenServeRankWin").new():addTo(self.rightLayer)
      self.OpenRankView:setPosition(-6, -6)
    end

    self.OpenRankView:open()
    self.lastView = self.OpenRankView
    self.lastView:setTitle(configHelper:getServiceActivityTypeConfig(self.currentIndex))
    self.lastView:setVisible(true)
    self.titlePanel:setVisible(false)

  else
    self.listView:removeAllItems()
    self.listView:onCleanup()
    self.rankListAdapter2:setFile("resui/serveExpItem.ExportJson")
    self.rankListAdapter2:setItemClass("app.modules.activity.view.OpenServeExpItem")
    self.lastView = self.listView
    self.lastView:setVisible(true)
  end

end

function OpenServeActivityView:setData(data)

 
 	data = data.data
 	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
 
	local config = self.configList[self.currentIndex]

 	if self.currentIndex == 7 then
 
    data = data.active_service_list
		local info = config[data[1].active_service_id]
		if info then
			info.num = data[1].num
			info.is_receive = data[1].is_receive
		end
 
		self.lastView:setViewInfo(info)
 
	elseif self.currentIndex == 8 then
 
		self.lastView:setViewInfo(data)
 
  elseif self.currentIndex == 9 then
 
    self.lastView:setViewInfo(data,config)

  elseif self.currentIndex == 2 or self.currentIndex == 5 then

    self.lastView:setViewInfo(data)

  elseif self.currentIndex == 4 or self.currentIndex == 6 then
    
    self.lastView:setViewInfo(data,config)
 
  elseif self.currentIndex >= 10 and self.currentIndex <= 15 then
 
    self.lastView:setViewInfo(data,config)

	else

    data = data.active_service_list
    
    local list = {}
    for i=1,#data do
         
      local info = config[data[i].active_service_id]
      if info then
        info.num = data[i].num
        info.is_receive = data[i].is_receive
      end
      table.insert(list, info)
    end
    
    if #list > 1 then
      table.sort(list,function(a,b) return a.value < b.value end)
    end

    self.rankListAdapter2:setData(list)

	end

end

function OpenServeActivityView:onClickItem(item)

	if item == nil then
		return 
	end
	self.selectItem = item
  if item:getData() then
    GlobalController.activity:requestActivityServiceReward(item:getData().id)
  end
	
end

function OpenServeActivityView:setSelectItem()
	if self.selectItem then
		self.selectItem:setTouchEnabled(false)
	end
	if self.RechargeGiftView and self.RechargeGiftView:isVisible() then
		self.RechargeGiftView:setViewButtonEnable(false)
	end
  --self.selectItem = nil
end

function OpenServeActivityView:open()
  GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_LIST,handler(self,self.handleMenuData))
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO,handler(self,self.setData))
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD,handler(self,self.setSelectItem))
  GlobalController.activity:requestActivityServiceList()
end

function OpenServeActivityView:close()
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_LIST)
  GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_INFO)
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD)
end

function OpenServeActivityView:destory()

  if self.OpenServeBossView then
    self.OpenServeBossView:destory();
    self.OpenServeBossView = nil
  end

  if self.OpenRankView then
    self.OpenRankView:destory();
    self.OpenRankView = nil
  end

  if self.OpenServeAngPaoView then
    self.OpenServeAngPaoView:destory();
    self.OpenServeAngPaoView = nil
  end

  if self.RechargeGiftView then
    self.RechargeGiftView:destory();
    self.RechargeGiftView = nil
  end
 
  if self.OpenServeSMShopView then
    self.OpenServeSMShopView:destory();
    self.OpenServeSMShopView = nil
  end

  if self.OpenServeShopView then
    self.OpenServeShopView:destory();
    self.OpenServeShopView = nil
  end

	self:close()
	OpenServeActivityView.super.destory(self)
end
 
return OpenServeActivityView