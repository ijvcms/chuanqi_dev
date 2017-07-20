--
-- Author: Yi hanneng
-- Date: 2016-03-30 10:12:34
--

local TeamOperationMenu = TeamOperationMenu or class("TeamOperationMenu", function() return display.newNode()end)

function TeamOperationMenu:ctor()

    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/teamList.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            if not cc.rectContainsPoint(self.ccui:getBoundingBox(), event) then
                self:setVisible(false)
            end
        end
        return true
    end)
   	self:init()
end

function TeamOperationMenu:init()

	self.btn_friend = cc.uiloader:seekNodeByName(self.ccui, "btn_friend")
	self.btn_equitment = cc.uiloader:seekNodeByName(self.ccui, "btn_equitment")
	self.btn_turnLeader = cc.uiloader:seekNodeByName(self.ccui, "btn_turnLeader")

	self.btn_chat = cc.uiloader:seekNodeByName(self.ccui, "btn_chat")
	self.btn_kick = cc.uiloader:seekNodeByName(self.ccui, "btn_kick")
 

	self.btn_friend:setTouchEnabled(true)
	self.btn_equitment:setTouchEnabled(true)
	self.btn_turnLeader:setTouchEnabled(true)
	self.btn_chat:setTouchEnabled(true)
	self.btn_kick:setTouchEnabled(true)

	self.btn_friend:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_friend:setScale(1.1)
        elseif event.name == "ended" then
            self.btn_friend:setScale(1)
 			self:addFriend(self.data)
        end
        return true
    end)

    self.btn_equitment:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_equitment:setScale(1.1)
        elseif event.name == "ended" then
            self.btn_equitment:setScale(1)
 			self:checkEquip(self.data)
        end
        return true
    end)

    self.btn_turnLeader:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_turnLeader:setScale(1.1)
        elseif event.name == "ended" then
            self.btn_turnLeader:setScale(1)
 			self:changeLeader(self.data)
        end
        return true
    end)

    self.btn_chat:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_chat:setScale(1.1)
        elseif event.name == "ended" then
            self.btn_chat:setScale(1)
 			self:talk(self.data)
        end
        return true
    end)

    self.btn_kick:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_kick:setScale(1.1)
        elseif event.name == "ended" then
            self.btn_kick:setScale(1)
 			self:DismissPlayer(self.data)
        end
        return true
    end)
end

function TeamOperationMenu:setData(data)
    self.data = data

    -- 如果我没有加入任何一个队伍，则不继续往下处理。
    if not GlobalController.team:HasTeam() then
        
        return
    end

    -- 检查是否为队长，开放对应的按钮。
    local myPlayerId = RoleManager:getInstance().roleInfo.player_id
    local isTeamLead = GlobalController.team:IsTeamLead(myPlayerId)
 
    if isTeamLead then
        self.btn_turnLeader:setButtonEnabled(true)
        self.btn_kick:setButtonEnabled(true)
    else
        self.btn_turnLeader:setButtonEnabled(false)
        self.btn_kick:setButtonEnabled(false)
         
    end
 
end

function TeamOperationMenu:addFriend(data)
	GameNet:sendMsgToSocket(24003, {tplayerId = data.player_id})
end

function TeamOperationMenu:checkEquip(data)
    GameNet:sendMsgToSocket(10011, {player_id = data.player_id})
end

function TeamOperationMenu:changeLeader(data)
	GlobalController.team:TransferLeadToPlayer(data.player_id)
end

function TeamOperationMenu:talk(data)
	GlobalWinManger:closeWin(GlobalWinManger.curWinTag)
    if GlobalWinManger:getWin(WinName.CHAT) then
        GlobalEventSystem:dispatchEvent(ChatEvent.SET_PRIVATE_CHAT,data)
    else
        GlobalWinManger:openWin(WinName.CHAT,{tabIndex = ChatChannelType.PRIVATE,data = data})
    end
end

function TeamOperationMenu:DismissPlayer(data)
	GlobalController.team:DismissPlayer(data.player_id)
end

function TeamOperationMenu:setPosition(x, y)

    if self.ccui then
        self.ccui:setPosition(x, y)
    end
end

return TeamOperationMenu