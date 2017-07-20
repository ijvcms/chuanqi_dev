%% @author qhb
%% @doc @todo Add description to util_timer.


-module(util_timer).
-compile(export_all).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

sleep_start(Tag) ->
	Name = lists:concat([pretime, '_', Tag]),
	Time = date_util:milliseconds(),
	put(Name, Time),
	Time.

sleep_to(Tag, TimeLine) ->
	Name = lists:concat([pretime, '_', Tag]),
	PreTime = get(Name),
	Time = date_util:milliseconds(),
	Tm = Time - PreTime,
	Last = TimeLine - Tm,
	case Last > 0 of
		true ->
			util:sleep(Last);
		false ->
			ok
	end,
	date_util:milliseconds().

sleep_stop(Tag) ->
	Name = lists:concat([pretime, '_', Tag]),
	erase(Name),
	date_util:milliseconds().

sleep_start() ->
	sleep_start(pretime).

sleep_to(Time) ->
	sleep_to(pretime, Time).

sleep_stop() ->
	sleep_stop(pretime).


%% ====================================================================
%% Internal functions
%% ====================================================================


