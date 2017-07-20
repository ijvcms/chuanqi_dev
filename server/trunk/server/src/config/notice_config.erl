%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(notice_config).

-include("common.hrl").
-include("notice_config.hrl").

-compile([export_all]).

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76].

get(1) ->
	#notice_conf{
		notice_id = 1,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffd200' size='20'>大陆的某个地方有BOSS刷新了，大家赶紧过去消灭他吧！</font>")
	};

get(2) ->
	#notice_conf{
		notice_id = 2,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>BOSS%s</font>们准备降临大陆，请勇士%s做好准备。~</font>")
	};

get(3) ->
	#notice_conf{
		notice_id = 3,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>夜深人静，BOSS们不再刷新，大家注意休息~</font>")
	};

get(4) ->
	#notice_conf{
		notice_id = 4,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>%s在<font color='0xf5f146' size='20'>%s</font>被击杀，掉落了%s</font>")
	};

get(5) ->
	#notice_conf{
		notice_id = 5,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>今天晚上<font color='0x00ff00' size='20'>21:00开启攻城战</font>，所有玩家都可以通过攻城战界面直接传送进入，活动奖励丰富，请踊跃参加</font>")
	};

get(6) ->
	#notice_conf{
		notice_id = 6,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x00ff00' size='20'>30分钟后</font>开启攻城战，各大行会勇士可以提前进入沙漠皇城占据有利位置，大战一触即发</font>")
	};

get(7) ->
	#notice_conf{
		notice_id = 7,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>攻城战正式开始，完全占领皇宫的行会将会获得最高荣誉</font>")
	};

get(8) ->
	#notice_conf{
		notice_id = 8,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0xf5f146' size='20'>%s</font>临时占领了沙城皇宫，该行会可以使用防守复活点，活动结束时临时占领行会将成为最终胜利者</font>")
	};

get(9) ->
	#notice_conf{
		notice_id = 9,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>经过激烈的战斗，<font color='0xf5f146' size='20'>%s</font>成为了皇城主宰，获得至高无上的荣誉</font>")
	};

get(10) ->
	#notice_conf{
		notice_id = 10,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>各大行会实力相当，没有分出胜负，至高无上的荣誉暂时悬空!</font>")
	};

get(11) ->
	#notice_conf{
		notice_id = 11,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>BOSS <font color='0xff0303' size='20'>%s</font>出现在<font color='0x02e5f9' size='20'>%s</font>，难道就没人可以收拾他了吗？</font>")
	};

get(12) ->
	#notice_conf{
		notice_id = 12,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>%s</font>在<font color='0x02f9b0' size='20'>%s</font>被击败，但他还会再来的！</font>")
	};

get(13) ->
	#notice_conf{
		notice_id = 13,
		broadcast_type = 1,
		priority = 1,
		content = <<"<font color='0xffffff' size='20'>%s</font>">>
	};

get(14) ->
	#notice_conf{
		notice_id = 14,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>行会BOSS</font>已经刷新了，大家赶紧过去通过行会活动界面进去挑战吧！</font>")
	};

get(15) ->
	#notice_conf{
		notice_id = 15,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>行会秘境</font>已经开启了，大家赶紧过去通过行会活动界面进去挑战吧！</font>")
	};

get(16) ->
	#notice_conf{
		notice_id = 16,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>沙城秘境</font>已经开启了，大家赶紧过去通过行会活动界面进去挑战吧！</font>")
	};

get(17) ->
	#notice_conf{
		notice_id = 17,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>恭喜<font color='0x00ff4e' size='20'>%s</font>将<font color='0xffae00' size='20'>%s</font>强化到%s，战力飙升</font>")
	};

get(18) ->
	#notice_conf{
		notice_id = 18,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xfed701' size='20'>%s在%s被%s击杀，掉落了<font color='0xfea201' size='20'>%s</font></font>")
	};

get(19) ->
	#notice_conf{
		notice_id = 19,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>未知暗殿</font>大门已开启，英勇的战士们啊，快去挑战这未知的世界吧！</font>")
	};

get(20) ->
	#notice_conf{
		notice_id = 20,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>未知暗殿</font>大门即将关闭，下次再来挑战吧！</font>")
	};

get(21) ->
	#notice_conf{
		notice_id = 21,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>至尊魔龙</font>已降临，勇士们啊，赶紧去给点颜色它瞧瞧！</font>")
	};

get(22) ->
	#notice_conf{
		notice_id = 22,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>屠龙大会已结束，请期待下一次屠龙盛宴吧！</font>")
	};

get(23) ->
	#notice_conf{
		notice_id = 23,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>至尊魔龙</font>已被击败，自尊心倍受打击的它将会变得更加强大哦！</font>")
	};

get(24) ->
	#notice_conf{
		notice_id = 24,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff size='20'><font color='0x00ff00' size='20'>胜者为王</font>活动已开启，快拿起你饥渴的大刀，登上霸者擂台吧！</font>")
	};

