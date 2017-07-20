%% ==========================================================
%% TCP
%% ==========================================================
-record(tcp_client_state, {
	open_id, %% 平台openid
	platform, %% 渠道号
	player_id, %% 角色id
	socket = null, %% socket
	player_pid = null, %% 角色pid
	timeout, %% 超时次数
	first_time,%%登录时间
	last_heart, %% 最后心跳时间戳
	need_clean_account = true, %% 是否需要清理账号信息
	socket_num = 0, %% 每一秒socket接收数据次数
	socket_time = 0, %% 次数记录时间
	ip %% 玩家ip
}).

%% ==========================================================
%% 在线
%% ==========================================================
-record(ets_account_online, {
	account_flag, %% 账号唯一标识{open_id,platform}
	player_id, %% 登陆的角色id
	socket, %% socket
	socket_pid, %% socketpid
	player_pid %% 玩家pid
}).

-record(ets_online, {
	player_id = 0, %% 玩家id
	socket = null, %% socket
	pid = null, %% 玩家pid
	is_robot = 0 %% 是否机器人，1是，0不是
}).

%% ==========================================================
%% 公告
%% ==========================================================
-record(ets_notice, {
	key = 0, %% 公告key
	day_time = null %% 公告日期时间
}).

%% ==========================================================
%% 玩家
%% ==========================================================
%% 基础属性
-record(attr_base, {
	hp = 0, %% 血量
	mp = 0, %% 魔法
	min_ac = 0, %% 最小物理攻击
	max_ac = 0, %% 最大物理攻击
	min_mac = 0, %% 最小魔法攻击
	max_mac = 0, %% 最大魔法攻击
	min_sc = 0, %% 最小道术攻击
	max_sc = 0, %% 最大道术攻击
	min_def = 0, %% 最小物防
	max_def = 0, %% 最大物防
	min_res = 0, %% 最小魔防
	max_res = 0, %% 最大魔防
	crit = 0, %% 暴击
	crit_att = 0, %% 暴击伤害
	hit = 0, %% 准确
	dodge = 0, %% 敏捷
	damage_deepen = 0, %% 伤害加深
	damage_reduction = 0, %% 伤害减免
	holy = 0, %% 神圣
	skill_add = 0, %% 技能伤害追加
	m_hit = 0, %% 魔法命中
	m_dodge = 0, %% 魔法闪避
	hp_recover = 0, %% 生命恢复
	mp_recover = 0, %% 魔法恢复
	resurgence = 0, %% 死亡恢复
	damage_offset = 0, %% 伤害减免
	luck = 0, %% 幸运值
	chaos = 0, %% 混乱伤害

	hp_p = 0, %% 血量百分比加成
	mp_p = 0, %% 魔法百分比加成
	min_ac_p = 0, %% 最小物理攻击百分比加成
	max_ac_p = 0, %% 最大物理攻击百分比加成
	min_mac_p = 0, %% 最小魔法攻击百分比加成
	max_mac_p = 0, %% 最大魔法攻击百分比加成
	min_sc_p = 0, %% 最小道术攻击百分比加成
	max_sc_p = 0, %% 最大道术攻击百分比加成
	min_def_p = 0, %% 最小物防百分比加成
	max_def_p = 0, %% 最大物防百分比加成
	min_res_p = 0, %% 最小魔防百分比加成
	max_res_p = 0, %% 最大魔防百分比加成
	crit_p = 0, %% 暴击百分比加成
	crit_att_p = 0, %% 暴击伤害百分比加成
	hit_p = 0, %% 准确百分比加成
	dodge_p = 0, %% 敏捷百分比加成
	damage_deepen_p = 0, %% 伤害加深百分比加成
	damage_reduction_p = 0, %% 伤害减免百分比加成
	holy_p = 0, %% 神圣百分比加成
	skill_add_p = 0, %% 技能伤害追加百分比加成
	m_hit_p = 0, %% 魔法命中百分比加成
	m_dodge_p = 0, %% 魔法闪避百分比加成
	hp_recover_p = 0, %% 生命恢复百分比加成
	mp_recover_p = 0, %% 魔法恢复百分比加成
	resurgence_p = 0, %% 死亡恢复百分比加成
	damage_offset_p = 0, %% 魔法抵消伤害
	mounts_p = 0, %% 坐骑装备加成百分比

	coin_p = 0, %% 金币百分比加成
	exp_p = 0 %% 经验百分比加成
}).

