%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%        自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------
-define(GAMECONFIG_PROTO_HP_SET, {proto_hp_set,1,80,0,80,0}).  %% {proto_hp_set,是否开启 1开启-0关闭,血量百分比,血量物品Id,蓝量百分比,蓝量物品Id}---回复初始设置
-define(GAMECONFIG_PROTO_HPMP_SET, {proto_hpmp_set,1,30,0}).  %% {proto_hpmp_set,是否开启1开启-0关闭,血量百分比,物品Id}--瞬间回复初始设置
-define(GAMECONFIG_MAX_FRIEND_NUM, 20).  %% 最大好友数
-define(GAMECONFIG_MAX_BLACK_NUM, 20).  %% 最大黑名单数
-define(GAMECONFIG_MAX_FRIEND_ASK_NUM, 20).  %% 最大申请列表
-define(GAMECONFIG_MAX_FOE_NUM, 20).  %% 最大仇人数
-define(GAMECONFIG_SHACHENG_START_RULE, {3, 6, {20, 00}, {21, 00}}).  %% 沙城活动开启规则{开服几天后开启, 周几, 开启时间, 结束时间}, 开始时间/结束时间格式:{小时, 分钟}
-define(GAMECONFIG_GUISE_STATE, {guise_state,0,10,0,0,0,0}).  %% 玩家的初始外观
-define(GAMECONFIG_EQUIP_SELL_SET, {proto_equip_sell_set,1,1,1,1,1}).  %% 装备出售初始设置{,自动出售,白色自动,绿色自动,蓝色自动,紫色自动}
-define(GAMECONFIG_PiCKUP_SET, {proto_pickup_set,1,[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1]}).  %% 拾取装备初始设置{,自动拾取,[白,绿,蓝,紫,澄色自动],[白,绿,蓝,紫,澄色自动],[特殊组标识]}
-define(GAMECONFIG_WORSHIP_JADE, 30).  %% 元宝膜拜消耗
-define(GAMECONFIG_FIRST_SCENE, 20101).  %% 首次登陆场景
-define(GAMECONFIG_CAREER_TITLE_LIMIT_LV, 30).  %% 第一称号出现的等级限制
-define(GAMECONFIG_SALE_EXPIRED_TIME, 72 * 3600).  %% 拍卖场玩家领取物品的过期时间  （单位秒） 
-define(GAMECONFIG_SALE_TAX, 0.05).  %% 拍卖场 交易税
-define(GAMECONFIG_SALE_SELL_TIME, 200).  %% 拍卖场上架物品， 每小时单价 （金币）
-define(GAMECONFIG_SALE_RECEIVE_TIME_OUT, 5000).  %% 拍卖场 领取物品过期后 额外需要支付的 金币
-define(GAMECONFIG_SALE_SELL_NUM, 20).  %% 拍卖场 玩家可以上架的物品上限
-define(GAMECONFIG_NEW_DEF_LV, 35).  %% 新手保护时间
-define(GAMECONFIG_SBK_WIN_MAIL_ID, 83).  %% 沙巴克胜利行会发放的邮件id

%% ===================================================================
%% define
%% ===================================================================
