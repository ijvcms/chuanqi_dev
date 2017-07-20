--替代ChatDataView
--@author shine

UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")


local ChatMetadata = import("..model.ChatMetadata")
local ChatItemView = class("ChatItemView", UIAsynListViewItem)


function ChatItemView:ctor()
	self:setNodeEventEnabled(true)
end

function ChatItemView:onCleanup()
	if self.chatType == ChatMetadata.CHAT_TYPE.CHAT_TALK then
		GlobalEventSystem:removeEventListener("play_talk")
	end
	self:stop()
end

function ChatItemView:onDisappear()
	self:stop()
end

function ChatItemView:setData(params)
	self.chatData = params.chatData
	self.chatType = params.chatType
    
    local chatData = params.chatData
    local showWidth = params.showWidth
    local showBg = params.showBg
    local showTime = params.showTime
    local chatType = params.chatType
    local isLocal = params.isLocal


	local height
 	if chatType == ChatMetadata.CHAT_TYPE.CHAT_TXT then
		if isLocal and chatData.channelId ~= 5 and chatData.channelId ~= 4 or showBg then
			local richStr = ChatMetadata.FormatMessageByChatData(chatData, isLocal)
 			if RichTextHelper.checkIsXmlString(richStr) then
                if self.headLabel  == nil then
                	self.headLabel = SuperRichText.new(richStr, showWidth, true)
                	self:addChild(self.headLabel)
                else
                	self.headLabel:setIsEllipsize(true)
                	self.headLabel:reuse(richStr, showWidth)
                	self.headLabel:setVisible(true)
                end
                if self.bg then
                	self.bg:setVisible(false)
                end
				height = self.headLabel:getContentSize().height + 4
				self:setContentSize(showWidth, height)
				self.headLabel:setPosition(0, 0)
			end

		else
			local headStr = ChatMetadata.FormatMessageHeadByChatData(chatData, isLocal)
			local contentStr = ChatMetadata.FormatMessageContent(chatData)
			if RichTextHelper.checkIsXmlString(headStr) and RichTextHelper.checkIsXmlString(contentStr) then
                if self.headLabel  == nil then
                	self.headLabel = SuperRichText.new(headStr, showWidth - 12)
                	self:addChild(self.headLabel)
                else

                	self.headLabel:reuse(headStr, showWidth - 12)
                	self.headLabel:setVisible(true)
                end

                self:initBackground(false)
                if self.contentLabel  == nil then
                	self.contentLabel = SuperRichText.new(contentStr, showWidth - 12)
                	self.bg:addChild(self.contentLabel)
                else
                	self.contentLabel:reuse(contentStr, showWidth - 12)
                	self.contentLabel:setVisible(true)
                end
                if self.talk then
                	self.talk:setVisible(false)
                end

				height = self.headLabel:getContentSize().height + 15
	 		
				local w = self.contentLabel:getContentSize().width
				local h = self.contentLabel:getContentSize().height
	 			if w < 50 then
					if w < 40 then
						w = 55
					else
						w = 70
					end
				else
					w = w + 20
				end
				 
				if h < 50 then
					if h < 40 then
						self.contentLabel:setPosition(15, 14)
					else
						self.contentLabel:setPosition(15, 4)
					end
					h = 48
				else
					h = h + 20
					self.contentLabel:setPosition(15, 10)
				end
				self.bg:setContentSize(cc.size(w,h))
				self.headLabel:setPosition(0, self.bg:getContentSize().height)
				self:setContentSize(showWidth, height + self.bg:getContentSize().height - 10)
			end
		end
	elseif chatType == ChatMetadata.CHAT_TYPE.CHAT_TALK then

		GlobalEventSystem:addEventListener("play_talk",handler(self,self.handlerTalk))

		local headStr = ChatMetadata.FormatMessageHeadByChatData(chatData, isLocal)	

        if self.headLabel  == nil then
            self.headLabel = SuperRichText.new(headStr, showWidth - 12)
            self:addChild(self.headLabel)
        else
            self.headLabel:reuse(headStr, showWidth - 12)
            self.headLabel:setVisible(true)
        end

		height = hearSrt:getContentSize().height + 15

        self:initBackground(true)

        if self.talk == nil then
        	self.talk = display.newSprite("#voiceBg5.png")
		    self.bg:addChild(self.talk)
        else
        	self.talk:setVisible(true)
        end
        if self.contentLabel then
        	self.contentLabel:setVisible(false)
        end

		self:playEffect("voice")
		
		self.headLabel:setPosition(5, self.bg:getContentSize().height)
		self.talk:setPosition(35, 25)
		self:setContentSize(showWidth, height + self.bg:getContentSize().height)   

	end

end


function ChatItemView:initBackground(can_touch)
	if self.bg == nil then
        self.bg = display.newScale9Sprite("#chat_lt.png", 0, 0, cc.size(200,48), cc.rect(28,24,1,1))
		self.bg:setAnchorPoint(0,0)
		self:addChild(self.bg)
		self.bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "began" then
             
            elseif event.name == "ended" then
        	    GlobalEventSystem:dispatchEvent("play_talk", self)
        	    if ChatAPI then
        		    ChatAPI:playVoiceMessage(self.chatData.content, true, handler(self, self.stop))
        	    end
        	    self.talkAction:stopAllActions()
        	    self.talkAction:getAnimation():play("effect")

            end     
            return true
        end)
    else
        self.bg:setContentSize(cc.size(200,48))
        self.bg:setVisible(true)
    end
    self.bg:setTouchEnabled(can_touch)
end

function ChatItemView:handlerTalk(data)

	if data ~= nil then
		if data.data ~= self then
			self:stop()
		end
	end
end

function ChatItemView:playEffect(action)

    ArmatureManager:getInstance():loadEffect(action)
    self.talkAction = ccs.Armature:create(action)
    self.bg:addChild(self.talkAction, 10)
    self.talkAction:stopAllActions()
    self.talkAction:setPosition(25, 25)
    --self.frameBgSprite:getAnimation():play("effect")

end

function ChatItemView:play()
	if self.talkAction then
		self.talkAction:stopAllActions()
    	self.talkAction:getAnimation():play("effect")
	end
end

function ChatItemView:stop()
	if self.talkAction then
		self.talkAction:stopAllActions()
	end
end

function ChatItemView:getType()
	return self.chatType
end


return ChatItemView