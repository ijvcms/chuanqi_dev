ERR_COMMON_SUCCESS 					= 0		--操作成功
ERR_COMMON_FAIL 					= 1		--操作失败
ERR_PLAYER_LV_NOT_ENOUGH 			= 2		--玩家等级不足
ERR_PLAYER_COIN_NOT_ENOUGH 			= 3		--玩家金币不足
ERR_PLAYER_JADE_NOT_ENOUGH 			= 4		--玩家元宝不足
ERR_PLAYER_SMELT_NOT_ENOUGH 		= 5		--玩家熔炼值不足
ERR_PLAYER_CAREER_LIMIT 			= 6		--玩家职业限制
ERR_PLAYER_BAG_NOT_ENOUGH 			= 7		--玩家背包不足
ERR_PLAYER_GIFT_NOT_ENOUGH 			= 8 	--玩家礼券不足
ERR_PLAYER_FIGHT_NOT_ENOUGH			= 9		--玩家战斗力不足



--[[
%% 自定义错误码(>=1001)
--]]
--角色模块
ERR_PLAYER_NOT 						= 1001	--没有该玩家
ERR_PLAYER_MAX 						= 1002	--角色数量已经创建满

--道具模块
ERR_GOODS_CANNOT_USE				= 1101	--道具不能使用
ERR_GOODS_NOT_ENOUGH				= 1102	--道具不足
ERR_GOODS_NOT_EXIST					= 1103	--道具不存在
ERR_WEAR_GRID_ERROR					= 1104	--装备穿戴位置错误
ERR_EQUIPS_CANNOT_BAP				= 1105	--装备不能洗练
ERR_FORGE_UPDATE_TIMES_NOT_ENOUGH	= 1106	--锻造刷新次数不足
ERR_NOT_ART_CANNOT_DEVOUR			= 1107	--非神器不能吞噬
ERR_GOODS_NOT_ART  					= 1108	--主物品不是神器
ERR_NOT_ART_CANNOT_INHERIT  		= 1109	--非神器不能传承
ERR_MAX_BAG_LIMIT 					= 1110  --背包格子已达上限
ERR_NOT_EQUIPS_WEAPON 				= 1111	--未装备武器
ERR_BLESS_OIL_NOT_EFFECT			= 1112	--祝福油使用无效
ERR_BLOOD_BAG_ENOUGH				= 1113	--血包已满
ERR_MAIL_NOT_EXIST 					= 1201	--邮件不存在

--行会模块

ERR_GUILD_NOT_EXIST						= 17001				--行会不存在
ERR_PLAYER_NOT_HUIZHANG					= 17002				--非会长
ERR_GUILD_APPLY_ENOUGH					= 17003				--行会申请列表已满
ERR_GUILD_MEMBER_ENOUGH					= 17004				--行会成员已满
ERR_APPLIST_NOT_EXIST					= 17005				--玩家不在申请列表
ERR_PLAYER_JOINED_GUILD					= 17006				--玩家已经加入行会
ERR_PLAYER_NOT_JOINED_GUILD				= 17007				--玩家还未加入行会
ERR_GUILD_LV_NOT_ENOUGH  				= 17008				--行会等级不够
ERR_GUILD_NAME_LEN_LIMIT  				= 17009				--行会名字长度限制
ERR_GUILD_NAME_ERROR  					= 17010				--名字不符合要求
ERR_GUILD_LEAVE_NOT_ENOUGH_24_HOURS  	= 17011				--玩家离开行会未满24小时
ERR_GUILD_NAME_SAME  					= 17012				--工会同名
ERR_PLAYER_LOGOUT						= 17013				--玩家不在线
ERR_GUILD_POSITION 						= 17014				--公会职位已达上限
ERR_PLAYER_ALREADY_DONATE  				= 17020				--今天已捐献
ERR_PLAYER_CONTRIBUTION_NOT_ENOUGH  	= 17021				--玩家行会贡献不足
ERR_PLAYER_COUNT_NOT_ENOUGH  			= 17022				--兑换次数不足

