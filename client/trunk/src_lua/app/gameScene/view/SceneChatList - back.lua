--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-05 11:30:52
-- 场景列表

local UIAsyncListView = import("app.gameui.listViewEx.UIAsyncListView")
local ChatMetadata = import("app.modules.chat.model.ChatMetadata")

local SceneChatList = class("SceneChatList", UIAsyncListView)

function SceneChatList:ctor(size)
	self.chatBg = display.newScale9Sprite("#scene/scene_alphaBg.png", 0, 0, size, cc.rect(8,4,2,2))
	self.chatBg:setAnchorPoint(0,0)
	self:addChild(self.chatBg)

	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
	SceneChatList.super.ctor(self, params)
	self:setContentSize(size)
	self.autoShowHide = true
	self:setAdapter(require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.chat.view.ChatItemView", 20))
	self.isSetData = false

	if self.chatUpdateEventId == nil then
    	self.chatUpdateEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_UPDATE, handler(self,self.updateChatInfo))
    end

    self.chatListChang = false
    self.hideTime = os.time()
    self.chatList = {}

    self:setChatData(self.chatList)
    self:refreshData()
    self:setTouchEnabled(false)
   	self:setTouchSwallowEnabled(false)
   	self:setNodeEventEnabled(false)
   	self:setTouchCaptureEnabled(false)


   	-- self.itemList = {}
   	-- for i=1,2 do
   	-- 	self.itemList[i] = require("app.modules.chat.view.ChatItemView").new()
   	-- 	self:addChild(self.itemList[i])
   	-- 	--content:setData(itemData)
   	-- end
end


function SceneChatList:updateChatInfo(data)
	--{data = data,channelId = curChannel,playerId = data.chatData.player_id}
	local cdv = data.data.data
	local channelId = data.data.channelId

	if not cdv.isLocal and channelId ~= ChatChannelType.SYSTEM and channelId ~= ChatChannelType.ALL and cdv.chatType ~= ChatMetadata.CHAT_TYPE.CHAT_TALK then
		--向外ui展示
		local item = {chatData = cdv.chatData, showWidth = 240, showBg = true, showTime = false, chatType = cdv.chatType, isLocal = cdv.isLocal} 
		self:pushChatData(item)
	end
end


function SceneChatList:setChatData(data)
	self.isSetData = true
	self.adapter:setData(data)
	self:scrollToBottom()
end

function SceneChatList:getIsSetData()
	return self.isSetData
end

function SceneChatList:needReload()
	self.needReload_ = true
end

function SceneChatList:refreshData()
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

function SceneChatList:pushChatData(data)
	if GlobalController.chat.chatWinIsOpen then
		self:setVisible(false)
		self.adapter:clearData()	
		return
	end

	table.insert(self.chatList,data)
	if #self.chatList > 2 then
		table.remove(self.chatList,1)
	end
	self.chatListChang = true
	self.hideTime = os.time()
	self:setVisible(true)
	if self.autoShowHide then
		if self.schedulerId == nil then
			self.schedulerId =  GlobalTimer.scheduleGlobal(handler(self,self.updateChatList),0.5)
		end
	end



	-- self:needReload()
	-- --self:syncData()
	-- self:refreshData()

	-- --self.adapter:insertData(data)
	-- if self.autoShowHide then
	-- 	--有信息，自动显示
	-- 	self:setVisible(true)
	-- 	if self.schedulerId then
	-- 		GlobalTimer.unscheduleGlobal(self.schedulerId)
	-- 		self.schedulerId = nil
	-- 	end
	-- 	--10秒自动隐藏
	-- 	self.schedulerId = GlobalTimer.performWithDelayGlobal(function()
	-- 		self:setVisible(false)
	-- 		--self.adapter:clearData()
	-- 		while #self.chatList > 0 do
	-- 			table.remove(self.chatList,1)
	-- 		end
	-- 	end,6)
	-- end
	-- self:scrollToBottom()
end

function SceneChatList:updateChatList(data)
	if os.time() - self.hideTime > 16 then
		self.chatListChang = false
		if self.schedulerId then
			GlobalTimer.unscheduleGlobal(self.schedulerId)
			self.schedulerId = nil
		end
		self:setVisible(false)
		--self.adapter:clearData()
		while #self.chatList > 0 do
			table.remove(self.chatList,1)
		end
	elseif self.chatListChang then
		self.chatListChang = false
		self:needReload()
		--self:syncData()
		self:refreshData()
		self:scrollToBottom()
	end
end

function SceneChatList:setIsStopPushChat(value)
	if value then
		self:setVisible(false)
	end
	self.isStopPushChat = value
end

function SceneChatList:syncData()
	self.adapter:syncData()
end

--未读信息数
function SceneChatList:getUnReadCount()
	return self.adapter:getCount() - self.rowLoaded
end



--设置是否自动隐藏界面
function SceneChatList:setAutoShowHide(flag)
	self.autoShowHide = flag
end

--销毁
function SceneChatList:destory()
	if self.schedulerId then
		GlobalTimer.unscheduleGlobal(self.schedulerId)
		self.schedulerId = nil
	end
	if self.chatUpdateEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.chatUpdateEventId)
		self.chatUpdateEventId = nil
	end
	self:removeSelf()
end


return SceneChatList