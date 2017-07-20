%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     后台协议头文件
%%% @end
%%% Created : 05. 六月 2015 下午2:38
%%%-------------------------------------------------------------------

%% 总请求包
-record(back_req, {
	cmd,
	data
}).

-record(back_rep, {
	cmd,
	data
}).

%% 充值请求 1000
-record(back_req_recharge, {
	ret,
	player_id,
	money,
	goods_id,
	platform
}).
-record(back_rep_recharge, {
	ret
}).

%% 获取礼包码状态协议
-record(back_req_code_status, {
	codes_list
}).
-record(back_rep_code_status, {
	codes_list
}).

-record(code_info, {
	code_id,
	player_id,
	use_time
}).

%% 用户进程数据获取 1002
-record(back_req_player_dict, {
	player_id,
	key
}).
-record(back_rep_player_dict, {
	data
}).

%% 封号 1003
-record(back_req_player_ban, {
	player_id,
	disabled
}).
-record(back_rep_player_ban, {
	ret
}).


%% ***************************************最新信息
%% 发送公告 1005
-record(back_req_notice, {
	notice
}).


-record(back_rep_notice, {
	result
}).

%% 发送邮件 1006
-record(back_req_send_mail, {
	content, %% 内容
	title,  %% 标题
	goodslist, %% 物品列表
	targetype, %% 目标类型 1，角色名称，2角色id，3，账号id，4全体
	targetarr %% 目标列表
}).



-record(back_rep_send_mail, {
	result
}).

%% 禁言
-record(back_req_limit_chat, {
	player_id, %% 玩家id
	limit_chat %% 禁言时间
}).

-record(back_rep_limit_chat, {
	result
}).

%% 封号
-record(back_req_limit_login, {
	player_id, %% 玩家id
	limit_login %% 禁言时间
}).

-record(back_rep_limit_login, {
	result
}).

%% 充值
-record(back_req_charge, {
	player_id, %% 玩家id
	id %% 定单号
}).

-record(back_rep_charge, {
	result
}).

%% 发送信息结构
-record(back_req_send_red, {
	rmb, %% 发送金额
	name %% 目标类型 1，角色名称
}).
%% 发送红包返回结构
-record(back_rep_send_red, {
	result
}).
%% 获取在线人数
-record(back_req_online_num, {
}).

-record(back_rep_online_num, {
	status,
	data
}).


%% 修改功能开启时间
-record(back_req_update_function, {
	function_id,
	begin_time,
	end_time,
	group
}).
%% 修改功能开启时间
-record(back_rep_update_function, {
	result
}).

%% 刷新服务器的配置信息
-record(back_req_ref_server_info, {

}).
%% 刷新服务器的配置信息
-record(back_rep_ref_server_info, {
	result
}).

%% 获取服务器信息
-record(back_server_info, {
	ip, %% 服务器ip
	intranet_ip, %% 服务器内部ip
	service_port, %% 游戏端口
	port, %% 后台端口
	begin_time, %% 获取服务器列表开启显示的时间
	cross_path, %% 跨服服务器地址
	robot_path, %% 机器人连接地址
	robot_time, %% 机器人开启时间
	merge_time, %% 合服时间
	merge_times %% 合服次数
}).

%% 刷新运营活动
-record(back_req_ref_operate_active_conf, {
	active_id,
	order_id,
	type,
	model,
	mark,
	title,
	content,
	show_reward,
	is_button,
	button_content,
	is_window,
	is_count_down,
	window_content,
	start_time,
	end_time,
	finish_type,
	finish_count,
	update_time
}).

%% 刷新运营活动结果
-record(back_rep_ref_operate_active_conf, {
	result
}).

-record(back_req_ref_operate_sub_type_conf, {
	active_id,
	sub_type,
	content,
	limit_count,
	original_price,
	finish_limit,
	finish_consume,
	finish_reward,
	update_time
}).

-record(back_rep_ref_operate_sub_type_conf, {
	result
}).

%% 获取服务器信息
-record(back_cross_server_info, {
	intranet_ip, %% 服务器内部ip
	service_id, %% 服务器id
	service_merge %% 服务器合服id
}).


%%1016 管理端配置
-record(back_req_manager_config, {
}).

-record(back_rep_manager_config, {
	code = 0
}).

%%管理端自定义配置
-record(back_manager_config, {
	paytype = 0    %%0默认,1支付宝，11浩宇
}).

%%1017 查询是否在线
-record(back_req_online_status, {
	player_id_list = []
}).

-record(back_rep_online_status, {
	code = 0,
	status_list = []
}).