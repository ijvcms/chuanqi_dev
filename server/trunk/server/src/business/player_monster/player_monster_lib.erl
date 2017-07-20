%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	玩家跟怪物相关的功能
%%% @end
%%% Created : 04. 八月 2016 下午5:20
%%%-------------------------------------------------------------------
-module(player_monster_lib).
-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("uid.hrl").

%% API
-export([
	save_monster_boss_drop/5,
	save_monster_boss_drop_local/5,
	monster_boss_drop/1,
	city_boss_killer_last/2,
	city_boss_killers/1
]).

%%保存指定的boss掉落物品
save_monster_boss_drop(SceneState, ObjState, KillerState, GoodsList, OwnerId) ->
	dp_lib:cast({?MODULE, save_monster_boss_drop_local, [SceneState, ObjState, KillerState, GoodsList, OwnerId]}).
save_monster_boss_drop_local(SceneState, ObjState, KillerState, GoodsList, OwnerId) ->
	#scene_obj_state{
		obj_id = _ObjId,
		obj_type = ObjType,
		monster_id = MonsterId,
		name = _Name
	} = ObjState,
	case ObjType of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(MonsterId),
			case MonsterConf#monster_conf.type of
				?MONSTER_TYPE_BOSS ->
					{PlayerId1, PlayerName1} = case KillerState of
												   #scene_obj_state{} ->
													   {KillerState#scene_obj_state.obj_id, KillerState#scene_obj_state.name};
												   _ ->
%% 													 ?ERR("KILL ~p", [KillerState]),
													   NewData = #scene_obj_state{},
													   {NewData#scene_obj_state.obj_id, NewData#scene_obj_state.name}
											   end,
					{PlayerId, PlayerName} =
						case OwnerId =:= PlayerId1 orelse OwnerId =:= 0 of
							true -> {PlayerId1, PlayerName1};
							false ->
								#db_player_base{name = PlayerName2} = player_base_cache:select_row(OwnerId),
								{OwnerId, PlayerName2}
						end,
					SceneId = SceneState#scene_state.scene_id,
					MonsterId,
					Time = util_date:unixtime(),
					SaveGoods =
						lists:foldl(fun(Goods, Acc) ->
							{GoodsId, _IsBind, _Num} =
								if
									is_record(Goods, db_goods) ->
										#db_goods{
											goods_id = GoodsId1,
											is_bind = IsBind1,
											num = Num1
										} = Goods,
										{GoodsId1, IsBind1, Num1};
									true ->
										Goods
								end,

							#goods_conf{is_dorplist = IsDropList} = goods_lib:get_goods_conf_by_id(GoodsId),
							case IsDropList =/= 0 of
								true ->
									[GoodsId | Acc];
								false ->
									Acc
							end

						end, [], GoodsList),
					%%{PlayerName, SceneId, SaveGoods, Time},
					case SaveGoods of
						[_ | _] ->
							SaveGoodsStr = util_data:term_to_string(SaveGoods),
							Data = #db_player_monster_drop{id = uid_lib:get_uid(?UID_TYPE_PLAYER_MONSTER_DROP), player_id = PlayerId, player_name = PlayerName, scene_id = SceneId,
								monster_id = MonsterId, monster_goods = SaveGoodsStr, add_time = Time},
							player_monster_drop_db:insert(Data),
							ok;
						_ ->
							%%?WARNING("drop filter ~p",[GoodsList]),
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	ok.

%%boss的掉落列表
monster_boss_drop(PlayerState) ->
	List = player_monster_drop_db:select_new(),
	DropList =
		[#proto_monster_boss_drop{planer_name = PlayerName, scene_id = SceneId, monster_id = MonsterId, monster_goods = util_data:string_to_term(MonsterGoods), kill_time = AddTime}
			|| #db_player_monster_drop{player_name = PlayerName, scene_id = SceneId, monster_id = MonsterId, monster_goods = MonsterGoods, add_time = AddTime} <- List],
	Rep = #rep_monster_boss_drop{drop_list = DropList},
	net_send:send_to_client(PlayerState#player_state.player_id, 11046, Rep),
	ok.

%%击杀游荡boss的最后一个玩家
city_boss_killer_last(ObjState, KillState) ->
	#scene_obj_state{
		obj_type = ObjType,
		monster_id = MonsterId
	} = ObjState,
	case ObjType of
		?OBJ_TYPE_MONSTER ->
			case random_monster_config:get(MonsterId) of
				#random_monster_conf{boss_flag = 1} ->
					Name = KillState#scene_obj_state.name,
					Rec = #db_player_monster_killer_last{monster_id = MonsterId, player_name = Name, update_time = util_date:unixtime()},
					player_monster_killer_last_db:replace(Rec),
					ok;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%%所有击杀游荡boss的最后一个玩家
city_boss_killers(PlayerState) ->
	List1 = player_monster_killer_last_db:select_all(),
	Killers =
		[#proto_city_boss_killer{monster_id = MonsterId, player_name = PlayerName}
			|| #db_player_monster_killer_last{monster_id = MonsterId, player_name = PlayerName} <- List1],
	Rep = #rep_city_boss_last_killers{killer_list = Killers},
	net_send:send_to_client(PlayerState#player_state.player_id, 11050, Rep),
	{ok, PlayerState}.