-record(guise_state, {
	weapon,
	clothes,
	wing,
	pet,
	mounts, %% 坐骑
	mounts_aura  %% 坐骑光环
}).

%% 玩家进程状态
-record(player_state, {
	player_id, %% 玩家id
	socket, %% socket
	socket_pid, %% socket进程
	db_player_base, %% 玩家数据库基础信息
	db_player_money, %% 玩家数据库货币信息
	db_player_attr, %% 玩家数据库属性信息
	db_player_mark, %% 玩家数据库标记信息
	scene_id, %% 玩家所在场景id
	scene_pid, %% 玩家所在场景pid
	scene_obj, %% 玩家所在场景的 obj 只有初始的时候调用
	scene_line_num, %% 玩家所在场景的 分线信息
	attr_base, %% 玩家基础属性
	attr_total, %% 玩家总属性
	skill_dict, %% 玩家已学技能
	effect_dict,
	effect_src_dict,
	buff_dict,
	order_skill_list, %%
	skill_keyboard, %%
	last_use_skill_time, %% 最后施法时间(毫秒)
	guise, %% 外观
	hook_report, %%挂机奖励纪录
	recover_pet_list, %% 玩家上线需要恢复的宠物列表(表元素{monster_id, exp})
	pet_dict, %% 宠物dict,
	pet_num, %% 宠物数量
	fighting, %% 玩家战斗力
	pass_trigger_skill_list, %% 被动触发技能列表
	name_colour, %% 名字颜色
	gray_time, %% 灰名时间
	last_reduce_time, %% 最后一次减少PK值时间
	platform, %% 渠道id
	open_id, %% 平台唯一标示id
	career_title, %% 职业称号
	team_id, %% 队伍id
	team_pid, %% 队伍的pid
	leader, %% 是否是队长
	team_switch_1, %% 队伍开关1
	team_switch_2, %% 队伍开关2
	scene_parameters, %% 场景参数
	function_open_list, %% 功能开启列表

	merit_task_id, %% 功勋任务纪录 id
	day_task_id, %% 日常任务纪录 id
	week_task_id, %% 周任务记录 id
	map_task_id, %% 周任务记录 id

	ref_task_list, %% 刷新任务纪录任务 id
	ref_week_task_list, %% 记录已经给前端的 周任务列表
	ref_day_task_list, %% 记录给前端的 日常任务列表
	ref_merit_task_list, %% 记录给前端 功勋任务列表
	ref_map_task_list, %% 记录给前端 功勋任务列表

	last_use_skill, %% 最后一次使用的技能
	black_friend_list, %% 黑名单
	refuse_function_time, %% 刷新功能的时间
	is_load_over, %% 地图加载是否已经完成
	active_remind_list, %% 限时活动通知列表
	chat_list, %% 聊天信息缓存发送
	is_guild_red, %% 是否在工会红包ui
	is_lottery, %% 是否在抽奖ui
	is_coin_lottery, %% 是否在金币抽奖ui

	is_world_boss_ui,%% 是否在bossui界面
	is_transaction, %% 是否发起过交易

	is_lottery_begin, %% 是否发送物品获取信息
	goods_list, %% 道具列表
	equip_list, %% 装备列表
	expire_goods_list, %% 时效性道具列表
	bag_goods_list, %% 开启礼包获得的道具列表

	ref_mystery_shop_time, %% 神秘商店刷新时间
	mystery_shop_list, %% 神秘商店物品列表

	atk_num,%% 技能攻击次数记录
	atk_time,%% 技能攻击时间记录

	is_robot, %% 是否机器人
	server_name, %% 服务器名称

	%% 跨服需求
	pid, %% 玩家的pid
	server_pass_my, %% 本纪的服务器地址
	guild_name, %% 帮会名字
	server_no, %% 服务器id
	server_pass, %% 主服务器连接地址

	is_double_exp, %% 是否是双倍经验
	collect_state  %% 玩家采集状态
}).

