--
-- Author: Yi hanneng
-- Date: 2016-02-26 10:00:11
--

--[[--]]

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local ExchangeReceiveItem = ExchangeReceiveItem or class("ExchangeReceiveItem", UIAsynListViewItemEx)

function ExchangeReceiveItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/exchangeGetItem.ExportJson")
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function ExchangeReceiveItem:init()
 
	self.itemImg = cc.uiloader:seekNodeByName(self.ccui, "itemImg")
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
 
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.priceLabel = cc.uiloader:seekNodeByName(self.ccui, "priceLabel")
	self.stateLabel = cc.uiloader:seekNodeByName(self.ccui, "stateLabel")
	self.shadowImg = cc.uiloader:seekNodeByName(self.ccui, "shadowImg")
	self.coinImg = cc.uiloader:seekNodeByName(self.ccui, "coinImg")

	self:setSelect(false)
end

function ExchangeReceiveItem:setData(data)
	if data == nil then
		return
	end

	self.data = data
 	self:setSelect(false)
 	
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
	commonItem:setCount(data.num)
	self.itemImg:addChild(commonItem, 10,10)
	commonItem:setPosition(commonItem:getContentSize().width/2 + 1, commonItem:getContentSize().height/2 + 2)
	commonItem:setScale(0.8)
	--]]
	self.nameLabel:setString(configHelper:getGoodNameByGoodId(data.goods_id))
 	
	
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

	if data.time < 0 then
		self.timeLabel:setString("已过期")
	end

	self.priceLabel:setString(data.jade)
	self.coinImg:setPositionX(self.priceLabel:getPositionX() - self.priceLabel:getContentSize().width/2 - self.coinImg:getContentSize().width/2 - 2)
-- 状态 1 已退回，2 出售成功，3 表示已下架,4 已购买
	if data.state == 1 then
		self.stateLabel:setString("已退回")
	elseif data.state == 2 then
		self.stateLabel:setString("出售成功")
	elseif data.state == 3 then
		self.stateLabel:setString("已下架")
	elseif data.state == 4 then
		self.stateLabel:setString("已购买")
	end
	

end

function ExchangeReceiveItem:getData()
	return self.data
end

function ExchangeReceiveItem:setSelect(b)
	self.selected = b
	if self.shadowImg then
		self.shadowImg:setVisible(b)
	end
end

return ExchangeReceiveItem