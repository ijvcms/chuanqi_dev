--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-23 09:40:57
-- 游戏常量定义

SceneColorType = {
	NPC = cc.c3b(101,254,101),
	MANSTER = cc.c3b(198,46,45),
	TRANSFER = cc.c3b(109,159,224),
	CITY = cc.c3b(101,254,101),
	FIELD = cc.c3b(198,46,45),
}
UiColorType = {
	ALERT_TITLE = cc.c3b(245,204,148),
	ALERT_TIPS = cc.c3b(205,153,115),
	BTN_LAB1 = cc.c3b(247,206,150),
	TAB_BTN_LAB1 = cc.c3b(247,206,150),

	LAB_W1 = cc.c3b(255,255,255),
	LAB_GRAY1 = cc.c3b(206,198,193),
	LAB_Y1 = cc.c3b(255,215,156),
	LAB_ORANGE1 = cc.c3b(203,153,115),
	LAB_RED1 = cc.c3b(207,46,46),
	LAB_GREEN1 = cc.c3b(101,241,98),
}

--物品类型
GoodsType = {
	PROP = 1, --道具
	EQUIP = 2, --装备
	JEWEL = 3, --宝石
	CONSUME = 4,--消耗(药品)
	MONEY = 5, --货币
	GIFT = 6, --礼包
}

-- --物品子类型
-- GoodsSubType = {
-- 	[1000] = "战", --战士
-- 	[2000] = "法", --法师
-- 	[3000] = "道", --道士
-- }

--物品品质类型
GoodsQualityType = {
	WHITE = 1, --白
	GREEN = 2, --绿
	BLUE = 3, --蓝
	PURPLE = 4,--紫
	ORANGE = 5, --橙
	RED = 6, --红色
}


SceneGridRect = {
	width = 64,
	height = 64,
}
--角色职业ID
RoleCareer = {
	WARRIOR = 1000, --战士
	MAGE =    2000, --法师
	TAOIST =  3000, --道士
}

--角色职业ID
ShabakeOfficeType = {
	CASTELLAN = 1, --城主
	VICECASTELLAN = 2, --副城主
	PRESBYTER = 3, --长老
	MEMBER = 4,--会员
}

--角色职业名称
RoleCareerName = {
	[1000] = "战士", --战士
	[2000] = "法师", --法师
	[3000] = "道士", --道士
}

--角色职业名称
RoleCareerName2 = {
	[1000] = "战", --战士
	[2000] = "法", --法师
	[3000] = "道", --道士
}

--角色性别
RoleSex = {
	MAN = 1,      --男性
	WOMAN = 2,    --女性
}

--场景类型
SceneType = {
	HANGUP = 1,       --挂记
	ACTIVITY = 2,     --活动
}

--场景NPC类型
MonsterType = {
    PT = 1,     --普通
    JY = 2,     --精英
    BOSS = 3,   --boss
    LZ = 4,     --拢住
}

--场景NPC类型
NpcType = {
    TRANSFER_NPC = 1,       --传送NPC，直接跳到场景
    OPEN_DIALOG = 2,     --打开对话框
    HANGUP = 3,     --挂机场景
    TRANSFER_POINT = 4,    --传送点
    SCENE_OBJECT = 5,      --场景对象
    OPEN_WIN = 6,     --直接打开界面
    WORSHIP_WIN = 7,     --直接打开膜拜
}

--战斗模式类型 1 和平，2 全体，3 帮派，4 队伍，5 善恶
FightModelType = {
	PEACE = 1,       --和平
	GOODEVIL = 5,    --善恶
	TEAM = 4,        --组队
	GUILD = 3,       --行会
	ALL = 2,         --全体
	NEWPLAYER = 6,   --新手
	ENEMY = 7,       --仇人
    CORPS = 8,       --军团
    UNION = 9,       --联盟
}


