%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 运营活动基础函数
%%%
%%% @end
%%% Created : 06. 七月 2016 16:22
%%%-------------------------------------------------------------------
-module(operate_active_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("proto_back.hrl").
-include("rank.hrl").

%% API
-export([
	init_conf/0,
	update_operate_active_conf/1,
	update_operate_sub_type_conf/1,
	check_conf/0,
	reload_conf/0,
	init_double_exp_state/1,
	get_start_active_list/0,
	get_start_holiday_active_list/0,
	get_holiday_loot_active_id/0,
	get_player_operate_active_info/1,
	get_player_holiday_active_info/1,
	receive_reward/2,
	receive_reward/3,
	update_limit_type/2,
	update_limit_type/3,
	update_instance_enter_count/2,
	get_operate_sub_type_conf_list/1,
	kill_monster/2,
	get_operate_active_conf/1,
	get_holiday_drop/2,
	send_kill_active_mail/1
]).

-define(STATE_NOT_ENOUGH, 0). %% 未达到条件
-define(STATE_ENOUGH, 1). %% 达到条件可领取
-define(STATE_HAVEBEEN, 2). %% 已领取

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% 初始运营活动配置
init_conf() ->
	try
%% 		EtsInfo = #ets_operate_active_conf{
%% 			active_id = 2040,  %% 活动编号
%% 			type = 4,
%% 			start_time = util_date:unixtime() - 1, %% 开始时间
%% 			end_time = util_date:unixtime() + 123600 %% 结束时间
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo),
%%
%%
%% 		EtsInfo1 = #ets_operate_active_conf{
%% 			active_id = 2041,  %% 活动编号
%% 			type = 5,
%% 			start_time = util_date:unixtime() - 1, %% 开始时间
%% 			end_time = util_date:unixtime() + 123600, %% 结束时间
%% 			finish_type = 1
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo1),
%%
%%
%% 		EtsInfo2 = #ets_operate_active_conf{
%% 			active_id = 2050,  %% 活动编号
%% 			type = 3,
%% 			order_id = 1,  %% 排序
%% 			model = 1, %% 模版 0默认 1累计充值消费  2限时购买
%% 			mark = 0, %% 活动标签0无 1限时 2火爆 3推荐
%% 			title = xmerl_ucs:to_utf8("累计消费"), %% 活动标题
%% 			content = xmerl_ucs:to_utf8("累计消费"), %% 活动内容
%% 			finish_type = 2,
%% 			start_time = util_date:unixtime() - 1, %% 开始时间,
%% 			end_time = util_date:unixtime() + 123600 %% 结束时间
%% 		},
%% 		EtsSubInfo2 = #ets_operate_sub_type_conf{
%% 			key = {2050, 1}, %% {active_id, active_type}
%% 			active_id = 2050,  %% 活动编号
%% 			sub_type = 1, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("累计消费100"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = 0, %% 原始价格
%% 			finish_limit = [{5, 100}], %% 完成条件,
%% 			finish_consume = [], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo2),
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo2),
%%
%% 		EtsSubInfo22 = #ets_operate_sub_type_conf{
%% 			key = {2050, 2}, %% {active_id, active_type}
%% 			active_id = 2050,  %% 活动编号
%% 			sub_type = 2, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("累计消费100"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = 0, %% 原始价格
%% 			finish_limit = [{5, 100}], %% 完成条件,
%% 			finish_consume = [], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo22),
%%
%% 		EtsSubInfo222 = #ets_operate_sub_type_conf{
%% 			key = {2050, 3}, %% {active_id, active_type}
%% 			active_id = 2050,  %% 活动编号
%% 			sub_type = 3, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("累计消费100"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = 0, %% 原始价格
%% 			finish_limit = [{5, 100}], %% 完成条件,
%% 			finish_consume = [], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo222),
%%
%% 		EtsInfo3 = #ets_operate_active_conf{
%% 			active_id = 2052,  %% 活动编号
%% 			type = 3,
%% 			order_id = 2,  %% 排序
%% 			model = 2, %% 模版 0默认 1累计充值消费  2限时购买
%% 			mark = 0, %% 活动标签0无 1限时 2火爆 3推荐
%% 			finish_type = 2,
%% 			title = xmerl_ucs:to_utf8("限时购买"), %% 活动标题
%% 			content = xmerl_ucs:to_utf8("限时购买"), %% 活动内容
%% 			start_time = util_date:unixtime() - 1, %% 开始时间
%% 			end_time = util_date:unixtime() + 123600 %% 结束时间
%% 		},
%% 		EtsSubInfo3 = #ets_operate_sub_type_conf{
%% 			key = {2052, 1}, %% {active_id, active_type}
%% 			active_id = 2052,  %% 活动编号
%% 			sub_type = 1, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("限时购买"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = [{110008, 2000}], %% 原始价格
%% 			finish_limit = [], %% 完成条件,
%% 			finish_consume = [{110008, 1000}], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo3),
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo3),
%%
%% 		EtsSubInfo33 = #ets_operate_sub_type_conf{
%% 			key = {2052, 2}, %% {active_id, active_type}
%% 			active_id = 2052,  %% 活动编号
%% 			sub_type = 2, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("限时购买"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = [{110008, 2000}], %% 原始价格
%% 			finish_limit = [], %% 完成条件,
%% 			finish_consume = [{110008, 1000}], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo33),
%%
%% 		EtsSubInfo333 = #ets_operate_sub_type_conf{
%% 			key = {2052, 3}, %% {active_id, active_type}
%% 			active_id = 2052,  %% 活动编号
%% 			sub_type = 3, %% 活动子类
%% 			content = xmerl_ucs:to_utf8("限时购买"), %% 活动标题, %% 内容
%% 			limit_count = 1, %% 限制次数
%% 			original_price = [{110008, 2000}], %% 原始价格
%% 			finish_limit = [], %% 完成条件,
%% 			finish_consume = [{110008, 1000}], %% 完成消耗扣除
%% 			finish_reward = [{202081, 0, 1}] %% 完成奖励
%% 		},
%% 		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsSubInfo333),
%%
%% 		EtsInfo4 = #ets_operate_active_conf{
%% 			active_id = 2055,  %% 活动编号
%% 			type = 3,
%% 			order_id = 3,  %% 排序
%% 			model = 0, %% 模版 0默认 1累计充值消费  2限时购买
%% 			mark = 0, %% 活动标签0无 1限时 2火爆 3推荐
%% 			finish_type = 2,
%% 			show_reward = [{202081, 0, 1}], %% 奖励展示
%% 			is_button = 1, %% 是否有领取按钮 0没有 1有
%% 			button_content = xmerl_ucs:to_utf8("fuck"),
%% 			is_window = 1,
%% 			window_content = xmerl_ucs:to_utf8("look"),
%% 			title = xmerl_ucs:to_utf8("主宰道链"), %% 活动标题
%% 			content = xmerl_ucs:to_utf8("主宰道链"), %% 活动内容
%% 			start_time = util_date:unixtime() - 1, %% 开始时间
%% 			end_time = util_date:unixtime() + 123600 %% 结束时间
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo4),
%%
%% 		EtsInfo5 = #ets_operate_active_conf{
%% 			active_id = 2056,  %% 活动编号
%% 			type = 1,
%% 			order_id = 4,  %% 排序
%% 			model = 3, %% 模版 0默认 1累计充值消费  2限时购买
%% 			mark = 0, %% 活动标签0无 1限时 2火爆 3推荐
%% 			finish_type = 2,
%% 			show_reward = [], %% 奖励展示
%% 			is_button = 0, %% 是否有领取按钮 0没有 1有
%% 			button_content = xmerl_ucs:to_utf8("fuck"),
%% 			is_window = 0,
%% 			window_content = xmerl_ucs:to_utf8("look"),
%% 			title = xmerl_ucs:to_utf8("主宰道链"), %% 活动标题
%% 			content = xmerl_ucs:to_utf8("主宰道链2222222222222222222222222222"), %% 活动内容
%% 			start_time = util_date:unixtime() - 1, %% 开始时间
%% 			end_time = util_date:unixtime() + 123600 %% 结束时间
%% 		},
%% 		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo5),

		init_operate_active_conf(),
		init_operate_sub_type_conf(),
		{OpenList, HolidayList, LimitList, State} = check_conf(),
		ets:insert(?ETS_OPEN_OPERATE_LIST, #ets_open_operate_list{key = ?ALL_SERVER_SIGN, active_list = OpenList, holiday_list = HolidayList, limit_list = LimitList}),
		ets:insert(?ETS_DOUBLE_EXP, #ets_double_exp{key = ?ALL_SERVER_SIGN, state = State}),
		?TRACE("operate is started"),
		{OpenList, HolidayList, LimitList, State}
	catch
		_ : _Erro ->
			?TRACE("operate is closed"),
			{[], [], [], 0}
	end.


init_operate_active_conf() ->
	%% 数据库加载
	case config:get_operate_active_conf_html() of
		List when length(List) > 0 ->
			%% 初始化筛选出开启的活动与双倍活动状态
			Fun = fun(Ets) ->
				EtsInfo = #ets_operate_active_conf{
					active_id = Ets#back_req_ref_operate_active_conf.active_id,  %% 活动编号
					order_id = Ets#back_req_ref_operate_active_conf.order_id,  %% 排序
					type = Ets#back_req_ref_operate_active_conf.type, %% 活动类型1文字公告类型 2双倍文字公告类 3配置条件类
					model = Ets#back_req_ref_operate_active_conf.model,
					mark = Ets#back_req_ref_operate_active_conf.mark, %% 活动标签0无 1限时 2火爆 3推荐
					title = Ets#back_req_ref_operate_active_conf.title, %% 活动标题
					content = Ets#back_req_ref_operate_active_conf.content, %% 活动内容
					show_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_active_conf.show_reward), %% 奖励展示
					is_button = Ets#back_req_ref_operate_active_conf.is_button, %% 是否有领取按钮 0没有 1有
					button_content = Ets#back_req_ref_operate_active_conf.button_content,
					is_window = Ets#back_req_ref_operate_active_conf.is_window,
					is_count_down = Ets#back_req_ref_operate_active_conf.is_count_down,
					window_content = Ets#back_req_ref_operate_active_conf.window_content,
					start_time = Ets#back_req_ref_operate_active_conf.start_time, %% 开始时间
					end_time = Ets#back_req_ref_operate_active_conf.end_time, %% 结束时间
					finish_type = Ets#back_req_ref_operate_active_conf.finish_type, %% 完成类型1 1活动期间内每天 2活动期间
					finish_count = Ets#back_req_ref_operate_active_conf.finish_count, %% 可完成次数1
					update_time = Ets#back_req_ref_operate_active_conf.update_time %% 更新时间
				},
				ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo)
			end,
			[Fun(X) || X <- List];
		_ ->
			skip
	end.

