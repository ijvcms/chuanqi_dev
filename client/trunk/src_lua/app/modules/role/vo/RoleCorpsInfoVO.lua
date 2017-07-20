--军团信息

RoleCorpsInfoVO = RoleCorpsInfoVO or class("RoleCorpsInfoVO")

function RoleCorpsInfoVO:ctor()
	self.legion_id = 0 			--行会id
	self.legion_name = ""        --行会名称
	self.legion_lv = 0 			--行会等级
	self.position = 0 			--职位 0非会员 1会长 2长老 3 会员
	self.contribution = 0 		--贡献
	self.isInit = false         --有没有初始化
end


function RoleCorpsInfoVO:updateFrom37011(data)
	self.legion_id = data.legion_id
	self.legion_name = data.legion_name 
	self.legion_lv = data.legion_lv or 0
	self.position = data.position
	self.contribution = data.contribution
	self.isInit = true
end