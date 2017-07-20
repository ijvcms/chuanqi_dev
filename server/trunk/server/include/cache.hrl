%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2015 下午12:10
%%%-------------------------------------------------------------------

-define(DB_OPERATE_INSERT, 1).    %% 插入记录
-define(DB_OPERATE_UPDATE, 2).    %% 更新记录
-define(DB_OPERATE_DELETE, 3).    %% 删除记录

-record(conf_cache, {
	table_name,
	key,
	db_agent,
	init_time,
	hit_add_time
}).
%% ets 数据库写入缓存
-record(ets_cache, {
	key,
	info
}).

%% 数据库查询缓存
-define(CACHE_EFFECTIVE, cache_effective).
-record(cache_effective, {
	tab_key, %% {表名, 表主键}
	effective_time
}).

-define(CACHE_OPERATE, cache_operate).
-record(cache_operate, {
	tab_key,
	operate,
	update_fields = [] %% 暂时没用到，可以扩展
}).

%% ===========================================================================
%% 自定义宏和record(加新表的时候需要在这里添加，对应数据库表明)
%% ===========================================================================
%% 用户信息表
-define(DB_PLAYER_BASE, db_player_base).
-record(db_player_base, {
	player_id, %% id
	name, %% 名字
	lv, %% 等级
	exp, %% 经验
	sex, %% 性别
	career, %% 职业
	register_time, %% 注册时间戳
	last_login_time, %% 最后登录时间
	last_logout_time, %% 最后离线时间
	os_type, %% 系统类型
	scene_id, %% 当前所在场景id
	x, %% 当前所在x坐标
	y, %% 当前所在y坐标
	pass_hook_scene_id, %% 通关挂机场景id
	hook_scene_id, %% 挂机场景id
	last_hook_time, %% 最后挂机时间
	draw_hook_time, %% 领取挂机奖励时间
	challenge_num, %% 当天可挑战次数
	buy_challenge_num, %% 当日购买挑战次数
	reset_challenge_time, %% 挑战重置时间
	power, %% 当前体力
	power_recover_time, %% 体力恢复时间
	buy_power_num, %% 当日购买体力次数
	reset_buy_power_time, %% 当日购买次数重置时间
	bag, %% 背包格子容量
	forge, %% 锻造id
	guild_id, %% 帮派id
	legion_id, %% 军团id
	set_pk_mode, %% 自己设定的pk模式
	pk_mode, %% pk模式
	pk_value, %% pk值
	vip, %% vip等级
	blood_bag, %% 血包
	ref_task_time, %% 记录任务刷新时间
	task_reward_active, %% 任务领取奖励记录
	hp_set, %% 回复设置信息
	hpmp_set, %% 瞬间回复设置
	fight, %% 战力
	instance_reset_time, %% 副本进入次数重置时间
	guise, %% 外观属性
	fh_cd, %% 复活戒指cd
	ring_transfer_cd, %% 传送戒指使用cd
	skill_set, %% 群体技能设置开关
	equip_sell_set, %% 装备自动出售设置
	pickup_set, %% 自动拾取设置
	vip_exp, %% vip经验
	pet_att_type, %% 宠物攻击类型
	limit_chat, %% 禁言时间
	limit_login, %% 封角色时间
	wing_state, %% 翅膀外观状态0显示 1不显示
	weapon_state, %% 特武外观状态0显示 1不显示
	guild_task_time, %% 公会任务刷新时间
	guild_task_id, %% 公会任务id记录
	lottery_num, %% 玩家抽奖次数
	lottery_coin_num, %% 玩家金币抽奖次数
	is_robot, %% 是否是机器人
	instance_left_time, %% 个人boss剩余时间
	state, %% 玩家状态
	lottery_num_1, %% 神皇秘境抽奖次数
	lottery_score_get_1, %% 神皇秘境得到的积分
	lottery_score_use_1 %% 神皇秘境已经使用的积分
}).

%% 用户信息表
-define(DB_GOODS, db_goods).
-record(db_goods, {
	id,
	player_id,
	goods_id,
	is_bind,
	num,
	stren_lv = 0,
	soul = 0,
	location = 0,
	grid = 0,
	extra = [],
	secure = 0,
	bless = 0,
	update_time = 0,
	expire_time = 0,
	server_id = 0
}).

