--
-- Author: Yi hanneng
-- Date: 2016-08-23 17:39:22
--

local OpenServeShopItem = class("OpenServeShopItem",function() return display.newNode() end)

function OpenServeShopItem:ctor()
	self.ccui = cc.uiloader:load("resui/serveGoodsItem.ExportJson")
     
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function OpenServeShopItem:init()

	self.itemBg = cc.uiloader:seekNodeByName(self.ccui, "itemBg")
    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
    self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
    self.limitLabel = cc.uiloader:seekNodeByName(self.ccui, "limitLabel")
    self.getBtn = cc.uiloader:seekNodeByName(self.ccui, "getBtn")
    self.connerIcon = cc.uiloader:seekNodeByName(self.ccui, "connerIcon")
    
    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.getBtn:setScale(1.0)
            if self.itemBtnClickFunc then
                self.itemBtnClickFunc(self.data)
            end
        end     
        return true
    end)
 
end

function OpenServeShopItem:setData(data)
 
	if data == nil or (data ~= nil and self.data == data) then
        return 
    end
 
    self.data = data

    self.nameLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
    self.priceLabel:setString(data.price)
    self.limitLabel:setString((data.limit_num - data.buy_num).."/"..data.limit_num)
    
    if data.buy_num >= data.limit_num then
        self.getBtn:setButtonEnabled(false)
    else
        self.getBtn:setButtonEnabled(true)
    end

    if self.commonItem == nil then
        self.commonItem = CommonItemCell.new()
        self.commonItem:setData(data)
        self.itemBg:addChild(self.commonItem, 10,10)
        self.commonItem:setPosition(self.commonItem:getContentSize().width/2, self.commonItem:getContentSize().height/2)
        --self.commonItem:setScale(0.8)
    else
        self.commonItem:setData(data)
    end

    self.commonItem:setCount(data.num)

end
 
function OpenServeShopItem:setItemBtnClickFunc(func)
    self.itemBtnClickFunc = func
end
 

function OpenServeShopItem:getData()
	return self.data
end

function OpenServeShopItem:destory()
end

return OpenServeShopItem