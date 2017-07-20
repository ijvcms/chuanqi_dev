%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 四月 2015 下午12:12
%%%-------------------------------------------------------------------
-module(test).

-include("proto.hrl").
-include("common.hrl").
-include("util_json.hrl").
-include("proto_back.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("record.hrl").

-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
test_map(N) ->
	test_map(N, util_date:longunixtime()).

test_map(0, Btime) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]);
test_map(N, Btime) ->
	%% Mod = util_data:to_atom("map_1"),
	Mod = scene_map_config:get(1),
	Data = Mod:data(),
	D1 = element(1, Data),
	_F = element(1, D1),
	test_map(N - 1, Btime).

test(N) ->
	test(N, util_date:longunixtime(), maps:new()).

test(0, Btime, Map) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]),
	Map;
test(N, Btime, Map) ->
	NewMap = maps:put(N, N, Map),
	test(N - 1, Btime, NewMap).

test_find(N, Map) ->
	test_find(N, util_date:longunixtime(), Map).

test_find(0, Btime, _) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]);
test_find(N, Btime, Map) ->
	_A = maps:find(N, Map),
	test_find(N - 1, Btime, Map).


test1(N) ->
	test1(N, util_date:longunixtime(), dict:new()).

test1(0, Btime, Dict) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]),
	Dict;
test1(N, Btime, Dict) ->
	NewMap = dict:store(N, N, Dict),
	test1(N - 1, Btime, NewMap).

test_find1(N, Dict) ->
	test_find1(N, util_date:longunixtime(), Dict).

test_find1(0, Btime, _) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]);
test_find1(N, Btime, Dict) ->
	_A = dict:find(N, Dict),
	test_find1(N - 1, Btime, Dict).

test_a_star(N) ->
	test_a_star1(N, util_date:longunixtime()).

test_a_star1(0, Btime) ->
	Etime = util_date:longunixtime(),
	?INFO("use time: ~p ms", [Etime - Btime]);
test_a_star1(N, Btime) ->
	BX = util_rand:rand(1, 269),
	BY = util_rand:rand(1, 205),
	EX = util_rand:rand(1, 269),
	EY = util_rand:rand(1, 205),
	area_lib:get_path(10002, {BX,BY}, {EX,EY}),
	test_a_star1(N-1, Btime).

update_obj_state([], ObjState) ->
	ObjState;
update_obj_state([{List, V} | T], ObjState) ->
	UpdateList = make_update_list(List, ObjState, []),
	NewObjState = update_obj_state1(UpdateList, V),
	update_obj_state(T, NewObjState).

update_obj_state1([], V) ->
	V;
update_obj_state1([{K, R} | T], V) ->
	NV = setelement(K, R, V),
	update_obj_state1(T, NV).

make_update_list([], _R, List) ->
	List;
make_update_list([K | T], R, List) ->
	NR = element(K, R),
	make_update_list(T, NR, [{K, R} | List]).



test_catch() ->
	M = lists,
	F = a,
	try M:F() of
		N -> N
	catch
		_:_ -> null
	end.

test_list1() ->
	List = lists:seq(1, 100000000),
	T1 = util_date:longunixtime(),
	_List1 = [X || X <- List],
	T2 = util_date:longunixtime(),
	?INFO("use time : ~p", [T2 - T1]).

test_list2() ->
	List = lists:seq(1, 100000000),
	T1 = util_date:longunixtime(),
	F = fun(X, Acc) ->
			[X | Acc]
		end,
	_List1 = lists:foldl(F, [], List),
	T2 = util_date:longunixtime(),
	?INFO("use time : ~p", [T2 - T1]).