--文本颜色类型
TextColor = {

	STONE = cc.c3b(112, 112, 112),
	TAB_BTN = cc.c3b(219, 174, 103), 	--tab按钮文本
	ROLENAME = cc.c3b(255, 255, 255), 	--角色名称cc.c3b(223, 216, 202)
	TITLE = cc.c3b(223, 216, 202), 		--白色标题

	TEXT_WHITE = cc.c3b(255, 255, 255), --纯白色文本
	TEXT_R = cc.c3b(247, 33, 33), 		--红色文本
	TEXT_HR = cc.c3b(255, 100, 7), 		--深红色文本
	TEXT_G = cc.c3b(111, 196, 145), 	--绿色文本
	TEXT_Y = cc.c3b(236, 183, 76), 		--黄色文本
	TEXT_GRAY = cc.c3b(193, 178, 159), 	--灰色文本
	TEXT_W = cc.c3b(255, 211, 175), 	--白色文本
	TEXT_O = cc.c3b(255, 118, 51), 		--橙色文本
	TEXT_C = cc.c3b(255, 118, 51), 		--橙色文本
	TEXT_BK = cc.c3b(20,20,20),			--黑色文本
	TEXT_DG = cc.c3b(41,219,40),		--深绿文本
	TEXT_B = cc.c3b(0,198,255),			--蓝色文本
	TEXT_P = cc.c3b(227, 147, 216),		--紫色文本
	
	BTN_Y = cc.c3b(219, 174, 103), 		--黄色文本
	BTN_W = cc.c3b(255, 211, 175), 		--黄色文本

	ITEM_W = cc.c3b(237, 227, 210), 	--物品白 White
	ITEM_G = cc.c3b(102, 219, 87), 		--物品绿 Green
	ITEM_B = cc.c3b(155, 198, 212), 	--物品蓝 Blue
	ITEM_P = cc.c3b(255, 101, 231), 	--物品紫 Purple
	ITEM_O = cc.c3b(255, 118, 58), 		--物品橙 Orange

	ROLE_W = cc.c3b(255, 255, 255), 	--角色白 White
	ROLE_GRAY = cc.c3b(136, 136, 136), 	--角色灰
	ROLE_Y = cc.c3b(245, 241, 70), 	--角色黄
	ROLE_R = cc.c3b(230, 27, 37), 	--角色红
	ROLE_G = cc.c3b(0, 255, 48), 	--角色绿
	ROLE_B = cc.c3b(3, 147, 247), 	--角色蓝色

	NPC_G = cc.c3b(0, 255, 48), 	--npc绿色
	MONSTER_R = cc.c3b(235, 12, 12), 	--怪物红色
	MONSTER_Y = cc.c3b(255, 235, 62), 	--怪物黄色
	MONSTER_W = cc.c3b(255, 255, 255), 	--怪物白色
}


			
AttrName = {
	[1]  = '等级',
	[2]  = '经验',
	[3]  = '当前血量',
	[4]  = '当前魔法',
	--[5]  = '血量上限',
	--[6]  = '魔法上限',
	[5]  = '气血',
	[6]  = '魔法',
	[7]  = '最小物理攻击',
	[8]  = '最大物理攻击',
	[9]  = '最小魔法攻击',
	[10] = '最大魔法攻击',
	[11] = '最小道术攻击',
	[12] = '最大道术攻击',
	[13] = '最小物防',
	[14] = '最大物防',
	[15] = '最小魔防',
	[16] = '最大魔防',
	[17] = '暴击',
	[18] = '暴击伤害',
	[19] = '准确',
	[20] = '敏捷',
	[21] = '伤害加深',
	[22] = '伤害减免',
	[23] = '神圣',
	[24] = '技能伤害追加',
	[25] = '魔法命中',
	[26] = '魔法闪避',
	[27] = '生命恢复',
	[28] = '魔法恢复',
	[29] = '死亡恢复',
	[30] = '伤害抵消',
	[31] = '元宝',
	[32] = '金币',
	[33] = '武器外观',
	[34] = '衣服外观',
	[35] = '熔炼值',
	[36] = '当前挂机场景',
	[37] = '通关挂机场景',
	[38] = '气血',					 				--百分比加成',
    [39] = '魔法',                   				--百分比加成',
    [40] = '最小物理攻击',                  		--百分比加成',
    [41] = '最大物理攻击',                       	--百分比加成',
    [42] = '最小魔法攻击',                       	--百分比加成',
    [43] = '最大魔法攻击',                       	--百分比加成',
    [44] = '最小道术攻击',                       	--百分比加成',
    [45] = '最大道术攻击',                       	--百分比加成',
    [46] = '最小物防',                       		--百分比加成',
    [47] = '最大物防',                       		--百分比加成',
    [48] = '最小魔防',                       		--百分比加成',
    [49] = '最大魔防',                       		--百分比加成',
    [50] = '暴击',                       			--百分比加成',
    [51] = '暴击伤害',                       		--百分比加成',
    [52] = '准确',                       			--百分比加成',
    [53] = '敏捷',                       			--百分比加成',
    [54] = '伤害加深',                       		--百分比加成',
    [55] = '伤害减免',                       		--百分比加成',
    [56] = '神圣',                       			--百分比加成',
    [57] = '技能伤害追加',                       	--百分比加成',
    [58] = '魔法命中',                       		--百分比加成',
    [59] = '魔法闪避',                       		--百分比加成',
    [60] = '生命恢复',                       		--百分比加成',
    [61] = '魔法恢复',                       		--百分比加成',
    [62] = '死亡恢复',                       		--百分比加成',
    [63] = '伤害减免',                       		--百分比加成',
    [64] = '战斗力',                       		
    [65] = '背包格子数',              
    [66] = '翅膀外观',
    [67] = '宠物外观',
    [68] = '金币百分比加成',						--百分比加成,
	[69] = '经验百分比加成',						--百分比加成,
	[70] = '礼券',
	[71] = 'pk值',
	[72] = 'pk模式',
	[73] = 'vip',
	[74] = '幸运',
	[75] = '名字颜色',        		
}

