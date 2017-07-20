
RoleGuildInfoVO = RoleGuildInfoVO or class("RoleGuildInfoVO")

function RoleGuildInfoVO:ctor()
	self.guild_id = 0 			--行会id
	self.guild_name = ""        --行会名称
	self.guild_lv = 0 			--行会等级
	self.position = 0 			--职位 0非会员 1会长 2长老 3 会员
	self.contribution = 0 		--贡献
	self.isInit = false         --有没有初始化

	self.union = {}             --结盟列表
	self.unionInfo = {}             --结盟详细信息列表
end

function RoleGuildInfoVO:isUnion(guildId)
	for i=1,#self.union do
		if self.union[i] == guildId then
			return true
		end
	end
	return false;
end

function RoleGuildInfoVO:updateFrom17011(data)
	self.guild_id = data.guild_id
	self.guild_name = data.guild_name 
	self.guild_lv = data.guild_lv or 0
	self.position = data.position
	self.contribution = data.contribution
	self.isInit = true
end