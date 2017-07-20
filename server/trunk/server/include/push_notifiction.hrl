%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 六月 2015 下午3:37
%%%-------------------------------------------------------------------

-define(PUSH_TYPE_CUSTOMIZEDCAST, <<"customizedcast">>).
-define(PUSH_TYPE_UNICAST, <<"unicast">>).
-define(PUSH_TYPE_LISTCAST, <<"listcast">>).
-define(PUSH_TYPE_BROADCAST, <<"broadcast">>).
-define(PUSH_TYPE_GROUPCAST, <<"groupcast">>).

-define(IOS_APP_KEY, <<"57833cb0e0f55ae2db002215">>).
-define(IOS_APP_MASTER_SECRET, <<"15hp9loltyrwedxbv1ypa2lldedbngzo">>).

-define(ANDROID_APP_KEY, <<"578365ee67e58e29c9000b26">>).
-define(ANDROID_APP_MASTER_SECRET, <<"hpbt9pumfhaeh7vrn7kom0oupqhbjjlc">>).

-define(URL, "http://msg.umeng.com/api/send").
-define(ALIAS_TYPE, <<"WEIXIN">>).

-record(umeng_data, {
	appkey,
	timestamp,
	type,
	device_tokens,
	alias_type,
	alias,
	file_id,
	filter,
	payload,
	policy,
	production_mode,
	description,
	thirdparty_id
}).

%% ios消息推送结构
-record(ios_payload, {
	aps,
	extra
}).

-record(aps, {
	alert,
	badge,
	sound,
	'content-available',
	category
}).

%% android消息推送结构
-record(android_payload, {
	display_type,
	body,
	extra
}).

-record(body, {
	ticker,
	title,
	text,
	icon,
	largeIcon,
	img,
	sound,
	builder_id,
	play_vibrate,
	play_lights,
	play_sound,
	after_open,
	url,
	activity,
	custom
}).

-record(extra, {
	k,
	v
}).
