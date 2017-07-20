--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-05 11:30:52
-- 场景聊天列表
local ChatMetadata = import("app.modules.chat.model.ChatMetadata")

local SceneChatList = class("SceneChatList", function()
	return display.newNode()
end)

function SceneChatList:ctor(size)
	self.chatBg = display.newSprite("#scene/scene_alphaBg.png")
	self.chatBg:setAnchorPoint(0,0)
	self.chatBg:setScale(size.width/16,size.height/9)
	self:addChild(self.chatBg)
	--size.width, size.height
	self.autoShowHide = true

	if self.chatUpdateEventId == nil then
    	self.chatUpdateEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_UPDATE, handler(self,self.updateChatInfo))
    end

    self.chatListChang = false
    self.hideTime = os.time()

    self:setTouchEnabled(false)
   	self:setTouchSwallowEnabled(false)
   	self:setNodeEventEnabled(false)
   	self:setTouchCaptureEnabled(false)

   	self.chatList = {} --聊天数据列表
   	self.itemList = {} --聊天显示对象列表
   	for i=1,2 do
   		self.itemList[i] = require("app.modules.chat.view.ChatItemView").new()
   		self:addChild(self.itemList[i])
   		self.itemList[i]:setPosition(0,50 +(1-i)*44)
   		--content:setData(itemData)
   	end
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



function SceneChatList:pushChatData(data)
	if GlobalController.chat.chatWinIsOpen then
		self:clear()
		return
	end
	table.insert(self.chatList,data)
	if #self.chatList > 2 then
		table.remove(self.chatList,1)
	end
	self.chatListChang = true
	self.hideTime = os.time()
	self:setVisible(true)

	self:updateChatList()

	if self.autoShowHide then
		if self.schedulerId == nil then
			self.schedulerId =  GlobalTimer.scheduleGlobal(handler(self,self.updateChatList),0.5)
		end
	end
end

function SceneChatList:updateChatList()
	if os.time() - self.hideTime > 6 then
		self.chatListChang = false
		self:clear()
	elseif self.chatListChang then
		self.chatListChang = false
		local item
		for i=1,#self.itemList do
			item = self.itemList[i]
			if self.chatList[i] then
				item:setVisible(true)
				item:setData(self.chatList[i])
			else
				item:setVisible(false)
			end
		end
	end
end

function SceneChatList:clear()
	self:setVisible(false)
	if self.schedulerId then
		GlobalTimer.unscheduleGlobal(self.schedulerId)
		self.schedulerId = nil
	end
	for i=1,#self.itemList do
		self.itemList[i]:setVisible(false)
	end
	if #self.chatList > 0 then
		self.chatList = {}
	end
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