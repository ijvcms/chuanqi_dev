%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 七月 2015 18:02
%%%-------------------------------------------------------------------
-module(cache_mod).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {}).

start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, State}
	| {ok, State, Timeout}
	| {ok, State, hibernate}
	| {stop, Reason :: term()}
	| ignore,
	State :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([]) ->
	process_flag(trap_exit, true),
	init_data(),
	{ok, #state{}}.


%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
-spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
	Result :: {reply, Reply, NewState}
	| {reply, Reply, NewState, Timeout}
	| {reply, Reply, NewState, hibernate}
	| {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason, Reply, NewState}
	| {stop, Reason, NewState},
	Reply :: term(),
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity,
	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
-spec handle_cast(Request :: term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast(_Msg, State) ->
	{noreply, State}.

%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_info(_Info, State) ->
	{noreply, State}.

%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
	| shutdown
	| {shutdown, term()}
	| term().
%% ====================================================================
terminate(_Reason, _State) ->
	io:format("~p terminate~n", [?MODULE]),
	ok.

%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% ====================================================================
%% Internal functions
%% ====================================================================

init_data() ->
	init_ets(),
	mail_lib:init_mail_conf(), %% 初始化邮件配置
	guild_lib:init_guild(),    %% 初始化帮派
	arena_lib:init_arena_rank(), %% 初始化竞技场
	careertitle_lib:init_title(),
	city_lib:init(),
	active_ets:init(),%% 初始化玩家怪物击杀信息
	active_merge_ets:init(),%% 初始话合服信息
	special_drop_cache:init_special_drop(), %% 初始化掉落
	ok.

init_ets() ->
	EtsTabList = [
		{?ETS_COMMON_CONFIG, #ets_common_config.key},
		{?ETS_PLAYER_COUNTER, #ets_player_counter.key},
		{?ETS_KEYWORD_GROUP, #ets_keyword_group.group},
		{?ETS_MAIL_CONF, #ets_mail_conf.id},
		{?ETS_PLAYER_MAIL, #ets_player_mail.key},
		{?ETS_RELATIONSHIP, #ets_relationship.player_id},
		{?ETS_GUILD_LIST, #ets_guild_list.guild_id},
		{?ETS_GUILD_MOD, #ets_guild_mod.key},
		{?ETS_GUILD, #db_guild.guild_id},
		{?ETS_PLAYER_GEM_LIST, #ets_player_gem_list.player_id},
		{?ETS_ARENA_RANK, #db_arena_rank.player_id},
		{?ETS_ARENA_RECORD, #db_arena_record.player_id},
		{?ETS_ARENA_SHOP, #db_arena_shop.id},
		{?ETS_TRANSACTION, #ets_transaction.player_idA},
		{?ETS_TITLE_CAREET, #ets_title_careet.career},
		{?ETS_TEAM, #ets_team.team_id},
		{?ETS_PLAYER_ID_NAME, #ets_player_id_name.player_id},
		{?ETS_PLAYER_NAME_ID, #ets_player_id_name.name},
		{?ETS_SCENE_CITY, #ets_scene_city.scene_id},
		{?ETS_ACTIVITY_SHACHENG, #ets_activity_shacheng.id},
		{?ETS_WANDER_SHOP_LIST, #ets_wander_shop_list.type},
		{?ETS_PlAYER_TEAM, #ets_player_team.player_id},
		{?ETS_ACTIVE_SERVICE_MONTHER, #db_player_monster.monster_id},
		{?ETS_ACTIVE_SERVICE_MONTHER_MERGE, #db_player_monster_merge.monster_id},
		{?ETS_ACTIVE_REMIND, #ets_active_remind.key},
		{?ETS_CHAT, #ets_chat.chat_sort},
		{?ETS_SPECIAL_DROP, #db_special_drop.drop_type},
		{?ETS_PLAYER_KILL, #ets_player_kill.key},
		{?ETS_FOE, #ets_foe.player_id},
		{?ETS_BUTTON_UPDATE_TIME, #ets_button_update_time.key},
		{?ETS_AREA_ID_LIST, #ets_area_id_list.x_y_witgh_high},
		{?ETS_SBK_BOX, #ets_sbk_box.key},
		{?ETS_HJZC, #ets_hjzc.key}
	],
	[ets:new(Tab, [{keypos, Key}, named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]) || {Tab, Key} <- EtsTabList],
	ok.


