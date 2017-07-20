--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-08-12 22:11:28
--

--怪物基础配置信息
--id 怪物ID
--name 怪物名称
--atkDis 攻击距离 像素
--resId 模型资源ID 
--atk 攻击
--hp 气血
--skillId 技能ID


--现在使用 MonsterConf   BaseMonsterConf 已废
BaseMonsterConf = {

	-- [1101] = {id = 1101,name = "战士",resId = "1104",atk = 90,hp = 200000,def = 15,mp = 100,skillId = 1101 ,ai = {{1,10002}},},
	-- [1201] = {id = 1201,name = "法师",resId = "1104",atk = 65,hp = 140000,def = 12,mp = 100,skillId = 1201 ,ai = {{1,10002}},},
	-- [1301] = {id = 1301,name = "道士",resId = "1104",atk = 65,hp = 140000,def = 12,mp = 100,skillId = 1301 ,ai = {{1,10002}},},
	-- [1000] = {id = 4001,name = "白猪",resId = "4001",atk = 35,hp = 180,def = 15,mp = 100,skillId = 1101 ,ai = {{1,10002}},},
	-- [4001] = {id = 4001,name = "白猪",resId = "4001",atk = 35,hp = 180,def = 15,mp = 100,skillId = 4001 ,ai = {{1,10002}},},
	-- [4002] = {id = 4002,name = "祖玛",resId = "4002",atk = 30,hp = 160,def = 10,mp = 100,skillId = 4002 ,ai = {{1,10002}},},
	-- [4003] = {id = 4003,name = "虫子",resId = "4003",atk = 25,hp = 100,def = 5,mp = 100,skillId = 4003 ,ai = {{1,10002}},},
	-- [5001] = {id = 5001,name = "僵尸",resId = "5001",atk = 50,hp = 300,def = 20,mp = 100,skillId = 5001 ,ai = {{1,10002}},},

	[1101] = {id = 1101,name = "战士",resId = "1104",atk = 90,hp = 200000,def = 15,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[1201] = {id = 1201,name = "法师",resId = "1104",atk = 65,hp = 140000,def = 12,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[1301] = {id = 1301,name = "道士",resId = "1104",atk = 65,hp = 140000,def = 12,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[1000] = {id = 4001,name = "白猪",resId = "4001",atk = 35,hp = 180,def = 15,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[4001] = {id = 4001,name = "白猪",resId = "4001",atk = 35,hp = 180,def = 15,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[4002] = {id = 4002,name = "祖玛",resId = "4002",atk = 30,hp = 160,def = 10,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[4003] = {id = 4003,name = "虫子",resId = "4003",atk = 25,hp = 100,def = 5,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
	[5001] = {id = 5001,name = "僵尸",resId = "5001",atk = 50,hp = 300,def = 20,mp = 100,skillId = 40100 ,ai = {{1,40100}},},
}


--攻击动作都在脚底 飞行和受击动作才有位置信息
--1 中心 2 脚底 3 头顶
EffPosType = {
	leidian6201 = 2,
	mfadunHurt = 2,
	
	[8103] = 1,
	[8104] = 1,
	[8105] = 1,
	[8106] = 1,
	[8107] = 1,
	[8108] = 1,

	[8201] = 2,
	[8202] = 1,
	[8203] = 2,
	[8204] = 2,
	[8205] = 2,
	[8219] = 2,
	[8208] = 2,
	[8209] = 2,
	[8210] = 1,
	[8211] = 1,
	[8212] = 1,
	[8213] = 1,
	[8214] = 1,
	[8215] = 2,

	[8301] = 1,
	[8302] = 2,
	[8303] = 1,
	[8304] = 2,
	[8305] = 1,
	[8306] = 2,
	[8307] = 1,
	[8308] = 2,
	[8309] = 1,
	[8310] = 2,	
	[8311] = 2,	
}


SkillTargerType = {
	MONSTER = 3,   	--怪物
	SELF = 1,		--自己
	PARTNER = 2,	--伙伴
}

SkillAtkType = {
	SINGLE = 1,   	--单体
	MULTIPLAYER = 2,		--多人
	GROUP_SURFACE = 3,	--群体地表
	GROUP_SKY = 4,		--群体空中
	GROUP_FIRE = 5,		--火墙
}

--技能攻击范围类型
SkillAtkRangeType = {
	R_SINGLE = 1,   	--单体
	R_N_GROUP = 2,	--近身群体
	R_F_GROUP = 3,	--远程群体
}

SkillRange = {
	[1] = {{{0,0}}},--单格单攻
	[2] = {{{0,0},{0,-1},{0,1},{-1,0},{1,0},{1,-1},{-1,-1},{-1,1},{1,1}}},--3*3群攻
	[3] = {
		{{0,0},{0,1},{-1,0},{1,0},{-1,1},{1,1},  {-2,0},{-2,1},{-2,2},{-1,2},{0,2},{1,2},{2,2},{2,1},{2,0}},
		{{0,0},{1,1},{1,0},{0,1},{1,-1},{-1,1}   ,{-2,2},{-1,2},{0,2},{1,2},{2,2},{2,1},{2,0},{2,-1}},
		{{0,0},{1,0},{0,-1},{0,1},{1,-1},{1,1}   ,{0,2},{1,2},{2,2},{2,1},{2,0},{2,-1},{2,-2},{1,-2},{0,-2}},
		{{0,0},{1,-1},{0,-1},{1,0},{-1,-1},{1,1}  ,{2,2},{2,1},{2,0},{2,-1},{2,-2},{1,-2},{0,-2},{-1,-2},{-2,-2}},
		{{0,0},{0,-1},{1,0},{-1,0},{1,-1},{-1,-1}  ,{2,0},{2,-1},{2,-2},{1,-2},{0,-2},{-1,-2},{-2,-2}},
		{{0,0},{-1,-1},{-1,0},{0,-1},{1,-1},{-1,1}  ,{2,-2},{1,-2},{0,-2},{-1,-2},{-2,-2},{-2,-1},{-2,0},{-2,1},{-2,2}},
		{{0,0},{-1,0},{0,-1},{-1,-1},{-1,1},{0,1}  ,{0,-2},{-1,-2},{-2,-2},{-2,-1},{-2,0},{-2,1},{-2,2},{-1,2},{0,2}},
		{{0,0},{-1,1},{-1,0},{0,1},{1,1},{-1,-1}   ,{-2,-2},{-2,-1},{-2,0},{-2,1},{-2,2},{-1,2},{0,2},{1,2},{2,2}},
	},--半月弯刀 周围5格
	[4] = {
		{{0,1},{0,2},{0,3}},
		{{1,1},{2,2},{3,3}},
		{{1,0},{2,0},{3,0}},
		{{1,-1},{2,-2},{3,-3}},
		{{0,-1},{0,-2},{0,-3}},
		{{-1,-1},{-2,-2},{-3,-3}},
		{{-1,0},{-2,0},{-3,0}},
		{{-1,1},{-2,2},{-3,3}},
	},--刺杀剑术 前方1个格子
	[5] = {
		{{0,1},{0,2}     ,{0,3},{0,4},{0,5}},
		{{1,1},{2,2}     ,{3,3},{4,4},{5,5}},
		{{1,0},{2,0}     ,{3,0},{4,0},{5,0}},
		{{1,-1},{2,-2}   ,{3,-3},{4,-4},{5,-5}},
		{{0,-1},{0,-2}   ,{0,-3},{0,-4},{0,-5}},
		{{-1,-1},{-2,-2} ,{-3,-3},{-4,-4},{-5,-5}},
		{{-1,0},{-2,0}   ,{-3,0},{-4,0},{-5,0}},
		{{-1,1},{-2,2}   ,{-3,3},{-4,4},{-5,5}},
	},--野蛮冲撞 前方5格子

	[6] = {
		{{0,1},{0,2}     ,{0,3},{0,4}},
		{{1,1},{2,2}     ,{3,3},{4,4}},
		{{1,0},{2,0}     ,{3,0},{4,0}},
		{{1,-1},{2,-2}   ,{3,-3},{4,-4}},
		{{0,-1},{0,-2}   ,{0,-3},{0,-4}},
		{{-1,-1},{-2,-2} ,{-3,-3},{-4,-4}},
		{{-1,0},{-2,0}   ,{-3,0},{-4,0}},
		{{-1,1},{-2,2}   ,{-3,3},{-4,4}},
	},--逐日剑法 前方4格子
}

--id    		技能ID
--name 			技能名称
--cd 			cd时间
--interval  	间隔时间
--selfBuff      自身Buff
--tarBuff       目标Buff
--tarType   	目标类型（选择攻击目标SkillTargerType）
--hurtEffType  		攻击类型（选择攻击类型SkillAtkType）
--atkDis        攻击距离
--rangeType     攻击伤害范围类型 SkillAtkRangeType
--rangeId       攻击伤害ID
--atkAct   		攻击动作（不同技能使用不同动作）
--atkSound  	攻击声音
--atkEff   		攻击效果
--atkEffType	攻击效果类型（有的效果有8方向）1是单方向 2是8方向
--flyEff   		飞行效果
--hurtEff   	受击效果

FightSkillConf = {
	[10101] = {id=10100, name = "普通攻击"  ,cd = 1500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff="cisha6101"			,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[10201] = {id=10200, name = "攻杀剑法"  ,cd = 1500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff="cisha6101"			,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[10301] = {id=10300, name = "刺杀剑法"  ,cd = 1500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff="8003"			,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[10401] = {id=10400, name = "半月剑法"  ,cd = 1500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff="8004"		,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[10501] = {id=10500, name = "烈焰剑法"  ,cd = 3500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct=""	,atkSound = "hit"	,atkEff=""		,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[10601] = {id=10600, name = "野蛮冲撞"  ,cd = 3500,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct=""	,atkSound = "hit"	,atkEff=""		,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	
	[20101] = {id=20100, name = "火球术  "  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 3,rangeType = 2,tarType = 1,hurtEffType = 1,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = "8201"				,hurtEff = "8202"},
	[20201] = {id=20200, name = "雷电术  "  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = "leidian6201"},
	[20301] = {id=20300, name = "火墙"  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 3,atkDis = 1,atkAct="attack1"	,atkSound = "hit"	,atkEff="8204"			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[20401] = {id=20400, name = "魔法盾  "  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 4,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = "8204"},
	[20501] = {id=20500, name = "地狱雷光"  ,cd = 5000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 4,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[20601] = {id=20600, name = "冰咆哮"  ,cd = 5000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 4,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[20801] = {id=20800, name = "抗拒火环"  ,cd = 4000,interval = 3.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 2,rangeType = 2,tarType = 1,hurtEffType = 4,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},

	[30101] = {id=30100, name = "灵魂火符"  ,cd = 5000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = "fufeixing6301" ,hurtEff = "8202"},
	[30201] = {id=30200, name = "治疗术  "  ,cd = 5000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff="8302"			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[30301] = {id=30300, name = "释毒术",cd = 5000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 4,atkDis = 6,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = "fufeixing6301" ,hurtEff = "308"},
	[30401] = {id=30400, name = "隐身术"  ,cd = 4000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 2,hurtEffType = 1,atkDis = 1,atkAct="attack1"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	

	[40101] = {id=40100, name = "怪物近攻"  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[40201] = {id=40200, name = "怪物远攻"  ,cd = 2000,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,rangeId = 1,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},

	[1001] = {id=1001, name = "all"  ,cd = 3,interval = 1.5 ,selfBuff = {},tarBuff = {}              ,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "hit"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[1101] = {id=1101, name = "战士" ,cd = 3,interval = 1.5 ,selfBuff = {10001},tarBuff = {}         ,rangeType = 1,tarType = 1,hurtEffType = 1,atkDis = 1,atkAct="attack"	,atkSound = "zhanshi"	,atkEff="cisha6101"	,atkEffType = 2,flyEff = ""				,hurtEff = ""},
	[1201] = {id=1201, name = "法师" ,cd = 3,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 500,atkAct="attack1"	,atkSound = "fashi"	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = "leidian6201"},
	[1301] = {id=1301, name = "道士" ,cd = 3,interval = 1.5 ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 400,atkAct="attack1"	,atkSound = "daoshi"	,atkEff=""			,atkEffType = 1,flyEff = "fufeixing6301",hurtEff = ""},
	[4001] = {id=4001, name = "白猪" ,cd = 3,interval = 3   ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 180,atkAct="attack"	,atkSound = ""	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[4002] = {id=4002, name = "祖玛" ,cd = 3,interval = 3   ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 500,atkAct="attack"	,atkSound = ""	,atkEff=""			,atkEffType = 1,flyEff = "309"			,hurtEff = ""},
	[4003] = {id=4003, name = "虫子" ,cd = 3,interval = 3   ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 180,atkAct="attack"	,atkSound = ""	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	[5001] = {id=5001, name = "僵尸" ,cd = 3,interval = 3   ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 280,atkAct="attack"	,atkSound = ""	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
	--[5001] = {id=5001, name = "僵尸" ,cd = 3,interval = 3   ,selfBuff = {},tarBuff = {}     ,tarType = 1,hurtEffType = 1,atkDis = 280,atkAct="attack"	,atkSound = ""	,atkEff=""			,atkEffType = 1,flyEff = ""				,hurtEff = ""},
}
--------------------------------------------------------------------buff 和 buff字典---------------------------------------------
	
--bId   	buffID
--bType     buff类型 1-加属性，2-气血相关，3-控制类 
--subType   buff子类型    控制技能只能是1-9中间，其他的都是三位数，前两位表示类型，后一位表示是Buff（0）还是debuff（1）

--level    	buff等级
--repel    	buff排斥类型（填上可以共存的控制技能subType）
--dispel   	是否可以驱散 0否1可以
--duration 	持续时间 单位毫秒
--cycle    	周期  单位毫秒
--buffAtt  	Buff对应的属性Key
--buffValue buff属性对应的值
--buffRes  	Buff效果资源ID
--desc     	buff描述

--buff叠加和替换规则，控制技能根据repel配置来表示那些Buff可以共存，替换规则，同类型的高等级替换低等级

FightBuffConf = {
	[10010] = {bId=10010,bType=1,subType = 100,buffAtt="buffEnergy",   buffValue=1000,   desc="能量加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10020] = {bId=10020,bType=1,subType = 110,buffAtt="buffArmor",    buffValue=1000,   desc="护甲加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10030] = {bId=10030,bType=1,subType = 120,buffAtt="buffAtkAir",   buffValue=1000,   desc="对空攻击加成值",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10040] = {bId=10040,bType=1,subType = 130,buffAtt="buffAtkLand",  buffValue=1000,   desc="对地攻击加成值",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10050] = {bId=10050,bType=1,subType = 140,buffAtt="buffAtk",      buffValue=1000,   desc="攻击加成值（所有攻击）",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10060] = {bId=10060,bType=1,subType = 150,buffAtt="buffDef",      buffValue=1000,   desc="防御加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10070] = {bId=10070,bType=1,subType = 160,buffAtt="buffBreaks",   buffValue=1000,   desc="破甲加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10080] = {bId=10080,bType=1,subType = 170,buffAtt="buffHurt",     buffValue=1000,   desc="伤害加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10090] = {bId=10090,bType=1,subType = 180,buffAtt="buffDisHurt",  buffValue=1000,   desc="免伤加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10100] = {bId=10100,bType=1,subType = 190,buffAtt="buffBlood",  	 buffValue=1000,   desc="治疗加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10110] = {bId=10110,bType=1,subType = 200,buffAtt="buffHit",  	 buffValue=1000,   desc="命中率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10120] = {bId=10120,bType=1,subType = 210,buffAtt="buffDodge",    buffValue=1000,   desc="闪避率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10130] = {bId=10130,bType=1,subType = 220,buffAtt="buffCrit",     buffValue=1000,   desc="暴击率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10140] = {bId=10140,bType=1,subType = 230,buffAtt="buffCritPer",  buffValue=1000,   desc="暴击比列如15000表示1.5倍伤害(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10150] = {bId=10150,bType=1,subType = 240,buffAtt="buffAtkAirRate",  buffValue=1000,   desc="对空攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10160] = {bId=10160,bType=1,subType = 250,buffAtt="buffAtkLandRate",  buffValue=1000,   desc="对地攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10170] = {bId=10170,bType=1,subType = 260,buffAtt="buffAtkRate",  buffValue=1000,   desc="攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10180] = {bId=10180,bType=1,subType = 270,buffAtt="buffDefRate",  buffValue=1000,   desc="防御加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10190] = {bId=10190,bType=1,subType = 280,buffAtt="buffBreakRate",  buffValue=1000,   desc="破甲加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10200] = {bId=10200,bType=1,subType = 290,buffAtt="buffHurtRate",  buffValue=1000,   desc="伤害加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10210] = {bId=10210,bType=1,subType = 300,buffAtt="buffDisHurtRate",  buffValue=1000,   desc="免伤加成比率((万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10220] = {bId=10220,bType=1,subType = 310,buffAtt="buffBloodRate",  buffValue=1000,   desc="治疗加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10230] = {bId=10230,bType=3,subType = 1,buffAtt="buffDizzy",  buffValue=1,   desc="晕 受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10240] = {bId=10240,bType=3,subType = 2,buffAtt="buffIce",  buffValue=1,   desc="冰住  受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	--[10250] = {bId=10250,bType=3,subType = 10,buffAtt="buffSleep",  buffValue=1,   desc="睡住",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10260] = {bId=10260,bType=3,subType = 3,buffAtt="buffInvisible",  buffValue=1,   desc="隐身  则敌方目标无法作为目标选中拥有该状态的单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10270] = {bId=10270,bType=3,subType = 4,buffAtt="buffUnmatched",  buffValue=1,   desc="无敌  受到的所有伤害均变为1（包含BUFF带来的持续伤害）",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10280] = {bId=10280,bType=3,subType = 5,buffAtt="buffSilence",  buffValue=1,   desc="沉默   无法施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10290] = {bId=10290,bType=3,subType = 6,buffAtt="buffNotMove",  buffValue=1,   desc="禁止移动  无法进行移动",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},	
	[10310] = {bId=10310,bType=3,subType = 7,buffAtt="buffControl",  buffValue=1,   desc="控制  伤害自己单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10320] = {bId=10320,bType=3,subType = 8,buffAtt="buffSame",  buffValue=1,   desc="黑蜂  只能攻击这个状态的敌人",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10300] = {bId=10300,bType=2,subType = 320,buffAtt="buffVampire",  buffValue=1,   desc="吸血  造成的伤害均会等量治疗自己",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10330] = {bId=10330,bType=2,subType = 330,buffAtt="buffAtkSpeed",  buffValue=30000,   desc="增加攻速（万分制）",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10340] = {bId=10340,bType=2,subType = 331,buffAtt="buffAtkSpeed",  buffValue=-6000,   desc="降低攻速",buffRes = "buff2",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	-- [10350] = {bId=10350,bType=1,buffAtt="buffHp",  buffValue=-5000,   desc="",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10380] = {bId=10380,bType=2,subType = 341,buffAtt="buffHp",  buffValue=-5000,   desc="持续掉血Buff，每隔2秒加一次",buffRes = "buff2",duration = 12000,cycle =2000,level=1,repel=0,dispel=1,},
	[10390] = {bId=10390,bType=2,subType = 340,buffAtt="buffHp",  buffValue=5000,   desc="持续加血Buff，每隔2秒加一次",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	[10400] = {bId=10400,bType=2,subType = 350,buffAtt="buffHpTop",  buffValue=5000,   desc="增加气血上限（仅限于被动技能）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10410] = {bId=10410,bType=2,subType = 360,buffAtt="buffHpTopPer",  buffValue=5000,   desc="增加气血上限百分比（仅限于被动技能，万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},

	[10420] = {bId=10420,bType=2,subType = 370,buffAtt="buffTerran",  buffValue=5000,   desc="人族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10430] = {bId=10430,bType=2,subType = 380,buffAtt="buffProtoss",  buffValue=5000,   desc="神族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10440] = {bId=10440,bType=2,subType = 390,buffAtt="buffZerg",  buffValue=5000,   desc="虫族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10450] = {bId=10450,bType=2,subType = 400,buffAtt="buffMecha",  buffValue=5000,   desc="机甲参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10460] = {bId=10460,bType=2,subType = 410,buffAtt="buffBiology",  buffValue=5000,   desc="生物参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10470] = {bId=10470,bType=2,subType = 420,buffAtt="buffGhost",  buffValue=5000,   desc="幽灵参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},

	[10480] = {bId=10480,bType=2,subType = 430,buffAtt="buffTerranRate",  buffValue=5000,   desc="人族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10490] = {bId=10490,bType=2,subType = 440,buffAtt="buffProtossRate",  buffValue=5000,   desc="神族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10500] = {bId=10500,bType=2,subType = 450,buffAtt="buffZergRate",  buffValue=5000,   desc="虫族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10510] = {bId=10510,bType=2,subType = 460,buffAtt="buffMechaRate",  buffValue=5000,   desc="机甲参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10520] = {bId=10520,bType=2,subType = 470,buffAtt="buffBiologyRate",  buffValue=5000,   desc="生物参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10530] = {bId=10530,bType=2,subType = 480,buffAtt="buffGhostRate",  buffValue=5000,   desc="幽灵参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},


	[10540] = {bId=10540,bType=2,subType = 490,buffAtt="buffHpRate",  buffValue=1000,   desc="持续加百分比血量",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	[10550] = {bId=10550,bType=2,subType = 491,buffAtt="buffHpRate",  buffValue=-1000,   desc="持续减百分比血量",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	
}











































































--角色基础配置信息
--id 角色ID
--head 头像ID
--name 角色名称
--atkDis 攻击距离 按格子数最小1格
--resDire 模型资源方向 原图向左是-1 原图向右是1
--raceType 种族类型 1人，2神，3虫
--gridType 格子类型 1表示1格单位，2表示2格单位 4表示4格单位
--modelID 模型资源ID 
--defSkill 默认技能ID 具体技能ID/100
--ai  该兵种使用的AI {{1,10002}}
--attackPos 攻击点坐标 {{50,46},{-85,-85}}
--hurtPos  受击点坐标 {{50,46},{-85,-85}}
--buffPos buff显示点 {{50,46},{-85,-85}}
--克制相关
--terran = 0 --对人族克制
--protoss = 0 --对神族克制
--zerg = 0 --对虫族克制
--mecha = 0 --对机甲克制
--biology = 0 --对生物克制
--ghost = 0 --对幽灵克制
--克制相关 END
--armorType 装甲类型 1机械 2生物 3幽灵
--atkType 攻击类型  1地 2空 0地空
--moveType 移动类型 1地面走 2空中飞
--atkSpeed 攻击速度 毫秒
--moveSpeed 移动速度
--atk 攻击值  测试用
--hp 气血值   测试用

--{"id", "name", "resDire", "atkDis", "gridType", "defSkill", "ai", "attackPos", "hurtPos", "buffPos", "modelID", "head", "raceType", "armorType", "atkType", "moveType", "hp", "atk", "moveSpeed", "atkSpeed"}
FightRoleConf = {
	[1] = {id = 1,name = "机枪兵",resDire = -1,atkDis = 3,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1 },
	[2] = {id = 2,name = "火焰兵",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 104,raceType = 1,armorType = 2,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[3] = {id = 3,name = "医生",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 105,raceType = 1,armorType = 2,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },	
	[4] = {id = 4,name = "特工",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 107,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[5] = {id = 5,name = "地雷车",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 108,raceType = 1,armorType = 1,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[6] = {id = 6,name = "幽灵战机",resDire = 1,atkDis = 5,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 3,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[7] = {id = 7,name = "科技球",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 1,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[8] = {id = 8,name = "瓦格雷",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 2,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[9] = {id = 9,name = "坦克",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[10] = {id = 10,name = "雷神",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[11] = {id = 11,name = "战列舰",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{112,50},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 1,armorType = 1,atkType = 3,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[12] = {id = 12,name = "狂战士",resDire = -1,atkDis = 1,gridType = 4, defSkill = 10003 ,ai = {{1,10004}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "kzs_101",head = 110,raceType = 2,armorType = 3,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[13] = {id = 13,name = "闪电兵",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 110,raceType = 2,armorType = 3,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[14] = {id = 14,name = "黑暗圣堂",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 110,raceType = 2,armorType = 3,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 1800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[15] = {id = 15,name = "探测者",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 110,raceType = 2,armorType = 3,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },

	[16] = {id = 16,name = "龙骑士",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10003},{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 1,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[17] = {id = 17,name = "侦察机",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 1,atkType = 3,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[18] = {id = 18,name = "海盗船",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 1,atkType = 2,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[19] = {id = 19,name = "光明执政",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 3,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[20] = {id = 20,name = "黑暗执政",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 3,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[21] = {id = 21,name = "仲裁者",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 3,atkType = 3,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[22] = {id = 22,name = "金甲虫",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 1,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[23] = {id = 23,name = "航空母舰",resDire = 1,atkDis = 2,gridType = 4, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "ylzj_110",head = 110,raceType = 2,armorType = 1,atkType = 3,moveType= 2,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[24] = {id = 24,name = "小狗",resDire = 1,atkDis = 1,gridType = 1, defSkill = 10003 ,ai = {{1,10004}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "xg_201",head = 110,raceType = 3,armorType = 2,atkType = 1,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[25] = {id = 25,name = "刺蛇",resDire = 1,atkDis = 2,gridType = 2, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "xg_201",head = 110,raceType = 3,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[26] = {id = 26,name = "地刺",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[27] = {id = 27,name = "蝎子",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[28] = {id = 28,name = "飞龙",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[29] = {id = 29,name = "皇后",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[30] = {id = 30,name = "雷兽",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800, terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1 },
	[31] = {id = 31,name = "守卫者",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[32] = {id = 32,name = "吞噬兽",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[33] = {id = 33,name = "宿主",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
	[34] = {id = 34,name = "爆炸蚊",resDire = -1,atkDis = 2,gridType = 1, defSkill = 10001 ,ai = {{1,10002}},attackPos = {{50,46},{-85,-85}},hurtPos = {{0,50}},buffPos = {{0,50}},modelID = "jqb_104",head = 103,raceType = 1,armorType = 2,atkType = 3,moveType= 1,moveSpeed = 2,atkSpeed = 2000,hp = 5000,atk = 800,terran = 1,protoss = 1,zerg = 1,mecha = 1,biology = 1,ghost = 1  },
}

--id  AI 的id
--aiType AI类型 1.循环几秒播 2单次执行判定
--condType 条件类型conditionType  
		--1 自身HP低于或者等于   百分比  怪物自身血量低于或者等于某一百分比值时。
		--2 每过时间触发（循环)   时间-毫秒  从战斗开始计算，可多次触发，循环释放技能
		--3	在某时间触发（一次）		时间-毫秒	某个时间点触发一次。				
		--4	是否有飞行单位		无					
		--5	是否有某类别单位		1、2、3对应幽能、生化、机械单位				
		--6	是否有某体积单位			1、2、3对应大型、中型、小型单位	

--condValue 条件值 如时间就是时间的毫秒，如果是气血就是气血的值
--actionType 动作类型,1表示使用技能 以后有扩展加后面
--actionValue 动作值 actionType=1时是技能前5位ID
--isAuto 是否自动释放，有个自动按钮控制
--ai中配的技能ID是技能ID的前五位

	

FightAIConf = {
	
	[10000] = {id=10000, aiType = 1, condType = 2, condValue = 6000,actionType = 1,actionValue = 10001,isAuto = false},
	----机枪兵
	[10001] = {id=10001, aiType = 1, condType = 2, condValue = 6000,actionType = 1,actionValue = 10001,isAuto = false},
	[10002] = {id=10002, aiType = 1, condType = 2, condValue = 6000,actionType = 1,actionValue = 10002,isAuto = false},
	--叉叉兵
	[10003] = {id=10003, aiType = 1, condType = 2, condValue = 6000,actionType = 1,actionValue = 10003,isAuto = false},
	[10004] = {id=10004, aiType = 1, condType = 2, condValue = 6000,actionType = 1,actionValue = 10004,isAuto = false},
	
	--循环执行自身气血低于多少时执行
	[10005] = {id=10005, aiType = 1, condType = 1, condValue = 10000,actionType = 1,actionValue = 10002,isAuto = false},
	--执行一次气血低于多少时执行技能
	[10006] = {id=10006, aiType = 2, condType = 1, condValue = 15000,actionType = 1,actionValue = 10002,isAuto = false},
	--执行一次时间条件技能	
	[10007] = {id=10007, aiType = 2, condType = 2, condValue = 6000,actionType = 1,actionValue = 10002,isAuto = false},
	--执行一次有某类别单位条件技能
	[10008] = {id=10008, aiType = 2, condType = 5, condValue = 2,   actionType = 1,actionValue = 10002,isAuto = false},


	[10009] = {id=10009, aiType = 1, condType = 2, condValue = 6,   actionType = 1,actionValue = 10009,isAuto = false},
	[10010] = {id=10010, aiType = 1, condType = 2, condValue = 6,   actionType = 1,actionValue = 10010,isAuto = false},

	-- [10001] = {id=10002,aiType = 1, aiValue = 6,actionType = 1,actionValue = 10002,isAuto = false},
	-- [10002] = {id=10002,aiType = 1, aiValue = 6,actionType = 1,actionValue = 10002,isAuto = false},
	-- --叉叉兵
	-- [10003] = {id=10003,aiType = 1, aiValue = 6,actionType = 1,actionValue = 10003,isAuto = false},
	-- [10004] = {id=10004,aiType = 1, aiValue = 6,actionType = 1,actionValue = 10004,isAuto = false},
	
	-- --说话(按时间无限说话) 
	-- [10005] = {id=10005,aiType = 1, aiValue = 3,actionType = 1,actionValue = 10006,isAuto = false},
	-- --范围
	-- [10007] = {id=10007,aiType = 1, aiValue = 1,actionType = 1,actionValue = 10007,isAuto = false},
	-- --闪电
	-- [10008] = {id=10008,aiType = 1, aiValue = 1,actionType = 1,actionValue = 10008,isAuto = false},

	-- 自动加血(按hp无限加血)
	-- --execute1血量

	-- [10009] = {id=10009,aiType = 2, aiValue = 1,actionType = 1,actionValue = 10009,isAuto = false,aiType2 = 1,condition1 = 1,execute1 = 50},

	-- --自动加血，只加一次
	-- [10011] = {id=10011,aiType = 2, aiValue = 1,actionType = 1,actionValue = 10011,isAuto = false,aiType2 = 2,condition1 = 1,execute1 = 50},

	-- --在某一个时间说话 execute1时间
	-- [10012] = {id=10012,aiType = 2, aiValue = 1,actionType = 1,actionValue = 10012,isAuto = false,aiType2 = 2,condition1 = 2,execute1 = 2},
}


------------------------------------------------------------------技能----------------------------------------------------------

--id    技能ID
--name 技能名称
--desc 技能描述
--icon 技能图标
--sType 技能类型 --1主动大招,2普通技能，3被动技能，
--sSubType 技能子类型  -- 1 攻击类，2气血类 3 buff类型 4晕 5冰 10表示说话技能
--group 技能分组 --技能前5位
--level 技能级别 --1
--nextSkill  升级后技能id
--condition 学习条件 
--consume 技能消耗(已去掉)

--cd 冷却时间
--interval 间隔时间
--hasAtk --是否伴随普攻  0表示没有  1表示有
--skillHit  技能命中率   万分制 10000

--scriptId  技能脚本ID 
			--10002 {subType } 清除Buff技能
            --10001 { }  加血技能
--args  技能脚本参数  根据技能脚本ID来决定

--属性相关
--energy 能量加成值修正
--armor 护甲加成值修正
--atkAir 对空攻击加成值修正
--atkLand 对地攻击加成值修正
--atk  攻击加成值（所有攻击） ？？？？
--def  防御加成值修正
--breaks  破甲加成值修正
--hurt  伤害加成值修正
--disHurt 免伤加成值修正
--blood 治疗加成值修正
--hit 命中率加成值修正
--dodge 闪避率加成值修正
--crit 暴击率加成值 修正  0表示没有暴击
--critPer 暴击比列修正如15000表示1.5倍伤害

--atkAirRate 对空攻击加成比率修正 
--atkLandRate 对地攻击加成比率修正
--atkRate 攻击加成比率修正(增加万分比)/？？？？
--defRate 防御加成比率修正
--breakRate 破甲加成比率修正
--hurtRate 伤害加成比率修正(增加万分比)
--disHurtRate 免伤加成比率修正(减少万分比)0表示不免伤 1表示全部免伤
--bloodRate 治疗加成比率修正	
--atkSpeed  攻击速度加成比率修正   ----------
--属性相关END


--selfBuff  作用于自身的BUff   如：{10010,10110}
--targetBuff 作用于目标的Buff	如：{10010,10110}
--
--armorLimit 装甲类型限制 1机械 2生物 3幽灵 										0 全部(先不用)
--moveLimit 地空类型限制  1地 2空 													0地空（先不用）
--gridLimit  格子体型限制 1表示1格单位，2表示2格单位 4表示4格单位               
--atkRange 攻击范围  1表示是单个目标,2表示1格内的,3表示1*2范围,4表示是1*3,5表示2*2,6表示3*3,7表示4*4,8表示全部,9闪电链
--target 目标类型 1表示敌人，2表示队友，3表示自己
--targetNum 目标数量 如10个
--decay 衰减系数 如 0.9
--

--vibration 是否震动屏幕 0or1
--atkAction 攻击动作动画名称
--atkSound 攻击时播放声音
--atkEffect 攻击时发的效果
--atkEffPos 攻击时播放攻击效果的点

--hBodyTopEff 伤害效果 攻击到敌人后，在敌人身上显示的效果
--hBodyFootEff 伤害效果 攻击到敌人后，在敌人脚下显示的效果
--hTopEff 伤害效果 攻击到敌人后，在所有人上方显示效果
--hFootEff 伤害效果 攻击到敌人后，在所有人下方显示的效果
--hEffType 伤害效果显示类型 1表示只是在单个目标内显示效果，2表示在多个目标内显示效果，3表示在顶层显示大招效果，4表示显示链式效果


FightSkillConf2 = {
	--机枪兵 普攻 10001普攻  10002 大招
	[10001001] = {id=10001001, name = "机枪兵普攻" ,icon = 10000, sType = 2,sSubType = 1, group=10001 ,level = 1,nextSkill = 10001002, condition = {},            cd = 3,interval = 3,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 1,                  vibration = 0,atkAction="attack",atkSound="sound_a_4",atkEffect="atk1",atkEffPos=1,hBodyTopEff="jqb",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,                           energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},
	[10002001] = {id=10002001, name = "机枪兵大招" ,icon = 10000, sType = 1,sSubType = 1, group=10002 ,level = 1,nextSkill = 10002002, condition = {},            cd = 4,interval = 4,hasAtk = 0,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 0.8,                  vibration = 1,atkAction="attack1",atkSound="sound_a_2",atkEffect="jqb1",atkEffPos=1,hBodyTopEff="",hBodyFootEff = "",hTopEff = "baozha3",hFootEff = "baozha5",hEffType=2,               energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 50000,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {10330},targetBuff={10340}},--10050
	
	[10003001] = {id=10003001, name = "狗狗普攻" ,icon = 10000, sType = 2, sSubType = 1,group=10003 ,level = 1,nextSkill = 10003002, condition = {},            cd = 3,interval = 3,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 1,                    vibration = 0,atkAction="attack",atkSound="sound_a_1",atkEffect="",atkEffPos=1,hBodyTopEff="binzhu1",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,               energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},
	[10004001] = {id=10004001, name = "狗狗大招" ,icon = 10000, sType = 1,sSubType = 1, group=10004 ,level = 1,nextSkill = 10004002, condition = {},            cd = 4,interval = 4,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 4,target = 1,targetNum = 10,decay = 0.8,                    vibration = 0,atkAction="attack1",atkSound="sound_a_1",atkEffect="",atkEffPos=1,hBodyTopEff="kzs1114DeadTeXiao",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,               energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 2000,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},--10390
	
	[10005001] = {id=10005001, name = "机枪兵普攻" ,icon = 10000, sType = 2,sSubType = 1, group=10001 ,level = 1,nextSkill = 10001002, condition = {},            cd = 2,interval = 2,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 0.8,                 	vibration = 0,atkAction="attack",atkSound="sound_a_4",atkEffect="atk1",atkEffPos=1,hBodyTopEff="jqb",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,                           energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},
	[10006001] = {id=10006001, name = "机枪兵普攻" ,icon = 10000, sType = 2,sSubType = 1, group=10001 ,level = 1,nextSkill = 10001002, condition = {},            cd = 2,interval = 2,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 0.8,                  vibration = 0,atkAction="attack",atkSound="sound_a_4",atkEffect="atk1",atkEffPos=1,hBodyTopEff="jqb",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,                           energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},
	[10008001] = {id=10008001, name = "机枪兵普攻" ,icon = 10000, sType = 2,sSubType = 1, group=10001 ,level = 1,nextSkill = 10001002, condition = {},            cd = 2,interval = 2,hasAtk = 1,skillHit = 9000,armorLimit = 123,moveLimit = 12,gridLimit = 124,atkRange = 1,target = 1,targetNum = 10,decay = 0.8,                  vibration = 0,atkAction="attack",atkSound="sound_a_4",atkEffect="atk1",atkEffPos=1,hBodyTopEff="jqb",hBodyFootEff = "",hTopEff = "",hFootEff = "",hEffType=1,                           energy = 0,armor = 0,atkAir = 0,atkLand = 0,atk= 0,def = 0,breaks= 0,hurt = 0,disHurt = 0,blood = 0,hit = 10000,dodge = 0,crit = 0,critPer = 0,atkAirRate = 0,atkLandRate = 0,atkRate= 0,defRate= 0,breakRate = 0,hurtRate = 0,disHurtRate = 0,bloodRate = 0,atkSpeed = 0,selfBuff = {},targetBuff={}},
}







--------------------------------------------------------------------buff 和 buff字典---------------------------------------------
	
--bId   	buffID
--bType     buff类型 1-加属性，2-气血相关，3-控制类 
--subType   buff子类型    控制技能只能是1-9中间，其他的都是三位数，前两位表示类型，后一位表示是Buff（0）还是debuff（1）

--level    	buff等级
--repel    	buff排斥类型（填上可以共存的控制技能subType）
--dispel   	是否可以驱散 0否1可以
--duration 	持续时间 单位毫秒
--cycle    	周期  单位毫秒
--buffAtt  	Buff对应的属性Key
--buffValue buff属性对应的值
--buffRes  	Buff效果资源ID
--desc     	buff描述

--buff叠加和替换规则，控制技能根据repel配置来表示那些Buff可以共存，替换规则，同类型的高等级替换低等级

FightBuffConf = {
	[10010] = {bId=10010,bType=1,subType = 100,buffAtt="buffEnergy",   buffValue=1000,   desc="能量加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10020] = {bId=10020,bType=1,subType = 110,buffAtt="buffArmor",    buffValue=1000,   desc="护甲加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10030] = {bId=10030,bType=1,subType = 120,buffAtt="buffAtkAir",   buffValue=1000,   desc="对空攻击加成值",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10040] = {bId=10040,bType=1,subType = 130,buffAtt="buffAtkLand",  buffValue=1000,   desc="对地攻击加成值",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10050] = {bId=10050,bType=1,subType = 140,buffAtt="buffAtk",      buffValue=1000,   desc="攻击加成值（所有攻击）",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10060] = {bId=10060,bType=1,subType = 150,buffAtt="buffDef",      buffValue=1000,   desc="防御加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10070] = {bId=10070,bType=1,subType = 160,buffAtt="buffBreaks",   buffValue=1000,   desc="破甲加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10080] = {bId=10080,bType=1,subType = 170,buffAtt="buffHurt",     buffValue=1000,   desc="伤害加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10090] = {bId=10090,bType=1,subType = 180,buffAtt="buffDisHurt",  buffValue=1000,   desc="免伤加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10100] = {bId=10100,bType=1,subType = 190,buffAtt="buffBlood",  	 buffValue=1000,   desc="治疗加成值",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10110] = {bId=10110,bType=1,subType = 200,buffAtt="buffHit",  	 buffValue=1000,   desc="命中率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10120] = {bId=10120,bType=1,subType = 210,buffAtt="buffDodge",    buffValue=1000,   desc="闪避率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10130] = {bId=10130,bType=1,subType = 220,buffAtt="buffCrit",     buffValue=1000,   desc="暴击率加成值(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10140] = {bId=10140,bType=1,subType = 230,buffAtt="buffCritPer",  buffValue=1000,   desc="暴击比列如15000表示1.5倍伤害(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10150] = {bId=10150,bType=1,subType = 240,buffAtt="buffAtkAirRate",  buffValue=1000,   desc="对空攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10160] = {bId=10160,bType=1,subType = 250,buffAtt="buffAtkLandRate",  buffValue=1000,   desc="对地攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10170] = {bId=10170,bType=1,subType = 260,buffAtt="buffAtkRate",  buffValue=1000,   desc="攻击加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10180] = {bId=10180,bType=1,subType = 270,buffAtt="buffDefRate",  buffValue=1000,   desc="防御加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10190] = {bId=10190,bType=1,subType = 280,buffAtt="buffBreakRate",  buffValue=1000,   desc="破甲加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10200] = {bId=10200,bType=1,subType = 290,buffAtt="buffHurtRate",  buffValue=1000,   desc="伤害加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10210] = {bId=10210,bType=1,subType = 300,buffAtt="buffDisHurtRate",  buffValue=1000,   desc="免伤加成比率((万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10220] = {bId=10220,bType=1,subType = 310,buffAtt="buffBloodRate",  buffValue=1000,   desc="治疗加成比率(万分制)",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10230] = {bId=10230,bType=3,subType = 1,buffAtt="buffDizzy",  buffValue=1,   desc="晕 受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10240] = {bId=10240,bType=3,subType = 2,buffAtt="buffIce",  buffValue=1,   desc="冰住  受到此状态则无法执行任何行动，包括移动与施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	--[10250] = {bId=10250,bType=3,subType = 10,buffAtt="buffSleep",  buffValue=1,   desc="睡住",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10260] = {bId=10260,bType=3,subType = 3,buffAtt="buffInvisible",  buffValue=1,   desc="隐身  则敌方目标无法作为目标选中拥有该状态的单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10270] = {bId=10270,bType=3,subType = 4,buffAtt="buffUnmatched",  buffValue=1,   desc="无敌  受到的所有伤害均变为1（包含BUFF带来的持续伤害）",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10280] = {bId=10280,bType=3,subType = 5,buffAtt="buffSilence",  buffValue=1,   desc="沉默   无法施放技能",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10290] = {bId=10290,bType=3,subType = 6,buffAtt="buffNotMove",  buffValue=1,   desc="禁止移动  无法进行移动",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},	
	[10310] = {bId=10310,bType=3,subType = 7,buffAtt="buffControl",  buffValue=1,   desc="控制  伤害自己单位",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10320] = {bId=10320,bType=3,subType = 8,buffAtt="buffSame",  buffValue=1,   desc="黑蜂  只能攻击这个状态的敌人",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10300] = {bId=10300,bType=2,subType = 320,buffAtt="buffVampire",  buffValue=1,   desc="吸血  造成的伤害均会等量治疗自己",buffRes = "",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10330] = {bId=10330,bType=2,subType = 330,buffAtt="buffAtkSpeed",  buffValue=30000,   desc="增加攻速（万分制）",buffRes = "buff1",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	[10340] = {bId=10340,bType=2,subType = 331,buffAtt="buffAtkSpeed",  buffValue=-6000,   desc="降低攻速",buffRes = "buff2",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	-- [10350] = {bId=10350,bType=1,buffAtt="buffHp",  buffValue=-5000,   desc="",duration = 15000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10380] = {bId=10380,bType=2,subType = 341,buffAtt="buffHp",  buffValue=-5000,   desc="持续掉血Buff，每隔2秒加一次",buffRes = "buff2",duration = 12000,cycle =2000,level=1,repel=0,dispel=1,},
	[10390] = {bId=10390,bType=2,subType = 340,buffAtt="buffHp",  buffValue=5000,   desc="持续加血Buff，每隔2秒加一次",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	[10400] = {bId=10400,bType=2,subType = 350,buffAtt="buffHpTop",  buffValue=5000,   desc="增加气血上限（仅限于被动技能）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10410] = {bId=10410,bType=2,subType = 360,buffAtt="buffHpTopPer",  buffValue=5000,   desc="增加气血上限百分比（仅限于被动技能，万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},

	[10420] = {bId=10420,bType=2,subType = 370,buffAtt="buffTerran",  buffValue=5000,   desc="人族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10430] = {bId=10430,bType=2,subType = 380,buffAtt="buffProtoss",  buffValue=5000,   desc="神族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10440] = {bId=10440,bType=2,subType = 390,buffAtt="buffZerg",  buffValue=5000,   desc="虫族参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10450] = {bId=10450,bType=2,subType = 400,buffAtt="buffMecha",  buffValue=5000,   desc="机甲参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10460] = {bId=10460,bType=2,subType = 410,buffAtt="buffBiology",  buffValue=5000,   desc="生物参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10470] = {bId=10470,bType=2,subType = 420,buffAtt="buffGhost",  buffValue=5000,   desc="幽灵参数（仅限于被动技能，伤害值）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},

	[10480] = {bId=10480,bType=2,subType = 430,buffAtt="buffTerranRate",  buffValue=5000,   desc="人族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10490] = {bId=10490,bType=2,subType = 440,buffAtt="buffProtossRate",  buffValue=5000,   desc="神族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10500] = {bId=10500,bType=2,subType = 450,buffAtt="buffZergRate",  buffValue=5000,   desc="虫族参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	
	[10510] = {bId=10510,bType=2,subType = 460,buffAtt="buffMechaRate",  buffValue=5000,   desc="机甲参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10520] = {bId=10520,bType=2,subType = 470,buffAtt="buffBiologyRate",  buffValue=5000,   desc="生物参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},
	[10530] = {bId=10530,bType=2,subType = 480,buffAtt="buffGhostRate",  buffValue=5000,   desc="幽灵参数（仅限于被动技能，伤害比 万分制）",buffRes = "",duration = 12000,cycle = 0,level=1,repel=0,dispel=1,},


	[10540] = {bId=10540,bType=2,subType = 490,buffAtt="buffHpRate",  buffValue=1000,   desc="持续加百分比血量",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	[10550] = {bId=10550,bType=2,subType = 491,buffAtt="buffHpRate",  buffValue=-1000,   desc="持续减百分比血量",buffRes = "buff2",duration = 12000,cycle = 2000,level=1,repel=0,dispel=1,},
	
}