--交易模块
ERR_PLAYERB_REFUSE_TRADE 				= 20001				--对方拒绝交易
ERR_PLAYER_TRADEING 					= 20002				--玩家正在进行交易






ErrorCodeNormalInfo = 
{
	[0] = "操作成功!",
	[1] = "操作失败!",
	[2] = "等级不足!",
	[3] = "金币不足!",
	[4] = "元宝不足!",
	[5] = "熔炼值不足!",
	[6] = "职业不符!",
	[7] = "背包容量不足!",
	[8] = "礼券不足!",
	[9] = "战斗力不足!",
 
	--[[
	%% 自定义错误码(>=1001)
	--]]
	--角色模块
	[1001] = "没有该玩家",
	[1002] = "角色数量已经创建满",


	--道具模块
	[1101] = "道具不能使用",
	[1102] = "道具不足",
	[1103] = "道具不存在",
	[1104] = "装备穿戴位置错误",
	[1105] = "装备不能洗练",
	[1106] = "锻造刷新次数不足",
	[1107] = "非神器不能吞噬",
	[1108] = "主物品不是神器",
	[1109] = "非神器不能传承",
	[1110] = "背包格子已达上限",
	[1111] = "未装备武器",
	[1112] = "祝福油使用无效",
	[1113] = "血包已满",
	[1116] = "装备强化失败",
	[1201] = "邮件不存在",

	--行会模块
	[17001] = "行会不存在",
	[17002] = "非会长",
	[17003] = "行会申请列表已满",
	[17004] = "行会成员已满",
	[17005] = "玩家不在申请列表",
	[17006] = "玩家已经加入行会",
	[17007] = "玩家还未加入行会",
	[17008]	= "行会等级不够",
	[17009]	= "行会名字长度限制",
	[17010]	= "名字不符合要求",			
	[17011]	= "玩家离开行会未满24小时",			
	[17012]	= "行会同名",
	[17013] = "玩家不在线",
	[17014] = "公会职位已达上限",
	[17020]	= "今天已捐献",
	[17021]	= "玩家行会贡献不足",
	[17022] = "兑换次数不足",
	
	[17024] = "沙巴克秘境已开启",
	[17025] = "非沙巴克行会",
	[17026] = "沙巴克秘境未开启",
	[17027] = "行会活动未开启",
	[17028] = "活动次数不足",
	[17029] = "行会资金不足",

	-- 聊天模块
	[18001] = "您已被禁言！",

	--交易模块
	[20001] = "对方拒绝交易",				
	[20002]	= "玩家正在进行交易",

	--组队模块
	[21001] = "该玩家已有队伍",
	[21002] = "该玩家没有队伍",
	[21003] = "该玩家不是队长",
	[21004] = "该队伍人数已满",
	[21005] = "该队伍不存在",

	--排位赛模块
	[23001] = "挑战的玩家不存在",
	[23002] = "您的声望不足",
	[23003] = "购买失败，该商品购买次数已达上限",
	[23004] = "挑战次数不足",
	--好友
	[3001] = "玩家已是好友",
	[3002] = "好友名额超出上限",
	[3003] = "对方好友名额超出上限",
	[3004] = "对方已经离线",
	[3005] = "重复申请",
	[3006] = "黑名单数量已超出上限",
	[3007] = "该玩家已在你黑名单中",
	--沙巴克官员任命
	[4001] = "您权限不够",
	[4002] = "数据错误",
	[4003] = "您已领取过奖励",
	[4004] = "任命官员达到上限",
	[4005] = "该成员已经有官职",

	[1001] = "没有该玩家",
	[1002] = "角色数量已经创建满",
	[1003] = "该角色名已存在",

	[5001] = "数据错误",
	[5002] = "你的元宝不足",

}

function ErrorCodeInfoFormat(errorCode,info)
	return {errorCode=errorCode,info=info}
end