update_operate_active_conf(List) when is_list(List) ->
	Fun = fun(Ets) ->
		EtsInfo = #ets_operate_active_conf{
			active_id = Ets#back_req_ref_operate_active_conf.active_id,  %% 活动编号
			order_id = Ets#back_req_ref_operate_active_conf.order_id,  %% 排序
			type = Ets#back_req_ref_operate_active_conf.type, %% 活动类型1文字公告类型 2双倍文字公告类 3配置条件类
			model = Ets#back_req_ref_operate_active_conf.model,
			mark = Ets#back_req_ref_operate_active_conf.mark, %% 活动标签0无 1限时 2火爆 3推荐
			title = Ets#back_req_ref_operate_active_conf.title, %% 活动标题
			content = Ets#back_req_ref_operate_active_conf.content, %% 活动内容
			show_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_active_conf.show_reward), %% 奖励展示
			is_button = Ets#back_req_ref_operate_active_conf.is_button, %% 是否有领取按钮 0没有 1有
			button_content = Ets#back_req_ref_operate_active_conf.button_content,
			is_window = Ets#back_req_ref_operate_active_conf.is_window,
			is_count_down = Ets#back_req_ref_operate_active_conf.is_count_down,
			window_content = Ets#back_req_ref_operate_active_conf.window_content,
			start_time = Ets#back_req_ref_operate_active_conf.start_time, %% 开始时间
			end_time = Ets#back_req_ref_operate_active_conf.end_time, %% 结束时间
			finish_type = Ets#back_req_ref_operate_active_conf.finish_type, %% 完成类型1 1活动期间内每天 2活动期间
			finish_count = Ets#back_req_ref_operate_active_conf.finish_count, %% 可完成次数1
			update_time = Ets#back_req_ref_operate_active_conf.update_time %% 更新时间
		},
		ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo)
	end,
	[Fun(X) || X <- List];
