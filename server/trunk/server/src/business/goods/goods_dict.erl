%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 18:12
%%%-------------------------------------------------------------------
-module(goods_dict).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").

%% API
%% @author tuhujia
%% @doc @todo Add description to goods_dict.
%% Description: 道具系统进程字典相关函数

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	init_dict/0,
	check_is_exist_goods/2,
	check_is_exist_store_goods/2,
	get_value_from_dict_by_id/2,
	get_value_from_store_dict_by_id/2,
	update_goods_num_to_dict/4,
	update_store_num_to_dict/4,
	delete_goods_num_to_dict/3,
	delete_store_goods_num_to_dict/3,
	init_bag_cell/0,
	set_bag_cell/1,
	set_store_bag_cell/1,
	get_bag_cell/0,
	get_store_bag_cell/0,
	add_bag_cell/0,
	add_store_bag_cell/0,
	delete_bag_cell/0,
	delete_store_bag_cell/0,
	add_blood_bag/0,
	get_blood_bag/0,
	init_blood_bag/0,
	save_player_goods_list/1,
	save_player_equips_list/1,
	save_player_store_list/1,
	get_player_goods_list/0,
	get_player_equips_list/0,
	get_player_store_list/0,
	update_player_goods_list_by_info/1,
	update_player_equips_list_by_info/1,
	update_player_store_list_by_info/1,
	delete_player_goods_list_by_info/1,
	delete_player_equips_list_by_info/1,
	delete_player_store_list_by_info/1,
	set_equips_baptize_attr/1,
	get_equips_baptize_attr/0,
	update_hp_recover/4,
	update_mp_recover/4,
	get_hp_recover/0,
	get_mp_recover/0,
	clear_hp_recover/0,
	clear_mp_recover/0,
	set_goods_cd_list/1,
	get_goods_cd_list/0
]).

%% 玩家道具列表缓存表
-define(PLAYER_GOODS_DICT, player_goods_dict).
%% 玩家仓库列表缓存表
-define(PLAYER_STORE_DICT, player_store_dict).
%% 玩家装背包占用数量
-define(PLAYER_BAG, player_bag).
%% 玩家仓库占用数量
-define(PLAYER_STORE_BAG, player_store_bag).
%% 玩家道具列表
-define(PLAYER_GOODS_LIST, player_goods_list).
%% 玩家装备列表
-define(PLAYER_EQUIPS_LIST, player_equips_list).
%% 玩家仓库列表
-define(PLAYER_STORE_LIST, player_store_list).
%% 洗练属性列表
-define(EQUIPS_BAPTIZE_ATTR, equips_baptize_attr).
%% 血包记录数据
-define(BLOOD_BAG, blood_bag).
%% HP缓慢回复记录数据
-define(HP_RECOVER, hp_recover).
%% MP缓慢回复记录数据
-define(MP_RECOVER, mp_recover).
%% 道具cd纪录列表
-define(GOODS_CD_LIST, goods_cd_list).

%% ====================================================================

%% 生成一个新的字典
init_dict() ->
	put(?PLAYER_GOODS_DICT, dict:new()),
	put(?PLAYER_STORE_DICT, dict:new()),
	put(?PLAYER_GOODS_LIST, []),
	put(?PLAYER_EQUIPS_LIST, []),
	put(?PLAYER_STORE_LIST, []),
	put(?EQUIPS_BAPTIZE_ATTR, []),
	put(?PLAYER_STORE_BAG, 0),
	put(?BLOOD_BAG, 0),
	put(?GOODS_CD_LIST, []).

%% 保存字典数据
save_player_goods_dict(Dict) ->
	put(?PLAYER_GOODS_DICT, Dict).

%% 获取字典数据
get_player_goods_dict() ->
	get(?PLAYER_GOODS_DICT).

%% 添加道具数据至字典
update_goods_num_to_dict(GoodsId, Id, IsBind, Num) ->
	case check_is_exist_goods(GoodsId, IsBind) of
		true ->
			OldList = get_value_from_dict_by_id(GoodsId, IsBind),
			NewList = lists:keystore(Id, 1, OldList, {Id, Num}),
			%% 由低至高排序
			Dict = update_goods_dict(GoodsId, IsBind, lists:keysort(2, NewList)),
			save_player_goods_dict(Dict);
		false ->
			Dict = update_goods_dict(GoodsId, IsBind, [{Id, Num}]),
			save_player_goods_dict(Dict)
	end.

