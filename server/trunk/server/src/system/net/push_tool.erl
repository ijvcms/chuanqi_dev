%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 上午11:18
%%%-------------------------------------------------------------------
-module(push_tool).
-include("common.hrl").
-include("push_notifiction.hrl").
-include("db_record.hrl").
-include("rfc4627.hrl").

-define(PLATFORM_FLAG_ANDROID, <<"android">>).
-define(PLATFORM_FLAG_IOS, <<"ios">>).

-define(JSON_TO_RECORD(RcName, Json),
	case rfc4627:decode(Json) of
		{ok, RequestEnc, []} -> ?RFC4627_TO_RECORD(RcName, RequestEnc);
		_ -> undefined
	end).

-define(JSON_FROM_RECORD(RcName, R), rfc4627:encode(?RFC4627_FROM_RECORD(RcName, R))).

%% API
-export([
	push_notifiction/3,
	push_notifiction/5,
	push_notifiction/4,
	push_notifiction/7
]).


%% 推送消息给单个人或者是一群人
push_notifiction(AppId, PlayerId, Msg) ->
	push_notifiction(AppId, PlayerId, Msg, null, []).

push_notifiction(AppId, PlayerId, Msg, ActionCmd, ActionArgList) when is_integer(PlayerId) ->
	case account_db:select_row(PlayerId) of
		#db_account{platform = Channel} = User ->
			Platform =
				case Channel =:= 1888 orelse Channel =:= 3888 of
					true -> ?PLATFORM_FLAG_IOS;
					false -> ?PLATFORM_FLAG_ANDROID
				end,
			Lang = <<"zh_CN">>,
			case enable_push(ActionCmd, User) of
				true ->
					push_notifiction(AppId, Platform, Lang, PlayerId, Msg, ActionCmd, ActionArgList);
				false ->
					skip
			end;
		_ ->
			skip
	end.

push_notifiction(AppId, Platform, PlayerIdOrList, Msg) ->
	push_notifiction(AppId, Platform, null, PlayerIdOrList, Msg, null, []).

push_notifiction(AppId, Platform, Lang, PlayerIdOrList, Msg, ActionCmd, ActionArgList) ->
	{Type, Alias} =
		case PlayerIdOrList of
			[0] -> {?PUSH_TYPE_BROADCAST, <<>>};
			_ -> {?PUSH_TYPE_CUSTOMIZEDCAST, to_alias_string(PlayerIdOrList)}
		end,
	Payload = make_payload(Platform, Lang, Msg, ActionCmd, ActionArgList),
	Data = #umeng_data{
		type = Type,
		appkey = get_app_key(AppId, Platform),
		alias = Alias,
		alias_type = <<"RENREN">>,
		timestamp = util_date:unixtime(),
		payload = Payload,
		production_mode = true,
		description = <<"server_push">>
	},
	Data1 = ?JSON_FROM_RECORD(umeng_data, Data),
	?INFO("~s", [Data1]),
	Sign = util_crypto:md5("POST" ++ ?URL ++ Data1 ++ util_data:to_list(get_app_master(AppId, Platform))),
	httpc:request(post, {?URL ++ "?sign=" ++ Sign, [], [], util_data:to_binary(Data1)}, [], []).

make_payload(?PLATFORM_FLAG_IOS, _Lang, Msg, ActionCmd, ActionArgList) ->
	Aps = #aps{
		alert = util_data:to_binary(xmerl_ucs:to_utf8(Msg))
	},
	Payload =
		case util_data:is_null(ActionCmd) of
			true ->
				#ios_payload{
					aps = ?RFC4627_FROM_RECORD(aps, Aps)
				};
			_ ->
				Extra = #extra{
					k = ActionCmd,
					v = ActionArgList
				},
				#ios_payload{
					aps = ?RFC4627_FROM_RECORD(aps, Aps),
					extra = ?RFC4627_FROM_RECORD(extra, Extra)
				}
		end,
	?RFC4627_FROM_RECORD(ios_payload, Payload);
make_payload(?PLATFORM_FLAG_ANDROID, _Lang, Msg, ActionCmd, ActionArgList) ->
	Body = #body{
		ticker = util_data:to_binary(xmerl_ucs:to_utf8("铁血沙城")),
		title = util_data:to_binary(xmerl_ucs:to_utf8("铁血沙城")),
		text = util_data:to_binary(xmerl_ucs:to_utf8(Msg))
	},
	Payload =
		case util_data:is_null(ActionCmd) of
			true ->
				#android_payload{
					display_type = <<"notification">>,
					body = ?RFC4627_FROM_RECORD(body, Body)
				};
			_ ->
				Extra = #extra{
					k = ActionCmd,
					v = ActionArgList
				},
				#android_payload{
					display_type = <<"notification">>,
					body = ?RFC4627_FROM_RECORD(body, Body),
					extra = ?RFC4627_FROM_RECORD(extra, Extra)
				}
		end,
	?RFC4627_FROM_RECORD(android_payload, Payload).

get_app_key(1, ?PLATFORM_FLAG_IOS) -> ?IOS_APP_KEY;
get_app_key(1, ?PLATFORM_FLAG_ANDROID) -> ?ANDROID_APP_KEY;
get_app_key(2, ?PLATFORM_FLAG_IOS) -> <<"5715fdf3e0f55ae8030017a7">>;
get_app_key(2, ?PLATFORM_FLAG_ANDROID) -> <<"null">>;
get_app_key(_, ?PLATFORM_FLAG_IOS) -> ?IOS_APP_KEY;
get_app_key(_, ?PLATFORM_FLAG_ANDROID) -> ?ANDROID_APP_KEY.

get_app_master(1, ?PLATFORM_FLAG_IOS) -> ?IOS_APP_MASTER_SECRET;
get_app_master(1, ?PLATFORM_FLAG_ANDROID) -> ?ANDROID_APP_MASTER_SECRET;
get_app_master(2, ?PLATFORM_FLAG_IOS) -> <<"al9oodn6frx93rpimrtwjmqdfukejboc">>;
get_app_master(2, ?PLATFORM_FLAG_ANDROID) -> <<"null">>;
get_app_master(_, ?PLATFORM_FLAG_IOS) -> ?IOS_APP_MASTER_SECRET;
get_app_master(_, ?PLATFORM_FLAG_ANDROID) -> ?ANDROID_APP_MASTER_SECRET.


%% ====================================================================
%% Internal functions
%% ====================================================================
to_alias_string(PlayerId) when is_integer(PlayerId) ->
	util_data:to_binary(PlayerId);
to_alias_string(List) when is_list(List) ->
	to_alias_string(List, <<>>).

to_alias_string([H], String) ->
	H1 = util_data:to_binary(H),
	<<String/binary, <<",">>/binary, H1/binary>>;
to_alias_string([H | T], String) ->
	H1 = util_data:to_binary(H),
	S1 =
		case String /= <<>> of
			true ->
				<<String/binary, <<",">>/binary, H1/binary>>;
			_ ->
				<<H1/binary>>
		end,
	to_alias_string(T, S1).

enable_push(_, _) ->
	true.