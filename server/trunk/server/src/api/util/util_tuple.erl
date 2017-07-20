%% @author qhb
%% @doc @todo Add description to util_tuple.


-module(util_tuple).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("db_record.hrl").

-define(LIST_TO_RECORD(RecName, List), list_to_tuple([RecName])).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	copy_elements/2,
	update/2,
	update_counter/2,
	filter_value/2,
	to_tuple_list/1,
	fields/1,
	update/3
]).

copy_elements(DestTuple, SrcTuple) ->
	DestList = tuple_to_list(DestTuple),
	SrcList = tuple_to_list(SrcTuple),
	List = util_list:copy_elements(DestList, SrcList),
	list_to_tuple(List).

update([], _FunMap, Tuple) ->
	Tuple;
update([{K, V} | T], FunMap, Tuple) ->
	List = FunMap(K),
	UpdateList = make_update_list(List, Tuple, []),
	NewTuple = update1(UpdateList, V),
	update(T, FunMap, NewTuple).

update1([], V) ->
	V;
update1([{K, R} | T], V) ->
	NV = setelement(K, R, V),
	update1(T, NV).

make_update_list([], _R, List) ->
	List;
make_update_list([K | T], R, List) ->
	NR = element(K, R),
	make_update_list(T, NR, [{K, R} | List]).

update(Tuple, UpList) ->
	lists:foldl(fun({Index, Value}, TupleAcc) ->
		setelement(Index, TupleAcc, Value)
	end, Tuple, UpList).

update_counter(Tuple, UpList) ->
	lists:foldl(fun({Index, Change}, TupleAcc) ->
		Value = element(Index, TupleAcc),
		setelement(Index, TupleAcc, Value + Change)
	end, Tuple, UpList).

filter_value(Tuple, Value) ->
	List = tuple_to_list(Tuple),
	ListNew = lists:map(fun(Val) ->
		case Val == Value of
			true -> undefined;
			false -> Val
		end
	end, List),
	list_to_tuple(ListNew).

%% #record{k1 = v1, k2 = v2} => [{k1, v1}, {k2, v2}]
%% 只有rec_util表中配置的record才可用
to_tuple_list(Tuple) ->
	[H | V] = tuple_to_list(Tuple),
	K = fields(H),
	to_tuple_list(K, V, []).

to_tuple_list([], [], List) ->
	List;
to_tuple_list([K | KT], [V | VT], List) ->
	case util_data:is_null(V) of
		true ->
			to_tuple_list(KT, VT, List);
		_ ->
			to_tuple_list(KT, VT, [{K, V} | List])
	end.

