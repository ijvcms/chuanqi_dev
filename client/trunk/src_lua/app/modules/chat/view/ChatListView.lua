--替代ChatDataView
--@author shine


local UIAsyncListView = import("app.gameui.listViewEx.UIAsyncListView")


local ChatListView = class("ChatListView", UIAsyncListView)

function ChatListView:ctor(size)
	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
	ChatListView.super.ctor(self, params)
	self:setContentSize(size)
	self.autoShowHide = true
	self:setAdapter(require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.chat.view.ChatItemView", 20))
	self.isSetData = false
end

function ChatListView:setChatData(data)
	self.isSetData = true
	self.adapter:setData(data)
	self:scrollToBottom()
end

function ChatListView:getIsSetData()
	return self.isSetData
end

function ChatListView:needReload()
	self.needReload_ = true
end

function ChatListView:refreshData()
	if self.needReload_ then
	    self:setChatData(self.adapter:getData())
	    self.needReload_ = false
	else
		self:syncData()
		if not self:isScrollToBottom() then
			self:scrollToBottom()
		end
	end
end

function ChatListView:pushChatData(data)
	if self.isStopPushChat then		
		return
	end
	self.adapter:insertData(data)
	if self.autoShowHide then
		--有信息，自动显示
		self:setVisible(true)
		if self.schedulerId then
			GlobalTimer.unscheduleGlobal(self.schedulerId)
			self.schedulerId = nil
		end
		--10秒自动隐藏
		self.schedulerId = GlobalTimer.performWithDelayGlobal(function()
			self:setVisible(false)
			self.adapter:clearData()
		end,10)
	end
	self:scrollToBottom()
end

function ChatListView:setIsStopPushChat(value)
	if value then
		self:setVisible(false)
	end
	self.isStopPushChat = value
end

function ChatListView:syncData()
	self.adapter:syncData()
end

--未读信息数
function ChatListView:getUnReadCount()
	return self.adapter:getCount() - self.rowLoaded
end



--设置是否自动隐藏界面
function ChatListView:setAutoShowHide(flag)
	self.autoShowHide = flag
end


return ChatListView