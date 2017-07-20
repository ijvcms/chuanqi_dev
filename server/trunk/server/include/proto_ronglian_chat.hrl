%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 三月 2016 下午2:46
%%%-------------------------------------------------------------------

-define(STATUS_CODE_SUCCESS, <<"000000">>). %% 成功

-define(GROUP_TYPE_TEMP, <<"0">>). %% 临时组(上限100人)
-define(GROUP_TYPE_NORMAL_1, <<"1">>). %% 普通组(上限300人)
-define(GROUP_TYPE_NORMAL_2, <<"2">>). %% 普通组(上限500人)
-define(GROUP_TYPE_PAY, <<"3">>). %% 付费普通组 (上限1000人)
-define(GROUP_TYPE_VIP, <<"4">>). %% 付费VIP组(上限2000人)

-define(PERMISSION_DEFAULT, <<"0">>).
-define(PERMISSION_VERIFY, <<"1">>).
-define(PERMISSION_PRIVATE, <<"2">>).

%% 创建群组
-record(rl_chat_req_create_group, {
	name = <<"">>,
	type = ?GROUP_TYPE_NORMAL_2,
	permission = ?PERMISSION_DEFAULT,
	declared = <<"">>
}).
-record(rl_chat_rep_create_group, {
	statusCode,
	groupId
}).

%% 删除群组
-record(rl_chat_req_delete_group, {
	groupId = <<"">>
}).
-record(rl_chat_rep_delete_group, {
	statusCode
}).

%% 查询群组
-record(rl_chat_req_search_groups, {
	groupId,
	name
}).
-record(rl_chat_rep_search_groups, {
	statusCode,
	groups
}).
-record(rl_chat_groups, {
	group
}).
-record(rl_chat_group, {
	groupId,
	name,
	type,
	count,
	permission
}).

%% 邀请入组
-record(rl_chat_req_invite, {
	groupId = <<"">>,
	members = [],
	confirm = <<"1">>,
	declared = <<"">>
}).
-record(rl_chat_members, {
	member
}).
-record(rl_chat_rep_invite, {
	statusCode
}).

%% 删除成员
-record(rl_chat_req_delete_member, {
	groupId = <<"">>,
	members = []
}).
-record(rl_chat_rep_delete_member, {
	statusCode
}).

%% 查询成员所加入的组
-record(rl_chat_rep_query_group, {
	statusCode,
	groups
}).