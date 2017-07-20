%% ========================================================
%% 角色配置
%% ========================================================
%% 角色属性配置
-record(player_attr_conf, {
	career, %% 职业
	lv, %% 等级
	attr_base %% 基础属性
}).

%% 角色升级配置
-record(player_upgrade_conf, {
	lv, %% 等级
	need_exp %% 需求经验
}).

%% ========================================================
%% 场景配置
%% ========================================================
%% monster_list格式如[{怪物id, 最多同时出现数量, 刷怪点列表[{x, y}, ...], ....]}]
%% 场景配置
-record(scene_conf, {
	map_data, %% 地图信息文件名
	scene_id, %% 场景id
	name, %% 地图名称
	map_id, %% 地图id
	type, %% 场景类型
	belong_scene_id, %% 所属场景
	activity_id, %% 活动id
	lv_limit, %% 最低等级
	lv_max, %% 最大等级
	power_limit, %% 战力需求
	rule_monster_list , %% 规则加载怪物列表
	monster_list, %% 怪物列表
	birth_area, %% 出生区域
	revive_area, %% 复活区域
	inplace_revive, %% 是否可以原地复活
	boss_refresh_limit, %% boss刷新时间限制
	pk_mode_list, %% 允许切换模式
	add_pk_value, %% 每杀一个人增加的PK值
	die_drop, %% 死亡是否掉落
	safety_area, %% 安全区
	exit_scene, %% 出口场景
	is_quick_transfer, %% 是否可以快速传送
	is_equip_send, %% 戒指是否可以传送1可以0不可以
	is_flying_shoes, %% 小飞鞋传送1可以，0 不可以
	copy_num, %% 需要复制场景个数
	limit_num, %% 场景人数限制
	cost, %% 消耗
	is_leader_transfer, %% 是否允许传送到队长身边
	is_cross, %% 是否跨服场景
	viplv_limit %% vip最低等级
}).

-record(scene_activity_conf, {
	activity_id, %% 活动id
	start_time, %% 开启时间
	effect, %% 活动期间对场景影响
	frist_time %% 第一次开启时间
}).

%% 世界boss配置
-record(world_boss_conf, {
	id, %% id
	scene_id, %% 场景id
	boss_id %% boss id
}).

%% 个人boss配置
-record(self_boss_conf, {
	id, %% id
	scene_id, %% 场景id
	boss_id %% boss id
}).

-record(treasure_conf, {
	id, %% id
	scene_id, %% 场景id
	boss_id %% boss id
}).

-record(npc_conf, {
	id, %% NPCid
	name, %% NPC名称
	sceneId, %% 所在场景
	x, %% x坐标
	y, %% y坐标
	type %% 类型
}).

-record(scene_transport_conf, {
	key, %% key
	scene_id, %% 场景id
	x, %% x坐标
	y, %% y坐标
	lv_limit, %% 等级限制
	spend_limit %% 消耗限制
}).

%% ========================================================
%% 挂机场景配置
%% ========================================================
-record(hook_scene_conf, {
	scene_id, %% 场景id
	name, %% 地图名称
	map_id, %% 地图id
	chapter, %% 章节
	stage, %% 关卡
	min_round_time, %% 最短回合时间
	min_monster_num, %% 最少刷怪数
	max_monster_num, %% 最大刷怪数
	monster_list, %% 怪物列表
	per_exp, %% 每个怪物掉落经验
	per_coin, %% 每个怪物掉落金币
	per_drop, %% 每个怪物掉落物品数量
	first_prize, %% 通关奖励
	boss_id, %% boss_id
	limit_time, %% boss限制时间
	star_3_time, %% 3星时间
	star_2_time, %% 2星时间
	star_1_time, %% 1星时间
	hook_factor, %% 挂机参数
	monster_drop, %% 普通掉落
	boss_drop %% boss掉落
}).

-record(buy_power_need_conf, {
	times, %% 当天购买次数
	need_jade %% 元宝消耗
}).

-record(hook_star_reward_conf, {
	chapter, %% 章节
	step1_condition, %% 阶段1条件
	step1_reward, %% 阶段1奖励
	step2_condition, %% 阶段2条件
	step2_reward, %% 阶段2奖励
	step3_condition, %% 阶段3条件
	step3_reward %% 阶段3奖励
}).

