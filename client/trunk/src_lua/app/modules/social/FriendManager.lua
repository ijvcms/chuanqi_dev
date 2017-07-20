--
-- Author: Your Name
-- Date: 2015-12-17 14:43:37
--
 

require("app.modules.social.FriendVo")
FriendManager = FriendManager or class("FriendManager", BaseManager)

function FriendManager:ctor()
	FriendManager.instance = self
	self.goodFriendList = {}
	self.applyList = {}
	self.blackList = {}
	self.enemyList = {}
	self.goodFriendNum = 0
	self.hasApply = 0
end

function FriendManager:getInstance()

	if FriendManager.instance == nil then
		FriendManager.new()
	end

	return FriendManager.instance
end

function FriendManager:handlerInfo(data)
 
	if data.type == 1 then
		GlobalEventSystem:dispatchEvent(TeamEvent.GET_FRIEND_LIST,data.relationship_list)
		self:handlerGoodFriendList(data.relationship_list)
	elseif data.type == 2 then
		--self:handlerApplyList(data.relationship_list)
	elseif data.type == 3 then
		self:handlerBlackList(data.relationship_list)
	elseif data.type == 4 then
		self:handlerEnemyList(data.relationship_list)
	end
end

function FriendManager:handlerUpdate(data, flag)

	if data.type == 1 then
		if flag  == 1 then
			local fvo = FriendVo.new(data.relationship_list[1])
			table.insert(self.goodFriendList,fvo)

		elseif flag  == 0 then
			for i=1,#self.goodFriendList do
				if data.tplayer_id == self.goodFriendList[i].playerId then
					table.remove(self.goodFriendList, i)
					break
				end
			end
			 
		end
		self.goodFriendNum = #self.goodFriendList
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.goodFriendList, friendNum = self.goodFriendNum})
	elseif data.type == 3 then
		
		for i=1,#self.blackList do
			if data.tplayer_id == self.blackList[i].playerId then
				table.remove(self.blackList, i)
				break
			end
		end
 
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.blackList, friendNum = self.goodFriendNum})
	elseif data.type == 4 then
		if flag  == 1 then
			local fvo = FriendVo.new(data.relationship_list[1])
			table.insert(self.enemyList,fvo)

		elseif flag  == 0 then

			for i=1,#self.enemyList do
				if data.tplayer_id == self.enemyList[i].playerId then
					table.remove(self.enemyList, i)
					break
				end
			end

		end
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.enemyList, friendNum = self.goodFriendNum})
	end

end

function FriendManager:handlerGoodFriendList(data)
	if data ~= nil then
		self.goodFriendList = {}
		for i=1,#data do
			local fvo = FriendVo.new(data[i])
			table.insert(self.goodFriendList,fvo)
		end

		self.goodFriendNum = #self.goodFriendList
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.goodFriendList, friendNum = self.goodFriendNum})
	end
end

function FriendManager:handlerApplyList(data)
 
	if data ~= nil then

		local fvo = {playerId = data.tplayer_id, name = data.tname}
		table.insert(self.applyList,fvo)

	end
 	
 	self:getOneApply()
end

function FriendManager:getOneApply()
	if self.applyList and  #self.applyList > 0 then
		if self.hasApply == 1 then
			return
		end
		local vo = self.applyList[1]
		self.applyList[1] = nil
		if GlobalController.fight:getScene().loading then
			self.eventForNewTrade = nil 
			local function onShow()
				SystemNotice:newFriendNotice(vo.playerId,vo.name)
				GlobalEventSystem:removeEventListenerByHandle(self.eventForNewTrade)
				self.eventForNewTrade = nil 
			end
			self.eventForNewTrade = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
		else
			SystemNotice:newFriendNotice(vo.playerId,vo.name)
		end
	end
end

function FriendManager:handlerBlackList(data)
	if data ~= nil then
		self.blackList = {}
		for i=1,#data do
			local fvo = FriendVo.new(data[i])
			table.insert(self.blackList,fvo)
		end
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.blackList, friendNum = self.goodFriendNum})
	end
end

function FriendManager:handlerEnemyList(data)
	if data ~= nil then
		self.enemyList = {}
		for i=1,#data do
			local fvo = FriendVo.new(data[i])
			table.insert(self.enemyList,fvo)
		end
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_GETLIST, {list = self.enemyList, friendNum = self.goodFriendNum})
	end
end

function FriendManager:isBlackListMember(playerId)
 
	if self.blackList and playerId ~= 0 then
		for i=1,#self.blackList do
			if playerId == self.blackList[i].playerId then
				return true
			end
		end
	end

	return false
end