%% 删除道具至字典
delete_goods_num_to_dict(GoodsId, Id, IsBind) ->
	OldList = get_value_from_dict_by_id(GoodsId, IsBind),
	NewList = lists:keydelete(Id, 1, OldList),
	Dict = update_goods_dict(GoodsId, IsBind, NewList),
	save_player_goods_dict(Dict).

%% 判断字典里面是否存在该道具 | 返回true/false
check_is_exist_goods(GoodsId, IsBind) ->
	dict:is_key({GoodsId, IsBind}, get_player_goods_dict()).

%% 更新字典里面的数据
update_goods_dict(GoodsId, IsBind, List) ->
	case List of
		[] ->
			delete_goods_id_from_dict(GoodsId, IsBind);
		_ ->
			dict:store({GoodsId, IsBind}, List, get_player_goods_dict())
	end.

%% 根据道具ID获取字典里面的数据
get_value_from_dict_by_id(GoodsId, IsBind) ->
	case check_is_exist_goods(GoodsId, IsBind) of
		true ->
			dict:fetch({GoodsId, IsBind}, get_player_goods_dict());
		false ->
			[]
	end.

%% ====================================================================

%% 保存仓库字典数据
save_player_store_dict(Dict) ->
	put(?PLAYER_STORE_DICT, Dict).

get_player_store_dict() ->
	get(?PLAYER_STORE_DICT).

%% 添加仓库道具数据至字典
update_store_num_to_dict(GoodsId, Id, IsBind, Num) ->
	case check_is_exist_store_goods(GoodsId, IsBind) of
		true ->
			OldList = get_value_from_store_dict_by_id(GoodsId, IsBind),
			NewList = lists:keystore(Id, 1, OldList, {Id, Num}),
			%% 由低至高排序
			Dict = update_store_dict(GoodsId, IsBind, lists:keysort(2, NewList)),
			save_player_store_dict(Dict);
		false ->
			Dict = update_store_dict(GoodsId, IsBind, [{Id, Num}]),
			save_player_store_dict(Dict)
	end.

%% 删除仓库道具至字典
delete_store_goods_num_to_dict(GoodsId, Id, IsBind) ->
	OldList = get_value_from_store_dict_by_id(GoodsId, IsBind),
	NewList = lists:keydelete(Id, 1, OldList),
	Dict = update_store_dict(GoodsId, IsBind, NewList),
	save_player_store_dict(Dict).

%% 判断仓库字典里面是否存在该道具 | 返回true/false
check_is_exist_store_goods(GoodsId, IsBind) ->
	dict:is_key({GoodsId, IsBind}, get_player_store_dict()).

%% 更新仓库字典里面的数据
update_store_dict(GoodsId, IsBind, List) ->
	case List of
		[] ->
			delete_store_goods_id_from_dict(GoodsId, IsBind);
		_ ->
			dict:store({GoodsId, IsBind}, List, get_player_store_dict())
	end.

%% 根据道具ID获取字典里面的数据
get_value_from_store_dict_by_id(GoodsId, IsBind) ->
	case check_is_exist_store_goods(GoodsId, IsBind) of
		true ->
			dict:fetch({GoodsId, IsBind}, get_player_store_dict());
		false ->
			[]
	end.

%% ====================================================================

%% 删除字典里面的key
delete_goods_id_from_dict(GoodsId, IsBind) ->
	dict:erase({GoodsId, IsBind}, get_player_goods_dict()).

%% 删除仓库字典里面的key
delete_store_goods_id_from_dict(GoodsId, IsBind) ->
	dict:erase({GoodsId, IsBind}, get_player_store_dict()).

%% 初始化背包格子占用
init_bag_cell() ->
	put(?PLAYER_BAG, 0).

%% 设定背包格子占用量
set_bag_cell(Num) ->
	put(?PLAYER_BAG, max(0, Num)).

set_store_bag_cell(Num) ->
	put(?PLAYER_STORE_BAG, max(0, Num)).

%% 获取背包格子占用量
get_bag_cell() ->
	get(?PLAYER_BAG).

get_store_bag_cell() ->
	get(?PLAYER_STORE_BAG).

%% 增加背包占用量
add_bag_cell() ->
	Num = get(?PLAYER_BAG),
	put(?PLAYER_BAG, Num + 1).

add_store_bag_cell() ->
	Num = get(?PLAYER_STORE_BAG),
	put(?PLAYER_STORE_BAG, Num + 1).

