%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 七月 2016 上午11:13
%%%-------------------------------------------------------------------
-module(db_data_init).

%% API
-export([
	update_accounts/0,
	delete_lottery_old/0
]).


update_accounts() ->
	SqlTpl = <<"update account set server_id='~w' where server_id=0">>,
	Sql = io_lib:format(SqlTpl, [config:get_server_no()]),
	db:execute(Sql),
	ok.

delete_lottery_old() ->
	Sql1 = <<"delete from lottery_box_db where ref_time<1483236000">>,
	db:execute(Sql1),
	Sql2 = <<"delete from lottery_box_log where time<1483236000">>,
	db:execute(Sql2),
	ok.