local EquipModel = class("EquipModel")


EquipModel.id                    = 0  			--道具唯一id
EquipModel.goods_id              = 0 			--道具id
EquipModel.is_bind               = false 		--是否绑定
EquipModel.num                   = 0            --数量
EquipModel.stren_lv              = 0            --强化等级
EquipModel.location              = 0            --存放位置
EquipModel.grid                  = 0            --存放所在格子
EquipModel.baptize_attr_list     = nil      	--装备的洗练属性
EquipModel.artifact_star         = 0           	--神器属性条数
EquipModel.artifact_lv           = 0            --神器等级
EquipModel.artifact_exp          = 0            --神器经验
EquipModel.soul                  = 0           	--铸魂
EquipModel.luck                  = 0            --幸运值
EquipModel.expire_time           = 0
EquipModel.sort                  = 0
EquipModel.secure                = 0
EquipModel.bless                 = 0   			--祝福值
EquipModel.server_id             = 0 or 0
EquipModel.is_use                = 1   			--1可以使用 0不可使用
EquipModel.fighting              =  0     		--装备评分

function EquipModel.mapServerModel(serverModel)
	local model = EquipModel.new()
	model.id                    = serverModel.id or 0                      --道具唯一id
	model.goods_id              = serverModel.goods_id or 0                --道具id
	model.is_bind               = serverModel.is_bind or 0                 --是否绑定
	model.num                   = serverModel.num or 0                     --数量
	model.stren_lv              = serverModel.stren_lv or 0                --强化等级
	model.location              = serverModel.location or 0                --存放位置
	model.grid                  = serverModel.grid or 0                    --存放所在格子
	model.baptize_attr_list     = serverModel.baptize_attr_list or {}      --装备的洗练属性
	model.artifact_star         = serverModel.artifact_star or 0           --神器属性条数
	model.artifact_lv           = serverModel.artifact_lv or 0             --神器等级
	model.artifact_exp          = serverModel.artifact_exp or 0            --神器经验
	model.soul                  = serverModel.soul or 0            --铸魂
	model.luck                  = serverModel.luck or 0            --幸运值
	model.expire_time           = serverModel.expire_time or 0
	model.sort                  = serverModel.sort or 0 
	model.secure               	= serverModel.secure or 0 
	model.bless                 = serverModel.bless or 0   --祝福值
	model.server_id             = serverModel.server_id or 0
	model.is_use                = serverModel.is_use or 1   --1可以使用 0不可使用
	    
	model.fighting              =  EquipUtil.getEquipFight(model)     --装备评分
	return model
end


return EquipModel