get(25) ->
	#notice_conf{
		notice_id = 25,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>恭喜<font color='0x00ff4e' size='20'>%s</font>决战到最后，成为今天胜者为王的霸主！</font>")
	};

get(26) ->
	#notice_conf{
		notice_id = 26,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>胜者为王活动已结束，没有得到名次的玩家请再接再厉！</font>")
	};

get(27) ->
	#notice_conf{
		notice_id = 27,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>全服第一战士<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font>")
	};

get(28) ->
	#notice_conf{
		notice_id = 28,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>全服第一法师<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font>")
	};

get(29) ->
	#notice_conf{
		notice_id = 29,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>全服第一道士<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font>")
	};

get(30) ->
	#notice_conf{
		notice_id = 30,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffea00' size='20'>君临天下的皇城主宰者<font color='0xff8400' size='20'>%s</font>上线了，小的们赶紧跟上！</font>")
	};

get(31) ->
	#notice_conf{
		notice_id = 31,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff8400' size='20'>%s</font>行会向<font color='0xff8400' size='20'>%s</font>行会宣战成功，1小时内两个行会成员战斗不会产生PK值</font>")
	};

get(32) ->
	#notice_conf{
		notice_id = 32,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xff3000' size='20'>%s行会的%s%s在%s被击杀，甚是耻辱</font>")
	};

get(33) ->
	#notice_conf{
		notice_id = 33,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>恭喜<font color='0xff8400' size='20'>%s</font>在行会战中击败<font color='0xff8400' size='20'>%s</font>，期间他们一共击败了敌对行会成员%s次</font>")
	};

get(34) ->
	#notice_conf{
		notice_id = 34,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff8400' size='20'>%s</font>与<font color='0xff8400' size='20'>%s</font>势均力敌，杀敌数%s：%s，行会战打成了平手</font>")
	};

get(35) ->
	#notice_conf{
		notice_id = 35,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>怪物攻城活动开启，大量怪物进攻沙漠皇城，大家可以通过活动入口进入皇城保卫龙柱！</font>")
	};

get(36) ->
	#notice_conf{
		notice_id = 36,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>很遗憾,大量的怪物把皇城龙柱破坏了，整个大陆受到前所未有的伤害。</font>")
	};

get(37) ->
	#notice_conf{
		notice_id = 37,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>进攻皇城的怪物已经全部被勇士们击败，大家将会获得大量奖励。</font>")
	};

get(38) ->
	#notice_conf{
		notice_id = 38,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第%s波怪物已经刷新，请赶紧阻止它们破坏龙柱。</font>")
	};

get(39) ->
	#notice_conf{
		notice_id = 39,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第%s波怪物已经被消灭，大量宝箱降临。</font>")
	};

get(40) ->
	#notice_conf{
		notice_id = 40,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'><font color='0xff0303' size='20'>%s</font>出现在<font color='0x02e5f9' size='20'>%s</font>，击杀可获得大量宝物！</font>")
	};

get(41) ->
	#notice_conf{
		notice_id = 41,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0xff0303' size='20'>%s</font>为求保命丢下大量宝物，但它还会再来的！</font>")
	};

get(42) ->
	#notice_conf{
		notice_id = 42,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>%s在%s被击杀，掉落了<font color='0xffae00' size='20'>%s</font></font>")
	};

get(43) ->
	#notice_conf{
		notice_id = 43,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>%s在%s挖宝的时候发现了<font color='0xffae00' size='20'>%s</font>，笑的合不拢嘴了。</font>")
	};

get(44) ->
	#notice_conf{
		notice_id = 44,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>%s在挖宝的时候挖出了千年尸王，并从它身上摸出了<font color='0xffae00' size='20'>%s</font>，真是走狗屎运了！</font>")
	};

get(45) ->
	#notice_conf{
		notice_id = 45,
		broadcast_type = 1,
		priority = 2,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>%s在智慧答题中力压群雄，夺得第一！真是太厉害啦！</font>")
	};

get(46) ->
	#notice_conf{
		notice_id = 46,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'>跨服活动-<font color='0x02e5f9' size='20'>火龙神殿</font>开启，各个服务器的勇士们可以通过限时活动或活动按钮进入跨服地图，与所有服务器玩家一起PK打宝！</font>")
	};

get(47) ->
	#notice_conf{
		notice_id = 47,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第1阶段杀怪目标达成，刷新第一层精英。</font>")
	};

get(48) ->
	#notice_conf{
		notice_id = 48,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第1阶段杀怪目标达成，刷新第二层BOSS。</font>")
	};

get(49) ->
	#notice_conf{
		notice_id = 49,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第2阶段杀怪目标达成，刷新第三层BOSS。</font>")
	};

get(50) ->
	#notice_conf{
		notice_id = 50,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第3阶段杀怪目标达成，刷新第二层BOSS。</font>")
	};

get(51) ->
	#notice_conf{
		notice_id = 51,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第4阶段杀怪目标达成，刷新第三层BOSS。</font>")
	};

