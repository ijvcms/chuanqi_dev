--
-- Author: Yi hanneng
-- Date: 2016-08-17 19:37:05
--
--[[
---------------节日活动----------------------
--]]

local HolidayActivityCompoundWin = import(".HolidayActivityCompoundWin")
local HolidayActivityKillWin = import(".HolidayActivityKillWin")

local HolidayActivityView = HolidayActivityView or class("HolidayActivityView", BaseView)

function HolidayActivityView:ctor(winTag, data, winconfig)
	HolidayActivityView.super.ctor(self, winTag, data, winconfig)
	self.data = data
	local root = self:getRoot()
	root:setPosition((display.width-960)/2,(display.height-640)/2)
	--self:creatPillar()

	self:init()
end

function HolidayActivityView:init()

	self.layerList = {}
	self.currentLayer = nil
	self.currentMenu = nil
	self.menuConfig = {}
	self.btnList = {}
	self.dataList = {}

	self.ruleLabel = self:seekNodeByName("ruleLabel")
  	self.timeLabel = self:seekNodeByName("timeLabel")
  	self.mainLayer = self:seekNodeByName("mainLayer")
  	self.closeBtn = self:seekNodeByName("closeBtn")
   	self.leftLayer = self:seekNodeByName("leftLayer")

   	self.ruleLabel:setVisible(false)
   	self.ruleRich = SuperRichText.new(nil,self.ruleLabel:getContentSize().width)
   	self.ruleRich:setAnchorPoint(0,1)
   	self.ruleLabel:getParent():addChild(self.ruleRich)
   	self.ruleRich:setPosition(self.ruleLabel:getPositionX(), self.ruleLabel:getPositionY() + 10)

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


    self.llistView = SCUIList.new {
        viewRect = cc.rect(0,0,self.leftLayer:getContentSize().width, self.leftLayer:getContentSize().height - 10),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.leftLayer):pos(0, 5)

end

function HolidayActivityView:buildMenu(data)

	if data == nil then
    return 
  	end

  data = data.data
 	 
  for i=1,#data.list do
    local config = configHelper:getHolidayConfigById(data.list[i].type)
    if config ~= nil then
      table.insert(self.menuConfig, config)
    end

    self.dataList[data.list[i].type] = data.list[i]
     
  end
  
  if #self.menuConfig > 1 then
    table.sort(self.menuConfig,function(a,b) return a.active_type < b.active_type end)
  end
  
 
  for i=1,#self.menuConfig do

    local item = self.llistView:newItem()
    local content = self:createItem(self.menuConfig[i].active_name)
    self.btnList[i] = content
    item:addContent(content)
    item:setItemSize(content:getContentSize().width, content:getContentSize().height + 20)
    self.llistView:addItem(item)
    --[[
    if self.menuConfig[i].id == 1 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_LV,self.btnMap[self.menuConfig[i].id],170,42)
    elseif self.menuConfig[i].id == 2 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_FIGHT,self.btnMap[self.menuConfig[i].id],170,42)
    elseif self.menuConfig[i].id == 3 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_MEDAL,self.btnMap[self.menuConfig[i].id],170,42)
      elseif self.menuConfig[i].id == 4 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_WING,self.btnMap[self.menuConfig[i].id],170,42)
      elseif self.menuConfig[i].id == 5 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_STREN,self.btnMap[self.menuConfig[i].id],170,42)
      elseif self.menuConfig[i].id == 6 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_CYZZ,self.btnMap[self.menuConfig[i].id],170,42)
      elseif self.menuConfig[i].id == 7 then
      elseif self.menuConfig[i].id == 8 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_LCJY,self.btnMap[self.menuConfig[i].id],170,42)
      elseif self.menuConfig[i].id == 9 then
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_SERVICE_BSS,self.btnMap[self.menuConfig[i].id],170,42)
      end
	--]]
    end

    
    self.llistView:reload()

  --默认打开第一个
  if #self.menuConfig > 0 then
    self:handleMenuClick(1)
  end
  

end

function HolidayActivityView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item =self.btnList[event.itemPos]
 
       	if self.currentMenu ~= nil and self.currentMenu ~= item then
            self.currentMenu:setSpriteFrame("festival_Btn1.png")
            self:handleMenuClick(event.itemPos)
        end

    end
end

function HolidayActivityView:handleMenuClick(index)

	self.btnList[index]:setSpriteFrame("festival_Btn2.png")
  	self.currentMenu = self.btnList[index]
  	self.currentType = self.menuConfig[index].active_type
  	self.currentIndex = index

 	--设置活动时间
  	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.dataList[self.currentType].start_time).."-"..os.date("%Y年%m月%d日%H:%M",self.dataList[self.currentType].end_time))
  	self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..self.menuConfig[index].active_rule.."</font>")
	
	self:setView(self.currentType)
	----------
	--获取数据
	self:request(self.currentType)
end

function HolidayActivityView:setView(type)

	if self.currentLayer then
		self.currentLayer:setVisible(false)
		self.currentLayer:close()
	end

	if type == 4 then
		if self.layerList[type] == nil then
			self.layerList[type] = HolidayActivityKillWin.new()
			self.mainLayer:addChild(self.layerList[type])
		end

		self.currentLayer = self.layerList[type]

	elseif type == 5 then
		if self.layerList[type] == nil then
			self.layerList[type] = HolidayActivityCompoundWin.new()
			self.mainLayer:addChild(self.layerList[type])
		end

		self.currentLayer = self.layerList[type]
	end

	if self.currentLayer then
		self.currentLayer:setVisible(true)
		self.currentLayer:open(self.menuConfig[self.currentIndex])
	end
	
end

function HolidayActivityView:request(type)
  
  local info = self.dataList[type]
  
  if info == nil then
    dump(type, "===无效的节日活动type===:")
    return 
  end
	
  if type == 4 then
			GlobalController.holiday:requestRankById(info.active_id)
	elseif type == 5 then
      GlobalController.holiday:requestExchangeById(info.active_id)
	end

end

function HolidayActivityView:callback(data)
end

function HolidayActivityView:open()
	
	GlobalEventSystem:addEventListener(HolidayEvent.HOLIDAY_INFO_LIST,handler(self,self.buildMenu))
	GlobalController.holiday:requestActivityInfo()
end

function HolidayActivityView:close()
	GlobalEventSystem:removeEventListener(HolidayEvent.HOLIDAY_INFO_LIST)
	if self.currentLayer then
		self.currentLayer:close()
		self.currentLayer = nil
	end
end

function HolidayActivityView:destory()
  self:close()
  HolidayActivityView.super.destory(self)
end

function HolidayActivityView:createItem(title)
	local bg = display.newSprite("#festival_Btn1.png")
	local txt = display.newTTFLabel({
    text = title,
    font = "Arial",
    size = 20,
    color = cc.c3b(255, 255, 255), -- 使用纯红色
    align = cc.TEXT_ALIGNMENT_LEFT,
    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    
	})
 
	bg:addChild(txt)
	txt:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
	return bg
end 

return HolidayActivityView