%% 使用技能信息
-record(use_skill_info, {
	skill_id, %% 技能id
	target %% 目标(包括目标对象或者是地面坐标)
}).

%% ==========================================================
%% 玩家进程存储的宠物信息
%% ==========================================================
-record(pet_info, {
	uid, %% 宠物唯一id
	scene_pid, %% 宠物所在场景的pid
	monster_id, %% 怪物模板id
	exp, %% 当前经验
	cur_hp %% 当前血量
}).

-record(enmity_info, {
	obj_type, %% 对象类型
	obj_id, %% 对象id
	value, %% 仇恨值
	effective_time %% 有效期
}).

-record(cur_target_info, {
	obj_type, %% 对象类型
	obj_id, %% 对象id
	name, %% 对象名
	career, %% 玩家职业,如果仇恨目标是玩家才有值
	sex, %% 玩家性别,如果仇恨目标是玩家才有值
	monster_id %% 怪物模板id,如果仇恨目标是非玩家才有值
}).

-record(cur_drop_owner_info, {
	player_id, %% 玩家id
	name, %% 玩家名字
	lv, %% 等级
	career, %% 职业
	vip, %% vip等级
	harm, %% 玩家造成伤害
	total_harm, %% 造成总输出
	effective_time %% 有效期
}).

%% ==========================================================
%% 场景
%% ==========================================================
-record(ets_scene, {
	pid,
	scene_id,
	player_list
}).

-record(ets_scene_maps, {
	scene_id,
	pid_list %% 多人副本场景pid集合
}).

-record(pid_line, {
	pid,
	line_num
}).

-record(ets_player_scene, {
	player_id,
	scene_id,
	pid
}).

-record(ets_boss_refresh, {
	scene_boss_id, %% {场景id,bossid,场景线路}
	refresh_time %% 刷新时间
}).

-record(ets_activity_shacheng, {
	id, %% 用做唯一标识
	guild_id, %% 当前占领的帮派id
	is_activity %% 是否关闭
}).

%% 场景进程状态
-record(scene_state, {
	scene_id, %% 场景Id
	scene_conf, %% 场景配置文件
	type, %% 场景类型
	width, %% 场景宽
	high, %% 场景高
	end_time, %% 活动介绍时间
	close_time, %% 场景关闭时间
	destroy_time, %% 场景销毁时间
	obj_dict, %% 对象字典
	area_dict, %% 区域字典
	point_dict, %% 坐标字典
	drop_dict, %% 掉落字典
	drop_point_dict, %% 掉落坐标字典
	fire_wall_dict, %% 火墙字典
	fire_wall_point_dict, %% 火墙坐标字典
	monster_area_dict, %% 刷怪区字典
	monster_refresh_dict, %% 怪物刷新字典
	instance_state, %% 副本记录
	activity_state, %% 活动记录
	activity_status, %% 活动状态:1活动开启,0活动关闭
	cur_uid, %% 当前唯一id
	drop_cur_uid, %% 掉落当前唯一id
	fire_wall_cur_uid, %% 火墙当前唯一id
	instance_end_state, %% 副本结束状态
	round, %% 副本的波数
	send_list_12010,  %% 触发技能效果 发送12010组包
	send_list_11020, %%  对象频繁数据更新 发送11020组包
	line_num,%% 属于线路
	activity_begintime_endtime, %% 活动开启结束时间
	enter_instance_player_list, %% 纪录进入过副本的玩家列表

	refuse_box_time_shacheng, %% 沙巴克刷新宝箱的时间
	ai_obj_on_time, %% 怪物定时器 设置1秒中循环一次
	scene_pic %% 场景的背景图
}).

