--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-06 15:07:53
--
module(..., package.seeall)


CHAT_TYPE = {
	
	CHAT_TXT = "CHAT_TXT", -- 文字
	CHAT_TALK = "CHAT_TALK", --语音

}

ChatChannelName = {
	[1] = "世界",
	[2] = "行会",
	[3] = "组队",
	[4] = "私聊",
	[5] = "系统",
--	[7] = "军团",
}

ChannelNameColorHex = {
	[1] = "0x6fc491",
	[2] = "0xecb74c",
	[3] = "0x9bc6d4",
	[4] = "0xff65e7",
	[5] = "0xff0000",
--	[7] = "0xff6407",
}

--1白色 2绿色 3蓝色 4紫色 5橙色 6红色
ChatEquiColor = 
{
	[1] = "0xede3d2",
	[2] = "0x66db57",
	[3] = "0x9bc6d4",
	[4] = "0xff65e7",
	[5] = "0xff763a",
	[6] = "0xeb0c0c",
}

local TEMPLATE_CHANNEL_NAME = "<font color='%s' size='18'>[%s]</font>"

local TEMPLATE_ME_TO_OTHER  = "我对<font color='0xff7633' eventType='1' eventParam='player_id=%s%%%%player_name=%s%%%%teamId=%s%%%%guild_id=%s'>%s</font>说"
local TEMPLATE_OTHER_TO_ME  = "<font color='0xff7633' eventType='1' eventParam='player_id=%s%%%%player_name=%s%%%%teamId=%s%%%%guild_id=%s'>%s</font>对我说"
local TEMPLATE_BROADCAST    = "<font color='0xff7633' eventType='1' eventParam='player_id=%s%%%%player_name=%s%%%%teamId=%s%%%%guild_id=%s'>%s</font>"

local TEMPLATE_SEND_TIME    = "<font color='0xff7633'>%s  </font>"
--local TEMPLATE_CONTENT      = "<font color='0xffd3af' size='18'>%s%s%s%s<br gap='5' />%s</font>"
local TEMPLATE_CONTENT_HEAD      = "<font color='0xffd3af' size='18'>%s%s%s%s</font>"
local TEMPLATE_CONTENT      = "<font color='0xffd3af' size='18'>%s</font>"
local TEMPLATE_FACE	 		= "<IMG path='#%s' WIDTH = '33' HEIGHT = '33'/>"

local TEMPLATE__EQU_BROADCAST    = "<font color='%s' eventType='2' eventParam='data=%s'>[%s]</font>"

local TEMPLATE__TEAM_BROADCAST    = "<font color='0x00ff00' eventType='3' eventParam='teamId=%s'>[%s]</font>"
--
-- 格式化频道名称
-- @param channel_id 频道id
--
function FormatTitleChannelName(channel_id)
	return string.format(TEMPLATE_CHANNEL_NAME, ChannelNameColorHex[channel_id], ChatChannelName[channel_id])
end

--
-- 格式化VIP等级
-- @param vip_lv VIP等级
--
function FormatTitleVipLevel(vip_lv)
	return ""
end
--
-- 格式化消息头玩家名称
-- @param nameStyle 样式1 = 默认样式， 样式2 = 我对别人说， 样式3 = 别人对我说
-- @param player_id 玩家的id
-- @param player_name 玩家名称
--
function FormatTitleUserName(nameStyle, player_id, player_name, teamId, guild_id)

	local template = TEMPLATE_BROADCAST
	if nameStyle == 1 then
		-- Default value
	elseif nameStyle == 2 then
		template = TEMPLATE_ME_TO_OTHER
	elseif nameStyle == 3 then
		template = TEMPLATE_OTHER_TO_ME
	end
	return string.format(template, player_id, player_name, teamId, guild_id, player_name)
end

--
-- 格式化消息头发送时间
--
function FormatTitleTime(time)
	return string.format(TEMPLATE_SEND_TIME, os.date("%H:%M", time))
end

--
-- 格式化消息内容
--
function FormatMessageContent(chatData)
	-- 这里格式化。。 装备信息、表情等。。
	if chatData.channelId == 5 then
		if chatData.content then
	 		local start,send = string.find(chatData.content,">")
	 		chatData.content = string.sub(chatData.content,send+1)
	 		chatData.content = "<font color='0xffd3af' size='18'>"..chatData.content
	 		return chatData.content
 		end
 		return ""
 	end

	return string.format(TEMPLATE_CONTENT, chatData.content)
end

function FormatFace(face)
	return string.format(TEMPLATE_FACE, face)
end

function FormatTeam(teamId,str)
	return string.format(TEMPLATE__TEAM_BROADCAST, teamId,str)
end

function FormatEqui(Quality,name,data)
	return string.format(TEMPLATE__EQU_BROADCAST,ChatEquiColor[Quality],data,name)
end

--
-- 根据消息数据格式化出一个完整的XML格式字符。
--
function FormatMessageByChatData(chatData, isLocal)
	--return FormatMessageHeadByChatData(chatData,isLocal).."<br gap='5' />"..FormatMessageContent(chatData)
	return FormatMessageHeadByChatData(chatData,isLocal).."<br/>"..FormatMessageContent(chatData)
end

function FormatMessageHeadByChatData(chatData, isLocal)
	local nameStyle = 1

	if isLocal and chatData.channelId ~= 5 then
		nameStyle = 2
	else
		if chatData.channelId == 4 then nameStyle = 3 end
	end

	local __channelNamme = FormatTitleChannelName(chatData.channelId)
	local __vipLv        = FormatTitleVipLevel(chatData.vip)
	local __userName     = FormatTitleUserName(nameStyle, chatData.player_id, chatData.player_name,chatData.team_id,chatData.guild_id)
	local __sendTime     = FormatTitleTime(chatData.time)
 
	return string.format(TEMPLATE_CONTENT_HEAD, __channelNamme, __vipLv, __userName, __sendTime)
end