update_operate_active_conf(Ets) ->
	EtsInfo = #ets_operate_active_conf{
		active_id = Ets#back_req_ref_operate_active_conf.active_id,  %% 活动编号
		order_id = Ets#back_req_ref_operate_active_conf.order_id,  %% 排序
		type = Ets#back_req_ref_operate_active_conf.type, %% 活动类型1文字公告类型 2双倍文字公告类 3配置条件类
		model = Ets#back_req_ref_operate_active_conf.model,
		mark = Ets#back_req_ref_operate_active_conf.mark, %% 活动标签0无 1限时 2火爆 3推荐
		title = Ets#back_req_ref_operate_active_conf.title, %% 活动标题
		content = Ets#back_req_ref_operate_active_conf.content, %% 活动内容
		show_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_active_conf.show_reward), %% 奖励展示
		is_button = Ets#back_req_ref_operate_active_conf.is_button, %% 是否有领取按钮 0没有 1有
		button_content = Ets#back_req_ref_operate_active_conf.button_content,
		is_window = Ets#back_req_ref_operate_active_conf.is_window,
		is_count_down = Ets#back_req_ref_operate_active_conf.is_count_down,
		window_content = Ets#back_req_ref_operate_active_conf.window_content,
		start_time = Ets#back_req_ref_operate_active_conf.start_time, %% 开始时间
		end_time = Ets#back_req_ref_operate_active_conf.end_time, %% 结束时间
		finish_type = Ets#back_req_ref_operate_active_conf.finish_type, %% 完成类型1 1活动期间内每天 2活动期间
		finish_count = Ets#back_req_ref_operate_active_conf.finish_count, %% 可完成次数1
		update_time = Ets#back_req_ref_operate_active_conf.update_time %% 更新时间
	},
	ets:insert(?ETS_OPERATE_ACTIVE_CONF, EtsInfo).

init_operate_sub_type_conf() ->
	%% 数据库加载
	case config:get_operate_sub_type_conf_html() of
		List when length(List) > 0 ->
			%% 初始化筛选出开启的活动与双倍活动状态
			Fun = fun(Ets) ->
				EtsInfo = #ets_operate_sub_type_conf{
					key = {Ets#back_req_ref_operate_sub_type_conf.active_id, Ets#back_req_ref_operate_sub_type_conf.sub_type}, %% {active_id, active_type}
					active_id = Ets#back_req_ref_operate_sub_type_conf.active_id,  %% 活动编号
					sub_type = Ets#back_req_ref_operate_sub_type_conf.sub_type, %% 活动子类
					content = Ets#back_req_ref_operate_sub_type_conf.content, %% 内容
					limit_count = Ets#back_req_ref_operate_sub_type_conf.limit_count, %% 限制次数
					original_price = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.original_price), %% 原始价格
					finish_limit = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_limit), %% 完成条件,
					finish_consume = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_consume), %% 完成消耗扣除
					finish_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_reward), %% 完成奖励
					update_time = Ets#back_req_ref_operate_sub_type_conf.update_time %% 更新时间
				},
				ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsInfo)
			end,
			[Fun(X) || X <- List];
		_ ->
			skip
	end.

update_operate_sub_type_conf(List) when is_list(List) ->
	Fun = fun(Ets) ->
		EtsInfo = #ets_operate_sub_type_conf{
			key = {Ets#back_req_ref_operate_sub_type_conf.active_id, Ets#back_req_ref_operate_sub_type_conf.sub_type}, %% {active_id, active_type}
			active_id = Ets#back_req_ref_operate_sub_type_conf.active_id,  %% 活动编号
			sub_type = Ets#back_req_ref_operate_sub_type_conf.sub_type, %% 活动子类
			content = Ets#back_req_ref_operate_sub_type_conf.content, %% 内容
			limit_count = Ets#back_req_ref_operate_sub_type_conf.limit_count, %% 限制次数
			original_price = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.original_price), %% 原始价格
			finish_limit = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_limit), %% 完成条件,
			finish_consume = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_consume), %% 完成消耗扣除
			finish_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_reward), %% 完成奖励
			update_time = Ets#back_req_ref_operate_sub_type_conf.update_time %% 更新时间
		},
		ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsInfo)
	end,
	[Fun(X) || X <- List];
update_operate_sub_type_conf(Ets) ->
	EtsInfo = #ets_operate_sub_type_conf{
		key = {Ets#back_req_ref_operate_sub_type_conf.active_id, Ets#back_req_ref_operate_sub_type_conf.sub_type}, %% {active_id, active_type}
		active_id = Ets#back_req_ref_operate_sub_type_conf.active_id,  %% 活动编号
		sub_type = Ets#back_req_ref_operate_sub_type_conf.sub_type, %% 活动子类
		content = Ets#back_req_ref_operate_sub_type_conf.content, %% 内容
		limit_count = Ets#back_req_ref_operate_sub_type_conf.limit_count, %% 限制次数
		original_price = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.original_price), %% 原始价格
		finish_limit = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_limit), %% 完成条件,
		finish_consume = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_consume), %% 完成消耗扣除
		finish_reward = util_data:bitstring_to_term(Ets#back_req_ref_operate_sub_type_conf.finish_reward), %% 完成奖励
		update_time = Ets#back_req_ref_operate_sub_type_conf.update_time %% 更新时间
	},
	ets:insert(?ETS_OPERATE_SUB_TYPE_CONF, EtsInfo).

check_conf() ->
	{OpenList, HolidayList, State} = check_operate_active_conf(),
	LimitList = check_operate_sub_type_conf(OpenList),
	{OpenList, HolidayList, LimitList, State}.

%% 运营活动检测
check_operate_active_conf() ->
	CurTime = util_date:unixtime(),
	EtsList = ets:tab2list(?ETS_OPERATE_ACTIVE_CONF),
	Fun = fun(Info, {OpenList, HolidayList, State}) ->
		case CurTime > Info#ets_operate_active_conf.start_time andalso
			CurTime < Info#ets_operate_active_conf.end_time of
			true ->
				ActiveId = Info#ets_operate_active_conf.active_id,
				ActiveType = Info#ets_operate_active_conf.type,
				case ActiveType of
					?OPERATE_ACTIVE_TYPE_2 ->
						OpenList1 = [{ActiveId, ActiveType}] ++ OpenList,
						{OpenList1, HolidayList, 1};
					?OPERATE_ACTIVE_TYPE_4 ->
						HolidayList1 = [{ActiveId, ActiveType}] ++ HolidayList,
						{OpenList, HolidayList1, State};
					?OPERATE_ACTIVE_TYPE_5 ->
						HolidayList1 = [{ActiveId, ActiveType}] ++ HolidayList,
						{OpenList, HolidayList1, State};
					_ ->
						OpenList1 = [{ActiveId, ActiveType}] ++ OpenList,
						{OpenList1, HolidayList, State}
				end;
			false ->
				{OpenList, HolidayList, State}
		end
	end,
	lists:foldl(Fun, {[], [], 0}, EtsList).