%% 玩家货币表
-define(DB_PLAYER_MONEY, db_player_money).
-record(db_player_money, {
	player_id,
	coin,
	jade,
	gift,
	smelt_value,
	feats,
	hp_mark_value,
	atk_mark_value,
	def_mark_value,
	res_mark_value
}).

%% 玩家标记
-define(DB_PLAYER_MARK, db_player_mark).
-record(db_player_mark, {
	player_id,
	hp_mark,
	atk_mark,
	def_mark,
	res_mark,
	holy_mark,
	mounts_mark_1,
	mounts_mark_2,
	mounts_mark_3,
	mounts_mark_4,
	update_time
}).

%% 玩家属性表
-define(DB_PLAYER_ATTR, db_player_attr).
-record(db_player_attr, {
	player_id,
	cur_hp,
	cur_mp,
	last_recover_hp,
	last_recover_mp
}).

%% 玩家计数器
-define(DB_PLAYER_COUNTER, db_player_counter).
-record(db_player_counter, {
	player_id,
	counter_id,
	value,
	update_time
}).

%% 玩家邮件
-define(DB_PLAYER_MAIL, db_player_mail).
-record(db_player_mail, {
	id,
	player_id,
	mail_id = 0,
	mail_type = 0,
	sender = "",
	title = "",
	content = "",
	award = [],
	state = 0,
	send_time = 0,
	limit_time = 0,
	update_time = 0
}).

%% 玩家帮派
-define(DB_PLAYER_GUILD, db_player_guild).
-record(db_player_guild, {
	player_id,
	name,
	career,
	sex,
	lv,
	guild_id,
	guild_name,
	position,
	fight,
	contribution,
	totoal_contribution,
	extra,
	join_time,
	login_time,
	update_time
}).


%% 帮派
-define(DB_GUILD, db_guild).
-record(db_guild, {
	guild_id, %% 帮派id
	guild_name, %% 名称
	state, %% 状态:0:未激活,1正常
	rank, %% 排名
	member_count, %% 成员数量
	lv, %% 等级
	expe, %% 经验
	active, %% 活跃点
	chief_id, %% 会长ID
	chief_name, %% 会长昵称
	capital, %% 行会资金
	public_announce, %% 外部公告
	internal_announce, %% 内部公告
	create_time, %% 创建时间
	extra, %% 额外数据(申请设置)
	update_time %% 更新时间
}).

%% 玩家帮派商店
-define(DB_PLAYER_GUILD_SHOP, db_player_guild_shop).
-record(db_player_guild_shop, {
	player_id,
	shop_id,
	count,
	update_time
}).

%% 帮派结盟信息
-define(DB_GUILD_ALLIANCE, db_guild_alliance).
-record(db_guild_alliance, {
	guild_id, %% 工会id
	alliance_id %% 结盟id
}).

%% 宝石
-define(DB_PLAYER_GEM, db_player_gem).
-record(db_player_gem, {
	player_id,
	goods_id,
	equips_type,
	gem_type,
	extra = [],
	update_time
}).

%% 玩家竞技场排名
-define(DB_ARENA_RANK, db_arena_rank).
-record(db_arena_rank, {
	player_id,
	rank,
	name,
	sex,
	lv,
	career,
	fighting,
	guild_id,
	extra = [],
	update_time
}).

%% 玩家竞技场记录
-define(DB_ARENA_RECORD, db_arena_record).
-record(db_arena_record, {
	player_id,
	reputation = 0,
	match_list = [],
	arena_list = [],
	update_time
}).


%% 竞技场商店
-define(DB_ARENA_SHOP, db_arena_shop).
-record(db_arena_shop, {
	id,
	player_id,
	count,
	update_time
}).

%% 技能表
-define(DB_SKILL, db_skill).
-record(db_skill, {
	player_id, %% 玩家id
	skill_id, %% 技能id
	lv, %% 技能等级
	exp, %% 技能熟练度
	pos, %% 技能快捷键位置
	auto_set, %% 自动设置开关
	next_time %% 下次可释放技能时间
}).

%% buff表
-define(DB_BUFF, db_buff).
-record(db_buff, {
	player_id,
	buff_id,
	next_time,
	remove_time,
	extra_info
}).

%% 每日任务表
-define(DB_DAILY_TASKS, db_daily_tasks).
-record(db_daily_tasks, {
	player_id,
	task_id,
	finish_times,
	update_time
}).

