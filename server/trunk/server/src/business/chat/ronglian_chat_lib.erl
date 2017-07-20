%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		使用容联云通讯 接口
%%% @end
%%% Created : 02. 三月 2016 上午10:43
%%%-------------------------------------------------------------------
-module(ronglian_chat_lib).

-include("common.hrl").
-include("record.hrl").
-include("util_json.hrl").
-include("proto_ronglian_chat.hrl").

-define(ACCOUNT_SID, "8a48b55152f73add01530d9d16bf2aab").
-define(AUTH_TOKEN, "616618f940364f54bca5379985737c12").

-define(SUB_ACCOUNT_SID_1, "aaf98f8952f7367a01530d9e6dad2a7c").
-define(SUB_AUTH_TOKEN_1, "fd667b15d3174586ae101c47c8819b18").

-define(SUB_ACCOUNT_SID_2, "aaf98f8952f7367a01530d9e6dba2a7d").
-define(SUB_AUTH_TOKEN_2, "2c5e8d205c494435b6e7a3dc25bc3bdb").

-define(APP_ID, "aaf98f8952f7367a01530da1dc152a89").
-define(APP_TOKEN, "b436a0130ebb61e5e18586eddc719f60").

-define(DEBUG_URL, "https://sandboxapp.cloopen.com:8883").
-define(RELEASE_URL, "https://app.cloopen.com:8883").

-define(USE_DEBUG, true).
-ifdef(USE_DEBUG).
-define(REST_URL, ?DEBUG_URL).
-else.
-define(REST_URL, ?RELEASE_URL).
-endif.

-define(ACCEPT_XMD, "application/xml;").
-define(ACCEPT_JSON, "application/json;").

-define(CONTENT_TYPE_XML, "application/xml;charset=utf-8;").
-define(CONTENT_TYPE_JSON, "application/json;charset=utf-8;").

-define(USE_JSON, true).
-ifdef(USE_JSON).
-define(ACCEPT, ?ACCEPT_JSON).
-define(CONTENT_TYPE, ?CONTENT_TYPE_JSON).
-else.
-define(ACCEPT, ?ACCEPT_XMD).
-define(CONTENT_TYPE, ?CONTENT_TYPE_XML).
-endif.

-define(GROUP_FLAG_GUILD, "guild_"). %% 帮派组
-define(GROUP_FLAG_TEAM, "team_"). %% 队伍组

