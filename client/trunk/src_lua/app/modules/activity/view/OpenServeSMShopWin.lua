--
-- Author: Yi hanneng
-- Date: 2016-08-24 16:42:09
--
 

local OpenServeSMShopWin = OpenServeSMShopWin or class("OpenServeSMShopWin", BaseView)

function OpenServeSMShopWin:ctor()
	self.ccui = cc.uiloader:load("resui/serveShopWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setNodeEventEnabled(true)
end

function OpenServeSMShopWin:init()

	self.itemList = {}
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.titleText = cc.uiloader:seekNodeByName(self.ccui, "titleText")
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.desLabel = cc.uiloader:seekNodeByName(self.ccui, "desLabel")
	self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
	self.skipBtn = cc.uiloader:seekNodeByName(self.ccui, "skipBtn")
 
	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(9,3)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/serveShopItem.ExportJson", "app.modules.activity.view.OpenServeSMShopItem", 6, handler(self, self.onClickItem))
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
 
 	self.skipBtn:setTouchEnabled(true)
    self.skipBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.skipBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.skipBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.TREASUERWIN)
        end
        return true
    end)
    
end

function OpenServeSMShopWin:onClickItem(item)

	if item == nil then
		return 
	end
 
	self.selectItem = item
	GlobalController.activity:requestActivityServiceReward(item:getData().id)
end

function OpenServeSMShopWin:setSelectItem()
	if self.selectItem then
		self.selectItem:setTouchEnabled(false)
	end
end

function OpenServeSMShopWin:open()
	GlobalEventSystem:addEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD,handler(self,self.setSelectItem))
end

function OpenServeSMShopWin:close()
	GlobalEventSystem:removeEventListener(ActivityEvent.RCV_ACTIVITY_SERVICE_REWARD)
end

function OpenServeSMShopWin:setViewInfo(data,config)
	

	if data == nil then
		return
	end
 
	self.data = data
 	self.numLabel:setString(data.my_value)
 	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
 
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

	if #list > 1 then
		table.sort(list,function(a,b) return a.value < b.value end)
	end

	self.rankListAdapter:setData(list)
end

function OpenServeSMShopWin:destory()
	self:close()
	OpenServeSMShopWin.super.destory(self)
end

return OpenServeSMShopWin