%% 挂机星级
-define(DB_PLAYER_HOOK_STAR, db_player_hook_star).
-record(db_player_hook_star, {
	player_id,
	hook_scene_id,
	star,
	reward_status
}).

%% 挂机星级奖励
-define(DB_HOOK_STAR_REWARD, db_hook_star_reward).
-record(db_hook_star_reward, {
	player_id,
	chapter,
	step_list
}).

%% ===================================================================
%% 玩家任务表信息
%% ===================================================================
-define(DB_PLAYER_TASK, db_player_task).
-record(db_player_task, {
	player_id,
	taskid_id,
	nownum,
	isfinish
}).

%% ===================================================================
%% 玩家完成任务列表
%% ===================================================================
-define(DB_PLAYER_TASK_FINISH, db_player_task_finish).
-record(db_player_task_finish, {
	player_id, %% 玩家id
	taskid_id %% 任务id
}).

%% ===================================================================
%% 玩家仇人表
%% ===================================================================
-define(DB_PLAYER_FOE, db_player_foe).
-record(db_player_foe, {
	player_id, %% 玩家id
	tplayer_id, %% 仇人Id
	time %% 添加时间
}).
%% ===================================================================
%% 玩家好友表
%% ===================================================================
-define(DB_PLAYER_FRIEND, db_player_friend).
-record(db_player_friend, {
	player_id, %% 玩家Id
	tplayer_id %% 好友Id
}).

%% ===================================================================
%% 玩家申请表
%% ===================================================================
-define(DB_PLAYER_FRIEND_ASK, db_player_friend_ask).
-record(db_player_friend_ask, {
	player_id, %% 玩家id
	tplayer_id, %% 申请人id
	asktime %% 申请时间
}).

%% ===================================================================
%% 黑名单表
%% ===================================================================
-define(DB_PLAYER_BLACK, db_player_black).
-record(db_player_black, {
	player_id, %% 玩家id
	tplayer_id, %% 黑名单玩家Id
	time %% 拉黑时间
}).

%% ===================================================================
%% 玩家副本映射表
%% ===================================================================
-define(DB_PLAYER_INSTANCE, db_player_instance).
-record(db_player_instance, {
	player_id, %% 玩家id
	scene_id, %% 副本场景id
	enter_times, %% 进入次数
	buy_times %% 购买次数
}).

%% ===================================================================
%% 城市任命信息
%% ===================================================================
-define(DB_CITY_OFFICER, db_city_officer).
-record(db_city_officer, {
	scene_id, %% 职位id
	player_id, %% 沙巴克场景id
	officer_id, %% 玩家id
	day_time, %% 每日奖励领取时间
	frist_player_id, %% 第一次领取的人的id
	day_officer_id, %% 每日奖励领取的 哪种官职的奖励
	is_del, %% 是否删除 1是删除
	every_player_id %% 每次攻城领取玩家id
}).

%% ===================================================================
%% 城市信息
%% ===================================================================
-define(DB_CITY_INFO, db_city_info).
-record(db_city_info, {
	scene_id, %% 城市场景id
	guild_id, %% 帮会ID
	occupy_time, %% 占领时间
	frist_player_id, %%
	every_player_id %%
}).


%% ===================================================================
%% 宠物信息
%% ===================================================================
-define(DB_PET, db_pet).
-record(db_pet, {
	player_id, %% 玩家id
	pet_list, %% 宠物列表
	effective_time %% 有效期
}).

%% ===================================================================
%% 玩家新手引导信息
%% ===================================================================
-define(DB_PLAYER_GUIDE, db_player_guide).
-record(db_player_guide, {
	player_id, %% 玩家新手引导记录
	guide_step_id %% 新手引导记录id
}).

%% ===================================================================
%% 玩家vip奖励领取纪录
%% ===================================================================
-define(DB_PLAYER_VIP, db_player_vip).
-record(db_player_vip, {
	player_id, %% 玩家vip奖励领取记录
	vip_lv %% vip等级
}).

%% ===================================================================
%% 玩家分包奖励领取记录
%% ===================================================================
-define(DB_PLAYER_PACKAGE, db_player_package).
-record(db_player_package, {
	player_id, %% 玩家下载的包记录表
	lv, %% 玩家记录的等级
	is_receive %% 是否已经领取了这个奖励了1是已经领取了，0是还未领取
}).