%% 运营活动检测
check_operate_sub_type_conf(OpenList) ->
	EtsList = ets:tab2list(?ETS_OPERATE_SUB_TYPE_CONF),
	Fun = fun(Info, Acc) ->
		Id = Info#ets_operate_sub_type_conf.active_id,
		case lists:keyfind(Id, 1, OpenList) of
			false ->
				Acc;
			{_, ActiveType} ->
				case ActiveType of
					?OPERATE_ACTIVE_TYPE_2 ->
						Acc;
					_ ->
						LimitList = [{Id, LimitType} || {LimitType, _Vlaue} <- Info#ets_operate_sub_type_conf.finish_limit],
						LimitList ++ Acc
				end
		end
	end,
	L = lists:foldl(Fun, [], EtsList),
	util_list:filter_duplicate(L).

%% 重载活动配置
reload_conf() ->
	ets:delete_all_objects(?ETS_OPERATE_ACTIVE_CONF),
	ets:delete_all_objects(?ETS_OPERATE_SUB_TYPE_CONF),
	init_operate_active_conf(),
	init_operate_sub_type_conf(),
	ok.


%%% ----------------------------------------------------------------------------
%%% 玩家相关函数对外接口
%%% ----------------------------------------------------------------------------
%% 初始化双倍经验状态
init_double_exp_state(PlayerState) ->
	case ets:lookup(?ETS_DOUBLE_EXP, ?ALL_SERVER_SIGN) of
		[R | _] ->
			PlayerState#player_state{is_double_exp = R#ets_double_exp.state};
		_ ->
			PlayerState#player_state{is_double_exp = 0}
	end.

%% 根据活动id获取运营活动状态和相关参数
get_player_operate_active_info(PlayerState) ->
	StartList = get_start_active_list(),
	StartList1 = [get_operate_active_conf(Id) || Id <- StartList],
	CurTime = util_date:unixtime(),
	Fun = fun(Conf, [Model1, Model2, Model3]) ->
		%% 检测活动是否过期
		case CurTime > Conf#ets_operate_active_conf.start_time andalso
			CurTime < Conf#ets_operate_active_conf.end_time of
			true ->
				case Conf#ets_operate_active_conf.model of
					0 ->
						Proto = get_proto_info(PlayerState, Conf),
						[[Proto] ++ Model1, Model2, Model3];
					1 ->
						Proto = get_proto_info_by_model_2(PlayerState, Conf, CurTime),
						[Model1, [Proto] ++ Model2, Model3];
					2 ->
						Proto = get_proto_info_by_model_3(PlayerState, Conf, CurTime),
						[Model1, Model2, [Proto] ++ Model3];
					3 ->
						Proto = get_proto_info(PlayerState, Conf),
						[[Proto] ++ Model1, Model2, Model3]
				end;
			false ->
				[Model1, Model2, Model3]
		end
	end,
	lists:foldl(Fun, [[], [], []], lists:keysort(#ets_operate_active_conf.order_id, StartList1)).

%% 根据活动id获取节日活动状态和相关参数
get_player_holiday_active_info(PlayerState) ->
	StartList = get_start_holiday_active_list(),
	StartList1 = [get_operate_active_conf(Id) || {Id, _Type} <- StartList],
	CurTime = util_date:unixtime(),
	Fun = fun(Conf, Acc) ->
		%% 检测活动是否过期
		case CurTime > Conf#ets_operate_active_conf.start_time andalso
			CurTime < Conf#ets_operate_active_conf.end_time of
			true ->
				Proto = get_proto_holiday_info(PlayerState, Conf),
				[Proto] ++ Acc;
			false ->
				Acc
		end
	end,
	lists:foldl(Fun, [], lists:keysort(#ets_operate_active_conf.order_id, StartList1)).

%% 领取活动奖励
receive_reward(PlayerState, Id) ->
	%% io:format("id is:~p~n", [Id]),
	CurTime = util_date:unixtime(),
	Conf = get_operate_active_conf(Id),
	case CurTime > Conf#ets_operate_active_conf.start_time andalso
		CurTime < Conf#ets_operate_active_conf.end_time andalso
		Conf#ets_operate_active_conf.type == ?OPERATE_ACTIVE_TYPE_3 of
		true ->
			PlayerId = PlayerState#player_state.player_id,
			case get_finish_conf(PlayerState, Conf) of
				#ets_operate_sub_type_conf{} = SubTypeConf ->
					Consume = SubTypeConf#ets_operate_sub_type_conf.finish_consume,
					case goods_util:check_special_list(PlayerState, Consume) of
						true ->
							Reward = SubTypeConf#ets_operate_sub_type_conf.finish_reward,
							case goods_lib_log:add_goods_list(PlayerState, Reward, ?LOG_TYPE_OPERATE_ACTIVE) of
								{ok, PlayerState1} ->
									{ok, PlayerState2} = goods_util:delete_special_list(PlayerState1, Consume, ?LOG_TYPE_OPERATE_ACTIVE),
									%% 更新奖励领取次数
									FinishType = Conf#ets_operate_active_conf.finish_type,
									SubType = SubTypeConf#ets_operate_sub_type_conf.sub_type,
									player_operate_active_cache:update_info(PlayerId, Id, SubType, FinishType),
									State = get_state(PlayerState, Conf),
									log_lib:log_activity(PlayerState, Id),
									{ok, PlayerState2, State};
								{fail, Reply} ->
									{fail, Reply}
							end;
						{fail, Reply} ->
							{fail, Reply}
					end;
				_ ->
					%% 获取活动子类型生成错误码
					case get_operate_sub_type_conf_list(Id) of
						[] ->
							{fail, ?ERR_COMMON_FAIL};
						[SubConf | _] ->
							case SubConf#ets_operate_sub_type_conf.finish_limit of
								[{?OPERATE_ACTIVE_LIMIT_TYPE_1, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_1};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_2, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_2};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_3, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_3};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_4, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_4};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_5, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_5};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_11, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_11};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_12, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_12};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_13, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_13};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_16, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_16};
								_ ->
									{fail, ?ERROR_OPERATE_ACTIVE_0}
							end
					end
			end;
		false ->
			{fail, ?ERR_ACTIVE_TIME_LIMIT}
	end.

