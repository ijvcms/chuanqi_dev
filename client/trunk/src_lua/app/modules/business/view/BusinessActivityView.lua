--
-- Author: Yi hanneng
-- Date: 2016-06-29 10:41:10
--

--[[
---------------运营活动---------------
--]]

local JingcaiBuyWin = import(".JingcaiBuyWin")
local JingcaiAnnounceWin = import(".JingcaiAnnounceWin")
local JingcaiCommonWin = import(".JingcaiCommonWin")
local JingcaiCountWin = import(".JingcaiCountWin")
 
local BusinessActivityLayer = import(".BusinessActivityLayer")
local  BusinessActivityView = BusinessActivityView or class("BusinessActivityView", BaseView)

function BusinessActivityView:ctor(winTag, data, winconfig)
	BusinessActivityView.super.ctor(self, winTag, data, winconfig)
	--jingcaihuodongWin
	local root = self:getRoot()
	root:setPosition((display.width-960)/2,(display.height-640)/2)
 
	self:init()
end

function BusinessActivityView:init()
 
  	self.mainLayer = self:seekNodeByName("mainLayer")
  	self.closeBtn = self:seekNodeByName("closeBtn")
  	self.leftLayer = self:seekNodeByName("leftLayer")

  	self.btnList = {}
  	self.menuConfig = {}
    self.configList = {}

    self.currentLayer = nil
    self.currentData = nil
    self.currentIndex = nil

    self.layerMap = {}

  	self.llistView = SCUIList.new {
        viewRect = cc.rect(0,0,self.leftLayer:getContentSize().width, self.leftLayer:getContentSize().height - 10),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.leftLayer):pos(0, 5)

  	self.closeBtn:setTouchEnabled(true)
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
 
end