%% ===================================================================
%% 玩家拍卖场领取信息
%% ===================================================================
-define(DB_PLAYER_SALE, db_player_sale).
-record(db_player_sale, {
	id, %% 编号id
	player_id, %% 拍卖玩家id
	goods_id, %% 拍卖物品id
	num, %% 数量
	stren_lv, %% 强化等级
	jade, %% 拍卖多少元宝
	state, %% 状态 1 已退出，2 出售成功，3 表示已下架,4 已购买
	update_time, %% 更新时间
	extra, %% 道具存储数据
	soul, %% 铸魂
	secure %% 保险次数
}).

%% ===================================================================
%% 拍卖场信息
%% ===================================================================
-define(DB_SALE, db_sale).
-record(db_sale, {
	sale_id, %% 编号id
	player_id, %% 拍卖玩家id
	goods_id, %% 拍卖物品id
	sale_sort, %% 拍卖物品类型
	num, %% 数量
	jade, %% 拍卖多少元宝
	begin_time, %% 拍卖开始时间
	end_time, %% 拍卖结束时间
	stren_lv, %% 强化等级
	extra, %% 道具存储数据
	soul, %% 铸魂
	secure %% 保险次数
}).

%% ===================================================================
%% 按钮信息
%% ===================================================================
-define(DB_BUTTON_TIPS, db_button_tips).
-record(db_button_tips, {
	player_id, %% 玩家id
	btn_id, %% 按钮id
	num %% 按钮提示数量
}).

%% ===================================================================
%% 怪物击杀信息
%% ===================================================================
-define(DB_MONSTER_KILLS, db_monster_kills).
-record(db_monster_kills, {
	monster_id, %% 怪物id
	scene_id, %% 场景id
	kill_count, %% 被击杀次数
	update_time %% 更新时间
}).

%% ===================================================================
%% 玩家充值信息
%% ===================================================================
-define(DB_PLAYER_CHARGE, db_player_charge).
-record(db_player_charge, {
	id, %% 订单编号id
	player_id, %% 玩家id
	platform, %% 渠道
	charge_key, %% 充值商品编号key
	rmb, %% 充值rmb
	charge_time, %% 充值时间
	state, %% 充值状态 0 订单开始，1，订单验证完成，2 订单完成
	is_bad, %% 是否坏账 1是,0不是
	platform_result %% 渠道返回信息
}).

%% ===================================================================
%% 每日签到记录
%% ===================================================================
-define(DB_PLAYER_SIGN, db_player_sign).
-record(db_player_sign, {
	player_id, %% 玩家id
	sign_month, %% 签到日期列表
	sign_list, %% 签到日期列表
	reward_list, %% 签到日期列表
	count, %% 补签次数
	update_time %% 更新时间
}).


%% ===================================================================
%% 副本通关纪录
%% ===================================================================
-define(DB_PLAYER_INSTANCE_PASS, db_player_instance_pass).
-record(db_player_instance_pass, {
	player_id, %% 玩家id
	scene_id, %% 副本场景id
	pass_time %% 通关时间
}).

%% ===================================================================
%% 掉落相关记录
%% ===================================================================
-define(DB_PLAYER_DROP, db_player_drop).
-record(db_player_drop, {
	player_id, %% 玩家id
	monster_id, %% 怪物id
	kill_count, %% 击杀次数
	update_time %% 更新时间
}).

-define(DB_SPECIAL_DROP, db_special_drop).
-record(db_special_drop, {
	drop_type, %% 掉落类型
	drop_num, %% 掉落数量
	next_time, %% 下次掉落刷新时间
	update_time %% 更新时间
}).

%% ===================================================================
%% 开服活动纪录信息
%% ===================================================================
-define(DB_PLAYER_ACTIVE_SERVICE, db_player_active_service).
-record(db_player_active_service, {
	player_id, %% 玩家id
	active_service_id, %% 开服活动id
	time %% 领取时间
}).


%% ===================================================================
%% 玩家月卡信息表
%% ===================================================================
-define(DB_PLAYER_MONTH, db_player_month).
-record(db_player_month, {
	player_id, %% 玩家id
	charge_key, %% 充值键值
	begin_time, %% 月卡开始时间
	end_time, %% 月卡结束时间
	time, %% 月卡领取奖励时间
	is_jade %% 是否领取元宝
}).