AttrMatch = 
{
	{key=3,field='cur_hp'}, 						--当前血量
	{key=4,field='cur_mp'}, 						--当前魔法
	{key=5,field='hp'},  							--血量
	{key=6,field='mp'},  							--魔法
	{key=7,field='min_ac'},  						--最小物理攻击
	{key=8,field='max_ac'},  						--最大物理攻击
	{key=9,field='min_mac'},  						--最小魔法攻击
	{key=10,field='max_mac'},  						--最大魔法攻击
	{key=11,field='min_sc'},  						--最小道术攻击
	{key=12,field='max_sc'},  					--最大道术攻击
	{key=13,field='min_def'},  						--最小物防
	{key=14,field='max_def'},  						--最大物防
	{key=15,field='min_res'},  						--最小魔防
	{key=16,field='max_res'},  						--最大魔防
	{key=17,field='crit'},  						--暴击
	{key=18,field='crit_att'},  					--暴击伤害
	{key=19,field='hit'},  							--准确
	{key=20,field='dodge'},  						--敏捷
	{key=21,field='damage_deepen'},  				--伤害加深
	{key=22,field='damage_reduction'},  			--伤害减免
	{key=23,field='holy'},  						--神圣
	{key=24,field='skill_add'},  					--技能伤害追加
	{key=25,field='m_hit'},  						--魔法命中
	{key=26,field='m_dodge'},  						--魔法闪避
	{key=27,field='hp_recover'},  					--生命恢复
	{key=28,field='mp_recover'},  					--魔法恢复
	{key=29,field='resurgence'},  					--死亡恢复
	{key=30,field='damage_offset'},  				--伤害抵消

	{key=74,field='lucky'},  						--幸运值
	{key=-1,field='curse'},  						--诅咒值

    {key=38,field='hp_p'},  						--血量百分比加成
    {key=39,field='mp_p'},  						--魔法百分比加成
    {key=40,field='min_ac_p'},  					--最小物理攻击百分比加成
    {key=41,field='max_ac_p'},  					--最大物理攻击百分比加成
    {key=42,field='min_mac_p'},  					--最小魔法攻击百分比加成
    {key=43,field='max_mac_p'},  					--最大魔法攻击百分比加成
    {key=44,field='min_sc_p'},  					--最小道术攻击百分比加成
    {key=45,field='max_sc_p'},  					--最大道术攻击百分比加成
    {key=46,field='min_def_p'},  					--最小物防百分比加成
    {key=47,field='max_def_p'},  					--最大物防百分比加成
    {key=48,field='min_res_p'},  					--最小魔防百分比加成
    {key=49,field='max_res_p'},  					--最大魔防百分比加成
    {key=50,field='crit_p'},  						--暴击百分比加成
    {key=51,field='crit_att_p'},  					--暴击伤害百分比加成
    {key=52,field='hit_p'},  						--准确百分比加成
    {key=53,field='dodge_p'}, 				 		--敏捷百分比加成
    {key=54,field='damage_deepen_p'},  				--伤害加深百分比加成
    {key=55,field='damage_reduction_p'},  			--伤害减免百分比加成
    {key=56,field='holy_p'},  						--神圣百分比加成
    {key=57,field='skill_add_p'},  					--技能伤害追加百分比加成
    {key=58,field='m_hit_p'},  						--魔法命中百分比加成
    {key=59,field='m_dodge_p'},  					--魔法闪避百分比加成
    {key=60,field='hp_recover_p'},  				--生命恢复百分比加成
    {key=61,field='mp_recover_p'},  				--魔法恢复百分比加成
    {key=62,field='resurgence_p'},  				--死亡恢复百分比加成
    {key=63,field='damage_offset_p'},  				--伤害抵消百分比加成
}

GuildPosition = {
	[0] = "非会员",
	[1] = "会长",
	[2] = "副会长",
	[3] = "长老",
	[4] = "精英",
	[5] = "成员"
}


CorpsPosition = {
	[0] = "非会员",
	[1] = "团长",
	[2] = "副团长",
	[3] = "长老",
	[4] = "精英",
	[5] = "成员"
}

SoulColorArr = {
  	
	["0"] = cc.c3b(255,255,255),
	["1"] = cc.c3b(255,255,255),
   	["2"] = cc.c3b(0,255,13),
   	["3"] = cc.c3b(80,179,211),
   	["4"] = cc.c3b(227,47,216),
   	["5"] = cc.c3b(242,158,25),
   	["6"] = cc.c3b(235,12,12),
   	["7"] = cc.c3b(255,235,62),

}

--人物形象层级
RoleLayerArr = {
	kGHEffectLayerId = 1,--光环动画层次
	kShadowLayerId = 2, --阴影层次
	kFootLayerId = 3,--脚动画层次
	kButtomAttackEffectLayerId = 100,  --底部攻击效果层次

	kHurtType1LayerId = 30000,--字体类型1的层次
	kHurtType2LayerId = 30001,--字体类型2的层次
	kHurtType3LayerId = 30002,--字体类型3的层次
	kManualAddHurtLayerId = 4,--人工加上的层次 暂时没有使用
	kTopContainerLayerId = 25000,--头部层次
	kHpContainerLayerId = 20000,--血量层次
	kTeamLayerId = 21000,--队伍标识层次
	kUnionLayerId = 22000,--阵营标识层次
	kTopEffectLayerId = 7,--  顶部的动画层次

	kTopAttackEffectlayerId = 100,  --顶部攻击效果层次



}