function BusinessActivityView:buildMenu(data)
 
  if data == nil then
    return 
  end
  
  data = data.data
 
  for i=1,#data.list2 do
    local item = self.llistView:newItem()
    local content = self:createItem(data.list2[i],data.list2[i].is_count_down == 1)
    self.btnList[#self.btnList + 1] = content
    item:addContent(content)
    item:setItemSize(content:getContentSize().width, content:getContentSize().height + 10)
    self.llistView:addItem(item)
    self.configList[#self.configList + 1] = data.list2[i]
  end


  for i=1,#data.list3 do
    local item = self.llistView:newItem()
    local content = self:createItem(data.list3[i],data.list3[i].is_count_down == 1)
    self.btnList[#self.btnList + 1] = content
    item:addContent(content)
    item:setItemSize(content:getContentSize().width, content:getContentSize().height + 10)
    self.llistView:addItem(item)
    self.configList[#self.configList + 1] = data.list3[i]
  end


  for i=1,#data.list do
    local item = self.llistView:newItem()
    local content = self:createItem(data.list[i],false)
    self.btnList[#self.btnList + 1] = content
    item:addContent(content)
    item:setItemSize(content:getContentSize().width, content:getContentSize().height + 10)
    self.llistView:addItem(item)
    self.configList[#self.configList + 1] = data.list[i]
  end
  
  self.llistView:reload()
  --默认打开第一个
  self:onClick(1)
	
end

function BusinessActivityView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item =self.btnList[event.itemPos]
 
       		if self.lastClick ~= nil and self.lastClick ~= item then
            	self.lastClick:setSpriteFrame("jchd_btn.png")
              self:onClick(event.itemPos)
          end
 
    end
end


function BusinessActivityView:onClick(index)
  if self.btnList[index] == nil then
    return 
  end
	self.btnList[index]:setSpriteFrame("jchd_btnSelect.png")
	self.lastClick = self.btnList[index]
  self.currentIndex = index
	self.currentData = self.configList[index]
  self:setView(self.currentData.model,index)
end

function BusinessActivityView:setView(type,index)
  
  if self.currentLayer ~= nil then
    self.currentLayer:setVisible(false)
    self.currentLayer:close()
  end

  if type == 0 then
    if self.layerMap[index] == nil then
      self.layerMap[index] = JingcaiCommonWin.new()
      self.layerMap[index]:setViewInfo(self.currentData)
      self.mainLayer:addChild(self.layerMap[index])
    end

    self.currentLayer = self.layerMap[index]

  elseif type == 1 then
    if self.layerMap[index] == nil then
      self.layerMap[index] = JingcaiCountWin.new()
      self.layerMap[index]:setViewInfo(self.currentData)
      self.mainLayer:addChild(self.layerMap[index])
    end

    self.currentLayer = self.layerMap[index]
  elseif type == 2 then
    if self.layerMap[index] == nil then
      self.layerMap[index] = JingcaiBuyWin.new()
      self.layerMap[index]:setViewInfo(self.currentData)
      self.mainLayer:addChild(self.layerMap[index])
    end

    self.currentLayer = self.layerMap[index]
  elseif type == 3 then
    if self.layerMap[index] == nil then
      self.layerMap[index] = JingcaiAnnounceWin.new()
      self.layerMap[index]:setViewInfo(self.currentData)
      self.mainLayer:addChild(self.layerMap[index])
    end

    self.currentLayer = self.layerMap[index]
  end

  if self.currentLayer then
    self.currentLayer:setVisible(true)
    self.currentLayer:open()
  end

end
 

function BusinessActivityView:setSelectItem(data)
 
  if self.showLayer then
	   self.showLayer:setButtonEnabled(data.data.state == 1)
     if self.menuConfig[self.currentIndex] then
       self.menuConfig[self.currentIndex].state = data.data.state
     end
  end
end

function BusinessActivityView:open()
	GlobalEventSystem:addEventListener(BusinessEvent.BUSINESS_INFO_LIST,handler(self,self.buildMenu))
	GlobalEventSystem:addEventListener(BusinessEvent.RCV_BUSINESS_REWARD,handler(self,self.setSelectItem))
	GlobalController.business:requestBusinessInfo()
end

function BusinessActivityView:close()
	GlobalEventSystem:removeEventListener(BusinessEvent.BUSINESS_INFO_LIST)
	GlobalEventSystem:removeEventListener(BusinessEvent.RCV_BUSINESS_REWARD)
end

function BusinessActivityView:destory()
  if self.isDestory then return end
 	if self.showLayer then
 		self.showLayer:destory()
 		self.showLayer = nil
 	end
	self:close()
	BusinessActivityView.super.destory(self)
end

--创建左侧按钮
function BusinessActivityView:createItem(data,hasTime)
	 
	local bg = display.newSprite("#jchd_btn.png")
	local txt = display.newTTFLabel({
    text = data.title,
    font = "Arial",
    size = 24,
    color = cc.c3b(255,235,62), -- 使用纯红色
    align = cc.TEXT_ALIGNMENT_LEFT,
    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    
	})

  bg:addChild(txt)
  txt:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2 + 14)

  if hasTime then
 
    local time = data.end_time - data.cur_time
    local timeStr = ""
   
    if time > 24*60*60 then
      timeStr = math.floor(time/(24*60*60)).."天后截止"
    elseif time > 60*60 then
      timeStr = math.floor(time/(60*60)).."小时后截止"
    elseif time > 60  then
      timeStr = math.floor(time/60).."分钟后截止"
    end

    local txt2 = display.newTTFLabel({
      text = timeStr,
      font = "Arial",
      size = 18,
      color = cc.c3b(231,211,173), -- 使用纯红色
      align = cc.TEXT_ALIGNMENT_LEFT,
      valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
      
    })
    bg:addChild(txt2)
    txt2:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2 - 14)
  end
 
	if data.mark ~= 0 then
		local sp = display.newSprite("#jingcai_signl"..data.mark..".png")
		bg:addChild(sp)
		sp:setPosition(sp:getContentSize().width/2, bg:getContentSize().height - sp:getContentSize().height/2)
	end
	return bg
end 

return BusinessActivityView