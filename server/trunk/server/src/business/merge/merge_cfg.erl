%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 六月 2016 下午4:02
%%%-------------------------------------------------------------------
-module(merge_cfg).
-include("common.hrl").
-include("cache.hrl").
-include("db_record.hrl").

-define(APP, server).

%% API
-export([
	get_list/0,
	get_player_shift/1,
	get_keys/1,
	get_source_servers/0
]).

get_list() ->
	[db_player_base, db_account, db_arena_shop, db_buff, db_button_tips, db_city_info, db_city_officer, db_guild,
		db_hook_star_reward, db_lottery_db, db_lottery_log, db_mail_conf, db_monster_kills, db_pet,
		db_player_active_service, db_player_arena_rank, db_arena_record, db_player_attr, db_player_batch_record, db_player_black,
		db_player_charge, db_player_counter, db_player_drop, db_player_foe, db_player_friend, db_player_friend_ask,
		db_goods, db_player_guide, db_player_guild, db_player_guild_shop, db_player_hook_star, db_player_instance,
		db_player_instance_pass, db_player_mail, db_player_mark, db_player_money, db_player_monster, db_player_monster_drop,
		db_player_monster_follow, db_player_monster_state, db_player_month, db_player_package,
		db_player_red, db_player_sale, db_player_shop_once, db_player_sign, db_player_task, db_player_task_finish, db_player_vip,
		db_red_record, db_relationship, db_sale, db_skill, db_special_drop].


get_player_shift(1002) -> 3874060500992;
get_player_shift(1001) -> 3869765533696;
get_player_shift(202) -> 3874060500992;
get_player_shift(201) -> 3869765533696;
get_player_shift(2) -> 3874060500992;
get_player_shift(1) -> 3869765533696;
get_player_shift(_ServerId) -> 0.

get_keys(db_account) -> [#db_account.player_id];
get_keys(db_arena_shop) -> [#db_arena_shop.player_id];
get_keys(db_buff) -> [#db_buff.player_id];
get_keys(db_button_tips) -> null;%%[1];
get_keys(db_city_info) -> null;
get_keys(db_city_officer) -> null;
get_keys(db_function) -> null;
get_keys(db_guild) -> [#db_guild.chief_id, #db_guild.guild_id];
get_keys(db_hook_star_reward) -> [#db_hook_star_reward.player_id];
get_keys(db_lottery_coin_db) -> null;
get_keys(db_lottery_coin_log) -> null;
get_keys(db_lottery_db) -> null;	%%保留一份
get_keys(db_lottery_log) -> null;
get_keys(db_mail_conf) -> null;
get_keys(db_monster_kills) -> null;
get_keys(db_pet) -> [#db_pet.player_id];
get_keys(db_player_active_service) -> null;
get_keys(db_player_arena_rank) ->null;
get_keys(db_arena_record) -> [#db_arena_record.player_id];
get_keys(db_player_attr) -> [#db_player_attr.player_id];
get_keys(db_player_base) -> [#db_player_base.player_id, #db_player_base.guild_id];
get_keys(db_player_batch_record) -> [#db_player_batch_record.player_id];
get_keys(db_player_black) -> [#db_player_black.player_id, #db_player_black.tplayer_id];
get_keys(db_player_charge) -> [#db_player_charge.player_id, #db_player_charge.id];
get_keys(db_player_counter) -> [#db_player_counter.player_id];
get_keys(db_player_drop) -> null;	%%保留一份
get_keys(db_player_foe) -> [#db_player_foe.player_id, #db_player_foe.tplayer_id];
get_keys(db_player_friend) -> [#db_player_friend.player_id, #db_player_friend.tplayer_id];
get_keys(db_player_friend_ask) -> [#db_player_friend_ask.player_id, #db_player_friend_ask.tplayer_id];
get_keys(db_goods) -> [#db_goods.player_id, #db_goods.id];
get_keys(db_player_guide) -> [#db_player_guide.player_id];
get_keys(db_player_guild) -> [#db_player_guild.player_id, #db_player_guild.guild_id];
get_keys(db_player_guild_shop) -> [#db_player_guild_shop.player_id];
get_keys(db_player_hook_star) -> [#db_player_hook_star.player_id];
get_keys(db_player_instance) -> [#db_player_instance.player_id];
get_keys(db_player_instance_pass) -> [#db_player_instance_pass.player_id];
get_keys(db_player_mail) -> [#db_player_mail.player_id, #db_player_mail.id];
get_keys(db_player_mark) -> [#db_player_mark.player_id];
get_keys(db_player_money) -> [#db_player_money.player_id];
get_keys(db_player_monster) -> [#db_player_monster.player_id];
get_keys(db_player_monster_drop) -> null; %%[#db_player_monster_drop.player_id, #db_player_monster_drop.id];
get_keys(db_player_monster_follow) -> [#db_player_monster_follow.player_id];
get_keys(db_player_monster_state) -> [#db_player_monster_state.player_id];
get_keys(db_player_month) -> [#db_player_month.player_id];
get_keys(db_player_package) -> [#db_player_package.player_id];
get_keys(db_player_red) -> null;
get_keys(db_player_sale) -> [#db_player_sale.player_id, #db_player_sale.id];
get_keys(db_player_shop_once) -> [#db_player_shop_once.player_id];
get_keys(db_player_sign) -> [#db_player_sign.player_id];
get_keys(db_player_task) -> [#db_player_task.player_id];
get_keys(db_player_task_finish) -> [#db_player_task_finish.player_id];
get_keys(db_player_vip) -> [#db_player_vip.player_id];
get_keys(db_red_record) -> [#db_red_record.player_id, #db_red_record.guild_id];
get_keys(db_relationship) -> null;
get_keys(db_sale) -> [#db_sale.player_id, #db_sale.sale_id];
get_keys(db_skill) -> [#db_skill.player_id];
get_keys(db_special_drop) -> null;	%%保留一份
get_keys(_) -> null.

get_source_servers() ->
	case application:get_env(?APP, source_servers) of
		{ok, ServerIds} ->
			ServerIds;
		_ ->
			[]
	end.