%% -define(xml_prolog, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>").
%% test_xml() ->
%% 	Data = {'Request', [{groupId,["g80000049837291"]}, {members,[{member, ["8000000345678"]}, {member, ["8000000345678"]}, {member, ["8000000345678"]}]}, {confirm, ["1"]}, {declared, [""]}]},
%% 	Xml = xmerl:export_simple([Data], xmerl_xml,[{prolog, ?xml_prolog}]),
%% 	Xml1 = lists:flatten(Xml),
%%
%% 	{Doc, _} = xmerl_scan:string(Xml1),
%% 	Doc.

test_xml() ->
	Data = #{
		'Request' => #{
			groupId => "g80000049837291",
			members => [
				#{member => "8000000345678"},
				#{member => "8000000345678"},
				#{member => "8000000345678"}
			],
			confirm => "1",
			declared => ""
		}
	},
	{ok, Xml} = util_xml:xml_from_map(Data),
	{ok, Map} = util_xml:xml_to_map(Xml),
	{ok, Xml1} = util_xml:xml_from_map(Map),
	Xml1.

test_apply(N) ->
	D1 = util_date:longunixtime(),
	test_apply(1, N),
	D2 = util_date:longunixtime(),
	io:format("~p~n", [D2 - D1]).

test_apply(_N, _N) ->
	ok;
test_apply(A, N) ->
	A1 = A rem 7,
	List = lists:seq(1, A1),
	%%erlang:apply(?MODULE, apply_fun, List),
	my_apply(?MODULE, apply_fun, List),
	test_apply(A+1, N).

test_cache() ->
	List1 = ets:tab2list(?CACHE_EFFECTIVE),
	List2 = ets:tab2list(?CACHE_OPERATE),
	F1 = fun(Info, Acc) ->
		#cache_effective{
			tab_key = {Tab, _}
		} = Info,
		case lists:keyfind(Tab, 1, Acc) of
			{Tab, Num} ->
				lists:keyreplace(Tab, 1, Acc, {Tab, Num+1});
			_ ->
				[{Tab, 1} | Acc]
		end
	end,
	List11 = lists:foldl(F1, [], List1),

	F2 = fun({Tab, Num}, Acc) ->
		{L, L1} = Acc,
		LL = ets:tab2list(Tab),
		Num1 = length(LL),
		NL =
		case Num /= Num1 of
			true -> [{Tab, Num1} | L];
			_ -> L
		end,
		{NL, [{Tab, Num1} | L1]}
	end,
	{List12, List14} = lists:foldl(F2, {[], []}, List11),
	io:format("======================= list show ========================~n"),
	io:format("~p~n", [List11]),
	io:format("-----------------------------------------------~n"),
	io:format("~p~n", [List14]),
	io:format("-----------------------------------------------~n"),
	io:format("~p~n", [List12]),
	io:format("======================= bug show ========================~n"),
	F3 = fun(Info, Acc) ->
		{Tab, Key} = Info#cache_operate.tab_key,
		case ets:lookup(Tab, Key) of
			[] ->
				[{Tab, Key} | Acc];
			_ ->
				Acc
		end
	end,
	List13 = lists:foldl(F3, [], List2),
	io:format("~p~n", [List13]).

