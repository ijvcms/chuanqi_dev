%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 三月 2016 下午2:40
%%%-------------------------------------------------------------------
-module(stat_lib).
-author("qhb").

%% API
-export([
	test_charge/0,
	charge/8
]).

%%测试
test_charge() ->
	Result = charge(4294967343, 1, 10, 2001, 1002, 40002, false, true),
	Result.

%% 订单开始或订单结束
charge(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete) ->
	EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
	post_talkingdata("E402F28B7FDD4DDA9913CD36502EBCA1", rfc4627:encode(EncData)).
%%
%%	if
%%		Server > 20000 ->
%%			case IsComplete of
%%				true ->
%%					spawn(fun() ->
%%						EncData = make_reyun_data(PlayerId, Money, Virtual, Platform, Server, ChargeId),
%%						post_reyun(rfc4627:encode(EncData))
%%					end);
%%				false ->
%%					skip
%%			end;
%%		Server > 13000 ->%%6kw
%%			spawn(fun() ->
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata("5D504D95810142CEA3190CD0F63261CA", rfc4627:encode(EncData))
%%			end);
%%		Server > 12000 ->%%玩趣（游魂)：赤月无双
%%			spawn(fun() ->
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata("310E2968B77F4F18B22D4B102AFA9766", rfc4627:encode(EncData))
%%			end);
%%		Server > 9000 ->%%云天空
%%			spawn(fun() ->
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata("0D3AC93FAACEBDB885DA0362A9580C2D", rfc4627:encode(EncData))
%%			end);
%%		Server > 5000 ->%%平平科技
%%			spawn(fun() ->
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata("F23DE28AA1A04897BDF07D500606BF03", rfc4627:encode(EncData))
%%			end);
%%		Server > 4000 ->%%聚丰
%%			spawn(fun() ->
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata("C45CCE588ECC4348A061036B146B8399", rfc4627:encode(EncData))
%%			end);
%%		Server > 1000 ->
%%			spawn(fun() ->
%%				TalinkAppId =
%%					if
%%						%%游戏Fan
%%						Platform =:= 2039 -> "D929CF90E98D43A5AB8FBD7B1DB59F6F";
%%						%%亿客游
%%						Platform =:= 2056 -> "097639BA5C3B46889DE33F23CF5AF90B";
%%						%%奇点网络
%%						Platform =:= 2057 -> "78130FD26DC5401C9EC75D09A738C86A";
%%						%%龙岩公会,改渠道码方式(2888(cps1636)-2700)
%%						Platform =:= 2700 -> "AC500264464C4AA49AFFDD464C78C671";
%%						%%上海清源
%%						Platform >= 3008 andalso Platform =< 3012 -> "BC788C5ED87A4970A69BEE3AA9C2E438";
%%						%%武汉辉腾
%%						Platform =:= 3013 -> "702D3AEDC0DA4FAFAEBE89CA856FD034";
%%						%%聚梦龙图
%%						Platform >= 3014 andalso Platform =< 3015 -> "09A0A542A3014A3A8DC687BB691D3EB2";
%%						Platform =:= 3021 -> "09A0A542A3014A3A8DC687BB691D3EB2";
%%						%%上海臻叙
%%						Platform >= 3016 andalso Platform =< 3018 -> "4FC001F0849E42E2802B03BCC116DF81";
%%						%%墨菲
%%						Platform =:= 3019 -> "74F72D8406BD4CE0B0CF8D6914589F40";
%%						%%Sogagame
%%						Platform =:= 3020 -> "9B469A17B82B4AB0A43EFC74704148BC";
%%						%%搜伯
%%						Platform >= 3022 andalso Platform =< 3023 -> "3914AE6D8DB245AEA30F9AA321A4979B";
%%						%%依然网络
%%						Platform =:= 3024 -> "B79135396D4D4B558451ED247C019091";
%%						%%瑞诺网络:铁血传奇
%%						Platform =:= 3601 -> "9D1121673ADF4FD4944152C1AC201696";
%%						%%武汉点智（皇途霸主）
%%						Platform =:= 3603 -> "668D3C820873430E9AD0C760793B7B90";
%%						%%铁血沙城
%%						true -> "0D3AC93FAACEBDB885DA0362A9580C2D"
%%					end,
%%				EncData = make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete),
%%				post_talkingdata(TalinkAppId, rfc4627:encode(EncData))
%%			end);
%%		true ->
%%			skip
%%	end.

