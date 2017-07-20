--
-- Author: Yi hanneng
-- Date: 2016-03-29 15:53:57
--
 local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local TeamNavView = TeamNavView or class("TeamNavView", BaseView)

function TeamNavView:ctor(width,height)

	self.width = width
	self.height = height
	self.itemList = {}
 
 	self.ListView = SCUIList.new {
        viewRect = cc.rect(0,0,width, height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self):pos(0, 0)
 

	self:open()
 
end

function TeamNavView:open()
	 GlobalEventSystem:addEventListener(TeamEvent.NAV_UPDATE,handler(self,self.setData))
	 GlobalController.team:RefreshMyTeamInfo()
end

function TeamNavView:close()
	 GlobalEventSystem:removeEventListener(TeamEvent.NAV_UPDATE)
	 self:clearTimer()
end

function TeamNavView:destory()
	self:close()
	self.super.destory(self)
end
 
function TeamNavView:setData(data)
 
 	data = data.data

 	if #self.itemList > 0 and self.ListView ~= nil then
 		self.itemList = {}
 		self.ListView:removeAllItems()
 		self:clearTimer()
 	end

 	self.isLeader = false
 
 	local i = 1
 	if #data.member_list == 0 then

 		local item = self.ListView:newItem()
		local content = require("app.modules.team.view.TeamNavItem").new()
		item:addContent(content)
		content:setData({none = 1})
        item:setItemSize(self.width - 4,58)
		--self.itemList[#self.itemList+1] = content
		table.insert(self.itemList, content)
		self.ListView:addItem(item)	
		self.ListView:reload()
 
 	else
 	 
 	 	for i=1,#data.member_list do

 	 		local item = self.ListView:newItem()
			local content = require("app.modules.team.view.TeamNavItem").new()
			item:addContent(content)
			content:setData(data.member_list[i])
	        item:setItemSize(self.width - 4,58)
			--self.itemList[#self.itemList+1] = content
			table.insert(self.itemList, content)
			self.ListView:addItem(item)	
			self.ListView:reload()
 
  	 		if data.member_list[i].type == 1 and tonumber(data.member_list[i].player_id) == tonumber(RoleManager:getInstance().roleInfo.player_id) then
 	 			self.isLeader = true
 	 		end
 	 
	 	end

	 	if self.isLeader then
 
	 		for i=5,#data.member_list + 1,-1 do
 				local item = self.ListView:newItem()
				local content = require("app.modules.team.view.TeamNavItem").new()
				content:setItemClick(handler(self, self.openInviteView))
				item:addContent(content)
				content:setData({none = 2})
		        item:setItemSize(self.width - 4,58)
				--self.itemList[#self.itemList+1] = content
				table.insert(self.itemList, content)
				self.ListView:addItem(item)	
				self.ListView:reload()
 			end
 		 
	 	end

	 	self:startTimer()

 	end

end
 
function TeamNavView:findPos(item)
	if self.itemList then
	for i=1,#self.itemList do
		if item == self.itemList[i] then
			return i
		end
	end
	end
	return #self.itemList
end

 

function TeamNavView:touchListener(event)
    local listView = event.listView

    if "clicked" == event.name then
    	GlobalWinManger:openWin(WinName.TEAMWIN)
    	--[[
        local item =self.itemList[event.itemPos]
        print("=========>")
        if item ~= nil and item.data ~= nil then
        	local data  = item:getData()
 
        end
        --]]
    elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function TeamNavView:getItemById(id)
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil then
				if self.itemList[i]:getData() and self.itemList[i]:getData().id == id then
					return self.itemList[i]
				end
			end
		end
	end
	return nil
end

function TeamNavView:removeItemById(id)
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil then
				if self.itemList[i]:getData() and self.itemList[i]:getData().id == id then
					table.remove(self.itemList,i)
					break 
				end
			end
		end
	end
end

function TeamNavView:findMainTaskData()
	if self.itemList then
		for i=1,#self.itemList do
			if self.itemList[i] ~= nil and self.itemList[i]:getData() and self.itemList[i]:getData().type == 1 then
				return self.itemList[i]:getData()
			end
		end
	end

	return nil
end
 
function  TeamNavView:openInviteView()
	local TeamInviteView = require("app.modules.team.view.TeamInviteView").new()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,TeamInviteView)
end


function TeamNavView:onTimerHandler()
 
	if tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 then
		local item
		for i=1,#self.itemList do
			item = self.itemList[i]
			for k,v in pairs(GameSceneModel.playerVOArr) do
	 
				if item:getData().player_id == v.id then
					item:setHp(v.hp/v.hp_limit)
				end
			end
		end

	else
		self:clearTimer()
	end
	 
end

function TeamNavView:startTimer()
	self:clearTimer()
 
	if tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 then
		self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 2)
		self:onTimerHandler()
	end
end	

function TeamNavView:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

return TeamNavView