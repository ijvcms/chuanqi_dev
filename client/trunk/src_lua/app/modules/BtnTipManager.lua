--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-02-27 16:00:36
-- 按钮红点提示管理器
BtnTipManager=BtnTipManager or class("BtnTipManager")
BtnTipsType = {
	BTN_ACTIVITY = 1,--活动中心
	BTN_DAILY_TARGET = 2,--今日目标
	BTN_ARENA = 3,--排位赛
	BTN_TASK_MERIT = 4,--功勋任务
	BTN_WORSHIP = 5,--膜拜英雄
	BTN_INSTANCE_SINGLE = 6,--个人副本
	BTN_WELFARE = 7,--福利大厅
	BTN_LOGIN = 8,--连续登陆
	BTN_AWARD_ONLINE = 9,--在线奖励
	BTN_STRATEGY = 10,--游戏攻略
	BTN_EQUIP = 11,--装备
	BTN_MEDAL = 12,--勋章
	BTN_MEDAL_UPGRADE = 13,--升级
	BTN_ACTIVITY_DAILY = 14,--日常任务
	-- BTN_ACTIVITY = 15,--活动中心
	BTN_ACTIVITY_TIMEACTIVITY = 55,--限时活动
	BTN_ACTIVE_GUILD= 15,--行会
	BTN_ACTIVE_EXCHAGE = 26,--交易所
	BTN_ACTIVE_WZAD = 56,--未知暗殿
	BTN_ACTIVE_TLDH = 57,--屠龙大会
	BTN_ACTIVE_SZWW = 58,--胜者为王
	BTN_SALE = 27,--领取物品
	BTN_GUILD_INFO = 16,--{16, "行会信息", "", 15, 1},
	BTN_GUILD_CONTRIBUTION = 17,--	[17] = {17, "每日捐献", "BTN_GUILD_CONTRIBUTION", 16, 1},
	BTN_GUILD_ACTIVITY = 18,--	[18] = {18, "行会活动", "", 15, 1},
	BTN_GUILD_BOSS = 19,--	[19] = {19, "行会BOSS", "BTN_GUILD_BOSS", 18, 1},
	BTN_GUILD_MJ = 20,--		[20] = {20, "行会秘境", "BTN_GUILD_MJ", 18, 1},
	BTN_SBK_MJ = 21,--	[21] = {21, "沙巴克秘境", "BTN_SBK_MJ", 18, 1},
	BTN_GUILD_APPLY_LIST = 22,--	[22] = {22, "申请列表", "BTN_GUILD_APPLY_LIST", 15, 0},
	BTN_ACTIVE_TIME = 55,--限时活动
	BTN_EMAIL = 24,--邮件
	BTN_SIGN = 28,--签到
	BTN_MONTH_GOODS = 68, --月卡
	BTN_LV_GIFT = 72, --等级礼包

	BTN_HOOK = 65, --挂机
	BTN_HOOK_BOOS = 66, --挂机boss
	BTN_HOOK_RAIDS = 67, --挂机扫荡

	BTN_ACTIVE_SERVICE_UI = 87, --开服活动界面按钮
	BTN_ACTIVE_SERVICE_UI_RANK = 86, --开服活动界面排行按钮
 
	BTN_ACTIVE_SERVICE_RECHARGE = 89,--1充值送大礼
	BTN_ACTIVE_SERVICE_STREN_ZK = 90,--2强化折扣日
	BTN_ACTIVE_SERVICE_YBXH = 91,--3消耗元宝送物品
	BTN_ACTIVE_SERVICE_SMSDHK = 92,--4神秘商店回馈
	BTN_ACTIVE_SERVICE_YJZK = 93,--5印记折扣
	BTN_ACTIVE_SERVICE_SMSDHK2 = 94,--6神秘商店回馈

	BTN_ACTIVE_SERVICE = 59, --开服活动
	BTN_ACTIVE_SERVICE_LV = 60, --等级活动
	BTN_ACTIVE_SERVICE_FIGHT = 61, --战力活动
	BTN_ACTIVE_SERVICE_MEDAL = 62, --勋章活动
	BTN_ACTIVE_SERVICE_WING = 63, --翅膀活动
	BTN_ACTIVE_SERVICE_STREN = 64, --强化活动
	BTN_ACTIVE_SERVICE_CYZZ = 69, --赤月紫装欢乐送
	BTN_ACTIVE_SERVICE_LCJY = 74, --赤月紫装欢乐送
	BTN_ACTIVE_SERVICE_BSS = 75, --赤月紫装欢乐送

	BIN_FIRST_CHARGR = 25,--首充
	BIN_DOWNLOAD = 52,--下载奖励

	--VIP
	BIN_VIP_BUTTON = 31,
	BTN_VIP_REWARD_1 = 32,
	BTN_VIP_REWARD_2 = 33,
	BTN_VIP_REWARD_3 = 34,
	BTN_VIP_REWARD_4 = 35,
	BTN_VIP_REWARD_5 = 36,
	BTN_VIP_REWARD_6 = 37,
	BTN_VIP_REWARD_7 = 38,
	BTN_VIP_REWARD_8 = 39,
	BTN_VIP_REWARD_9 = 40,
	BTN_VIP_REWARD_10 = 41,
	BTN_VIP_REWARD_11 = 42,
	BTN_VIP_REWARD_12 = 43,
	BTN_VIP_REWARD_13 = 44,
	BTN_VIP_REWARD_14 = 45,
	BTN_VIP_REWARD_15 = 46,

	BIN_SET = 47,        --设置
	BIN_AUTO_DRINK  = 48,--自动喝药

	BIN_AUTO_DRINK1  = 481,
	BIN_AUTO_DRINK2  = 482,
	BIN_AUTO_DRINK3  = 483,
	BIN_AUTO_DRINK4  = 484,

	BTN_ROLE = 76,
	BTN_ROLE_STAMP = 77,
	BTN_ROLE_STAMP_HP = 78,
	BTN_ROLE_STAMP_ATK = 79,
	BTN_ROLE_STAMP_DEF = 80,
	BTN_ROLE_STAMP_MDEF = 81,
	BTN_ROLE_STAMP_HOLY = 82, 	
	BTN_ACTIVE_MAC = 83,--怪物攻城
	BTN_GUILD_APPLY = 84,--行会申请按钮

	BTN_ROLE_WING = 88,--角色翅膀红点

	BTN_GROUP_TAG = 95,--军团标签页
	BTN_GUIDE_TAG = 96,--行会标签页
	BTN_GROUP_APPLY_LIST = 97,--军团申请红点
	BTN_MERGE_ACTIVITY = 98,--合服活动红点

	BTN_EXP_DOUBLE = 109,--全服双倍

	BTN_ROLE_RIDE = 980,--角色坐骑
	BTN_ROLE_RIDE_STRENG1 = 990,--角色坐骑
	BTN_ROLE_RIDE_STRENG2 = 1000,--角色坐骑
	BTN_ROLE_RIDE_STRENG3 = 1010,--角色坐骑
	BTN_ROLE_RIDE_STRENG4 = 1020,--角色坐骑强化
	BTN_ROLE_RIDE_UP = 1030,--角色坐骑升阶
}

