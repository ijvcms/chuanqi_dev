--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:20:50
--
-------------累计充值、消费--------------
local JingcaiCountWin = JingcaiCountWin or class("JingcaiCountWin", BaseView)

function JingcaiCountWin:ctor()
	self.ccui = cc.uiloader:load("resui/jingcaiCountWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)
end

function JingcaiCountWin:init()

	self.itemList = {}
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
	self.tipsText = cc.uiloader:seekNodeByName(self.ccui, "tipsText")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")

	self.goodsList = {}


	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPositionX(7)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/jingcaiCountItem.ExportJson", "app.modules.business.view.JingcaiCountItem", 6, handler(self, self.itemClick))
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
 
end

function JingcaiCountWin:setViewInfo(data)

	if data == nil then
		return
	end

	self.data = data
	dump(data)
 	self.tipsText:setString(data.content)
 	self.numLabel:setString(data.content_value)
 	self.titleLabel:setString(data.title)
 	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.start_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
 
	self.rankListAdapter:setData(data.sub_list,true)

end

function JingcaiCountWin:ddd(data)
	
	if self.data.active_id == data.data.active_id then
 
		for i=1,#self.data.sub_list do
			 
			if self.data.sub_list[i].sub_type == data.data.sub_type then
				self.data.sub_list[i].state = data.data.value
			end
	 
		end
		 
		self.rankListAdapter:setData(self.data.sub_list,true)
	end
end

function JingcaiCountWin:itemClick(data)
	if data == nil then
		return
	end
 
	GlobalController.business:requestBusinessReceiveReward(self.data.active_id,data.sub_type)
end

function JingcaiCountWin:open(data)
	
	GlobalEventSystem:addEventListener(BusinessEvent.RCV_BUSINESS_REWARD,handler(self, self.ddd))
 
end

function JingcaiCountWin:close()
	GlobalEventSystem:removeEventListener(BusinessEvent.RCV_BUSINESS_REWARD)
end

function JingcaiCountWin:destory()
	self:close()
	JingcaiCountWin.super.destory(self)
end

return JingcaiCountWin