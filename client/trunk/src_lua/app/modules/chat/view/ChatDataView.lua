--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 14:58:37
-- 拆解自 ChatView
-- 废弃不用

-- CHAT_TYPE = {
	
-- 	CHAT_TXT = "CHAT_TXT", -- 文字
-- 	CHAT_TALK = "CHAT_TALK", --语音

-- }

-- local ChatMetadata = import("..model.ChatMetadata")
-- local ChatDataView = class("ChatDataView", function()
-- 	return display.newNode()
-- end)

-- function ChatDataView:ctor(chatData, showWidth, showBg, showTime, chatType, isLocal)
-- 	self.chatData = chatData
-- 	self.chatType = chatType
-- 	if showBg then
-- 		self.colorLayer = cc.LayerColor:create(cc.c4b(0,0,0,100))
-- 		self:addChild(self.colorLayer)
-- 	end
  	 
-- 	local height
--  	self.chatType = chatType
--  	if chatType == CHAT_TYPE.CHAT_TXT then
 
-- 		if isLocal and chatData.channelId ~= 5 or showBg then
-- 			local richStr = ChatMetadata.FormatMessageByChatData(chatData, isLocal)
 				
--  			if RichTextHelper.checkIsXmlString(richStr) then
 
-- 				local srt = SuperRichText.new(richStr, showWidth)
-- 				height = srt:getContentSize().height + 15
		 
-- 				self:addChild(srt)
-- 				self:setContentSize(showWidth, height)
-- 				srt:setContentSize(0, 0)
-- 				srt:setPosition(5, height)

-- 			end
-- 		else

-- 			local headStr = ChatMetadata.FormatMessageHeadByChatData(chatData, isLocal)
-- 			local contentStr = ChatMetadata.FormatMessageContent(chatData)

-- 			if RichTextHelper.checkIsXmlString(headStr) and RichTextHelper.checkIsXmlString(contentStr) then

-- 				local hearSrt = SuperRichText.new(headStr, showWidth - 15)
-- 				local contentSrt = SuperRichText.new(contentStr, showWidth - 15)
-- 				height = hearSrt:getContentSize().height + 15
	 		
-- 				local w = contentSrt:getContentSize().width
-- 				local h = contentSrt:getContentSize().height
	 
-- 	 			if w < 50 then
-- 					if w < 40 then
-- 						w = 55
-- 					else
-- 						w = 70
-- 					end
-- 				else
-- 					w = w + 20
-- 				end
				 
-- 				if h < 50 then
-- 					if h < 40 then
-- 						contentSrt:setPosition(15, contentSrt:getContentSize().height + 14)
-- 					else
-- 						contentSrt:setPosition(15, contentSrt:getContentSize().height + 4)
-- 					end
-- 					h = 48
-- 				else
-- 					h = h + 20
-- 					contentSrt:setPosition(15, contentSrt:getContentSize().height + 10)
-- 				end

-- 				self.bg = display.newScale9Sprite("#voiceBg1.png", 0, 0, cc.size(w,h),cc.rect(20,35,2,2))
-- 			 	self.bg:setAnchorPoint(0,0)
-- 				self:addChild(self.bg)
				
-- 				self:addChild(hearSrt)
-- 				self.bg:addChild(contentSrt)
-- 				hearSrt:setPosition(5, self.bg:getContentSize().height + height - 15)
-- 				self:setContentSize(showWidth, height + self.bg:getContentSize().height - 10)
-- 			end
-- 		end
-- 	elseif chatType == CHAT_TYPE.CHAT_TALK then

-- 		GlobalEventSystem:addEventListener("play_talk",handler(self,self.handlerTalk))

-- 		local headStr = ChatMetadata.FormatMessageHeadByChatData(chatData, isLocal)	
-- 		local hearSrt = SuperRichText.new(headStr, showWidth - 15)
-- 		height = hearSrt:getContentSize().height + 15
-- 		self:addChild(hearSrt)

		
-- 		self.bg = display.newScale9Sprite("#voiceBg1.png", 0, 0, cc.size(200,48),cc.rect(20,35,2,2))
-- 		self:playEffect("voice")
-- 		self.talk = display.newSprite("#voiceBg5.png")
-- 		self.bg:setAnchorPoint(0,0)
-- 		self:addChild(self.bg)
-- 		self.bg:addChild(self.talk)
-- 		hearSrt:setPosition(5, self.bg:getContentSize().height + height - 15)
-- 		self.talk:setPosition(35, 25)
-- 		self:setContentSize(showWidth, height + self.bg:getContentSize().height)

-- 		self.bg:setTouchEnabled(true)
-- 		self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
--         if event.name == "began" then
             
--         elseif event.name == "ended" then
--         	GlobalEventSystem:dispatchEvent("play_talk",self)
--         	if ChatAPI then
--         		ChatAPI:playVoiceMessage(chatData.content, true, handler(self, self.stop))
--         	end
--         	self.talkAction:stopAllActions()
--         	self.talkAction:getAnimation():play("effect")

--         end     
--         return true
--     end)

-- 	end
 
-- 	if self.colorLayer then
-- 		self.colorLayer:setContentSize(showWidth,height)
-- 		self.colorLayer:setPositionX(-2)
-- 		self.colorLayer:setPositionY(7)
-- 	end
-- end

-- function ChatDataView:handlerTalk(data)

-- 	if data ~= nil then
-- 		if data.data ~= self then
-- 			self:stop()
-- 		end
-- 	end
-- end

-- function ChatDataView:playEffect(action)

--     ArmatureManager:getInstance():loadEffect(action)
--     self.talkAction = ccs.Armature:create(action)
--     self.bg:addChild(self.talkAction, 10)
--     self.talkAction:stopAllActions()
--     self.talkAction:setPosition(25, 25)
--     --self.frameBgSprite:getAnimation():play("effect")

-- end

-- function ChatDataView:play()
-- 	if self.talkAction then
-- 		self.talkAction:stopAllActions()
--     	self.talkAction:getAnimation():play("effect")
-- 	end
-- end

-- function ChatDataView:stop()
-- 	if self.talkAction then
-- 		self.talkAction:stopAllActions()
-- 	end
-- end

-- function ChatDataView:getType()
-- 	return self.chatType
-- end

-- function ChatDataView:destory()
-- 	if self.chatType == CHAT_TYPE.CHAT_TALK then
-- 		GlobalEventSystem:removeEventListener("play_talk")
-- 	end
-- 	self:stop()
-- end

-- return ChatDataView