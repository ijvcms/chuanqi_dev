--
-- Author: Yi hanneng
-- Date: 2016-03-30 09:29:34
--

--[[
－－－－－－－－－－－－组队邀请界面－－－－－－－－－－－－－－－
--]]
local TeamInviteView = TeamInviteView or class("TeamInviteView", function() return display.newNode()end)

function TeamInviteView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/teamInvite.ExportJson")
  	self:addChild(self.ccui)
   	--self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))

   	local size = self.ccui:getContentSize()
  	self.ccui:setPosition((display.width - size.width)/2,(display.height - size.height)/2)
  	
   	self:init()
   
end

function TeamInviteView:init()
	
	self.itemList = {}

	self.ListView = SCUIList.new {
        viewRect = cc.rect(0,0,567, 315),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --:onTouch(handler(self, self.touchListener))
        :addTo(self.ccui):pos(180, 106)
        
	self.btnList = {}
	self.btnList[1] = cc.uiloader:seekNodeByName(self.ccui, "btnFriend")
	self.btnList[2] = cc.uiloader:seekNodeByName(self.ccui, "btnUnion")
	self.btnList[3] = cc.uiloader:seekNodeByName(self.ccui, "btnNear")
	self.btnList[4] = cc.uiloader:seekNodeByName(self.ccui, "btnGroup")
	self.btnSend = cc.uiloader:seekNodeByName(self.ccui, "btnSend")
	self.btnClose = cc.uiloader:seekNodeByName(self.ccui, "btnClose")
	self.btnRefresh = cc.uiloader:seekNodeByName(self.ccui, "btnRefresh")
	self.power = cc.uiloader:seekNodeByName(self.ccui, "power")
	self.noLabel = cc.uiloader:seekNodeByName(self.ccui, "noLabel")
	self.noLabel:setVisible(false)
	self.lastClickItem = nil

	self.btnSend:setTouchEnabled(true)
	self.btnClose:setTouchEnabled(true)
	self.btnRefresh:setTouchEnabled(true)

	for i=1,#self.btnList do
		
		self.btnList[i]:setTouchEnabled(true)
		self.btnList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
             
        elseif event.name == "ended" then
            if self.lastClickItem ~= nil then
            	self.lastClickItem:setSpriteFrame("com_labBtn4.png")
            end

            self.btnList[i]:setSpriteFrame("com_labBtn4Sel.png")
        	
        	self.lastClickItem  = self.btnList[i]
        	self:btnTag(i)
        end     
		return true
	    end)
  	end

    self.btnSend:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnSend:setScale(1.1)
        elseif event.name == "ended" then
            self.btnSend:setScale(1)
 			--打开界面
	 		local TeamSendView = require("app.modules.team.view.TeamSendView").new()
	  		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,TeamSendView)  
 
        end
        return true
    end)

    self.btnClose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnClose:setScale(1.1)
        elseif event.name == "ended" then
            self.btnClose:setScale(1)
 			self:close()
        end
        return true
    end)
--刷新
    self.btnRefresh:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRefresh:setScale(1.1)
        elseif event.name == "ended" then
            self.btnRefresh:setScale(1)
 			self:refreshInfo(self.currentIndex)
        end
        return true
    end)
 
    self:open()

end

function TeamInviteView:btnTag(index)
	self.currentIndex = index
