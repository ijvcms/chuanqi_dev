--
-- Author: Yi hanneng
-- Date: 2016-04-14 17:16:29
--
local RankOPList = RankOPList or class("RankOPList", function() return display.newNode()end)

function RankOPList:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)

	self.root = cc.uiloader:load("resui/rankingList.ExportJson")
    self:addChild(self.root)
    self:setContentSize(cc.size(self.root:getContentSize().width, self.root:getContentSize().height))
    self.root:setPosition((display.width - self.root:getContentSize().width)/2,(display.height - self.root:getContentSize().height)/2)
    
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            if not cc.rectContainsPoint(self.root:getBoundingBox(), event) then
                self:setVisible(false)
            end
        end
        return true
    end)
    self:init()
    self:addEvent()
end

function RankOPList:init()
 
    self.btn_friend = cc.uiloader:seekNodeByName(self.root, "btn_friend")
    self.btn_equipment = cc.uiloader:seekNodeByName(self.root, "btn_equipment")
    self.btn_chat = cc.uiloader:seekNodeByName(self.root, "btn_chat")
    self.btn_blacklist = cc.uiloader:seekNodeByName(self.root, "btn_blacklist")

end

function RankOPList:setData(data)
	self.data = data
end

function RankOPList:addEvent()

	self.btn_friend:setTouchEnabled(true)
	self.btn_equipment:setTouchEnabled(true)
	self.btn_chat:setTouchEnabled(true)
	self.btn_blacklist:setTouchEnabled(true)

	self.btn_friend:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_friend:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_friend:setScale(1.0)
            GlobalController.social:sendApplyFriend(self.data.player_id)
        end
        return true
    end)

    self.btn_equipment:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_equipment:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_equipment:setScale(1.0)
            GameNet:sendMsgToSocket(10011, {player_id = self.data.player_id})
        end
        return true
    end)

    self.btn_chat:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_chat:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_chat:setScale(1.0)
            GlobalWinManger:closeWin(GlobalWinManger.curWinTag)
            if GlobalWinManger:getWin(WinName.CHAT) then
                GlobalEventSystem:dispatchEvent(ChatEvent.SET_PRIVATE_CHAT,self.data)
            else
                GlobalWinManger:openWin(WinName.CHAT,{tabIndex = ChatChannelType.PRIVATE,data = self.data})
            end
        end
        return true
    end)

    self.btn_blacklist:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_blacklist:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_blacklist:setScale(1.0)
            GlobalController.social:sendBlackList(self.data.player_id)
        end
        return true
    end)
end
 
return RankOPList