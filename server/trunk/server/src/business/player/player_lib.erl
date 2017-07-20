%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 下午4:06
%%%-------------------------------------------------------------------
-module(player_lib).
%%
-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").
-include("notice_config.hrl").

%% 帧循环1秒, 单位毫秒
-define(TIMER_FRAME, 1000).
%% 心跳超时30秒, 单位秒
-define(HEART_OVERTIME, 60).

%% API
-export([
	get_player_list_data/3,
	get_player_detail_data/1,
	get_player_extra_data/1,
	get_player_pid/1,
	get_socket/1,
	get_online_players/0,
	get_attack_interval/1,
	get_player_detailed_info/2,
	create/1,
	enter/7,
	logout/1,
	is_online/1,
	pickup_drop/5,
	collection/2,
	add_exp/3,
	add_money_to_logout_player/4,
	update_player_state/2,
	update_player_state_back/2,
	update_player_state_async/2,
	update_player_state_sync/2,
	update_player_state/3,
	update_player_state/4,
	update_player_state/5,
	update_refresh_player/2,
	revive/2,
	get_key_map/1,
	send_update/3,
	can_action/1,
	can_use_skill/1,
	chang_pk_mode/2,
	get_name_colour/2,
	is_outlaw/1,
	is_online_int/1,
	update_player_career_title/1,
	kill_monster/3,
	kill_monster_by_team/4,
	make_proto_guise/1,
	make_proto_mark/1,
	incval_on_player_money_log/4,
	incval_on_player_money_log/5,
	back_city/1,
	kick_player/2,
	get_scene_xy/1
]).

%% callbacks
-export([
	do_pickup_drop/5,
	do_collection/2,
	do_kill_monster/3,
	do_kill_monster_by_team/4
]).

%% Mod API
-export([
	init_player_state/4,
	init_player_state2/1,
	update_double_exp/1,
	on_timer/1,
	get_hook_state/0,
	put_hook_state/1,
	login/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
get_player_list_data(OpenId, Platform, ClientServerId) ->
	ServerId = get_true_server_id(ClientServerId),
	case account_db:select_all({OpenId, Platform}, ServerId) of
		[] ->
			[];
		List ->
			F = fun(Info, Acc) ->
				case make_proto_login_info(Info#db_account.player_id) of
					#proto_login_info{} = ProtoInfo ->
						[ProtoInfo | Acc];
					_ ->
						Acc
				end
			end,
			lists:foldl(F, [], List)
	end.

%%快速登录用
get_player_list_data(OpenId, Platform) ->
	account_db:select_all({OpenId, Platform}).
%% 	case account_db:select_all({OpenId, Platform}) of
%% 		[] ->
%% 			[];
%% 		List -> List
%% 			F = fun(Info, Acc) ->
%% 				case make_proto_login_info(Info#db_account.player_id) of
%% 					#proto_login_info{} = ProtoInfo ->
%% 						[ProtoInfo | Acc];
%% 					_ ->
%% 						Acc
%% 				end
%% 			end,
%% 			lists:foldl(F, [], List)
%% 	end.

%% 获取玩家详细信息
get_player_detail_data(PlayerState) ->
	make_proto_player_info(PlayerState).

%% 获取玩家扩展详细信息
get_player_extra_data(PlayerState) ->
	{NewPlayerState, InstanceLeftTime} = player_instance_lib:get_single_boss_left_time(PlayerState),
	Rep = #rep_player_extra_info{
		result = 0,
		instance_left_time = InstanceLeftTime
	},
	?INFO("get_player_extra_data ~p", [Rep]),
	net_send:send_to_client(PlayerState#player_state.socket, 10016, Rep),
	{ok, NewPlayerState}.

%% 获取玩家pid
get_player_pid(PlayerId) ->
	case ets:lookup(?ETS_ONLINE, PlayerId) of
		[EtsOnline] ->
			case misc:is_process_alive(EtsOnline#ets_online.pid) of
				true ->
					EtsOnline#ets_online.pid;
				_ ->
					ets:delete(?ETS_ONLINE, PlayerId),
					null
			end;
		_ ->
			null
	end.

%% 获取玩家socket
get_socket(PlayerId) ->
	case ets:lookup(?ETS_ONLINE, PlayerId) of
		[EtsOnline] ->
			EtsOnline#ets_online.socket;
		_ ->
			null
	end.

get_online_players() ->
	ets:tab2list(?ETS_ONLINE).

%% 创建新角色
create(ReqData) ->
	#req_create{
		open_id = OpenId,
		platform = Platform,
		name = Name,
		sex = Sex,
		career = Career,
		server_id = ClientServerId
	} = ReqData,
	ServerId = get_true_server_id(ClientServerId),
	%% 判断玩家名称是否重复
	case sensitive_word_lib:check(Name) orelse util_string:check_name(Name) of
		true ->
			%% 角色名字有敏感词
			{fail, ?ERR_PLAYER_NAME_ILLEGAL};
		_ ->
			List = account_db:select_all({OpenId, Platform}, ServerId),
			case length(List) < ?MAX_CREATE_COUNT of
				true ->
					case player_id_name_lib:is_no_name(Name) andalso not player_base_db:check_name(Name) of
						true ->
							{ok, PlayerId} = create(OpenId, Platform, Name, Sex, Career, ServerId),
							%% 存储玩家的名称映射
							player_id_name_lib:save_ets_player(PlayerId, Career, Name),
							{ok, make_proto_login_info(PlayerId)};
						_ ->
							%% 角色名称重复了
							{fail, ?ERR_PLAYER_REPEAT}
					end;
				_ ->
					%% 已经创满了，不能再创建角色
					{fail, ?ERR_PLAYER_MAX}
			end
	end.


create(OpenId, Platform, Name, Sex, Career, ServerId) ->
	PlayerId = uid_lib:get_uid(?UID_TYPE_PLAYER),
	CurTime = util_date:unixtime(),
	TomorrowTime = util_date:get_tomorrow_unixtime(),
	CellConf = cell_config:get(1),
	%% 是否是机器人
	IsRobot = case lists:member(OpenId, robot_account_config:get_list()) of
				  true ->
					  1;
				  _ ->
					  0
			  end,
	%% 添加玩家基础信息
	PlayerBase = #db_player_base{
		player_id = PlayerId,
		name = check({name, Name}),
		lv = 1,
		exp = 0,
		sex = check({sex, Sex}),
		career = check({career, Career}),
		register_time = CurTime,
		last_login_time = CurTime,
		scene_id = ?GAMECONFIG_FIRST_SCENE,
		hook_scene_id = ?INIT_HOOK_SCENE_ID,
		pass_hook_scene_id = 0,
		last_hook_time = CurTime,
		draw_hook_time = CurTime,
		challenge_num = ?INIT_CHALLENGE_NUM,
		buy_challenge_num = 0,
		reset_challenge_time = TomorrowTime,
		power = ?MAX_POWER,
		power_recover_time = 0,
		buy_power_num = 0,
		reset_buy_power_time = TomorrowTime,
		bag = CellConf#cell_conf.cell,
		forge = 0,
		set_pk_mode = ?PK_MODE_NOOB,
		pk_mode = ?PK_MODE_NOOB,
		pk_value = 0,
		guild_id = 0,
		vip = 0,
		vip_exp = 0,
		blood_bag = 0,
		ref_task_time = 0,
		task_reward_active = [],
		hp_set = ?GAMECONFIG_PROTO_HP_SET,
		hpmp_set = ?GAMECONFIG_PROTO_HPMP_SET,
		guise = ?GAMECONFIG_GUISE_STATE,
		fh_cd = 0,
		equip_sell_set = ?GAMECONFIG_EQUIP_SELL_SET,
		pickup_set = ?GAMECONFIG_PiCKUP_SET,
		skill_set = 0,
		wing_state = 0,%%
		weapon_state = 0,
		pet_att_type = ?ATTACK_TYPE_INITIATIVE,
		limit_chat = 0,
		limit_login = 0,
		guild_task_time = 0,
		guild_task_id = 0,
		lottery_num = 0,
		is_robot = IsRobot
	},
	player_base_cache:insert(PlayerBase),

	%% 添加玩家货币信息
	PlayerMoney = #db_player_money{
		player_id = PlayerId,
		coin = 0,
		jade = 0,
		gift = 0,
		smelt_value = 0,
		feats = 0,
		hp_mark_value = 0,
		atk_mark_value = 0,
		def_mark_value = 0,
		res_mark_value = 0
	},
	player_money_cache:insert(PlayerMoney),

	%% 添加玩家标记信息
	PlayerMark = #db_player_mark{
		player_id = PlayerId,
		hp_mark = 0,
		atk_mark = 0,
		def_mark = 0,
		res_mark = 0,
		holy_mark = 0,
		mounts_mark_1 = 0,
		mounts_mark_2 = 0,
		mounts_mark_3 = 0,
		mounts_mark_4 = 0,
		update_time = CurTime
	},
	player_mark_cache:insert(PlayerMark),

	%% 添加账号信息
	Account = #db_account{
		open_id = OpenId,
		player_id = PlayerId,
		platform = Platform,
		server_id = ServerId
	},
	account_db:insert(Account),

	player_id_name_lib:add_server_user(PlayerId, OpenId, Name, CurTime, 0),

	{ok, PlayerId}.

%% 进入游戏
enter(PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot) ->
	#db_player_base{player_id = PlayerId} = PlayerBase,
	case get_player_pid(PlayerId) of
		null ->
			enter1(PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot);
		Pid ->
			try
				case util_data:check_pid(Pid) of
					true ->
						reenter(PlayerId, Pid, Socket, SocketPid, OsType),
						{ok, Pid};
					_ ->
						enter1(PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot)
				end
			catch
				_Class:_Err ->
%% 					?ERR("~p ~p ~p", [_Class, _Err, erlang:get_stacktrace()]),
					timer:sleep(1000),
					enter(PlayerBase,  Socket, SocketPid, OsType, OpenId, Platform, IsRobot)
			end
	end.
