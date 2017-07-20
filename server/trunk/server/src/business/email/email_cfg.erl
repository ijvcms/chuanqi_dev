%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 五月 2016 下午3:12
%%%-------------------------------------------------------------------
-module(email_cfg).

%% API
-export([
	get_groups/0,
	get_all/0,
	get/1
]).

get_groups() ->
	["dev", "operation", "manager"].

get_all() ->
	Groups = get_groups(),
	List = lists:flatten([email_cfg:get(Group) || Group <- Groups]),
	List.

get("dev") ->
	["3041386976@qq.com"];
get("manager") ->
	[];
get(_) ->
	[].