%% 全服红包信息
-record(red_state, {
	red_record_list, %% 红包列表
	red_id_player_id_list, %% 领取红包玩家列表
	begin_time, %% 开始时间
	end_time, %% 结束时间
	send_time %% 发送时间
}).

%% 帮会红包信息
-record(red_guild_state, {
	red_guild_record_list %% 红包列表
}).


%% 个人副本状态
-record(instance_single_state, {
	monster_count, %% 怪物总数
	kill_monster_count, %% 杀死怪物数量
	boss_count, %% boss总数
	kill_boss_count, %% 杀死boss数量
	logout_time, %% 玩家离线时间

	monster_list, %% 幻境之城怪物数据保存
	is_pass, %% 该场景是否已经已经通关
	ref_time, %% 幻境之城刷新时间
	round %% 波数
}).

%% 开服活动纪录state
-record(active_state, {
	active_service_list,
	active_service_type_list
}).

%% 合服活动纪录state
-record(active_merge_state, {
	active_service_list,
	active_service_type_list
}).

%% 竞技场副本状态
-record(instance_arena_state, {
	player_id,
	player_socket,
	arena_a,
	arena_b,
	is_send_result
}).

%% 多人副本纪录
-record(instance_multiple_state, {
	scene_sign
}).

%% 屠龙大会副本记录
-record(instance_dragon_state, {
	boss_id,
	is_die
}).

%% 胜者为王副本纪录
-record(instance_szww_state, {
	total_time,
	close_tamp,
	stop_tamp
}).

%% 沙城活动
-record(activity_shacheng_state, {
	guild_id%% 占领帮派id
}).

%% 攻城副本状态
-record(instance_attack_city_state, {
	round, %% 当前怪物波数
	box_count, %% 剩余宝箱数量
	next_refuse_time, %% 下一波怪物刷新时间
	is_kill_boss, %% 龙柱是否被击杀
	boss_id,
	boss_hp,
	boss_harm
}).

%% 个人boss纪录
-record(instance_single_boss_state, {
	scene_sign,        %%副本标识
	instance_week,    %%副本关闭时间
	instance_day,    %%副本计时日
	boss_count, %% boss总数
	kill_boss_count, %% 杀死boss数量
	enter_time,    %%进入时间
	left_time    %%进入时剩余时间
}).

%% 王城乱斗副本记录
-record(instance_king_state, {
	next_round_time
}).


