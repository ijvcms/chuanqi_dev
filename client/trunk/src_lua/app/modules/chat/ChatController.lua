--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-11-30 
-- 聊天控制器

require("app.modules.social.FriendManager")
ChatController = ChatController or class("ChatController",BaseController)

local ChatMetadata = import(".model.ChatMetadata")
ChatChannelType = {
	ALL = 1, --"综 合"
	GUILD = 2, --"行 会"
	TEAM = 3, --"队 伍"
	PRIVATE = 4,--"私 聊"
	SYSTEM = 5,--"系 统"
	WORLD = 6,--"世 界"
}
function ChatController:ctor()	
	ChatController.Instance = self
	self.chatWidth = 360
	self:initProtocal()

	self.channelProtocol = {
		[ChatChannelType.ALL] = 18001,
		[ChatChannelType.GUILD] = 18003,
		[ChatChannelType.TEAM] = 18006,
		[ChatChannelType.PRIVATE] = 18002,
		[ChatChannelType.WORLD] = 18001,
		--[7] = 18010,
	}

	--聊天数据显示
	self.chatChannelData = {
        [ChatChannelType.ALL] = {},
        [ChatChannelType.GUILD] = {},
        [ChatChannelType.TEAM] = {},
        [ChatChannelType.PRIVATE] = {},
        [ChatChannelType.SYSTEM] = {},
        [ChatChannelType.WORLD] = {},
        --[7] = {},
    }
    --外面场景上显示
    self.chatOutData = {}
    self.chatNeedRefresh = {}

    self.chatWinIsOpen = false
    self.chatRedPointIsOpen = false
end



function ChatController:getInstance()
	if ChatController.Instance==nil then
		ChatController.new()
	end
	return ChatController.Instance
end

function ChatController:getMetaDataUtil()
	return ChatMetadata
end

-- 追加一条系统消息。
function ChatController:pushSystemMsg(message_text)
	local chatData = {
		--频道id
		channelId = 5,
		--名称
		player_name = "",
		--时间
		time = os.time(),
		--内容
		content = message_text,
		-- id
		player_id = RoleManager:getInstance().roleInfo.player_id,
		guild_id = 0,
		team_id = 0,
	}

	chatData.isLocal = true

	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT, chatData)
end

--添加聊天信息
function ChatController:pushChat(chatData,isLocal,type,sender)
	local chatType
	if type == 2 then
		chatType = ChatMetadata.CHAT_TYPE.CHAT_TALK
	else
		chatType = ChatMetadata.CHAT_TYPE.CHAT_TXT
	end
    local cdv = {chatData = chatData, showWidth = self.chatWidth, showBg = false, showTime = true, chatType = chatType, isLocal = isLocal} 
    table.insert(self.chatChannelData[ChatChannelType.ALL], cdv) --向综合聊天层插入聊天数据
    self:clearChatData(ChatChannelType.ALL,cdv)
	--向对应的单独聊天层插入聊天数据
	if chatData.channelId == 1 then--1 世界  2 公会  3 队伍  4 私聊 5 系统  7军团
		table.insert(self.chatChannelData[ChatChannelType.WORLD], cdv)
		self:clearChatData(ChatChannelType.WORLD,cdv)
	else
		table.insert(self.chatChannelData[chatData.channelId], cdv)
		self:clearChatData(chatData.channelId,cdv)
	end
	
end
--清理多余的数据
function ChatController:clearChatData(curChannel,data)
	local dataList = self.chatChannelData[curChannel]
	if dataList and  #dataList > 40 then
		while #dataList > 12 do
			table.remove(dataList, 1)
		end
		self.chatNeedRefresh[curChannel] = true
	end
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_UPDATE,{data = data,channelId = curChannel,playerId = data.chatData.player_id})
end


function ChatController:pushTeamMsg(message_text)
	local chatData = {
		--频道id
		channelId = 1,
		--名称
		player_name = RoleManager:getInstance().roleInfo.name,
		--时间
		time = os.time(),
		--内容
		content = "<font color='0xff7633' size='18'>"..message_text..ChatMetadata.FormatTeam(RoleManager:getInstance().roleInfo.teamId,"组队").."</font>",
		-- id
		player_id = RoleManager:getInstance().roleInfo.player_id,
		guild_id = RoleManager:getInstance().guildInfo.guild_id,
		team_id = RoleManager:getInstance().roleInfo.teamId,
	}
 
	GameNet:sendMsgToSocket(18001, chatData)
end

function ChatController:callUiInitCompleted()
	GameNet:sendMsgToSocket(18008, {})
