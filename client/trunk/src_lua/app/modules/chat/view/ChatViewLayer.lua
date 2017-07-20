--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 15:00:09
-- 拆解自 ChatView
-- 废弃不用

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ChatViewLayer = class("ChatViewLayer", function()
	return display.newNode()
end)

function ChatViewLayer:ctor(width,height)
	self.ori_width = width
	self.ori_height = height
	self:setContentSize(width,height)
	self.chatItemHeight = 0
	self:setTouchEnabled(false)
	self:setTouchSwallowEnabled(false)
	self.chatItems = {}
	self.chatHeights = {}
	self.offsets = 0
	self.autoShowHide = false
	self.autoScroll = false
	self.schedulerId = nil
end

function ChatViewLayer:pushChatItem(chatItem)

	if self.autoShowHide then
		--有信息，自动显示
		self:setVisible(true)
		if self.schedulerId then
			scheduler.unscheduleGlobal(self.schedulerId)
			self.schedulerId = nil
		end
		--10秒自动隐藏
		self.schedulerId = scheduler.performWithDelayGlobal(function()
			self:setVisible(false)
		end,10)
	end

	self:addChild(chatItem)
	table.insert(self.chatItems,chatItem)
	local chatHeight = chatItem:getContentSize().height
	table.insert(self.chatHeights,chatHeight)
	self.chatItemHeight = self.chatItemHeight+chatHeight
	chatItem:setPositionY(self.ori_height-self.chatItemHeight)

	if self.autoScroll then
		self:handlerAutoScroll()
	elseif #self.chatItems > 20 then
		local h = self.chatItems[1]:getContentSize().height
		self.chatItemHeight = self.chatItemHeight - h
		self.chatItems[1]:destory()
		self.chatItems[1]:removeSelf()
		table.remove(self.chatItems,1)
		table.remove(self.chatHeights,1)
		--调整位置
		for i=1,#self.chatItems do
			self.chatItems[i]:setPositionY(self.chatItems[i]:getPositionY()+h)
		end
	 
	end
	
end
--自动滚屏(其实是删除前面纪录)
function ChatViewLayer:handlerAutoScroll()

	if self.ori_height  + self.offsets <  self.chatItemHeight then

		local h = self.chatItems[1]:getContentSize().height
		self.chatItemHeight = self.chatItemHeight - h
		self.chatItems[1]:destory()
		self.chatItems[1]:removeSelf()
		table.remove(self.chatItems,1)
		table.remove(self.chatHeights,1)
		--调整位置
		for i=1,#self.chatItems do
			self.chatItems[i]:setPositionY(self.chatItems[i]:getPositionY()+h)
		end
		self:handlerAutoScroll()
	end
end

function ChatViewLayer:setOffset(offsets)
	self.offsets = offsets
end

function ChatViewLayer:setAutoScroll(flag)
	self.autoScroll = flag
end
--设置是否自动隐藏界面
function ChatViewLayer:setAutoShowHide(flag)
	self.autoShowHide = flag
end

function ChatViewLayer:getCurChatIndex()
	local h = self:getPositionY()+self.ori_height-77
	local h2 = 0
	for i=1,#self.chatItems do
		h2 = h2 + self.chatHeights[i]
		if h2 > h then
			return i
		end
	end

	return #self.chatItems
end

function ChatViewLayer:getHeight()
	return self.ori_height  + self.offsets <  self.chatItemHeight, self.chatItemHeight
end

return ChatViewLayer