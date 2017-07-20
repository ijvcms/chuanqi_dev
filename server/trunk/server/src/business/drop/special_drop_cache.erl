%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 四月 2016 11:16
%%%-------------------------------------------------------------------
-module(special_drop_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").

%% API
-export([
	select_all/0,
	select_row/1,
	replace/1,
	remove_cache/1,
	init_special_drop/0,
	get_no_drop_type_list/0,
	update_drop_type_info/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all() ->
	db_cache_lib:select_all(?DB_SPECIAL_DROP).

select_row(DropType) ->
	db_cache_lib:select_row(?DB_SPECIAL_DROP, DropType).

replace(Info) ->
	DropType = Info#db_special_drop.drop_type,
	db_cache_lib:replace(?DB_SPECIAL_DROP, DropType, Info).

remove_cache(DropType) ->
	db_cache_lib:remove_cache(?DB_SPECIAL_DROP, DropType).

%% ====================================================================

%% 初始化ets
init_special_drop() ->
	case select_all() of
		[] ->
			[];
		List ->
			Fun = fun(DbSpecialDrop) ->
					ets:insert(?ETS_SPECIAL_DROP, DbSpecialDrop)
				  end,
			[Fun(X) || X <- List]
	end.

%% 获取不可掉落的类型列表
get_no_drop_type_list() ->
	case ets:tab2list(?ETS_SPECIAL_DROP) of
		[] ->
			[];
		List ->
			NowTime = util_date:unixtime(),
			Fun = fun(DbInfo) ->
				Type = DbInfo#db_special_drop.drop_type,
				case special_drop_type_config:get(Type) of
					#special_drop_type_conf{} = SDTConf ->
						NowTime < DbInfo#db_special_drop.next_time andalso
						SDTConf#special_drop_type_conf.drop_limit =< DbInfo#db_special_drop.drop_num;
					_ ->
						false
				end
			end,
			[X#db_special_drop.drop_type || X <- List, Fun(X)]
	end.

%% 更新掉落类型数据
update_drop_type_info(GoodsId, Num, Type) ->
	case special_drop_config:get({GoodsId, Type}) of
		#special_drop_conf{} = SpecDropConf ->
			DropType = SpecDropConf#special_drop_conf.drop_type,
			case ets:lookup(?ETS_SPECIAL_DROP, DropType) of
				[Info|_] ->
					NowTime = util_date:unixtime(),
					case NowTime >= Info#db_special_drop.next_time of
						true ->
							case special_drop_type_config:get(Type) of
								#special_drop_type_conf{} = SDTConf ->
									DropCycle = SDTConf#special_drop_type_conf.drop_cycle,
									Unit = get_period_unit(SDTConf#special_drop_type_conf.drop_unit),
									Info1 = Info#db_special_drop
									{
										drop_num = Num, %% 掉落数量
										update_time = NowTime,
										next_time = NowTime + DropCycle * Unit
									},
									ets:insert(?ETS_SPECIAL_DROP, Info1),
									replace(Info1);
								_ ->
									skip
							end;
						false ->
							NewDropNum = Info#db_special_drop.drop_num + Num,
							Info1 = Info#db_special_drop
							{
								drop_num = NewDropNum, %% 掉落数量
								update_time = util_date:unixtime()
							},
							ets:insert(?ETS_SPECIAL_DROP, Info1),
							replace(Info1)
					end;
				_ ->
					case special_drop_type_config:get(Type) of
						#special_drop_type_conf{} = SDTConf ->
							DropCycle = SDTConf#special_drop_type_conf.drop_cycle,
							Unit = get_period_unit(SDTConf#special_drop_type_conf.drop_unit),
							NowTime = util_date:unixtime(),
							NextTime = NowTime + DropCycle * Unit,
							Info = #db_special_drop
							{
								drop_type = DropType, %% 掉落类型
								drop_num = Num, %% 掉落数量
								next_time = NextTime, %% 下次掉落刷新时间
								update_time = NowTime %% 更新时间
							},
							ets:insert(?ETS_SPECIAL_DROP, Info),
							replace(Info);
						_ ->
							skip
					end
			end;
		_ ->
			skip
	end.

get_period_unit(<<"day">>) -> 86400;
get_period_unit(<<"hour">>) -> 3600;
get_period_unit(_Other) -> 86400.