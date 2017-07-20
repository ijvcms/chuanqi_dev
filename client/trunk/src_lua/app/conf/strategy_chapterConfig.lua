-- 自动生成，请勿修改 
-- 时间：2016/07/26
-- 21102585@qq.com

local strategy_chapterConfig = class("strategy_chapterConfig")
function strategy_chapterConfig:ctor()
	self.fields = {"id", "strategy_id", "chapter_type", "title", "level", "icon_file", "content", "button_label", "function_id"}
	self.datas = {
		[1] = {1, 1001, 1, "1-15级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>新手任务进行快速升级，骷髅洞野外打怪</font>", "", 0},
		[2] = {2, 1001, 1, "16-29级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>奥玛寺庙任务，打怪升级</font>", "", 0},
		[3] = {3, 1001, 1, "30级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>挂机开启，一键扫荡快速升级</font>", "前往挂机", 22},
		[4] = {4, 1001, 1, "35级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>日常任务开启，完成获取大量经验</font>", "日常任务", 36},
		[5] = {5, 1001, 1, "30-37级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>蜈蚣洞任务、打怪升级</font>", "膜拜英雄", 24},
		[6] = {6, 1001, 1, "38级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>膜拜英雄开启，前往膜拜可获取大量经验</font>", "", 0},
		[7] = {7, 1001, 1, "40级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>挑战个人副本，轻松获取经验、金币、强化材料</font>", "个人副本", 26},
		[8] = {8, 1001, 1, "40级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>胜者为王开启，可前往参与pk乱斗</font>", "胜者为王", 39},
		[9] = {9, 1001, 1, "41级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>攻城战开启，攻城日可参与，共夺霸主之位</font>", "攻城战", 16},
		[10] = {10, 1001, 1, "42级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>神秘暗殿开启，前往挑战获取大量装备</font>", "神秘暗殿", 37},
		[11] = {11, 1001, 1, "43-44级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>野猪洞任务、打怪升级</font>", "", 0},
		[12] = {12, 1001, 1, "45级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>屠龙大会开启，参与击杀获得大量奖励</font>", "屠龙大会", 38},
		[13] = {13, 1001, 1, "46-49级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>蜈蚣洞2层任务、打怪升级</font>", "", 0},
		[14] = {14, 1001, 1, "50级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>怪物攻城开启，可前往保卫皇城龙柱</font>", "怪物攻城", 75},
		[15] = {15, 1001, 1, "51-56级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>祖玛地宫任务、打怪升级</font>", "", 0},
		[16] = {16, 1001, 1, "57-60级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>赤月地图任务、打怪升级</font>", "", 0},
		[17] = {17, 2001, 2, "", 30, "scene_hangupBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>挂机系统里面，可以挑战BOSS，每次挑战成功会切换到下一张地图，获得更高的挂机经验。</font>", "挂机", 22},
		[18] = {18, 2001, 2, "", 35, "scene_dailytask.png", "<font color='0xDBAE67' size='18' opacity='255'>完成日常任务能获得大量经验，是提升等级的快速途径。</font>", "日常任务", 36},
		[19] = {19, 2001, 2, "", 38, "scene_worshipBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>每日能进行2次英雄膜拜，膜拜英雄可以获得大量经验。</font>", "前往膜拜", 24},
		[20] = {20, 2001, 2, "", 40, "scene_instance.png", "<font color='0xDBAE67' size='18' opacity='255'>个人副本中的经验副本可以获得较多的经验，通关成功还能获取经验丹，加快升级进度。</font>", "个人副本", 26},
		[21] = {21, 2001, 2, "", 45, "scene_dragonBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>屠龙大会能获得大量经验值，击杀至尊魔龙后，还会掉落大量的经验丹。</font>", "屠龙大会", 38},
		[22] = {22, 2002, 2, "", 20, "scene_forge.png", "<font color='0xDBAE67' size='18' opacity='255'>打造装备可获得更高级的装备套装，是获取高阶装备的主流方式，打造材料可以从世界BOSS身上掉落。</font>", "装备打造", 13},
		[23] = {23, 2002, 2, "", 20, "scene_bossBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>每隔一段时间野外地图的深处会刷新实力强劲的世界BOSS，击杀世界BOSS会掉落大量珍稀装备。</font>", "世界BOSS", 25},
		[24] = {24, 2002, 2, "", 35, "scene_unionBossBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>行会BOSS在每天的21：00都会刷新，通过行会进入，击杀可以获得大量装备和道具。</font>", "行会BOSS", 43},
		[25] = {25, 2002, 2, "", 35, "scene_unionAreaBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>3级以上行会可开启行会秘境，每周日21:00开放一次，秘境BOSS有几率掉落高级装备和强化道具。</font>", "行会秘境", 44},
		[26] = {26, 2002, 2, "", 42, "scene_darkPalaceBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>神秘暗殿里的部分怪物会掉落大量高级装备和材料，是前期轻松获取高级装备的捷径。</font>", "神秘暗殿", 37},
		[27] = {27, 2002, 2, "", 50, "scene_monsterAttack.png", "<font color='0xDBAE67' size='18' opacity='255'>怪物攻城里的怪物有较高的几率掉落高级装备和材料，掉落物品的稀有度与波数成正比。</font>", "怪物攻城", 75},
		[28] = {28, 2002, 2, "", 35, "scene_storeBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>商城可以购买战神、法神、天尊武器箱，打开后可以获得极品的稀有装备。</font>", "商城", 21},
		[29] = {29, 2003, 2, "", 10, "scene_strengthen.png", "<font color='0xDBAE67' size='18' opacity='255'>强化装备可以提升装备的基础属性，强化材料可以通过材料副本和怪物掉落获得。</font>", "装备强化", 11},
		[30] = {30, 2003, 2, "", 12, "scene_baptize.png", "<font color='0xDBAE67' size='18' opacity='255'>洗练装备可以获得额外的洗练属性，洗炼属性分白绿蓝紫，装备洗的次数越多，属性出现紫色概率越高；不同部位对应不同的属性类型，洗练石可以通过材料副本和怪物掉落获得。</font>", "装备洗练", 12},
		[31] = {31, 2003, 2, "", 50, "scene_equipSoul.png", "<font color='0xDBAE67' size='18' opacity='255'>装备铸魂可以提升装备的基础属性，铸魂共5个等级，铸魂需要消耗铸魂精华，铸魂精华可以通过分解装备获得。</font>", "装备铸魂", 69},
		[32] = {32, 2003, 2, "", 38, "scene_medal.png", "<font color='0xDBAE67' size='18' opacity='255'>消耗功勋值升级勋章获得大量属性。功勋可以通过完成每日功勋任务、胜者为王获得，如果使用一键完成，可以额外获得大量功勋。</font>", "勋章升级", 33},
		[33] = {33, 2004, 2, "", 35, "scene_instance.png", "<font color='0xDBAE67' size='18' opacity='255'>每天可以进行1次金币副本、1次购买机会。</font>", "金币副本", 26},
		[34] = {34, 2004, 2, "", 35, "scene_qualifyingBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>在排位赛每次挑战别的玩家可以获得声望，每天根据排名也会给予大量声望奖励，声望可以在竞技场商店购买物品</font>", "排位赛", 18},
		[35] = {35, 2004, 2, "", 35, "scene_hangupBtn.png", "<font color='0xDBAE67' size='18' opacity='255'>野外打怪和挂机产出的不需要的装备，可以在背包出售，获得金币。</font>", "", 0},
		[36] = {36, 3001, 3, "坐骑", "", "", "<font color='0xDBAE67' size='18' opacity='255'>上马下马：装备坐骑后，向上滑动屏幕为上马操作，向下滑动为下马操作；<br/>坐骑可在商城购买或VIP赠送。<br/>在设置界面可以关闭自动上马哦！</font>", "商城", 21},
		[37] = {37, 3001, 3, "诱惑之光", "", "", "<font color='0xDBAE67' size='18' opacity='255'>法师可以通过击杀世界BOSS获得诱惑之光技能书，可以同时诱惑多个怪物作为自己的伙伴作战，并且可以升级。</font>", "世界BOSS", 25},
		[38] = {38, 3001, 3, "迷阵走法", "", "", "<font color='0xDBAE67' size='18' opacity='255'>石墓迷阵走法：上下上下上下。<br/>祖玛迷阵走法：左上上上右。</font>", "", 0},
		[39] = {39, 3002, 3, "可诱惑怪物：", "", "", "<font color='0xDBAE67' size='18' opacity='255'>银杏村&#58;鹿&#40;Lv1&#41;<br/>蜈蚣洞&#58;蜈蚣&#40;Lv24&#41;&#59;跳跳蜂&#40;Lv26&#41;&#59;钢甲钳虫&#40;Lv30&#41;<br/>野猪洞&#58;黑色恶蛆&#40;Lv30&#41;<br/>虎卫堂&#58;虎卫&#40;Lv1&#41;<br/>迷失森林&#58;天狼蜘蛛&#40;Lv35&#41;&#59;鹰卫&#40;Lv1&#41;</font>", "", 0},
		[40] = {40, 3002, 3, "神兽升级", "", "", "<font color='0xDBAE67' size='18' opacity='255'>道士的神兽通过计算击杀怪物的数量可以提升等级，等级越高能力越强。</font>", "", 0},
		[41] = {41, 3002, 3, "虎卫鹰卫", "", "", "<font color='0xDBAE67' size='18' opacity='255'>在虎卫堂每隔一段时间会刷新实力劲爆的虎卫法师可以诱惑之；远程攻击的鹰卫刷新在迷失森林。</font>", "", 0},

	}
end
return strategy_chapterConfig
