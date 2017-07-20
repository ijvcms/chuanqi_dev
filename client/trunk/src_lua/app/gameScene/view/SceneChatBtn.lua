--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-04 18:50:08
--
local SceneChatBtn = class("SceneChatBtn", function()
	return cc.Sprite:create()
end)


function SceneChatBtn:ctor()
	self:setSpriteFrame("scene/scene_chatBtn.png")
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self:setScale(1.1)
        elseif event.name == "ended" then
        	self:setScale(1)
        	if FunctionOpenManager:getFunctionOpenById(FunctionOpenType.Chat) then
        		GlobalWinManger:openWin(WinName.CHAT)
	        else
	        	FunctionOpenManager:showFunctionOpenTips(FunctionOpenType.Chat)
        	end

        	self:setRedPointVisible(GlobalController.chat.chatRedPointIsOpen)
        end     
        return true
    end)

    --私聊红点
    self.topRedPoint = display.newSprite("#scene/scene_redPointPic.png")
    self.topRedPoint:setPosition(36, 36)
    self.topRedPoint:setVisible(false)
    self:addChild(self.topRedPoint)

    if self.chatUpdateEventId == nil then
    	self.chatUpdateEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_UPDATE, handler(self,self.updateChatInfo))
    end
end

function SceneChatBtn:updateChatInfo(data)
	if ChatChannelType.PRIVATE == data.data.channelId then
		self:setRedPointVisible(true)
		if GlobalController.chat.chatWinIsOpen then
		else
			GlobalController.chat.chatRedPointIsOpen = true
		end
	else
		self:setRedPointVisible(GlobalController.chat.chatRedPointIsOpen)
	end
end

function SceneChatBtn:setRedPointVisible(bool)
    self.topRedPoint:setVisible(bool)
end

function SceneChatBtn:hideChatRedPoint(data)
	self:setRedPointVisible(false)
end

-- 销毁
function SceneChatBtn:destory()
	if self.chatUpdateEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.chatUpdateEventId)
		self.chatUpdateEventId = nil
	end
	self:removeSelf()
end

return SceneChatBtn
