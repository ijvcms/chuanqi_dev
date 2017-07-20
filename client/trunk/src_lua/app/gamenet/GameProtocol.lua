-- 自动生成，请勿修改 
-- shine 时间：2017/03/14

local GameProtocol = class("GameProtocol")
function GameProtocol:ctor()
    self.dataStruct={

	C_9000 = function(data, buffer) return 0 end,
	C_9001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_9002 = function(data, buffer) return 0 end,
	C_10000 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.open_id, buffer)
		buffer:writeShort(data.platform)
		totleLen = totleLen + 2
		buffer:writeShort(data.server_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_10001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.open_id, buffer)
		buffer:writeShort(data.platform)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.server_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_10002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.open_id, buffer)
		buffer:writeShort(data.platform)
		totleLen = totleLen + 2
		buffer:writeChar(data.os_type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10003 = function(data, buffer) return 0 end,
	C_10005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10006 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.client_time)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_10007 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.flag)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.pk_mode)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_10010 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.caster_name, buffer)
		return totleLen
	end,
	C_10011 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_10012 = function(data, buffer) return 0 end,
	C_10013 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.subtype)
		totleLen = totleLen + 2
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10014 = function(data, buffer) return 0 end,
	C_10015 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_10016 = function(data, buffer) return 0 end,
	C_10017 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.push_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeInt(data.push_list[i])
			totleLen = totleLen + 4
		end
		return totleLen
	end,
	C_10018 = function(data, buffer) return 0 end,
	C_10099 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.open_id, buffer)
		buffer:writeShort(data.platform)
		totleLen = totleLen + 2
		buffer:writeChar(data.os_type)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.key, buffer)
		return totleLen
	end,
	C_11001 = function(data, buffer) return 0 end,
	C_11002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.direction)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_point", data.begin_point, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.end_point, buffer)
		return totleLen
	end,
	C_11003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.direction)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_point", data.point, buffer)
		return totleLen
	end,
	C_11006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.drop_id, buffer)
		return totleLen
	end,
	C_11009 = function(data, buffer) return 0 end,
	C_11010 = function(data, buffer) return 0 end,
	C_11013 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11014 = function(data, buffer) return 0 end,
	C_11016 = function(data, buffer) return 0 end,
	C_11018 = function(data, buffer) return 0 end,
	C_11019 = function(data, buffer) return 0 end,
	C_11021 = function(data, buffer) return 0 end,
	C_11022 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11024 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11025 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_11026 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.guide_step_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_11031 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11032 = function(data, buffer) return 0 end,
	C_11033 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11034 = function(data, buffer) return 0 end,
	C_11035 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11037 = function(data, buffer) return 0 end,
	C_11038 = function(data, buffer) return 0 end,
	C_11039 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.line)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11040 = function(data, buffer) return 0 end,
	C_11043 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_11044 = function(data, buffer) return 0 end,
	C_11045 = function(data, buffer) return 0 end,
	C_11046 = function(data, buffer) return 0 end,
	C_11047 = function(data, buffer) return 0 end,
	C_11048 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_11050 = function(data, buffer) return 0 end,
	C_11051 = function(data, buffer) return 0 end,
	C_11053 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.top)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_11054 = function(data, buffer) return 0 end,
	C_11055 = function(data, buffer) return 0 end,
	C_11060 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_11061 = function(data, buffer) return 0 end,
	C_11103 = function(data, buffer) return 0 end,
	C_11104 = function(data, buffer) return 0 end,
	C_11105 = function(data, buffer) return 0 end,
	C_12001 = function(data, buffer) return 0 end,
	C_12002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.direction)
		totleLen = totleLen + 1
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.target_type)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.target_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.target_point, buffer)
		return totleLen
	end,
	C_12004 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_12005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.pos)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_12006 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_12007 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.switch)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_12008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_12009 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_12010 = function(data, buffer) return 0 end,
	C_13001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_13002 = function(data, buffer) return 0 end,
	C_13003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.caster_flag, buffer)
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self:writeDataPacket("proto_point", data.target_point, buffer)
		len=#data.target_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_obj_flag")
		for i=1,len do
			totleLen = totleLen + fun(data.target_list[i], buffer)
		end
		return totleLen
	end,
	C_13006 = function(data, buffer) return 0 end,
	C_13007 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_13008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_13009 = function(data, buffer) return 0 end,
	C_13010 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.times)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_13011 = function(data, buffer) return 0 end,
	C_13012 = function(data, buffer) return 0 end,
	C_13013 = function(data, buffer) return 0 end,
	C_13014 = function(data, buffer) return 0 end,
	C_13015 = function(data, buffer) return 0 end,
	C_13020 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.fire_wall_attack_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_fire_wall_attack")
		for i=1,len do
			totleLen = totleLen + fun(data.fire_wall_attack_list[i], buffer)
		end
		return totleLen
	end,
	C_13022 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.chapter)
		totleLen = totleLen + 2
		buffer:writeChar(data.step)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_13024 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_13025 = function(data, buffer) return 0 end,
	C_14001 = function(data, buffer) return 0 end,
	C_14003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14004 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.quality)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14005 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.goods_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self.wiriteString
		for i=1,len do
			totleLen = totleLen + fun(data.goods_list[i], buffer)
		end
		return totleLen
	end,
	C_14006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14007 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_14008 = function(data, buffer) return 0 end,
	C_14009 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14010 = function(data, buffer) return 0 end,
	C_14020 = function(data, buffer) return 0 end,
	C_14022 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.grid)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14023 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.grid)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14024 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		len=#data.goods_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeInt(data.goods_list[i])
			totleLen = totleLen + 4
		end
		return totleLen
	end,
	C_14025 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.id_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self.wiriteString
		for i=1,len do
			totleLen = totleLen + fun(data.id_list[i], buffer)
		end
		return totleLen
	end,
	C_14026 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14027 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14028 = function(data, buffer) return 0 end,
	C_14029 = function(data, buffer) return 0 end,
	C_14030 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14031 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.formula_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_14032 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		len=#data.devour_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self.wiriteString
		for i=1,len do
			totleLen = totleLen + fun(data.devour_list[i], buffer)
		end
		return totleLen
	end,
	C_14033 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.idA, buffer)
		totleLen = totleLen + self.wiriteString(data.idB, buffer)
		return totleLen
	end,
	C_14034 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_14035 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.formula_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_14036 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14037 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.goods_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self.wiriteString
		for i=1,len do
			totleLen = totleLen + fun(data.goods_list[i], buffer)
		end
		return totleLen
	end,
	C_14038 = function(data, buffer) 
		local totleLen, len = 0, 0
		len=#data.quality_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeChar(data.quality_list[i])
			totleLen = totleLen + 1
		end
		return totleLen
	end,
	C_14040 = function(data, buffer) return 0 end,
	C_14042 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14043 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_14044 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14045 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.idA, buffer)
		totleLen = totleLen + self.wiriteString(data.idB, buffer)
		return totleLen
	end,
	C_14046 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14047 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeChar(data.baptize_id)
		totleLen = totleLen + 1
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14048 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeChar(data.count)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14049 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14050 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.idA, buffer)
		totleLen = totleLen + self.wiriteString(data.idB, buffer)
		return totleLen
	end,
	C_14051 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_14053 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_14054 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.mark_type)
		totleLen = totleLen + 2
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_14055 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.mark_type)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_15001 = function(data, buffer) return 0 end,
	C_15003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_15004 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_16001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_16002 = function(data, buffer) return 0 end,
	C_16003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_16004 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_16005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeChar(data.pos)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_16100 = function(data, buffer) return 0 end,
	C_16101 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.mystery_shop_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_16102 = function(data, buffer) return 0 end,
	C_17001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeChar(data.is_jade)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		return totleLen
	end,
	C_17003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_17004 = function(data, buffer) return 0 end,
	C_17005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_17006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		return totleLen
	end,
	C_17007 = function(data, buffer) return 0 end,
	C_17008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_17009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17010 = function(data, buffer) return 0 end,
	C_17011 = function(data, buffer) return 0 end,
	C_17012 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_17013 = function(data, buffer) return 0 end,
	C_17014 = function(data, buffer) return 0 end,
	C_17015 = function(data, buffer) return 0 end,
	C_17016 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_17017 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_17018 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_17019 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17020 = function(data, buffer) return 0 end,
	C_17050 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17051 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.shop_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_17052 = function(data, buffer) return 0 end,
	C_17053 = function(data, buffer) return 0 end,
	C_17054 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_17056 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		return totleLen
	end,
	C_17057 = function(data, buffer) return 0 end,
	C_17058 = function(data, buffer) return 0 end,
	C_17059 = function(data, buffer) return 0 end,
	C_17060 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.id)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17061 = function(data, buffer) return 0 end,
	C_17062 = function(data, buffer) return 0 end,
	C_17063 = function(data, buffer) return 0 end,
	C_17064 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.last_red_id, buffer)
		return totleLen
	end,
	C_17065 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.last_id, buffer)
		return totleLen
	end,
	C_17069 = function(data, buffer) return 0 end,
	C_17070 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.red_id, buffer)
		return totleLen
	end,
	C_17071 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.des, buffer)
		return totleLen
	end,
	C_17080 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id_b, buffer)
		return totleLen
	end,
	C_17082 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id_a, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17084 = function(data, buffer) return 0 end,
	C_17085 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.server_id_b)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id_b, buffer)
		totleLen = totleLen + self.wiriteString(data.player_id_b, buffer)
		return totleLen
	end,
	C_17087 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.server_id_a)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id_a, buffer)
		totleLen = totleLen + self.wiriteString(data.player_id_a, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_17089 = function(data, buffer) return 0 end,
	C_17090 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.server_id_b)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id_b, buffer)
		return totleLen
	end,
	C_17093 = function(data, buffer) return 0 end,
	C_17094 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		return totleLen
	end,
	C_18001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_18002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_18003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_18006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_18005 = function(data, buffer) return 0 end,
	C_18008 = function(data, buffer) return 0 end,
	C_18009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_18010 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_19000 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_19001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeInt(data.active)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_20001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_20003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeChar(data.player_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_20004 = function(data, buffer) return 0 end,
	C_20005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		len=#data.trade_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_trade_list")
		for i=1,len do
			totleLen = totleLen + fun(data.trade_list[i], buffer)
		end
		return totleLen
	end,
	C_20007 = function(data, buffer) return 0 end,
	C_21000 = function(data, buffer) return 0 end,
	C_21001 = function(data, buffer) return 0 end,
	C_21002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.switch_type)
		totleLen = totleLen + 1
		buffer:writeChar(data.status)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_21004 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_21006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_21007 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		return totleLen
	end,
	C_21009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_21010 = function(data, buffer) return 0 end,
	C_21011 = function(data, buffer) return 0 end,
	C_21012 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_21013 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_21014 = function(data, buffer) return 0 end,
	C_21015 = function(data, buffer) return 0 end,
	C_21017 = function(data, buffer) return 0 end,
	C_22000 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_hp_set", data.hp_set, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_hpmp_set", data.hpmp_set, buffer)
		return totleLen
	end,
	C_22001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_pickup_set", data.pickup_set, buffer)
		return totleLen
	end,
	C_22002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.code, buffer)
		return totleLen
	end,
	C_22003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_equip_sell_set", data.equip_sell_set, buffer)
		return totleLen
	end,
	C_22004 = function(data, buffer) return 0 end,
	C_22005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.monster_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.action)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_23001 = function(data, buffer) return 0 end,
	C_23002 = function(data, buffer) return 0 end,
	C_23003 = function(data, buffer) return 0 end,
	C_23004 = function(data, buffer) return 0 end,
	C_23005 = function(data, buffer) return 0 end,
	C_23006 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_23007 = function(data, buffer) return 0 end,
	C_23008 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_23009 = function(data, buffer) return 0 end,
	C_23010 = function(data, buffer) return 0 end,
	C_24000 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_24001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_24002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_24003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayerId, buffer)
		return totleLen
	end,
	C_24004 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayerId, buffer)
		return totleLen
	end,
	C_24005 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		return totleLen
	end,
	C_24008 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_24009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_25000 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_25001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.officer_id)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.tplayerId, buffer)
		return totleLen
	end,
	C_25002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayerId, buffer)
		return totleLen
	end,
	C_25003 = function(data, buffer) return 0 end,
	C_25004 = function(data, buffer) return 0 end,
	C_25005 = function(data, buffer) return 0 end,
	C_25006 = function(data, buffer) return 0 end,
	C_25008 = function(data, buffer) return 0 end,
	C_26000 = function(data, buffer) return 0 end,
	C_26001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_26002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_26007 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_26009 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_type)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_27000 = function(data, buffer) return 0 end,
	C_27001 = function(data, buffer) return 0 end,
	C_27002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.is_jade)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_28001 = function(data, buffer) return 0 end,
	C_28003 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.channel, buffer)
		totleLen = totleLen + self.wiriteString(data.cps, buffer)
		return totleLen
	end,
	C_29001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.vip_lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_29002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.vip_lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_29004 = function(data, buffer) return 0 end,
	C_29005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.x)
		totleLen = totleLen + 2
		buffer:writeShort(data.y)
		totleLen = totleLen + 2
		buffer:writeChar(data.is_equip)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_29006 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.vip_exp)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_29007 = function(data, buffer) return 0 end,
	C_30001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.order_id, buffer)
		return totleLen
	end,
	C_30002 = function(data, buffer) return 0 end,
	C_30003 = function(data, buffer) return 0 end,
	C_30004 = function(data, buffer) return 0 end,
	C_31001 = function(data, buffer) return 0 end,
	C_31002 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_32001 = function(data, buffer) return 0 end,
	C_32002 = function(data, buffer) return 0 end,
	C_32003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_32005 = function(data, buffer) return 0 end,
	C_32006 = function(data, buffer) return 0 end,
	C_32007 = function(data, buffer) return 0 end,
	C_32008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_32009 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeChar(data.page)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32010 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeChar(data.page)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32011 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.page)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32012 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32013 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_service_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_32014 = function(data, buffer) return 0 end,
	C_32015 = function(data, buffer) return 0 end,
	C_32016 = function(data, buffer) return 0 end,
	C_32017 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.days)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32018 = function(data, buffer) return 0 end,
	C_32019 = function(data, buffer) return 0 end,
	C_32020 = function(data, buffer) return 0 end,
	C_32021 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.active_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32030 = function(data, buffer) return 0 end,
	C_32031 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.ex_index)
		totleLen = totleLen + 4
		buffer:writeChar(data.choice)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32032 = function(data, buffer) return 0 end,
	C_32033 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.ex_index)
		totleLen = totleLen + 4
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_32034 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.type)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32035 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.active_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32036 = function(data, buffer) return 0 end,
	C_32037 = function(data, buffer) return 0 end,
	C_32038 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.key)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32042 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32043 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.list_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32044 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.active_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_32045 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.active_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.sub_type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_33000 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.page)
		totleLen = totleLen + 1
		buffer:writeChar(data.order)
		totleLen = totleLen + 1
		buffer:writeChar(data.sort1)
		totleLen = totleLen + 1
		buffer:writeShort(data.sort2)
		totleLen = totleLen + 2
		buffer:writeInt(data.sort3)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_33001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.page)
		totleLen = totleLen + 1
		buffer:writeChar(data.order)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		return totleLen
	end,
	C_33002 = function(data, buffer) return 0 end,
	C_33003 = function(data, buffer) return 0 end,
	C_33004 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.bag_id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		buffer:writeInt(data.hour)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_33005 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.sale_id, buffer)
		return totleLen
	end,
	C_33006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.sale_id, buffer)
		return totleLen
	end,
	C_33007 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_33008 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.sale_id, buffer)
		return totleLen
	end,
	C_33009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.hour, buffer)
		return totleLen
	end,
	C_33010 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	C_34000 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.red_id, buffer)
		return totleLen
	end,
	C_35000 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.last_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_35001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_35003 = function(data, buffer) return 0 end,
	C_35004 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.last_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_35005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_35006 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_36000 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.last_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_36001 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_36003 = function(data, buffer) return 0 end,
	C_37001 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		buffer:writeChar(data.is_jade)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_37002 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		return totleLen
	end,
	C_37003 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_37004 = function(data, buffer) return 0 end,
	C_37005 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_37006 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		return totleLen
	end,
	C_37007 = function(data, buffer) return 0 end,
	C_37008 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_37009 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_37010 = function(data, buffer) return 0 end,
	C_37011 = function(data, buffer) return 0 end,
	C_37012 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.min_value)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_value)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_37013 = function(data, buffer) return 0 end,
	C_37014 = function(data, buffer) return 0 end,
	C_37015 = function(data, buffer) return 0 end,
	C_37016 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		return totleLen
	end,
	C_37017 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_37018 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	C_37019 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_37020 = function(data, buffer) return 0 end,
	C_37053 = function(data, buffer) return 0 end,
	C_37054 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		return totleLen
	end,
	C_37056 = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		return totleLen
	end,
	C_38012 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		return totleLen
	end,
	C_38013 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_service_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	C_38019 = function(data, buffer) return 0 end,
	C_38042 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	C_38043 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.list_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_login_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_attr_base = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_ac)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_ac)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_mac)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_mac)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_sc)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_sc)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_def)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_def)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_res)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_res)
		totleLen = totleLen + 4
		buffer:writeInt(data.crit)
		totleLen = totleLen + 4
		buffer:writeInt(data.crit_att)
		totleLen = totleLen + 4
		buffer:writeInt(data.hit)
		totleLen = totleLen + 4
		buffer:writeInt(data.dodge)
		totleLen = totleLen + 4
		buffer:writeShort(data.damage_deepen)
		totleLen = totleLen + 2
		buffer:writeShort(data.damage_reduction)
		totleLen = totleLen + 2
		buffer:writeInt(data.holy)
		totleLen = totleLen + 4
		buffer:writeInt(data.skill_add)
		totleLen = totleLen + 4
		buffer:writeInt(data.m_hit)
		totleLen = totleLen + 4
		buffer:writeInt(data.m_dodge)
		totleLen = totleLen + 4
		buffer:writeChar(data.hp_recover)
		totleLen = totleLen + 1
		buffer:writeChar(data.mp_recover)
		totleLen = totleLen + 1
		buffer:writeChar(data.resurgence)
		totleLen = totleLen + 1
		buffer:writeChar(data.damage_offset)
		totleLen = totleLen + 1
		buffer:writeInt(data.luck)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_ac_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_ac_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_mac_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_mac_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_sc_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_sc_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_def_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_def_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.min_res_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.max_res_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.crit_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.crit_att_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.hit_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.dodge_p)
		totleLen = totleLen + 4
		buffer:writeShort(data.damage_deepen_p)
		totleLen = totleLen + 2
		buffer:writeShort(data.damage_reduction_p)
		totleLen = totleLen + 2
		buffer:writeInt(data.holy_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.skill_add_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.m_hit_p)
		totleLen = totleLen + 4
		buffer:writeInt(data.m_dodge_p)
		totleLen = totleLen + 4
		buffer:writeChar(data.hp_recover_p)
		totleLen = totleLen + 1
		buffer:writeChar(data.mp_recover_p)
		totleLen = totleLen + 1
		buffer:writeChar(data.resurgence_p)
		totleLen = totleLen + 1
		buffer:writeChar(data.damage_offset_p)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_guise = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.weapon)
		totleLen = totleLen + 4
		buffer:writeInt(data.clothes)
		totleLen = totleLen + 4
		buffer:writeInt(data.wing)
		totleLen = totleLen + 4
		buffer:writeInt(data.pet)
		totleLen = totleLen + 4
		buffer:writeInt(data.mounts)
		totleLen = totleLen + 4
		buffer:writeInt(data.mounts_aura)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_money = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.coin)
		totleLen = totleLen + 4
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		buffer:writeInt(data.gift)
		totleLen = totleLen + 4
		buffer:writeInt(data.smelt_value)
		totleLen = totleLen + 4
		buffer:writeInt(data.feats)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp_mark_value)
		totleLen = totleLen + 4
		buffer:writeInt(data.atk_mark_value)
		totleLen = totleLen + 4
		buffer:writeInt(data.def_mark_value)
		totleLen = totleLen + 4
		buffer:writeInt(data.res_mark_value)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_mark = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.hp_mark)
		totleLen = totleLen + 2
		buffer:writeShort(data.atk_mark)
		totleLen = totleLen + 2
		buffer:writeShort(data.def_mark)
		totleLen = totleLen + 2
		buffer:writeShort(data.res_mark)
		totleLen = totleLen + 2
		buffer:writeShort(data.holy_mark)
		totleLen = totleLen + 2
		buffer:writeShort(data.mounts_mark_1)
		totleLen = totleLen + 2
		buffer:writeShort(data.mounts_mark_2)
		totleLen = totleLen + 2
		buffer:writeShort(data.mounts_mark_3)
		totleLen = totleLen + 2
		buffer:writeShort(data.mounts_mark_4)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_hp_set = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.isuse)
		totleLen = totleLen + 1
		buffer:writeChar(data.hp)
		totleLen = totleLen + 1
		buffer:writeInt(data.hp_goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.mp)
		totleLen = totleLen + 1
		buffer:writeInt(data.mp_goods_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_hpmp_set = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.isuse)
		totleLen = totleLen + 1
		buffer:writeChar(data.hp)
		totleLen = totleLen + 1
		buffer:writeInt(data.hp_mp_goods_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_equip_sell_set = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.isauto)
		totleLen = totleLen + 1
		buffer:writeChar(data.white)
		totleLen = totleLen + 1
		buffer:writeChar(data.green)
		totleLen = totleLen + 1
		buffer:writeChar(data.blue)
		totleLen = totleLen + 1
		buffer:writeChar(data.purple)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_pickup_set = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.isauto)
		totleLen = totleLen + 1
		len=#data.equip_set
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeChar(data.equip_set[i])
			totleLen = totleLen + 1
		end
		len=#data.prop_set
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeChar(data.prop_set[i])
			totleLen = totleLen + 1
		end
		len=#data.spec_set
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeChar(data.spec_set[i])
			totleLen = totleLen + 1
		end
		return totleLen
	end,
	proto_player_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeInt(data.exp)
		totleLen = totleLen + 4
		totleLen = totleLen + self:writeDataPacket("proto_attr_base", data.attr_base, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_guise", data.guise, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_money", data.money, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_mark", data.mark, buffer)
		buffer:writeShort(data.hook_scene_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.pass_hook_scene_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.fighting)
		totleLen = totleLen + 4
		buffer:writeInt(data.bag)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		buffer:writeChar(data.pk_mode)
		totleLen = totleLen + 1
		buffer:writeShort(data.pk_value)
		totleLen = totleLen + 2
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		buffer:writeChar(data.vip)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_hp_set", data.hp_set, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_hpmp_set", data.hpmp_set, buffer)
		buffer:writeShort(data.career_title)
		totleLen = totleLen + 2
		totleLen = totleLen + self:writeDataPacket("proto_equip_sell_set", data.equip_sell_set, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_pickup_set", data.pickup_set, buffer)
		len=#data.function_open_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeShort(data.function_open_list[i])
			totleLen = totleLen + 2
		end
		len=#data.guide_step_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeShort(data.guide_step_list[i])
			totleLen = totleLen + 2
		end
		buffer:writeInt(data.vip_exp)
		totleLen = totleLen + 4
		buffer:writeChar(data.wing_state)
		totleLen = totleLen + 1
		buffer:writeChar(data.weapon_state)
		totleLen = totleLen + 1
		buffer:writeChar(data.pet_att_type)
		totleLen = totleLen + 1
		buffer:writeChar(data.pet_num)
		totleLen = totleLen + 1
		buffer:writeInt(data.register_time)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		return totleLen
	end,
	proto_obj_flag = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		return totleLen
	end,
	proto_point = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.x)
		totleLen = totleLen + 2
		buffer:writeShort(data.y)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_buff = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.buff_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.effect_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.countdown)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_spec_buff = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.type)
		totleLen = totleLen + 2
		buffer:writeInt(data.value)
		totleLen = totleLen + 4
		buffer:writeInt(data.countdown)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_scene_player = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp)
		totleLen = totleLen + 4
		buffer:writeChar(data.direction)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_point", data.begin_point, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.end_point, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_guise", data.guise, buffer)
		len=#data.buff_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_buff")
		for i=1,len do
			totleLen = totleLen + fun(data.buff_list[i], buffer)
		end
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		buffer:writeShort(data.career_title)
		totleLen = totleLen + 2
		buffer:writeChar(data.pet_num)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.server_name, buffer)
		buffer:writeChar(data.collect_state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_scene_player_update = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		buffer:writeShort(data.career_title)
		totleLen = totleLen + 2
		buffer:writeChar(data.pet_num)
		totleLen = totleLen + 1
		buffer:writeChar(data.collect_state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_scene_obj_often_update = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_atk, buffer)
		buffer:writeChar(data.cause)
		totleLen = totleLen + 1
		buffer:writeChar(data.harm_status)
		totleLen = totleLen + 1
		buffer:writeInt(data.hp_change)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp_change)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_scene_pet_update = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_enmity = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.monster_id)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_drop_owner = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		return totleLen
	end,
	proto_scene_monster = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.owner_flag, buffer)
		buffer:writeShort(data.monster_id)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp)
		totleLen = totleLen + 4
		buffer:writeChar(data.direction)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_point", data.begin_point, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.end_point, buffer)
		len=#data.buff_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_buff")
		for i=1,len do
			totleLen = totleLen + fun(data.buff_list[i], buffer)
		end
		totleLen = totleLen + self:writeDataPacket("proto_enmity", data.enmity, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		totleLen = totleLen + self:writeDataPacket("proto_drop_owner", data.drop_owner, buffer)
		totleLen = totleLen + self.wiriteString(data.server_name, buffer)
		return totleLen
	end,
	proto_scene_drop = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self:writeDataPacket("proto_point", data.point, buffer)
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeShort(data.time_out)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		return totleLen
	end,
	proto_fire_wall = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.point, buffer)
		return totleLen
	end,
	proto_skill = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.skill_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		buffer:writeInt(data.exp)
		totleLen = totleLen + 4
		buffer:writeChar(data.pos)
		totleLen = totleLen + 1
		buffer:writeChar(data.auto_set)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_player_update = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		buffer:writeInt(data.value)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_attr_value = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		buffer:writeInt(data.value)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_attr_baptize_value = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.id)
		totleLen = totleLen + 1
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		buffer:writeInt(data.value)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_harm = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		buffer:writeChar(data.harm_status)
		totleLen = totleLen + 1
		buffer:writeInt(data.harm_value)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_cure = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		buffer:writeInt(data.add_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_buff_operate = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		buffer:writeChar(data.operate)
		totleLen = totleLen + 1
		buffer:writeShort(data.buff_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.effect_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.countdown)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_hook_monster = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.owner_flag, buffer)
		buffer:writeShort(data.monster_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.cur_hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_mp)
		totleLen = totleLen + 4
		buffer:writeInt(data.hp)
		totleLen = totleLen + 4
		buffer:writeInt(data.mp)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		buffer:writeChar(data.name_colour)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_goods_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeChar(data.stren_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.location)
		totleLen = totleLen + 1
		buffer:writeChar(data.grid)
		totleLen = totleLen + 1
		buffer:writeInt(data.expire_time)
		totleLen = totleLen + 4
		buffer:writeShort(data.map_scene)
		totleLen = totleLen + 2
		buffer:writeShort(data.map_x)
		totleLen = totleLen + 2
		buffer:writeShort(data.map_y)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_equips_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeChar(data.stren_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.location)
		totleLen = totleLen + 1
		buffer:writeChar(data.grid)
		totleLen = totleLen + 1
		len=#data.baptize_attr_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_attr_baptize_value")
		for i=1,len do
			totleLen = totleLen + fun(data.baptize_attr_list[i], buffer)
		end
		buffer:writeChar(data.soul)
		totleLen = totleLen + 1
		buffer:writeChar(data.luck)
		totleLen = totleLen + 1
		buffer:writeInt(data.expire_time)
		totleLen = totleLen + 4
		buffer:writeChar(data.secure)
		totleLen = totleLen + 1
		buffer:writeInt(data.bless)
		totleLen = totleLen + 4
		buffer:writeInt(data.server_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.is_use)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_goods_full_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeChar(data.stren_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.location)
		totleLen = totleLen + 1
		buffer:writeChar(data.grid)
		totleLen = totleLen + 1
		len=#data.baptize_attr_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_attr_baptize_value")
		for i=1,len do
			totleLen = totleLen + fun(data.baptize_attr_list[i], buffer)
		end
		buffer:writeChar(data.soul)
		totleLen = totleLen + 1
		buffer:writeChar(data.luck)
		totleLen = totleLen + 1
		buffer:writeChar(data.secure)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_goods_list = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_trade_list = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_mail_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		totleLen = totleLen + self.wiriteString(data.title, buffer)
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		len=#data.award
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_mail_award")
		for i=1,len do
			totleLen = totleLen + fun(data.award[i], buffer)
		end
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		buffer:writeInt(data.send_time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_mail_award = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_guild_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		buffer:writeShort(data.guild_rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		totleLen = totleLen + self.wiriteString(data.chairman_name, buffer)
		buffer:writeChar(data.guild_lv)
		totleLen = totleLen + 1
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeShort(data.number)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_guild_simple_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.server_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		return totleLen
	end,
	proto_guild_standard_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.server_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		totleLen = totleLen + self.wiriteString(data.chairman_name, buffer)
		buffer:writeChar(data.guild_lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.number)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_apply_guild_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fighting)
		totleLen = totleLen + 4
		buffer:writeInt(data.online)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_guild_detailed_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		totleLen = totleLen + self.wiriteString(data.chairman_name, buffer)
		buffer:writeChar(data.guild_lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.guild_rank)
		totleLen = totleLen + 2
		buffer:writeShort(data.number)
		totleLen = totleLen + 2
		buffer:writeInt(data.exp)
		totleLen = totleLen + 4
		buffer:writeInt(data.capital)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.announce, buffer)
		return totleLen
	end,
	proto_guild_member_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fighting)
		totleLen = totleLen + 4
		buffer:writeInt(data.contribution)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_guild_log_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeInt(data.parameter1)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.parameter2, buffer)
		buffer:writeInt(data.parameter3)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_player_guild_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		buffer:writeInt(data.contribution)
		totleLen = totleLen + 4
		buffer:writeShort(data.guild_lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_donation_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeChar(data.count)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_legion_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		buffer:writeShort(data.legion_rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		totleLen = totleLen + self.wiriteString(data.chairman_name, buffer)
		buffer:writeChar(data.legion_lv)
		totleLen = totleLen + 1
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeShort(data.number)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_apply_legion_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fighting)
		totleLen = totleLen + 4
		buffer:writeInt(data.online)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_legion_detailed_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		totleLen = totleLen + self.wiriteString(data.chairman_name, buffer)
		buffer:writeChar(data.legion_lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.legion_rank)
		totleLen = totleLen + 2
		buffer:writeShort(data.number)
		totleLen = totleLen + 2
		buffer:writeInt(data.exp)
		totleLen = totleLen + 4
		buffer:writeInt(data.capital)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.announce, buffer)
		return totleLen
	end,
	proto_legion_member_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fighting)
		totleLen = totleLen + 4
		buffer:writeInt(data.contribution)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_legion_log_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeInt(data.parameter1)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.parameter2, buffer)
		buffer:writeInt(data.parameter3)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_player_legion_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_name, buffer)
		buffer:writeChar(data.position)
		totleLen = totleLen + 1
		buffer:writeInt(data.contribution)
		totleLen = totleLen + 4
		buffer:writeShort(data.legion_lv)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_hook_drop = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_goods_report = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.quality)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeInt(data.sale_num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_hook_report = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.offline_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.kill_num)
		totleLen = totleLen + 4
		buffer:writeShort(data.die_num)
		totleLen = totleLen + 2
		buffer:writeInt(data.coin)
		totleLen = totleLen + 4
		buffer:writeInt(data.exp)
		totleLen = totleLen + 4
		len=#data.goods_report_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_goods_report")
		for i=1,len do
			totleLen = totleLen + fun(data.goods_report_list[i], buffer)
		end
		len=#data.goods_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		fun = self:writeDataPacketFun("proto_hook_drop")
		for i=1,len do
			totleLen = totleLen + fun(data.goods_list[i], buffer)
		end
		return totleLen
	end,
	proto_hook_star = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.hook_scene_id)
		totleLen = totleLen + 2
		buffer:writeChar(data.star)
		totleLen = totleLen + 1
		buffer:writeChar(data.reward_status)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_hook_star_reward = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.chapter)
		totleLen = totleLen + 2
		buffer:writeChar(data.star)
		totleLen = totleLen + 1
		len=#data.step_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeChar(data.step_list[i])
			totleLen = totleLen + 1
		end
		return totleLen
	end,
	proto_hook_fire_wall = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.point, buffer)
		buffer:writeShort(data.interval)
		totleLen = totleLen + 2
		buffer:writeShort(data.duration)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_fire_wall_attack = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.fire_wall_uid, buffer)
		totleLen = totleLen + self.wiriteString(data.monster_uid, buffer)
		return totleLen
	end,
	proto_point_change = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_obj_flag", data.obj_flag, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.begin_point, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_point", data.end_point, buffer)
		return totleLen
	end,
	proto_taskinfo = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.nownum)
		totleLen = totleLen + 4
		buffer:writeChar(data.isfinish)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_boss_refresh = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.id)
		totleLen = totleLen + 1
		buffer:writeInt(data.refresh_time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_team_member_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.type)
		totleLen = totleLen + 1
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_online)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_near_by_player = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		return totleLen
	end,
	proto_near_by_team = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.memeber_num)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		return totleLen
	end,
	proto_map_teammate_flag = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self:writeDataPacket("proto_point", data.point, buffer)
		return totleLen
	end,
	proto_arena_challenge_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeInt(data.rank)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_arena_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeInt(data.rank)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_active_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.score)
		totleLen = totleLen + 4
		buffer:writeInt(data.rank)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_active_service_type_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.type_id)
		totleLen = totleLen + 2
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_arena_record = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.type, buffer)
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		buffer:writeInt(data.time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_relationship_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeChar(data.lv)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		buffer:writeChar(data.isonline)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.last_offline_time, buffer)
		return totleLen
	end,
	proto_city_officer_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.officer_id)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.tplayer_id, buffer)
		totleLen = totleLen + self.wiriteString(data.tname, buffer)
		totleLen = totleLen + self:writeDataPacket("proto_guise", data.guise, buffer)
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_navigate_task_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.task_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		buffer:writeInt(data.now_num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_worship_first_career_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeChar(data.sex)
		totleLen = totleLen + 1
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	proto_activity_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.activity_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.now_num)
		totleLen = totleLen + 2
		buffer:writeShort(data.max_num)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_active_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.key)
		totleLen = totleLen + 2
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_sale_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.sale_id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeInt(data.time)
		totleLen = totleLen + 4
		buffer:writeChar(data.stren_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.soul)
		totleLen = totleLen + 1
		buffer:writeChar(data.secure)
		totleLen = totleLen + 1
		len=#data.baptize_attr_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_attr_baptize_value")
		for i=1,len do
			totleLen = totleLen + fun(data.baptize_attr_list[i], buffer)
		end
		buffer:writeChar(data.artifact_star)
		totleLen = totleLen + 1
		buffer:writeChar(data.artifact_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.artifact_exp)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_player_sale_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeInt(data.time)
		totleLen = totleLen + 4
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		buffer:writeChar(data.stren_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.soul)
		totleLen = totleLen + 1
		buffer:writeChar(data.secure)
		totleLen = totleLen + 1
		len=#data.baptize_attr_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_attr_baptize_value")
		for i=1,len do
			totleLen = totleLen + fun(data.baptize_attr_list[i], buffer)
		end
		buffer:writeChar(data.artifact_star)
		totleLen = totleLen + 1
		buffer:writeChar(data.artifact_lv)
		totleLen = totleLen + 1
		buffer:writeChar(data.artifact_exp)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_button_tips = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		buffer:writeShort(data.num)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_world_boss_rank = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.harm)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_attack_city_rank = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.score)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_wander_shop = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.shop_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.count)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_mystery_shop = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.mystery_shop_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeChar(data.curr_type)
		totleLen = totleLen + 1
		buffer:writeInt(data.price)
		totleLen = totleLen + 4
		buffer:writeShort(data.vip)
		totleLen = totleLen + 2
		buffer:writeChar(data.is_buy)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.discount, buffer)
		return totleLen
	end,
	proto_active_shop = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.id)
		totleLen = totleLen + 2
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		buffer:writeInt(data.buy_num)
		totleLen = totleLen + 4
		buffer:writeInt(data.limit_num)
		totleLen = totleLen + 4
		buffer:writeChar(data.curr_type)
		totleLen = totleLen + 1
		buffer:writeInt(data.price)
		totleLen = totleLen + 4
		buffer:writeInt(data.price_old)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_lv_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_fight_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.fight)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_guild_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.chief_name, buffer)
		buffer:writeShort(data.member_num)
		totleLen = totleLen + 2
		buffer:writeShort(data.guild_lv)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.guild_name, buffer)
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_fb_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.scene_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.now_times)
		totleLen = totleLen + 2
		buffer:writeShort(data.buy_times)
		totleLen = totleLen + 2
		buffer:writeShort(data.limit_buy_times)
		totleLen = totleLen + 2
		buffer:writeShort(data.next_scene_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.need_jade)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_raids_goods_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_active_service_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.active_service_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_receive)
		totleLen = totleLen + 1
		buffer:writeChar(data.state2)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_active_service_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeInt(data.value)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_guild_red_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.position)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.red_id, buffer)
		totleLen = totleLen + self.wiriteString(data.des, buffer)
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_guild_red_log = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.jade)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_lottery_log_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.id, buffer)
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		return totleLen
	end,
	proto_lottery_goods_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.id)
		totleLen = totleLen + 4
		buffer:writeInt(data.goods_id)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_bind)
		totleLen = totleLen + 1
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_world_chat_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		buffer:writeChar(data.vip)
		totleLen = totleLen + 1
		buffer:writeInt(data.time)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		totleLen = totleLen + self.wiriteString(data.team_id, buffer)
		totleLen = totleLen + self.wiriteString(data.guild_id, buffer)
		totleLen = totleLen + self.wiriteString(data.legion_id, buffer)
		return totleLen
	end,
	proto_line_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.line_num)
		totleLen = totleLen + 2
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		buffer:writeShort(data.player_num)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_operate_active_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		buffer:writeChar(data.mark)
		totleLen = totleLen + 1
		buffer:writeChar(data.model)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.title, buffer)
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		len=#data.show_reward
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_goods_list")
		for i=1,len do
			totleLen = totleLen + fun(data.show_reward[i], buffer)
		end
		buffer:writeChar(data.is_button)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.button_content, buffer)
		buffer:writeChar(data.is_window)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.window_content, buffer)
		buffer:writeInt(data.start_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.end_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.state)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_operate_active_info_model_2 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		buffer:writeChar(data.mark)
		totleLen = totleLen + 1
		buffer:writeChar(data.model)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.title, buffer)
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		buffer:writeInt(data.content_value)
		totleLen = totleLen + 4
		len=#data.sub_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_model_2")
		for i=1,len do
			totleLen = totleLen + fun(data.sub_list[i], buffer)
		end
		buffer:writeInt(data.start_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.end_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_time)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_count_down)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_model_2 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.sub_type)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		len=#data.show_reward
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_goods_list")
		for i=1,len do
			totleLen = totleLen + fun(data.show_reward[i], buffer)
		end
		buffer:writeInt(data.state)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_operate_active_info_model_3 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		buffer:writeChar(data.mark)
		totleLen = totleLen + 1
		buffer:writeChar(data.model)
		totleLen = totleLen + 1
		totleLen = totleLen + self.wiriteString(data.title, buffer)
		len=#data.sub_list
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_model_3")
		for i=1,len do
			totleLen = totleLen + fun(data.sub_list[i], buffer)
		end
		buffer:writeInt(data.start_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.end_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.cur_time)
		totleLen = totleLen + 4
		buffer:writeChar(data.is_count_down)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_model_3 = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.sub_type)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.content, buffer)
		len=#data.old_price
		buffer:writeShort(len)
		totleLen = totleLen + 2
		local fun = self:writeDataPacketFun("proto_goods_list")
		for i=1,len do
			totleLen = totleLen + fun(data.old_price[i], buffer)
		end
		len=#data.new_price
		buffer:writeShort(len)
		totleLen = totleLen + 2
		fun = self:writeDataPacketFun("proto_goods_list")
		for i=1,len do
			totleLen = totleLen + fun(data.new_price[i], buffer)
		end
		len=#data.shop
		buffer:writeShort(len)
		totleLen = totleLen + 2
		fun = self:writeDataPacketFun("proto_goods_list")
		for i=1,len do
			totleLen = totleLen + fun(data.shop[i], buffer)
		end
		buffer:writeInt(data.count)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_operate_holiday_active_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.type)
		totleLen = totleLen + 2
		buffer:writeInt(data.start_time)
		totleLen = totleLen + 4
		buffer:writeInt(data.end_time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_operate_holiday_change_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.active_id)
		totleLen = totleLen + 2
		buffer:writeShort(data.fusion_id)
		totleLen = totleLen + 2
		buffer:writeInt(data.count)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_exam_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.score)
		totleLen = totleLen + 4
		buffer:writeInt(data.rank)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_monster_follow = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.monster_id)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_monster_boss_drop = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.planer_name, buffer)
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.monster_id)
		totleLen = totleLen + 4
		len=#data.monster_goods
		buffer:writeShort(len)
		totleLen = totleLen + 2
		for i=1,len do
			buffer:writeInt(data.monster_goods[i])
			totleLen = totleLen + 4
		end
		buffer:writeInt(data.kill_time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_boss_time_and_follow = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.monster_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.refresh_time)
		totleLen = totleLen + 4
		buffer:writeChar(data.follow)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_city_boss_killer = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.monster_id)
		totleLen = totleLen + 4
		totleLen = totleLen + self.wiriteString(data.player_name, buffer)
		return totleLen
	end,
	proto_word_map_info = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeShort(data.state)
		totleLen = totleLen + 2
		return totleLen
	end,
	proto_shop_once_state = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeChar(data.pos)
		totleLen = totleLen + 1
		buffer:writeChar(data.state)
		totleLen = totleLen + 1
		return totleLen
	end,
	proto_instance_king_rank = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.score)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_instance_king_rank_full = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeShort(data.lv)
		totleLen = totleLen + 2
		buffer:writeShort(data.career)
		totleLen = totleLen + 2
		buffer:writeInt(data.score)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_hjzc_rank_info = function(data, buffer) 
		local totleLen, len = 0, 0
		totleLen = totleLen + self.wiriteString(data.player_id, buffer)
		buffer:writeShort(data.rank)
		totleLen = totleLen + 2
		totleLen = totleLen + self.wiriteString(data.name, buffer)
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_palace_scene = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.time)
		totleLen = totleLen + 4
		return totleLen
	end,
	proto_palace_boss_num = function(data, buffer) 
		local totleLen, len = 0, 0
		buffer:writeInt(data.scene_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.boss_id)
		totleLen = totleLen + 4
		buffer:writeInt(data.num)
		totleLen = totleLen + 4
		return totleLen
	end,

}