%% ===================================================================
%% 红包信息记录
%% ===================================================================
-define(DB_RED_RECORD, db_red_record).
-record(db_red_record, {
	red_id, %% 红包id
	active_service_id, %% 开服活动id
	player_id, %% 发送的玩家id
	name, %% 玩家名称
	position, %% 发送时玩家的职位 职位:0非会员,1会长,2长老,3会员
	red_type_id, %% 红包类型 0,一般红包 1，手气红包 ，2 定额红包
	guild_id, %% 帮派id
	min_jade, %% 红包最小奖励
	max_jade, %% 红包最大奖励
	num, %% 红包最大数量
	loss_num, %% 已经使用的红包数量
	jade, %% 总金额元宝
	loss_jade, %% 已经领取的金额元宝
	begin_time, %% 红包发送时间
	end_time, %% 红包结束时间
	des %% 红包说明
}).


%% ===================================================================
%% 红包领取信息
%% ===================================================================
-define(DB_PLAYER_RED, db_player_red).
-record(db_player_red, {
	red_id, %% 红包id
	player_id, %% 红包id
	id, %% 玩家id
	guild_id, %% 帮派id
	jade, %% 领取的元宝金额
	time %% 领取的时间
}).

%% ===================================================================
%% record 玩家首次击杀boss信息
%% ===================================================================
-define(DB_PLAYER_MONSTER, db_player_monster).
-record(db_player_monster, {
	monster_id, %% 怪物id
	player_id, %% 玩家id
	time, %% 击杀时间
	is_frist, %% 是否是全服首杀 0不是 1是
	is_frist_goods, %% 是否是领取全服首杀 0不是 1是
	is_goods %% 是否领取单次击杀 0不是 1是
}).


%% ===================================================================
%% 抽奖日志记录
%% ===================================================================
-define(DB_LOTTERY_LOG, db_lottery_log).
-record(db_lottery_log, {
	id, %% 编号id
	player_id, %% 玩家id
	lottery_id, %% 奖励id
	time, %% 抽取时间
	group_num %% 属于哪个轮数
}).

%% ===================================================================
%% 抽奖次数记录
%% ===================================================================
-define(DB_LOTTERY_DB, db_lottery_db).
-record(db_lottery_db, {
	lottery_id, %% 奖励id
	day_num, %% 每次抽取次数记录
	ref_time %% 刷新时间
}).

%% ===================================================================
%% 抽奖箱日志记录
%% ===================================================================
-define(DB_LOTTERY_BOX_LOG, db_lottery_box_log).
-record(db_lottery_box_log, {
	id, %% 编号id
	player_id, %% 玩家id
	lottery_id, %% 奖励id
	lottery_type,    %%类型
	time, %% 抽取时间
	group_num, %% 属于哪个轮数
	goods_id %%抽到的物品
}).

%% ===================================================================
%% 抽奖箱次数记录
%% ===================================================================
-define(DB_LOTTERY_BOX_DB, db_lottery_box_db).
-record(db_lottery_box_db, {
	lottery_id, %% 奖励id
	day_num, %% 每次抽取次数记录
	ref_time %% 刷新时间
}).

%% ===================================================================
%% 金币抽奖日志记录
%% ===================================================================
-define(DB_LOTTERY_COIN_LOG, db_lottery_coin_log).
-record(db_lottery_coin_log, {
	id, %% 编号id
	player_id, %% 玩家id
	lottery_coin_id, %% 奖励id
	time %% 抽取时间
}).

%% ===================================================================
%% 金币抽奖次数记录
%% ===================================================================
-define(DB_LOTTERY_COIN_DB, db_lottery_coin_db).
-record(db_lottery_coin_db, {
	lottery_coin_id, %% 奖励id
	day_num, %% 每次抽取次数记录
	ref_time %% 刷新时间
}).

%% ===================================================================
%% 功能信息记录
%% ===================================================================
-define(DB_FUNCTION, db_function).
-record(db_function, {
	id, %% 功能id
	begin_time, %% 开启时间
	end_time, %% 结束时间
	group_num %% 开启分组
}).


%% ===================================================================
%% 神秘商店
%% ===================================================================
-define(DB_PLAYER_MYSTERY_SHOP, db_player_mystery_shop).
-record(db_player_mystery_shop, {
	id, %% 编号
	player_id, %% 玩家id
	mystery_shop_id, %% 神秘商店id
	ref_time, %% 刷新时间
	is_buy %% 是否已经购买
}).