receive_reward(PlayerState, Id, SubType) ->
	%% io:format("id is:~p~n", [Id]),
	CurTime = util_date:unixtime(),
	Conf = get_operate_active_conf(Id),
	case CurTime > Conf#ets_operate_active_conf.start_time andalso
		CurTime < Conf#ets_operate_active_conf.end_time andalso
		Conf#ets_operate_active_conf.type == ?OPERATE_ACTIVE_TYPE_3 of
		true ->
			PlayerId = PlayerState#player_state.player_id,
			SubTypeConf = get_operate_sub_type_conf(Id, SubType),
			case check_special_active_state(PlayerState, Conf, SubTypeConf) of
				?STATE_ENOUGH ->
					Consume = SubTypeConf#ets_operate_sub_type_conf.finish_consume,
					case goods_util:check_special_list(PlayerState, Consume) of
						true ->
							Reward = SubTypeConf#ets_operate_sub_type_conf.finish_reward,
							case goods_lib_log:add_goods_list(PlayerState, Reward, ?LOG_TYPE_OPERATE_ACTIVE) of
								{ok, PlayerState1} ->
									{ok, PlayerState2} = goods_util:delete_special_list(PlayerState1, Consume, ?LOG_TYPE_OPERATE_ACTIVE),
									%% 更新奖励领取次数
									FinishType = Conf#ets_operate_active_conf.finish_type,
									SubType = SubTypeConf#ets_operate_sub_type_conf.sub_type,
									NewActiveInfo = player_operate_active_cache:update_info(PlayerId, Id, SubType, FinishType),

									%% 根据不同模版类型 返回对应的结果
									State = case Conf#ets_operate_active_conf.model of
												1 -> %% 返回领取状态
													check_special_active_state(PlayerState, Conf, SubTypeConf);
												2 -> %% 返回剩余购买次数
													SubTypeConf#ets_operate_sub_type_conf.limit_count - NewActiveInfo#db_player_operate_active.count
											end,

									log_lib:log_activity(PlayerState, Id),
									{ok, PlayerState2, State};
								{fail, Reply} ->
									{fail, Reply}
							end;
						{fail, Reply} ->
							{fail, Reply}
					end;
				_ ->
					%% 获取活动子类型生成错误码
					case get_operate_sub_type_conf_list(Id) of
						[] ->
							{fail, ?ERR_COMMON_FAIL};
						[SubConf | _] ->
							case SubConf#ets_operate_sub_type_conf.finish_limit of
								[{?OPERATE_ACTIVE_LIMIT_TYPE_1, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_1};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_2, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_2};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_3, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_3};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_4, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_4};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_5, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_5};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_11, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_11};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_12, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_12};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_13, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_13};
								[{?OPERATE_ACTIVE_LIMIT_TYPE_16, _} | _] ->
									{fail, ?ERROR_OPERATE_ACTIVE_16};
								_ ->
									{fail, ?ERROR_OPERATE_ACTIVE_0}
							end
					end
			end;
		false ->
			{fail, ?ERR_ACTIVE_TIME_LIMIT}
	end.

get_holiday_drop(Career, MonsterId) ->
	HolidayList = get_start_holiday_active_list(),
	Fun = fun({_Id, Type}, DropList) ->
		case Type of
			?OPERATE_ACTIVE_TYPE_5 ->
				case active_drop_config:get({Type, MonsterId}) of
					#active_drop_conf{} = DropConf ->
						List = DropConf#active_drop_conf.drop_list,
						rand_drop(List, Career, []);
					_ ->
						DropList
				end;
			_ ->
				DropList
		end
	end,
	lists:foldl(Fun, [], HolidayList).

rand_drop([], _Career, DropList) ->
	DropList;
rand_drop([{CareerLimit, DropWeightList, List} | T], Career, DropList) ->
	case CareerLimit == 0 orelse CareerLimit == Career of
		true ->
			List1 = [{{GoodsId, IsBind, Num}, Rate} || {GoodsId, IsBind, Num, Rate} <- List],
			DropNum = util_rand:weight_rand_ex(DropWeightList),
			DropList1 =
				case DropNum > 0 of
					true ->
						[util_rand:weight_rand_ex(List1) || _N <- lists:seq(1, DropNum)];
					_ ->
						[]
				end,
			rand_drop(T, Career, DropList1 ++ DropList);
		_ ->
			rand_drop(T, Career, DropList)
	end.

%%% ----------------------------------------------------------------------------
%%% 内部接口
%%% ----------------------------------------------------------------------------