fields(db_player_base) -> record_info(fields, db_player_base);
fields(db_player_money) -> record_info(fields, db_player_money);
fields(db_account) -> record_info(fields, db_account);
fields(db_log_account) -> record_info(fields, db_log_account);
fields(db_player_attr) -> record_info(fields, db_player_attr);
fields(db_skill) -> record_info(fields, db_skill);
fields(db_goods) -> record_info(fields, db_goods);
fields(db_player_counter) -> record_info(fields, db_player_counter);
fields(db_player_hook_star) -> record_info(fields, db_player_hook_star);
fields(db_buff) -> record_info(fields, db_buff);
fields(db_player_mail) -> record_info(fields, db_player_mail);
fields(db_hook_star_reward) -> record_info(fields, db_hook_star_reward);
fields(db_guild) -> record_info(fields, db_guild);
fields(db_guild_alliance) -> record_info(fields, db_guild_alliance);
fields(db_player_guild) -> record_info(fields, db_player_guild);
fields(db_player_guild_shop) -> record_info(fields, db_player_guild_shop);
fields(db_player_task) -> record_info(fields, db_player_task);%% yubin添加
fields(db_player_task_finish) -> record_info(fields, db_player_task_finish);%% yubin添加
fields(db_arena_rank) -> record_info(fields, db_arena_rank);
fields(db_arena_record) -> record_info(fields, db_arena_record);
fields(db_arena_shop) -> record_info(fields, db_arena_shop);
fields(db_player_black) -> record_info(fields, db_player_black);%% yubin添加
fields(db_player_foe) -> record_info(fields, db_player_foe);%% yubin添加
fields(db_player_friend) -> record_info(fields, db_player_friend);%% yubin添加
fields(db_player_friend_ask) -> record_info(fields, db_player_friend_ask);%% yubin添加
fields(db_player_instance) -> record_info(fields, db_player_instance);
fields(db_player_instance_pass) -> record_info(fields, db_player_instance_pass);
fields(db_city_info) -> record_info(fields, db_city_info);
fields(db_city_officer) -> record_info(fields, db_city_officer);
fields(db_player_guide) -> record_info(fields, db_player_guide);
fields(db_player_vip) -> record_info(fields, db_player_vip);
fields(db_player_package) -> record_info(fields, db_player_package);
fields(db_pet) -> record_info(fields, db_pet);
fields(db_sale) -> record_info(fields, db_sale);
fields(db_player_sale) -> record_info(fields, db_player_sale);
fields(db_button_tips) -> record_info(fields, db_button_tips);
fields(db_monster_kills) -> record_info(fields, db_monster_kills);
fields(db_player_charge) -> record_info(fields, db_player_charge);
fields(db_player_active_service) -> record_info(fields, db_player_active_service);%% 开服活动信息
fields(db_log_money) -> record_info(fields, db_log_money);
fields(db_log_exp) -> record_info(fields, db_log_exp);
fields(db_player_sign) -> record_info(fields, db_player_sign);
fields(db_player_drop) -> record_info(fields, db_player_drop);
fields(db_special_drop) -> record_info(fields, db_special_drop);
fields(db_player_month) -> record_info(fields, db_player_month);
fields(db_red_record) -> record_info(fields, db_red_record);
fields(db_player_red) -> record_info(fields, db_player_red);
fields(db_player_monster) -> record_info(fields, db_player_monster);
fields(db_lottery_db) -> record_info(fields, db_lottery_db);
fields(db_lottery_log) -> record_info(fields, db_lottery_log);
fields(db_lottery_coin_db) -> record_info(fields, db_lottery_coin_db);
fields(db_lottery_coin_log) -> record_info(fields, db_lottery_coin_log);
fields(db_lottery_box_db) -> record_info(fields, db_lottery_box_db);
fields(db_lottery_box_log) -> record_info(fields, db_lottery_box_log);
fields(db_function) -> record_info(fields, db_function);
fields(db_log_chat) -> record_info(fields, db_log_chat);
fields(db_log_dead) -> record_info(fields, db_log_dead);
fields(db_log_trade) -> record_info(fields, db_log_trade);
fields(db_log_goods) -> record_info(fields, db_log_goods);
fields(db_log_goods_attr) -> record_info(fields, db_log_goods_attr);
fields(db_log_fight) -> record_info(fields, db_log_fight);
fields(db_log_reputation) -> record_info(fields, db_log_reputation);
fields(db_log_drop) -> record_info(fields, db_log_drop);
fields(db_log_login) -> record_info(fields, db_log_login);
fields(db_log_mail) -> record_info(fields, db_log_mail);
fields(db_log_daily) -> record_info(fields, db_log_daily);
fields(db_log_monster_kill) -> record_info(fields, db_log_monster_kill);
fields(db_log_instance_activity) -> record_info(fields, db_log_instance_activity);
fields(db_log_instance_single) -> record_info(fields, db_log_instance_single);
fields(db_log_activity) -> record_info(fields, db_log_activity);
fields(db_log_insurance) -> record_info(fields, db_log_insurance);
fields(db_log_shop_once) -> record_info(fields, db_log_shop_once);
fields(db_player_mark) -> record_info(fields, db_player_mark);
fields(db_player_mystery_shop) -> record_info(fields, db_player_mystery_shop);
fields(db_player_operate_record) -> record_info(fields, db_player_operate_record);
fields(db_player_operate_active) -> record_info(fields, db_player_operate_active);
fields(db_player_monster_follow) -> record_info(fields, db_player_monster_follow);
fields(db_player_monster_drop) -> record_info(fields, db_player_monster_drop);
fields(db_player_monster_killer_last) -> record_info(fields, db_player_monster_killer_last);
fields(db_player_monster_state) -> record_info(fields, db_player_monster_state);
fields(db_player_active_service_record) -> record_info(fields, db_player_active_service_record);
fields(db_log_login_cross) -> record_info(fields, db_log_login_cross);
fields(db_legion) -> record_info(fields, db_legion);
fields(db_player_legion) -> record_info(fields, db_player_legion);
fields(db_player_batch_record) -> record_info(fields, db_player_batch_record);
fields(db_player_shop_once) -> record_info(fields, db_player_shop_once);
%% 合服活动相关
fields(db_player_active_service_merge) -> record_info(fields, db_player_active_service_merge);
fields(db_player_active_service_record_merge) -> record_info(fields, db_player_active_service_record_merge);
fields(db_player_monster_merge) -> record_info(fields, db_player_monster_merge);
fields(RecTye) ->
	?WARNING("recrod fields ~p ~n", [RecTye]),
	[].
%% ====================================================================
%% Internal functions
%% ====================================================================