%% ===================================================================
%% 运营活动
%% ===================================================================
-define(DB_PLAYER_OPERATE_RECORD, db_player_operate_record).
-record(db_player_operate_record, {
	player_id, %% 玩家id
	active_id, %% 活动编号
	finish_limit_type, %% 完成条件类型
	finish_limit_value, %% 完成条件参数
	update_time %% 更新时间
}).

-define(DB_PLAYER_OPERATE_ACTIVE, db_player_operate_active).
-record(db_player_operate_active, {
	player_id, %% 玩家id
	active_id, %% 活动编号
	sub_type, %% 活动子类
	count, %% 完成次数
	update_time %% 更新时间
}).

%% 多个场景的怪物状态
-define(DB_PLAYER_MONSTER_STATE, db_player_monster_state).
-record(db_player_monster_state, {
	player_id, %% 玩家id
	refresh_time, %%刷新或失效时间
	hp_reset_time,        %%满血的时间
	monster_state %%多个场景的怪物状态列表，[{scene_id,[{monster_id,hp}]} ]
}).


%% ===================================================================
%% 开服活动记录
%% ===================================================================
-define(DB_PLAYER_ACTIVE_SERVICE_RECORD, db_player_active_service_record).
-record(db_player_active_service_record, {
	player_id, %% 玩家id
	active_service_type_id, %% 开服活动类型id记录
	value, %% 玩家值记录
	update_time %% 更新时间
}).

%% ===================================================================
%% 军团
%% ===================================================================
-define(DB_LEGION, db_legion).
-record(db_legion, {
	legion_id, %% 军团id
	legion_name, %% 名称
	state, %% 状态:0:未激活,1正常
	rank, %% 排名
	member_count, %% 成员数量
	lv, %% 等级
	expe, %% 经验
	active, %% 活跃点
	chief_id, %% 会长ID
	chief_name, %% 会长昵称
	capital, %% 行会资金
	public_announce, %% 外部公告
	internal_announce, %% 内部公告
	create_time, %% 创建时间
	extra, %% 额外数据(申请设置)
	update_time %% 更新时间
}).

%% ===================================================================
%% 军团成员信息
%% ===================================================================
-define(DB_PLAYER_LEGION, db_player_legion).
-record(db_player_legion, {
	player_id, %% 玩家id
	server_id, %% 服务器id
	name, %% 姓名
	career, %% 职业
	sex, %%
	lv, %% 等级
	legion_id, %% 军团id
	legion_name, %%
	position, %% 职位:0非会员,1会长,2长老,3会员
	fight, %% 战斗力
	contribution, %% 贡献
	totoal_contribution, %% 总贡献
	extra, %%
	join_time, %% 加入时间
	login_time, %% 最后上线时间
	update_time %% 更新时间
}).


%% ===================================================================
%% 合服领取记录
%% ===================================================================
-define(DB_PLAYER_ACTIVE_SERVICE_MERGE, db_player_active_service_merge).
-record(db_player_active_service_merge, {
	player_id, %% 玩家id
	active_service_merge_id, %% 合服活动id
	time %% 领取时间
}).
%% ===================================================================
%% 合服日志记录
%% ===================================================================
-define(DB_PLAYER_ACTIVE_SERVICE_RECORD_MERGE, db_player_active_service_record_merge).
-record(db_player_active_service_record_merge, {
	player_id, %% 玩家id
	active_service_merge_type_id, %% 合服活动类型id记录
	value, %% 玩家值记录
	update_time %% 更新时间
}).

%% ===================================================================
%% 合服怪物首杀记录
%% ===================================================================
-define(DB_PLAYER_MONSTER_MERGE, db_player_monster_merge).
-record(db_player_monster_merge, {
	monster_id, %% 怪物id
	player_id, %% 玩家id
	time, %% 击杀时间
	is_frist, %% 是否是合服首杀 0不是 1是
	is_frist_goods, %% 是否是领取合服首杀 0不是 1是
	is_goods %% 是否领取单次击杀 0不是 1是
}).


%% ===================================================================
%% 一生一次购买记录
%% ===================================================================
-define(DB_PLAYER_SHOP_ONCE, db_player_shop_once).
-record(db_player_shop_once, {
	player_id, %%
	lv, %% 级别
	pos, %% 位置
	state, %% 购买状态0未购买，1已购买
	goods_id, %% 物品id
	goods_num, %% 物品数量
	add_time, %% 添加时间
	expire_time, %% 过期时间
	buy_time, %% 购买时间
	money %% 金额
}).