end

function ChatController:initProtocal( )
	--世界聊天
	self:registerProtocal(18001,handler(self,self.onHandle18001))
	--私聊
	self:registerProtocal(18002,handler(self,self.onHandle18002))
	--公会聊天
	self:registerProtocal(18003,handler(self,self.onHandle18003))
	--私聊结果通知
	self:registerProtocal(18004,handler(self,self.onHandle18004))
	--语音聊天获取md5和时间戳
	self:registerProtocal(18005,handler(self,self.onHandle18005))
	--组队聊天
	self:registerProtocal(18006,handler(self,self.onHandle18006))
    --聊天历史
	self:registerProtocal(18008,handler(self,self.onHandle18008))
	 --军团聊天
	self:registerProtocal(18010,handler(self,self.onHandle18010))
end

function ChatController:onHandle18001(data)
	print("onHandle18001")
	if FriendManager:getInstance():isBlackListMember(data.player_id) then
		return
	end
	data = data.chat_info
	data.channelId = ChatChannelType.ALL

	self:pushChat(data, data.isLocal)
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT,data)
end

function ChatController:onHandle18002(data)
	print("onHandle18002")
	if FriendManager:getInstance():isBlackListMember(data.player_id) then
		return
	end
	data = data.chat_info
	data.channelId = ChatChannelType.PRIVATE
	self:pushChat(data, data.isLocal)
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT,data)
end

function ChatController:onHandle18003(data)
	print("onHandle18003")
	data = data.chat_info
	data.channelId = ChatChannelType.GUILD
	self:pushChat(data, data.isLocal)
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT,data)
end

function ChatController:onHandle18004(data)
	print("onHandle18004")
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function ChatController:onHandle18005(data)
	print("onHandle18005")
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_MD5_TIME,data)
end

function ChatController:onHandle18006(data)
	print("onHandle18006")
	data = data.chat_info
	data.channelId = ChatChannelType.TEAM
	self:pushChat(data, data.isLocal)
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT,data)
end


function ChatController:onHandle18008(data)
	print("onHandle18008")
	self.chatChannelData = {
        [ChatChannelType.ALL] = {},
        [ChatChannelType.GUILD] = {},
        [ChatChannelType.TEAM] = {},
        [ChatChannelType.PRIVATE] = {},
        [ChatChannelType.SYSTEM] = {},
        [ChatChannelType.WORLD] = {},
        --[7] = {},
    }
	local history = data.chat_info_list
	for _, chatData in ipairs(history) do
		chatData.channelId = ChatChannelType.ALL
		local historyData = {chatData = chatData, showWidth = self.chatWidth, showBg = false, showTime = true, chatType = ChatMetadata.CHAT_TYPE.CHAT_TXT} 
		table.insert(self.chatChannelData[ChatChannelType.ALL], historyData) --向综合聊天层插入聊天数据
		table.insert(self.chatChannelData[ChatChannelType.WORLD], historyData) --向世界聊天层插入聊天数据
	end
	history = data.chat_player_list--私聊
	for _, chatData in ipairs(history) do
		chatData.channelId = ChatChannelType.PRIVATE
		local historyData = {chatData = chatData, showWidth = self.chatWidth, showBg = false, showTime = true, chatType = ChatMetadata.CHAT_TYPE.CHAT_TXT} 
		table.insert(self.chatChannelData[ChatChannelType.PRIVATE], historyData) --向综合聊天层插入聊天数据
	end
	history = data.chat_guild_list--行会
	for _, chatData in ipairs(history) do
		chatData.channelId = ChatChannelType.GUILD
		local historyData = {chatData = chatData, showWidth = self.chatWidth, showBg = false, showTime = true, chatType = ChatMetadata.CHAT_TYPE.CHAT_TXT} 
		table.insert(self.chatChannelData[ChatChannelType.GUILD], historyData) 
	end
	history = data.chat_legion_list--军团
	for _, chatData in ipairs(history) do
		chatData.channelId = 7
		local historyData = {chatData = chatData, showWidth = self.chatWidth, showBg = false, showTime = true, chatType = ChatMetadata.CHAT_TYPE.CHAT_TXT} 
		table.insert(self.chatChannelData[7], historyData) 
	end
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT_HISTORY,data)
end

function ChatController:onHandle18010(data)
	print("onHandle18010")
	data = data.chat_info
	data.channelId = 7
	self:pushChat(data, data.isLocal)
	--GlobalEventSystem:dispatchEvent(ChatEvent.GET_CHAT,data)
end