%% API
-export([
	init/0,
	get_md5_and_timestamp/1,
	creat_guild_group/1,
	creat_team_group/1,
	create_group/2,
	delete_guild_group/1,
	delete_team_group/1,
	delete_group/2,
	get_all_groups/0,
	search_groups/1,
	query_group/1,
	invite_join_guild_group/2,
	invite_join_team_group/2,
	invite_join_group/3,
	delete_guild_member/2,
	delete_team_member/2,
	delete_member/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
init() ->
	GroupsList = get_all_groups(),
	case GroupsList of
		[] ->
			skip;
		_ ->
			[begin
				#rl_chat_group{
					name = Name,
					groupId = GroupId
				} = Group,
				ets:insert(?ETS_RL_GROUP, #ets_rl_group{name = Name, group_id = GroupId})
			end || Group <- GroupsList]
	end.

%% 获取账号md5值和时间戳字符串(前端使用)
get_md5_and_timestamp(PlayerId) ->
	CurTime = util_date:unixtime(),
	TimeStr = util_date:unixtime_to_timelist(CurTime, 'yyyymmddhhmmss'),
	List = lists:concat([?APP_ID, PlayerId, TimeStr, ?APP_TOKEN]),
	Md5 = util_crypto:md5(List),
	{Md5, TimeStr}.

%% 创建帮派聊天组
creat_guild_group(GuildId) ->
	Name = make_name(?GROUP_FLAG_GUILD, GuildId),
	create_group(?GROUP_FLAG_TEAM, Name).

%% 创建队伍聊天组
creat_team_group(TeamId) ->
	Name = make_name(?GROUP_FLAG_TEAM, TeamId),
	create_group(?GROUP_FLAG_TEAM, Name).

%% 创建组
create_group(Flag, Name) ->
	Data = #rl_chat_req_create_group{
		name = Name
	},
	DataBin = ?JSON_FROM_RECORD(rl_chat_req_create_group, Data),

	{SubAccountSid, SubAuthToken} = get_admin_info(Flag),
	{Url, Headers} = get_url_and_headers(SubAccountSid, SubAuthToken, "Group", "CreateGroup"),
	case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, DataBin}, [], []) of
		{ok, {_StatusLine, _Headers1, Body}} ->
			Rep = ?JSON_TO_RECORD(rl_chat_rep_create_group, Body),
			case Rep#rl_chat_rep_create_group.statusCode of
				?STATUS_CODE_SUCCESS ->
					GroupId = Rep#rl_chat_rep_create_group.groupId,
					ets:insert(?ETS_RL_GROUP, #ets_rl_group{name = Name, group_id = GroupId}),
					{ok, Rep#rl_chat_rep_create_group.groupId};
				_ ->
					{fail, Rep#rl_chat_rep_create_group.statusCode}
			end;
		_Err ->
			?INFO("~p", [_Err])
	end.

%% 创建帮派聊天组
delete_guild_group(GuildId) ->
	Name = make_name(?GROUP_FLAG_GUILD, GuildId),
	delete_group(?GROUP_FLAG_GUILD, Name).

%% 创建队伍聊天组
delete_team_group(TeamId) ->
	Name = make_name(?GROUP_FLAG_TEAM, TeamId),
	delete_group(?GROUP_FLAG_TEAM, Name).

%% 删除组
delete_group(Flag, Name) ->
	case ets:lookup(?ETS_RL_GROUP, Name) of
		[EtsRlGroup] ->
			Id = EtsRlGroup#ets_rl_group.group_id,
			Data = #rl_chat_req_delete_group{
				groupId = Id
			},
			DataBin = ?JSON_FROM_RECORD(rl_chat_req_delete_group, Data),
			{SubAccountSid, SubAuthToken} = get_admin_info(Flag),
			{Url, Headers} = get_url_and_headers(SubAccountSid, SubAuthToken, "Group", "DeleteGroup"),
			case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, DataBin}, [], []) of
				{ok, {_StatusLine, _Headers1, Body}} ->
					Rep = ?JSON_TO_RECORD(rl_chat_rep_delete_group, Body),
					case Rep#rl_chat_rep_delete_group.statusCode of
						?STATUS_CODE_SUCCESS ->
							ets:delete(?ETS_RL_GROUP, Name),
							{ok, Id};
						_ ->
							{fail, Rep#rl_chat_rep_delete_group.statusCode}
					end;
				_Err ->
					?INFO("~p", [_Err])
			end;
		_ ->
			skip
	end.

%% 查询群组
search_groups(Name) ->
	Data = #rl_chat_req_search_groups{
		name = Name
	},
	DataBin = ?JSON_FROM_RECORD(rl_chat_req_search_groups, Data),
	{Url, Headers} = get_url_and_headers(?SUB_ACCOUNT_SID_1, ?SUB_AUTH_TOKEN_1, "Group", "SearchPublicGroups"),
	case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, DataBin}, [], []) of
		{ok, {_StatusLine, _Headers1, Body}} ->
			?INFO("~p", [Body]),
			Rep = ?JSON_TO_RECORD(rl_chat_rep_search_groups, Body),
			case Rep#rl_chat_rep_search_groups.statusCode of
				?STATUS_CODE_SUCCESS ->
					Groups = Rep#rl_chat_rep_search_groups.groups,
					case util_data:is_null(Groups) of
						true ->
							{ok, []};
						_ ->
							R = ?RFC4627_TO_RECORD(rl_chat_groups, Groups),
							List = [?RFC4627_TO_RECORD(rl_chat_group, Bin) || Bin <- R#rl_chat_groups.group],
							{ok, List}
					end;
				_ ->
					{fail, Rep#rl_chat_rep_search_groups.statusCode}
			end;
		_Err ->
			?INFO("~p", [_Err])
	end.

get_all_groups() ->
	FlagList = [?GROUP_FLAG_GUILD, ?GROUP_FLAG_TEAM],
	F = fun(Flag, Acc) ->
		case query_group(Flag) of
			{ok, List} ->
				List ++ Acc;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], FlagList).