self.cmdStruct={
	
	S_9000 = function(byteArray) 
		function create_button_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_button_tips")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {button_list = create_button_list(byteArray),} end,
	S_9001 = function(byteArray) 
		function create_button_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_button_tips")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {button_list = create_button_list(byteArray),} end,
	S_9998 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_9999 = function(byteArray) 
		function create_arg_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {notice_id = byteArray:readShort(),arg_list = create_arg_list(byteArray),} end,
	S_9997 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_10000 = function(byteArray) 
		function create_player_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_login_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {result = byteArray:readShort(),player_list = create_player_list(byteArray),} end,
	S_10001 = function(byteArray) return {result = byteArray:readShort(),player_info = self:getCmdStruct("proto_login_info",byteArray),} end,
	S_10002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_10003 = function(byteArray) return {result = byteArray:readShort(),player_info = self:getCmdStruct("proto_player_info",byteArray),} end,
	S_10004 = function(byteArray) 
		function create_update_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_player_update")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {update_list = create_update_list(byteArray),} end,
	S_10005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_10006 = function(byteArray) return {server_time = byteArray:readInt(),} end,
	S_10007 = function(byteArray) return {flag = byteArray:readChar(),} end,
	S_10008 = function(byteArray) return {result = byteArray:readShort(),pk_mode = byteArray:readChar(),} end,
	S_10009 = function(byteArray) return {player_id = byteArray:readStringUShort(),} end,
	S_10010 = function(byteArray) return {caster_name = byteArray:readStringUShort(),fh_vip_num = byteArray:readShort(),} end,
	S_10011 = function(byteArray) 
		function create_equips_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),lv = byteArray:readShort(),sex = byteArray:readChar(),career = byteArray:readShort(),fight = byteArray:readInt(),equips_list = create_equips_list(byteArray),guise = self:getCmdStruct("proto_guise",byteArray),mark = self:getCmdStruct("proto_mark",byteArray),result = byteArray:readShort(),} end,
	S_10012 = function(byteArray) 
		function create_spec_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_spec_buff")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {spec_buff_list = create_spec_buff_list(byteArray),buff_list = create_buff_list(byteArray),} end,
	S_10013 = function(byteArray) return {state = byteArray:readChar(),subtype = byteArray:readShort(),} end,
	S_10015 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_10016 = function(byteArray) return {result = byteArray:readShort(),instance_left_time = byteArray:readInt(),} end,
	S_10018 = function(byteArray) return {open_days = byteArray:readInt(),server_time = byteArray:readInt(),} end,
	S_11001 = function(byteArray) 
		function create_player_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_player")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_monster_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_monster")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_drop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_drop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_fire_wall_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_fire_wall")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {result = byteArray:readShort(),scene_id = byteArray:readShort(),player_list = create_player_list(byteArray),monster_list = create_monster_list(byteArray),drop_list = create_drop_list(byteArray),fire_wall_list = create_fire_wall_list(byteArray),} end,
	S_11002 = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),direction = byteArray:readChar(),begin_point = self:getCmdStruct("proto_point",byteArray),end_point = self:getCmdStruct("proto_point",byteArray),} end,
	S_11003 = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),direction = byteArray:readChar(),point = self:getCmdStruct("proto_point",byteArray),end_point = self:getCmdStruct("proto_point",byteArray),} end,
	S_11004 = function(byteArray) 
		function create_obj_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_obj_flag")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {obj_list = create_obj_list(byteArray),} end,
	S_11005 = function(byteArray) 
		function create_player_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_player")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_monster_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_monster")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_drop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_drop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_fire_wall_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_fire_wall")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_list = create_player_list(byteArray),monster_list = create_monster_list(byteArray),drop_list = create_drop_list(byteArray),fire_wall_list = create_fire_wall_list(byteArray),} end,
	S_11006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11007 = function(byteArray) 
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff_operate")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {buff_list = create_buff_list(byteArray),} end,
	S_11008 = function(byteArray) 
		function create_harm_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_harm")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {harm_list = create_harm_list(byteArray),} end,
	S_11009 = function(byteArray) 
		function create_refresh_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_boss_refresh")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {refresh_list = create_refresh_list(byteArray),} end,
	S_11010 = function(byteArray) 
		function create_refresh_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_boss_refresh")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {refresh_list = create_refresh_list(byteArray),} end,
	S_11011 = function(byteArray) 
		function create_player_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_player_update")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_list = create_player_list(byteArray),} end,
	S_11012 = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),} end,
	S_11013 = function(byteArray) return {scene_id = byteArray:readShort(),enter_times = byteArray:readChar(),} end,
	S_11015 = function(byteArray) return {scene_id = byteArray:readShort(),monster_count = byteArray:readShort(),kill_monster = byteArray:readShort(),boss_count = byteArray:readChar(),kill_boss = byteArray:readChar(),end_time = byteArray:readInt(),round = byteArray:readInt(),} end,
	S_11017 = function(byteArray) return {scene_id = byteArray:readShort(),instance_result = byteArray:readChar(),} end,
	S_11018 = function(byteArray) return {activity = byteArray:readChar(),guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),} end,
	S_11019 = function(byteArray) 
		function create_flag_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_map_teammate_flag")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {flag_list = create_flag_list(byteArray),} end,
	S_11020 = function(byteArray) 
		function create_obj_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_obj_often_update")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {obj_list = create_obj_list(byteArray),} end,
	S_11021 = function(byteArray) return {can_find = byteArray:readChar(),point = self:getCmdStruct("proto_point",byteArray),} end,
	S_11022 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11023 = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),enmity = self:getCmdStruct("proto_enmity",byteArray),drop_owner = self:getCmdStruct("proto_drop_owner",byteArray),} end,
	S_11024 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11025 = function(byteArray) return {type = byteArray:readInt(),} end,
	S_11026 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11027 = function(byteArray) 
		function create_pet_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_scene_pet_update")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {pet_list = create_pet_list(byteArray),} end,
	S_11028 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_world_boss_rank")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),player_rank = byteArray:readShort(),player_harm = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_11029 = function(byteArray) return {total_time = byteArray:readInt(),time = byteArray:readInt(),the_number = byteArray:readShort(),} end,
	S_11030 = function(byteArray) return {rank = byteArray:readShort(),} end,
	S_11032 = function(byteArray) return {num = byteArray:readChar(),} end,
	S_11033 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11034 = function(byteArray) 
		function create_fb_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_fb_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {fb_list = create_fb_list(byteArray),} end,
	S_11035 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11036 = function(byteArray) return {fb_info = self:getCmdStruct("proto_fb_info",byteArray),} end,
	S_11038 = function(byteArray) 
		function create_line_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_line_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {now_line = byteArray:readShort(),line_info_list = create_line_info_list(byteArray),} end,
	S_11040 = function(byteArray) 
		function create_player_id_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {player_id_list = create_player_id_list(byteArray),} end,
	S_11041 = function(byteArray) return {del_player_id = byteArray:readStringUShort(),add_player_id = byteArray:readStringUShort(),} end,
	S_11042 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attack_city_rank")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),round = byteArray:readChar(),box = byteArray:readShort(),time = byteArray:readShort(),player_rank = byteArray:readShort(),player_score = byteArray:readInt(),boss_hp = byteArray:readInt(),boss_cur_hp = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_11043 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_11045 = function(byteArray) return {left_time = byteArray:readInt(),left_boss = byteArray:readChar(),} end,
	S_11046 = function(byteArray) 
		function create_drop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_monster_boss_drop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {drop_list = create_drop_list(byteArray),} end,
	S_11047 = function(byteArray) return {left_time = byteArray:readInt(),} end,
	S_11048 = function(byteArray) 
		function create_boss_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_boss_time_and_follow")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),boss_list = create_boss_list(byteArray),} end,
	S_11049 = function(byteArray) return {scene_id = byteArray:readInt(),monster_id = byteArray:readInt(),} end,
	S_11050 = function(byteArray) 
		function create_killer_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_city_boss_killer")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {killer_list = create_killer_list(byteArray),} end,
	S_11052 = function(byteArray) return {warning_id = byteArray:readInt(),} end,
	S_11053 = function(byteArray) 
		function create_weapon_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_clothes_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_wing_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_monster_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		return {weapon_list = create_weapon_list(byteArray),clothes_list = create_clothes_list(byteArray),wing_list = create_wing_list(byteArray),monster_list = create_monster_list(byteArray),} end,
	S_11054 = function(byteArray) return {kill_num = byteArray:readInt(),} end,
	S_11055 = function(byteArray) 
		function create_map_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_word_map_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {map_info_list = create_map_info_list(byteArray),} end,
	S_11056 = function(byteArray) return {time_left = byteArray:readShort(),} end,
	S_11057 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_instance_king_rank")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_rank = byteArray:readShort(),player_score = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_11058 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_instance_king_rank_full")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_rank = byteArray:readShort(),player_score = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_11061 = function(byteArray) 
		function create_left_time(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_palace_scene")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_kill_boss(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_palace_boss_num")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {left_time = create_left_time(byteArray),kill_boss = create_kill_boss(byteArray),} end,
	S_11101 = function(byteArray) return {scene_pic = byteArray:readStringUShort(),} end,
	S_11102 = function(byteArray) return {room_pass = byteArray:readChar(),} end,
	S_11103 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hjzc_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {rank_list = create_rank_list(byteArray),} end,
	S_11104 = function(byteArray) 
		function create_pass_room_num_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {room_num = byteArray:readChar(),pass_room_num_list = create_pass_room_num_list(byteArray),} end,
	S_11105 = function(byteArray) return {room_num = byteArray:readChar(),} end,
	S_12001 = function(byteArray) 
		function create_skill_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_skill")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {result = byteArray:readShort(),skill_list = create_skill_list(byteArray),} end,
	S_12002 = function(byteArray) return {result = byteArray:readShort(),caster_flag = self:getCmdStruct("proto_obj_flag",byteArray),caster_point = self:getCmdStruct("proto_point",byteArray),direction = byteArray:readChar(),skill_id = byteArray:readInt(),skill_lv = byteArray:readInt(),target_type = byteArray:readChar(),target_flag = self:getCmdStruct("proto_obj_flag",byteArray),target_point = self:getCmdStruct("proto_point",byteArray),} end,
	S_12003 = function(byteArray) return {skill_info = self:getCmdStruct("proto_skill",byteArray),} end,
	S_12004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_12005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_12006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_12007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_12008 = function(byteArray) return {type = byteArray:readChar(),} end,
	S_12009 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_12010 = function(byteArray) 
		function create_target_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_obj_flag")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff_operate")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_move_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_point_change")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_knockback_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_point_change")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {target_list = create_target_list(byteArray),buff_list = create_buff_list(byteArray),move_list = create_move_list(byteArray),knockback_list = create_knockback_list(byteArray),} end,
	S_13001 = function(byteArray) return {result = byteArray:readShort(),scene_id = byteArray:readShort(),} end,
	S_13002 = function(byteArray) 
		function create_monster_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_monster")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {monster_type = byteArray:readChar(),monster_list = create_monster_list(byteArray),} end,
	S_13003 = function(byteArray) 
		function create_harm_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_harm")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_cure_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_cure")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff_operate")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {harm_list = create_harm_list(byteArray),cure_list = create_cure_list(byteArray),buff_list = create_buff_list(byteArray),} end,
	S_13004 = function(byteArray) return {status = byteArray:readChar(),next_time = byteArray:readChar(),} end,
	S_13005 = function(byteArray) 
		function create_drop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_drop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),drop_list = create_drop_list(byteArray),} end,
	S_13006 = function(byteArray) return {challenge_num = byteArray:readChar(),need_jade = byteArray:readShort(),} end,
	S_13007 = function(byteArray) return {result = byteArray:readShort(),scene_id = byteArray:readShort(),} end,
	S_13008 = function(byteArray) return {result = byteArray:readShort(),scene_id = byteArray:readShort(),} end,
	S_13009 = function(byteArray) return {hook_report = self:getCmdStruct("proto_hook_report",byteArray),} end,
	S_13010 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_13011 = function(byteArray) return {result = byteArray:readShort(),challenge_num = byteArray:readChar(),need_jade = byteArray:readShort(),} end,
	S_13012 = function(byteArray) return {hour_kill_num = byteArray:readShort(),hour_coin_gain = byteArray:readInt(),hour_exp_gain = byteArray:readInt(),drop_rate = byteArray:readChar(),} end,
	S_13013 = function(byteArray) return {need_jade = byteArray:readShort(),buy_num = byteArray:readChar(),all_buy_num = byteArray:readChar(),remain_times = byteArray:readChar(),hook_info = self:getCmdStruct("proto_hook_report",byteArray),} end,
	S_13014 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_13015 = function(byteArray) 
		function create_hook_star_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_star")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_hook_star_reward_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_star_reward")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {hook_star_list = create_hook_star_list(byteArray),hook_star_reward_list = create_hook_star_reward_list(byteArray),} end,
	S_13016 = function(byteArray) return {hook_star = self:getCmdStruct("proto_hook_star",byteArray),} end,
	S_13017 = function(byteArray) return {status = byteArray:readChar(),scene_id = byteArray:readShort(),} end,
	S_13018 = function(byteArray) 
		function create_hook_obj_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_monster")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {hook_obj_list = create_hook_obj_list(byteArray),} end,
	S_13019 = function(byteArray) 
		function create_hook_fire_wall_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_fire_wall")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {hook_fire_wall_list = create_hook_fire_wall_list(byteArray),} end,
	S_13021 = function(byteArray) 
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff_operate")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {buff_list = create_buff_list(byteArray),} end,
	S_13022 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_13023 = function(byteArray) return {hook_star_reward = self:getCmdStruct("proto_hook_star_reward",byteArray),} end,
	S_13024 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_13025 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14001 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),} end,
	S_14002 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),} end,
	S_14003 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14004 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),get_coin = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_14005 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),get_coin = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_14006 = function(byteArray) return {get_coin = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_14007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14009 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),} end,
	S_14010 = function(byteArray) return {value = byteArray:readInt(),} end,
	S_14011 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {goods_id = byteArray:readInt(),num = byteArray:readInt(),type = byteArray:readChar(),goods_list = create_goods_list(byteArray),} end,
	S_14020 = function(byteArray) 
		function create_equips_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {equips_list = create_equips_list(byteArray),} end,
	S_14021 = function(byteArray) 
		function create_equips_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {equips_list = create_equips_list(byteArray),} end,
	S_14022 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14023 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14024 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14025 = function(byteArray) 
		function create_goods_id_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		return {result = byteArray:readShort(),smelt = byteArray:readInt(),goods_id_list = create_goods_id_list(byteArray),} end,
	S_14026 = function(byteArray) 
		function create_attr_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attr_baptize_value")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {result = byteArray:readShort(),attr_list = create_attr_list(byteArray),} end,
	S_14027 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14028 = function(byteArray) return {goods_id = byteArray:readInt(),star = byteArray:readChar(),forge_num = byteArray:readShort(),smelt = byteArray:readInt(),} end,
	S_14029 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14030 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14031 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14032 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14033 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14034 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14035 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14036 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14037 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),result = byteArray:readShort(),} end,
	S_14038 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),result = byteArray:readShort(),} end,
	S_14040 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_full_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {store_cell = byteArray:readChar(),goods_list = create_goods_list(byteArray),} end,
	S_14041 = function(byteArray) return {goods_info = self:getCmdStruct("proto_goods_full_info",byteArray),} end,
	S_14042 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14043 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14044 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14045 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14046 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14047 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14048 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14049 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14050 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14051 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14052 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14053 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_14054 = function(byteArray) return {result = byteArray:readShort(),mark_type = byteArray:readShort(),bless = byteArray:readShort(),} end,
	S_14055 = function(byteArray) return {bless = byteArray:readInt(),mark_type = byteArray:readShort(),} end,
	S_15001 = function(byteArray) 
		function create_mail_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_mail_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {mail_list = create_mail_list(byteArray),} end,
	S_15002 = function(byteArray) return {mail_info = self:getCmdStruct("proto_mail_info",byteArray),} end,
	S_15003 = function(byteArray) return {id = byteArray:readStringUShort(),result = byteArray:readShort(),} end,
	S_15004 = function(byteArray) return {id = byteArray:readStringUShort(),result = byteArray:readShort(),} end,
	S_16001 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_16002 = function(byteArray) 
		function create_shop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_wander_shop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {shop_list = create_shop_list(byteArray),} end,
	S_16003 = function(byteArray) return {use_num = byteArray:readShort(),limit_num = byteArray:readShort(),} end,
	S_16004 = function(byteArray) 
		function create_state_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_shop_once_state")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {state_list = create_state_list(byteArray),expire_time = byteArray:readInt(),} end,
	S_16005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_16100 = function(byteArray) 
		function create_mystery_shop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_mystery_shop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {is_open = byteArray:readChar(),mystery_shop_list = create_mystery_shop_list(byteArray),count = byteArray:readShort(),ref_time = byteArray:readInt(),need_jade = byteArray:readInt(),} end,
	S_16101 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_16102 = function(byteArray) 
		function create_mystery_shop_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_mystery_shop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {mystery_shop_list = create_mystery_shop_list(byteArray),result = byteArray:readShort(),} end,
	S_17001 = function(byteArray) return {result = byteArray:readShort(),need_jade = byteArray:readInt(),} end,
	S_17002 = function(byteArray) return {fight = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_17003 = function(byteArray) return {fight = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_17004 = function(byteArray) return {guild_num = byteArray:readShort(),} end,
	S_17005 = function(byteArray) 
		function create_guild_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {guild_info = create_guild_info(byteArray),} end,
	S_17006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17007 = function(byteArray) return {num = byteArray:readShort(),} end,
	S_17008 = function(byteArray) 
		function create_apply_guild_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_apply_guild_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {min_value = byteArray:readShort(),max_value = byteArray:readShort(),apply_guild_info = create_apply_guild_info(byteArray),} end,
	S_17009 = function(byteArray) return {player_id = byteArray:readStringUShort(),type = byteArray:readChar(),result = byteArray:readShort(),} end,
	S_17010 = function(byteArray) return {guild_detailed_info = self:getCmdStruct("proto_guild_detailed_info",byteArray),} end,
	S_17011 = function(byteArray) return {player_guild_info = self:getCmdStruct("proto_player_guild_info",byteArray),} end,
	S_17012 = function(byteArray) 
		function create_guild_member_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_member_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {min_value = byteArray:readShort(),max_value = byteArray:readShort(),guild_member_info_list = create_guild_member_info_list(byteArray),} end,
	S_17013 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17014 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17015 = function(byteArray) return {num = byteArray:readShort(),} end,
	S_17016 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17017 = function(byteArray) 
		function create_equips_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),lv = byteArray:readShort(),sex = byteArray:readChar(),career = byteArray:readShort(),fight = byteArray:readInt(),equips_list = create_equips_list(byteArray),guise = self:getCmdStruct("proto_guise",byteArray),result = byteArray:readShort(),} end,
	S_17018 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17019 = function(byteArray) return {player_id = byteArray:readStringUShort(),position = byteArray:readChar(),result = byteArray:readShort(),} end,
	S_17020 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17050 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17051 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17052 = function(byteArray) 
		function create_donation_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_donation_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {donation_info = create_donation_info(byteArray),} end,
	S_17053 = function(byteArray) 
		function create_guild_log_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {guild_log_info = create_guild_log_info(byteArray),} end,
	S_17054 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17055 = function(byteArray) return {guild_name = byteArray:readStringUShort(),guild_id = byteArray:readStringUShort(),tname = byteArray:readStringUShort(),} end,
	S_17056 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17057 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17058 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17059 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17060 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_17061 = function(byteArray) return {num = byteArray:readChar(),lv = byteArray:readChar(),open_time = byteArray:readInt(),close_time = byteArray:readInt(),} end,
	S_17062 = function(byteArray) return {sbk_name = byteArray:readStringUShort(),lv = byteArray:readChar(),state = byteArray:readInt(),timestamp = byteArray:readInt(),} end,
	S_17063 = function(byteArray) 
		function create_red_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_red_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_red_log_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_red_log")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {red_list = create_red_list(byteArray),red_log_list = create_red_log_list(byteArray),} end,
	S_17064 = function(byteArray) 
		function create_red_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_red_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {red_list = create_red_list(byteArray),} end,
	S_17065 = function(byteArray) 
		function create_red_log_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_red_log")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {red_log_list = create_red_log_list(byteArray),} end,
	S_17066 = function(byteArray) return {red_info = self:getCmdStruct("proto_guild_red_info",byteArray),} end,
	S_17067 = function(byteArray) return {red_log = self:getCmdStruct("proto_guild_red_log",byteArray),} end,
	S_17068 = function(byteArray) return {} end,
	S_17070 = function(byteArray) return {result = byteArray:readInt(),red_id = byteArray:readStringUShort(),jade = byteArray:readInt(),} end,
	S_17071 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_17080 = function(byteArray) return {result = byteArray:readInt(),guild_name_b = byteArray:readStringUShort(),} end,
	S_17081 = function(byteArray) return {guild_id_a = byteArray:readStringUShort(),guild_name_a = byteArray:readStringUShort(),} end,
	S_17082 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_17083 = function(byteArray) return {guild_id_a = byteArray:readStringUShort(),guild_name_a = byteArray:readStringUShort(),guild_id_b = byteArray:readStringUShort(),guild_name_b = byteArray:readStringUShort(),kill_a = byteArray:readShort(),kill_b = byteArray:readShort(),time_left = byteArray:readInt(),} end,
	S_17084 = function(byteArray) return {guild_id_a = byteArray:readStringUShort(),guild_name_a = byteArray:readStringUShort(),guild_id_b = byteArray:readStringUShort(),guild_name_b = byteArray:readStringUShort(),} end,
	S_17085 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_17086 = function(byteArray) return {server_id_a = byteArray:readInt(),guild_id_a = byteArray:readStringUShort(),guild_name_a = byteArray:readStringUShort(),player_id_a = byteArray:readStringUShort(),player_name_a = byteArray:readStringUShort(),} end,
	S_17087 = function(byteArray) return {result = byteArray:readInt(),type = byteArray:readChar(),} end,
	S_17088 = function(byteArray) return {server_id_b = byteArray:readInt(),guild_id_b = byteArray:readStringUShort(),guild_name_b = byteArray:readStringUShort(),player_id_b = byteArray:readStringUShort(),player_name_b = byteArray:readStringUShort(),} end,
	S_17089 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_17090 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_17091 = function(byteArray) return {guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),} end,
	S_17092 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_simple_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_17093 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_standard_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_17094 = function(byteArray) return {result = byteArray:readInt(),guild_info = self:getCmdStruct("proto_guild_standard_info",byteArray),} end,
	S_18001 = function(byteArray) return {chat_info = self:getCmdStruct("proto_world_chat_info",byteArray),} end,
	S_18002 = function(byteArray) return {chat_info = self:getCmdStruct("proto_world_chat_info",byteArray),} end,
	S_18003 = function(byteArray) return {chat_info = self:getCmdStruct("proto_world_chat_info",byteArray),} end,
	S_18006 = function(byteArray) return {chat_info = self:getCmdStruct("proto_world_chat_info",byteArray),} end,
	S_18004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_18005 = function(byteArray) return {md5 = byteArray:readStringUShort(),timestamp = byteArray:readStringUShort(),} end,
	S_18008 = function(byteArray) 
		function create_chat_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_world_chat_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_chat_player_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_world_chat_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_chat_guild_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_world_chat_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_chat_legion_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_world_chat_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {chat_info_list = create_chat_info_list(byteArray),chat_player_list = create_chat_player_list(byteArray),chat_guild_list = create_chat_guild_list(byteArray),chat_legion_list = create_chat_legion_list(byteArray),} end,
	S_18009 = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),content = byteArray:readStringUShort(),} end,
	S_18010 = function(byteArray) return {chat_info = self:getCmdStruct("proto_world_chat_info",byteArray),} end,
	S_19000 = function(byteArray) 
		function create_player_tasklist(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_taskinfo")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_player_reward_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		return {player_tasklist = create_player_tasklist(byteArray),player_reward_list = create_player_reward_list(byteArray),} end,
	S_19001 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_20001 = function(byteArray) return {result = byteArray:readShort(),player_name = byteArray:readStringUShort(),player_lv = byteArray:readChar(),} end,
	S_20002 = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),player_lv = byteArray:readChar(),} end,
	S_20003 = function(byteArray) return {result = byteArray:readShort(),player_name = byteArray:readStringUShort(),player_lv = byteArray:readChar(),} end,
	S_20004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_20005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_20006 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_full_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {jade = byteArray:readInt(),goods_list = create_goods_list(byteArray),} end,
	S_20007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_20008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_20009 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21000 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21001 = function(byteArray) 
		function create_member_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_team_member_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {switch1 = byteArray:readChar(),switch2 = byteArray:readChar(),member_list = create_member_list(byteArray),} end,
	S_21002 = function(byteArray) return {switch_type = byteArray:readChar(),status = byteArray:readChar(),} end,
	S_21003 = function(byteArray) return {value = byteArray:readStringUShort(),type = byteArray:readChar(),} end,
	S_21004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21005 = function(byteArray) return {team_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),player_id = byteArray:readStringUShort(),} end,
	S_21006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21008 = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),} end,
	S_21009 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21010 = function(byteArray) 
		function create_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_near_by_player")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {info_list = create_info_list(byteArray),} end,
	S_21011 = function(byteArray) 
		function create_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_near_by_team")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {info_list = create_info_list(byteArray),} end,
	S_21012 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21013 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21014 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21015 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_21016 = function(byteArray) 
		function create_member_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_team_member_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {member_list = create_member_list(byteArray),} end,
	S_21017 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_22002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_22004 = function(byteArray) 
		function create_follows(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_monster_follow")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {follows = create_follows(byteArray),} end,
	S_22005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_23001 = function(byteArray) return {rank = byteArray:readInt(),} end,
	S_23002 = function(byteArray) return {count = byteArray:readChar(),} end,
	S_23003 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_arena_challenge_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_23004 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_arena_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_23005 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_arena_record")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_23006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_23007 = function(byteArray) return {reputation = byteArray:readInt(),} end,
	S_23008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_23009 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_23010 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_23011 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {result = byteArray:readShort(),goods_list = create_goods_list(byteArray),rank = byteArray:readInt(),} end,
	S_23012 = function(byteArray) return {reputation = byteArray:readInt(),} end,
	S_24000 = function(byteArray) 
		function create_relationship_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_relationship_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),relationship_list = create_relationship_list(byteArray),} end,
	S_24001 = function(byteArray) return {tplayer_id = byteArray:readStringUShort(),type = byteArray:readChar(),result = byteArray:readShort(),} end,
	S_24002 = function(byteArray) return {tplayer_id = byteArray:readStringUShort(),result = byteArray:readShort(),} end,
	S_24003 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_24004 = function(byteArray) return {name = byteArray:readStringUShort(),lv = byteArray:readInt(),career = byteArray:readShort(),tplayer_id = byteArray:readStringUShort(),} end,
	S_24005 = function(byteArray) return {name = byteArray:readStringUShort(),lv = byteArray:readInt(),career = byteArray:readShort(),tplayer_id = byteArray:readStringUShort(),} end,
	S_24006 = function(byteArray) 
		function create_relationship_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_relationship_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),relationship_list = create_relationship_list(byteArray),} end,
	S_24007 = function(byteArray) return {tname = byteArray:readStringUShort(),tplayer_id = byteArray:readStringUShort(),} end,
	S_24008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_24009 = function(byteArray) return {tplayer_id = byteArray:readStringUShort(),result = byteArray:readShort(),} end,
	S_25000 = function(byteArray) 
		function create_city_officer_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_city_officer_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_guild_member_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_member_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {min_value = byteArray:readShort(),max_value = byteArray:readShort(),member_num = byteArray:readInt(),city_officer_list = create_city_officer_list(byteArray),guild_member_list = create_guild_member_list(byteArray),} end,
	S_25001 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_25002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_25003 = function(byteArray) return {officer_id = byteArray:readInt(),isday = byteArray:readChar(),frist_player_name = byteArray:readStringUShort(),isfrist = byteArray:readChar(),title_player_name = byteArray:readStringUShort(),isexery = byteArray:readChar(),every_player_name = byteArray:readStringUShort(),} end,
	S_25004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_25005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_25006 = function(byteArray) 
		function create_city_officer_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_city_officer_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {city_officer_list = create_city_officer_list(byteArray),guild_name = byteArray:readStringUShort(),occupy_day = byteArray:readShort(),officer_id = byteArray:readShort(),next_open_time = byteArray:readInt(),} end,
	S_25007 = function(byteArray) 
		function create_city_officer_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_city_officer_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {city_officer_list = create_city_officer_list(byteArray),} end,
	S_25008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_26000 = function(byteArray) 
		function create_navigate_task_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_navigate_task_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {navigate_task_list = create_navigate_task_list(byteArray),} end,
	S_26001 = function(byteArray) return {result = byteArray:readShort(),task_id = byteArray:readInt(),} end,
	S_26002 = function(byteArray) return {result = byteArray:readShort(),task_id = byteArray:readInt(),} end,
	S_26003 = function(byteArray) 
		function create_navigate_task_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_navigate_task_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {navigate_task_list = create_navigate_task_list(byteArray),} end,
	S_26007 = function(byteArray) return {result = byteArray:readShort(),task_id = byteArray:readInt(),} end,
	S_26008 = function(byteArray) return {record_task_info = self:getCmdStruct("proto_navigate_task_info",byteArray),} end,
	S_26009 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_27000 = function(byteArray) 
		function create_worship_frist_career_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_worship_first_career_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {worship_frist_career_list = create_worship_frist_career_list(byteArray),} end,
	S_27001 = function(byteArray) return {num = byteArray:readInt(),jade_num = byteArray:readInt(),} end,
	S_27002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_28000 = function(byteArray) 
		function create_function_open_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {function_open_list = create_function_open_list(byteArray),} end,
	S_28001 = function(byteArray) 
		function create_activity_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_activity_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {activity_list = create_activity_list(byteArray),} end,
	S_28002 = function(byteArray) 
		function create_function_close_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {function_close_list = create_function_close_list(byteArray),} end,
	S_28003 = function(byteArray) return {state = byteArray:readChar(),} end,
	S_29001 = function(byteArray) return {result = byteArray:readShort(),vip_exp = byteArray:readInt(),} end,
	S_29002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_29004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_29005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_29006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_29007 = function(byteArray) return {vip_exp = byteArray:readInt(),} end,
	S_30001 = function(byteArray) return {order_id = byteArray:readStringUShort(),result = byteArray:readShort(),pay_type = byteArray:readChar(),} end,
	S_30002 = function(byteArray) 
		function create_key_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {key_list = create_key_list(byteArray),} end,
	S_30003 = function(byteArray) return {state = byteArray:readChar(),over_day = byteArray:readInt(),} end,
	S_30004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_31001 = function(byteArray) 
		function create_lv_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {lv_list = create_lv_list(byteArray),} end,
	S_31002 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32001 = function(byteArray) 
		function create_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {info_list = create_info_list(byteArray),} end,
	S_32002 = function(byteArray) return {times = byteArray:readInt(),} end,
	S_32003 = function(byteArray) return {key = byteArray:readShort(),result = byteArray:readShort(),} end,
	S_32004 = function(byteArray) 
		function create_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {info_list = create_info_list(byteArray),} end,
	S_32005 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {goods_list = create_goods_list(byteArray),} end,
	S_32006 = function(byteArray) return {is_sign = byteArray:readChar(),sign_count = byteArray:readChar(),} end,
	S_32007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32009 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lv_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {rank = byteArray:readShort(),rank_list = create_rank_list(byteArray),} end,
	S_32010 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_fight_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {rank = byteArray:readShort(),rank_list = create_rank_list(byteArray),} end,
	S_32011 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_guild_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {rank = byteArray:readShort(),rank_list = create_rank_list(byteArray),} end,
	S_32012 = function(byteArray) 
		function create_active_service_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {begin_time = byteArray:readInt(),end_time = byteArray:readInt(),my_value = byteArray:readInt(),active_service_list = create_active_service_list(byteArray),} end,
	S_32013 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32014 = function(byteArray) 
		function create_sign_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		
		function create_reward_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		return {sign_list = create_sign_list(byteArray),reward_list = create_reward_list(byteArray),count = byteArray:readChar(),} end,
	S_32015 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32016 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32017 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32018 = function(byteArray) 
		function create_open_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		return {start_id = byteArray:readChar(),open_list = create_open_list(byteArray),} end,
	S_32019 = function(byteArray) 
		function create_type_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_type_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type_info_list = create_type_info_list(byteArray),} end,
	S_32020 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_operate_active_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_list2(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_operate_active_info_model_2")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_list3(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_operate_active_info_model_3")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),list2 = create_list2(byteArray),list3 = create_list3(byteArray),} end,
	S_32021 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32030 = function(byteArray) 
		function create_ex_ids(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		return {result = byteArray:readShort(),tools1 = byteArray:readChar(),tools2 = byteArray:readChar(),tools3 = byteArray:readChar(),ex_ids = create_ex_ids(byteArray),rank = byteArray:readInt(),time_left = byteArray:readInt(),} end,
	S_32031 = function(byteArray) return {result = byteArray:readShort(),rank = byteArray:readInt(),is_right = byteArray:readChar(),total_score = byteArray:readInt(),right_num = byteArray:readChar(),error_num = byteArray:readChar(),exp = byteArray:readInt(),coin = byteArray:readInt(),} end,
	S_32032 = function(byteArray) 
		function create_ranks(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_exam_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {ranks = create_ranks(byteArray),} end,
	S_32033 = function(byteArray) 
		function create_params(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readStringUShort()
			end
			return list
		end
		return {result = byteArray:readShort(),type = byteArray:readChar(),params = create_params(byteArray),tools_num = byteArray:readChar(),} end,
	S_32034 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32035 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {rank = byteArray:readInt(),score = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_32036 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_operate_holiday_active_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_32037 = function(byteArray) return {key = byteArray:readInt(),} end,
	S_32038 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_32040 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {my_rank = byteArray:readShort(),my_lv = byteArray:readStringUShort(),begin_time = byteArray:readInt(),end_time = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_32041 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_shop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {begin_time = byteArray:readInt(),end_time = byteArray:readInt(),goods_list = create_goods_list(byteArray),} end,
	S_32042 = function(byteArray) return {result = byteArray:readInt(),active_shop_info = self:getCmdStruct("proto_active_shop",byteArray),} end,
	S_32044 = function(byteArray) 
		function create_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_operate_holiday_change_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {list = create_list(byteArray),} end,
	S_32045 = function(byteArray) return {active_id = byteArray:readInt(),sub_type = byteArray:readChar(),result = byteArray:readShort(),value = byteArray:readShort(),} end,
	S_33000 = function(byteArray) 
		function create_sale_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_sale_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {num = byteArray:readInt(),sale_goods_list = create_sale_goods_list(byteArray),} end,
	S_33001 = function(byteArray) 
		function create_sale_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_sale_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {num = byteArray:readInt(),sale_goods_list = create_sale_goods_list(byteArray),} end,
	S_33002 = function(byteArray) 
		function create_sale_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_sale_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {sale_goods_list = create_sale_goods_list(byteArray),} end,
	S_33003 = function(byteArray) 
		function create_sale_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_player_sale_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {sale_goods_list = create_sale_goods_list(byteArray),} end,
	S_33004 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_33005 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_33006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_33007 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_33008 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_33009 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_33010 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_34000 = function(byteArray) return {result = byteArray:readInt(),} end,
	S_34001 = function(byteArray) return {red_id = byteArray:readStringUShort(),} end,
	S_35000 = function(byteArray) 
		function create_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_lottery_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {log_lists = create_log_lists(byteArray),lottery_goods_list = create_lottery_goods_list(byteArray),num1_need_jade = byteArray:readInt(),num10_need_jade = byteArray:readInt(),begin_time = byteArray:readInt(),end_time = byteArray:readInt(),} end,
	S_35001 = function(byteArray) 
		function create_lottery_id_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_equip_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {lottery_id_list = create_lottery_id_list(byteArray),goods_list = create_goods_list(byteArray),equip_list = create_equip_list(byteArray),result = byteArray:readInt(),} end,
	S_35002 = function(byteArray) 
		function create_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {log_lists = create_log_lists(byteArray),} end,
	S_35004 = function(byteArray) 
		function create_all_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_my_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {all_log_lists = create_all_log_lists(byteArray),my_log_lists = create_my_log_lists(byteArray),group_id = byteArray:readInt(),lottery_score = byteArray:readInt(),num1_need_jade = byteArray:readInt(),num5_need_jade = byteArray:readInt(),num10_need_jade = byteArray:readInt(),begin_time = byteArray:readInt(),end_time = byteArray:readInt(),} end,
	S_35005 = function(byteArray) 
		function create_lottery_id_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_equip_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {lottery_id_list = create_lottery_id_list(byteArray),goods_list = create_goods_list(byteArray),equip_list = create_equip_list(byteArray),lottery_score = byteArray:readInt(),result = byteArray:readInt(),} end,
	S_35006 = function(byteArray) return {lottery_score = byteArray:readInt(),result = byteArray:readInt(),} end,
	S_35007 = function(byteArray) 
		function create_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type = byteArray:readChar(),log_lists = create_log_lists(byteArray),} end,
	S_36000 = function(byteArray) 
		function create_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {log_lists = create_log_lists(byteArray),} end,
	S_36001 = function(byteArray) 
		function create_lottery_id_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_equip_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {lottery_id_list = create_lottery_id_list(byteArray),goods_list = create_goods_list(byteArray),equip_list = create_equip_list(byteArray),result = byteArray:readInt(),} end,
	S_36002 = function(byteArray) 
		function create_log_lists(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_lottery_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {log_lists = create_log_lists(byteArray),} end,
	S_37001 = function(byteArray) return {result = byteArray:readShort(),need_jade = byteArray:readInt(),} end,
	S_37002 = function(byteArray) return {fight = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_37003 = function(byteArray) return {fight = byteArray:readInt(),result = byteArray:readShort(),} end,
	S_37004 = function(byteArray) return {legion_num = byteArray:readShort(),} end,
	S_37005 = function(byteArray) 
		function create_legion_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_legion_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {legion_info = create_legion_info(byteArray),} end,
	S_37006 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37007 = function(byteArray) return {num = byteArray:readShort(),} end,
	S_37008 = function(byteArray) 
		function create_apply_legion_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_apply_legion_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {min_value = byteArray:readShort(),max_value = byteArray:readShort(),apply_legion_info = create_apply_legion_info(byteArray),} end,
	S_37009 = function(byteArray) return {player_id = byteArray:readStringUShort(),type = byteArray:readChar(),result = byteArray:readShort(),} end,
	S_37010 = function(byteArray) return {legion_detailed_info = self:getCmdStruct("proto_legion_detailed_info",byteArray),} end,
	S_37011 = function(byteArray) return {player_legion_info = self:getCmdStruct("proto_player_legion_info",byteArray),} end,
	S_37012 = function(byteArray) 
		function create_legion_member_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_legion_member_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {min_value = byteArray:readShort(),max_value = byteArray:readShort(),legion_member_info_list = create_legion_member_info_list(byteArray),} end,
	S_37013 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37014 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37015 = function(byteArray) return {num = byteArray:readShort(),} end,
	S_37016 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37017 = function(byteArray) 
		function create_equips_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_equips_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),lv = byteArray:readShort(),sex = byteArray:readChar(),career = byteArray:readShort(),fight = byteArray:readInt(),equips_list = create_equips_list(byteArray),guise = self:getCmdStruct("proto_guise",byteArray),result = byteArray:readShort(),} end,
	S_37018 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37019 = function(byteArray) return {player_id = byteArray:readStringUShort(),position = byteArray:readChar(),result = byteArray:readShort(),} end,
	S_37020 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37053 = function(byteArray) 
		function create_legion_log_info(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_legion_log_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {legion_log_info = create_legion_log_info(byteArray),} end,
	S_37054 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_37055 = function(byteArray) return {legion_name = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),tname = byteArray:readStringUShort(),} end,
	S_37056 = function(byteArray) return {result = byteArray:readShort(),} end,
	S_38012 = function(byteArray) 
		function create_active_service_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {begin_time = byteArray:readInt(),end_time = byteArray:readInt(),my_value = byteArray:readInt(),active_service_list = create_active_service_list(byteArray),} end,
	S_38013 = function(byteArray) return {result = byteArray:readShort(),active_service_id = byteArray:readInt(),} end,
	S_38019 = function(byteArray) 
		function create_type_info_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_type_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {type_info_list = create_type_info_list(byteArray),} end,
	S_38040 = function(byteArray) 
		function create_rank_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_service_rank_info")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {my_rank = byteArray:readShort(),my_lv = byteArray:readStringUShort(),begin_time = byteArray:readInt(),end_time = byteArray:readInt(),rank_list = create_rank_list(byteArray),} end,
	S_38041 = function(byteArray) 
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_active_shop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {begin_time = byteArray:readInt(),end_time = byteArray:readInt(),goods_list = create_goods_list(byteArray),} end,
	S_38042 = function(byteArray) return {result = byteArray:readInt(),active_shop_info = self:getCmdStruct("proto_active_shop",byteArray),} end,
	proto_login_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),sex = byteArray:readChar(),career = byteArray:readShort(),lv = byteArray:readShort(),} end,
	proto_attr_base = function(byteArray) return {cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),hp = byteArray:readInt(),mp = byteArray:readInt(),min_ac = byteArray:readInt(),max_ac = byteArray:readInt(),min_mac = byteArray:readInt(),max_mac = byteArray:readInt(),min_sc = byteArray:readInt(),max_sc = byteArray:readInt(),min_def = byteArray:readInt(),max_def = byteArray:readInt(),min_res = byteArray:readInt(),max_res = byteArray:readInt(),crit = byteArray:readInt(),crit_att = byteArray:readInt(),hit = byteArray:readInt(),dodge = byteArray:readInt(),damage_deepen = byteArray:readShort(),damage_reduction = byteArray:readShort(),holy = byteArray:readInt(),skill_add = byteArray:readInt(),m_hit = byteArray:readInt(),m_dodge = byteArray:readInt(),hp_recover = byteArray:readChar(),mp_recover = byteArray:readChar(),resurgence = byteArray:readChar(),damage_offset = byteArray:readChar(),luck = byteArray:readInt(),hp_p = byteArray:readInt(),mp_p = byteArray:readInt(),min_ac_p = byteArray:readInt(),max_ac_p = byteArray:readInt(),min_mac_p = byteArray:readInt(),max_mac_p = byteArray:readInt(),min_sc_p = byteArray:readInt(),max_sc_p = byteArray:readInt(),min_def_p = byteArray:readInt(),max_def_p = byteArray:readInt(),min_res_p = byteArray:readInt(),max_res_p = byteArray:readInt(),crit_p = byteArray:readInt(),crit_att_p = byteArray:readInt(),hit_p = byteArray:readInt(),dodge_p = byteArray:readInt(),damage_deepen_p = byteArray:readShort(),damage_reduction_p = byteArray:readShort(),holy_p = byteArray:readInt(),skill_add_p = byteArray:readInt(),m_hit_p = byteArray:readInt(),m_dodge_p = byteArray:readInt(),hp_recover_p = byteArray:readChar(),mp_recover_p = byteArray:readChar(),resurgence_p = byteArray:readChar(),damage_offset_p = byteArray:readChar(),} end,
	proto_guise = function(byteArray) return {weapon = byteArray:readInt(),clothes = byteArray:readInt(),wing = byteArray:readInt(),pet = byteArray:readInt(),mounts = byteArray:readInt(),mounts_aura = byteArray:readInt(),} end,
	proto_money = function(byteArray) return {coin = byteArray:readInt(),jade = byteArray:readInt(),gift = byteArray:readInt(),smelt_value = byteArray:readInt(),feats = byteArray:readInt(),hp_mark_value = byteArray:readInt(),atk_mark_value = byteArray:readInt(),def_mark_value = byteArray:readInt(),res_mark_value = byteArray:readInt(),} end,
	proto_mark = function(byteArray) return {hp_mark = byteArray:readShort(),atk_mark = byteArray:readShort(),def_mark = byteArray:readShort(),res_mark = byteArray:readShort(),holy_mark = byteArray:readShort(),mounts_mark_1 = byteArray:readShort(),mounts_mark_2 = byteArray:readShort(),mounts_mark_3 = byteArray:readShort(),mounts_mark_4 = byteArray:readShort(),} end,
	proto_hp_set = function(byteArray) return {isuse = byteArray:readChar(),hp = byteArray:readChar(),hp_goods_id = byteArray:readInt(),mp = byteArray:readChar(),mp_goods_id = byteArray:readInt(),} end,
	proto_hpmp_set = function(byteArray) return {isuse = byteArray:readChar(),hp = byteArray:readChar(),hp_mp_goods_id = byteArray:readInt(),} end,
	proto_equip_sell_set = function(byteArray) return {isauto = byteArray:readChar(),white = byteArray:readChar(),green = byteArray:readChar(),blue = byteArray:readChar(),purple = byteArray:readChar(),} end,
	proto_pickup_set = function(byteArray) 
		function create_equip_set(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		
		function create_prop_set(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		
		function create_spec_set(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		return {isauto = byteArray:readChar(),equip_set = create_equip_set(byteArray),prop_set = create_prop_set(byteArray),spec_set = create_spec_set(byteArray),} end,
	proto_player_info = function(byteArray) 
		function create_function_open_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		
		function create_guide_step_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readShort()
			end
			return list
		end
		return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),sex = byteArray:readChar(),career = byteArray:readShort(),lv = byteArray:readShort(),exp = byteArray:readInt(),attr_base = self:getCmdStruct("proto_attr_base",byteArray),guise = self:getCmdStruct("proto_guise",byteArray),money = self:getCmdStruct("proto_money",byteArray),mark = self:getCmdStruct("proto_mark",byteArray),hook_scene_id = byteArray:readShort(),pass_hook_scene_id = byteArray:readShort(),fighting = byteArray:readInt(),bag = byteArray:readInt(),guild_id = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),pk_mode = byteArray:readChar(),pk_value = byteArray:readShort(),name_colour = byteArray:readChar(),vip = byteArray:readChar(),hp_set = self:getCmdStruct("proto_hp_set",byteArray),hpmp_set = self:getCmdStruct("proto_hpmp_set",byteArray),career_title = byteArray:readShort(),equip_sell_set = self:getCmdStruct("proto_equip_sell_set",byteArray),pickup_set = self:getCmdStruct("proto_pickup_set",byteArray),function_open_list = create_function_open_list(byteArray),guide_step_list = create_guide_step_list(byteArray),vip_exp = byteArray:readInt(),wing_state = byteArray:readChar(),weapon_state = byteArray:readChar(),pet_att_type = byteArray:readChar(),pet_num = byteArray:readChar(),register_time = byteArray:readInt(),team_id = byteArray:readStringUShort(),} end,
	proto_obj_flag = function(byteArray) return {type = byteArray:readChar(),id = byteArray:readStringUShort(),} end,
	proto_point = function(byteArray) return {x = byteArray:readShort(),y = byteArray:readShort(),} end,
	proto_buff = function(byteArray) return {buff_id = byteArray:readShort(),effect_id = byteArray:readShort(),countdown = byteArray:readInt(),} end,
	proto_spec_buff = function(byteArray) return {type = byteArray:readShort(),value = byteArray:readInt(),countdown = byteArray:readInt(),} end,
	proto_scene_player = function(byteArray) 
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),name = byteArray:readStringUShort(),sex = byteArray:readChar(),career = byteArray:readShort(),lv = byteArray:readShort(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),hp = byteArray:readInt(),mp = byteArray:readInt(),direction = byteArray:readChar(),begin_point = self:getCmdStruct("proto_point",byteArray),end_point = self:getCmdStruct("proto_point",byteArray),guise = self:getCmdStruct("proto_guise",byteArray),buff_list = create_buff_list(byteArray),guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),legion_name = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),name_colour = byteArray:readChar(),career_title = byteArray:readShort(),pet_num = byteArray:readChar(),server_name = byteArray:readStringUShort(),collect_state = byteArray:readChar(),} end,
	proto_scene_player_update = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),legion_name = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),name_colour = byteArray:readChar(),career_title = byteArray:readShort(),pet_num = byteArray:readChar(),collect_state = byteArray:readChar(),} end,
	proto_scene_obj_often_update = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),obj_atk = self:getCmdStruct("proto_obj_flag",byteArray),cause = byteArray:readChar(),harm_status = byteArray:readChar(),hp_change = byteArray:readInt(),mp_change = byteArray:readInt(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),hp = byteArray:readInt(),mp = byteArray:readInt(),} end,
	proto_scene_pet_update = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),guild_id = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),name_colour = byteArray:readChar(),} end,
	proto_enmity = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),name = byteArray:readStringUShort(),career = byteArray:readShort(),sex = byteArray:readChar(),monster_id = byteArray:readShort(),} end,
	proto_drop_owner = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),name = byteArray:readStringUShort(),} end,
	proto_scene_monster = function(byteArray) 
		function create_buff_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_buff")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),owner_flag = self:getCmdStruct("proto_obj_flag",byteArray),monster_id = byteArray:readShort(),name = byteArray:readStringUShort(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),hp = byteArray:readInt(),mp = byteArray:readInt(),direction = byteArray:readChar(),begin_point = self:getCmdStruct("proto_point",byteArray),end_point = self:getCmdStruct("proto_point",byteArray),buff_list = create_buff_list(byteArray),enmity = self:getCmdStruct("proto_enmity",byteArray),guild_id = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),name_colour = byteArray:readChar(),drop_owner = self:getCmdStruct("proto_drop_owner",byteArray),server_name = byteArray:readStringUShort(),} end,
	proto_scene_drop = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),goods_id = byteArray:readInt(),point = self:getCmdStruct("proto_point",byteArray),num = byteArray:readShort(),player_id = byteArray:readStringUShort(),time_out = byteArray:readShort(),team_id = byteArray:readStringUShort(),} end,
	proto_fire_wall = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),point = self:getCmdStruct("proto_point",byteArray),} end,
	proto_skill = function(byteArray) return {skill_id = byteArray:readInt(),lv = byteArray:readChar(),exp = byteArray:readInt(),pos = byteArray:readChar(),auto_set = byteArray:readChar(),} end,
	proto_player_update = function(byteArray) return {key = byteArray:readShort(),value = byteArray:readInt(),} end,
	proto_attr_value = function(byteArray) return {key = byteArray:readShort(),value = byteArray:readInt(),} end,
	proto_attr_baptize_value = function(byteArray) return {id = byteArray:readChar(),state = byteArray:readChar(),key = byteArray:readShort(),value = byteArray:readInt(),} end,
	proto_harm = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),harm_status = byteArray:readChar(),harm_value = byteArray:readInt(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),} end,
	proto_cure = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),add_hp = byteArray:readInt(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),} end,
	proto_buff_operate = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),operate = byteArray:readChar(),buff_id = byteArray:readShort(),effect_id = byteArray:readShort(),countdown = byteArray:readInt(),} end,
	proto_hook_monster = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),owner_flag = self:getCmdStruct("proto_obj_flag",byteArray),monster_id = byteArray:readShort(),cur_hp = byteArray:readInt(),cur_mp = byteArray:readInt(),hp = byteArray:readInt(),mp = byteArray:readInt(),guild_id = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),name_colour = byteArray:readChar(),} end,
	proto_goods_info = function(byteArray) return {id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),stren_lv = byteArray:readChar(),location = byteArray:readChar(),grid = byteArray:readChar(),expire_time = byteArray:readInt(),map_scene = byteArray:readShort(),map_x = byteArray:readShort(),map_y = byteArray:readShort(),} end,
	proto_equips_info = function(byteArray) 
		function create_baptize_attr_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attr_baptize_value")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),stren_lv = byteArray:readChar(),location = byteArray:readChar(),grid = byteArray:readChar(),baptize_attr_list = create_baptize_attr_list(byteArray),soul = byteArray:readChar(),luck = byteArray:readChar(),expire_time = byteArray:readInt(),secure = byteArray:readChar(),bless = byteArray:readInt(),server_id = byteArray:readInt(),is_use = byteArray:readInt(),} end,
	proto_goods_full_info = function(byteArray) 
		function create_baptize_attr_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attr_baptize_value")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),stren_lv = byteArray:readChar(),location = byteArray:readChar(),grid = byteArray:readChar(),baptize_attr_list = create_baptize_attr_list(byteArray),soul = byteArray:readChar(),luck = byteArray:readChar(),secure = byteArray:readChar(),} end,
	proto_goods_list = function(byteArray) return {goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),} end,
	proto_trade_list = function(byteArray) return {id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),num = byteArray:readInt(),} end,
	proto_mail_info = function(byteArray) 
		function create_award(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_mail_award")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {id = byteArray:readStringUShort(),title = byteArray:readStringUShort(),content = byteArray:readStringUShort(),award = create_award(byteArray),state = byteArray:readChar(),send_time = byteArray:readInt(),} end,
	proto_mail_award = function(byteArray) return {goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),} end,
	proto_guild_info = function(byteArray) return {guild_id = byteArray:readStringUShort(),guild_rank = byteArray:readShort(),guild_name = byteArray:readStringUShort(),chairman_name = byteArray:readStringUShort(),guild_lv = byteArray:readChar(),fight = byteArray:readInt(),number = byteArray:readShort(),} end,
	proto_guild_simple_info = function(byteArray) return {server_id = byteArray:readInt(),guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),} end,
	proto_guild_standard_info = function(byteArray) return {server_id = byteArray:readInt(),guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),chairman_name = byteArray:readStringUShort(),guild_lv = byteArray:readChar(),number = byteArray:readShort(),} end,
	proto_apply_guild_info = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),lv = byteArray:readShort(),career = byteArray:readShort(),fighting = byteArray:readInt(),online = byteArray:readInt(),} end,
	proto_guild_detailed_info = function(byteArray) return {guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),chairman_name = byteArray:readStringUShort(),guild_lv = byteArray:readChar(),guild_rank = byteArray:readShort(),number = byteArray:readShort(),exp = byteArray:readInt(),capital = byteArray:readInt(),announce = byteArray:readStringUShort(),} end,
	proto_guild_member_info = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),position = byteArray:readChar(),lv = byteArray:readShort(),career = byteArray:readShort(),fighting = byteArray:readInt(),contribution = byteArray:readInt(),} end,
	proto_guild_log_info = function(byteArray) return {type = byteArray:readChar(),parameter1 = byteArray:readInt(),parameter2 = byteArray:readStringUShort(),parameter3 = byteArray:readInt(),} end,
	proto_player_guild_info = function(byteArray) return {guild_id = byteArray:readStringUShort(),guild_name = byteArray:readStringUShort(),position = byteArray:readChar(),contribution = byteArray:readInt(),guild_lv = byteArray:readShort(),} end,
	proto_donation_info = function(byteArray) return {type = byteArray:readChar(),count = byteArray:readChar(),} end,
	proto_legion_info = function(byteArray) return {legion_id = byteArray:readStringUShort(),legion_rank = byteArray:readShort(),legion_name = byteArray:readStringUShort(),chairman_name = byteArray:readStringUShort(),legion_lv = byteArray:readChar(),fight = byteArray:readInt(),number = byteArray:readShort(),} end,
	proto_apply_legion_info = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),lv = byteArray:readShort(),career = byteArray:readShort(),fighting = byteArray:readInt(),online = byteArray:readInt(),} end,
	proto_legion_detailed_info = function(byteArray) return {legion_id = byteArray:readStringUShort(),legion_name = byteArray:readStringUShort(),chairman_name = byteArray:readStringUShort(),legion_lv = byteArray:readChar(),legion_rank = byteArray:readShort(),number = byteArray:readShort(),exp = byteArray:readInt(),capital = byteArray:readInt(),announce = byteArray:readStringUShort(),} end,
	proto_legion_member_info = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),position = byteArray:readChar(),lv = byteArray:readShort(),career = byteArray:readShort(),fighting = byteArray:readInt(),contribution = byteArray:readInt(),} end,
	proto_legion_log_info = function(byteArray) return {type = byteArray:readChar(),parameter1 = byteArray:readInt(),parameter2 = byteArray:readStringUShort(),parameter3 = byteArray:readInt(),} end,
	proto_player_legion_info = function(byteArray) return {legion_id = byteArray:readStringUShort(),legion_name = byteArray:readStringUShort(),position = byteArray:readChar(),contribution = byteArray:readInt(),legion_lv = byteArray:readShort(),} end,
	proto_hook_drop = function(byteArray) return {goods_id = byteArray:readInt(),num = byteArray:readInt(),} end,
	proto_goods_report = function(byteArray) return {quality = byteArray:readChar(),num = byteArray:readInt(),sale_num = byteArray:readInt(),} end,
	proto_hook_report = function(byteArray) 
		function create_goods_report_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_report")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_goods_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_hook_drop")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {offline_time = byteArray:readInt(),kill_num = byteArray:readInt(),die_num = byteArray:readShort(),coin = byteArray:readInt(),exp = byteArray:readInt(),goods_report_list = create_goods_report_list(byteArray),goods_list = create_goods_list(byteArray),} end,
	proto_hook_star = function(byteArray) return {hook_scene_id = byteArray:readShort(),star = byteArray:readChar(),reward_status = byteArray:readChar(),} end,
	proto_hook_star_reward = function(byteArray) 
		function create_step_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readChar()
			end
			return list
		end
		return {chapter = byteArray:readShort(),star = byteArray:readChar(),step_list = create_step_list(byteArray),} end,
	proto_hook_fire_wall = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),point = self:getCmdStruct("proto_point",byteArray),interval = byteArray:readShort(),duration = byteArray:readShort(),} end,
	proto_fire_wall_attack = function(byteArray) return {fire_wall_uid = byteArray:readStringUShort(),monster_uid = byteArray:readStringUShort(),} end,
	proto_point_change = function(byteArray) return {obj_flag = self:getCmdStruct("proto_obj_flag",byteArray),begin_point = self:getCmdStruct("proto_point",byteArray),end_point = self:getCmdStruct("proto_point",byteArray),} end,
	proto_taskinfo = function(byteArray) return {task_id = byteArray:readInt(),nownum = byteArray:readInt(),isfinish = byteArray:readChar(),} end,
	proto_boss_refresh = function(byteArray) return {id = byteArray:readChar(),refresh_time = byteArray:readInt(),} end,
	proto_team_member_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),type = byteArray:readChar(),lv = byteArray:readChar(),career = byteArray:readShort(),guild_name = byteArray:readStringUShort(),fight = byteArray:readInt(),is_online = byteArray:readChar(),} end,
	proto_near_by_player = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),lv = byteArray:readChar(),career = byteArray:readShort(),guild_name = byteArray:readStringUShort(),} end,
	proto_near_by_team = function(byteArray) return {team_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),lv = byteArray:readChar(),career = byteArray:readShort(),memeber_num = byteArray:readShort(),guild_name = byteArray:readStringUShort(),} end,
	proto_map_teammate_flag = function(byteArray) return {point = self:getCmdStruct("proto_point",byteArray),} end,
	proto_arena_challenge_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),career = byteArray:readShort(),sex = byteArray:readChar(),fight = byteArray:readInt(),rank = byteArray:readInt(),} end,
	proto_arena_rank_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),career = byteArray:readShort(),fight = byteArray:readInt(),lv = byteArray:readShort(),guild_name = byteArray:readStringUShort(),rank = byteArray:readInt(),} end,
	proto_active_rank_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),score = byteArray:readInt(),rank = byteArray:readInt(),} end,
	proto_active_service_type_info = function(byteArray) return {type_id = byteArray:readShort(),state = byteArray:readChar(),} end,
	proto_arena_record = function(byteArray) return {type = byteArray:readStringUShort(),player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),rank = byteArray:readShort(),time = byteArray:readInt(),} end,
	proto_relationship_info = function(byteArray) return {tplayer_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),lv = byteArray:readChar(),career = byteArray:readShort(),fight = byteArray:readInt(),isonline = byteArray:readChar(),last_offline_time = byteArray:readStringUShort(),} end,
	proto_city_officer_info = function(byteArray) return {officer_id = byteArray:readChar(),tplayer_id = byteArray:readStringUShort(),tname = byteArray:readStringUShort(),guise = self:getCmdStruct("proto_guise",byteArray),sex = byteArray:readChar(),career = byteArray:readShort(),} end,
	proto_navigate_task_info = function(byteArray) return {task_id = byteArray:readInt(),state = byteArray:readChar(),now_num = byteArray:readInt(),} end,
	proto_worship_first_career_info = function(byteArray) return {sex = byteArray:readChar(),career = byteArray:readShort(),name = byteArray:readStringUShort(),fight = byteArray:readInt(),player_id = byteArray:readStringUShort(),} end,
	proto_activity_info = function(byteArray) return {activity_id = byteArray:readShort(),now_num = byteArray:readShort(),max_num = byteArray:readShort(),} end,
	proto_active_info = function(byteArray) return {key = byteArray:readShort(),state = byteArray:readChar(),} end,
	proto_sale_info = function(byteArray) 
		function create_baptize_attr_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attr_baptize_value")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {sale_id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),jade = byteArray:readInt(),num = byteArray:readInt(),time = byteArray:readInt(),stren_lv = byteArray:readChar(),soul = byteArray:readChar(),secure = byteArray:readChar(),baptize_attr_list = create_baptize_attr_list(byteArray),artifact_star = byteArray:readChar(),artifact_lv = byteArray:readChar(),artifact_exp = byteArray:readChar(),} end,
	proto_player_sale_info = function(byteArray) 
		function create_baptize_attr_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_attr_baptize_value")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {id = byteArray:readStringUShort(),goods_id = byteArray:readInt(),jade = byteArray:readInt(),num = byteArray:readInt(),time = byteArray:readInt(),state = byteArray:readChar(),stren_lv = byteArray:readChar(),soul = byteArray:readChar(),secure = byteArray:readChar(),baptize_attr_list = create_baptize_attr_list(byteArray),artifact_star = byteArray:readChar(),artifact_lv = byteArray:readChar(),artifact_exp = byteArray:readChar(),} end,
	proto_button_tips = function(byteArray) return {id = byteArray:readShort(),num = byteArray:readShort(),} end,
	proto_world_boss_rank = function(byteArray) return {rank = byteArray:readShort(),name = byteArray:readStringUShort(),harm = byteArray:readInt(),} end,
	proto_attack_city_rank = function(byteArray) return {rank = byteArray:readShort(),name = byteArray:readStringUShort(),score = byteArray:readInt(),} end,
	proto_wander_shop = function(byteArray) return {shop_id = byteArray:readShort(),count = byteArray:readShort(),} end,
	proto_mystery_shop = function(byteArray) return {mystery_shop_id = byteArray:readShort(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),curr_type = byteArray:readChar(),price = byteArray:readInt(),vip = byteArray:readShort(),is_buy = byteArray:readChar(),discount = byteArray:readStringUShort(),} end,
	proto_active_shop = function(byteArray) return {id = byteArray:readShort(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),buy_num = byteArray:readInt(),limit_num = byteArray:readInt(),curr_type = byteArray:readChar(),price = byteArray:readInt(),price_old = byteArray:readInt(),} end,
	proto_lv_rank_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),career = byteArray:readShort(),lv = byteArray:readShort(),guild_name = byteArray:readStringUShort(),rank = byteArray:readShort(),} end,
	proto_fight_rank_info = function(byteArray) return {player_id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),career = byteArray:readShort(),fight = byteArray:readInt(),guild_name = byteArray:readStringUShort(),rank = byteArray:readShort(),} end,
	proto_guild_rank_info = function(byteArray) return {guild_id = byteArray:readStringUShort(),chief_name = byteArray:readStringUShort(),member_num = byteArray:readShort(),guild_lv = byteArray:readShort(),guild_name = byteArray:readStringUShort(),rank = byteArray:readShort(),} end,
	proto_fb_info = function(byteArray) return {scene_id = byteArray:readShort(),now_times = byteArray:readShort(),buy_times = byteArray:readShort(),limit_buy_times = byteArray:readShort(),next_scene_id = byteArray:readShort(),need_jade = byteArray:readShort(),} end,
	proto_raids_goods_info = function(byteArray) return {goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),} end,
	proto_active_service_info = function(byteArray) return {active_service_id = byteArray:readInt(),is_receive = byteArray:readChar(),state2 = byteArray:readChar(),name = byteArray:readStringUShort(),num = byteArray:readInt(),} end,
	proto_active_service_rank_info = function(byteArray) return {rank = byteArray:readShort(),name = byteArray:readStringUShort(),player_id = byteArray:readStringUShort(),value = byteArray:readInt(),} end,
	proto_guild_red_info = function(byteArray) return {name = byteArray:readStringUShort(),position = byteArray:readInt(),num = byteArray:readInt(),red_id = byteArray:readStringUShort(),des = byteArray:readStringUShort(),state = byteArray:readChar(),} end,
	proto_guild_red_log = function(byteArray) return {id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),jade = byteArray:readInt(),} end,
	proto_lottery_log_info = function(byteArray) return {id = byteArray:readStringUShort(),name = byteArray:readStringUShort(),goods_id = byteArray:readInt(),player_id = byteArray:readStringUShort(),} end,
	proto_lottery_goods_info = function(byteArray) return {id = byteArray:readInt(),goods_id = byteArray:readInt(),is_bind = byteArray:readChar(),num = byteArray:readInt(),} end,
	proto_world_chat_info = function(byteArray) return {player_id = byteArray:readStringUShort(),player_name = byteArray:readStringUShort(),vip = byteArray:readChar(),time = byteArray:readInt(),content = byteArray:readStringUShort(),team_id = byteArray:readStringUShort(),guild_id = byteArray:readStringUShort(),legion_id = byteArray:readStringUShort(),} end,
	proto_line_info = function(byteArray) return {line_num = byteArray:readShort(),state = byteArray:readChar(),player_num = byteArray:readShort(),} end,
	proto_operate_active_info = function(byteArray) 
		function create_show_reward(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {active_id = byteArray:readShort(),mark = byteArray:readChar(),model = byteArray:readChar(),title = byteArray:readStringUShort(),content = byteArray:readStringUShort(),show_reward = create_show_reward(byteArray),is_button = byteArray:readChar(),button_content = byteArray:readStringUShort(),is_window = byteArray:readChar(),window_content = byteArray:readStringUShort(),start_time = byteArray:readInt(),end_time = byteArray:readInt(),state = byteArray:readInt(),} end,
	proto_operate_active_info_model_2 = function(byteArray) 
		function create_sub_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_model_2")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {active_id = byteArray:readShort(),mark = byteArray:readChar(),model = byteArray:readChar(),title = byteArray:readStringUShort(),content = byteArray:readStringUShort(),content_value = byteArray:readInt(),sub_list = create_sub_list(byteArray),start_time = byteArray:readInt(),end_time = byteArray:readInt(),cur_time = byteArray:readInt(),is_count_down = byteArray:readChar(),} end,
	proto_model_2 = function(byteArray) 
		function create_show_reward(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {sub_type = byteArray:readShort(),content = byteArray:readStringUShort(),show_reward = create_show_reward(byteArray),state = byteArray:readInt(),} end,
	proto_operate_active_info_model_3 = function(byteArray) 
		function create_sub_list(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_model_3")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {active_id = byteArray:readShort(),mark = byteArray:readChar(),model = byteArray:readChar(),title = byteArray:readStringUShort(),sub_list = create_sub_list(byteArray),start_time = byteArray:readInt(),end_time = byteArray:readInt(),cur_time = byteArray:readInt(),is_count_down = byteArray:readChar(),} end,
	proto_model_3 = function(byteArray) 
		function create_old_price(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_new_price(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		
		function create_shop(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			local fun = self:getCmdStructFun("proto_goods_list")
			for i=1,len do
				list[i] = fun(byteArray)
			end
			return list
		end
		return {sub_type = byteArray:readShort(),content = byteArray:readStringUShort(),old_price = create_old_price(byteArray),new_price = create_new_price(byteArray),shop = create_shop(byteArray),count = byteArray:readInt(),} end,
	proto_operate_holiday_active_info = function(byteArray) return {active_id = byteArray:readShort(),type = byteArray:readShort(),start_time = byteArray:readInt(),end_time = byteArray:readInt(),} end,
	proto_operate_holiday_change_info = function(byteArray) return {active_id = byteArray:readShort(),fusion_id = byteArray:readShort(),count = byteArray:readInt(),} end,
	proto_exam_rank_info = function(byteArray) return {name = byteArray:readStringUShort(),score = byteArray:readInt(),rank = byteArray:readInt(),} end,
	proto_monster_follow = function(byteArray) return {scene_id = byteArray:readInt(),monster_id = byteArray:readInt(),} end,
	proto_monster_boss_drop = function(byteArray) 
		function create_monster_goods(byteArray)
			local len = byteArray:readShort()
			local list = create_array(len)
			for i=1,len do
				list[i] = byteArray:readInt()
			end
			return list
		end
		return {planer_name = byteArray:readStringUShort(),scene_id = byteArray:readInt(),monster_id = byteArray:readInt(),monster_goods = create_monster_goods(byteArray),kill_time = byteArray:readInt(),} end,
	proto_boss_time_and_follow = function(byteArray) return {scene_id = byteArray:readInt(),monster_id = byteArray:readInt(),refresh_time = byteArray:readInt(),follow = byteArray:readChar(),} end,
	proto_city_boss_killer = function(byteArray) return {monster_id = byteArray:readInt(),player_name = byteArray:readStringUShort(),} end,
	proto_word_map_info = function(byteArray) return {scene_id = byteArray:readInt(),state = byteArray:readShort(),} end,
	proto_shop_once_state = function(byteArray) return {lv = byteArray:readShort(),pos = byteArray:readChar(),state = byteArray:readChar(),} end,
	proto_instance_king_rank = function(byteArray) return {rank = byteArray:readShort(),name = byteArray:readStringUShort(),score = byteArray:readInt(),} end,
	proto_instance_king_rank_full = function(byteArray) return {rank = byteArray:readShort(),name = byteArray:readStringUShort(),lv = byteArray:readShort(),career = byteArray:readShort(),score = byteArray:readInt(),} end,
	proto_hjzc_rank_info = function(byteArray) return {player_id = byteArray:readStringUShort(),rank = byteArray:readShort(),name = byteArray:readStringUShort(),num = byteArray:readInt(),} end,
	proto_palace_scene = function(byteArray) return {scene_id = byteArray:readInt(),time = byteArray:readInt(),} end,
	proto_palace_boss_num = function(byteArray) return {scene_id = byteArray:readInt(),boss_id = byteArray:readInt(),num = byteArray:readInt(),} end,


}


end

function GameProtocol:getCmdStruct(cmdId, byteArray)
    return self.cmdStruct[cmdId](byteArray)
end

function GameProtocol:getCmdStructFun(cmdId)
    return self.cmdStruct[cmdId]
end

function GameProtocol:writeDataPacket(cmdId, data, buffer)
    return self.dataStruct[cmdId](data, buffer)
end

function GameProtocol:writeDataPacketFun(cmdId)
    return self.dataStruct[cmdId]
end

function GameProtocol.wiriteString(data, buffer)
    local __s = string.pack(buffer:_getLC("P"), data)--writeStringUShort
	buffer:writeBuf(__s)
	return #__s
end

return GameProtocol

