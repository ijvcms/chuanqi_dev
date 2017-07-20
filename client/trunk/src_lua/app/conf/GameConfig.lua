--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-03-25 09:28:48
-- 游戏配置信息
GameBaseConfig = {
--id 游戏ID score 标准分，name游戏名称，introPic 介绍图片,scene游戏场景名称
	[10000] = {id = 1,score = 10,name = "    ",scene = "ASMDScene", dbTable = "", groupCount = 0, introPic = "game/img_tip_game_1.png",encourageNum = 6,},
	[1] = {id = 1,score = 40,name = "加减乘除",scene = "ASMDScene", dbTable = "", groupCount = 4, introPic = "game/img_tip_game_1.png",encourageNum = 6,},
	[2] = {id = 2,score = 12,name = "方向达人",scene = "FXDRScene", dbTable = "", groupCount = 1, introPic = "game/img_tip_game_2.png",encourageNum = 6,},
	[3] = {id = 3,score = 9,name = "顺序击破",scene = "SXJPScene", dbTable = "", groupCount = 3, introPic = "game/img_tip_game_3.png",encourageNum = 4,},
	[4] = {id = 4,score = 5,name = "雨伞挡雨",scene = "YSDYScene", dbTable = "", groupCount = 0, introPic = "game/img_tip_game_4.png",encourageNum = 3,},
	[5] = {id = 5,score = 44,name = "点击加法",scene = "DJJFScene", dbTable = "", groupCount = 1, introPic = "game/img_tip_game_5.png",encourageNum = 3,},
	[6] = {id = 6,score = 35,name = "颜色陷阱",scene = "YSXJScene", dbTable = "", groupCount = 6, introPic = "game/img_tip_game_6.png",encourageNum = 3,},
	[7] = {id = 7,score = 18,name = "反序击破",scene = "FXJPScene", dbTable = "", groupCount = 3, introPic = "game/img_tip_game_7.png",encourageNum = 4,},
	[8] = {id = 8,score = 21,name = "翻盘记忆",scene = "FPJYScene", dbTable = "", groupCount = 3, introPic = "game/img_tip_game_8.png",encourageNum = 6,},
	[9] = {id = 9,score = 25,name = "色迷心窍",scene = "SMXJScene", dbTable = "", groupCount = 0, introPic = "game/img_tip_game_9.png",encourageNum = 6,},
	[10] = {id = 10,score = 46,name = "简易运算",scene = "JYYSScene", dbTable = "", groupCount = 4, introPic = "game/img_tip_game_10.png",encourageNum = 6,},
	[11] = {id = 11,score = 15,name = "快速分类",scene = "KSFLScene", dbTable = "wewars_lib_quicksort", groupCount = 1, introPic = "game/img_tip_game_11.png",encourageNum = 6,},
	[12] = {id = 12,score = 15,name = "点击色块",scene = "DJSKScene", dbTable = "wewars_lib_clickcolor", groupCount = 1, introPic = "game/img_tip_game_12.png",encourageNum = 6,},
	[13] = {id = 13,score = 45,name = "天气预报",scene = "TQYBScene", dbTable = "wewars_lib_weather", groupCount = 3, introPic = "game/img_tip_game_13.png",encourageNum = 6,},
	[14] = {id = 14,score = 4,name = "别踩白块",scene = "BCBKScene", dbTable = "wewars_lib_notwhite", groupCount = 5, introPic = "game/img_tip_game_14.png",encourageNum = 6,},
	[15] = {id = 15,score = 21,name = "开大开小",scene = "KDKXScene", dbTable = "wewars_lib_bigsmall", groupCount = 1, introPic = "game/img_tip_game_15.png",encourageNum = 6,},
	[16] = {id = 16,score = 45,name = "见钱眼开",scene = "JQYKScene", dbTable = "wewars_lib_money", groupCount = 1, introPic = "game/img_tip_game_16.png",encourageNum = 6,},
	
	[17] = {id = 17,score = 10,name = "升序降序",scene = "SXJXScene", dbTable = "wewars_lib_ascdesc", groupCount = 3, introPic = "game/img_tip_game_17.png",encourageNum = 6,},
	[18] = {id = 18,score = 45,name = "速算大小",scene = "SSDXScene", dbTable = "wewars_lib_quickbigsmall", groupCount = 3, introPic = "game/img_tip_game_18.png",encourageNum = 6,},
	
	[19] = {id = 19,score = 22,name = "方块记忆",scene = "FKJYScene", dbTable = "wewars_lib_rememberblock", groupCount = 1, introPic = "game/img_tip_game_19.png",encourageNum = 6,},
	[20] = {id = 20,score = 50,name = "看图解锁",scene = "KTJSScene", dbTable = "wewars_lib_squaredunlock", groupCount = 1, introPic = "game/img_tip_game_20.png",encourageNum = 6,},
}