%% 场景对象
-record(scene_obj_state, {
	%% 基础信息
	obj_type, %% 对象类型
	obj_id, %% 对象id
	x, %% 当前x坐标
	y, %% 当前y坐标
	ex, %% 移动目标点x坐标
	ey, %% 移动目标点y坐标
	direction, %% 朝向
	area_id, %% 区域id
	buff_time, %% buff时间

	%% 生物信息
	name, %% 名字
	sex, %% 性别
	career, %% 职业
	lv, %% 等级
	cur_hp, %% 当前血量
	cur_mp, %% 当前魔法
	attr_base, %% 基础属性
	attr_total, %% 对象总属性
	effect_dict, %% 效果字典
	effect_src_dict, %% 效果来源字典
	buff_dict, %% buff字典
	last_move_time, %% 最后移动时间
	pass_trigger_skill_list = [], %% 被动技能列表
	status, %% 对象状态:0死亡，1活着
	pk_mode, %% pk模式
	vip, %% vip等级

	%% 玩家和宠物通用类型
	name_colour, %% 名字颜色
	guild_id, %% 帮派id
	legion_id, %% 军团id
	team_id, %% 队伍id
	group,        %%活动类型的临时分组

	%% 玩家特有信息
	obj_pid, %% 对象pid
	guise, %% 对象外观
	fh_cd, %% 复活戒指cd
	career_title, %% 添加玩家的称号
	leader, %% 是否是队长
	pet_dict, %% 宠物dict
	pet_att_type, %% 宠物攻击模式
	guild_name, %% 帮会名字
	collect_state, %% 玩家采集状态

	%% 掉落物品特有信息
	goods_id, %% 如果是掉落对象有物品id
	drop_num, %% 物品掉落数量
	owner_change_time, %% 归属权移除时间

	%% 怪物宠物通用信息
	monster_id, %% 如果是怪物有怪物模板id

	%% 怪物信息
	birth_x, %% 出生点x坐标
	birth_y, %% 出生点y坐标
	refresh_location, %% 刷新区域，只有怪物才有
	refresh_interval, %% 刷新间隔，只有怪物才有
	area_flag, %% 刷怪区标识(只有怪物才有，用于映射对应的刷怪区)
	drop_owner, %% 掉落归属{玩家id, 归属移除时间}
	warning_info, %% 怪物即将预警的信息
	warning_skill_info, %% 怪物即将释放的技能信息
	last_skill, %% 最后释放的技能
	monster_res_id, %% 怪物的外观id
	go_out_time, %% 怪物离开时间

	%% 宠物信息
	owner_type, %% 主人类型
	owner_id, %% 主人id
	owner_pid, %% 主人pid
	exp, %% 宠物当前经验

	%% AI信息
	cur_target, %% 当前仇恨目标
	attack_type, %% 攻击类型
	guard_range, %% 警戒范围
	patrol_range, %% 巡逻范围
	chase_range, %% 追击范围
	speed, %% 速度
	patrol_interval, %% 巡逻间隔
	patrol_rate, %% 巡逻概率
	patrol_list, %% 巡逻列表
	chase_interval, %% 追击间隔
	skill_dict, %% 技能字典(用于存放技能CD等)
	skill_rule, %% 技能释放规则
	enmity_dict, %% 仇恨字典
	last_use_skill_time, %% 最后施法时间(毫秒)
	ai_state, %% ai状态
	action_cmd, %% 行动指令
	next_action_time, %% 下一次行动时间
	public_cd_interval, %% 公用CD间隔
	last_use_skill, %% 最后使用技能
	walk_range, %% 行走范围

	kill_targer, %% 击杀该玩家的信息

	server_name, %% 服务器名称
	server_id, %% 原服务器id
	server_pass %% 服务器地址
}).

%% 场景掉落对象
-record(scene_drop_state, {
	uid,
	goods_id,
	bind,
	num,
	x,
	y,
	area_id,
	goods_info,
	remove_time,
	owner_id,
	owner_change_time,
	team_id, %% 队伍id
	server_id %% 服务器id
}).

%% 火墙对象
-record(fire_wall_state, {
	uid,
	owner_id,
	pk_mode,
	x,
	y,
	area_id,
	min_att,
	max_att,
	interval,
	next_time,
	remove_time,
	guild_id,
	team_id
}).

%% 刷怪区域对象
-record(monster_area_state, {
	area_flag, %% 区域标识
	count, %% 怪物总数
	monster_id, %% 怪物Id
	next_refresh_time, %% 下次刷新时间戳
	refresh_location, %% 刷新区域
	refresh_interval, %% 刷新间隔
	monster_list %% 当前存活怪物列表
}).

%% 刷怪对象
-record(monster_refresh_state, {
	die_obj_id, %% 死亡怪物唯一id
	monster_id, %% 怪物Id
	next_refresh_time, %% 下次刷新时间戳
	refresh_location, %% 刷新区域
	refresh_interval %% 刷新间隔
}).

%% ==========================================================
%% 游戏对象
%% ==========================================================
%% 游戏场景对象管理状态(所有的字典信息只保存活着的对象)
-record(game_obj_mgr_state, {
	scene_id, %% 对应的场景id
	scene_pid, %% 对应的场景pid
	obj_dict, %% 对象字典
	area_dict, %% 区域字典
	point_dict %% 坐标字典
}).