ets_init() ->
	ets:new(test, [{keypos, #ets_cache.key}, named_table, public, set, {write_concurrency, true}]),
	[ets:insert(test, #ets_cache{key = N, info = N}) || N <- lists:seq(1, 1000)].

ets_test() ->
	F = fun() ->
		List = ets:tab2list(test),
		F1 = fun(N) ->
			case ets:lookup(test, N#ets_cache.key) of
				[] ->
					io:format("~p~n", [N#ets_cache.key]);
				_ ->
					ok
			end
		end,
		lists:foreach(F1, List)
	end,
	spawn(F),

	F2 = fun() ->
		List = ets:tab2list(test),
		F1 = fun(N) ->
			ets:delete(test, N#ets_cache.key)
		end,
		lists:foreach(F1, List)
	end,
	spawn(F2).


%% ====================================================================
%% Internal functions
%% ====================================================================
my_apply(M, F, []) ->
	M:F();
my_apply(M, F, [A]) ->
	M:F(A);
my_apply(M, F, [A, A1]) ->
	M:F(A, A1);
my_apply(M, F, [A, A1, A2]) ->
	M:F(A, A1, A2);
my_apply(M, F, [A, A1, A2, A3]) ->
	M:F(A, A1, A2, A3);
my_apply(M, F, [A, A1, A2, A3, A4]) ->
	M:F(A, A1, A2, A3, A4);
my_apply(M, F, [A, A1, A2, A3, A4, A5]) ->
	M:F(A, A1, A2, A3, A4, A5).

apply_fun() ->
	ok.
apply_fun(A) ->
	A.
apply_fun(A, A1) ->
	{A, A1}.
apply_fun(A, A1, A2) ->
	{A, A1, A2}.
apply_fun(A, A1, A2, A3) ->
	{A, A1, A2, A3}.
apply_fun(A, A1, A2, A3, A4) ->
	{A, A1, A2, A3, A4}.
apply_fun(A, A1, A2, A3, A4, A5) ->
	{A, A1, A2, A3, A4, A5}.
%% 检查指定敏感词
check_by_keyword() ->
	NowTime = util_date:unixtime(),
	Fun = fun(_) ->
		check_by_keyword(<<116,104,106,229,135,164,230,150,176,229,132,191,150,176,229,132,191>>,<<"thj">>)
	end,
	[Fun(X) || X <- lists:seq(1, 5000)],
	util_date:unixtime() - NowTime.
check_by_keyword(BinMsg,Keyword) ->
	RegExp = list_to_binary(".*" ++ binary_to_list(Keyword) ++ ".*"),
	case re:compile(RegExp, [caseless]) of
		{ok, _Mp} ->
			case re:run(BinMsg,RegExp) of
				nomatch -> true;
				{match,_} -> false
			end;
		{error,_} -> true
	end.

%% 掉落测试
rand_drop(MonsterId, Career, SceneId) ->
	MonsterConf = monster_config:get(MonsterId),
	DropList =
		case MonsterConf#monster_conf.is_growth == 1 of
			true ->
				MonsterId = MonsterConf#monster_conf.monster_id,
				KillCount = monster_kills_cache:get_monster_kills_count(MonsterId, SceneId),
				case monster_growth_config:get(KillCount) of
					#monster_growth_conf{} = GrowthConf ->
						GrowthConf#monster_growth_conf.drop_list;
					_ ->
						MonsterConf#monster_conf.drop_list
				end;
			false ->
				MonsterConf#monster_conf.drop_list
		end,
	rand_drop1(DropList, Career, []).

rand_drop1([], _Career, DropList) ->
	DropList;
rand_drop1([{CareerLimit, DropWeightList, List} | T], Career, DropList) ->
	case CareerLimit == 0 orelse CareerLimit == Career of
		true ->
			List1 = [{{GoodsId, IsBind, Num}, Rate} || {GoodsId, IsBind, Num, Rate} <- List],
			DropNum = util_rand:weight_rand_ex(DropWeightList),
			DropList1 =
				case DropNum > 0 of
					true ->
						[util_rand:weight_rand_ex(List1) || _N <- lists:seq(1, DropNum)];
					_ ->
						[]
				end,
			rand_drop1(T, Career, DropList1 ++ DropList);
		_ ->
			rand_drop1(T, Career, DropList)
	end.

replace_by_keyword(BinMsg,Keyword) ->
	RegExp = list_to_binary(".*" ++ binary_to_list(Keyword) ++ ".*"),
	case re:compile(Keyword, [caseless]) of
		{ok, Mp} ->
			case re:run(BinMsg,RegExp) of
				nomatch -> BinMsg;
				{match,_} -> re:replace(BinMsg, Mp, <<"***">>, [global, {return, binary}])
			end;
		{error,_} -> BinMsg
	end.

vip_up(Exp, Career) ->
	VipList = [X || X <- vip_config:get_list(), X#vip_conf.career =:= Career, X#vip_conf.exp =< Exp],
	List = lists:keysort(#vip_conf.lv, VipList),
	lists:last(List).

test_100() ->
	re:run("的asd", "[\x{4e00}-\x{9fff}]+", [unicode]) =/= nomatch.

test_time() ->
	Time1 = util_date:longunixtime(),
	%% area_lib:get_path(20100, {28, 71}, {27, 62}),
	T = area_lib:get_path(20100, {28, 71}, {27, 62}),
	Time2 = util_date:longunixtime(),
	io:format("dddddd:~p,~p~n", [[Time2 - Time1], T]).

test_time2(Y) ->
	Time1 = util_date:longunixtime(),
	%% area_lib:get_path(20100, {28, 71}, {27, 62}),
	Fun = fun(_) ->
		area_lib:get_path(20100, {28, 71}, {29, 60})
	end,
	[Fun(X)||X <- lists:seq(1, Y)],
	Time2 = util_date:longunixtime(),
	io:format("dddddd:~p~n", [[Time2 - Time1]]).

%%获取场景SceneId中{X1,Y1}到{X2,Y2}的最近线路点列表
%%返回[{X1,Y1}，{X2,Y2}……]没包括起点包括了终点
get_path(SceneId,X1,Y1,X2,Y2)->
	Start={X1,Y1},
	Target={X2,Y2},
	case is_block(SceneId, Target)  of
		true->
			[{X1,Y1}];
		false->
			get_walk_path(SceneId,Start,Target)
	end.

%%A星算法获取线路函数
get_walk_path(SceneId,Start,Target)->
	OpenList=dict:store(Start, {Start, 0}, dict:new()),  %%开放列表 存储待处理的点
	WalkList=dict:store(Start, {Start, 0}, dict:new()),  %%路线列表 存储路线点
	CloseList=dict:new(),       %%封闭列表  存放已处理的节点
	WalkList2=get_nodes(SceneId, Start, Target, OpenList, CloseList, WalkList),  %%获取路线开始
	WalkList2 ++ [Target].

get_nodes(SceneId, Start, Target, OpenList, CloseList, WalkList)->
	{Tx, Ty} = Target,
	{CurNode, G} =getBestNode(OpenList, Target),   %%在开放列表获取最佳点 即G+H为最小的点（G从开始点走到当前点的路程，H当前点到目标的距离）
	{X,Y} = CurNode,
	case X == Tx andalso Y==Ty of
		true ->      %%如果最佳点等于目标点
			PathList=getPath(WalkList, Start, Target, []),
			lists:reverse(PathList);
		false ->    %%不等
			OpenList1=dict:erase({X,Y}, OpenList),    %%开放列表删除该最佳点 以该点为节点
			CloseList1 = dict:store({X,Y}, {CurNode, G}, CloseList),  %%节点存入到封闭列表
			Neighbor=getNeighBor(X,Y),          %%获取该节点邻接点
			[OpenList2, CloseList2, WalkListNew2] = checkNeighbor(SceneId, Neighbor, Start, Target, OpenList1, CloseList1, {CurNode, G}, WalkList),
			get_nodes(SceneId, Start, Target, OpenList2, CloseList2, WalkListNew2)
	end.

getBestNode(OpenList, Target)->
	OpenList1=dict:to_list(OpenList),
	F=fun({Pos1, {_, G1}}, {Pos2, {_, G2}})-> dist(Pos1, Target) + G1 =< dist(Pos2, Target) + G2 end, %%dist(Pos1, Target) + G1=H+G
	[Node|_] = lists:sort(F, OpenList1),
	{Pos,{_, Score}}=Node,
	{Pos, Score}.

getNeighBor(X,Y)->
	AllPos=[{X-1, Y-1}, {X-1, Y}, {X-1, Y+1}, {X, Y-1}, {X, Y+1}, {X+1, Y-1}, {X+1, Y}, {X+1, Y+1}],
	[{Px, Py} || {Px,Py} <- AllPos, Px > 0 andalso Py > 0 ].

%%对节点邻接点进行判断
checkNeighbor(_SceneId, [], _Start, _Target, OpenList, CloseList, _, WalkList) ->
	[OpenList, CloseList, WalkList];
checkNeighbor(SceneId, [Pos|T], Start, Target, OpenList, CloseList, Node, WalkList) ->
	{CurPos,G} = Node,          %%当前节点
	GNew=G+ dist(CurPos, Pos),   %%当前邻点的G值
	IsBlocked = is_block(SceneId, Pos),
	IsLowerThanCloseList = dict:is_key(Pos, CloseList),
	IsLowerThanOpenList = dict:is_key(Pos, OpenList),

	if
		IsBlocked ->   %%当前邻点为不可走不用操作就进行下一个邻点判断
			checkNeighbor(SceneId, T, Start, Target,  OpenList, CloseList, Node, WalkList);
		IsLowerThanCloseList ->   %%当前邻点为在封闭列表不用操作
			checkNeighbor(SceneId, T, Start, Target,  OpenList, CloseList, Node, WalkList);
		IsLowerThanOpenList ->    %%当前邻点在开放列表
			{_ParPos, GValue} = dict:fetch(Pos, OpenList),
			case GNew<GValue of
				true->   %%若走当前节点到该邻点的G值小于该邻点保存的G值   则更新该邻点G值并写到路点列表
					OpenListNew=dict:store(Pos, {CurPos, GNew}, OpenList),
					WalkListNew=dict:store(Pos, {CurPos, GNew}, WalkList),
					checkNeighbor(SceneId, T, Start, Target, OpenListNew, CloseList, Node,  WalkListNew);
				false->  %%大于则不用操作
					checkNeighbor(SceneId, T, Start, Target, OpenList, CloseList, Node,  WalkList)
			end;
		true ->     %%否则当前邻点添加到开放列表和路点列表
			WalkListNew=dict:store(Pos, {CurPos, GNew}, WalkList),
			OpenListNew = dict:store(Pos, {CurPos, GNew}, OpenList),
			checkNeighbor(SceneId, T, Start, Target, OpenListNew, CloseList, Node, WalkListNew)
	end.

%%从最后得到的路点列表获取想要的值
getPath(WalkList, {X,Y}, {Px,Py}, Result) ->
	Tmp = dict:fetch({Px,Py}, WalkList),
	{{X0, Y0},_} = Tmp,
	case X0 == X andalso Y == Y0 of
		true ->
			Result;
		false ->
			getPath(WalkList, {X,Y}, {X0,Y0}, Result ++ [{X0, Y0}])
	end.

%%判断一个点是否可走
is_block(SceneId, {EX, EY}) ->
	not area_lib:can_move(SceneId, {EX, EY}).

%%获取两个点距离
dist({X1, Y1}, {X2, Y2}) ->
	math:sqrt((X2 - X1) * (X2 - X1) + (Y2 - Y1) * (Y2 - Y1)).

test_300(S, T) ->
	OpenList=dict:store(S, {S, 0}, dict:new()),  %%开放列表 存储待处理的点
	OpenList1=dict:to_list(OpenList),
	F=fun({Pos1, {_, G1}}, {Pos2, {_, G2}})-> dist(Pos1, T) + G1 =< dist(Pos2, T) + G2 end, %%dist(Pos1, Target) + G1=H+G
	[Node|_] = lists:sort(F, OpenList1),
	Node.

test_nm() ->
	%% 邮件补发
	AL = [X||X <- ets:tab2list(ets_operate_active_conf), X#ets_operate_active_conf.type == 4],
	case AL of
		[Conf|_] ->
			RankFlag = {ets_rank_kill_active, Conf#ets_operate_active_conf.active_id, 18},
			case rank_lib:get_rank_list(RankFlag) of
				[] ->
					skip;
				RankList ->
					ets:delete(ets_rank_info, RankFlag),
					Proto = rank_lib:get_rank_list_data(RankFlag, RankList),
					NewProto = [P || P <- Proto, P#proto_active_rank_info.rank =< 3],
					Fun = fun(ProtoInfo) ->
						case ProtoInfo#proto_active_rank_info.score >= 5000 of
							true ->
								{_, MailId} = lists:keyfind(ProtoInfo#proto_active_rank_info.rank, 1, [{1, 93},{2, 94}, {3, 95}]),
								PlayerId = ProtoInfo#proto_active_rank_info.player_id,
								EtsMailList = mail_cache:get_all_player_mail_from_ets(PlayerId),
								List = [X||X <- EtsMailList, X#ets_player_mail.mail_id == MailId andalso X#ets_player_mail.state == 0],
								case List of
									[] ->
										mail_lib:send_mail_to_player(PlayerId, MailId);
									_ ->
										skip
								end;
							false ->
								skip
						end
					end,
					[Fun(X)||X <- NewProto]
			end;
		_ ->
			skip
	end.