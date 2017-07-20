--
-- Author: Yi hanneng
-- Date: 2016-08-18 12:00:21
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local HolidayActivityCompoundItem = HolidayActivityCompoundItem or class("HolidayActivityCompoundItem", UIAsynListViewItemEx)

function HolidayActivityCompoundItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/HolidayActivityCompoundItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function HolidayActivityCompoundItem:init()


	self.posList = {}
    self.itemList = {}
	self.itemList[1] = cc.uiloader:seekNodeByName(self.ccui, "item1")
	self.itemList[3] = cc.uiloader:seekNodeByName(self.ccui, "item2")
	self.itemList[5] = cc.uiloader:seekNodeByName(self.ccui, "item3")
	self.item4 = cc.uiloader:seekNodeByName(self.ccui, "item4")
    self.itemList[2] = cc.uiloader:seekNodeByName(self.ccui, "addImg")
    self.itemList[4] = cc.uiloader:seekNodeByName(self.ccui, "addImg2")
    self.compoundBtn = cc.uiloader:seekNodeByName(self.ccui, "compoundBtn")
    self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
 	
 	self.posList[1] = {}
 	self.posList[2] = {}

 	table.insert(self.posList[1], 100)
 	table.insert(self.posList[1], 177)
 	table.insert(self.posList[1], 249)

 	table.insert(self.posList[2], 53)
 	table.insert(self.posList[2], 113)
 	table.insert(self.posList[2], 170)
 	table.insert(self.posList[2], 229)
 	table.insert(self.posList[2], 286)


 	self.goodsList = {}

 	self.compoundBtn:setTouchEnabled(true)
    self.compoundBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.compoundBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.compoundBtn:setScale(1.0)
            if self.itemClickFunc then
            	self.itemClickFunc(self.data)
            end
        end
        return true
    end)


 
end

function HolidayActivityCompoundItem:setData(data)

	if data == nil then
		 
        return 
    end

    self.data = configHelper:getFusionProductConfigByKey(data[2])

    local canUse = true
 
    local stype = #self.data.stuff == 2 and 1 or 2
 
    for i=#self.itemList,#self.posList[stype] + 1, -1 do
        self.itemList[i]:setVisible(false)
    end

    for i=1,#self.posList[stype] do
    	self.itemList[i]:setVisible(true)
    	self.itemList[i]:setPositionX(self.posList[stype][i])
    end

    local j = 1

    if #self.goodsList > 0 then
 
        for i=1,#self.data.stuff do
            if self.goodsList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = self.data.stuff[i][2]})
                item:setCount(self.data.stuff[i][3])
                item:setTouchSwallowEnabled(false)
                self.itemList[j]:addChild(item)
                item:setScale(0.8)
                self.goodsList[#self.goodsList + 1] = item
   
                item:setPosition(self.itemList[j]:getContentSize().width/2,self.itemList[j]:getContentSize().height/2)
            else
            	
                self.goodsList[i]:setData({goods_id = self.data.stuff[i][2]})
                self.goodsList[i]:setCount(self.data.stuff[i][3])
            end

            if BagManager:getInstance():findItemCountByItemId(self.data.stuff[i][2]) < self.data.stuff[i][3] then
                canUse = false
            end

            j = j + 2
 
        end
    else
 
        for i=1,#self.data.stuff do
                
            local item = CommonItemCell.new()
            item:setData({goods_id = self.data.stuff[i][2]})
            item:setCount(self.data.stuff[i][3])
            item:setTouchSwallowEnabled(false)
            self.itemList[j]:addChild(item)
            item:setScale(0.8)
            self.goodsList[#self.goodsList + 1] = item
        
            item:setPosition(self.itemList[j]:getContentSize().width/2,self.itemList[j]:getContentSize().height/2)
        	j = j + 2

            if BagManager:getInstance():findItemCountByItemId(self.data.stuff[i][2]) < self.data.stuff[i][3] then
                canUse = false
            end

        end
    end

    if self.item4Goods == nil then
    	self.item4Goods = CommonItemCell.new()
	 	
	    self.item4Goods:setTouchSwallowEnabled(false)
	    self.item4:addChild(self.item4Goods)
	    self.item4Goods:setScale(0.8)
	  
	    self.item4Goods:setPosition(self.item4:getContentSize().width/2,self.item4:getContentSize().height/2)
    end
    
    self.item4Goods:setData({goods_id = self.data.product[1][2]})
    self.compoundBtn:setButtonEnabled(canUse)

    if data[3] == 0 then
        self.numLabel:setString("不限")
        self.numLabel:setColor(cc.c3b(0, 255, 0))
    else
        self.numLabel:setString((data[3] - data.info.count).."/"..data[3])
        if data.info.count < data[3] then
            self.numLabel:setColor(cc.c3b(0, 255, 0))
        else
            self.numLabel:setColor(cc.c3b(255, 0, 0))
            self.compoundBtn:setButtonEnabled(false)
        end
    end     
end

function HolidayActivityCompoundItem:setItemClick(func)
	self.itemClickFunc = func
end

function HolidayActivityCompoundItem:getData()
	return self.data
end

function HolidayActivityCompoundItem:destory()
end

return HolidayActivityCompoundItem