%% 传输数据
post_talkingdata(TalinkAppId, JsonData) ->
	Data = zlib:gzip(util_data:to_binary(JsonData)),
	%%TalinkAppId = "0D3AC93FAACEBDB885DA0362A9580C2D",
	Url = "http://api.talkinggame.com/api/charge/" ++ TalinkAppId,
	httpc:request(post, {Url, [], [], Data}, [], []).

%% 数据封装
make_charge_data(PlayerId, Money, Virtual, Platform, Server, ChargeId, IsIOS, IsComplete) ->
	MsgId = util_data:to_binary(util_data:to_list(Server) ++ "_" ++ util_data:to_list(ChargeId)),
	Status = case IsComplete of
				 true -> <<"success">>;
				 false -> <<"request">>
			 end,
	OS = case IsIOS of
			 true -> <<"ios">>;
			 false -> <<"android">>
		 end,
	AccountId = util_data:to_binary(PlayerId),
	OrderID = MsgId,
	CurrencyAmount = Money,
	CurrencyType = <<"CNY">>,
	VirtualCurrencyAmount = Virtual,
	ChargeTime = util_date:unixtime(),
	IapID = <<"">>,
	PaymentType = util_data:to_binary(xmerl_ucs:to_utf8("PaymentType") ++ util_data:to_list(Platform)),
	GameServer = util_data:to_binary("server_" ++ util_data:to_list(Server)),
	GameVersion = util_data:to_binary("0.0.9"),
	Level = 1,
	Mission = util_data:to_binary(xmerl_ucs:to_utf8("Mission")),
	Partner = <<"">>,
	EncData = [{obj, [{"msgID", MsgId}, {"status", Status}, {"OS", OS},
		{"accountID", AccountId}, {"orderID", OrderID}, {"currencyAmount", CurrencyAmount},
		{"currencyType", CurrencyType}, {"virtualCurrencyAmount", VirtualCurrencyAmount}, {"chargeTime", ChargeTime},
		{"iapID", IapID}, {"paymentType", PaymentType}, {"gameServer", GameServer}, {"gameVersion", GameVersion}, {"level", Level},
		{"mission", Mission}, {"partner", Partner}
	]}],
	EncData.


%% 传输数据到热云
post_reyun(JsonData) ->
	Data = util_data:to_binary(JsonData),
	Url = "http://log.reyun.com/receive/rest/payment",
	Header = "content-type: application/json; charset=UTF-8",
	httpc:request(post, {Url, [], Header, Data}, [], []).

%% 热云数据封装
make_reyun_data(PlayerId, Money, Virtual, Platform, Server, ChargeId) ->
	AppId = <<"b3ec73f62acc1f38f2203a558fd231ca">>,
	Who = util_data:to_binary(PlayerId),				%%账户ID
	Deviceid = util_data:to_binary(PlayerId),			%%设备ID
	Transactionid = util_data:to_binary(ChargeId),		%%交易的流水号
	Paymenttype	= util_data:to_binary(xmerl_ucs:to_utf8("PaymentType") ++ util_data:to_list(Platform)),		%%支付类型
	Currencytype = <<"CNY">>,							%%货币类型
	Currencyamount = util_data:to_binary(Money),		%%支付的真实货币的金额
	Virtualcoinamount = util_data:to_binary(Virtual),	%%通过充值获得的游戏内货币的数量
	Iapname = 	util_data:to_binary(xmerl_ucs:to_utf8("Iap") ++ util_data:to_list(Virtual)), 	%%游戏内购买道具的名称
	Iapamount = util_data:to_binary(Virtual),			%%游戏内购买道具的数量
	Serverid = util_data:to_binary(Server), 			%%服务器ID
	Channelid = util_data:to_binary(Platform),			%%渠道ID
	EncData = {obj, [{"appid", AppId}, {"who", Who}, {"context", {obj, [{"deviceid", Deviceid}, {"transactionid", Transactionid}, {"paymenttype", Paymenttype},
		{"currencytype", Currencytype}, {"currencyamount", Currencyamount}, {"virtualcoinamount", Virtualcoinamount},
		{"iapname", Iapname}, {"iapamount", Iapamount}, {"serverid", Serverid},
		{"channelid", Channelid}
	]} }]},
	EncData.