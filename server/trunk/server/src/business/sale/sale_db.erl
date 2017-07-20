%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(sale_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	delete/1,
	select_page/3,
	select_all/1,
	select_page_num/1,
	select_page1/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row(SaleId) ->
	case db:select_row(sale, record_info(fields, db_sale), [{sale_id, SaleId}]) of
		[] ->
			null;
		List ->
			Data= list_to_tuple([db_sale | List]),
			Data#db_sale{
				extra = util_data:string_to_term(Data#db_sale.extra)
			}
	end.

select_page1(Where,MinNum,MaxNum)->
	LimitSql= case MinNum>0 orelse MaxNum>0 of
				  true->
					  lists:concat([" limit ",MinNum,",",MaxNum]);
				  _->
					  ""
			  end,
	Sql=lists:concat([" select * from sale ",Where,LimitSql]),
	List= db:select_all(Sql),
	Data= [ list_to_tuple([db_sale | X]) || X<-List ],
	[X#db_sale{ extra = util_data:string_to_term(X#db_sale.extra) } || X<-Data].

select_page(Where,MinNum,MaxNum)->
	LimitSql= case MinNum>0 orelse MaxNum>0 of
					true->
						lists:concat([" limit ",MinNum,",",MaxNum]);
					_->
						""
			  end,
	Sql=lists:concat([" select * from sale ",Where,LimitSql]),
	List= db:select_all(Sql),
	Data= [ list_to_tuple([db_sale | X]) || X<-List ],
	[X#db_sale{ extra = util_data:string_to_term(X#db_sale.extra) } || X<-Data].


select_page_num(Where)->
	Sql=lists:concat([" select count(sale_id) from sale ",Where]),
	Data = db:execute(Sql),
	[T|_H]=Data,
	[T1|_H1]=T,
	T1.

select_all(PlayerId) ->
	case db:select_all(sale, record_info(fields, db_sale), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			Data= [list_to_tuple([db_sale | X]) || X <- List],
			[ X#db_sale{extra =  util_data:string_to_term(X#db_sale.extra) } || X<-Data]
	end.

insert(SaleInfo) ->
	Extra = SaleInfo#db_sale.extra,
	SaleInfo1 = SaleInfo#db_sale{extra = util_data:term_to_string(Extra)},
	db:insert(sale, util_tuple:to_tuple_list(SaleInfo1)).

delete(SaleId) ->
	db:delete(sale, [{sale_id, SaleId}]).
%% API

