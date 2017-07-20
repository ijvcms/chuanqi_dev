--
-- Author: Yi hanneng
-- Date: 2016-02-26 09:57:51
--
local ExchangeSaleItem = ExchangeSaleItem or class("ExchangeSaleItem", function() return display.newNode() end)

function ExchangeSaleItem:ctor()
	self.ccui = cc.uiloader:load("resui/exchangeShelfItem.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function ExchangeSaleItem:init()
 
	self.itemImg = cc.uiloader:seekNodeByName(self.ccui, "itemImg")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
 
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
	self.shadowImg = cc.uiloader:seekNodeByName(self.ccui, "shadowImg")

	self:setSelect(false)
end

function ExchangeSaleItem:setData(data)
	if data == nil then
		return
	end
	self.data = data
 
 	if self.commonItem == nil then
		self.commonItem = CommonItemCell.new()
		self.commonItem:setData(data)
		self.commonItem:setCount(data.num)
		self.itemImg:addChild(self.commonItem, 10,10)
		self.commonItem:setPosition(self.itemImg:getContentSize().width/2, self.itemImg:getContentSize().height/2)
		self.commonItem:setScale(0.8)
	else
		self.commonItem:setData(data)
		self.commonItem:setCount(data.num)
	end
	--[[
	 if self.itemImg:getChildByTag(10) then
		self.itemImg:removeChildByTag(10, true)
	end

	
	local commonItem = CommonItemCell.new()
	commonItem:setData(data)
	self.itemImg:addChild(commonItem, 10,10)
	commonItem:setPosition(commonItem:getContentSize().width/2 + 1, commonItem:getContentSize().height/2 + 2)
	commonItem:setScale(0.8)
	--]]
	self.nameLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
 
	self.timeLabel:setString(data.time)
	self.priceLabel:setString(data.price)


end

function ExchangeSaleItem:getData()
	return self.data
end

function ExchangeSaleItem:setSelect(b)
	self.selected = b
	if self.shadowImg then
		self.shadowImg:setVisible(b)
	end
end

function ExchangeSaleItem:getSelected()
	return self.selected
end

return ExchangeSaleItem