%% 减少背包占用量
delete_bag_cell() ->
	Num = get(?PLAYER_BAG),
	put(?PLAYER_BAG, max(0, Num - 1)).

delete_store_bag_cell() ->
	Num = get(?PLAYER_STORE_BAG),
	put(?PLAYER_STORE_BAG, max(0, Num - 1)).

%% set洗练属性
set_equips_baptize_attr(Value) ->
	put(?EQUIPS_BAPTIZE_ATTR, Value).

%% get洗练属性
get_equips_baptize_attr() ->
	get(?EQUIPS_BAPTIZE_ATTR).

%% 设置血包参数
add_blood_bag() ->
	Val = get(?BLOOD_BAG),
	put(?BLOOD_BAG, Val + 1).

%% 获取血包参数
get_blood_bag() ->
	get(?BLOOD_BAG).

%% 初始血包参数
init_blood_bag() ->
	put(?BLOOD_BAG, 0).

%% 获取hp回复参数
update_hp_recover(RecTime, Val, NowTime, FinishTime) ->
	put(?HP_RECOVER, {RecTime, Val, NowTime, FinishTime}).

%% 获取mp回复参数
update_mp_recover(RecTime, Val, NowTime, FinishTime) ->
	put(?MP_RECOVER, {RecTime, Val, NowTime, FinishTime}).

%% 获取hp回复参数
get_hp_recover() ->
	get(?HP_RECOVER).

%% 获取mp回复参数
get_mp_recover() ->
	get(?MP_RECOVER).

%% 清除hp回复参数
clear_hp_recover() ->
	erase(?HP_RECOVER).

%% 清除mp回复参数
clear_mp_recover() ->
	erase(?MP_RECOVER).

%% 更新cd列表
set_goods_cd_list(Value) ->
	put(?GOODS_CD_LIST, Value).

%% 获取cd列表
get_goods_cd_list() ->
	get(?GOODS_CD_LIST).

%% ====================================================================

%% 保存玩家道具列表
save_player_goods_list(GoodsList) ->
	put(?PLAYER_GOODS_LIST, GoodsList).

%% 保存玩家装备列表
save_player_equips_list(EquipsList) ->
	put(?PLAYER_EQUIPS_LIST, EquipsList).

%% 保存玩家仓库列表
save_player_store_list(GoodsList) ->
	put(?PLAYER_STORE_LIST, GoodsList).

%% 获取玩家道具列表
get_player_goods_list() ->
	get(?PLAYER_GOODS_LIST).

%% 保存玩家装备列表
get_player_equips_list() ->
	get(?PLAYER_EQUIPS_LIST).

%% 保存玩家仓库列表
get_player_store_list() ->
	get(?PLAYER_STORE_LIST).

%% 更新玩家道具列表
update_player_goods_list_by_info(Info) ->
	GoodsList = get_player_goods_list(),
	Id = Info#db_goods.id,
	GoodsList1 = lists:keystore(Id, #db_goods.id, GoodsList, Info),
	save_player_goods_list(GoodsList1).

%% 更新玩家装备列表
update_player_equips_list_by_info(Info) ->
	EquipsList = get_player_equips_list(),
	Id = Info#db_goods.id,
	EquipsList1 = lists:keystore(Id, #db_goods.id, EquipsList, Info),
	save_player_equips_list(EquipsList1).

%% 更新玩家仓库列表
update_player_store_list_by_info(Info) ->
	GoodsList = get_player_store_list(),
	Id = Info#db_goods.id,
	GoodsList1 = lists:keystore(Id, #db_goods.id, GoodsList, Info),
	save_player_store_list(GoodsList1).

%% 删除玩家道具列表
delete_player_goods_list_by_info(Info) ->
	GoodsList = get_player_goods_list(),
	Id = Info#db_goods.id,
	GoodsList1 = lists:keydelete(Id, #db_goods.id, GoodsList),
	save_player_goods_list(GoodsList1).

%% 删除玩家装备列表
delete_player_equips_list_by_info(Info) ->
	EquipsList = get_player_equips_list(),
	Id = Info#db_goods.id,
	EquipsList1 = lists:keydelete(Id, #db_goods.id, EquipsList),
	save_player_equips_list(EquipsList1).

%% 删除玩家仓库列表
delete_player_store_list_by_info(Info) ->
	GoodsList = get_player_store_list(),
	Id = Info#db_goods.id,
	GoodsList1 = lists:keydelete(Id, #db_goods.id, GoodsList),
	save_player_store_list(GoodsList1).

