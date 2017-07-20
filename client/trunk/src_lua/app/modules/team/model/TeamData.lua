--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-07 14:27:36
--

--[[
	组队数据模型。
]]
local BaseArray = require("common.base.BaseArray")
local TeamData = class("TeamData")

function TeamData:ctor()
	self:initialization()
end

function TeamData:initialization()
	self._options = {}

	--[[
		<Type name="proto_team_member_info" describe="捐献信息">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="name" type="string" describe="玩家姓名"/>
			<Param name="type" type="int8" describe="玩家类型1队长 2队员"/>
			<Param name="lv" type="int8" describe="等级"/>
			<Param name="career" type="int16" describe="职业"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]
	self._teamPlayerList = BaseArray.new()
	self._teamPlayerList:SetEqualseMethod(function(a, b)
		return a.player_id == b.player_id
	end)

	--[[
		<Type name="proto_near_by_team" describe="附近队伍信息(组队系统)">
			<Param name="team_id" type="int64" describe="队伍id"/>
			<Param name="name" type="string" describe="队长姓名"/>
			<Param name="lv" type="int8" describe="队长等级"/>
			<Param name="career" type="int16" describe="队长职业"/>
			<Param name="memeber_num" type="int16" describe="队伍人数"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]
	self._nearTeamList   = BaseArray.new()
	self._nearTeamList:SetEqualseMethod(function(a, b)
		return a.player_id == b.player_id
	end)

	--[[
		<Type name="proto_near_by_player" describe="附近玩家信息(组队系统)">
			<Param name="player_id" type="int64" describe="玩家id"/>
			<Param name="name" type="string" describe="玩家姓名"/>
			<Param name="lv" type="int8" describe="等级"/>
			<Param name="career" type="int16" describe="职业"/>
			<Param name="guild_name" type="string" describe="所在行会名"/>
		</Type>
	]]
	self._nearPlayerList = BaseArray.new()
	self._nearPlayerList:SetEqualseMethod(function(a, b)
		return a.team_id == b.team_id
	end)
end

function TeamData:SetOptionEnabled(option, isEnabled)
	assert(self._options ~= nil, "[TeamData] the data has destory.")
	self._options[option] = isEnabled
end

function TeamData:GetOptionEnabled(option)
	assert(self._options ~= nil, "[TeamData] the data has destory.")
	return self._options[option]
end

function TeamData:GetTeamPlayerList()
	assert(self._teamPlayerList ~= nil, "[TeamData] the data has destory.")
	return self._teamPlayerList
end

function TeamData:GetNearTeamList()
	assert(self._nearTeamList ~= nil, "[TeamData] the data has destory.")
	return self._nearTeamList
end

function TeamData:GetNearPlayerList()
	assert(self._nearPlayerList ~= nil, "[TeamData] the data has destory.")
	return self._nearPlayerList
end

function TeamData:inTeam(player_id)

	for i=1,#self._teamPlayerList do
		if self._teamPlayerList[i].player_id == player_id then
			return true
		end
	end

	return false

end

function TeamData:Destory()
	self._options = nil
	self._teamPlayerList = nil
	self._nearTeamList = nil
	self._nearPlayerList = nil
end

return TeamData