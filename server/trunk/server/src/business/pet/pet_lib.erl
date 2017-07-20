%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		主要用于宠物数据更新和加载
%%% @end
%%% Created : 06. 一月 2016 下午5:04
%%%-------------------------------------------------------------------
-module(pet_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").

%% API
-export([
	load_pet/1,
	player_logout/1,
	add_pet/6,
	update_pet/6,
	delete_pet/2,
	delete_all_pet/1,
	change_att_type/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 从数据库加载
load_pet(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case pet_cache:select_row(PlayerId) of
		#db_pet{} = DbPet ->
			CurTime = util_date:unixtime(),
			case DbPet#db_pet.effective_time >= CurTime orelse DbPet#db_pet.effective_time == 0 of
				true ->
					Update = #db_pet{
						effective_time = 0
					},
					pet_cache:update(PlayerId, Update),
					PetList = DbPet#db_pet.pet_list,
					List = [{MonsterId, Exp, CurHp} || {_, MonsterId, Exp, CurHp} <- PetList],
					pet_cache:delete(PlayerId),
					PlayerState#player_state{recover_pet_list = List, pet_dict = dict:new(), pet_num = 0};
				_ ->
					pet_cache:delete(PlayerId),
					PlayerState#player_state{recover_pet_list = [], pet_dict = dict:new(), pet_num = 0}
			end;
		_ ->
			PlayerState#player_state{recover_pet_list = [], pet_dict = dict:new(), pet_num = 0}
	end.

player_logout(PlayerState) ->
	#player_state{
		player_id = PlayerId,
		pet_dict = PetDict,
		db_player_base = DbPlayerBase
	} = PlayerState,
	case PetDict == dict:new() of
		true ->
			skip;
		_ ->
			CurTime = util_date:unixtime(),
			TimeCount =
				case DbPlayerBase#db_player_base.vip > 0 of
					true ->
						?DAY_TIME_COUNT;
					_ ->
						(?DAY_TIME_COUNT / 2)
				end,
			Update = #db_pet{
				effective_time = CurTime + TimeCount
			},
			pet_cache:update(PlayerId, Update)
	end.

add_pet(PlayerState, ScenePid, PetUid, MonsterId, Exp, CurHp) ->
	#player_state{
		player_id = PlayerId,
		pet_dict = PetDict
	} = PlayerState,
	case PetDict == dict:new() of
		true ->
			DbPet = #db_pet{
				player_id = PlayerId,
				pet_list = [{PetUid, MonsterId, Exp, CurHp}],
				effective_time = 0
			},

			case pet_cache:select_row(PlayerId) of
				null->
					pet_cache:insert(DbPet);
				_->
					pet_cache:update(PlayerId,DbPet)
			end,

			PetInfo = #pet_info{
				uid = PetUid,
				scene_pid = ScenePid,
				monster_id = MonsterId,
				exp = Exp,
				cur_hp = CurHp
			},
			NewPetDict = dict:store(PetUid, PetInfo, PetDict),
			Num = dict:size(NewPetDict),
			Update = #player_state{pet_dict = NewPetDict, pet_num = Num},
			player_lib:update_player_state(PlayerState, Update);
		_ ->
			update_pet(PlayerState, ScenePid, PetUid, MonsterId, Exp, CurHp)
	end.

update_pet(PlayerState, ScenePid, PetUid, MonsterId, Exp, CurHp) ->
	#player_state{
		player_id = PlayerId,
		pet_dict = PetDict
	} = PlayerState,

	PetInfo = #pet_info{
		uid = PetUid,
		scene_pid = ScenePid,
		monster_id = MonsterId,
		exp = Exp,
		cur_hp = CurHp
	},
	NewPetDict = dict:store(PetUid, PetInfo, PetDict),

	F = fun(_, PetInfo1, Acc) ->
			#pet_info{
				uid = Uid1,
				monster_id = MonsterId1,
				exp = Exp1,
				cur_hp = CurHp1
			} = PetInfo1,
			[{Uid1, MonsterId1, Exp1, CurHp1} | Acc]
		end,
	PetList = dict:fold(F, [], NewPetDict),
	Update = #db_pet{
		player_id =PlayerId,
		pet_list = PetList
	},
	case pet_cache:update(PlayerId, Update) of
		{ok, _NewPet} ->
			Num = dict:size(NewPetDict),
			Update1 = #player_state{pet_dict = NewPetDict, pet_num = Num},
			player_lib:update_player_state(PlayerState, Update1);
		_ ->
			{ok, PlayerState}
	end.

delete_pet(PlayerState, PetUid) ->
	#player_state{
		player_id = PlayerId,
		pet_dict = PetDict
	} = PlayerState,
	%% 从表中移除 改宠物数据
	NewPetDict = dict:erase(PetUid, PetDict),
	F = fun(_, PetInfo1, Acc) ->
		#pet_info{
			uid = Uid1,
			monster_id = MonsterId1,
			exp = Exp1
		} = PetInfo1,
		[{Uid1, MonsterId1, Exp1} | Acc]
	end,
	%% 组合成一个新的宠物列表
	PetList = dict:fold(F, [], NewPetDict),
	case PetList /= [] of
		true ->
			%% 修改宠物信息
			Update = #db_pet{
				player_id = PlayerId,
				pet_list = PetList
			},
			case pet_cache:update(PlayerId, Update) of
				{ok, _NewPet} ->
					Num = dict:size(NewPetDict),
					Update1 = #player_state{pet_dict = NewPetDict, pet_num = Num},
					player_lib:update_player_state(PlayerState, Update1);
				_ ->
					{ok, PlayerState}
			end;
		_ ->
			pet_cache:delete(PlayerId),
			Update1 = #player_state{pet_dict = NewPetDict},
			player_lib:update_player_state(PlayerState, Update1)
	end.

delete_all_pet(PlayerState) ->

	PlayerId = PlayerState#player_state.player_id,
	pet_cache:delete(PlayerId),

	Update = #player_state{pet_dict = dict:new(), pet_num = 0},
	player_lib:update_player_state(PlayerState, Update).

change_att_type(PlayerState) ->
	#player_state{
		scene_id = SceneId,
		scene_pid = ScenePid,
		db_player_base = DbPlayerBase,
		pet_dict = PetDict
	} = PlayerState,

	#db_player_base{
		x = X,
		y = Y,
		pet_att_type = AttType
	} = DbPlayerBase,

	NewAttType =
		case AttType of
			?ATTACK_TYPE_INITIATIVE ->
				?ATTACK_TYPE_PASSIVITY;
			_ ->
				?ATTACK_TYPE_INITIATIVE
		end,

	F = fun(_, PetInfo) ->
		#pet_info{
			uid = PetId,
			scene_pid = PetScenePid
		} = PetInfo,
		obj_pet_lib:set_attack_type(PetScenePid, PetId, ScenePid, SceneId, {X, Y}, NewAttType)
	end,
	dict:map(F, PetDict),

	Update = #player_state{
		db_player_base = #db_player_base{
			pet_att_type = NewAttType
		}
	},
	player_lib:update_player_state(PlayerState, Update).

%% ====================================================================
%% Internal functions
%% ====================================================================
