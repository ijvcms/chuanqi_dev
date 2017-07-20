--
-- Author: Yi hanneng
-- Date: 2016-02-26 09:46:35
--

--[[--]]

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local ExchangeBuyItem = ExchangeBuyItem or class("ExchangeBuyItem", UIAsynListViewItemEx)

function ExchangeBuyItem:ctor(loader, layoutFile)
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))

   	self:init()
end

function ExchangeBuyItem:init()

	self.selected = false
 
	self.itemImg = cc.uiloader:seekNodeByName(self.ccui, "itemImg")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
	self.levelLabel = cc.uiloader:seekNodeByName(self.ccui, "levelLabel")
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
	self.coinImg = cc.uiloader:seekNodeByName(self.ccui, "coinImg")
	self.shadowImg = cc.uiloader:seekNodeByName(self.ccui, "shadowImg")
end

function ExchangeBuyItem:setData(data)

 
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
 
	self.nameLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
	self.levelLabel:setString(configHelper:getGoodLVByGoodId(data.goods_id))

	local tt = math.ceil(data.time/3600)
	local str = ""
	if tt > 24 then
		str = "大于24小时"
	elseif tt > 12 then
		str = "12至24小时"
	else
		str ="小于"..tt.."小时"
	end
	self.timeLabel:setString(str)
 
	self.priceLabel:setString(data.jade)
	self.coinImg:setPositionX(self.priceLabel:getPositionX() - self.priceLabel:getContentSize().width/2 - self.coinImg:getContentSize().width/2 - 2)
    self:setSelect(self.data.selected)
end

function ExchangeBuyItem:getData()
	return self.data
end

function ExchangeBuyItem:setSelect(b)
	if self.shadowImg then
		self.shadowImg:setVisible(b)
	end
	self.data.selected = b
end

function ExchangeBuyItem:getSelected()
	return self.data.selected
end

return ExchangeBuyItem
--]]