--1:请求好友。2:请求行会。3:请求附近玩家。4:军团
	if index == 1 then
		GameNet:sendMsgToSocket(24000,{type = 1})
		self.power:setString("战斗力")
	elseif index == 2 then
 		self.power:setString("战斗力")
		if tonumber(RoleManager:getInstance().guildInfo.guild_id) == 0 then
			if self.itemList and #self.itemList > 0 then
				self.ListView:removeAllItems()
				self.itemList = {}
			end
			self.noLabel:setVisible(true)
			self.noLabel:setString("您当前没有行会，去加入行会或创建一个行会吧。")
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"你还没有加入行会！")
			return 
		end
		GameNet:sendMsgToSocket(17012, {min_value=1,max_value=50})
	elseif index == 3 then
		GlobalController.team:RefreshNearPlayerList()
		self.power:setString("行会")
	elseif index== 4 then
		self.power:setString("战斗力")
		if tonumber(RoleManager:getInstance().corpsInfo.legion_id) == 0 then
			if self.itemList and #self.itemList > 0 then
				self.ListView:removeAllItems()
				self.itemList = {}
			end
			self.noLabel:setVisible(true)
			self.noLabel:setString("尚未加入跨服军团，赶紧申请一个吧。")
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"你还没有加入军团！")
			return 
		end
		GameNet:sendMsgToSocket(37012, {min_value=1,max_value=50})
	end
end

function TeamInviteView:setViewInfo(data)
 
	if data == nil or data.data == nil then
		return 
	end
	if self.itemList and #self.itemList > 0 then
		self.ListView:removeAllItems()
		self.itemList = {}
	end
	data = data.data
	local playerId = 1
	for i=1,#data do

		if data[i].player_id then
			playerId = data[i].player_id
		elseif data[i].tplayer_id then
			playerId = data[i].tplayer_id
		end

		if not GlobalController.team._teamData:inTeam(playerId) and playerId ~= RoleManager:getInstance().roleInfo.player_id then
 
	    	local item = self.ListView:newItem()
			local content = require("app.modules.team.view.TeamInviteItem").new()
			content:setData(data[i])
			content:setItemClickFunc(handler(self, self.invite))
			item:addContent(content)
	        item:setItemSize(content:getContentSize().width, content:getContentSize().height)
			--self.itemList[#self.itemList+1] = content
			table.insert(self.itemList, content)
			self.ListView:addItem(item)	
		end
    end
    if #data == 0 then
   		
   		if self.noLabel ~= nil  then
   			 
	    	self.noLabel:setVisible(true)
	    	 
			if self.currentIndex == 1 then
				self.noLabel:setString("当前没有符合条件的好友，去多加点好友吧。")
			elseif self.currentIndex == 2 then
		 		self.noLabel:setString("您当前没有行会，去加入行会或创建一个行会吧。")
			elseif self.currentIndex == 3 then
				self.noLabel:setString("当前场景没有符合条件的玩家，您可以去其他场景试试。")
			elseif self.currentIndex == 4 then
				self.noLabel:setString("尚未加入跨服军团，赶紧申请一个吧。")
			end

		end

	else
		self.noLabel:setVisible(false)
		self.ListView:reload()
    end

end

function TeamInviteView:invite(data)
	if data.tplayer_id then
		GlobalController.team:InvitePlayer(data.tplayer_id)
	else
		GlobalController.team:InvitePlayer(data.player_id)
	end
	
end

function TeamInviteView:refreshInfo(index)
	self:btnTag(self.currentIndex)
end
 
function TeamInviteView:open()
 
	GlobalEventSystem:addEventListener(TeamEvent.GET_FRIEND_LIST,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(TeamEvent.GET_GUILD_MEMBER_LIST,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(TeamEvent.GET_CORPS_MEMBER_LIST,handler(self,self.setViewInfo))
	GlobalEventSystem:addEventListener(TeamEvent.GET_NEAR_PALER_LIST,handler(self,self.setViewInfo))

	self.btnList[1]:setSpriteFrame("com_labBtn4Sel.png")	
    self.lastClickItem  = self.btnList[1]
    self:btnTag(1)

end

function TeamInviteView:close()

	GlobalEventSystem:removeEventListener(TeamEvent.GET_FRIEND_LIST)
	GlobalEventSystem:removeEventListener(TeamEvent.GET_GUILD_MEMBER_LIST)
	GlobalEventSystem:removeEventListener(TeamEvent.GET_CORPS_MEMBER_LIST)
	GlobalEventSystem:removeEventListener(TeamEvent.GET_NEAR_PALER_LIST)
	self:removeSelf()
end

return TeamInviteView