query_group(Flag) ->
	{SubAccountSid, SubAuthToken} = get_admin_info(Flag),
	{Url, Headers} = get_url_and_headers(SubAccountSid, SubAuthToken, "Member", "QueryGroup"),
	case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, []}, [], []) of
		{ok, {_StatusLine, _Headers1, Body}} ->
			Rep = ?JSON_TO_RECORD(rl_chat_rep_query_group, Body),
			case Rep#rl_chat_rep_query_group.statusCode of
				?STATUS_CODE_SUCCESS ->
					Groups = Rep#rl_chat_rep_query_group.groups,
					case util_data:is_null(Groups) of
						true ->
							{ok, []};
						_ ->
							R = ?RFC4627_TO_RECORD(rl_chat_groups, Groups),
							List = [?RFC4627_TO_RECORD(rl_chat_group, Bin) || Bin <- R#rl_chat_groups.group],
							{ok, List}
					end;
				_ ->
					{fail, Rep#rl_chat_rep_query_group.statusCode}
			end;
		_Err ->
			?INFO("~p", [_Err])
	end.

%% 邀请玩家加入帮派聊天组
invite_join_guild_group(GuildId, PlayerList) ->
	Name = make_name(?GROUP_FLAG_GUILD, GuildId),
	invite_join_group(?GROUP_FLAG_GUILD, Name, PlayerList).

%% 邀请玩家加入队伍聊天组
invite_join_team_group(TeamId, PlayerList) ->
	Name = make_name(?GROUP_FLAG_TEAM, TeamId),
	invite_join_group(?GROUP_FLAG_TEAM, Name, PlayerList).

invite_join_group(Flag, Name, PlayerList) ->
	case ets:lookup(?ETS_RL_GROUP, Name) of
		[EtsRlGroup] ->
			Id = EtsRlGroup#ets_rl_group.group_id,
			MemberList =
				[begin
					util_data:to_binary(?APP_ID ++ util_data:to_list(PlayerId))
				end	|| PlayerId <- PlayerList],

			Members = #rl_chat_members{
				member = MemberList
			},
			Members1 = ?RFC4627_FROM_RECORD(rl_chat_members, Members),
			Data = #rl_chat_req_invite{
				groupId = Id,
				members = Members1
			},
			DataBin = ?JSON_FROM_RECORD(rl_chat_req_invite, Data),
			?INFO("~p", [DataBin]),
			{SubAccountSid, SubAuthToken} = get_admin_info(Flag),
			{Url, Headers} = get_url_and_headers(SubAccountSid, SubAuthToken, "Group", "InviteJoinGroup"),
			case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, DataBin}, [], []) of
				{ok, {_StatusLine, _Headers1, Body}} ->
					Rep = ?JSON_TO_RECORD(rl_chat_rep_invite, Body),
					case Rep#rl_chat_rep_invite.statusCode of
						?STATUS_CODE_SUCCESS ->
							ok;
						_ ->
							{fail, Rep#rl_chat_rep_invite.statusCode}
					end;
				_Err ->
					?INFO("~p", [_Err])
			end;
		_ ->
			skip
	end.

delete_guild_member(GuildId, PlayerList) ->
	Name = make_name(?GROUP_FLAG_GUILD, GuildId),
	delete_member(?GROUP_FLAG_GUILD, Name, PlayerList).

delete_team_member(TeamId, PlayerList) ->
	Name = make_name(?GROUP_FLAG_TEAM, TeamId),
	delete_member(?GROUP_FLAG_TEAM, Name, PlayerList).

delete_member(Flag, Name, PlayerList) ->
	case ets:lookup(?ETS_RL_GROUP, Name) of
		[EtsRlGroup] ->
			Id = EtsRlGroup#ets_rl_group.group_id,
			MemberList = [util_data:to_binary(?APP_ID ++ util_data:to_list(PlayerId)) || PlayerId <- PlayerList],
			Data = #rl_chat_req_delete_member{
				groupId = Id,
				members = MemberList
			},
			DataBin = ?JSON_FROM_RECORD(rl_chat_req_delete_member, Data),
			{SubAccountSid, SubAuthToken} = get_admin_info(Flag),
			{Url, Headers} = get_url_and_headers(SubAccountSid, SubAuthToken, "Group", "DeleteGroupMember"),
			case httpc:request(post, {Url, Headers, ?CONTENT_TYPE, DataBin}, [], []) of
				{ok, {_StatusLine, _Headers1, Body}} ->
					Rep = ?JSON_TO_RECORD(rl_chat_req_delete_member, Body),
					case Rep#rl_chat_rep_invite.statusCode of
						?STATUS_CODE_SUCCESS ->
							ok;
						_ ->
							{fail, Rep#rl_chat_rep_invite.statusCode}
					end;
				_Err ->
					?INFO("~p", [_Err])
			end;
		_ ->
			skip
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 获取管理员信息
get_admin_info(?GROUP_FLAG_GUILD) ->
	{?SUB_ACCOUNT_SID_1, ?SUB_AUTH_TOKEN_1};
get_admin_info(_) ->
	{?SUB_ACCOUNT_SID_2, ?SUB_AUTH_TOKEN_2}.

%% 获取url和协议头
get_url_and_headers(SubAccountSid, SubAuthToken, Func, Funcdes) ->
	CurTime = util_date:unixtime(),
	TimeStr = util_date:unixtime_to_timelist(CurTime, 'yyyymmddhhmmss'),

	Url = make_url(SubAccountSid, SubAuthToken, TimeStr, Func, Funcdes),
	Headers = make_headers(SubAccountSid, TimeStr),
	{Url, Headers}.

%% 根据表示和id生成组名字
make_name(Flag, Id) ->
	Id1 = util_data:to_list(Id),
	util_data:to_binary(Flag ++ Id1).

%% 生成url
make_url(SubAccountSid, Token, TimeStr, Func, Funcdes) ->
	List = lists:concat([SubAccountSid, Token, TimeStr]),
	SigParameter = util_crypto:md5(List),
	lists:concat([?REST_URL, "/2013-12-26/SubAccounts/", SubAccountSid, "/", Func, "/", Funcdes, "?sig=", SigParameter]).

%% 生成协议头
make_headers(SubAccountSid, TimeStr) ->
	List = lists:concat([SubAccountSid, ":", TimeStr]),
	Authorization = base64:encode_to_string(List),
	[
		{"Accept", ?ACCEPT},
		{"Content-Type", ?CONTENT_TYPE},
		{"Authorization", Authorization}
	].