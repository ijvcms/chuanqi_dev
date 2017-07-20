%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2015 上午11:10
%%%-------------------------------------------------------------------
-module(db_cache_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% API
-export([
	init/0,
	select_row/2,
	select_all/1,
	select_all/2,
	insert/3,
	update/3,
	replace/3,
	delete/2,
	check_effective/0,
	save_to_db/0,
	remove_cache/2,
	remove_all_cache/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
init() ->
	ets:new(?CACHE_EFFECTIVE, [{keypos, #cache_effective.tab_key}, named_table, public, set,
		{read_concurrency, true}, {write_concurrency, true}]),
	ets:new(?CACHE_OPERATE, [{keypos, #cache_operate.tab_key}, named_table, public, set,
		{read_concurrency, true}, {write_concurrency, true}]),
	[ets:new(TabName, [{keypos, #ets_cache.key}, named_table, public, set,
		{read_concurrency, true}, {write_concurrency, true}]) || TabName <- db_cache_config:get_list()].

select_row(Tab, Key) ->
	try
		ConfCache = db_cache_config:get(Tab),
		case ets:lookup(Tab, Key) of
			[EtsCache] ->
				case ets:lookup(?CACHE_EFFECTIVE, {Tab, Key}) of
					#cache_effective{} = CacheEffective ->
						NewTime = CacheEffective#cache_effective.effective_time + ConfCache#conf_cache.hit_add_time,
						ets:update_element(?CACHE_EFFECTIVE, {Tab, Key}, {#cache_effective.effective_time, NewTime});
					_ ->
						CacheEffective = #cache_effective{
							tab_key = {Tab, Key},
							effective_time = util_date:unixtime() + ConfCache#conf_cache.init_time
						},
						ets:insert(?CACHE_EFFECTIVE, CacheEffective)
				end,
				EtsCache#ets_cache.info;
			_ ->
				Agent = ConfCache#conf_cache.db_agent,
				case Agent:select_row(Key) of
					Info when is_tuple(Info) ->
						ets:insert(Tab, #ets_cache{key = Key, info = Info}),
						CacheEffective = #cache_effective{
							tab_key = {Tab, Key},
							effective_time = util_date:unixtime() + ConfCache#conf_cache.init_time
						},
						ets:insert(?CACHE_EFFECTIVE, CacheEffective),
						Info;
					_ ->
						null
				end
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			null
	end.

%% 获取数据表里面的所有数据
select_all(Tab) ->
	try
		ConfCache = db_cache_config:get(Tab),
		Agent = ConfCache#conf_cache.db_agent,
		case Agent:select_all() of
			[] ->
				List = ets:tab2list(Tab),
				[Info#ets_cache.info || Info <- List];
			List1 ->
				CurTime = util_date:unixtime(),
				[begin
					 Key1 = make_key(ConfCache#conf_cache.key, Info),
					 case ets:lookup(Tab, Key1) of
						 [EtsCache] ->
							 EtsCache#ets_cache.info;
						 _ ->
							 ets:insert(Tab, #ets_cache{key = Key1, info = Info}),
							 CacheEffective = #cache_effective{
								 tab_key = {Tab, Key1},
								 effective_time = CurTime + ConfCache#conf_cache.init_time
							 },
							 ets:insert(?CACHE_EFFECTIVE, CacheEffective),
							 Info
					 end
				 end || Info <- List1],
				List2 = ets:tab2list(Tab),
				[Info#ets_cache.info || Info <- List2]
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			[]
	end.

%% key格式使用ets:match_object的key模式
select_all(Tab, Key) ->
	try
		ConfCache = db_cache_config:get(Tab),
		Agent = ConfCache#conf_cache.db_agent,
		case Agent:select_all(Key) of
			[] ->
				List = ets:match_object(Tab, #ets_cache{key = Key, _ = '_'}),
				[Info#ets_cache.info || Info <- List];
			List1 ->
				CurTime = util_date:unixtime(),
				[begin
					 Key1 = make_key(ConfCache#conf_cache.key, Info),
					 case ets:lookup(Tab, Key1) of
						 [EtsCache] ->
							 EtsCache#ets_cache.info;
						 _ ->
							 ets:insert(Tab, #ets_cache{key = Key1, info = Info}),
							 CacheEffective = #cache_effective{
								 tab_key = {Tab, Key1},
								 effective_time = CurTime + ConfCache#conf_cache.init_time
							 },
							 ets:insert(?CACHE_EFFECTIVE, CacheEffective),
							 Info
					 end
				 end || Info <- List1],
				List2 = ets:match_object(Tab, #ets_cache{key = Key, _ = '_'}),
				[Info#ets_cache.info || Info <- List2]
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			[]
	end.

insert(Tab, Key, Info) ->
	try
		case ets:lookup(Tab, Key) of
			[_EtsCache] ->
				?ERR("error insert cache, tab: ~p,  key : ~p, info: ~p", [Tab, Key, Info]),
				{fail, 1};
			_ ->
				insert_1(Tab, Key, Info)
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			{fail, 1}
	end.
insert_1(Tab, Key, Info) ->
	ConfCache = db_cache_config:get(Tab),
	Agent = ConfCache#conf_cache.db_agent,
	case Agent:select_row(Key) of
		_Info1 when is_tuple(_Info1) ->
			?ERR("error insert cache, tab: ~p,  key : ~p, info: ~p", [Tab, Key, Info]),
			{fail, 1};
		_ ->
			ets:insert(Tab, #ets_cache{key = Key, info = Info}),

			CacheEffective = #cache_effective{
				tab_key = {Tab, Key},
				effective_time = util_date:unixtime() + ConfCache#conf_cache.init_time
			},
			ets:insert(?CACHE_EFFECTIVE, CacheEffective),

			CacheOperate = #cache_operate{
				tab_key = {Tab, Key},
				operate = ?DB_OPERATE_INSERT
			},
			ets:insert(?CACHE_OPERATE, CacheOperate),
			{ok, Info}
	end.

update(Tab, Key, UpdateInfo) ->
	try
		case select_row(Tab, Key) of
			Info when is_tuple(Info) ->
				update_1(Tab, Key, Info, UpdateInfo);
			_ ->
				?ERR("error update cache, tab: ~p, key: ~p, upate info: ~p",
					[Tab, Key, UpdateInfo]),
				{fail, 1}
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			{fail, 1}
	end.
update_1(Tab, Key, Info, UpdateInfo) ->
	case ets:lookup(?CACHE_OPERATE, {Tab, Key}) of
		[CacheOperate] ->
			OldOperate = CacheOperate#cache_operate.operate,
			CurOperate = ?DB_OPERATE_UPDATE,
			case get_new_db_operate(OldOperate, CurOperate) of
				NewOperate when is_integer(NewOperate) ->
					ets:update_element(?CACHE_OPERATE, {Tab, Key}, {#cache_operate.operate, NewOperate}),
					NewInfo = util_tuple:copy_elements(Info, UpdateInfo),
					ets:update_element(Tab, Key, {#ets_cache.info, NewInfo}),
					{ok, NewInfo};
				_ ->
					?ERR("error update cache, tab: ~p, key: ~p, upate info: ~p, old operate: ~p, cur operate: ~p",
						[Tab, Key, UpdateInfo, OldOperate, CurOperate]),
					{fail, 1}
			end;
		_ ->
			CacheOperate = #cache_operate{
				tab_key = {Tab, Key},
				operate = ?DB_OPERATE_UPDATE
			},
			ets:insert(?CACHE_OPERATE, CacheOperate),
			NewInfo = util_tuple:copy_elements(Info, UpdateInfo),
			ets:update_element(Tab, Key, {#ets_cache.info, NewInfo}),
			{ok, NewInfo}
	end.

replace(Tab, Key, Info) ->
	try
		case select_row(Tab, Key) of
			OldInfo when is_tuple(OldInfo) ->
				update_1(Tab, Key, OldInfo, Info);
			_ ->
				insert_1(Tab, Key, Info)
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			{fail, 1}
	end.

delete(Tab, Key) ->
	try
		case select_row(Tab, Key) of
			Info when is_tuple(Info) ->
				ets:delete(Tab, Key),
				ets:delete(?CACHE_EFFECTIVE, {Tab, Key}),
				ets:delete(?CACHE_OPERATE, {Tab, Key}),
				ConfCache = db_cache_config:get(Tab),
				Agent = ConfCache#conf_cache.db_agent,
				Agent:delete(Key),
				ok;
			_ ->
				ok
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			skip
	end.

remove_cache(Tab, Key) ->
	try
		case ets:lookup(?CACHE_EFFECTIVE, {Tab, Key}) of
			[CacheEffective] ->
				remove_cache(CacheEffective);
			_ ->
				skip
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			skip
	end.
remove_cache(CacheEffective) ->
	{Tab, Key} = CacheEffective#cache_effective.tab_key,
	case ets:lookup(?CACHE_OPERATE, {Tab, Key}) of
		[CacheOperate] ->
			save_to_db(CacheOperate);
		_ ->
			skip
	end,
	ets:delete(?CACHE_EFFECTIVE, {Tab, Key}),
	ets:delete(Tab, Key).

remove_all_cache(Tab, Key) ->
	try
		case ets:match_object(Tab, #ets_cache{key = Key, _ = '_'}) of
			[] ->
				skip;
			List ->
				[remove_cache(Tab, Info#ets_cache.key) || Info <- List]
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			skip
	end.

check_effective() ->
	try
		case ets:tab2list(?CACHE_EFFECTIVE) of
			[] ->
				skip;
			List ->
				[check_effective(CacheEffective) || CacheEffective <- List]
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			skip
	end.
check_effective(CacheEffective) ->
	#cache_effective{
		tab_key = TabKey
	} = CacheEffective,
	%% 必须得检查多一次，因为有多个进程在使用ets表，确保确保取出来的是最新值
	case ets:lookup(?CACHE_EFFECTIVE, TabKey) of
		[CacheEffective1] ->
			CurTime = util_date:unixtime(),
			case CacheEffective1#cache_effective.effective_time < CurTime of
				true ->
					remove_cache(CacheEffective1);
				_ ->
					skip
			end;
		_ ->
			skip
	end.

save_to_db() ->
	try
		case ets:tab2list(?CACHE_OPERATE) of
			[] ->
				skip;
			List ->
				[save_to_db(CacheOperate) || CacheOperate <- List]
		end
	catch
		_Err:_Info ->
			?ERR("~p:~p~n~p", [_Err, _Info, erlang:get_stacktrace()]),
			skip
	end.
save_to_db(CacheOperate) ->
	{Tab, Key} = CacheOperate#cache_operate.tab_key,
	%% 必须得检查多一次，因为有多个进程在使用ets表，确保确保取出来的是最新值
	case ets:lookup(?CACHE_OPERATE, {Tab, Key}) of
		[CacheOperate1] ->
			ConfCache = db_cache_config:get(Tab),
			Agent = ConfCache#conf_cache.db_agent,
			save_operate(CacheOperate1#cache_operate.operate, Agent, Tab, Key),
			ets:delete(?CACHE_OPERATE, CacheOperate1#cache_operate.tab_key);
		_ ->
			skip
	end.

save_operate(?DB_OPERATE_INSERT, Agent, Tab, Key) ->
	case ets:lookup(Tab, Key) of
		[EtsCache] ->
			Agent:insert(EtsCache#ets_cache.info);
		_ ->
			?ERR("insert db error, not cache, tab: ~p, key: ~p ", [Tab, Key]),
			{fail, 1}
	end;
save_operate(?DB_OPERATE_UPDATE, Agent, Tab, Key) ->
	case ets:lookup(Tab, Key) of
		[EtsCache] ->
			Agent:update(Key, EtsCache#ets_cache.info);
		_ ->
			?ERR("update db error, not cache, tab: ~p, key: ~p ", [Tab, Key]),
			{fail, 1}
	end;
save_operate(?DB_OPERATE_DELETE, Agent, _Tab, Key) ->
	Agent:delete(Key).

%% ====================================================================
%% Internal functions
%% ====================================================================
get_new_db_operate(?DB_OPERATE_INSERT, ?DB_OPERATE_DELETE) -> del_cache;
get_new_db_operate(?DB_OPERATE_INSERT, ?DB_OPERATE_UPDATE) -> ?DB_OPERATE_INSERT;

get_new_db_operate(?DB_OPERATE_DELETE, ?DB_OPERATE_INSERT) -> ?DB_OPERATE_INSERT;

get_new_db_operate(?DB_OPERATE_UPDATE, ?DB_OPERATE_DELETE) -> ?DB_OPERATE_DELETE;
get_new_db_operate(?DB_OPERATE_UPDATE, ?DB_OPERATE_UPDATE) -> ?DB_OPERATE_UPDATE;
get_new_db_operate(_OldOperate, _CurOperate) -> skip.

make_key(KeyRule, Info) when is_integer(KeyRule) ->
	element(KeyRule, Info);
make_key(KeyRule, Info) when is_tuple(KeyRule) ->
	KeyList = util_data:to_list(KeyRule),
	list_to_tuple([element(Key, Info) || Key <- KeyList]).

