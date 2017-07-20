%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2016 上午9:23
%%%-------------------------------------------------------------------
-module(util_xml).

-include("common.hrl").
-include("record.hrl").
-include_lib("xmerl/include/xmerl.hrl").

-define(XML_PROLOG, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>").

%% API
-export([
	xml_from_map/1,
	xml_to_map/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
xml_from_map(MapData) ->
	try
		List = maps:to_list(MapData),
		Data1 = xml_from_map1(List),
		?INFO("~p", [Data1]),
		Xml = xmerl:export_simple(Data1, xmerl_xml,[{prolog, ?XML_PROLOG}]),
		{ok, lists:flatten(Xml)}
	catch
	    Err:Info ->
			?ERR("~p:~p~n~p", [Err, Info, erlang:get_stacktrace()]),
			{Err, Info}
	end.

xml_from_map1(List) ->
	[xml_from_map2(K, V) || {K, V} <- List].

xml_from_map2(K, V) when is_map(V) ->
	List = maps:to_list(V),
	{K, xml_from_map1(List)};
xml_from_map2(K, []) ->
	{K, [""]};
xml_from_map2(K, [X | _T] = V) when is_map(X) ->
	VList = [
		begin
			List = maps:to_list(V1),
			[Data] = xml_from_map1(List),
			Data
		end || V1 <- V],
	{K, VList};
xml_from_map2(K, V) ->
	{K, [util_data:to_list(V)]}.

xml_to_map(XmlData) ->
	try
		{XmlElement, _} = xmerl_scan:string(XmlData),
		#xmlElement{
			name = Name,
			content = Content
		} = XmlElement,
		MapData = maps:put(Name, xml_to_map1(Content), maps:new()),
		{ok, MapData}
	catch
		Err:Info ->
			?ERR("~p:~p~n~p", [Err, Info, erlang:get_stacktrace()]),
			{Err, Info}
	end.

xml_to_map1([]) ->
	[];
xml_to_map1([XmlText]) when is_record(XmlText, xmlText) ->
	XmlText#xmlText.value;
xml_to_map1(Content) ->
	case has_same_element(Content, dict:new()) of
		true ->
			xml_to_map2(Content, []);
		_ ->
			xml_to_map2(Content, #{})
	end.

xml_to_map2([], Acc) ->
	Acc;
xml_to_map2([XmlElement | T], Acc) when is_map(Acc) ->
	#xmlElement{
		name = Name,
		content = Content
	} = XmlElement,
	NewAcc = maps:put(Name, xml_to_map1(Content), Acc),
	xml_to_map2(T, NewAcc);
xml_to_map2([XmlElement | T], Acc) when is_list(Acc) ->
	#xmlElement{
		name = Name,
		content = Content
	} = XmlElement,
	NewAcc = [maps:put(Name, xml_to_map1(Content), maps:new()) | Acc],
	xml_to_map2(T, NewAcc).

%% ====================================================================
%% Internal functions
%% ====================================================================
has_same_element([], _EleDict) ->
	false;
has_same_element([XmlElement | T], EleDict) ->
	#xmlElement{
		name = Name
	} = XmlElement,
	case dict:find(Name, EleDict) of
		{ok, _} ->
			true;
		_ ->
			has_same_element(T, dict:store(Name, Name, EleDict))
	end.
