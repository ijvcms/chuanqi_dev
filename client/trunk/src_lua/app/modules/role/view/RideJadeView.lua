--
-- Author: Yi hanneng
-- Date: 2016-09-06 14:11:04
--
local RideJadeView = RideJadeView or class("RideJadeView", BaseView)

function RideJadeView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/roleJade.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	
   	self.ccui:setPosition(display.width/2 - self.ccui:getContentSize().width/2, display.height/2 - self.ccui:getContentSize().height/2)
   	
   	self:init()

end

function RideJadeView:init()

	self.type = 0

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "closeBtn")
	self.itemName = cc.uiloader:seekNodeByName(self.ccui, "itemName")
	self.confirmBtn = cc.uiloader:seekNodeByName(self.ccui, "confirmBtn")

	self.selected = cc.uiloader:seekNodeByName(self.ccui, "selected")

	self.des = SuperRichText.new(nil,400):addTo(self.ccui)
	self.des:setAnchorPoint(0,1)
	self.des:setPosition(self.itemName:getPositionX(), self.itemName:getPositionY() - 20)
 
	self.itemList = {}
	self.itemList[1] = cc.uiloader:seekNodeByName(self.ccui, "item1")
	self.itemList[2] = cc.uiloader:seekNodeByName(self.ccui, "item2")
	self.itemList[3] = cc.uiloader:seekNodeByName(self.ccui, "item3")
	self.itemList[4] = cc.uiloader:seekNodeByName(self.ccui, "item4")
	self.itemList[5] = cc.uiloader:seekNodeByName(self.ccui, "item5")
 
	self.confirmBtn:setTouchEnabled(true)
	self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmBtn:setScale(1.0)

            if BagManager:getInstance():findItemCountByItemId(self.selectInfo.goods_id) <= self.selectInfo.num then
	        	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,configHelper:getGoodNameByGoodId(self.selectInfo.goods_id).."数量不足！")
	        	return
	        end

            if self.backFunc then
            	self.backFunc(self.selectInfo)
            	self.selectInfo = nil
            	self:close()
            end
         end     
        return true
    end)
 
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:close()
        end     
        return true
    end)


    self:setViewInfo(nil)

end

function RideJadeView:setViewInfo(data)

	local config = configHelper:getMoutJadeList()
	local firstItem = nil
	for i=1,#config do
		if self.itemList[i] then
			local commonItem = CommonItemCell.new()
	        commonItem:setData({goods_id = config[i].key,num = config[i].num})
	        self.itemList[i]:addChild(commonItem, 10,10)
	        commonItem:setItemClickFunc(handler(self, self.handleClick))
	        commonItem:setPosition(commonItem:getContentSize().width/2 + 2, commonItem:getContentSize().height/2 + 2)
	        commonItem:setScale(0.8)
	        if BagManager:getInstance():findItemCountByItemId(config[i].key) <= config[i].num then
	        	commonItem:checkAndSetGray(true)
	        end

	        if i == 1 then
	        	firstItem = commonItem
	        end
		end
	end

	if firstItem then
		self:handleClick(firstItem)
	end

end

function RideJadeView:handleClick(item)
	local info = item:getData()
	self.itemName:setString(configHelper:getGoodNameByGoodId(info.goods_id))
	if self.selected then
		self.selected:setPositionX(item:getParent():getPositionX())
	end

	self.des:renderXml("<font color='e7d3ad' size='18' opacity='255'>"..configHelper:getGoodDescByGoodId(info.goods_id).."</font>")
	self.selectInfo = info
end

function RideJadeView:setBackFun(func)
	self.backFunc = func
end

function RideJadeView:open()

end

function RideJadeView:close()
	self:removeSelf()
end
 

return RideJadeView