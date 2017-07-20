-- 自动生成，请勿修改 
-- 时间：2016/10/10
-- 21102585@qq.com

local active_service_merge_typeConfig = class("active_service_merge_typeConfig")
function active_service_merge_typeConfig:ctor()
	self.fields = {"id", "list_id", "name", "viewType", "title_img", "sort", "des1", "des2", "tipsId"}
	self.datas = {
		[1] = {1, 1, "合服累充", "mergeTotalChargeWin", "serveActivity_font1.png", 3, 0, 0, 99},
		[2] = {2, 1, "超值礼包", "MergeBuyWin", "serveActivity_font2.png", 4, 0, 0, 101},
		[9] = {9, 1, "首杀BOSS", "mergeBossWin", "", 6, 0, 0, 100},
		[15] = {15, 1, "战力排名", "MergeRankWin", "", 5, "<font color='f4e6d5' size='16' opacity='255'>战力达到<font color='00ff0d' size='16' opacity='255'>60000以上</font>的玩家可以进入排名，结束时排名前3的玩家获得排名奖励，邮件发送。</font>", 0, 0},
		[16] = {16, 1, "合服首充", "mergeChargeWin", "", 2, 0, 0, 102},
		[17] = {17, 1, "登录大礼", "mergeLoginWin", "", 1, 0, 0, 103},
		[18] = {18, 1, "合服双倍", "mergeEXPWin", "", 7, 0, 0, 0},
		[19] = {19, 1, "合服攻城", "mergeSBKWin", "", 8, 0, 0, 0},
		[20] = {20, 1, "合服转盘", 0, "", 9, 0, 0, 0},

	}
end
return active_service_merge_typeConfig