get(52) ->
	#notice_conf{
		notice_id = 52,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>与<font color='0x00ff0d' size='20'>%s服%s</font>双方成功缔结同盟，势力更强大了！</font>")
	};

get(53) ->
	#notice_conf{
		notice_id = 53,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>、<font color='0x00ff0d' size='20'>%s服%s</font>、<font color='0x00ff0d' size='20'>%s服%s</font>缔结三方同盟，独霸一方！</font>")
	};

get(54) ->
	#notice_conf{
		notice_id = 54,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>与<font color='0x00ff0d' size='20'>%s服%s</font>解除联盟关系</font>")
	};

get(55) ->
	#notice_conf{
		notice_id = 55,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>脱离与<font color='0x00ff0d' size='20'>%s服%s</font>和<font color='0x00ff0d' size='20'>%s服%s</font>的三方同盟</font>")
	};

get(56) ->
	#notice_conf{
		notice_id = 56,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>跨服神秘暗殿</font>已开启，各个服务器的勇士们可以通过活动按钮进入跨服地图，与所有服务器玩家一起杀怪打宝！</font>")
	};

get(57) ->
	#notice_conf{
		notice_id = 57,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>跨服神秘暗殿</font>大门即将关闭，各位勇士请明天同一时间再来挑战吧！</font>")
	};

get(58) ->
	#notice_conf{
		notice_id = 58,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'>跨服活动-<font color='0x02e5f9' size='20'>火龙神殿</font>现已关闭，来自各服务器的勇士们，请明天同一时间再来挑战吧！</font>")
	};

get(59) ->
	#notice_conf{
		notice_id = 59,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>周末福利-<font color='0x02e5f9' size='20'>未知暗殿</font>大门已开启，英勇的战士们啊，快去挑战这未知的世界吧！</font>")
	};

get(60) ->
	#notice_conf{
		notice_id = 60,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffffff' size='20'>周末福利-<font color='0x02e5f9' size='20'>未知暗殿</font>大门即将关闭，下次再来挑战吧！</font>")
	};

get(61) ->
	#notice_conf{
		notice_id = 61,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'>周末福利-<font color='0x02e5f9' size='20'>跨服神秘暗殿</font>已开启，各个服务器的勇士们可以通过活动按钮进入跨服地图，与所有服务器玩家一起杀怪打宝！</font>")
	};

get(62) ->
	#notice_conf{
		notice_id = 62,
		broadcast_type = 1,
		priority = 3,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'>周末福利-<font color='0x02e5f9' size='20'>跨服神秘暗殿</font>大门即将关闭，各位勇士请下次再来挑战吧！</font>")
	};

get(63) ->
	#notice_conf{
		notice_id = 63,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>全服双倍经验</font>现已开启，击杀野外怪物均可享受双倍经验奖励，可与多倍经验进行叠加</font>")
	};

get(64) ->
	#notice_conf{
		notice_id = 64,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>全服双倍经验</font>现已结束，请明天同一时间再来吧！</font>")
	};

get(65) ->
	#notice_conf{
		notice_id = 65,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>杀怪目标达成，出现终极火龙BOSS。</font>")
	};

get(66) ->
	#notice_conf{
		notice_id = 66,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第5阶段杀怪目标达成，刷新第二层BOSS。</font>")
	};

get(67) ->
	#notice_conf{
		notice_id = 67,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>第6阶段杀怪目标达成，刷新第三层BOSS。</font>")
	};

get(68) ->
	#notice_conf{
		notice_id = 68,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>火龙神殿</font>已经开启，各位勇士们快来挑战吧！</font>")
	};

get(69) ->
	#notice_conf{
		notice_id = 69,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>火龙神殿</font>现已关闭，请下回再来挑战吧！</font>")
	};

get(70) ->
	#notice_conf{
		notice_id = 70,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>跨服幻境之地</font>已开启，快去寻找幻境里的秘宝吧！</font>")
	};

get(71) ->
	#notice_conf{
		notice_id = 71,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>跨服幻境之地</font>已关闭，明天再来吧！</font>")
	};

get(72) ->
	#notice_conf{
		notice_id = 72,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>%s在幻境之间发现了幻金宝箱，采集获得了%s真是运气爆棚！</font>")
	};

get(73) ->
	#notice_conf{
		notice_id = 73,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'>%s小心翼翼地打开了幻金宝箱，翻出了<font color='0xf0f314' size='20'>%s</font></font>")
	};

get(74) ->
	#notice_conf{
		notice_id = 74,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>幻境之地</font>已开启，快去寻找幻境里的秘宝吧！</font>")
	};

get(75) ->
	#notice_conf{
		notice_id = 75,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>幻境之地</font>已关闭，明天再来吧！</font>")
	};

get(76) ->
	#notice_conf{
		notice_id = 76,
		broadcast_type = 1,
		priority = 1,
		content = xmerl_ucs:to_utf8("<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>%s</font>在变异地宫击杀的怪物突发变异成<font color='0x02e5f9' size='20'>%s</font></font>")
	};

get(_Key) ->
	?ERR("undefined key from notice_config ~p", [_Key]).