%% ==========================================================
%% 挂机
%% ==========================================================
%% 挂机进程状态
-record(hook_state, {
	scene_id, %% 场景id
	hook_player_state, %% 玩家对象
	hook_pet_state, %% 宠物对象
	monster_dict, %% 怪物字典
	fire_wall_dict, %% 火墙字典
	start_time, %% 挂机回合开始时间戳
	end_time, %% 挂机结束时间戳
	next_round_time, %% 下一回合时间戳
	round_status, %% 回合状态
	challenge_boos, %% 挑战boss
	boss_round, %% boss回合
	hook_heartbeat, %% 挂机心跳
	drive, %% 驱动(前端驱动/后端驱动)
	fire_wall_uid %% 火墙唯一id
}).

%% 挂机怪物对象
-record(hook_obj_state, {
	obj_id,
	obj_type,
	monster_id,
	career,
	lv,
	is_boss,
	status,
	cur_hp,
	cur_mp,
	attr_base,
	attr_total,
	skill_dict,
	order_skill_list,
	effect_dict,
	effect_src_dict,
	buff_dict,
	is_drop,
	pet_id,
	last_use_skill_time, %% 最后施法时间(毫秒)
	pass_trigger_skill_list = [] %% 被动技能列表
}).

%% ==========================================================
%% 战斗
%% ==========================================================
%% 战斗对象
-record(combat_obj, {
	obj_id,
	obj_type,
	career,
	lv,
	effect_dict,
	effect_src_dict,
	buff_dict,
	cur_hp, %% 当前血量
	cur_mp, %% 当前蓝量
	attr_base, %% 基础属性
	attr_total, %% 总属性
	x,
	y,
	pass_trigger_skill_list = [],
	fh_cd = 0,
	monster_id,
	pet_dict
}).

%% 技能伤害加成
-record(skill_harm, {
	add_percent = 0, %% 百分比加成
	append = 0 %% 附加伤害
}).

%% 技能效果返回
-record(skill_result, {
	skill_cmd,
	obj_type,
	obj_id,
	result
}).

%% 伤害结果
-record(harm_result, {
	harm_value,
	status
}).

%% buff结果
-record(buff_result, {
	operate,
	buff_id,
	buff_info
}).

%% 施法信息
-record(spell_skill_info, {
	target_point,
	skill_conf
}).

-record(skill_effect, {
	harm_list = [], %% 伤害列表
	cure_list = [], %% 恢复列表
	buff_list = [], %% buff列表
	move_list = [], %% 移动列表
	knockback_list = [], %% 击退列表
	call_pet, %% 招唤宠物
	fire_wall, %% 火墙
	remove_effect, %% 移除buff
	tempt %% 诱惑
}).

-record(buff_effect, {
	effect_id = 0,
	effect_p = 0,
	effect_v = 0,
	attr_change = #attr_base{}
}).

%% ==========================================================
%% 其他
%% ==========================================================
-record(ets_player_counter, {
	key, %% {player_id,counter_id}
	value,
	update_time
}).

%% 关键字分组记录定义
-record(ets_keyword_group, {
	group = 0, %% 分组，即字符长度
	content = [] %% 内容，即字符列表
}).

-record(ets_chat, {
	chat_sort = 0, %%聊天类型
	chat_list = [] %%聊天数据
}).

-record(ets_mail_conf, {
	id = 0, %% id类型
	mail_type,
	sender,
	title,
	content,
	award,
	active_time,
	update_time
}).

