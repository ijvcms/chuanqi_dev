-- 自动生成，请勿修改 
-- 时间：2016/10/12
-- 21102585@qq.com

local activity_listConfig = class("activity_listConfig")
function activity_listConfig:ctor()
	self.fields = {"id", "type", "is_high_yield", "icon_file", "text_file", "describe", "btn_label", "time", "is_show_num", "function_id", "skip"}
	self.datas = {
		[101] = {101, 1, 1, "activity26.png", "activity13.png", "<font color='0xDBAE67' size='20' opacity='255'>主要<font color='0x00EE00' size='20' opacity='255'>经验</font></font>", "日常任务", "", 1, 36, "npc,7507,1"},
		[102] = {102, 1, 1, "activity22.png", "activity16.png", "<font color='0xDBAE67' size='20' opacity='255'>巨额<font color='0x00EE00' size='20' opacity='255'>经验</font></font>", "膜拜英雄", "", 1, 24, "npc,7524,1"},
		[103] = {103, 1, 0, "activity23.png", "activity14.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>声望</font></font>", "排位赛", "", 1, 18},
		[104] = {104, 1, 0, "activity20.png", "activity12.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>功勋</font></font>", "功勋任务", "", 1, 23, "npc,7522,1"},
		[105] = {105, 1, 0, "activity46.png", "activity47.png", "<font color='0xDBAE67' size='20' opacity='255'>各种<font color='0x00EE00' size='20' opacity='255'>奖励</font></font>", "藏宝图", "", 1, 83, "npc,7590,1"},
		[107] = {107, 1, 1, "activity21.png", "activity15.png", "<font color='0xDBAE67' size='20' opacity='255'>各种<font color='0x00EE00' size='20' opacity='255'>材料</font></font>", "个人副本", "", 0, 26},
		[108] = {108, 1, 0, "activity49.png", "activity6.png", "<font color='0xDBAE67' size='20' opacity='255'>各种<font color='0x00EE00' size='20' opacity='255'>奖励</font></font>", "敬请期待", "", 0, 118},
		[201] = {201, 2, 1, "activity28.png", "activity38.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>奖励</font></font>", "屠龙大会", "12:15--12:45", 0, 38},
		[202] = {202, 2, 1, "activity29.png", "activity39.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>功勋</font></font>", "胜者为王", "14:00--14:30", 0, 39},
		[203] = {203, 2, 1, "activity33.png", "activity37.png", "<font color='0xDBAE67' size='20' opacity='255'>稀有<font color='0x00EE00' size='20' opacity='255'>装备</font></font>", "神秘暗殿", "15:30--16:00", 0, 37},
		[204] = {204, 2, 1, "activity30.png", "activity32.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>装备</font></font>", "行会Boss", "21:00--21:30", 0, 43},
		[205] = {205, 2, 1, "activity34.png", "activity18.png", "<font color='0xDBAE67' size='20' opacity='255'>稀有<font color='0x00EE00' size='20' opacity='255'>装备</font></font>", "行会秘境", "21:00--22:00", 0, 44},
		[206] = {206, 2, 1, "main_guildIcon.png", "activity19.png", "<font color='0xDBAE67' size='20' opacity='255'>独特<font color='0x00EE00' size='20' opacity='255'>装备</font></font>", "沙城秘境", "不定时", 0, 5},
		[207] = {207, 2, 1, "activity41.png", "activity40.png", "<font color='0xDBAE67' size='20' opacity='255'>大量<font color='0x00EE00' size='20' opacity='255'>装备</font></font>", "怪物攻城", "20:00--20:45", 0, 75},

	}
end
return activity_listConfig