%% 获取运营活动列表
get_start_active_list() ->
	case ets:lookup(?ETS_OPEN_OPERATE_LIST, ?ALL_SERVER_SIGN) of
		[R | _] ->
			[X || {X, _Y} <- R#ets_open_operate_list.active_list];
		_ ->
			[]
	end.

%% 获取节日活动列表
get_start_holiday_active_list() ->
	case ets:lookup(?ETS_OPEN_OPERATE_LIST, ?ALL_SERVER_SIGN) of
		[R | _] ->
			[{X, Y} || {X, Y} <- R#ets_open_operate_list.holiday_list];
		_ ->
			[]
	end.

%% 获取当前兑换活动的活动id
get_holiday_loot_active_id() ->
	case ets:lookup(?ETS_OPEN_OPERATE_LIST, ?ALL_SERVER_SIGN) of
		[R | _] ->
			[X || {X, Y} <- R#ets_open_operate_list.holiday_list, Y == ?OPERATE_ACTIVE_TYPE_5];
		_ ->
			[]
	end.

%% 获取运营活动限制条件列表
get_limit_list() ->
	case ets:lookup(?ETS_OPEN_OPERATE_LIST, ?ALL_SERVER_SIGN) of
		[R | _] ->
			R#ets_open_operate_list.limit_list;
		_ ->
			[]
	end.

%% 获取运营活动配置
get_operate_active_conf(Id) ->
	case ets:lookup(?ETS_OPERATE_ACTIVE_CONF, Id) of
		[R | _] ->
			R;
		_ ->
			[]
	end.

get_operate_sub_type_conf(Id, SubType) ->
	case ets:lookup(?ETS_OPERATE_SUB_TYPE_CONF, {Id, SubType}) of
		[R | _] ->
			R;
		_ ->
			[]
	end.

%% 获取活动子类配置列表
get_operate_sub_type_conf_list(Id) ->
	case ets:match_object(?ETS_OPERATE_SUB_TYPE_CONF, #ets_operate_sub_type_conf{key = {Id, '_'}, _ = '_'}) of
		MailList when length(MailList) > 0 ->
			lists:keysort(#ets_operate_sub_type_conf.sub_type, MailList);
		_ ->
			[]
	end.

get_proto_info(PlayerState, Conf) ->
	State = get_state(PlayerState, Conf),
	#proto_operate_active_info{
		active_id = Conf#ets_operate_active_conf.active_id,  %%  活动编号
		mark = Conf#ets_operate_active_conf.mark,
		model = Conf#ets_operate_active_conf.model,
		title = Conf#ets_operate_active_conf.title,  %%  活动标题
		content = Conf#ets_operate_active_conf.content,  %%  活动内容
		show_reward = get_goods_proto(Conf#ets_operate_active_conf.show_reward),  %%  奖励展示
		is_button = Conf#ets_operate_active_conf.is_button,
		button_content = Conf#ets_operate_active_conf.button_content,  %%  按钮描述
		is_window = Conf#ets_operate_active_conf.is_window,  %%  是否弹窗
		window_content = Conf#ets_operate_active_conf.window_content,  %%  弹窗内容文字
		start_time = Conf#ets_operate_active_conf.start_time,  %%  开始时间戳
		end_time = Conf#ets_operate_active_conf.end_time,  %%  结束时间戳
		state = State
	}.

get_proto_info_by_model_2(PlayerState, ActiveConf, CurTime) ->
	PlayerId = PlayerState#player_state.player_id,
	ActiveId = ActiveConf#ets_operate_active_conf.active_id,
	FinishType = ActiveConf#ets_operate_active_conf.finish_type,
	SubConfList = get_operate_sub_type_conf_list(ActiveId),
	case SubConfList of
		[SubConf | _] ->
			[{LimitType, _} | _] = SubConf#ets_operate_sub_type_conf.finish_limit,
			Info = player_operate_record_cache:get_info(PlayerId, ActiveId, LimitType, FinishType),
			ConcentValue = Info#db_player_operate_record.finish_limit_value,

			Fun = fun(SC) ->
				#proto_model_2{
					sub_type = SC#ets_operate_sub_type_conf.sub_type,  %%  子类型
					content = SC#ets_operate_sub_type_conf.content,  %%  参数内容
					show_reward = get_goods_proto(SC#ets_operate_sub_type_conf.finish_reward),  %%  奖励展示
					state = check_special_active_state(PlayerState, ActiveConf, SC)  %%  0未领取 1已领取
				}
			end,
			SubList = [Fun(X) || X <- SubConfList],

			#proto_operate_active_info_model_2{
				active_id = ActiveConf#ets_operate_active_conf.active_id,  %%  活动编号
				mark = ActiveConf#ets_operate_active_conf.mark,
				model = ActiveConf#ets_operate_active_conf.model,
				title = ActiveConf#ets_operate_active_conf.title,  %%  活动标题
				content = ActiveConf#ets_operate_active_conf.content,  %%  活动内容
				content_value = ConcentValue,
				sub_list = SubList,
				start_time = ActiveConf#ets_operate_active_conf.start_time,  %%  开始时间戳
				end_time = ActiveConf#ets_operate_active_conf.end_time,
				is_count_down = ActiveConf#ets_operate_active_conf.is_count_down,
				cur_time = CurTime
			};
		_ ->
			#proto_operate_active_info_model_2{
				active_id = ActiveConf#ets_operate_active_conf.active_id,  %%  活动编号
				mark = ActiveConf#ets_operate_active_conf.mark,
				model = ActiveConf#ets_operate_active_conf.model,
				title = ActiveConf#ets_operate_active_conf.title,  %%  活动标题
				content = ActiveConf#ets_operate_active_conf.content,  %%  活动内容
				content_value = 0,
				sub_list = [],
				start_time = ActiveConf#ets_operate_active_conf.start_time,  %%  开始时间戳
				end_time = ActiveConf#ets_operate_active_conf.end_time,
				is_count_down = ActiveConf#ets_operate_active_conf.is_count_down,
				cur_time = CurTime
			}
	end.


get_proto_info_by_model_3(PlayerState, ActiveConf, CurTime) ->
	PlayerId = PlayerState#player_state.player_id,
	ActiveId = ActiveConf#ets_operate_active_conf.active_id,
	FinishType = ActiveConf#ets_operate_active_conf.finish_type,
	SubConfList = get_operate_sub_type_conf_list(ActiveId),
	case SubConfList of
		[_SubConf | _] ->
			Fun = fun(SC) ->
				SubType = SC#ets_operate_sub_type_conf.sub_type,
				Info = player_operate_active_cache:get_info(PlayerId, ActiveId, SubType, FinishType),

				#proto_model_3{
					sub_type = SC#ets_operate_sub_type_conf.sub_type,  %%  子类型
					content = SC#ets_operate_sub_type_conf.content,  %%  参数内容
					old_price = get_goods_proto(SC#ets_operate_sub_type_conf.original_price),  %%  原价
					new_price = get_goods_proto(SC#ets_operate_sub_type_conf.finish_consume),  %%  现价
					shop = get_goods_proto(SC#ets_operate_sub_type_conf.finish_reward),  %%  商品
					count = SC#ets_operate_sub_type_conf.limit_count - Info#db_player_operate_active.count  %%  剩余购买次数
				}
			end,
			SubList = [Fun(X) || X <- SubConfList],

			#proto_operate_active_info_model_3{
				active_id = ActiveConf#ets_operate_active_conf.active_id,  %%  活动编号
				mark = ActiveConf#ets_operate_active_conf.mark,
				model = ActiveConf#ets_operate_active_conf.model,
				title = ActiveConf#ets_operate_active_conf.title,  %%  活动标题
				sub_list = SubList,
				start_time = ActiveConf#ets_operate_active_conf.start_time,  %%  开始时间戳
				end_time = ActiveConf#ets_operate_active_conf.end_time,
				is_count_down = ActiveConf#ets_operate_active_conf.is_count_down,
				cur_time = CurTime
			};
		_ ->
			#proto_operate_active_info_model_3{
				active_id = ActiveConf#ets_operate_active_conf.active_id,  %%  活动编号
				mark = ActiveConf#ets_operate_active_conf.mark,
				model = ActiveConf#ets_operate_active_conf.model,
				title = ActiveConf#ets_operate_active_conf.title,  %%  活动标题
				sub_list = [],
				start_time = ActiveConf#ets_operate_active_conf.start_time,  %%  开始时间戳
				end_time = ActiveConf#ets_operate_active_conf.end_time,
				is_count_down = ActiveConf#ets_operate_active_conf.is_count_down,
				cur_time = CurTime
			}
	end.

%% 检测特殊活动领取状态
check_special_active_state(PlayerState, ActiveConf, SubConf) ->
	PlayerId = PlayerState#player_state.player_id,
	ActiveId = ActiveConf#ets_operate_active_conf.active_id,
	SubType = SubConf#ets_operate_sub_type_conf.sub_type,
	FinishType = ActiveConf#ets_operate_active_conf.finish_type,
	FinishInfo = player_operate_active_cache:get_info(PlayerId, ActiveId, SubType, FinishType),
	ConfCount = SubConf#ets_operate_sub_type_conf.limit_count,
	FinishCount = FinishInfo#db_player_operate_active.count,
	FinishLimit = SubConf#ets_operate_sub_type_conf.finish_limit,
	check_finish_count(PlayerState, ActiveConf, ConfCount, FinishCount, FinishLimit).

get_proto_holiday_info(_PlayerState, Conf) ->
	#proto_operate_holiday_active_info{
		active_id = Conf#ets_operate_active_conf.active_id,  %%  活动编号
		type = Conf#ets_operate_active_conf.type,
		start_time = Conf#ets_operate_active_conf.start_time,  %%  开始时间戳
		end_time = Conf#ets_operate_active_conf.end_time  %%  结束时间戳
	}.

get_goods_proto(ShowList) ->
	Fun = fun(L) ->
		case L of
			{GoodsId, IsBind, Num} ->
				#proto_goods_list{
					goods_id = GoodsId,  %%  道具id
					is_bind = IsBind,  %%  是否绑定 0非绑 1绑定
					num = Num  %%  数量
				};
			{GoodsId, Num} ->
				#proto_goods_list{
					goods_id = GoodsId,  %%  道具id
					is_bind = ?NOT_BIND,  %%  是否绑定 0非绑 1绑定
					num = Num  %%  数量
				}
		end
	end,
	[Fun(X) || X <- ShowList].


