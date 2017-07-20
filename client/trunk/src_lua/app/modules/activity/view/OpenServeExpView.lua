--
-- Author: Yi hanneng
-- Date: 2016-05-13 16:21:04
--
local OpenServeExpView = OpenServeExpView or class("OpenServeExpView", BaseView)
function OpenServeExpView:ctor(w,h)
  	--self:addChild(self.ccui)
   	--self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:setContentSize(cc.size(w, w))
   	
   	self:init()
end

function OpenServeExpView:init()

	--[[
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")

	self.listView = SCUIList.new {
        viewRect = cc.rect(0,0,self.mainLayer:getContentSize().width, self.mainLayer:getContentSize().height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :addTo(self.mainLayer):pos(0, 0)
	--]]

	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self:getContentSize().width - 10 , self:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self:getContentSize().width - 10 , self:getContentSize().height - 10))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPositionX(7)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/serveExpItem.ExportJson", "app.modules.activity.view.OpenServeExpItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    self:addChild(self.listView)

end

function OpenServeExpView:setViewInfo(data,config)

	--[[
	if self.listView then
		self.listView:removeAllItems()
	end
 	
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
	data = data.active_service_list
 
	for i=1,#data do
		local item = self.listView:newItem()
		local content = require("app.modules.activity.view.OpenServeExpItem").new()
		local info = config[data[i].active_service_id]
		if info then
			info.num = data[i].num
			info.is_receive = data[i].is_receive
		end
		content:setData(info)
		content:setItemClickFunc(handler(self, self.onClickItem))
		item:addContent(content)
		item:setItemSize(content:getContentSize().width, content:getContentSize().height)
		self.listView:addItem(item)
		end
 
		self.listView:reload()
 	--]]

 	data = data.active_service_list
 	
 	local list = {}
	for i=1,#data do
			 
		local info = config[data[i].active_service_id]
		if info then
			info.num = data[i].num
			info.is_receive = data[i].is_receive
		end
	 	table.insert(list, info)
	end
	
	table.sort(list,function(a,b) return a.value < b.value end)

	self.rankListAdapter:setData(list)

 	
end

function OpenServeExpView:onClickItem(item)

	if item == nil then
		return 
	end
 
	self.selectItem = item
	GlobalController.activity:requestActivityServiceReward(item:getData().id)
end

function OpenServeExpView:setSelectItem()
	if self.selectItem then
		self.selectItem:setTouchEnabled(false)
	end
end

function OpenServeExpView:open()
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD,handler(self,self.setSelectItem))
end

function OpenServeExpView:close()
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD)
end

function OpenServeExpView:destory()
	self:close()
	OpenServeExpView.super.destory(self)
end
return OpenServeExpView