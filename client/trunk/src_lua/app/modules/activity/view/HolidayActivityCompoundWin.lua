--
-- Author: Yi hanneng
-- Date: 2016-08-18 11:44:24
--

local HolidayActivityCompoundWin = HolidayActivityCompoundWin or class("HolidayActivityCompoundWin", BaseView)

function HolidayActivityCompoundWin:ctor()
	self.ccui = cc.uiloader:load("resui/festivalCompoundWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function HolidayActivityCompoundWin:init()

	self.itemList = {}
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.itemList[1] = cc.uiloader:seekNodeByName(self.ccui, "item1")
	self.itemList[2] = cc.uiloader:seekNodeByName(self.ccui, "item2")
	self.itemList[3] = cc.uiloader:seekNodeByName(self.ccui, "item3")

	self.goodsList = {}


	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPositionX(7)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/festivalCompoundItem.ExportJson", "app.modules.activity.view.HolidayActivityCompoundItem", 6, handler(self, self.itemClick))
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
 
end

function HolidayActivityCompoundWin:setViewInfo(data)
	if data == nil then
		return
	end
 
	--self.data = data
	if #self.goodsList > 0 then
		for i=1,3 do
			if self.goodsList[i] == nil then
				local item = CommonItemCell.new()
			    item:setData({goods_id = data.goods_show[i]})
			    item:setCount(BagManager:getInstance():findItemCountByItemId(data.goods_show[i]))
			    item:setTouchSwallowEnabled(false)
			    self.itemList[i]:addChild(item)
			    self.goodsList[i] = item
			    item:setScale(0.8)
			    item:setPosition(self.itemList[i]:getContentSize().width/2, self.itemList[i]:getContentSize().height/2)
			else
				self.goodsList[i]:setTouchSwallowEnabled(false)
				self.goodsList[i]:setData({goods_id = data.goods_show[i]})
			    self.goodsList[i]:setCount(BagManager:getInstance():findItemCountByItemId(data.goods_show[i]))
			end
		end
	else
		for i=1,3 do
			local item = CommonItemCell.new()
		    item:setData({goods_id = data.goods_show[i]})
		    item:setCount(BagManager:getInstance():findItemCountByItemId(data.goods_show[i]))
		    item:setTouchSwallowEnabled(false)
		    self.itemList[i]:addChild(item)
		    self.goodsList[i] = item
		    item:setScale(0.8)
		    item:setPosition(self.itemList[i]:getContentSize().width/2, self.itemList[i]:getContentSize().height/2)
		end
 	end
 	--dump(data.rewards)
	self.rankListAdapter:setData(data.rewards,true)

end

function HolidayActivityCompoundWin:ddd(data)
	
	local list = data.data.list

	for i=1,#self.data.rewards do
		for j=1,#list do
			if self.data.rewards[i][2] == list[j].fusion_id then
				self.data.rewards[i].info = list[j]
			end
		end
	end
	
	self:setViewInfo(self.data)
	--self.rankListAdapter:setData(self.data.rewards)

end

function HolidayActivityCompoundWin:itemClick(data)
	if data == nil then
		return
	end
	dump(data)
	GameNet:sendMsgToSocket(14031,{formula_id = data.key})
end

function HolidayActivityCompoundWin:open(data)
	self.data = data
	GlobalEventSystem:addEventListener(HolidayEvent.RCV_HOLIDAY_COMPOSE,handler(self, self.ddd))
	--GlobalEventSystem:addEventListener(HolidayEvent.HOLIDAY_COMPOSE_SUCCESS,function() self:setViewInfo(self.data) end)
	--self:setViewInfo(data)
end

function HolidayActivityCompoundWin:close()
	--GlobalEventSystem:removeEventListener(HolidayEvent.HOLIDAY_COMPOSE_SUCCESS)
	GlobalEventSystem:removeEventListener(HolidayEvent.RCV_HOLIDAY_COMPOSE)
end

return HolidayActivityCompoundWin