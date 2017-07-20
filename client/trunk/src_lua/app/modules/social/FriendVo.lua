--
-- Author: Your Name
-- Date: 2015-12-17 16:22:32
--
FriendVo = FriendVo or class("FriendVo")

function FriendVo:ctor(data)

	self.playerId = data.tplayer_id
	self.name = data.name
	self.lv = data.lv
				--职业
	if data.career == 1000 then
		self.career = "战士"
	elseif data.career == 2000 then
		self.career = "法师"
	elseif data.career == 3000 then
		self.career = "道士"
	end
	self.fight = data.fight				--战力
	self.isonline = data.isonline			--是否在线 1:在线 0:不在线
	self.lastOfflineTime = data.last_offline_time  	--最后离线时间

end
