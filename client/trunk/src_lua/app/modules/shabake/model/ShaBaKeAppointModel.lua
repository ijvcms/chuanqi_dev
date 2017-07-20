--
-- Author: Your Name
-- Date: 2015-12-23 09:55:18
--

ShaBaKeAppointModel = ShaBaKeAppointModel or class("ShaBaKeAppointModel")

function ShaBaKeAppointModel:ctor()
	self.guild_member_list = {}
	self.city_officer_list = {}
	self.min_value = 0
	self.min_value = 0
	self.officer_id = 0
	self.targetPlayerId = 0
	self.member_num = 0
end
--guild_member_list
function ShaBaKeAppointModel:setData(data)
	self.min_value = data.min_value
	self.min_value = data.min_value
	self.city_officer_list = data.city_officer_list
	self.guild_member_list = data.guild_member_list
	self.member_num = data.member_num
end