get_finish_conf(PlayerState, Conf) ->
	Id = Conf#ets_operate_active_conf.active_id,
	FinishType = Conf#ets_operate_active_conf.finish_type,
	PlayerId = PlayerState#player_state.player_id,
	Fun = fun(SubTypeConf) ->
		SubType = SubTypeConf#ets_operate_sub_type_conf.sub_type,
		FinishInfo = player_operate_active_cache:get_info(PlayerId, Id, SubType, FinishType),
		ConfCount = Conf#ets_operate_active_conf.finish_count,
		FinishCount = FinishInfo#db_player_operate_active.count,
		FinishLimit = SubTypeConf#ets_operate_sub_type_conf.finish_limit,
		State = check_finish_count(PlayerState, Conf, ConfCount, FinishCount, FinishLimit),
		{SubTypeConf, State}
	end,
	ResultList = [Fun(X) || X <- get_operate_sub_type_conf_list(Id)],
	get_finish_conf_1(ResultList).

get_finish_conf_1([]) ->
	0;
get_finish_conf_1([{Conf, State} | T]) ->
	case State of
		?STATE_ENOUGH ->
			Conf;
		_ ->
			get_finish_conf_1(T)
	end.

%% 检测当前活动完成次数
check_finish_count(PlayerState, Conf, ConfCount, FinishCout, FinishLimit) ->
	case FinishCout >= ConfCount of
		true ->
			?STATE_HAVEBEEN;
		false ->
			FinishType = Conf#ets_operate_active_conf.finish_type,
			ActiveId = Conf#ets_operate_active_conf.active_id,
			check_limit_cond(PlayerState, ActiveId, FinishType, FinishLimit)
	end.

%% 检测限制条件
check_limit_cond(_PlayerState, _ActiveId, _FinishType, []) ->
	?STATE_ENOUGH;
check_limit_cond(PlayerState, ActiveId, FinishType, [{Type, Value} | T]) ->
	case check_limit_cond_ex(PlayerState, ActiveId, FinishType, {Type, Value}) of
		?STATE_ENOUGH ->
			check_limit_cond(PlayerState, ActiveId, FinishType, T);
		_ ->
			?STATE_NOT_ENOUGH
	end.

%% 条件检测 特殊条件可写对应方法
check_limit_cond_ex(PlayerState, _ActiveId, _FinishType, {?OPERATE_ACTIVE_LIMIT_TYPE_1, Value}) ->
	DPB = PlayerState#player_state.db_player_base,
	PlayerLv = DPB#db_player_base.lv,
	case PlayerLv >= Value of
		true ->
			?STATE_ENOUGH;
		false ->
			?STATE_NOT_ENOUGH
	end;
check_limit_cond_ex(PlayerState, ActiveId, FinishType, {?OPERATE_ACTIVE_LIMIT_TYPE_3, Value}) ->
	NowTime = util_date:unixtime(),
	DPB = PlayerState#player_state.db_player_base,
	PlayerId = PlayerState#player_state.player_id,
	Info = player_operate_record_cache:get_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_3, FinishType),
	LastLoginTime = DPB#db_player_base.last_login_time,
	case Info#db_player_operate_record.finish_limit_value + NowTime - LastLoginTime >= Value of
		true ->
			?STATE_ENOUGH;
		false ->
			?STATE_NOT_ENOUGH
	end;
check_limit_cond_ex(PlayerState, ActiveId, FinishType, {LimitType, Value}) ->
	PlayerId = PlayerState#player_state.player_id,
	Info = player_operate_record_cache:get_info(PlayerId, ActiveId, LimitType, FinishType),
	case Info#db_player_operate_record.finish_limit_value >= Value of
		true ->
			?STATE_ENOUGH;
		false ->
			?STATE_NOT_ENOUGH
	end.

get_state(PlayerState, Conf) ->
	case get_finish_conf(PlayerState, Conf) of
		#ets_operate_sub_type_conf{} = _SubTypeConf ->
			1;
		_ ->
			2
	end.

%%% ----------------------------------------------------------------------------
%%% 条件函数
%%% ----------------------------------------------------------------------------

%% 更新活动完成条件
update_limit_type(PlayerState, Type) when is_record(PlayerState, player_state) ->
	ActiveList = [Id || {Id, LimitType} <- get_limit_list(), LimitType == Type],
	PlayerId = PlayerState#player_state.player_id,
	%% 更新对应活动的纪录
	Fun = fun(ActiveId) ->
		update_limit_type(PlayerId, Type, 1, ActiveId)
	end,
	[Fun(X) || X <- ActiveList];
