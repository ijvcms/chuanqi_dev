--
-- Author: Yi hanneng
-- Date: 2016-08-18 10:43:53
--


local HolidayActivityKillWin = HolidayActivityKillWin or class("HolidayActivityKillWin", BaseView)

function HolidayActivityKillWin:ctor()
	self.ccui = cc.uiloader:load("resui/festivalKillWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function HolidayActivityKillWin:init()

	self.rankLabelList = {}
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	self.rankLabelList[1] = cc.uiloader:seekNodeByName(self.ccui, "Rank1")
	self.rankLabelList[2] = cc.uiloader:seekNodeByName(self.ccui, "Rank2")
	self.rankLabelList[3] = cc.uiloader:seekNodeByName(self.ccui, "Rank3")
	self.rankLabel = cc.uiloader:seekNodeByName(self.ccui, "rankLabel")
	self.pointLabel = cc.uiloader:seekNodeByName(self.ccui, "pointLabel")


	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
    --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPositionX(7)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/festivalKillReward.ExportJson", "app.modules.activity.view.HolidayActivityKillItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
 
end

function HolidayActivityKillWin:itemClick(item)
end

function HolidayActivityKillWin:setViewInfo(data)
	
	if data == nil then
		return
	end

	data = data.data
	self.data = data
	 
 	if data.rank ~= 0 then
 		self.rankLabel:setString(data.rank)
 	else
 		self.rankLabel:setString("未上榜")
 	end
	
	self.pointLabel:setString(data.score)

	for i=1,3 do
		if data.rank_list[i] then
			self.rankLabelList[i]:setString(data.rank_list[i].rank.."、"..data.rank_list[i].name)
		else
			self.rankLabelList[i]:setString("")
		end
	end
 
end

function HolidayActivityKillWin:open(data)
	GlobalEventSystem:addEventListener(HolidayEvent.RCV_HOLIDAY_RANK,handler(self,self.setViewInfo))
	self.rankListAdapter:setData(data.rewards)
end

function HolidayActivityKillWin:close()
	GlobalEventSystem:removeEventListener(HolidayEvent.RCV_HOLIDAY_RANK)
end

return HolidayActivityKillWin