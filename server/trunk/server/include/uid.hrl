%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 七月 2015 下午2:49
%%%-------------------------------------------------------------------

%% 定义uid类型
-define(UID_TYPE_PLAYER, 1).
-define(UID_TYPE_TEAM, 2).
-define(UID_TYPE_PLAYER_GOODS, 3).
-define(UID_TYPE_PLAYER_MAIL, 4).
-define(UID_TYPE_GUILD, 5).
-define(UID_TYPE_PET, 6).
-define(UID_TYPE_SALE, 7).
-define(UID_TYPE_PLAYER_SALE, 8).
-define(UID_TYPE_PLAYER_CHARGE, 9).
-define(UID_TYPE_RED_RECORD, 10).
-define(UID_TYPE_PLAYER_RED, 11).
-define(UID_TYPE_LOTTERY_LOG, 12).
-define(UID_TYPE_LOTTERY_COIN_LOG, 13).
-define(UID_TYPE_PLAYER_MYSTERY_SHOP, 14).
-define(UID_TYPE_PLAYER_MONSTER_DROP, 15).
-define(UID_TYPE_LEGION, 16).
-define(UID_TYPE_LOTTERY_BOX_LOG, 17).
-define(UID_TYPE_ALLIANCE, 18).%% 结盟id

-record(conf_uid, {
	type = 0,    %% 类型
	table = "",    %% 表名
	key_field = ""  %% key字段名
}).

-define(UID_CONF, [
	#conf_uid{type = ?UID_TYPE_PLAYER, table = "player_base", key_field = "player_id"},
	#conf_uid{type = ?UID_TYPE_TEAM},
	#conf_uid{type = ?UID_TYPE_PLAYER_GOODS, table = "player_goods", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_MAIL, table = "player_mail", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_GUILD, table = "guild", key_field = "guild_id"},
	#conf_uid{type = ?UID_TYPE_SALE, table = "sale", key_field = "sale_id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_SALE, table = "player_sale", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_CHARGE, table = "player_charge", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_RED_RECORD, table = "red_record", key_field = "red_id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_RED, table = "player_red", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_LOTTERY_LOG, table = "lottery_log", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_LOTTERY_COIN_LOG, table = "lottery_coin_log", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_LOTTERY_BOX_LOG, table = "lottery_box_log", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_MYSTERY_SHOP, table = "player_mystery_shop", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_PLAYER_MONSTER_DROP, table = "player_monster_drop", key_field = "id"},
	#conf_uid{type = ?UID_TYPE_LEGION, table = "legion", key_field = "legion_id"},
	#conf_uid{type = ?UID_TYPE_PET},
	#conf_uid{type = ?UID_TYPE_ALLIANCE, table = "guild_alliance", key_field = "alliance_id"}
]).