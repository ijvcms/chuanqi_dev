--
-- Author: Yi hanneng
-- Date: 2016-05-09 15:29:31
--
local WelfareLevelView = WelfareLevelView or class("WelfareLevelView", BaseView)

function WelfareLevelView:ctor()
	self.ccui = cc.uiloader:load("resui/welfareOnlineWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setViewInfo(nil)
   	
end

function WelfareLevelView:init()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.ccui:getContentSize().width - 12, self.ccui:getContentSize().height - 12)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.ccui:getContentSize().width - 12, self.ccui:getContentSize().height - 12))
    self.listView:setPosition(6,6)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/welfareLevelItem.ExportJson", "app.modules.welfare.view.WelfareLevelItem", 6,handler(self, self.itemClick))
    self.listView:setAdapter(self.rankListAdapter)
    self.ccui:addChild(self.listView)

end

function WelfareLevelView:setViewInfo(data)
 
	local config = configHelper:getWelfareRewardsByType(4)
	self.rankListAdapter:setData(config)
end

function WelfareLevelView:itemClick(item)

	if item ~= nil then
		self.clickItem = item
        GlobalController.welfare:RequestReceiveReward(item:getData().key)
    end
end

function WelfareLevelView:getSucc()
	if self.clickItem then
		self.clickItem:setState(false)
	end
end

function WelfareLevelView:open()
	GlobalController.welfare:RequestGetRewardsState()
end

function WelfareLevelView:close()
end

function WelfareLevelView:destory()
	--[[
	if self.itemList and #self.itemList > 0 then
		for i=1,#self.itemList do
			self.itemList[i]:destory()
		end
	end
	self.itemList = {}
	--]]
	self.listView:removeAllItems()

	self:close()
	WelfareLevelView.super.destory(self)
end

return WelfareLevelView