%% ========================================================
%% 背包装备配置
%% ========================================================
-record(goods_conf, {
	id, %% 道具id
	name, %% 道具名称
	type, %% 类型
	sub_type, %% 子类型
	quality, %% 品质
	limit_num, %% 堆叠上限
	limit_career, %% 职业限制
	limit_lvl, %% 等级限制
	sale, %% 出售价格
	extra, %% 额外效果
	is_use, %% 是否能使用
	res, %% 外观
	is_sell, %% 是否能出售
	drop_rate1, %% 普通掉落
	drop_rate2, %% 红名掉落
	sale_sort, %% 交易所分类
	suit_id, %% 套装id
	is_notice, %% 掉落是否公告
	is_timeliness, %% 是否具有时效性
	is_timeliness_delete, %% 过期是否删除(0删除 1不删除）
	sort, %% 背包排序
	secure_price, %% 投保价格
	is_decompose, %% 是否能按品质分解
	is_dorplist, %% 是否在掉落记录显示
	price_jade, %% 道具的元宝价值
	lv, %% 装备顺序等级
	drop_type, %% 跨服是否掉落
	drop_jade, %% 跨服掉落对应元宝价值
	cost, %% 开启消耗
	notice_id %% 获得道具公告ID
}).
%% 0：表示跨服不掉落 　 　 　 　
%% 1：表示跨服掉落：如果掉落元宝配置为0，则直接掉落响应的道具；如果掉落元宝不为0，

-record(goods_type_conf, {
	key, %% {type, subtype}
	type, %% 道具类型
	sub_type, %% 道具子类型
	cd_time %% cd时间(秒)
}).

-record(goods_map_conf, {
	key, %% key
	min_lv, %% 最小等级
	max_lv, %% 最大等级
	type_list, %% 随机类型列表
	scene_list, %% 场景
	goods_list, %% 可获取道具
	monster_list %% 可开出怪物
}).

-record(equips_conf, {
	attr_base %% 基础属性
}).

-record(equips_plus_conf, {
	attr_base %% 基础属性
}).

-record(equips_quality_conf, {
	id, %% 装备品质
	stren_consume, %% 强化消耗百分比
	smelt_value %% 熔炼值
}).

-record(equips_stren_conf, {
	key, %% key值
	coin, %% 消耗金币数量
	change_jade, %% 转移消耗的元宝
	max_bless %% 祝福值
}).

-record(stren_rate_conf, {
	key, %% 递增id
	goods_id, %% 强化石id
	stren_lv, %% 对应强化等级
	rate %% 对应加成概率
}).

-record(equips_forge_conf, {
	key, %% {神器星级, 等极段1, 等级段2}
	rate, %% 锻造装备出现几率
	quality_rate %% 品质出现几率
}).

-record(equips_smelt_conf, {
	key, %% {装备等级,装备品质}
	smelt_rate, %% 熔炼概率
	up_rate %% 装备提升概率
}).

-record(decompose_conf, {
	key, %% 可分解的装备id
	goods_list %% 分解后获得道具列表
}).

-record(decompose_stren_conf, {
	key, %% 强化等级
	goods_list %% 分解后获得道具列表
}).

-record(forge_consume_conf, {
	key, %% {装备品质,装备等级}
	use_smelt %% 需要消耗的熔炼值
}).

-record(counter_conf, {
	counter_id, %% 计数器id
	period_unit, %% 周期单位
	period, %% 周期数
	limit_value, %% 限制数量
	base_time %% 基准日期
}).

-record(equips_baptize_conf, {
	id, %% id
	quality, %% 品质
	sub_type, %% 装备子类型
	career, %% 职业
	min_lv, %% 最小等级
	max_lv, %% 最大等级
	branch_num, %% 洗炼出现属性条数
	use_coin, %% 消耗金钱
	use_goods, %% 消耗道具id
	use_goods_num, %% 消耗道具数
	attr_rate, %% 洗炼出属性概率
	attr_max_value, %% 属性最大值
	bap_rate %% 洗练率
}).

-record(equips_baptize_lock_conf, {
	lock, %% 锁定数量
	cost %% 消耗洗炼石
}).

-record(equips_baptize_qian_conf, {
	id, %% id
	max %% 最大属性
}).

-record(equips_baptiz_change_jade_conf, {
	key, %% key
	min_percent, %% 最小百分比
	max_percent, %% 最大百分比
	jade %% 需要元宝数量
}).

-record(fusion_conf, {
	key, %% 配方id
	rate, %% 合成概率
	type, %% 类型
	sub_type, %% 子类型
	stuff, %% 合成所需材料
	wear_equips, %% 所需穿戴装备id
	product, %% 合成产物
	product_equips %% 产出穿戴在身上的装备id
}).

-record(gem_upgrade_conf, {
	key, %% 宝石id
	rate, %% 升级概率
	stuff, %% 升级所需材料
	result %% 升级后的宝石id
}).

-record(artifact_attr_conf, {
	key, %% 递增key
	sub_type, %% 装备子类型
	star, %% 属性条数
	lv, %% 神器等级
	attr_list %% 属性列表
}).

-record(artifact_exp_conf, {
	key, %% {神器星级, 神器属性数}
	lv, %% 神器等级
	star_lv, %% 神器星级
	exp, %% 升级所需经验
	coin %% 所需铜钱系数
}).

-record(arena_shop_conf, {
	key, %% 商品id
	limit_count, %% 限购次数
	goods_id, %% 道具id
	reputation %% 消耗声望
}).

-record(shop_conf, {
	key, %% 商品id
	type, %% 商品类型
	goods_id, %% 道具id
	is_bind, %% 是否绑定
	num, %% 数量
	curr_type, %% 货币类型
	price, %% 价格
	limit_vip, %% vip购买限制
	counter_id %% 购买计数器
}).

-record(wander_shop_conf, {
	key, %% key
	refuse_time, %% 刷新时间
	random_num, %% 随机数量
	shop_list, %% 必刷列表
	random_list %% 随机道具列表
}).

-record(mystery_shop_conf, {
	id, %% ID
	goods, %% 物品信息
	curr_type, %% 货币类型
	price, %% 售价
	weights, %% 权重
	vip, %% VIP等级限制
	counter_id, %% 计数器id
	discount %% 折扣横幅
}).

-record(daily_tasks_conf, {
	key, %% 每日任务id
	count, %% 任务可完成次数
	integral %% 积分
}).

-record(daily_tasks_reward_conf, {
	key, %% 奖品id
	integral_cond, %% 领取积分条件
	reward, %% 奖品列表
	counter_id %% 计数器id
}).

-record(fighting_conf, {
	key, %% 属性对应的key
	fight %% 战斗力系数
}).

-record(guild_conf, {
	key, %% 行会等级
	exp, %% 升级所需经验
	member_limit %% 成员人数限制
}).

-record(guild_donation_conf, {
	key, %% 捐献类型
	consume_type, %% 消费类型1金币2元宝
	consume_value, %% 消费金额
	vip_limit,  %% vip限制
	contribution, %% 贡献
	guild_exp, %% 行会经验
	guild_capital, %% 行会资金
	counter_id %% 计数器id
}).

-record(guild_shop_conf, {
	key, %% 商品id
	goods_id, %% 物品id
	need_contribution, %% 需要贡献值
	limit_lv, %% 等级限制
	limit_guild_lv, %% 行会等级限制
	limit_count %% 购买次数限制
}).

-record(guild_active_conf, {
	key, %% 活动id
	is_push, %% 是否推送活动信息给前端
	enter_limit, %% 进入限制
	open_limit, %% 开启条件
	open_type, %% 开启时间类型
	open_week, %% 开启周期
	open_time, %% 开始时间
	close_time, %% 结束时间
	count_type, %% 开启次数类型
	limit_count, %% 每天开启次数限制
	enter_instance, %% 进入副本id
	sub_instance %% 子副本id列表
}).

-record(bag_conf, {
	key, %% 礼包id
	goods %% 道具
}).

-record(luck_conf, {
	key, %% 幸运值key
	succ_rate, %% 成功率
	nor_rate, %% 不变率
	fail_rate, %% 失败率
	max_atk_rate, %% 触发最大攻击概率
	min_atk_rate %% 触发最小攻击概率
}).

-record(arena_reward_conf, {
	key, %% 排名
	min_rank, %% 最小排名区间
	max_rank, %% 最大排名区间
	coin, %% 金币
	reputation, %% 声望
	goods_list, %% 道具列表
	mail_id %% 邮件id
}).

-record(wing_conf, {
	key, %% 翅膀强化id
	goods_id, %% 翅膀道具id
	need_goods, %% 所需道具id
	need_num, %% 所需数量
	money_type, %% 货币类型
	price, %% 补足元宝单价
	limit_lv, %% 等级限制
	next_id %% 升级后翅膀id
}).

-record(wing_mapping_conf, {
	key, %% 时效翅膀
	wing_id %% 正版翅膀
}).

%% ========================================================
%% 技能配置
%% ========================================================
-record(skill_conf, {
	skill_id, %% 技能id
	lv, %% 技能等级
	type, %% 技能类型
	cost_mp, %% 消耗魔法
	cd, %% 技能cd
	spell_distance, %% 施法距离
	hit, %% 是否控制必中
	target, %% 作用目标
	range, %% 范围
	effect_list, %% 技能效果
	spell_time %% 施法时间
}).

-record(buff_conf, {
	buff_id, %% buff_id
	effect_id, %% 效果id
	src_id, %% 来源
	rule, %% 效果规则
	interval, %% 生效间隔
	duration, %% 持续时间
	show %% 是否显示
}).

-record(skill_tree_conf, {
	skill_id, %% 技能id
	lv, %% 技能等级
	type, %% 技能类型
	auto_type, %% 自动技能类型
	career, %% 职业
	limit_lv, %% 学习等级
	goods_1, %% 所需道具1
	num_1, %% 道具1数量
	next_exp, %% 下一级需要的经验
	trigger_type %% 触发条件
}).

-record(medal_conf, {
	key, %% 勋章强化id
	goods_id, %% 勋章道具id
	career, %% 对应职业
	need_feats, %% 功勋值
	limit_lv, %% 等级限制
	next_id %% 升级后勋章id
}).

-record(active_remind_conf, {
	key, %% 优先级
	active_id, %% 活动id
	enter_limit, %% 进入条件
	type, %% 时间类型
	time_list %% 时间列表
}).

%% ========================================================
%% 怪物配置
%% ========================================================
-record(monster_conf, {
	monster_id, %% 怪物id
	name, %% 怪物名称
	career, %% 职业
	type, %% 怪物类型
	notice, %% 公告类型
	count_down, %% 刷新倒计时
	resId, %% 形象id
	lv, %% 等级
	attr_base, %% 基础属性
	skill_rule, %% 技能列表
	hook_skill_list, %% 挂机技能列表
	drop_list, %% 掉落列表
	guard_range, %% 警觉范围
	attack_type, %% 攻击类型
	patrol_range, %% 巡逻范围
	chase_range, %% 追击范围
	walk_range, %% 回家范围
	speed, %% 速度
	patrol_interval, %% 巡逻间隔
	patrol_rate, %% 巡逻概率
	chase_interval, %% 追击间隔
	exp, %% 经验
	ownership, %% 归属权
	need_exp, %% 升下一级所需经验
	tempt, %% 是否可以被诱惑
	pet_id, %% 诱惑后对应的宠物id
	tempt_lv_limit, %% 诱惑等级限制
	tempt_skill_lv_limit, %% 诱惑技能等级限制
	is_growth, %% 是否成长
	special_drop, %% 特殊掉落
	kill_value, %% 击杀获得的幸运值
	is_drop, %% 是否启用特殊掉落
	is_red, %% 是否掉落红包
	is_resist_stun, %% 是否免疫晕眩
	is_resist_poison, %% 是否免疫中毒
	is_resist_mb, %% 是否免疫麻痹
	is_resist_invisibility, %% 是否免疫隐身
	is_resist_knockback, %% 是否免疫冲撞
	is_resist_back, %% 是否免疫抗拒火环
	is_resist_silent, %% 是否免疫沉默
	is_resist_thorns, %% 是否免疫反伤
	drop_type, %% 怪物掉落分类
	random_refuse, %% 死亡随机刷新规则
	box_count, %% 宝箱拾取次数
	box_reset_time, %% 宝箱重置拾取时间
	is_resist_vampire %% 吸血抗性
}).

-record(monster_growth_conf, {
	monster_id, %% 怪物id
	min_kill_count, %% 最小击杀次数
	max_kill_count, %% 最大击杀次数
	attr_base, %% 基础属性
	drop_list %% 掉落列表
}).

-record(loop_notice_conf, {
	key, %% key
	notice_id, %% 公告id
	time_rule %% 公告时间
}).

-record(active_reward_conf, {
	key, %% 奖励id
	min_lv, %% 最小等级
	max_lv, %% 最大等级
	type, %% 奖励类型
	value, %% 条件参数
	reward, %% 奖励列表
	reward_zhanshi, %% 战士奖励列表
	reward_fashi, %% 法师奖励列表
	reward_daoshi, %% 道士奖励列表
	counter_id %% 计数器id
}).

-record(everyday_sign_conf, {
	key, %% key
	year, %% 年
	month, %% 月
	count, %% 次
	reward, %% 奖励
	is_double, %% 是否翻倍
	vip_double %% vip翻倍等级
}).

-record(random_monster_conf, {
	monster_id, %% 怪物id
	boss_flag, %% 是否真BOSS
	batch, %% 批次
	refuse_list %% refuse_list
}).

%% ========================================================
%% 任务配置
%% ========================================================
-record(task_conf, {
	id, %% 任务id
	sort_id, %% 任务类型id
	type_id, %% 大任务类型
	min_lv, %% 需要最小等级
	limit_lv, %% 需要等级
	front_task_id, %% 前置任务id
	accept_npc_id, %% 接取任务npcid
	accept_dec, %% 接受描述
	accept_info, %% 接受对话信息
	openinstance, %% 打开副本
	tool, %% 公用字段
	need_num, %% 需要数量
	finish_npc_id, %% 完成任务npcid
	finish_info, %% 完成对话信息
	finish_dec, %% 完成描述
	goods_zhanshi, %% 战士奖励
	goods_daoshi, %% 道士奖励
	goods_fashi, %% 法师奖励
	goods_extra, %% 额外奖励
	goods_extra_probability, %% 额外奖励获得几率（0必得）
	active, %% 活跃值
	monsterid_arr %% 击杀怪物收集道具任务使用，怪物id
}).

%% ===================================================================
%% 任务奖励配置信息
%% ===================================================================
-record(taskreward_conf, {
	id, %% ID
	lv, %% 等级
	need_active, %% 需要活跃值
	goods %% 物品信息
}).

%% ===================================================================
%% 副本配置信息
%% ===================================================================
-record(instance_conf, {
	scene_id, %% 场景id
	next_id, %% 下级副本
	type, %% 副本类型
	setup_time, %% 准备时间
	end_time, %% 结束时间
	close_time, %% 关闭时间
	times_limit, %% 进入次数限制
	buy_limit, %% 额外购买次数
	cost, %% 花费
	pass_condition, %% 通关条件
	pass_prize, %% 通关奖励
	boss_id, %% BOSSID
	recover, %% 进出满状态
	mail_reward %% 邮件奖励
}).

-record(instance_single_conf, {
	id, %% id
	scene_id %% 场景id
}).

-record(active_instance_conf, {
	key, %% 活动id
	open_type, %% 开启时间类型
	open_week, %% 开启周期
	open_time_1, %% 开始时间1
	close_time_1, %% 结束时间1
	open_time_2, %% 开始时间2
	close_time_2, %% 结束时间2
	enter_time_1, %% 允许进入时间
	stop_time_1, %% 禁止进入时间
	enter_time_2, %% 允许进入时间2
	stop_time_2, %% 禁止进入时间2
	instance_id, %% 进入副本id
	sub_instance_list %% 子副本列表
}).

%% ===================================================================
%% 城市沙巴克官职信息
%% ===================================================================
-record(city_officer_conf, {
	id, %% 官员id
	num, %% 数量
	name, %% 官员名称
	isshow, %% 是否在表里面添加
	day_reward_goods, %% 官员每日奖励
	frist_reward_goods, %% 城主首次奖励
	every_reward_goods %% 每次城主奖励
}).

%% ===================================================================
%% 传送阵配置
%% ===================================================================
-record(transfer_conf, {
	id, %% 传送阵id
	from_scene, %% 所在场景
	from_pos, %% 所在坐标
	to_scene, %% 目标场景
	to_pos, %% 目标坐标
	lv_limit, %% 等级限制
	guild_lv_limit, %% 行会等级限制
	power_limit, %% 战力限制
	order_num, %% 传送位置
	direction %% 传送方向
}).

%% ===================================================================
%% 膜拜奖励信息
%% ===================================================================
-record(worship_goods_conf, {
	id, %% id
	min_lv, %% 最小等级
	max_lv, %% 最大等级
	goods, %% 免费膜拜
	jade_goods %% 元宝膜拜
}).

%% ===================================================================
%% 功能相关信息
%% ===================================================================
-record(function_conf, {
	id, %% 功能id
	name, %% 功能名称
	lv, %% 开启等级
	task_id, %% 开启任务id
	type, %% 功能类型
	begin_time, %% 开启时间
	end_time, %% 关闭时间
	consume %% 消耗
}).

-record(ui_function_conf, {
	id, %% 功能id
	state %% 开启状态
}).

-record(function_notice_conf, {
	id, %% id
	name, %% 功能名称
	lv, %% 等级
	reward, %% 奖励列表
	counter_id %% 计数id
}).

%% ===================================================================
%% vip 信息
%% ===================================================================
-record(vip_conf, {
	id, %% 编号
	career, %% 职业
	lv, %% vip等级
	exp, %% vip等级经验
	goods, %% vip奖励
	hook_num, %% 挂机增加次数
	hook_exp, %% 挂机经验增加
	fh_num, %% 复活次数
	rank_num, %% 排位赛次数
	clear_red, %% 清除红名
	store_num, %% 仓库格子
	buy_hook_num, %% 允许购买挂机次数
	boss_transfer, %% boss传送次数
	buy_fb_num, %% 允许购买个人副本次数
	sign_num, %% 每日签到补签次数
	drop_modulus, %% 掉落系数
	exam_tools, %% 答题道具个数
	vipbuffid, %% vipbuffid
	attr_base %% 基础属性
}).

-record(vip_boss_conf, {
	id, %% id
	scene_id, %% 场景id
	boss_id %% boss id
}).

%% ===================================================================
%% 活动信息
%% ===================================================================
-record(activity_list_conf, {
	id, %% id
	type, %% 类型
	is_show_num, %% 是否显示数量
	function_id %% 活动ID
}).

-record(package_goods_conf, {
	lv, %% vip等级
	goods %% 奖励
}).

%% ===================================================================
%% 充值相关
%% ===================================================================
-record(charge_conf, {
	key, %% 属性对应的key
	jade, %% 充值元宝
	first_giving, %% 第一次返利
	common_giving, %% 正常返利
	rmb, %% 人民币
	counter_id, %% 计数器id
	time_counter_id, %% 充值计数器ID
	month_day, %% 月卡天数（大于0表示月卡，等于0表示普通充值）
	month_jade %% 月卡领取元宝
}).

%% ===================================================================
%% 拍卖类型
%% ===================================================================
-record(sale_sort_conf, {
	id, %% ID
	sort1, %% 1级标签ID
	sort2, %% 2级标签ID
	sort3 %% 3级标签ID
}).
%% ===================================================================
%% 任务元宝话费信息
%% ===================================================================
-record(task_complete_conf, {
	id, %% id
	type, %% 任务类型
	num, %% 次数
	need_jade %% 需要元宝
}).
%% ===================================================================
%% 屠龙大会副本
%% ===================================================================
-record(world_boss_reward_conf, {
	key, %% key
	min_rank, %% 排名小
	max_rank, %% 排名大
	min_lv, %% 最小等级
	max_lv, %% 最大等级
	mail_id %% 邮件id
}).

-record(szww_reward_conf, {
	key, %% key
	min_rank, %% 排名小
	max_rank, %% 排名大
	mail_id %% 邮件id
}).

%% ===================================================================
%% 装备套装
%% ===================================================================
%% 套装属性配置
-record(equips_suit_conf, {
	key, %% 套装id
	min_count, %%  最小套件数
	max_count, %% 最大套件数
	attr_base %% 基础属性
}).

%% ===================================================================
%% 邮件配置
%% ===================================================================
-record(mail_conf, {
	id, %% 邮件id
	mail_type, %% 邮件类型(0系统1其他2全服)
	sender, %% 发送者
	title, %% 邮件标题
	content, %% 邮件内容
	award, %% 邮件奖励
	active_time, %% 邮件有效时间
	update_time %% 更新时间
}).

%% ===================================================================
%% 掉落配置
%% ===================================================================
-record(drop_modulus_conf, {
	key, %% key
	min_lv, %% 最小等级差
	max_lv, %% 最大等级差
	modulus %% 系数
}).

-record(special_drop_conf, {
	goods_id, %% 道具id
	type, %% 怪物掉落类型
	drop_type %% 掉落分类
}).

-record(special_drop_type_conf, {
	drop_type, %% 掉落类型
	drop_limit, %% 掉落限制数量
	drop_unit, %% 掉落周期
	drop_cycle %% 周期数
}).

-record(active_service_type_conf, {
	id, %% 活动类型id
	list_id, %% 分页ID
	receive_state, %% 领取状态
	name, %%  活动名称
	is_add, %% 数据是添加，还是替换，1是添加0，是替换
	begin_time, %% 活动开启时间
	end_time, %% 活动结束时间
	show_time, %% 活动隐藏时间
	value, %% 排名必须达到的基础value
	is_one %% 是否单人活动
}).

-record(active_service_conf, {
	id, %% 活动id
	type, %% 奖励类型
	rank, %% 排名（排名大于0的就表示只有一份全服）
	value, %% 条件参数
	reward_zhanshi, %% 战士奖励列表
	reward_fashi, %% 法师奖励列表
	reward_daoshi, %% 道士奖励列表(全服击杀奖励)
	reward, %% 单人击杀奖励
	num, %% 数量
	condition_text, %% 条件内容描述
	min_jade, %% 最小元宝
	max_jade, %% 最大元宝
	info, %% 公告内容
	mail_title, %% 邮件标题
	mail_text %% 邮件内容
}).

-record(active_service_shop_conf, {
	key, %% 商品id
	type, %% 活动类型
	goods_id, %% 道具id
	is_bind, %% 是否绑定
	num, %% 数量
	curr_type, %% 货币类型
	price, %% 价格
	counter_id %% 购买计数器
}).

%% ===================================================================
%% 铸魂配置
%% ===================================================================
-record(equips_soul_plus_conf, {
	key, %% 铸魂等级
	modulus %% 系数
}).

-record(equips_soul_conf, {
	key, %% key
	goods_id, %% 装备id
	soul, %% 铸魂等级
	consume %% 升级消耗
}).

%% ===================================================================
%% 背包格子配置
%% ===================================================================
-record(cell_conf, {
	key, %% key
	min_lv, %% 最小排名区间
	max_lv, %% 最大排名区间
	cell %% 格子数
}).

%% ===================================================================
%% 抽奖
-record(lottery_conf, {
	id, %% ID
	group, %% 组
	weights, %% 权重
	min_num, %% 玩家保底次数
	day_num, %% 每日限制次数
	server_num, %% 全服达到必出次数
	goods, %% 奖励物品信息
	is_log, %% 是否保存记录
	name, %% 物品名称
	notice_info, %% 公告内容
	is_notice %% 是否公告
}).
%% ===================================================================
%% 抽奖
%% ===================================================================
-record(lottery_coin_conf, {
	id, %% ID
	weights, %% 权重
	min_num, %% 玩家保底次数
	day_num, %% 每日限制次数
	server_num, %% 全服达到必出次数
	goods, %% 奖励物品信息
	is_log, %% 是否保存记录
	name, %% 物品名称
	notice_info, %% 公告内容
	is_notice %% 是否公告
}).
%% ===================================================================
%% 多类型抽奖
%% ===================================================================
-record(lottery_box_conf, {
	id, %% ID
	type, %% 分类
	group, %% 组
	weights, %% 权重
	min_num, %% 玩家保底次数
	day_num, %% 每日限制次数
	server_num, %% 全服达到必出次数
	goods, %% 奖励物品信息
	is_log, %% 是否保存记录
	name, %% 物品名称
	notice_info, %% 公告内容
	is_notice %% 是否公告
}).
%% ===================================================================
%% 印记
%% ===================================================================
-record(mark_conf, {
	type, %% 印记类型
	lv, %% 印记等级
	career, %% 职业
	upgrade_stuff, %% 材料
	limit_cond, %% 限制条件
	res, %% 坐骑装备外观
	rate, %% 成功率
	stuff_jade, %% 材料元宝代替的单价
	one_bless, %% 单次强化增加的祝福值
	max_bless, %% 最大祝福值
	bless_section, %% 区间
	attr_base %% 属性
}).

%% ===================================================================
%% 坐骑升级
%% ===================================================================
-record(mounts_conf, {
	key, %% 坐骑强化id
	goods_id, %% 升级的坐骑道具id
	limit_lv, %% 等级限制
	rate, %% 升级成功率
	stuff, %% 升级材料
	next_id %% 升级后坐骑id
}).

%% ===================================================================
%% 假人信息
%% ===================================================================
-record(robot_conf, {
	lv, %% 等级
	career, %% 职业
	weapon, %% 武器
	clothes, %% 衣服
	helmet, %% 头盔
	necklace, %% 项链
	medal, %% 勋章
	bangle, %% 手镯
	ring, %% 戒指
	belt, %% 腰带
	shoes, %% 鞋子
	wing, %% 翅膀
	skill, %% 技能
	event, %% 场景行动类型(单位秒)
	event_stand, %% 站立
	event_run, %% 跑步
	event_kill, %% 等级对应场景信息杀怪
	add_exp %% 时间毫秒，增加的经验
}).

%% ===================================================================
%% 怪物攻城奖励
%% ===================================================================
-record(monster_attack_reward_conf, {
	key, %% key
	min_rank, %% 排名小
	max_rank, %% 排名大
	win_mail_id, %% 胜利邮件id
	lose_mail_id %% 失败邮件id
}).
%% ===================================================================
%% 前一个名字
%% ===================================================================
-record(random_first_name_conf, {
	id, %% id
	name %% 名字
}).
%% ===================================================================
%% 后一个名字
%% ===================================================================
-record(random_last_name_conf, {
	id, %% id
	gender, %% 不知道
	name %% 名字
}).
%% ===================================================================
%% 装备类型前后端对应
%% ===================================================================
-record(equips_type_conf, {
	id, %% 后端部位ID
	id_qian %% 前端部位ID
}).
%% ===================================================================
%% 机器人账号记录
%% ===================================================================
-record(robot_account_conf, {
	id, %% 编号
	robot_account %% 账号
}).

-record(pickup_setting_conf, {
	id, %% 位置ID(固定)
	name, %% 选项名称
	items, %% 可拾取物品
	tick %% 默认勾上
}).

-record(expression_conf, {
	id, %% id
	key %% 表情名
}).

-record(equips_exhibition_conf, {
	key %% 固定ID
}).

-record(equips_exhibition_list_conf, {
	key %% 序号
}).

-record(city_boss_conf, {
	id, %% id
	boss_id %% boss id
}).

%%答题
-record(examination_conf, {
	id, %% id
	type, %% 题目类型
	result %% 答案
}).

-record(vip_return_conf, {
	vip, %% vip级别
	goods %% 返还物品列表
}).

-record(holidays_active_conf, {
	active_type, %% 活动类型
	reward %% 活动奖励
}).

-record(active_drop_conf, {
	type, %% 活动ID
	monster_id, %% 怪物ID
	drop_list, %% 掉落列表
	active_score %% 活动怪物积分
}).

%%下载资源包礼包
-record(gift_download_conf, {
	key, %% 等级
	reward, %% 奖励
	counter_id %% 计数器id
}).

%% 背包物品掉落概率信息
-record(bag_drop_conf, {
	id, %% 1
	num_min, %% 1
	num_max, %% 1000
	weight %% 100
}).

-record(group_conf, {
	key, %% 军团等级
	exp, %% 升级所需经验
	member_limit %% 成员人数限制
}).

%%火龙神殿玩法
-record(instance_dragon_conf, {
	id, %% key(杀怪数量)
	boss_scene_id, %% 刷新boss的场景
	scene_list, %% 刷新精英的场景列表
	notice_id, %% 场景公告
	description %% 描述
}).

%%火龙神殿周末玩法
-record(instance_dragon_weeken_conf, {
	id, %% key(杀怪数量)
	boss_scene_id, %% 刷新boss的场景
	scene_list, %% 刷新精英的场景列表
	notice_id, %% 场景公告
	description %% 描述
}).

%%本服火龙
-record(instance_dragon_native_conf, {
	id, %% key(杀怪数量)
	boss_scene_id, %% 刷新boss的场景
	scene_list, %% 刷新精英的场景列表
	notice_id, %% 场景公告
	description %% 描述
}).

%%地图场景相关信息
-record(word_map_conf, {
	id, %% 区域id
	scene_id %% 场景id
}).

%%一生一次礼包
-record(shop_once_conf, {
	id, %% id
	goods_id, %% 物品
	lv, %% 级别
	pos, %% 位置(1-3)
	is_bind, %% 是否绑定
	num, %% 数量
	price_now %% 现价
}).

%%****************************************合服活动相关
%% 合服活动信息
-record(active_service_merge_conf, {
	id, %% 活动id
	type, %% 奖励类型
	rank, %% 排名（排名大于0的就表示只有一份全服）
	value, %% 条件参数
	reward_zhanshi, %% 战士奖励列表
	reward_fashi, %% 法师奖励列表
	reward_daoshi, %% 道士奖励列表(全服击杀奖励)
	reward, %% 单人击杀奖励
	num, %% 数量
	condition_text, %% 条件内容描述
	min_jade, %% 最小元宝
	max_jade, %% 最大元宝
	info, %% 公告内容
	mail_title, %% 邮件标题
	mail_text %% 邮件内容
}).
%% 合服活动商店信息
-record(active_service_merge_shop_conf, {
	key, %% 商品id
	type, %% 活动类型
	goods_id, %% 道具id
	is_bind, %% 是否绑定
	num, %% 数量
	curr_type, %% 货币类型
	price, %% 价格
	price_old, %% 原价格
	counter_id %% 购买计数器
}).
%% 合服活动类型信息
-record(active_service_merge_type_conf, {
	id, %% 活动类型id
	list_id, %% 分页ID
	receive_state, %% 领取状态
	name, %%  活动名称
	is_show, %% 是否显示1，表示要显示0，表示不显示
	is_add, %% 数据是添加，还是替换，1是添加0，是替换
	begin_time, %% 活动开启时间
	end_time, %% 活动持续时间（开启后隔x天）
	show_time, %% 活动隐藏时间(开始后隔x天)
	limit_lv, %% 限制等级
	value, %% 排名必须达到的基础value
	is_one, %% 是否单人活动
	sort %% 前端显示排序
}).

-record(luckdraw_exchange_conf, {
	id, %% ID
	lv, %% 兑换等级
	point, %% 兑换积分
	goods %% 物品ID
}).

%% 充值次数限制时间记录
-record(charge_times_conf, {
	id, %% 编号
	min_num, %% 最小次数
	max_num, %% 最大次数
	time %% 间隔时间(单位秒)
}).
