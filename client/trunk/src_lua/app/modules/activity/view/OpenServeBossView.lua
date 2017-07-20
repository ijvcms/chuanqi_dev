--
-- Author: Yi hanneng
-- Date: 2016-05-13 15:35:33
--
local OpenServeBossView = OpenServeBossView or class("OpenServeBossView", BaseView)
function OpenServeBossView:ctor()

	self.ccui = cc.uiloader:load("resui/serveBossWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end
 
function OpenServeBossView:init()

	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")

    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width , self.mainLayer:getContentSize().height)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width , self.mainLayer:getContentSize().height))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    --self.listView:setPositionX(7)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/serveBossItem.ExportJson", "app.modules.activity.view.OpenServeBossItem", 6, handler(self, self.onClickItem))
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
end

function OpenServeBossView:setViewInfo(data,config)

	if self.listView then
		self.listView:removeAllItems()
	end
 	
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
	data = data.active_service_list
 	
 	local list = {}
	for i=1,#data do
 
		local info = config[data[i].active_service_id]
		if info then
			info.num = data[i].num
			info.is_receive = data[i].is_receive
			info.state2 = data[i].state2
			info.name = data[i].name
		end

	 	table.insert(list, info)
	end
	
  	if #list > 1 then
  		table.sort(list,function(a,b) return a.id < b.id end)
  	end
  	
 	self.rankListAdapter:setData(list)
 	
end

function OpenServeBossView:onClickItem(item)

	if item == nil then
		return 
	end
 
	self.selectItem = item
	GlobalController.activity:requestActivityServiceReward(item:getData().id)
end

function OpenServeBossView:setSelectItem()
	if self.selectItem then
		self.selectItem:setTouchEnabled(false)
	end
end

function OpenServeBossView:open()
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD,handler(self,self.setSelectItem))
end

function OpenServeBossView:close()
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD)
end

function OpenServeBossView:destory()
	self:close()
	OpenServeBossView.super.destory(self)
end

return OpenServeBossView