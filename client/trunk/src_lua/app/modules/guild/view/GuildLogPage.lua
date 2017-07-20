--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:20:23
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--行会日志页
local GuildBasePage = import(".GuildBasePage")
local GuildLogPage = class("GuildLogPage", GuildBasePage)

function GuildLogPage:ctor()
	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(10, 10, 630 - 10, 376)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(size)
    self.listView:setPosition(220,100)
    self.listViewAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.guild.view.GuildLogItem", 20)
    self.listView:setAdapter(self.listViewAdapter)
    self:addChild(self.listView)
    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function GuildLogPage:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    	self.listView:onCleanup()
    end
end

function GuildLogPage:createLogs(logListData)
	self.listViewAdapter:setData(logListData)
end

function GuildLogPage:registerEvent()
	self.registerEventId = {}
	--取得行会日志
    local function onGuildLog(data)
    	self:createLogs(data.data)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_LOG_INFO, onGuildLog)
end

function GuildLogPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuildLogPage:onShow()
	GameNet:sendMsgToSocket(17053,{})
end

return GuildLogPage