%% 玩家进入游戏
enter1(PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot) ->
	#db_player_base{player_id = PlayerId} = PlayerBase,
	case player_mod:start([PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot]) of
		{ok, Pid} ->
			ets:insert(?ETS_ONLINE, #ets_online{player_id = PlayerId, socket = Socket, pid = Pid, is_robot = IsRobot}),
			{ok, Pid};
		Err ->
			?ERR("start player err: ~p ~n~p", [Err, erlang:get_stacktrace()]),
			{fail, ?ERR_COMMON_FAIL}
	end.



%%重新进入游戏 socket信息处理
reenter(PlayerId, PlayerPid, Socket, SocketPid, OsType) ->
	gen_server2:call(PlayerPid, {reenter, Socket, SocketPid, OsType}),
	ets:insert(?ETS_ONLINE, #ets_online{player_id = PlayerId, socket = Socket, pid = PlayerPid, is_robot = 0}).

%% 退出角色
logout(PlayerId) when is_integer(PlayerId) ->
	PlayerPid = get_player_pid(PlayerId),
	gen_server2:apply_async(PlayerPid, {?MODULE, logout, []});
%% 退出角色逻辑处理
logout(PlayerState) when is_record(PlayerState, player_state) ->
	robot_cross:exe_robot(login_out, [PlayerState#player_state.open_id]),
	scene_mgr_lib:leave_scene(PlayerState, ?LEAVE_SCENE_TYPE_LOGOUT),
	%% 玩家下线删除场景中的宠物
	PetDict = PlayerState#player_state.pet_dict,
	case PetDict /= dict:new() of
		true ->
			F = fun(_, PetInfo) ->
				case is_record(PetInfo, pet_info) of
					true ->
						#pet_info{
							scene_pid = PetScenePid,
							uid = Uid
						} = PetInfo,
						case is_pid(PetScenePid) of
							true ->
								scene_obj_lib:remove_obj(PetScenePid, ?OBJ_TYPE_PET, Uid, ?LEAVE_SCENE_TYPE_INITIATIVE);
							_ ->
								skip
						end;
					_ ->
						?ERR("remov_user ~p", [PetDict])
				end
			end,
			dict:map(F, PetDict);
		_ ->
			skip
	end,
	%%HookState = get_hook_state(),
	%%hook_lib:update_last_hook_time(PlayerState, HookState),

	Base = PlayerState#player_state.db_player_base,
	LeftTime = case scene_lib:get_single_boss_time(PlayerState) of
				   {ok, UseTime} ->
					   erlang:max(Base#db_player_base.instance_left_time - UseTime, 0);
				   _ ->
					   Base#db_player_base.instance_left_time
			   end,
	%%?ERR("~p", [LeftTime]),
	%% 下线更新行会
	guild_lib:on_player_logout(PlayerState),
	%% 交易检测
	transaction_lib:clearn_player_trade(PlayerState#player_state.player_id),
	%% 队伍检测
	team_lib:player_logout(PlayerState),
	%% 保存宠物信息
	pet_lib:player_logout(PlayerState),
	%% 修改玩家的战力信息 玩家最后退出时间
	Update = #player_state
	{
		db_player_base = #db_player_base
		{
			fight = PlayerState#player_state.fighting,
			guise = PlayerState#player_state.guise,
			last_logout_time = util_date:unixtime(),
			instance_left_time = LeftTime
		}
	},
	{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update),

%%     ?ERR("logout ~p", [PlayerState#player_state.player_id]),
	%% 纪录玩家在线时长
	welfare_active_lib:update_player_online_times(NewPlayerState),
	ets:delete(?ETS_ONLINE, NewPlayerState#player_state.player_id),
	{stop, normal, NewPlayerState};

logout(_) ->
	skip.

%% 踢玩家下线
kick_player(PlayerState, Err) ->
	net_send:send_to_client(PlayerState#player_state.socket, 9997, #rep_login_out{result = Err}),
	gen_server2:cast(PlayerState#player_state.socket_pid, {kick_out, 1}).

%% 判断玩家是否在线
is_online(PlayerId) ->
	case ets:lookup(?ETS_ONLINE, PlayerId) of
		[EtsOnline] ->
			is_process_alive(EtsOnline#ets_online.pid);
		_ ->
			false
	end.
%% 判断玩家是否在线
is_online_int(PlayerId) ->
	case ets:lookup(?ETS_ONLINE, PlayerId) of
		[EtsOnline] ->
			case is_process_alive(EtsOnline#ets_online.pid) of
				true ->
					1;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 选择角色
get_attack_interval(Career) ->
	case Career of
		?CAREER_ZHANSHI -> ?MIN_INTERVAL_ZHANSHI;
		?CAREER_FASHI -> ?MIN_INTERVAL_FASHI;
		?CAREER_DAOSHI -> ?MIN_INTERVAL_DAOSHI
	end.


%% #base_money数据添加
incval_on_player_money_log(PS, Key, Val, Type) ->
	?INFO("111 ~p ~p", [Val, Type]),
	incval_on_player_money_log(PS, Key, Val, true, Type).
%% money所有类型 数据修改
incval_on_player_money_log(PS, Key, Val, IsSendUpdate, Type) ->
	%% 活动消耗统计检测
	case Key =:= #db_player_money.jade andalso Val < 0 of
		true ->
			case Type == ?LOG_TYPE_TRADE orelse
				Type == ?LOG_TYPE_SALE_ADD orelse
				Type == ?LOG_TYPE_SALE_BUY orelse
				Type == ?LOG_TYPE_RED_TYPE_GUILD orelse
				Type =:= ?LOG_TYPE_EQUIPS_SECURE
			of
				true ->
					skip;
				false ->
					operate_active_lib:update_limit_type(PS, ?OPERATE_ACTIVE_LIMIT_TYPE_5, -Val),
					active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_JADE_SELL, PS, -Val),
					case Type == ?LOG_TYPE_BUY_MYSTERY_SHOP of
						true ->
							?ERR("~p", [-Val]),
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_MYSTERY_SHOP_SELL_1, PS, -Val),
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_MYSTERY_SHOP_SELL, PS, -Val);
						_ ->
							skip
					end
			end;
		false ->
			ok
	end,
	case Val /= 0 of
		true ->
			PM = PS#player_state.db_player_money,
			Val0 =
				case Key =:= #db_player_money.coin of
					true -> pack_int32(Val + element(Key, PM));
					false -> Val + element(Key, PM)
				end,
			Val1 = max(0, Val0),
			NPM = setelement(Key, PM, Val1),
			?INFO("222 ~p ~p", [Val, Type]),
			log_lib:log_money_inster(PS#player_state.player_id, Key, Val, Val1, Type),
			update_player_state(PS, #player_state{db_player_money = NPM}, IsSendUpdate);
		_ ->
			{ok, PS}
	end.

pack_int32(Value) ->
	MaxValue = 2000000000,
	case Value >= MaxValue of
		true -> MaxValue;
		false -> Value
	end.


%% 玩家离线添加金币类数值
add_money_to_logout_player(PlayerId, Key, Val, Type) ->
	case player_money_cache:select_row(PlayerId) of
		#db_player_money{} = PM ->
			Val1 = max(0, Val + element(Key, PM)),
			NPM = setelement(Key, PM, Val1),
			player_money_cache:update(PlayerId, NPM),
			log_lib:log_money_inster(PlayerId, Key, Val, Val1, Type),
			ok;
		_ ->
			skip
	end.

pickup_drop(PlayerPid, GoodsId, Num, IsBind, GoodsInfo) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, do_pickup_drop, [GoodsId, Num, IsBind, GoodsInfo]}).
%% 道具 money添加 道具添加 掉落添加
do_pickup_drop(PlayerState, GoodsId, Num, IsBind, GoodsInfo) ->
	case GoodsId =:= ?GOODS_ID_COIN of
		true ->
			{ok, NewState} = incval_on_player_money_log(PlayerState, #db_player_money.coin, Num, ?LOG_TYPE_PICKUP_DROP),
			net_send:send_to_client(NewState#player_state.socket, 11006, #rep_pickup{}),
			{ok, NewState};
		_ ->
			case util_data:is_null(GoodsInfo) of
				true ->
					case goods_lib_log:add_goods(PlayerState, GoodsId, IsBind, Num, ?LOG_TYPE_PICKUP_DROP) of
						{ok, NewState} ->
							net_send:send_to_client(NewState#player_state.socket, 11006, #rep_pickup{}),
							{ok, NewState};
						{fail, _Err} ->
							?INFO("error: ~p", [_Err]),
							net_send:send_to_client(PlayerState#player_state.socket, 11006, #rep_pickup{result = 1}),
							{ok, PlayerState}
					end;
				_ ->
					case goods_lib_log:add_goods_by_goods_info(PlayerState, GoodsInfo, ?LOG_TYPE_PICKUP_DROP) of
						{ok, NewState} ->
							net_send:send_to_client(NewState#player_state.socket, 11006, #rep_pickup{}),
							{ok, NewState};
						{fail, _Err} ->
							?INFO("error: ~p", [_Err]),
							net_send:send_to_client(PlayerState#player_state.socket, 11006, #rep_pickup{result = 1}),
							{ok, PlayerState}
					end
			end
	end.

%% 采集
collection(PlayerPid, CollectionGoodsList) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, do_collection, [CollectionGoodsList]}).
do_collection(PlayerState, CollectionGoodsList) ->
	case goods_lib_log:add_goods_list(PlayerState, CollectionGoodsList, ?LOG_TYPE_SCENE_COLLECT) of
		{ok, PlayerState1} ->
			{ok, PlayerState1};
		_ ->
			{ok, PlayerState}
	end.

%% 根据pid更新玩家的职业 称号
update_player_career_title(PlayerPid) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, update_player_career_title, []});
%% 根据pid更新玩家的职业 称号
update_player_career_title(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	Update = PlayerState#player_state
	{
		career_title = careertitle_lib:get_career_title_player_id(PlayerState#player_state.player_id, Base#db_player_base.career)
	},
	update_player_state(PlayerState, Update).

%% PI修改状态信息
update_player_state_back(PlayerPid, Update) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, update_player_state_back, [Update]});
update_player_state_back(PlayerState, Update) ->
	Base = Update#player_state.db_player_base,
	%% 如果是封号信息，那么处理踢出玩家的帐号信息
	case util_data:is_null(Base#db_player_base.limit_login) /= true andalso Base#db_player_base.limit_login > util_date:unixtime() of
		true ->
			kick_player(PlayerState, ?ERR_PLAYER_TITLE);
		_ ->
			skip
	end,
	update_player_state(PlayerState, Update).

%% PI修改状态信息
update_player_state_async(PlayerPid, Update) when is_pid(PlayerPid) ->
%% 	?WARNING("update_player_state_async ~p", [PlayerPid]),
	gen_server2:apply_async(PlayerPid, {?MODULE, update_player_state, [Update]}).

update_player_state_sync(PlayerPid, Update) when is_pid(PlayerPid) ->
%% 	?WARNING("update_player_state_sync ~p", [PlayerPid]),
	gen_server2:apply_sync(PlayerPid, {?MODULE, update_player_state, [Update]}).

%% 根据状态更新玩家的信息
update_player_state(PlayerState, Update) ->
	update_player_state(PlayerState, Update, true, false, ?UPDATE_CAUSE_OTHER).
%% 刷新属性
update_refresh_player(PlayerState, Update) ->
	update_player_state(PlayerState, Update, true, true, ?UPDATE_CAUSE_OTHER).

update_player_state(PlayerState, Update, IsSendUpdate) ->
	update_player_state(PlayerState, Update, IsSendUpdate, false, ?UPDATE_CAUSE_OTHER).
%%  IsSendUpdate 是否发送更新信息 IsRefreshAttr 是否更新战斗力
update_player_state(PlayerState, Update, IsSendUpdate, IsRefreshAttr) ->
	update_player_state(PlayerState, Update, IsSendUpdate, IsRefreshAttr, ?UPDATE_CAUSE_OTHER).

update_player_state(PlayerState, Update, IsSendUpdate, IsRefreshAttr, Cause) ->
	PlayerId = PlayerState#player_state.player_id,
	NewDbPlayerBase = update_db_player_base(PlayerState, Update),
	NewDbPlayerMoney = update_db_player_money(PlayerState, Update),
	NewDbPlayerAttr = update_db_player_attr(PlayerState, Update),
	NewDbPlayerMark = update_db_player_mark(PlayerState, Update),

	save_buff_update_to_db(PlayerState, Update),

	Update1 = Update#player_state{
		db_player_base = null,
		db_player_attr = null,
		db_player_money = null,
		db_player_mark = null
	},
	PlayerState1 = util_tuple:copy_elements(PlayerState, Update1),
	PlayerState2 = PlayerState1#player_state{
		db_player_base = NewDbPlayerBase,
		db_player_money = NewDbPlayerMoney,
		db_player_attr = NewDbPlayerAttr,
		db_player_mark = NewDbPlayerMark
	},

	NewPlayerState =
		case IsRefreshAttr of
			true ->
				refresh_attr(PlayerState2);
			_ ->
				PlayerState2
		end,

	OldPlayerBase = PlayerState#player_state.db_player_base,
	NewPlayerState1 =
		case NewDbPlayerBase#db_player_base.lv =:= OldPlayerBase#db_player_base.lv of
			true ->
				NewPlayerState;
			false ->
				AttrTotal = NewPlayerState#player_state.attr_total,
				ChangePlayerAttr = #db_player_attr{cur_mp = AttrTotal#attr_base.mp, cur_hp = AttrTotal#attr_base.hp},
				{ok, NewPlayerAttr} = player_attr_cache:update(PlayerId, ChangePlayerAttr),
				NewPlayerState#player_state{db_player_attr = NewPlayerAttr}
		end,

	case IsSendUpdate of
		true ->
			%% 更新新的状态信息
			send_update(PlayerState, NewPlayerState1, Cause);
		_ ->
			skip
	end,
	{ok, NewPlayerState1}.

save_buff_update_to_db(PlayerState, Update) ->
	PlayerId = PlayerState#player_state.player_id,
	NewBuffDict = Update#player_state.buff_dict,
	case util_data:is_null(NewBuffDict) of
		true ->
			skip;
		_ ->
			OldBuffDict = PlayerState#player_state.buff_dict,
			F = fun(BuffId, Buff) ->
				case dict:find(BuffId, OldBuffDict) of
					{ok, Buff} ->
						skip;
					{ok, _} ->
						%% buff图标推送
						buff_base_lib:send_buff_info(PlayerState, NewBuffDict),
						buff_cache:update({PlayerId, BuffId}, Buff);
					_ ->
						%% buff图标推送
						buff_base_lib:send_buff_info(PlayerState, NewBuffDict),
						buff_cache:insert(Buff)
				end
			end,
			dict:map(F, NewBuffDict),

			F1 =
				fun(BuffId, _Buff) ->
					case dict:find(BuffId, NewBuffDict) of
						{ok, _} ->
							skip;
						_ ->
							%% buff图标推送
							buff_base_lib:send_buff_info(PlayerState, NewBuffDict),
							buff_cache:delete({PlayerId, BuffId})
					end
				end,
			dict:map(F1, OldBuffDict)
	end.

update_db_player_base(PlayerState, Update) ->
	#player_state{db_player_base = OldBaseDB, player_id = PlayerId} = PlayerState,
	#player_state{db_player_base = NewBaseDB} = Update,
	{ok, NewDbPlayerBase} =
		case util_data:is_null(NewBaseDB) of
			true ->
				{ok, OldBaseDB};
			_ ->
				player_base_cache:update(PlayerId, NewBaseDB)
		end,
	NewDbPlayerBase.

update_db_player_money(PlayerState, Update) ->
	#player_state{db_player_money = OldMoneyDB, player_id = PlayerId} = PlayerState,
	#player_state{db_player_money = NewMoneyDB} = Update,
	{ok, NewDbPlayerMoney} =
		case util_data:is_null(NewMoneyDB) of
			true ->
				{ok, OldMoneyDB};
			_ ->
%%                 ?ERR("update ~p", [NewMoneyDB]),
				player_money_cache:update(PlayerId, NewMoneyDB)
		end,
	NewDbPlayerMoney.

update_db_player_attr(PlayerState, Update) ->
	#player_state{db_player_attr = OldAttrDB, player_id = PlayerId} = PlayerState,
	#player_state{db_player_attr = NewAttrDB} = Update,
	{ok, NewDbPlayerAttr} =
		case util_data:is_null(NewAttrDB) of
			true ->
				{ok, OldAttrDB};
			_ ->
				player_attr_cache:update(PlayerId, NewAttrDB)
		end,
	NewDbPlayerAttr.

update_db_player_mark(PlayerState, Update) ->
	#player_state{db_player_mark = OldMarkDB, player_id = PlayerId} = PlayerState,
	#player_state{db_player_mark = NewMarkDB} = Update,
	{ok, NewDbPlayerMark} =
		case util_data:is_null(NewMarkDB) of
			true ->
				{ok, OldMarkDB};
			_ ->
				player_mark_cache:update(PlayerId, NewMarkDB)
		end,
	NewDbPlayerMark.

%% 发送新的状态信息 更新
send_update(OldState, NewState, Cause) ->
	UpdateList = make_update_data_list(?ALL_UPDATE_KEY, OldState, NewState, []),
	case UpdateList /= [] of
		true ->
			net_send:send_to_client(NewState#player_state.socket, 10004, #rep_update_player{update_list = UpdateList});
		_ ->
			skip
	end,

	case need_sync_to_scene(OldState, NewState) of
		true ->
			sync_to_scene(NewState, Cause);
		_ ->
			skip
	end,

	case need_sync_to_pet(OldState, NewState) of
		true ->
			sync_to_pet(NewState);
		_ ->
			skip
	end.

need_sync_to_scene(OldState, NewState) ->
	DbPlayerAttr1 = OldState#player_state.db_player_attr,
	DbPlayerAttr2 = NewState#player_state.db_player_attr,
	DbPlayerBase1 = OldState#player_state.db_player_base,
	DbPlayerBase2 = NewState#player_state.db_player_base,

	OldState#player_state.attr_base /= NewState#player_state.attr_base orelse
		OldState#player_state.attr_total /= NewState#player_state.attr_total orelse
		DbPlayerAttr1#db_player_attr.cur_hp /= DbPlayerAttr2#db_player_attr.cur_hp orelse
		DbPlayerAttr1#db_player_attr.cur_mp /= DbPlayerAttr2#db_player_attr.cur_mp orelse
		OldState#player_state.guise /= NewState#player_state.guise orelse
		OldState#player_state.pass_trigger_skill_list /= NewState#player_state.pass_trigger_skill_list orelse
		DbPlayerBase1#db_player_base.pk_mode /= DbPlayerBase2#db_player_base.pk_mode orelse
		DbPlayerBase1#db_player_base.guild_id /= DbPlayerBase2#db_player_base.guild_id orelse
		OldState#player_state.name_colour /= NewState#player_state.name_colour orelse
		OldState#player_state.team_id /= NewState#player_state.team_id orelse
		OldState#player_state.leader /= NewState#player_state.leader orelse
		DbPlayerBase1#db_player_base.fh_cd /= DbPlayerBase2#db_player_base.fh_cd orelse
		OldState#player_state.career_title /= NewState#player_state.career_title orelse
		OldState#player_state.pet_dict /= NewState#player_state.pet_dict orelse
		DbPlayerBase1#db_player_base.pet_att_type /= DbPlayerBase2#db_player_base.pet_att_type orelse
		DbPlayerBase1#db_player_base.vip /= DbPlayerBase2#db_player_base.vip orelse
		DbPlayerBase1#db_player_base.lv /= DbPlayerBase2#db_player_base.lv orelse
		OldState#player_state.collect_state /= NewState#player_state.collect_state.

sync_to_scene(PlayerState, Cause) ->
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	DbPlayerBase = PlayerState#player_state.db_player_base,
	Update = #scene_obj_state{
		attr_base = PlayerState#player_state.attr_base,
		attr_total = PlayerState#player_state.attr_total,
		cur_hp = DbPlayerAttr#db_player_attr.cur_hp,
		cur_mp = DbPlayerAttr#db_player_attr.cur_mp,
		guise = PlayerState#player_state.guise,
		pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list,
		pk_mode = DbPlayerBase#db_player_base.pk_mode,
		guild_id = DbPlayerBase#db_player_base.guild_id,
		legion_id = DbPlayerBase#db_player_base.legion_id,
		name_colour = PlayerState#player_state.name_colour,
		team_id = PlayerState#player_state.team_id,
		leader = PlayerState#player_state.leader,
		fh_cd = DbPlayerBase#db_player_base.fh_cd,
		career_title = PlayerState#player_state.career_title,
		pet_dict = PlayerState#player_state.pet_dict,
		pet_att_type = DbPlayerBase#db_player_base.pet_att_type,
		vip = DbPlayerBase#db_player_base.vip,
		lv = DbPlayerBase#db_player_base.lv,
		collect_state = PlayerState#player_state.collect_state
	},
	scene_obj_lib:update_obj(PlayerState#player_state.scene_pid, ?OBJ_TYPE_PLAYER, PlayerState#player_state.player_id, Update, Cause).

need_sync_to_pet(OldState, NewState) ->
	DbPlayerBase1 = OldState#player_state.db_player_base,
	DbPlayerBase2 = NewState#player_state.db_player_base,

	(DbPlayerBase1#db_player_base.pk_mode /= DbPlayerBase2#db_player_base.pk_mode orelse
		DbPlayerBase1#db_player_base.guild_id /= DbPlayerBase2#db_player_base.guild_id orelse
		OldState#player_state.team_id /= NewState#player_state.team_id orelse
		OldState#player_state.name_colour /= NewState#player_state.name_colour) andalso
		NewState#player_state.pet_dict /= undefined.

sync_to_pet(PlayerState) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	Update = #scene_obj_state{
		pk_mode = DbPlayerBase#db_player_base.pk_mode,
		guild_id = DbPlayerBase#db_player_base.guild_id,
		legion_id = DbPlayerBase#db_player_base.legion_id,
		name_colour = PlayerState#player_state.name_colour,
		team_id = PlayerState#player_state.team_id
	},

	PetDict = PlayerState#player_state.pet_dict,
	F = fun(_, PetInfo) ->
		PetScenePid = PetInfo#pet_info.scene_pid,
		PetId = PetInfo#pet_info.uid,
		scene_obj_lib:update_obj(PetScenePid, ?OBJ_TYPE_PET, PetId, Update, ?UPDATE_CAUSE_OTHER)
	end,
	dict:map(F, PetDict).


%% 组合玩家基础信息的更新 健值对 也是更新玩家的场景信息 比如 更新 玩家的血量 key＝血量的key值，values血量的内容值
make_update_data_list([], _OldState, _NewState, ClientUpdateList) ->
	ClientUpdateList;
make_update_data_list([UpdateKey | T], OldState, NewState, ClientUpdateList) ->
	V1 = get_update_key_value(UpdateKey, OldState),
	V2 = get_update_key_value(UpdateKey, NewState),
	NewUpdateList =
		case V1 /= V2 of
			true ->
				Proto = #proto_player_update{key = UpdateKey, value = V2},
				[Proto | ClientUpdateList];
			_ ->
				ClientUpdateList
		end,
	make_update_data_list(T, OldState, NewState, NewUpdateList).

%% 杀死怪物
kill_monster(PlayerPid, SceneId, MonsterId) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, do_kill_monster, [SceneId, MonsterId]}).

do_kill_monster(PlayerState, SceneId, MonsterId) ->
	MonsterConf = monster_config:get(MonsterId),
	%% 发送给运营活动处理
	operate_active_lib:kill_monster(PlayerState, MonsterId),
	AddExp = get_kill_monster_exp(PlayerState, SceneId, MonsterConf#monster_conf.exp),
	{ok, PlayerState1} = player_lib:add_exp(PlayerState, AddExp, {?LOG_TYPE_KILL_MONSTER, [SceneId, MonsterId]}),

	%% 如果有宠物通知宠物加经验
	#player_state{
		player_id = PlayerId,
		scene_pid = ScenePid,
		pet_dict = PetDict,
		skill_dict = SkillDict
	} = PlayerState1,

	case PetDict /= dict:new() of
		true ->
			%% 获取法师诱惑之光或者道士召唤神兽技能的信息用于确定宠物等级上限
			DbPlayerBase = PlayerState1#player_state.db_player_base,
			LvLimit =
				case DbPlayerBase#db_player_base.career of
					?CAREER_FASHI ->
						%% 诱惑之光技能id
						SkillId = 21000,
						case dict:find(SkillId, SkillDict) of
							{ok, Skill} ->
								SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
								[{tempt, _, _, Limit} | _T] = SkillConf#skill_conf.effect_list,
								Limit;
							_ ->
								0
						end;
					?CAREER_DAOSHI ->
						%% 召唤神兽技能id
						[{_, PetInfo} | _T] = dict:to_list(PetDict),

						%% 判断在场的宠物是骷髅还是神兽
						SkillId =
							if
								PetInfo#pet_info.monster_id >= 20011 ->
									30800;
								true ->
									30600
							end,
						case dict:find(SkillId, SkillDict) of
							{ok, Skill} ->
								SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
								[{call_pet, _, Limit} | _T1] = SkillConf#skill_conf.effect_list,
								Limit;
							_ ->
								0
						end;
					_ ->
						0
				end,
			case LvLimit > 0 of
				true ->
					obj_pet_lib:pet_add_exp(ScenePid, PlayerId, 1, LvLimit);
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	%% boss首杀活动
	active_ets:save_kill(PlayerState#player_state.player_id, MonsterId),
	%% 合服首杀boss
	active_merge_ets:save_kill(PlayerState#player_state.player_id, MonsterId),
	{ok, PlayerState2} = task_comply:update_player_tasksort_kill_monster(PlayerState1, MonsterId),
	%%每日任务
	task_comply:update_player_tasksort_kill_scene(PlayerState2, 1, SceneId).

%% 杀死怪物
kill_monster_by_team(PlayerPid, SceneId, MonsterId, AddExp) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, do_kill_monster_by_team, [SceneId, MonsterId, AddExp]}).

do_kill_monster_by_team(PlayerState, SceneId, MonsterId, Exp) ->
	?INFO("do_kill_monster_by_team ~p", [Exp]),
	AddExp = get_kill_monster_exp(PlayerState, SceneId, Exp),
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	CurHp = DbPlayerAttr#db_player_attr.cur_hp,
	%% 发送给运营活动处理
	operate_active_lib:kill_monster(PlayerState, MonsterId),
	case PlayerState#player_state.scene_id == SceneId andalso CurHp > 0 of
		true ->
			{ok, PlayerState1} = player_lib:add_exp(PlayerState, AddExp, {?LOG_TYPE_KILL_MONSTER, [SceneId, MonsterId]}),

			%% 如果有宠物通知宠物加经验
			#player_state{
				player_id = PlayerId,
				scene_pid = ScenePid,
				pet_dict = PetDict,
				skill_dict = SkillDict
			} = PlayerState1,

			case PetDict /= dict:new() of
				true ->
					%% 获取法师诱惑之光或者道士召唤神兽技能的信息用于确定宠物等级上限
					DbPlayerBase = PlayerState1#player_state.db_player_base,
					LvLimit =
						case DbPlayerBase#db_player_base.career of
							?CAREER_FASHI ->
								%% 诱惑之光技能id
								SkillId = 21000,
								case dict:find(SkillId, SkillDict) of
									{ok, Skill} ->
										SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
										[{tempt, _, _, Limit} | _T] = SkillConf#skill_conf.effect_list,
										Limit;
									_ ->
										0
								end;
							?CAREER_DAOSHI ->
								%% 召唤神兽技能id
								[{_, PetInfo} | _T] = dict:to_list(PetDict),

								%% 判断在场的宠物是骷髅还是神兽
								SkillId =
									if
										PetInfo#pet_info.monster_id >= 20011 ->
											30800;
										true ->
											30600
									end,
								case dict:find(SkillId, SkillDict) of
									{ok, Skill} ->
										SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
										[{call_pet, _, Limit} | _T1] = SkillConf#skill_conf.effect_list,
										Limit;
									_ ->
										0
								end;
							_ ->
								0
						end,
					case LvLimit > 0 of
						true ->
							obj_pet_lib:pet_add_exp(ScenePid, PlayerId, 1, LvLimit);
						_ ->
							skip
					end;
				_ ->
					skip
			end,

			{ok, PlayerState2} = task_comply:update_player_tasksort_kill_monster(PlayerState1, MonsterId),
			%%每日任务
			task_comply:update_player_tasksort_kill_scene(PlayerState2, 1, SceneId);
		false ->
			{ok, PlayerState}
	end.

%% 获取玩家的基础信息
get_scene_xy(PlayerState) ->
	{ok, PlayerState#player_state.db_player_base}.

%% 添加经验
add_exp(PlayerPid, AddExp, TypeMessage) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, add_exp, [AddExp, TypeMessage]});

add_exp(PlayerState, AddExp, TypeMessage) when is_record(PlayerState, player_state) ->
	add_exp(PlayerState, AddExp, true, TypeMessage).

add_exp(PlayerState, AddExp, IsSendUpdate, TypeMessage) when is_record(PlayerState, player_state) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	#db_player_base{
		lv = CurLv,
		exp = CurExp
	} = DbPlayerBase,
	{NewLv, NewExp} = make_new_lv_and_exp(CurLv, CurExp + AddExp),
	Update = #player_state{
		db_player_base = #db_player_base{lv = NewLv, exp = NewExp}
	},
	%% 添加日志记录
	log_lib:log_exp_inster(PlayerState, Update, TypeMessage, AddExp),
	case NewLv == CurLv of
		true ->
			update_player_state(PlayerState, Update, IsSendUpdate);
		false ->
			{ok, PlayerState1} = update_player_state(PlayerState, Update, IsSendUpdate, true),
			%% 添加勋章
			{ok, PlayerState2} = goods_lib:add_medal_goods(PlayerState1, CurLv, NewLv),
			%% 把玩家加进竞技场排名中
			arena_lib:add_player_to_arena_rank(PlayerState2, CurLv, NewLv),
			%% 功能开启
			PlayerState3 = function_lib:ref_function_open_list(PlayerState2),
			%% 升级任务
			{ok, PlayerState4} = task_comply:update_player_tasksort_up_lv(PlayerState3),
			%% 升级称号
			PlayerState5 = careertitle_lib:update_career_title(PlayerState4),
			%% 新手模式检测
			{ok, PlayerState6} = check_pk_mode(PlayerState5, CurLv, NewLv),
			%% 背包升级检测
			{ok, PlayerState7} = check_bag(PlayerState6, NewLv),
			%% 队伍数据更新
			team_lib:update_team_info(PlayerState7),

			%%下载资源包礼包
			gift_lib:download(PlayerState#player_state.player_id, NewLv),
			%%一生一次购买
			shop_lib:shop_once_add(PlayerState#player_state.player_id, CurLv, NewLv),

			log_lib:log_fight_player_change(PlayerState7, PlayerState, ?LOG_TYPE_LV_UPGRADE),

			active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_LOGION, PlayerState7, 1),
			{ok, PlayerState7}
	end.

make_new_lv_and_exp(Lv, Exp) ->
	case player_upgrade_config:get(Lv) of
		null ->
			#player_upgrade_conf{need_exp = Exp1} = player_upgrade_config:get(Lv - 1),
			{Lv - 1, Exp1};
		PlayerUpgradeConf ->
			NeedExp = PlayerUpgradeConf#player_upgrade_conf.need_exp,
			case NeedExp > 0 of
				true ->
					case NeedExp =< Exp of
						true ->
							make_new_lv_and_exp(Lv + 1, Exp - NeedExp);
						_ ->
							{Lv, Exp}
					end;
				_ ->
					{Lv, min(Exp, NeedExp)}
			end
	end.

revive(PlayerState, ReviveType) ->
	AttrTotal = PlayerState#player_state.attr_total,
	Update = #player_state{
		db_player_attr = #db_player_attr{cur_mp = AttrTotal#attr_base.mp, cur_hp = AttrTotal#attr_base.hp}
	},
	?INFO("playerlib 444 ~p", [ReviveType]),
	SceneId = PlayerState#player_state.scene_id,
	case is_number(SceneId) of
		true ->
			%% 如果场景不支持原地复活，强制把原地复活改成复活点复活
			SceneConf = scene_config:get(SceneId),
			ReviveType1 =
				if
					SceneConf#scene_conf.inplace_revive == 0 -> ?REVIVE_TYPE_REVIVE_AREA;
					true -> ReviveType
				end,

			case ReviveType1 of
				?REVIVE_TYPE_REVIVE_AREA ->
					%% 复活点复活
					case SceneConf#scene_conf.revive_area =:= [] of
						true ->
							?INFO("playerlib 222 ~p", [ReviveType1]),
							%% 回城复活
							Update1 =
								case SceneId =/= 32107 of
									true ->
										#player_state{
											db_player_attr = #db_player_attr{cur_mp = AttrTotal#attr_base.mp, cur_hp = AttrTotal#attr_base.hp div 2}
										};
									false ->
										Update
								end,
							{ok, PlayerState1} = update_player_state(PlayerState, Update1),
							ExitScene = SceneConf#scene_conf.exit_scene,
							scene_mgr_lib:change_scene(PlayerState1, self(), ExitScene, ?CHANGE_SCENE_TYPE_REVIVE, null);%%
						_ ->
							?INFO("playerlib 333 ~p", [ReviveType1]),
							Update1 =
								case SceneId =/= 32107 of
									true ->
										#player_state{
											db_player_attr = #db_player_attr{cur_mp = AttrTotal#attr_base.mp, cur_hp = AttrTotal#attr_base.hp div 2}
										};
									false ->
										Update
								end,
							%% 复活点复活
							scene_obj_lib:player_revive(PlayerState, ReviveType),
							update_player_state(PlayerState, Update1)
					end;
				_ ->
					Base = PlayerState#player_state.db_player_base,
					%% 原地复活
					VipFhNum = vip_lib:get_vip_fh_num(PlayerState#player_state.player_id, Base#db_player_base.career, Base#db_player_base.vip),
					case VipFhNum > 0 of
						true ->
							?INFO("playerlib 1111 ~p", [ReviveType1]),
							counter_lib:update(PlayerState#player_state.player_id, ?COUNTER_FH_NUM),
							scene_obj_lib:player_revive(PlayerState, ReviveType),
							update_player_state(PlayerState, Update);
						_ ->
							Times = case PlayerState#player_state.name_colour of
										?NAME_COLOUR_RED -> 1;
										_ -> 1
									end,
							case goods_lib_log:delete_goods_by_num(PlayerState, ?ITEM_REVIVE, Times, ?LOG_TYPE_REVIVE) of
								{ok, PlayerState1} ->
									?INFO("playerlib 555 ~p", [11]),
									scene_obj_lib:player_revive(PlayerState, ReviveType),
									update_player_state(PlayerState1, Update);
								_ ->
									DbPlayerMoney = PlayerState#player_state.db_player_money,
									GoodsConf = goods_config:get(?ITEM_REVIVE),
									NeedJade = GoodsConf#goods_conf.price_jade * Times,
									case DbPlayerMoney#db_player_money.jade >= NeedJade of
										true ->
											?INFO("playerlib 666 ~p", [11]),
											{ok, PlayerState1} = incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, false, ?LOG_TYPE_REVIVE),
											scene_obj_lib:player_revive(PlayerState, ReviveType),
											{ok, PlayerState2} = update_player_state(PlayerState1, Update, false),
											send_update(PlayerState, PlayerState2, ?UPDATE_CAUSE_OTHER),
											{ok, PlayerState2};
										_ ->
											{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
									end
							end
					end
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 回城
back_city(PlayerState) ->
	SceneId = PlayerState#player_state.scene_id,
	case is_number(SceneId) of
		true ->
			%% 如果场景不支持原地复活，强制把原地复活改成复活点复活
			SceneConf = scene_config:get(SceneId),
			%% 回城
			ExitScene = SceneConf#scene_conf.exit_scene,
			%% 获取出身点
			ExitSceneConf = scene_config:get(ExitScene),
			Point =
				case ExitSceneConf#scene_conf.birth_area of
					List when length(List) > 0 ->
						{{EX, EY}, {MX, MY}} = util_rand:list_rand(List),
						{util_rand:rand(EX, MX), util_rand:rand(EY, MY)};
					_ ->
						null
				end,
			scene_mgr_lib:change_scene(PlayerState, self(), ExitScene, ?CHANGE_SCENE_TYPE_CHANGE, Point);%%
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

get_name_colour(PkValue, GrayTime) ->
	PkValue1 = 21,
	PkValue2 = 79,
	NameColour1 =
		if
			PkValue =< PkValue1 -> ?NAME_COLOUR_WHITE;
			PkValue =< PkValue2 -> ?NAME_COLOUR_YELLOW;
			true -> ?NAME_COLOUR_RED
		end,

	CurTime = util_date:unixtime(),
	if
		NameColour1 /= ?NAME_COLOUR_RED andalso CurTime =< GrayTime -> ?NAME_COLOUR_GRAY;
		true -> NameColour1
	end.

%% 判断是否是罪犯
is_outlaw(NameColour) ->
	NameColour =:= ?NAME_COLOUR_RED orelse NameColour =:= ?NAME_COLOUR_GRAY orelse NameColour =:= ?NAME_COLOUR_YELLOW.

%% 获取玩家详细信息
get_player_detailed_info(State, PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			net_send:send_to_client(State#player_state.socket, 17017, #rep_get_member_info{result = ?ERR_PLAYER_LOGOUT});
		PlayerPid ->
			gen_server2:cast(PlayerPid, {get_player_detailed_info, State#player_state.socket})
	end.

%% ====================================================================
%% Mod API functions
%% ====================================================================
init_player_state(PlayerState, OsType, OpenId, Platform) ->
	#player_state{player_id = PlayerId, db_player_base = PlayerBase} = PlayerState,
	#db_player_base{pk_mode = PkMode, set_pk_mode = SetPkMode, pet_att_type = PetAttType} = PlayerBase,
	CurTime = util_date:unixtime(),
	DbUpdate = PlayerBase#db_player_base{
		os_type = OsType,
		last_login_time = CurTime,
		last_hook_time = CurTime,
		draw_hook_time = CurTime
	},

	DbUpdate1 =
		case SetPkMode == 0 of
			true ->
				DbUpdate#db_player_base{set_pk_mode = PkMode};
			_ ->
				DbUpdate
		end,

	DbUpdate2 =
		case PetAttType == 0 of
			true ->
				DbUpdate1#db_player_base{pet_att_type = ?ATTACK_TYPE_INITIATIVE};
			_ ->
				DbUpdate1
		end,

	{ok, NewPlayerBase} = player_base_cache:update(PlayerId, DbUpdate2),
	PlayerState22 = PlayerState#player_state{
		platform = Platform,
		open_id = OpenId,
		db_player_base = NewPlayerBase,
		last_use_skill_time = util_date:longunixtime(),
		last_reduce_time = CurTime,
		expire_goods_list = []
	},
	gen_server:cast(self(), {init_player_state2}),
	gen_server2:apply_after(?TIMER_FRAME + 1000, self(), {?MODULE, on_timer, []}),
	{ok, PlayerState22}.


init_player_state2(PlayerState) ->
	#player_state{player_id=PlayerId, db_player_base=PlayerBase, 	last_reduce_time = CurTime} = PlayerState,
	LastHookTime = PlayerBase#db_player_base.last_hook_time,
	DrawHookTime = PlayerBase#db_player_base.draw_hook_time,
	PlayerState1 = PlayerState#player_state{
		%% 保存已经开启的 功能信息
		function_open_list = function_lib:get_function_open_list(PlayerId, PlayerState)
	},
	PlayerState2 = load_player_money(PlayerState1),
	PlayerState3 = load_player_attr(PlayerState2),
	PlayerState3_1 = load_player_mark(PlayerState3),
	PlayerState4 = skill_base_lib:init_skill(PlayerState3_1),
	PlayerState5 = goods_lib:init_goods(PlayerState4),
	PlayerState6 = buff_base_lib:init(PlayerState5),

	PkValue = PlayerBase#db_player_base.pk_value,
	GrayTime = 0,
	NameColour = get_name_colour(PkValue, GrayTime),
	PlayerState7 = PlayerState6#player_state{name_colour = NameColour, gray_time = GrayTime},

	PlayerState8 = refresh_attr(PlayerState7),
	PlayerState9 = guild_lib:on_player_login(PlayerState8),

	%% 如果进入时玩家是死亡状态直接复活
	DbPlayerAttr = PlayerState9#player_state.db_player_attr,
	PlayerState10 =
		case DbPlayerAttr#db_player_attr.cur_hp =< 0 of
			true ->
				Attr = PlayerState9#player_state.attr_total,
				DbUpdate3 = #db_player_attr{cur_hp = Attr#attr_base.hp, cur_mp = Attr#attr_base.mp},
				{ok, NewDbPlayerAttr} = player_attr_cache:update(PlayerId, DbUpdate3),
				PlayerState9#player_state{db_player_attr = NewDbPlayerAttr};
			_ ->
				PlayerState9
		end,
	%% 军团检测
	PlayerStateLegion = legion_lib:on_player_login(PlayerState10),
	%% 初始化副本信息
	PlayerState11 = player_instance_lib:init(PlayerStateLegion),
	%% 初始化任务
	PlayerState12 = task_lib:init_task(PlayerState11),
	%% 加载宠物信息
	PlayerState13 = pet_lib:load_pet(PlayerState12),

	%% 计算离线收益
	TimeCount = min(CurTime - LastHookTime, CurTime - DrawHookTime),
	TimeCount1 = min(TimeCount, 86400),
	PlayerState15 = hook_lib:compute_hook_offline(PlayerState13, TimeCount1),

	%% 初始化挂机
	HookState = hook_lib:init(PlayerState15),
	player_lib:put_hook_state(HookState),
	%% 初始化挂机星级
	player_hook_star_lib:init(PlayerState15),
	%% 初始化挂机星级奖励
	hook_star_reward_lib:init(PlayerState15),

	%% 初始化邮件
	mail_lib:on_player_login(PlayerId),

	%% 初始化玩家的 关系ets
	relationship_lib:init(PlayerState15),
	%% 修改玩家的战力信息
	Base = PlayerState15#player_state.db_player_base,
	%% 校验玩家背包格子
	PlayerBag = Base#db_player_base.bag,
	Lv = Base#db_player_base.lv,
	SceneId = case scene_config:get(Base#db_player_base.scene_id) of
							#scene_conf{} ->
								Base#db_player_base.scene_id;
							_ ->
								20102
						end,
	NewCellConf = cell_config:get(Lv),
	NewCell = NewCellConf#cell_conf.cell,

	Update = #player_state
	{
		db_player_base = #db_player_base
		{
			fight = PlayerState15#player_state.fighting,
			guise = PlayerState15#player_state.guise,
			bag = max(PlayerBag, NewCell),
			is_robot = PlayerState15#player_state.is_robot,
			scene_id = SceneId
		},
		career_title = careertitle_lib:get_career_title_player_id(PlayerState15#player_state.player_id, Base#db_player_base.career)
	},
	%% 活动检测
	welfare_active_lib:check_active_state(PlayerState15),
	{ok, PlayerState16} = player_lib:update_player_state(PlayerState15, Update),

	CareerTitle = Update#player_state.career_title,
	case CareerTitle > 0 of
		true ->
			notice_lib:send_career_title(CareerTitle, Base#db_player_base.name);
		false ->
			skip
	end,
	%%检测行会宣战
	guild_challenge_lib:login_check(),

	%% 加载按钮提示
	PlayerState17 = button_tips_lib:init(PlayerState16),
	%% 队伍检测
	PlayerState18 = team_lib:player_login(PlayerState17),
	%% 神秘商店缓存
	PlayerState19 = mystery_shop_lib:init(PlayerState18),
	%% 合服竞技场检查
	arena_lib:check_uniform_service(PlayerState19),
	operate_active_lib:update_limit_type(PlayerState19, ?OPERATE_ACTIVE_LIMIT_TYPE_4),
	%% 登陆初始化双倍活动状态
	{ok, PlayerState20} = update_double_exp(PlayerState19),
	%% 开启功能按钮提醒检测
	NewPlayerState = active_remind_lib:check_active_remind('login', PlayerState20),
	active_rank_lib:checke_acitve_over(NewPlayerState),
	{ok, NewPlayerState}.



%% 定时器
on_timer(PlayerState) ->
%% 	io:format("on timer 1: ~p~n", [util_date:longunixtime()]),
	HookState = get_hook_state(),
	HookPlayerState =
		case hook_lib:on_timer(PlayerState, HookState) of
			{ok, _PlayerState1} ->
				_PlayerState1;
			_ ->
				PlayerState
		end,

	{ok, PlayerState2, RemoveBuffList} = buff_base_lib:trigger_effect(HookPlayerState),

	{ok, PlayerState3} = goods_util:check_blood_bag(PlayerState2),

	#player_state{
		name_colour = NameColour,
		gray_time = GrayTime,
		db_player_base = DbPlayerBase,
		last_reduce_time = LRTime
	} = PlayerState3,

	PkValue = DbPlayerBase#db_player_base.pk_value,
	CurTime = util_date:unixtime(),
	%%  pk值间隔减少逻辑
	{NewPkValue, PlayerState4} =
		case LRTime + ?PK_VALUE_REDUCE_INTERVAL =< CurTime andalso PkValue > 0 of
			true ->
				PkValue1 = max(PkValue - 1, 0),
				Update = #player_state{
					db_player_base = #db_player_base{
						pk_value = PkValue1
					},
					last_reduce_time = CurTime
				},
				{ok, _PlayerState3} = update_player_state(PlayerState3, Update, false),
				{PkValue1, _PlayerState3};
			_ ->
				{PkValue, PlayerState3}
		end,

	%% 判断玩家灰名时间是否失效
	NewNameColour = get_name_colour(NewPkValue, GrayTime),
	PlayerState5 =
		case NameColour /= NewNameColour of
			true ->
				_PlayerState4 = PlayerState4#player_state{name_colour = NewNameColour},
				_PlayerState4;
			_ ->
				PlayerState4
		end,

	%% 任务检测
	{ok, NewPlayerState} = active_task_lib:check_ref_tasklist(PlayerState5, false),

%% %% 	%% 双倍经验
%% 	{ok, NewPlayerState} = update_double_exp(PlayerState6),
	%% 红点检测
	welfare_active_lib:check_button_online_tips(NewPlayerState),
	%% 晚上12点刷新红点
	NewPlayerState1 = refuse_function_by_24hours(NewPlayerState, CurTime),
	%% 检测限时活动
	NewPlayerState2 = active_remind_lib:check_active_remind('on_timer', NewPlayerState1),

	NewPlayerState3 = chat_lib:send_chat_list(NewPlayerState2, NewPlayerState1#player_state.chat_list),
	%% 限时道具检测
	{NewPlayerState4, IsUpdateAttr} = goods_lib:check_expire_goods(NewPlayerState3),

	%% 移除的buffid检测 如果有属性强化buff重新计算属性
	IsUpdateAttr1 = is_refuse_attr_by_buff(RemoveBuffList, IsUpdateAttr),

	%% 验证是否在线，如果不在线，那么就退出账号
	case player_lib:get_player_pid(PlayerState#player_state.player_id) of
		null ->
			player_lib:logout(PlayerState);
		Pid ->
			case Pid /= self() of
				true ->
					player_lib:logout(PlayerState);
				_ ->
					%% 确保需要更新缓存的内容全部更新
					{ok, NPS} = update_player_state(PlayerState, NewPlayerState4, true, IsUpdateAttr1),
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
%% 					io:format("on timer 2: ~p~n", [util_date:longunixtime()]),
					{ok, NPS}
			end
	end.

get_hook_state() ->
	get(hook_state).
%% 修改挂机状态
put_hook_state(HookState) ->
	put(hook_state, HookState).

can_action(PlayerState) ->
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	BuffDict = PlayerState#player_state.buff_dict,
	EffectDict = PlayerState#player_state.effect_dict,
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_STUN),
	BuffEffect1 = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_MB),
	Res = (DbPlayerAttr#db_player_attr.cur_hp > 0 andalso
		BuffEffect#buff_effect.effect_p =:= 0 andalso
		BuffEffect#buff_effect.effect_v =:= 0 andalso
		BuffEffect1#buff_effect.effect_p =:= 0 andalso
		BuffEffect1#buff_effect.effect_v =:= 0),
	Res.

%% 判断A是否能使用技能(沉默效果判断)
can_use_skill(PlayerState) ->
	BuffDict = PlayerState#player_state.buff_dict,
	EffectDict = PlayerState#player_state.effect_dict,
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_SILENT),
	Res = BuffEffect#buff_effect.effect_v =:= 0 andalso BuffEffect#buff_effect.effect_p =:= 0,
	Res.

chang_pk_mode(PlayerState, PkMode) ->
	SceneId = PlayerState#player_state.scene_id,
	case util_data:is_null(SceneId) of
		true ->
			{fail, 1};
		_ ->
			SceneConf = scene_config:get(SceneId),
			PkModeList = SceneConf#scene_conf.pk_mode_list,
			case lists:member(PkMode, PkModeList) of
				true ->
					Update = #player_state{
						db_player_base = #db_player_base{pk_mode = PkMode, set_pk_mode = PkMode}
					},
					update_player_state(PlayerState, Update);
				_ ->
					{fail, 2}
			end
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
load_player_money(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case player_money_cache:select_row(PlayerId) of
		#db_player_money{} = PlayerMoney ->
			PlayerState#player_state{db_player_money = PlayerMoney};
		_ ->
			PlayerMoney = #db_player_money{
				player_id = PlayerId,
				coin = 0,
				jade = 0,
				gift = 0,
				smelt_value = 0,
				feats = 0,
				hp_mark_value = 0,
				atk_mark_value = 0,
				def_mark_value = 0,
				res_mark_value = 0
			},
			player_money_cache:insert(PlayerMoney),
			PlayerState#player_state{db_player_money = PlayerMoney}
	end.

load_player_attr(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case player_attr_cache:select_row(PlayerId) of
		#db_player_attr{} = PlayerAttr ->
			PlayerState#player_state{db_player_attr = PlayerAttr};
		_ ->
			PlayerAttr = #db_player_attr{
				player_id = PlayerId,
				cur_hp = 0,
				cur_mp = 0,
				last_recover_hp = 0,
				last_recover_mp = 0
			},
			player_attr_cache:insert(PlayerAttr),
			PlayerState#player_state{db_player_attr = PlayerAttr}
	end.

load_player_mark(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case player_mark_cache:select_row(PlayerId) of
		#db_player_mark{} = PlayerMark ->
			PlayerState#player_state{db_player_mark = PlayerMark};
		_ ->
			PlayerMark = #db_player_mark{
				player_id = PlayerId,
				hp_mark = 0,
				atk_mark = 0,
				def_mark = 0,
				res_mark = 0,
				holy_mark = 0,
				mounts_mark_1 = 0,
				mounts_mark_2 = 0,
				mounts_mark_3 = 0,
				mounts_mark_4 = 0,
				update_time = util_date:unixtime()
			},
			player_mark_cache:insert(PlayerMark),
			PlayerState#player_state{db_player_mark = PlayerMark}
	end.

%% 全部属性重新算
refresh_attr(PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	ConfPlayerAttr = player_attr_config:get({PlayerBase#db_player_base.career, PlayerBase#db_player_base.lv}),
	PlayerBaseAttr = ConfPlayerAttr#player_attr_conf.attr_base,
	%% 玩家进程内调用 获取玩家装备属性列表
	%% 总基础属性(装备基础属性 ＋ 人物基础属性＋vip属性加成)
	VipAttr = vip_lib:get_vip_attributes(PlayerBase#db_player_base.career, PlayerBase#db_player_base.vip),
	%% 玩家印记属性
	SecureAttr = player_mark_lib:get_player_secure_attr(PlayerState),

	{EBaseAttr, ETotalAttr} = equips_lib:get_equips_attr_list(),
	%% 玩家坐骑属性
	BaseMountsAttr = player_mark_lib:get_player_mounts_mark_attr(PlayerState),
	NewMuntsAttr = api_attr:addition_attr(BaseMountsAttr, EBaseAttr#attr_base.mounts_p / ?PERCENT_BASE),

	AttrList = [PlayerBaseAttr, ETotalAttr, VipAttr, SecureAttr, NewMuntsAttr],
	TotalAttr = api_attr:attach_attr(AttrList),

	TotalBaseAttr = api_attr:attach_attr([EBaseAttr, PlayerBaseAttr]),

	%% 最后计算百分比加成属性
	ExAttr = api_attr:compute_base_attr_p(TotalBaseAttr, TotalAttr),
	%% 把百分比加成属性加到总属性上
	TotalAttr1 = api_attr:attach_attr([ExAttr, TotalAttr]),
	%% 追加buff属性
	BuffAttr = get_buff_attr_plus(PlayerState),
	ExBuffAttr = api_attr:compute_base_attr_p(TotalAttr1, BuffAttr),
	TotalAttr2 = api_attr:attach_attr_by_value([TotalAttr1, ExBuffAttr, BuffAttr]),
	%% 取整
	NewPlayerState = PlayerState#player_state{
		attr_base = TotalBaseAttr,
		attr_total = api_attr:floor_attr(TotalAttr2)
	},
	%% 更新玩家战斗力
	NewPlayerState1 = update_total_fighting(NewPlayerState),

	check_hp_mp(NewPlayerState1, PlayerState).


make_proto_login_info(PlayerId) ->
	case player_base_cache:select_row(PlayerId) of
		#db_player_base{} = PlayerBase ->
			#proto_login_info{
				player_id = PlayerId,
				name = PlayerBase#db_player_base.name,
				sex = PlayerBase#db_player_base.sex,
				career = PlayerBase#db_player_base.career,
				lv = PlayerBase#db_player_base.lv
			};
		_ ->
			null
	end.

make_proto_player_info(PlayerState) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	?INFO("-=-=-=-=-=-= ~p", [PlayerState#player_state.pet_num]),
	#proto_player_info{
		player_id = PlayerState#player_state.player_id,
		name = DbPlayerBase#db_player_base.name,
		sex = DbPlayerBase#db_player_base.sex,
		career = DbPlayerBase#db_player_base.career,
		lv = DbPlayerBase#db_player_base.lv,
		exp = DbPlayerBase#db_player_base.exp,
		attr_base = make_proto_attr_base(PlayerState#player_state.attr_total, DbPlayerAttr),
		guise = make_proto_guise(PlayerState#player_state.guise),
		money = make_proto_money(PlayerState#player_state.db_player_money),
		mark = make_proto_mark(PlayerState#player_state.db_player_mark),
		hook_scene_id = DbPlayerBase#db_player_base.hook_scene_id,
		pass_hook_scene_id = DbPlayerBase#db_player_base.pass_hook_scene_id,
		fighting = PlayerState#player_state.fighting,
		bag = DbPlayerBase#db_player_base.bag,
		guild_id = DbPlayerBase#db_player_base.guild_id,
		legion_id = DbPlayerBase#db_player_base.legion_id,
		pk_mode = DbPlayerBase#db_player_base.pk_mode,
		vip = DbPlayerBase#db_player_base.vip,
		pk_value = DbPlayerBase#db_player_base.pk_value,
		hp_set = DbPlayerBase#db_player_base.hp_set,
		hpmp_set = DbPlayerBase#db_player_base.hpmp_set,
		career_title = PlayerState#player_state.career_title,
		equip_sell_set = DbPlayerBase#db_player_base.equip_sell_set,
		pickup_set = DbPlayerBase#db_player_base.pickup_set,
		function_open_list = PlayerState#player_state.function_open_list,
		guide_step_list = guide_lib:get_guide_list(PlayerState#player_state.player_id),
		vip_exp = DbPlayerBase#db_player_base.vip_exp,
		wing_state = DbPlayerBase#db_player_base.wing_state, %%
		weapon_state = DbPlayerBase#db_player_base.weapon_state,
		pet_att_type = DbPlayerBase#db_player_base.pet_att_type,
		pet_num = PlayerState#player_state.pet_num,
		register_time = DbPlayerBase#db_player_base.register_time,
		team_id = PlayerState#player_state.team_id
	}.

make_proto_attr_base(AttrBase, DbPlayerAttr) ->
	#proto_attr_base{
		cur_hp = DbPlayerAttr#db_player_attr.cur_hp,
		cur_mp = DbPlayerAttr#db_player_attr.cur_mp,
		hp = AttrBase#attr_base.hp,
		mp = AttrBase#attr_base.mp,
		min_ac = AttrBase#attr_base.min_ac,
		max_ac = AttrBase#attr_base.max_ac,
		min_mac = AttrBase#attr_base.min_mac,
		max_mac = AttrBase#attr_base.max_mac,
		min_sc = AttrBase#attr_base.min_sc,
		max_sc = AttrBase#attr_base.max_sc,
		min_def = AttrBase#attr_base.min_def,
		max_def = AttrBase#attr_base.max_def,
		min_res = AttrBase#attr_base.min_res,
		max_res = AttrBase#attr_base.max_res,
		crit = AttrBase#attr_base.crit,
		crit_att = AttrBase#attr_base.crit_att,
		hit = AttrBase#attr_base.hit,
		dodge = AttrBase#attr_base.dodge,
		damage_deepen = AttrBase#attr_base.damage_deepen,
		damage_reduction = AttrBase#attr_base.damage_reduction,
		holy = AttrBase#attr_base.holy,
		skill_add = AttrBase#attr_base.skill_add,
		m_hit = AttrBase#attr_base.m_hit,
		m_dodge = AttrBase#attr_base.m_dodge,
		hp_recover = AttrBase#attr_base.hp_recover,
		mp_recover = AttrBase#attr_base.mp_recover,
		resurgence = AttrBase#attr_base.resurgence,
		damage_offset = AttrBase#attr_base.damage_offset,
		luck = AttrBase#attr_base.luck,
		hp_p = AttrBase#attr_base.hp_p,
		mp_p = AttrBase#attr_base.mp_p,
		min_ac_p = AttrBase#attr_base.min_ac_p,
		max_ac_p = AttrBase#attr_base.max_ac_p,
		min_mac_p = AttrBase#attr_base.min_mac_p,
		max_mac_p = AttrBase#attr_base.max_mac_p,
		min_sc_p = AttrBase#attr_base.min_sc_p,
		max_sc_p = AttrBase#attr_base.max_sc_p,
		min_def_p = AttrBase#attr_base.min_def_p,
		max_def_p = AttrBase#attr_base.max_def_p,
		min_res_p = AttrBase#attr_base.min_res_p,
		max_res_p = AttrBase#attr_base.max_res_p,
		crit_p = AttrBase#attr_base.crit_p,
		crit_att_p = AttrBase#attr_base.crit_att_p,
		hit_p = AttrBase#attr_base.hit_p,
		dodge_p = AttrBase#attr_base.dodge_p,
		damage_deepen_p = AttrBase#attr_base.damage_deepen_p,
		damage_reduction_p = AttrBase#attr_base.damage_reduction_p,
		holy_p = AttrBase#attr_base.holy_p,
		skill_add_p = AttrBase#attr_base.skill_add_p,
		m_hit_p = AttrBase#attr_base.m_hit_p,
		m_dodge_p = AttrBase#attr_base.m_dodge_p,
		hp_recover_p = AttrBase#attr_base.hp_recover_p,
		mp_recover_p = AttrBase#attr_base.mp_recover_p,
		resurgence_p = AttrBase#attr_base.resurgence_p,
		damage_offset_p = AttrBase#attr_base.damage_offset_p
	}.

make_proto_guise(GuiseState) ->
	#proto_guise{
		weapon = GuiseState#guise_state.weapon,
		clothes = GuiseState#guise_state.clothes,
		wing = GuiseState#guise_state.wing,
		mounts = GuiseState#guise_state.mounts,
		pet = 0,
		mounts_aura = GuiseState#guise_state.mounts_aura
	}.

make_proto_money(PlayerMoney) ->
	#proto_money{
		coin = PlayerMoney#db_player_money.coin,
		jade = PlayerMoney#db_player_money.jade,
		gift = PlayerMoney#db_player_money.gift,
		smelt_value = PlayerMoney#db_player_money.smelt_value,
		feats = PlayerMoney#db_player_money.feats,
		hp_mark_value = PlayerMoney#db_player_money.hp_mark_value,  %%  hp印记值
		atk_mark_value = PlayerMoney#db_player_money.atk_mark_value,  %%  攻击印记值
		def_mark_value = PlayerMoney#db_player_money.def_mark_value,  %%  防御印记值
		res_mark_value = PlayerMoney#db_player_money.res_mark_value  %%  魔防印记值
	}.

make_proto_mark(PlayerMark) ->
	#proto_mark{
		hp_mark = PlayerMark#db_player_mark.hp_mark,  %%  hp印记
		atk_mark = PlayerMark#db_player_mark.atk_mark,  %%  atk印记
		def_mark = PlayerMark#db_player_mark.def_mark,  %%  def印记
		res_mark = PlayerMark#db_player_mark.res_mark,  %%  res印记
		holy_mark = PlayerMark#db_player_mark.holy_mark,  %%  holy印记
		mounts_mark_1 = PlayerMark#db_player_mark.mounts_mark_1,  %%  坐骑装备印记1
		mounts_mark_2 = PlayerMark#db_player_mark.mounts_mark_2,  %%  坐骑装备印记2
		mounts_mark_3 = PlayerMark#db_player_mark.mounts_mark_3,  %%  坐骑装备印记3
		mounts_mark_4 = PlayerMark#db_player_mark.mounts_mark_4  %%  坐骑装备印记4
	}.

check({name, Name}) ->
	Name;
check({sex, Sex}) ->
	case Sex of
		?SEX_MALE -> ?SEX_MALE;
		_ -> ?SEX_FEMALE
	end;
check({career, Career}) ->
	case Career of
		?CAREER_ZHANSHI -> ?CAREER_ZHANSHI;
		?CAREER_FASHI -> ?CAREER_FASHI;
		?CAREER_DAOSHI -> ?CAREER_DAOSHI;
		_ -> ?CAREER_ZHANSHI
	end.

%% hp mp上限变更检测
check_hp_mp(PlayerState, OldPlayerState) ->
	TotalAttr = PlayerState#player_state.attr_total,
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	OldTotalAttr = OldPlayerState#player_state.attr_total,
	OldDbPlayerAttr = OldPlayerState#player_state.db_player_attr,

	case is_record(OldTotalAttr, attr_base) andalso is_record(OldDbPlayerAttr, db_player_attr) of
		true ->
			OldCurHp = OldDbPlayerAttr#db_player_attr.cur_hp,
			OldCurMp = OldDbPlayerAttr#db_player_attr.cur_mp,
			OldHp = OldTotalAttr#attr_base.hp,
			OldMp = OldTotalAttr#attr_base.mp,

			DbPlayerAttr1 = DbPlayerAttr#db_player_attr{
				cur_hp = trunc(TotalAttr#attr_base.hp * (OldCurHp / OldHp)),
				cur_mp = trunc(TotalAttr#attr_base.mp * (OldCurMp / OldMp))
			},
			PlayerState#player_state{db_player_attr = DbPlayerAttr1};
		false ->
			PlayerState
	end.

get_update_key_value(UpdateKey, PlayerState) ->
	IndexList = get_key_map(UpdateKey),
	get_update_key_value1(IndexList, PlayerState).

get_update_key_value1([], V) ->
	V;
get_update_key_value1([K | T], V) ->
	V1 = element(K, V),
	get_update_key_value1(T, V1).

get_key_map(?UPDATE_KEY_LV) -> [#player_state.db_player_base, #db_player_base.lv];
get_key_map(?UPDATE_KEY_EXP) -> [#player_state.db_player_base, #db_player_base.exp];
get_key_map(?UPDATE_KEY_CUR_HP) -> [#player_state.db_player_attr, #db_player_attr.cur_hp];
get_key_map(?UPDATE_KEY_CUR_MP) -> [#player_state.db_player_attr, #db_player_attr.cur_mp];
get_key_map(?UPDATE_KEY_HP) -> [#player_state.attr_total, #attr_base.hp];
get_key_map(?UPDATE_KEY_MP) -> [#player_state.attr_total, #attr_base.mp];
get_key_map(?UPDATE_KEY_MIN_AC) -> [#player_state.attr_total, #attr_base.min_ac];
get_key_map(?UPDATE_KEY_MAX_AC) -> [#player_state.attr_total, #attr_base.max_ac];
get_key_map(?UPDATE_KEY_MIN_MAC) -> [#player_state.attr_total, #attr_base.min_mac];
get_key_map(?UPDATE_KEY_MAX_MAC) -> [#player_state.attr_total, #attr_base.max_mac];
get_key_map(?UPDATE_KEY_MIN_SC) -> [#player_state.attr_total, #attr_base.min_sc];
get_key_map(?UPDATE_KEY_MAX_SC) -> [#player_state.attr_total, #attr_base.max_sc];
get_key_map(?UPDATE_KEY_MIN_DEF) -> [#player_state.attr_total, #attr_base.min_def];
get_key_map(?UPDATE_KEY_MAX_DEF) -> [#player_state.attr_total, #attr_base.max_def];
get_key_map(?UPDATE_KEY_MIN_RES) -> [#player_state.attr_total, #attr_base.min_res];
get_key_map(?UPDATE_KEY_MAX_RES) -> [#player_state.attr_total, #attr_base.max_res];
get_key_map(?UPDATE_KEY_CRIT) -> [#player_state.attr_total, #attr_base.crit];
get_key_map(?UPDATE_KEY_CRIT_ATT) -> [#player_state.attr_total, #attr_base.crit_att];
get_key_map(?UPDATE_KEY_HIT) -> [#player_state.attr_total, #attr_base.hit];
get_key_map(?UPDATE_KEY_DODGE) -> [#player_state.attr_total, #attr_base.dodge];
get_key_map(?UPDATE_KEY_DAMAGE_DEEPEN) -> [#player_state.attr_total, #attr_base.damage_deepen];
get_key_map(?UPDATE_KEY_DAMAGE_REDUCTION) -> [#player_state.attr_total, #attr_base.damage_reduction];
get_key_map(?UPDATE_KEY_HOLY) -> [#player_state.attr_total, #attr_base.holy];
get_key_map(?UPDATE_KEY_SKILL_ADD) -> [#player_state.attr_total, #attr_base.skill_add];
get_key_map(?UPDATE_KEY_M_HIT) -> [#player_state.attr_total, #attr_base.m_hit];
get_key_map(?UPDATE_KEY_M_DODGE) -> [#player_state.attr_total, #attr_base.m_dodge];
get_key_map(?UPDATE_KEY_HP_RECOVER) -> [#player_state.attr_total, #attr_base.hp_recover];
get_key_map(?UPDATE_KEY_MP_RECOVER) -> [#player_state.attr_total, #attr_base.mp_recover];
get_key_map(?UPDATE_KEY_RESURGENCE) -> [#player_state.attr_total, #attr_base.resurgence];
get_key_map(?UPDATE_KEY_DAMAGE_OFFSET) -> [#player_state.attr_total, #attr_base.damage_offset];
get_key_map(?UPDATE_KEY_JADE) -> [#player_state.db_player_money, #db_player_money.jade];
get_key_map(?UPDATE_KEY_COIN) -> [#player_state.db_player_money, #db_player_money.coin];
get_key_map(?UPDATE_KEY_GUISE_WEAPON) -> [#player_state.guise, #guise_state.weapon];
get_key_map(?UPDATE_KEY_GUISE_CLOTHES) -> [#player_state.guise, #guise_state.clothes];
get_key_map(?UPDATE_KEY_SMELT) -> [#player_state.db_player_money, #db_player_money.smelt_value];
get_key_map(?UPDATE_KEY_HOOK_SCENE_ID) -> [#player_state.db_player_base, #db_player_base.hook_scene_id];
get_key_map(?UPDATE_KEY_PASS_HOOK_SCENE_ID) -> [#player_state.db_player_base, #db_player_base.pass_hook_scene_id];
get_key_map(?UPDATE_KEY_HP_P) -> [#player_state.attr_total, #attr_base.hp_p];
get_key_map(?UPDATE_KEY_MP_P) -> [#player_state.attr_total, #attr_base.mp_p];
get_key_map(?UPDATE_KEY_MIN_AC_P) -> [#player_state.attr_total, #attr_base.min_ac_p];
get_key_map(?UPDATE_KEY_MAX_AC_P) -> [#player_state.attr_total, #attr_base.max_ac_p];
get_key_map(?UPDATE_KEY_MIN_MAC_P) -> [#player_state.attr_total, #attr_base.min_mac_p];
get_key_map(?UPDATE_KEY_MAX_MAC_P) -> [#player_state.attr_total, #attr_base.max_mac_p];
get_key_map(?UPDATE_KEY_MIN_SC_P) -> [#player_state.attr_total, #attr_base.min_sc_p];
get_key_map(?UPDATE_KEY_MAX_SC_P) -> [#player_state.attr_total, #attr_base.max_sc_p];
get_key_map(?UPDATE_KEY_MIN_DEF_P) -> [#player_state.attr_total, #attr_base.min_def_p];
get_key_map(?UPDATE_KEY_MAX_DEF_P) -> [#player_state.attr_total, #attr_base.max_def_p];
get_key_map(?UPDATE_KEY_MIN_RES_P) -> [#player_state.attr_total, #attr_base.min_res_p];
get_key_map(?UPDATE_KEY_MAX_RES_P) -> [#player_state.attr_total, #attr_base.max_res_p];
get_key_map(?UPDATE_KEY_CRIT_P) -> [#player_state.attr_total, #attr_base.crit_p];
get_key_map(?UPDATE_KEY_CRIT_ATT_P) -> [#player_state.attr_total, #attr_base.crit_att_p];
get_key_map(?UPDATE_KEY_HIT_P) -> [#player_state.attr_total, #attr_base.hit_p];
get_key_map(?UPDATE_KEY_DODGE_P) -> [#player_state.attr_total, #attr_base.dodge_p];
get_key_map(?UPDATE_KEY_DAMAGE_DEEPEN_P) -> [#player_state.attr_total, #attr_base.damage_deepen_p];
get_key_map(?UPDATE_KEY_DAMAGE_REDUCTION_P) -> [#player_state.attr_total, #attr_base.damage_reduction_p];
get_key_map(?UPDATE_KEY_HOLY_P) -> [#player_state.attr_total, #attr_base.holy_p];
get_key_map(?UPDATE_KEY_SKILL_ADD_P) -> [#player_state.attr_total, #attr_base.skill_add_p];
get_key_map(?UPDATE_KEY_M_HIT_P) -> [#player_state.attr_total, #attr_base.m_hit_p];
get_key_map(?UPDATE_KEY_M_DODGE_P) -> [#player_state.attr_total, #attr_base.m_dodge_p];
get_key_map(?UPDATE_KEY_HP_RECOVER_P) -> [#player_state.attr_total, #attr_base.hp_recover_p];
get_key_map(?UPDATE_KEY_MP_RECOVER_P) -> [#player_state.attr_total, #attr_base.mp_recover_p];
get_key_map(?UPDATE_KEY_RESURGENCE_P) -> [#player_state.attr_total, #attr_base.resurgence_p];
get_key_map(?UPDATE_KEY_DAMAGE_OFFSET_P) -> [#player_state.attr_total, #attr_base.damage_offset_p];
get_key_map(?UPDATE_KEY_FIGHTINF) -> [#player_state.fighting];
get_key_map(?UPDATE_KEY_BAG) -> [#player_state.db_player_base, #db_player_base.bag];
get_key_map(?UPDATE_KEY_GUISE_WING) -> [#player_state.guise, #guise_state.wing];
get_key_map(?UPDATE_KEY_GUISE_PET) -> [#player_state.guise, #guise_state.pet];
get_key_map(?UPDATE_KEY_COIN_P) -> [#player_state.attr_total, #attr_base.coin_p];
get_key_map(?UPDATE_KEY_EXP_P) -> [#player_state.attr_total, #attr_base.exp_p];
get_key_map(?UPDATE_KEY_GIFT) -> [#player_state.db_player_money, #db_player_money.gift];
get_key_map(?UPDATE_KEY_PK_VALUE) -> [#player_state.db_player_base, #db_player_base.pk_value];
get_key_map(?UPDATE_KEY_PK_MODE) -> [#player_state.db_player_base, #db_player_base.pk_mode];
get_key_map(?UPDATE_KEY_VIP) -> [#player_state.db_player_base, #db_player_base.vip];
get_key_map(?UPDATE_KEY_LUCK) -> [#player_state.attr_total, #attr_base.luck];
get_key_map(?UPDATE_KEY_NAME_COLOUR) -> [#player_state.name_colour];
get_key_map(?UPDATE_KEY_CAREER_Title) -> [#player_state.career_title];
get_key_map(?UPDATE_KEY_FEATS) -> [#player_state.db_player_money, #db_player_money.feats];
get_key_map(?UPDATE_KEY_VIP_EXP) -> [#player_state.db_player_base, #db_player_base.vip_exp];
get_key_map(?UPDATE_KEY_WING_STATE) -> [#player_state.db_player_base, #db_player_base.wing_state];%%
get_key_map(?UPDATE_KEY_WEAPON_STATE) -> [#player_state.db_player_base, #db_player_base.weapon_state];
get_key_map(?UPDATE_KEY_PET_ATT_TYPE) -> [#player_state.db_player_base, #db_player_base.pet_att_type];
get_key_map(?UPDATE_KEY_PET_NUM) -> [#player_state.pet_num];
get_key_map(?UPDATE_KEY_GUISE_MOUNTS) -> [#player_state.guise, #guise_state.mounts];
get_key_map(?UPDATE_KEY_TEAM_ID) -> [#player_state.team_id];
get_key_map(?UPDATE_KEY_HP_MARK_VALUE) -> [#player_state.db_player_money, #db_player_money.hp_mark_value];
get_key_map(?UPDATE_KEY_ATK_MARK_VALUE) -> [#player_state.db_player_money, #db_player_money.atk_mark_value];
get_key_map(?UPDATE_KEY_DEF_MARK_VALUE) -> [#player_state.db_player_money, #db_player_money.def_mark_value];
get_key_map(?UPDATE_KEY_RES_MARK_VALUE) -> [#player_state.db_player_money, #db_player_money.res_mark_value];
get_key_map(?UPDATE_KEY_HP_MARK) -> [#player_state.db_player_mark, #db_player_mark.hp_mark];
get_key_map(?UPDATE_KEY_ATK_MARK) -> [#player_state.db_player_mark, #db_player_mark.atk_mark];
get_key_map(?UPDATE_KEY_DEF_MARK) -> [#player_state.db_player_mark, #db_player_mark.def_mark];
get_key_map(?UPDATE_KEY_RES_MARK) -> [#player_state.db_player_mark, #db_player_mark.res_mark];
get_key_map(?UPDATE_KEY_HOLY_MARK) -> [#player_state.db_player_mark, #db_player_mark.holy_mark];
get_key_map(?UPDATE_KEY_MOUNT_MARK_1) -> [#player_state.db_player_mark, #db_player_mark.mounts_mark_1];
get_key_map(?UPDATE_KEY_MOUNT_MARK_2) -> [#player_state.db_player_mark, #db_player_mark.mounts_mark_2];
get_key_map(?UPDATE_KEY_MOUNT_MARK_3) -> [#player_state.db_player_mark, #db_player_mark.mounts_mark_3];
get_key_map(?UPDATE_KEY_MOUNT_MARK_4) -> [#player_state.db_player_mark, #db_player_mark.mounts_mark_4];
get_key_map(?UPDATE_KEY_GUISE_MOUNTS_AURA) -> [#player_state.guise, #guise_state.mounts_aura].

%% 更新玩家总属性战斗力
update_total_fighting(PlayerState) ->
	Fun = fun(Key, Acc) ->
		Value = get_update_key_value(Key, PlayerState),
		FConf = fighting_config:get(Key),
		Acc + Value * FConf#fighting_conf.fight
	end,
	Temp = lists:foldl(Fun, 0, fighting_config:get_list()),
	Fighting = Temp div 10,

	%% 修完玩家的战力信息
	Base = PlayerState#player_state.db_player_base,
	NewBase = Base#db_player_base{
		fight = Fighting,
		guise = PlayerState#player_state.guise
	},
	NewPlayerState = PlayerState#player_state{fighting = Fighting, db_player_base = NewBase},
	%% 开服活动红点战力刷新
	{ok, NewPlayerState1} = active_service_lib:ref_button_tips(NewPlayerState, ?ACTIVE_SERVICE_TYPE_FIGHT),%%
	%% 合服战力更新
	{ok, NewPlayerState2} = active_service_merge_lib:ref_button_tips(NewPlayerState1, ?MERGE_ACTIVE_SERVICE_TYPE_FIGHT),%%
	careertitle_lib:update_career_title(NewPlayerState2).

%% 获取击杀怪物经验(经验加成buff检测)
get_kill_monster_exp(PlayerState, SceneId, Exp) ->
	SceneConf = scene_config:get(SceneId),
	%% 副本不启用经验加成
	case SceneConf#scene_conf.type =/= ?SCENE_TYPE_INSTANCE of
		true ->
			F = fun(BuffId, _Buff, Acc) ->
				BuffConf = buff_config:get(BuffId),
				case BuffConf#buff_conf.effect_id of
					?BUFF_EFFECT_EXP ->
						Acc + BuffConf#buff_conf.rule;
					_ ->
						Acc
				end
			end,
			Multiple = dict:fold(F, ?PERCENT_BASE, PlayerState#player_state.buff_dict),

			case PlayerState#player_state.is_double_exp > 0 of
				true ->
					case Multiple of
						?PERCENT_BASE ->
							2 * Exp;
						_ ->
							util_math:floor(Exp * (Multiple + 2 * ?PERCENT_BASE) / ?PERCENT_BASE)
					end;
				false ->
					util_math:floor(Exp * Multiple / ?PERCENT_BASE)
			end;
		false ->
			Exp
	end.

%% 每晚24点刷新功能
refuse_function_by_24hours(PlayerState, CurTime) ->
	case PlayerState#player_state.refuse_function_time of
		RefuseTime when is_integer(RefuseTime) ->
			case CurTime >= RefuseTime of
				true ->
					%% 刷新红点提示
					{ok, PlayerState1} = button_tips_lib:ref_button_tips(PlayerState, button_tips_config:get_list()),
					PlayerState1#player_state{refuse_function_time = RefuseTime + ?DAY_TIME_COUNT};
				false ->
					PlayerState
			end;
		_ ->
			PlayerState#player_state{refuse_function_time = util_date:get_today_unixtime() + ?DAY_TIME_COUNT}
	end.

%% 新手模式检测
check_pk_mode(PlayerState5, OldLv, NewLv) ->
	case OldLv < 36 andalso NewLv >= 36 of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{pk_mode = ?PK_MODE_PEACE, set_pk_mode = ?PK_MODE_PEACE}
			},
			update_player_state(PlayerState5, Update);
		false ->
			{ok, PlayerState5}
	end.

%% 背包扩充检测
check_bag(PlayerState, NewLv) ->
	DbPlayerState = PlayerState#player_state.db_player_base,
	PlayerBag = DbPlayerState#db_player_base.bag,
	NewCellConf = cell_config:get(NewLv),
	NewCell = NewCellConf#cell_conf.cell,
	case PlayerBag =/= NewCell of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{bag = max(PlayerBag, NewCell)}
			},
			update_player_state(PlayerState, Update);
		false ->
			{ok, PlayerState}
	end.

%% *******************************************************
%% 信息
%% *******************************************************
login(ClientState, Data) ->
	#req_enter{
		player_id = PlayerId,
		os_type = OsType,
		open_id = OpenId,
		platform = Platform
	} = Data,
	#tcp_client_state{
		socket = Socket
	} = ClientState,
	case player_id_name_lib:checklogin(OpenId, Socket) of
		false ->
			{fail, ?ERR_SERVER_STOP};
		_ ->
			IsRobot = robot_cross:is_robot_open_id(OpenId, Platform),
			%% 如果tcp_client_state里面保存的open_id是空的话说明是快速登陆、没有跑正常的登陆流程
			case get_player_list_data(OpenId, Platform) of
				[] ->
					{fail, ?ERR_PLAYER_NOT};
				List ->
					case lists:keyfind(PlayerId, #db_account.player_id, List) of
%% 						#proto_login_info{} = _ ->
						#db_account{} ->
							case player_base_cache:select_row(PlayerId) of
								null ->
									{fail, ?ERR_PLAYER_NOT};
								BaseInfo ->
									case BaseInfo#db_player_base.limit_login > util_date:unixtime() of
										true -> 							%% 判断是否被封号了
											{fail, ?ERR_LIMIT_LOGIN_PLAYER};
										_ ->
											account_lib:login(OpenId, Platform, self(), ClientState#tcp_client_state.socket),
											case account_lib:enter_game(BaseInfo, OpenId, Platform, Socket, PlayerId, OsType, IsRobot) of
												{ok, Pid} ->
													NewClientState = ClientState#tcp_client_state{
														player_id = PlayerId,
														player_pid = Pid,
														open_id = OpenId,
														platform = Platform
													},
													#db_player_base{name = Name, register_time = RegisterTime, vip = Vip, lv = Lv, scene_id = SceneId} = BaseInfo,
													player_id_name_lib:add_server_user(PlayerId, OpenId, Name, RegisterTime, Vip),
													active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_LOGION, PlayerId, Lv, 1),
													robot_cross:exe_robot(login, [OpenId, PlayerId, SceneId, IsRobot]),
													{ok, NewClientState};
												{fail, Err} ->
													{fail, Err}
											end
									end
							end;
						_ ->
							{fail, ?ERR_PLAYER_NOT}
					end
			end
	end.

is_refuse_attr_by_buff([], IsUpdateAttr) ->
	IsUpdateAttr;
is_refuse_attr_by_buff([BuffId | T], IsUpdateAttr) ->
	Conf = buff_config:get(BuffId),
	case Conf#buff_conf.effect_id of
		?BUFF_EFFECT_ATTR_PLUS ->
			true;
		_ ->
			is_refuse_attr_by_buff(T, IsUpdateAttr)
	end.

%% 获取玩家身上的属性加成buff
get_buff_attr_plus(PlayerState) ->
	BuffDict = PlayerState#player_state.buff_dict,
	EffectDict = PlayerState#player_state.effect_dict,
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_ATTR_PLUS),
	BuffEffect#buff_effect.attr_change.


get_true_server_id(ClientServerId) ->
	case config:get_merge_servers() of
		[] -> config:get_server_no();
		MergeServers ->
			case lists:member(ClientServerId, MergeServers) of
				true -> ClientServerId;
				false -> config:get_server_no()
			end
	end.

%% update player double exp
update_double_exp(PlayerState) ->
%% 	io:format("update double_exp 1:~p~n", [util_date:longunixtime()]),
	NewPlayerState = operate_active_lib:init_double_exp_state(PlayerState),
%% 	io:format("update double_exp 1-2:~p~n", [util_date:longunixtime()]),

	NewPlayerState1 = active_service_merge_lib:check_double_exp(NewPlayerState),
%% 	io:format("update double_exp 1-3:~p~n", [util_date:longunixtime()]),

	NewPlayerState2 = active_instance_lib:check_double_exp(NewPlayerState1),
%% 	io:format("update double_exp 1-4:~p~n", [util_date:longunixtime()]),

%% 	NewPlayerState3 = buff_base_lib:check_double_exp(NewPlayerState2),
	#player_state{is_double_exp = OldIsDouble} = PlayerState,
	#player_state{is_double_exp = NewIsDouble} = NewPlayerState2,
%% 	io:format("update double_exp 1-5:~p~n", [{OldIsDouble, NewIsDouble}]),

	util_erl:get_if(OldIsDouble == NewIsDouble, next, buff_base_lib:send_buff_info(NewPlayerState2)),
%% 	io:format("update double_exp 2:~p~n", [util_date:longunixtime()]),
	{ok, NewPlayerState2}.


