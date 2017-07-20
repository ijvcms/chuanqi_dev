%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%        自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

%% ===================================================================
%% define
%% ===================================================================
-define(NOTICE_BOSS_BEFALL, 1).  %%<font color='0xffd200' size='20'>大陆的某个地方有BOSS刷新了，大家赶紧过去消灭他吧！</font> 
-define(NOTICE_TEST, 2).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>BOSS%s</font>们准备降临大陆，请勇士%s做好准备。~</font> 
-define(NOTICE_BOSS_REST, 3).  %%<font color='0xffffff' size='20'>夜深人静，BOSS们不再刷新，大家注意休息~</font> 
-define(NOTICE_PLAYER_DIE, 4).  %%<font color='0x00ff00' size='20'>%s在<font color='0xf5f146' size='20'>%s</font>被击杀，掉落了%s</font> 
-define(NOTICE_SHACHENG_WILL_START_1, 5).  %%<font color='0x00ff00' size='20'>今天晚上<font color='0x00ff00' size='20'>21:00开启攻城战</font>，所有玩家都可以通过攻城战界面直接传送进入，活动奖励丰富，请踊跃参加</font> 
-define(NOTICE_SHACHENG_WILL_START_2, 6).  %%<font color='0x00ff00' size='20'><font color='0x00ff00' size='20'>30分钟后</font>开启攻城战，各大行会勇士可以提前进入沙漠皇城占据有利位置，大战一触即发</font> 
-define(NOTICE_SHACHENG_START, 7).  %%<font color='0x00ff00' size='20'>攻城战正式开始，完全占领皇宫的行会将会获得最高荣誉</font> 
-define(NOTICE_SHACHENG_TEMP_OCCUPY, 8).  %%<font color='0x00ff00' size='20'><font color='0xf5f146' size='20'>%s</font>临时占领了沙城皇宫，该行会可以使用防守复活点，活动结束时临时占领行会将成为最终胜利者</font> 
-define(NOTICE_SHACHENG_OCCUPY, 9).  %%<font color='0x00ff00' size='20'>经过激烈的战斗，<font color='0xf5f146' size='20'>%s</font>成为了皇城主宰，获得至高无上的荣誉</font> 
-define(NOTICE_SHACHENG_NOT_OCCUPY, 10).  %%<font color='0x00ff00' size='20'>各大行会实力相当，没有分出胜负，至高无上的荣誉暂时悬空!</font> 
-define(NOTICE_WORD_BOSS_REF, 11).  %%<font color='0xffffff' size='20'>BOSS <font color='0xff0303' size='20'>%s</font>出现在<font color='0x02e5f9' size='20'>%s</font>，难道就没人可以收拾他了吗？</font> 
-define(NOTICE_WORD_BOSS_DIE, 12).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>%s</font>在<font color='0x02f9b0' size='20'>%s</font>被击败，但他还会再来的！</font> 
-define(NOTICE_BACK, 13).  %%<font color='0xffffff' size='20'>%s</font> 
-define(NOTICE_GUILD_BOSS, 14).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>行会BOSS</font>已经刷新了，大家赶紧过去通过行会活动界面进去挑战吧！</font> 
-define(NOTICE_GUILD_MJ, 15).  %%<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>行会秘境</font>已经开启了，大家赶紧过去通过行会活动界面进去挑战吧！</font> 
-define(NOTICE_SBK_OPEN, 16).  %%<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>沙城秘境</font>已经开启了，大家赶紧过去通过行会活动界面进去挑战吧！</font> 
-define(NOTICE_EQUIPS_STREN, 17).  %%<font color='0xffffff' size='20'>恭喜<font color='0x00ff4e' size='20'>%s</font>将<font color='0xffae00' size='20'>%s</font>强化到%s，战力飙升</font> 
-define(NOTICE_MONSTER_LOOT, 18).  %%<font color='0xfed701' size='20'>%s在%s被%s击杀，掉落了<font color='0xfea201' size='20'>%s</font></font> 
-define(NOTICE_WZAD_OPEN, 19).  %%<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>未知暗殿</font>大门已开启，英勇的战士们啊，快去挑战这未知的世界吧！</font> 
-define(NOTICE_WZAD_CLOSE, 20).  %%<font color='0xffffff' size='20'><font color='0x02e5f9' size='20'>未知暗殿</font>大门即将关闭，下次再来挑战吧！</font> 
-define(NOTICE_TLDH_OPEN, 21).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>至尊魔龙</font>已降临，勇士们啊，赶紧去给点颜色它瞧瞧！</font> 
-define(NOTICE_TLDH_CLOSE, 22).  %%<font color='0xffffff' size='20'>屠龙大会已结束，请期待下一次屠龙盛宴吧！</font> 
-define(NOTICE_TLDH_KILL, 23).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>至尊魔龙</font>已被击败，自尊心倍受打击的它将会变得更加强大哦！</font> 
-define(NOTICE_SZWW_OPEN, 24).  %%<font color='0xffffff size='20'><font color='0x00ff00' size='20'>胜者为王</font>活动已开启，快拿起你饥渴的大刀，登上霸者擂台吧！</font> 
-define(NOTICE_SZWW_WIN, 25).  %%<font color='0xffffff' size='20'>恭喜<font color='0x00ff4e' size='20'>%s</font>决战到最后，成为今天胜者为王的霸主！</font> 
-define(NOTICE_SZWW_CLOSE, 26).  %%<font color='0xffffff' size='20'>胜者为王活动已结束，没有得到名次的玩家请再接再厉！</font> 
-define(NOTICE_CAREER_ZHANSHI, 27).  %%<font color='0xffffff' size='20'>全服第一战士<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font> 
-define(NOTICE_CAREER_FASHI, 28).  %%<font color='0xffffff' size='20'>全服第一法师<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font> 
-define(NOTICE_CAREER_DAOSHI, 29).  %%<font color='0xffffff' size='20'>全服第一道士<font color='0xffcc00' size='20'>%s</font>上线，大家顶礼膜拜吧！</font> 
-define(NOTICE_CITY_TITLE, 30).  %%<font color='0xffea00' size='20'>君临天下的皇城主宰者<font color='0xff8400' size='20'>%s</font>上线了，小的们赶紧跟上！</font> 
-define(NOTICE_GUILD_CHALLENGE_BEGIN, 31).  %%<font color='0xffffff' size='20'><font color='0xff8400' size='20'>%s</font>行会向<font color='0xff8400' size='20'>%s</font>行会宣战成功，1小时内两个行会成员战斗不会产生PK值</font> 
-define(NOTICE_GUILD_CHALLENGE_KILL, 32).  %%<font color='0xff3000' size='20'>%s行会的%s%s在%s被击杀，甚是耻辱</font> 
-define(NOTICE_GUILD_CHALLENGE_WIN, 33).  %%<font color='0xffffff' size='20'>恭喜<font color='0xff8400' size='20'>%s</font>在行会战中击败<font color='0xff8400' size='20'>%s</font>，期间他们一共击败了敌对行会成员%s次</font> 
-define(NOTICE_GUILD_CHALLENGE_DRAW, 34).  %%<font color='0xffffff' size='20'><font color='0xff8400' size='20'>%s</font>与<font color='0xff8400' size='20'>%s</font>势均力敌，杀敌数%s：%s，行会战打成了平手</font> 
-define(NOTICE_MONSTER_ATK_OPEN, 35).  %%<font color='0x00ff00' size='20'>怪物攻城活动开启，大量怪物进攻沙漠皇城，大家可以通过活动入口进入皇城保卫龙柱！</font> 
-define(NOTICE_MONSTER_ATK_LOSE, 36).  %%<font color='0xffffff' size='20'>很遗憾,大量的怪物把皇城龙柱破坏了，整个大陆受到前所未有的伤害。</font> 
-define(NOTICE_MONSTER_ATK_WIN, 37).  %%<font color='0x00ff00' size='20'>进攻皇城的怪物已经全部被勇士们击败，大家将会获得大量奖励。</font> 
-define(NOTICE_MONSTER_ATK_REFUSE, 38).  %%<font color='0x00ff00' size='20'>第%s波怪物已经刷新，请赶紧阻止它们破坏龙柱。</font> 
-define(NOTICE_MONSTER_ATK_REFUSE_BOX, 39).  %%<font color='0x00ff00' size='20'>第%s波怪物已经被消灭，大量宝箱降临。</font> 
-define(NOTICE_RANDOM_BOSS_REF, 40).  %%<font color='0xffffff' size='20'><font color='0xff0303' size='20'>%s</font>出现在<font color='0x02e5f9' size='20'>%s</font>，击杀可获得大量宝物！</font> 
-define(NOTICE_RANDOM_BOSS_DIE, 41).  %%<font color='0x00ff00' size='20'><font color='0xff0303' size='20'>%s</font>为求保命丢下大量宝物，但它还会再来的！</font> 
-define(NOTICE_RANDOM_BOSS_LOOT, 42).  %%<font color='0xffffff' size='20'>%s在%s被击杀，掉落了<font color='0xffae00' size='20'>%s</font></font> 
-define(NOTICE_XUNBAO, 43).  %%<font color='0xffffff' size='20'>%s在%s挖宝的时候发现了<font color='0xffae00' size='20'>%s</font>，笑的合不拢嘴了。</font> 
-define(NOTICE_XUNBAO_KILL, 44).  %%<font color='0xffffff' size='20'>%s在挖宝的时候挖出了千年尸王，并从它身上摸出了<font color='0xffae00' size='20'>%s</font>，真是走狗屎运了！</font> 
-define(NOTICE_EXAM, 45).  %%<font color='0x00ff00' size='20'>%s在智慧答题中力压群雄，夺得第一！真是太厉害啦！</font> 
-define(NOTICE_CROSS, 46).  %%<font color='0xffae00' size='20'>跨服活动-<font color='0x02e5f9' size='20'>火龙神殿</font>开启，各个服务器的勇士们可以通过限时活动或活动按钮进入跨服地图，与所有服务器玩家一起PK打宝！</font> 
-define(NOTICE_CROSS_BOSS_1, 47).  %%<font color='0x00ff00' size='20'>第1阶段杀怪目标达成，刷新第一层精英。</font> 
-define(NOTICE_CROSS_BOSS_2, 48).  %%<font color='0x00ff00' size='20'>第1阶段杀怪目标达成，刷新第二层BOSS。</font> 
-define(NOTICE_CROSS_BOSS_3, 49).  %%<font color='0x00ff00' size='20'>第2阶段杀怪目标达成，刷新第三层BOSS。</font> 
-define(NOTICE_CROSS_BOSS_4, 50).  %%<font color='0x00ff00' size='20'>第3阶段杀怪目标达成，刷新第二层BOSS。</font> 
-define(NOTICE_CROSS_BOSS_5, 51).  %%<font color='0x00ff00' size='20'>第4阶段杀怪目标达成，刷新第三层BOSS。</font> 
-define(NOTICE_UNION_1, 52).  %%<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>与<font color='0x00ff0d' size='20'>%s服%s</font>双方成功缔结同盟，势力更强大了！</font> 
-define(NOTICE_UNION_2, 53).  %%<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>、<font color='0x00ff0d' size='20'>%s服%s</font>、<font color='0x00ff0d' size='20'>%s服%s</font>缔结三方同盟，独霸一方！</font> 
-define(NOTICE_UNION_3, 54).  %%<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>与<font color='0x00ff0d' size='20'>%s服%s</font>解除联盟关系</font> 
-define(NOTICE_UNION_4, 55).  %%<font color='0x00ff00' size='20'><font color='0x00ff0d' size='20'>%s服%s</font>脱离与<font color='0x00ff0d' size='20'>%s服%s</font>和<font color='0x00ff0d' size='20'>%s服%s</font>的三方同盟</font> 
-define(NOTICE_CROSS_PALACE, 56).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>跨服神秘暗殿</font>已开启，各个服务器的勇士们可以通过活动按钮进入跨服地图，与所有服务器玩家一起杀怪打宝！</font> 
-define(NOTICE_CROSS_PALACE_CLOSE, 57).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>跨服神秘暗殿</font>大门即将关闭，各位勇士请明天同一时间再来挑战吧！</font> 
-define(NOTICE_CROSS_CLOSE, 58).  %%<font color='0xffae00' size='20'>跨服活动-<font color='0x02e5f9' size='20'>火龙神殿</font>现已关闭，来自各服务器的勇士们，请明天同一时间再来挑战吧！</font> 
-define(NOTICE_WZAD_WEEKEND_OPEN, 59).  %%<font color='0xffffff' size='20'>周末福利-<font color='0x02e5f9' size='20'>未知暗殿</font>大门已开启，英勇的战士们啊，快去挑战这未知的世界吧！</font> 
-define(NOTICE_WZAD_WEEKEND_CLOSE, 60).  %%<font color='0xffffff' size='20'>周末福利-<font color='0x02e5f9' size='20'>未知暗殿</font>大门即将关闭，下次再来挑战吧！</font> 
-define(NOTICE_CROSS_WEEKEND_OPEN, 61).  %%<font color='0xffae00' size='20'>周末福利-<font color='0x02e5f9' size='20'>跨服神秘暗殿</font>已开启，各个服务器的勇士们可以通过活动按钮进入跨服地图，与所有服务器玩家一起杀怪打宝！</font> 
-define(NOTICE_CROSS_WEEKEND_CLOSE, 62).  %%<font color='0xffae00' size='20'>周末福利-<font color='0x02e5f9' size='20'>跨服神秘暗殿</font>大门即将关闭，各位勇士请下次再来挑战吧！</font> 
-define(NOTICE__DOUBLE_EXP_OPEN, 63).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>全服双倍经验</font>现已开启，击杀野外怪物均可享受双倍经验奖励，可与多倍经验进行叠加</font> 
-define(NOTICE__DOUBLE_EXP_CLOSE, 64).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>全服双倍经验</font>现已结束，请明天同一时间再来吧！</font> 
-define(NOTICE_LOCAL_BOSS_1, 65).  %%<font color='0x00ff00' size='20'>杀怪目标达成，出现终极火龙BOSS。</font> 
-define(NOTICE_CROSS_BOSS_6, 66).  %%<font color='0x00ff00' size='20'>第5阶段杀怪目标达成，刷新第二层BOSS。</font> 
-define(NOTICE_CROSS_BOSS_7, 67).  %%<font color='0x00ff00' size='20'>第6阶段杀怪目标达成，刷新第三层BOSS。</font> 
-define(NOTICE_NATIVE_BOSS_OPEN, 68).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>火龙神殿</font>已经开启，各位勇士们快来挑战吧！</font> 
-define(NOTICE_NATIVE_BOSS_CLOSE, 69).  %%<font color='0xffae00' size='20'><font color='0x02e5f9' size='20'>火龙神殿</font>现已关闭，请下回再来挑战吧！</font> 
-define(NOTICE_HJZC, 70).  %%<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>跨服幻境之地</font>已开启，快去寻找幻境里的秘宝吧！</font> 
-define(NOTICE_HJZC_END, 71).  %%<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>跨服幻境之地</font>已关闭，明天再来吧！</font> 
-define(NOTICE_HJBX, 72).  %%<font color='0x00ff00' size='20'>%s在幻境之间发现了幻金宝箱，采集获得了%s真是运气爆棚！</font> 
-define(NOTICE_HJBX2, 73).  %%<font color='0x00ff00' size='20'>%s小心翼翼地打开了幻金宝箱，翻出了<font color='0xf0f314' size='20'>%s</font></font> 
-define(NOTICE_NATIVE_HJZC, 74).  %%<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>幻境之地</font>已开启，快去寻找幻境里的秘宝吧！</font> 
-define(NOTICE_NATIVE_HJZC_END, 75).  %%<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>幻境之地</font>已关闭，明天再来吧！</font> 
-define(NOTICE_BYDG, 76).  %%<font color='0x00ff00' size='20'><font color='0x02e5f9' size='20'>%</font>在变异地宫击杀的怪物突发变异成<font color='0x02e5f9' size='20'>%</font></font> 

%% ===================================================================
%% record
%% ===================================================================

-record(notice_conf, {
	notice_id, %% 公告id
	broadcast_type, %% 广播类型
	priority, %% 优先级
	content %% 内容
}).