--GameNet:sendMsgToSocket(9001,{id = 10,num = 1})
function BtnTipManager:ctor()
	self.tipKeyDic = {} --记录当前Key的值
	self.tipKeyBtnDic = {}
	GameNet:registerProtocal(9000,handler(self,self.onHandle9000))
	GameNet:registerProtocal(9001,handler(self,self.onHandle9001))
end

function BtnTipManager:onHandle9000(data)
	--dump(data.button_list)
	if data.button_list then 
		for i=1,#data.button_list do
			local item = data.button_list[i]
			self:setKeyValue(item["id"],item["num"])
			
			--self:setKeyValue(item["id"],1)
		end
	end
end

function BtnTipManager:onHandle9001(data)
	self:onHandle9000(data)
	print("============>BtnTipManager:onHandle9000")
end

function BtnTipManager:init()
	if self.tipKeyBtnDic == nil then
		self.tipKeyBtnDic = {} --记录当前Key对应的按钮
	end
end

--获取Key对应值
function BtnTipManager:getKeyValue(key)
	if self.tipKeyDic[key] ~= nil then
		return self.tipKeyDic[key]
	end
	return 0
end
--设置Key对应值
function BtnTipManager:setKeyValue(key,value)
	self.tipKeyDic[key] = value
	if value > 0 then
		if self.tipKeyBtnDic[key] then
			self.tipKeyBtnDic[key]:showClickTip(value)
		end
	else
		if self.tipKeyBtnDic[key] then
			self.tipKeyBtnDic[key]:closeClickTip()
		end
	end
end
--删除Key对应值
function BtnTipManager:delKeyValue(key)
	self.tipKeyDic[key] = 0
end

--设置Key对应按钮
function BtnTipManager:setKeyBtn(key,btn)
	self.tipKeyBtnDic[key] = btn
	local value = self.tipKeyDic[key]
	if value ~= nil and value > 0  then
		btn:showClickTip(value)
	else
		btn:closeClickTip()
	end
end
--删除Key对应按钮
function BtnTipManager:delKeyBtn(key)
	if self.tipKeyBtnDic[key] then
		self.tipKeyBtnDic[key]:closeClickTip()
	end
	self.tipKeyBtnDic[key] = nil
end

function BtnTipManager:destory()
	self.tipKeyBtnDic = {}
end