-record(ets_player_mail, {
	key, %% {id,player_id}
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

-record(ets_guild_list, {
	guild_id,
	member_num = 0,
	member_list = [],
	apply_list = [],
	log_list = [],
	sbk_fem_state = 0,
	sbk_fem_time = 0
}).

-record(ets_guild_mod, {
	key,
	pid
}).

-record(ets_player_gem_list, {
	player_id,
	gem_list
}).

-record(ets_daily_tasks, {
	key, %% {player_id,task_id}
	db = []
}).

%% 玩家交易记录记录
-record(ets_transaction, {
	player_idA = 0, %% key
	player_idB = 0, %% 对方
	status = 0, %% 标记状态[0:正在交易,1:锁定道具,2:确定交易]
	goods_list = [],
	jade = 0
}).

%% 玩家队伍
-record(ets_player_team, {
	player_id = 0, %% 玩家id
	team_id = 0 %% 队长pid
}).

%% 队伍资料
-record(ets_team, {
	team_id = 0, %% 队长id
	leader_id = 0, %% 队长pid
	pid = none,
	name = "", %% 队长名字
	lv = 0, %% 队长等级
	career = 0, %% 队长职业
	guild_name = "", %% 队长帮会名
	mb_num = [], %% 队伍人数
	team_pid = none %% 队伍pid
}).

%% 队伍基础数据
-record(team, {
	team_id = 0, %% 队伍id
	leader_id = 0, %% 队长id
	leader_pid = none, %% 队长pid
	mb = []%% 队伍成员
}).

%% 队伍成员数据
-record(team_mb, {
	player_id, %% 玩家id
	name, %% 名字
	lv, %% 等级
	career, %% 职业
	fight, %% 战斗力
	guild_name, %% 帮会名
	is_online, %% 是否在线 0离线 1在线
	player_pid, %% 玩家pid
	socket,
	scene_id %% 玩家所在场景id
}).

%% 玩家好友信息ets信息
-record(ets_relationship, {
	player_id,
	name,
	career,
	sex,
	friend_list = [], %% 玩家好友列表#ets_relationship_map
	black_list = [], %% 黑名单
	foe_list = [], %% 仇人列表
	friend_ask_list = [], %% 玩家A的申请列表
	update_time_list = [] %% 需要更新好友在线时间的列表
}).

%% 称号相关信息记录
-record(ets_title_careet, {
	career, %% 职业
	player_id, %% 玩家id
	name, %% 玩家名称
	fight, %% 战力
	sex %% 性别
}).

-record(ets_player_id_name, {
	name = <<"">>, %% 玩家名称
	player_id = 0, %% 玩家id
	career = 0,%% 玩家职业
	merit_task_id = 0 %% 纪录功勋任务id
}).

-record(ets_scene_city,
{
	scene_id, %% 场景城市id
	city_info, %% 城市信息
	city_officer = [] %% 城市官员信息
}).

%% 全局通用配置
-record(ets_common_config, {
	key,
	value
}).

%% 容联聊天群组缓存
-record(ets_rl_group, {
	name,
	group_id
}).

%% 云游商人商品ets
-record(ets_wander_shop, {
	shop_id,
	limit_count,
	buy_count
}).

%% 云游商人商品列表ets
-record(ets_wander_shop_list, {
	type,
	shop_list,
	update_time,
	refuse_list
}).

%% 玩家仇人记录
-record(ets_foe, {
	player_id,
	foe_list
}).

%% 限时活动提醒
-record(ets_active_remind, {
	key,
	close_function_list,
	open_function_list
}).

%% 抽奖信息记录
-record(lottery_state, {
	lottery_db_list, %% 转盘抽奖信息
	server_num, %% 转盘抽奖次数
	ref_time, %% 转盘刷新时间

	lottery_shmj,    %%神皇秘境转盘状态

	lottery_coin_db_list, %% 金币转盘抽奖信息
	server_coin_num, %% 金币转盘抽奖次数
	ref_coin_time %% 金币转盘刷新时间
}).
%% 抽奖信息
-record(lottery_data, {
	lottery_db_list, %% 转盘抽奖信息
	server_num, %% 转盘抽奖次数
	ref_time, %% 转盘刷新时间
	day_num        %%本服每日抽奖次数
}).
%% 红包零时数据存储
-record(lottery_temp, {
	lottery_info,
	lottery_conf
}).

%% 日志gen_server状态
-record(log_state, {
	log_tables,
	db_name
}).

%%日志状态
-record(log_cache_state, {
	begin_id = 1,
	current_id = 1,
	saving = false
}).

%% 击杀玩家信息
-record(ets_player_kill, {
	key, %% {player_id, kill_player_id}
	count,
	update_time
}).

%%合服
-record(merge_state, {
	type,
	tasks,
	step,
	page_no,
	pages,
	%%多任务方式
	single_tasks,    %%顺序执行任务
	process_tasks,    %%正在处理的任务
	idle_pools        %%空闲的线程
}).

%% 机器人相关
-record(robot_state, {
	use_list %% 已经使用的编号列表
}).

%% ==========================================================
%% 运营活动
%% ==========================================================

%% 运营活动配置
-record(ets_operate_active_conf, {
	active_id,  %% 活动编号
	order_id,  %% 排序
	type, %% 活动类型1文字公告类型 2双倍文字公告类 3配置条件类
	model, %% 模版 1默认 2累计充值消费  3限时购买
	mark, %% 活动标签0无 1限时 2火爆 3推荐
	title, %% 活动标题
	content, %% 活动内容
	show_reward, %% 奖励展示
	is_button, %% 是否有领取按钮 0没有 1有
	button_content,
	is_window,
	is_count_down,
	window_content,
	start_time, %% 开始时间
	end_time, %% 结束时间
	finish_type, %% 完成类型1 1活动期间内每天 2活动期间
	finish_count, %% 可完成次数1
	update_time %% 更新时间
}).

-record(ets_operate_sub_type_conf, {
	key, %% {active_id, active_type}
	active_id,  %% 活动编号
	sub_type, %% 活动子类
	content, %% 内容
	limit_count, %% 限制次数
	original_price, %% 原始价格
	finish_limit, %% 完成条件,
	finish_consume, %% 完成消耗扣除
	finish_reward, %% 完成奖励
	update_time %% 更新时间
}).

%% 当前开启的运营活动id列表
-record(ets_open_operate_list, {
	key,
	active_list,  %% 活动列表{active_id, active_type}
	holiday_list, %% 节日活动列表{active_id, active_type}
	limit_list %% 限制条件列表{active_id, limit_type}
}).

%% 双倍经验状态纪录
-record(ets_double_exp, {
	key,
	state %% 状态0未开启 1已开启
}).

%% 双倍经验状态纪录
-record(ets_button_update_time, {
	key, %% {player_id, button_id}
	update_time %% 更新时间
}).

-record(active_time_info, {
	active_type_id,
	active_type_conf,
	begin_time,
	end_time,
	is_open
}).

%% 坐标记录信息
-record(ets_area_id_list, {
	x_y_witgh_high, %% 坐标宽高
	list %% 区域列表
}).

%% 沙巴克拾取宝箱记录
-record(ets_sbk_box, {
	key, %% 沙巴克sceneid
	ref_shacheng_time, %% 沙城刷新时间
	ref_palace_time, %% 皇宫宝箱刷新时间
	player_dice %% 玩家采集数据保存
}).

%% 幻境之城记录
-record(ets_hjzc, {
	key, %%id
	is_open, %% 是否开启
	player_pass_dict, %% 玩家通关房间记录
	box_from_list, %% 宝箱出现的房间
	rand_room_num_list, %% 可以随机的房间数列表
	record_box_list %% 记录box出现的房间信息
}).

-record(hjzc_player, {
	player_id, %% 玩家id
	name, %% 玩家名字
	room_list, %% 点亮的房间列表
	time, %% 最新的点亮时间
	server_pass %% 对应玩家的服务器地址
}).

%%每一个结盟的帮会列表
-record(ets_guild_alliance, {
	id,            %%结盟id
	guild_list    %%帮会列表
}).

%%帮会的结盟状态
-record(ets_guild_alliance_state, {
	guild_id,            %%帮会id
	alliance_id = 0,    %%结盟id
	request_list = []    %%结盟请求列表
}).