update_limit_type(PlayerId, Type) ->
	ActiveList = [Id || {Id, LimitType} <- get_limit_list(), LimitType == Type],
	%% 更新对应活动的纪录
	Fun = fun(ActiveId) ->
		update_limit_type(PlayerId, Type, 1, ActiveId)
	end,
	[Fun(X) || X <- ActiveList].
update_limit_type(PlayerState, Type, Value) when is_record(PlayerState, player_state) ->
	ActiveList = [Id || {Id, LimitType} <- get_limit_list(), LimitType == Type],
	PlayerId = PlayerState#player_state.player_id,
	%% 更新对应活动的纪录
	Fun = fun(ActiveId) ->
		update_limit_type(PlayerId, Type, Value, ActiveId)
	end,
	[Fun(X) || X <- ActiveList];
update_limit_type(PlayerId, Type, Value) ->
	ActiveList = [Id || {Id, LimitType} <- get_limit_list(), LimitType == Type],
	%% 更新对应活动的纪录
	Fun = fun(ActiveId) ->
		update_limit_type(PlayerId, Type, Value, ActiveId)
	end,
	[Fun(X) || X <- ActiveList].

%% 等级条件(限定活动时间内到达多少级)
update_limit_type(_PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_1, _Value, _ActiveId) ->
	skip;
%% 充值金额(限定活动时间内累计充值)
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_2, Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_count(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_2, FinishType, Value);
%% 累计在线(限定活动时间内累计在线时间)
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_3, Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_count(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_3, FinishType, Value);
%% 累计登陆(限定活动时间内累计登陆天数)
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_4, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_every_day(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_4, FinishType);
%% 累计消耗元宝(限定活动时间内累计消费元宝数)(不计算交易所、角色交易和行会红包消耗的元宝)
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_5, Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_count(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_5, FinishType, Value);


%% 日常任务
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_6, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_6, FinishType);
%% 膜拜英雄
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_7, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_7, FinishType);
%% 排位赛
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_8, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_8, FinishType);
%% 功勋任务
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_9, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_9, FinishType);
%% 个人副本（经验、金币、材料）
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_10, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_10, FinishType);
%% 屠龙大会
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_11, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_11, FinishType);
%% 胜者为王
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_12, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_12, FinishType);
%% 神秘暗殿
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_13, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_13, FinishType);
%% 行会BOSS
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_14, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_14, FinishType);
%% 行会秘境
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_15, Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_count(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_15, FinishType, Value);
%% 怪物攻城
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_16, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_16, FinishType);
%% 宝图任务
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_17, _Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_17, FinishType);
%% 活动期间内击杀怪物获得积分
update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_18, Value, ActiveId) ->
	Conf = get_operate_active_conf(ActiveId),
	FinishType = Conf#ets_operate_active_conf.finish_type,
	player_operate_record_cache:update_info_by_count(PlayerId, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_18, FinishType, Value);
update_limit_type(_PlayerId, _LimitType, _Value, _A) ->
	?ERR("update_limit_type error ~p", [_LimitType]).

%% 更新相关副本次数
update_instance_enter_count(PlayerId, SceneId) ->
	InstanceConf = instance_config:get(SceneId),
	InstanceType = InstanceConf#instance_conf.type,
	case InstanceType of
		?INSTANCE_TYPE_SINGLE -> %% 个人副本
			update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_10);
		?INSTANCE_TYP_DRAGON -> %% 屠龙大会
			update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_11);
		?INSTANCE_TYP_SZWW -> %% 胜者为王
			update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_12);
		?INSTANCE_TYP_WZAD -> %% 未知暗殿
			update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_13);
		?INSTANCE_TYPE_MULTIPLE -> %% 多人副本包括 行会BOSS 行会秘境
			case SceneId of
				20300 ->
					update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_14);
				20301 ->
					update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_14);
				20302 ->
					update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_14);
				20303 ->
					update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_15);
				_ ->
					skip
			end;
		?INSTANCE_TYP_ATTACK_CITY -> %% 怪物攻城
			update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_16);
		_ ->
			skip
	end.

%%% ----------------------------------------------------------------------------
%%% 进程相关
%%% ----------------------------------------------------------------------------

%% 玩家击杀怪物
kill_monster(PlayerState, MonsterId) ->
	%% 检测ets如果有杀怪活动则添加积分
	HolidayList = get_start_holiday_active_list(),
	case lists:keyfind(?OPERATE_ACTIVE_TYPE_4, 2, HolidayList) of
		{ActiveId, _Type} ->
			PlayerId = PlayerState#player_state.player_id,
			Score = case active_drop_config:get({?OPERATE_ACTIVE_TYPE_4, MonsterId}) of
						#active_drop_conf{} = Conf ->
							Conf#active_drop_conf.active_score;
						_ ->
							0
					end,

			case Score > 0 of
				true ->
					NewInfo = update_limit_type(PlayerId, ?OPERATE_ACTIVE_LIMIT_TYPE_18, Score, ActiveId),
					check_kill_info(NewInfo, Score);
				false ->
					skip
			end;
		_ ->
			skip
	end.

%% 奖励检测
check_kill_info(NewInfo, AddValue) ->
	%% 获取杀怪积分配置
	Conf = holidays_active_config:get(?OPERATE_ACTIVE_TYPE_4),
	{_, List} = lists:keyfind(score, 1, Conf#holidays_active_conf.reward),
	NewValue = NewInfo#db_player_operate_record.finish_limit_value,
	Fun = fun({Score, MailId}) ->
		case NewValue - AddValue < Score andalso NewValue >= Score of
			true ->
				%% 发送邮件奖励
				PlayerId = NewInfo#db_player_operate_record.player_id,
				mail_lib:send_mail_to_player(PlayerId, MailId);
			false ->
				skip
		end
	end,
	[Fun(X) || X <- List].

%% 活动结束发放123名奖励
send_kill_active_mail(RankList) ->
	Conf = holidays_active_config:get(?OPERATE_ACTIVE_TYPE_4),
	{_, List} = lists:keyfind(rank, 1, Conf#holidays_active_conf.reward),
	Fun = fun({Rank, MailId, MinScore}) ->
		case lists:keyfind(Rank, #ets_rank_kill_active.rank, RankList) of
			false ->
				skip;
			R ->
				case R#ets_rank_kill_active.score >= MinScore of
					true ->
						mail_lib:send_mail_to_player(R#ets_rank_kill_active.player_id, MailId);
					false ->
						skip
				end
		end
	end,
	[Fun(X) || X <- List].