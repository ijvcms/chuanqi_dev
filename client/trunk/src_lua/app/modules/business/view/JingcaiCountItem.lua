--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:23:30
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local JingcaiCountItem = JingcaiCountItem or class("JingcaiCountItem", UIAsynListViewItemEx)

function JingcaiCountItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/jingcaiCountItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function JingcaiCountItem:init()
 
    self.itemList = {}
    self.itemLayer = cc.uiloader:seekNodeByName(self.ccui, "itemLayer")
    self.compoundBtn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
    self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")

    self.titleLabel:setVisible(false)
    self.ruleRich = SuperRichText.new(nil,self.titleLabel:getContentSize().width)
    self.ruleRich:setAnchorPoint(0,1)
    self.titleLabel:getParent():addChild(self.ruleRich)
    self.ruleRich:setPosition(self.titleLabel:getPositionX(), self.titleLabel:getPositionY() + 10)
 
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

function JingcaiCountItem:setData(data)

	if data == nil then
		 
        return 
    end

    self.data = data

    self.ruleRich:renderXml("<font color='ffffff' size='18' opacity='255'>"..data.content.."</font>")
     
    if data.state == 1 then
        self.compoundBtn:setButtonEnabled(true)
        self.compoundBtn:setButtonLabelString("领取")
    elseif data.state == 2 then
        self.compoundBtn:setButtonEnabled(false)
        self.compoundBtn:setButtonLabelString("已领取")
    elseif data.state == 0 then
        self.compoundBtn:setButtonEnabled(false)
        self.compoundBtn:setButtonLabelString("未获得")
    end

    local itemWidth = 0
    local itemHeight = 0

    if #self.itemList > 0 then

        for i=#self.itemList,#data.show_reward + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#data.show_reward do
            if self.itemList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = data.show_reward[i].goods_id,is_bind = data.show_reward[i].is_bind})
                item:setCount(data.show_reward[i].num)
                item:setTouchSwallowEnabled(false)
                self.ccui:addChild(item)
                --item:setScale(0.8)
                self.itemList[#self.itemList + 1] = item
                    
                itemWidth = item:getContentSize().width + 20
                itemHeight = item:getContentSize().height + 10

                item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2 + 12)
            else
            	self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = data.show_reward[i].goods_id,is_bind = data.show_reward[i].is_bind})
                self.itemList[i]:setCount(data.show_reward[i].num)
            end
 
        end
    else
        for i=1,#data.show_reward do
                
            local item = CommonItemCell.new()
            item:setData({goods_id = data.show_reward[i].goods_id,is_bind = data.show_reward[i].is_bind})
            item:setCount(data.show_reward[i].num)
            item:setTouchSwallowEnabled(false)
            self.ccui:addChild(item)
            --item:setScale(0.8)
            self.itemList[#self.itemList + 1] = item
            	
     		itemWidth = item:getContentSize().width + 20
     		itemHeight = item:getContentSize().height + 10

            item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2 + 12)
        
        end
    end
end

function JingcaiCountItem:setItemClick(func)
	self.itemClickFunc = func
end

function JingcaiCountItem:getData()
	return self.data
end

function JingcaiCountItem:destory()
end

return JingcaiCountItem