--
-- Author: Yi hanneng
-- Date: 2016-04-22 10:18:11
--


--[[
福利中心－－－－在线登陆
--]]
local WelfareOnlineView = WelfareOnlineView or class("WelfareOnlineView", BaseView)

function WelfareOnlineView:ctor()

	self.ccui = cc.uiloader:load("resui/welfareOnlineWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
   	self:setViewInfo(nil)
end

function WelfareOnlineView:init()

	--[[
	self.itemList = {}

	self.listView = SCUIList.new {
        viewRect = cc.rect(0,0,self.ccui:getContentSize().width - 40, self.ccui:getContentSize().height - 40),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :addTo(self.ccui):pos(20,20)
	--]]
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.ccui:getContentSize().width - 10, self.ccui:getContentSize().height - 12)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.ccui:getContentSize().width - 40, self.ccui:getContentSize().height - 40))
            --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(5,6)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/welfareOnlineItem.ExportJson", "app.modules.welfare.view.WelfareOnlineItem", 6,handler(self, self.itemClick))
    self.listView:setAdapter(self.rankListAdapter)
    self.ccui:addChild(self.listView)

 end

function WelfareOnlineView:setViewInfo(data)
 
	local config = configHelper:getWelfareRewardsByType(2)
	self.rankListAdapter:setData(config)
	--[[
	for i=1,#config do
		local item = self.listView:newItem()
		local content = require("app.modules.welfare.view.WelfareOnlineItem").new()
		content:setData(config[i])
		item:addContent(content)
		content:setItemClick(handler(self, self.itemClick))
		self.itemList[#self.itemList + 1] = content
	    item:setItemSize(content:getContentSize().width, content:getContentSize().height)
		self.listView:addItem(item)
	end

	self.listView:reload()
	--]]
end

function WelfareOnlineView:itemClick(item)

	if item ~= nil then
		self.clickItem = item
		dump(item:getData())
        GlobalController.welfare:RequestReceiveReward(item:getData().key)
    end
end

function WelfareOnlineView:getSucc()
	if self.clickItem then
		self.clickItem:setState(false)
	end
end

function WelfareOnlineView:open()

	--GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDITEM_STATE, handler(self,self.getSucc))
	--GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, handler(self,self.setViewInfo))

	GlobalController.welfare:RequestGetOnlineTime()
	GlobalController.welfare:RequestGetRewardsState()

end

function WelfareOnlineView:close()
	--GlobalEventSystem:removeEventListener(WelfareEvent.CHANGE_REWARDS_STATE)
	--GlobalEventSystem:removeEventListener(WelfareEvent.CHANGE_REWARDITEM_STATE)
end

function WelfareOnlineView:destory()
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
	WelfareOnlineView.super.destory(self)
end

return WelfareOnlineView