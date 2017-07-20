%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%        自动生成文件，不要手动修改
%%% @end
%%% Created : 2017/03/29
%%%-------------------------------------------------------------------

%% 玩家登录信息
-record(proto_login_info, {
	player_id = 0,  %%  玩家唯一id
	name = <<"">>,  %%  玩家名
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	lv = 0  %%  等级
}).

%% 玩家基础属性
-record(proto_attr_base, {
	cur_hp = 0,  %%  当前血量
	cur_mp = 0,  %%  当前魔法
	hp = 0,  %%  血量
	mp = 0,  %%  魔法
	min_ac = 0,  %%  最小物理攻击
	max_ac = 0,  %%  最大物理攻击
	min_mac = 0,  %%  最小魔法攻击
	max_mac = 0,  %%  最大魔法攻击
	min_sc = 0,  %%  最小道术攻击
	max_sc = 0,  %%  最大道术攻击
	min_def = 0,  %%  最小物防
	max_def = 0,  %%  最大物防
	min_res = 0,  %%  最小魔防
	max_res = 0,  %%  最大魔防
	crit = 0,  %%  暴击
	crit_att = 0,  %%  暴击伤害
	hit = 0,  %%  准确
	dodge = 0,  %%  敏捷
	damage_deepen = 0,  %%  伤害加深
	damage_reduction = 0,  %%  伤害减免
	holy = 0,  %%  神圣
	skill_add = 0,  %%  技能伤害追加
	m_hit = 0,  %%  魔法命中
	m_dodge = 0,  %%  魔法闪避
	hp_recover = 0 ,  %%  生命恢复
	mp_recover = 0 ,  %%  魔法恢复
	resurgence = 0 ,  %%  死亡恢复
	damage_offset = 0 ,  %%  伤害抵消
	luck = 0,  %%  幸运
	hp_p = 0,  %%  血量百分比加成
	mp_p = 0,  %%  魔法百分比加成
	min_ac_p = 0,  %%  最小物理攻击百分比加成
	max_ac_p = 0,  %%  最大物理攻击百分比加成
	min_mac_p = 0,  %%  最小魔法攻击百分比加成
	max_mac_p = 0,  %%  最大魔法攻击百分比加成
	min_sc_p = 0,  %%  最小道术攻击百分比加成
	max_sc_p = 0,  %%  最大道术攻击百分比加成
	min_def_p = 0,  %%  最小物防百分比加成
	max_def_p = 0,  %%  最大物防百分比加成
	min_res_p = 0,  %%  最小魔防百分比加成
	max_res_p = 0,  %%  最大魔防百分比加成
	crit_p = 0,  %%  暴击百分比加成
	crit_att_p = 0,  %%  暴击伤害百分比加成
	hit_p = 0,  %%  准确百分比加成
	dodge_p = 0,  %%  敏捷百分比加成
	damage_deepen_p = 0,  %%  伤害加深百分比加成
	damage_reduction_p = 0,  %%  伤害减免百分比加成
	holy_p = 0,  %%  神圣百分比加成
	skill_add_p = 0,  %%  技能伤害追加百分比加成
	m_hit_p = 0,  %%  魔法命中百分比加成
	m_dodge_p = 0,  %%  魔法闪避百分比加成
	hp_recover_p = 0 ,  %%  生命恢复百分比加成
	mp_recover_p = 0 ,  %%  魔法恢复百分比加成
	resurgence_p = 0 ,  %%  死亡恢复百分比加成
	damage_offset_p = 0   %%  伤害抵消百分比加成
}).

%% 外观属性
-record(proto_guise, {
	weapon = 0,  %%  武器外观
	clothes = 0,  %%  衣服外观
	wing = 0,  %%  翅膀外观
	pet = 0,  %%  宠物外观
	mounts = 0,  %%  坐骑外观
	mounts_aura = 0  %%  坐骑光环
}).

%% 货币属性
-record(proto_money, {
	coin = 0,  %%  金币
	jade = 0,  %%  元宝
	gift = 0,  %%  礼券
	smelt_value = 0,  %%  熔炼值
	feats = 0,  %%  功勋
	hp_mark_value = 0,  %%  hp印记值
	atk_mark_value = 0,  %%  攻击印记值
	def_mark_value = 0,  %%  防御印记值
	res_mark_value = 0  %%  魔防印记值
}).

%% 标记值
-record(proto_mark, {
	hp_mark = 0,  %%  hp印记
	atk_mark = 0,  %%  atk印记
	def_mark = 0,  %%  def印记
	res_mark = 0,  %%  res印记
	holy_mark = 0,  %%  holy印记
	mounts_mark_1 = 0,  %%  坐骑装备印记1
	mounts_mark_2 = 0,  %%  坐骑装备印记2
	mounts_mark_3 = 0,  %%  坐骑装备印记3
	mounts_mark_4 = 0  %%  坐骑装备印记4
}).

%% 自动喝药设置
-record(proto_hp_set, {
	isuse = 0 ,  %%  是否开启自动回复功能
	hp = 0 ,  %%  回复血量百分比
	hp_goods_id = 0,  %%  回复血量百分比道具
	mp = 0 ,  %%  回复篮量百分比
	mp_goods_id = 0  %%  回复篮量百分比道具
}).

%% 自动回蓝回血设置
-record(proto_hpmp_set, {
	isuse = 0 ,  %%  是否开启瞬间回复功能
	hp = 0 ,  %%  对象唯一id
	hp_mp_goods_id = 0  %%  瞬间回复血量篮量道具
}).

%% 出售装备设置
-record(proto_equip_sell_set, {
	isauto = 0 ,  %%  是否开启自动出售功能 1是0不是
	white = 0 ,  %%  白色是否自动出售 1是0不是
	green = 0 ,  %%  绿色是否自动出售 1是0不是
	blue = 0 ,  %%  蓝色是否自动出售 1是0不是
	purple = 0   %%  紫色是否自动出售 1是0不是
}).

%% 自动拾取设置信息
-record(proto_pickup_set, {
	isauto = 0 ,  %%  是否开启自动拾取功能 1是0不是
	equip_set = [],  %%  装备拾取,品质列表
	prop_set = [],  %%  道具拾取,品质列表
	spec_set = []  %%  特殊拾取,组列表
}).

%% 玩家信息
-record(proto_player_info, {
	player_id = 0,  %%  玩家唯一id
	name = <<"">>,  %%  玩家名
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	lv = 0,  %%  等级
	exp = 0,  %%  经验
	attr_base = #proto_attr_base{},  %%  玩家基础属性
	guise = #proto_guise{},  %%  外观属性
	money = #proto_money{},  %%  货币属性
	mark = #proto_mark{},  %%  印记属性
	hook_scene_id = 0,  %%  当前挂机场景id
	pass_hook_scene_id = 0,  %%  通关挂机场景id
	fighting = 0,  %%  玩家战斗力
	bag = 0,  %%  玩家背包格子数
	guild_id = 0,  %%  玩家帮派id
	legion_id = 0,  %%  军团id
	pk_mode = 0 ,  %%  pk模式: 1 和平，2 全体，3 帮派，4 队伍，5 善恶
	pk_value = 0,  %%  pk值
	name_colour = 0 ,  %%  名字颜色
	vip = 0 ,  %%  vip等级
	hp_set = #proto_hp_set{},  %%  血量回复百分比
	hpmp_set = #proto_hpmp_set{},  %%  瞬间回复百分比
	career_title = 0,  %%  职业称号
	equip_sell_set = #proto_equip_sell_set{},  %%  出售装备设置
	pickup_set = #proto_pickup_set{},  %%  拾取设置
	function_open_list = [],  %%  开启功能信息
	guide_step_list = [],  %%  已经完成了的新手信息
	vip_exp = 0,  %%  vip经验
	wing_state = 0 ,  %%  翅膀显示状态
	weapon_state = 0 ,  %%  特武显示状态
	pet_att_type = 0 ,  %%  宠物攻击模式
	pet_num = 0 ,  %%  宠物攻击模式
	register_time = 0,  %%  角色注册时间
	team_id = 0  %%  玩家队伍id
}).

%% 场景对象唯一标识
-record(proto_obj_flag, {
	type = 0 ,  %%  对象类型
	id = 0  %%  对象唯一id
}).

%% 场景坐标
-record(proto_point, {
	x = 0,  %%  x
	y = 0  %%  y
}).

%% buff信息
-record(proto_buff, {
	buff_id = 0,  %%  buff id
	effect_id = 0,  %%  效果id
	countdown = 0  %%  倒计时
}).

%% 特殊buff信息
-record(proto_spec_buff, {
	type = 0,  %%  类型:1血包 2全服双倍 100-300vipbuff
	value = 0,  %%  参数
	countdown = 0  %%  倒计时
}).

%% 场景玩家信息
-record(proto_scene_player, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	name = <<"">>,  %%  玩家名
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	lv = 0,  %%  等级
	cur_hp = 0,  %%  当前血量
	cur_mp = 0,  %%  当前魔法
	hp = 0,  %%  血量
	mp = 0,  %%  魔法
	direction = 0 ,  %%  朝向
	begin_point = #proto_point{},  %%  起始坐标
	end_point = #proto_point{},  %%  结束坐标
	guise = #proto_guise{},  %%  外观属性
	buff_list = [],  %%  buff列表
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>,  %%  帮派名
	legion_id = 0,  %%  军团id
	legion_name = <<"">>,  %%  军团名字
	team_id = 0,  %%  队伍id
	name_colour = 0 ,  %%  名字颜色
	career_title = 0,  %%  职业称号
	pet_num = 0 ,  %%  宠物数量
	server_name = <<"">>,  %%  玩家所在的服务器名称
	collect_state = 0   %%  玩家场景采集状态0未采集 1正在采集
}).

%% 场景玩家更新信息
-record(proto_scene_player_update, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>,  %%  帮派名
	legion_id = 0,  %%  军团id
	legion_name = <<"">>,  %%  军团名字
	team_id = 0,  %%  队伍id
	name_colour = 0 ,  %%  名字颜色
	career_title = 0,  %%  职业称号
	pet_num = 0 ,  %%  宠物数量
	collect_state = 0   %%  玩家场景采集状态0未采集 1正在采集
}).

%% 场景对象频繁更新信息
-record(proto_scene_obj_often_update, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	obj_atk = #proto_obj_flag{},  %%  攻击方的唯一标示
	cause = 0 ,  %%  变更原因: 0 其他原因, 1 技能造成, 2 自身恢复, 3 换装, 4 升级, 5 吃药
	harm_status = 0 ,  %%  伤害状态: 1 miss, 2 普通, 3 暴击 4 反击
	hp_change = 0,  %%  血量变更值
	mp_change = 0,  %%  魔法变更值
	cur_hp = 0,  %%  当前血量
	cur_mp = 0,  %%  当前魔法
	hp = 0,  %%  血量
	mp = 0  %%  魔法
}).

%% 场景玩家更新信息
-record(proto_scene_pet_update, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	guild_id = 0,  %%  帮派id
	legion_id = 0,  %%  军团id
	team_id = 0,  %%  队伍id
	name_colour = 0   %%  名字颜色
}).

%% 仇恨目标
-record(proto_enmity, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	name = <<"">>,  %%  名称
	career = 0,  %%  玩家职业, 如果仇恨目标是玩家才有值
	sex = 0 ,  %%  玩家性别, 如果仇恨目标是玩家才有值
	monster_id = 0  %%  怪物模板id, 如果仇恨目标是非玩家才有值
}).

%% 掉落归属
-record(proto_drop_owner, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	name = <<"">>  %%  名称
}).

%% 场景怪物信息
-record(proto_scene_monster, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	owner_flag = #proto_obj_flag{},  %%  主人唯一标识
	monster_id = 0,  %%  怪物模板id
	name = <<"">>,  %%  怪物名字
	cur_hp = 0,  %%  当前血量
	cur_mp = 0,  %%  当前魔法
	hp = 0,  %%  血量
	mp = 0,  %%  魔法
	direction = 0 ,  %%  朝向
	begin_point = #proto_point{},  %%  起始坐标
	end_point = #proto_point{},  %%  结束坐标
	buff_list = [],  %%  buff列表
	enmity = #proto_enmity{},  %%  仇恨目标
	guild_id = 0,  %%  帮派id
	legion_id = 0,  %%  军团id
	team_id = 0,  %%  队伍id
	name_colour = 0 ,  %%  名字颜色
	drop_owner = #proto_drop_owner{},  %%  掉落归属
	server_name = <<"">>  %%  玩家所在的服务器名称
}).

%% 场景掉落信息
-record(proto_scene_drop, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	goods_id = 0,  %%  道具id
	point = #proto_point{},  %%  坐标
	num = 0,  %%  数量
	player_id = 0,  %%  归属玩家id
	time_out = 0,  %%  归属失效时间
	team_id = 0  %%  归属队伍id
}).

%% 火墙信息
-record(proto_fire_wall, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	point = #proto_point{}  %%  坐标
}).

%% 技能信息
-record(proto_skill, {
	skill_id = 0,  %%  技能模板id
	lv = 0 ,  %%  技能等级
	exp = 0,  %%  技能熟练度
	pos = 0 ,  %%  快捷键位置
	auto_set = 0   %%  自动开关0无 1激活
}).

%% 玩家信息(只能更新数值型数据)
-record(proto_player_update, {
	key = 0,  %%  key
	value = 0  %%  对应key的值
}).

%% 属性数据
-record(proto_attr_value, {
	key = 0,  %%  key
	value = 0  %%  对应key的值
}).

%% 洗练属性数据
-record(proto_attr_baptize_value, {
	id = 0 ,  %%  对应条数id
	state = 0 ,  %%  锁定状态0未锁定 1锁定
	key = 0,  %%  属性key
	value = 0  %%  对应key的值
}).

%% 伤害信息
-record(proto_harm, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	harm_status = 0 ,  %%  伤害状态: 1 miss, 2 普通, 3 暴击 4 反击
	harm_value = 0,  %%  伤害值
	cur_hp = 0,  %%  当前血量
	cur_mp = 0  %%  当前魔法
}).

%% 回血信息
-record(proto_cure, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	add_hp = 0,  %%  增加血量
	cur_hp = 0,  %%  当前血量
	cur_mp = 0  %%  当前魔法
}).

%% buff信息
-record(proto_buff_operate, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	operate = 0 ,  %%  buff操作: 1 添加，2 更新，3 删除
	buff_id = 0,  %%  buff id
	effect_id = 0,  %%  效果id
	countdown = 0  %%  倒计时
}).

%% 挂机怪物信息
-record(proto_hook_monster, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	owner_flag = #proto_obj_flag{},  %%  主人唯一标识
	monster_id = 0,  %%  怪物模板id
	cur_hp = 0,  %%  当前血量
	cur_mp = 0,  %%  当前魔法
	hp = 0,  %%  血量
	mp = 0,  %%  魔法
	guild_id = 0,  %%  帮派id
	legion_id = 0,  %%  军团id
	team_id = 0,  %%  队伍id
	name_colour = 0   %%  名字颜色
}).

%% 道具信息
-record(proto_goods_info, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0,  %%  数量
	stren_lv = 0 ,  %%  强化等级
	location = 0 ,  %%  存放位置
	grid = 0 ,  %%  存放所在格子
	expire_time = 0,  %%  到期时间(时间戳)
	map_scene = 0,  %%  宝图场景id
	map_x = 0,  %%  宝图x坐标
	map_y = 0  %%  宝图y坐标
}).

%% 装备信息
-record(proto_equips_info, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0,  %%  数量
	stren_lv = 0 ,  %%  强化等级
	location = 0 ,  %%  存放位置
	grid = 0 ,  %%  存放所在格子
	baptize_attr_list = [],  %%  装备的洗练属性
	soul = 0 ,  %%  铸魂等级
	luck = 0 ,  %%  幸运值
	expire_time = 0,  %%  到期时间(时间戳)
	secure = 0 ,  %%  投保次数
	bless = 0,  %%  祝福值
	server_id = 0,  %%  服务器id
	is_use = 0  %%  对应服务器，是否可以使用
}).

%% 道具完整信息
-record(proto_goods_full_info, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0,  %%  数量
	stren_lv = 0 ,  %%  强化等级
	location = 0 ,  %%  存放位置
	grid = 0 ,  %%  存放所在格子
	baptize_attr_list = [],  %%  装备的洗练属性
	soul = 0 ,  %%  铸魂等级
	luck = 0 ,  %%  幸运值
	secure = 0   %%  投保次数
}).

%% 道具列表
-record(proto_goods_list, {
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0  %%  数量
}).

%% 交易列表
-record(proto_trade_list, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	num = 0  %%  数量
}).

%% 邮件信息
-record(proto_mail_info, {
	id = 0,  %%  邮件唯一id
	title = <<"">>,  %%  邮件标题
	content = <<"">>,  %%  邮件内容
	award = [],  %%  邮件奖励
	state = 0 ,  %%  邮件领取状态
	send_time = 0  %%  邮件发送时间
}).

%% 邮件信息
-record(proto_mail_award, {
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0  %%  数量
}).

%% 帮派信息
-record(proto_guild_info, {
	guild_id = 0,  %%  帮派id
	guild_rank = 0,  %%  帮派排名
	guild_name = <<"">>,  %%  帮派名称
	chairman_name = <<"">>,  %%  会长名称
	guild_lv = 0 ,  %%  帮派等级
	fight = 0,  %%  战斗力要求
	number = 0  %%  人数
}).

%% 跨服帮派简单信息
-record(proto_guild_simple_info, {
	server_id = 0,  %%  区服
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>  %%  帮派名称
}).

%% 跨服帮标准信息
-record(proto_guild_standard_info, {
	server_id = 0,  %%  区服
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>,  %%  帮派名称
	chairman_name = <<"">>,  %%  会长名称
	guild_lv = 0 ,  %%  帮派等级
	number = 0  %%  人数
}).

%% 帮派申请信息
-record(proto_apply_guild_info, {
	player_id = <<"">>,  %%  玩家名字
	player_name = <<"">>,  %%  玩家名字
	lv = 0,  %%  玩家等级
	career = 0,  %%  玩家职业
	fighting = 0,  %%  玩家战斗力
	online = 0  %%  玩家是否在线0不在1在线
}).

%% 帮派详细信息
-record(proto_guild_detailed_info, {
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>,  %%  帮派名称
	chairman_name = <<"">>,  %%  会长名称
	guild_lv = 0 ,  %%  帮派等级
	guild_rank = 0,  %%  行会排名
	number = 0,  %%  人数
	exp = 0,  %%  行会经验
	capital = 0,  %%  行会资金
	announce = <<"">>  %%  行会公告
}).

%% 帮派成员信息
-record(proto_guild_member_info, {
	player_id = 0,  %%  玩家id
	player_name = <<"">>,  %%  玩家名字
	position = 0 ,  %%  职位:0非会员,1会长,2长老,3会员
	lv = 0,  %%  玩家等级
	career = 0,  %%  玩家职业
	fighting = 0,  %%  玩家战斗力
	contribution = 0  %%  贡献
}).

%% 行会日志信息
-record(proto_guild_log_info, {
	type = 0 ,  %%  类型1加入行会2退出行会3剔除行会4捐献5委任职位6发红包10创建行会
	parameter1 = 0,  %%  参数1时间
	parameter2 = <<"">>,  %%  参数2姓名
	parameter3 = 0  %%  参数3捐献类型，根据type值有不同的含义
}).

%% 玩家帮派信息
-record(proto_player_guild_info, {
	guild_id = 0,  %%  帮派id
	guild_name = <<"">>,  %%  帮派名称
	position = 0 ,  %%  职位:0非会员,1会长,2长老,3会员
	contribution = 0,  %%  贡献
	guild_lv = 0  %%  行会等级
}).

%% 捐献信息
-record(proto_donation_info, {
	type = 0 ,  %%  捐献类型
	count = 0   %%  已捐献次数
}).

%% 帮派信息
-record(proto_legion_info, {
	legion_id = 0,  %%  帮派id
	legion_rank = 0,  %%  帮派排名
	legion_name = <<"">>,  %%  帮派名称
	chairman_name = <<"">>,  %%  会长名称
	legion_lv = 0 ,  %%  帮派等级
	fight = 0,  %%  战斗力要求
	number = 0  %%  人数
}).

%% 帮派申请信息
-record(proto_apply_legion_info, {
	player_id = <<"">>,  %%  玩家名字
	player_name = <<"">>,  %%  玩家名字
	lv = 0,  %%  玩家等级
	career = 0,  %%  玩家职业
	fighting = 0,  %%  玩家战斗力
	online = 0  %%  玩家是否在线0不在1在线
}).

%% 帮派详细信息
-record(proto_legion_detailed_info, {
	legion_id = 0,  %%  帮派id
	legion_name = <<"">>,  %%  帮派名称
	chairman_name = <<"">>,  %%  会长名称
	legion_lv = 0 ,  %%  帮派等级
	legion_rank = 0,  %%  行会排名
	number = 0,  %%  人数
	exp = 0,  %%  行会经验
	capital = 0,  %%  行会资金
	announce = <<"">>  %%  行会公告
}).

%% 帮派成员信息
-record(proto_legion_member_info, {
	player_id = 0,  %%  玩家id
	player_name = <<"">>,  %%  玩家名字
	position = 0 ,  %%  职位:0非会员,1会长,2长老,3会员
	lv = 0,  %%  玩家等级
	career = 0,  %%  玩家职业
	fighting = 0,  %%  玩家战斗力
	contribution = 0  %%  贡献
}).

%% 行会日志信息
-record(proto_legion_log_info, {
	type = 0 ,  %%  类型1加入行会2退出行会3剔除行会4捐献5委任职位6发红包10创建行会
	parameter1 = 0,  %%  参数1时间
	parameter2 = <<"">>,  %%  参数2姓名
	parameter3 = 0  %%  参数3捐献类型，根据type值有不同的含义
}).

%% 玩家帮派信息
-record(proto_player_legion_info, {
	legion_id = 0,  %%  帮派id
	legion_name = <<"">>,  %%  帮派名称
	position = 0 ,  %%  职位:0非会员,1会长,2长老,3会员
	contribution = 0,  %%  贡献
	legion_lv = 0  %%  行会等级
}).

%% 挂机掉落
-record(proto_hook_drop, {
	goods_id = 0,  %%  道具id
	num = 0  %%  数量
}).

%% 道具报告
-record(proto_goods_report, {
	quality = 0 ,  %%  品质
	num = 0,  %%  数量
	sale_num = 0  %%  出售数量
}).

%% 挂机报告
-record(proto_hook_report, {
	offline_time = 0,  %%  离线时长
	kill_num = 0,  %%  杀怪数量
	die_num = 0,  %%  死亡次数
	coin = 0,  %%  获得金币
	exp = 0,  %%  获得经验
	goods_report_list = [],  %%  道具报表
	goods_list = []  %%  道具列表
}).

%% 挂机星级
-record(proto_hook_star, {
	hook_scene_id = 0,  %%  挂机场景Id
	star = 0 ,  %%  星级
	reward_status = 0   %%  奖励状态: 0未领取, 1可领取, 2已领取
}).

%% 挂机星级奖励
-record(proto_hook_star_reward, {
	chapter = 0,  %%  章节
	star = 0 ,  %%  星级
	step_list = []  %%  阶段奖励领取状态, 0未领取, 1可领取, 2已领取
}).

%% 挂机火墙
-record(proto_hook_fire_wall, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	point = #proto_point{},  %%  坐标
	interval = 0,  %%  间隔
	duration = 0  %%  时长
}).

%% 挂机火墙攻击
-record(proto_fire_wall_attack, {
	fire_wall_uid = 0,  %%  火墙唯一id
	monster_uid = 0  %%  受击怪物唯一id
}).

%% 坐标变化
-record(proto_point_change, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	begin_point = #proto_point{},  %%  起始坐标
	end_point = #proto_point{}  %%  结束坐标
}).

%% 任务信息
-record(proto_taskinfo, {
	task_id = 0,  %%  任务id
	nownum = 0,  %%  完成数量
	isfinish = 0   %%  任务是否完成
}).

%% boss刷新时间
-record(proto_boss_refresh, {
	id = 0 ,  %%  id
	refresh_time = 0  %%  刷新时长
}).

%% 组队信息
-record(proto_team_member_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家姓名
	type = 0 ,  %%  玩家类型1队长 2队员
	lv = 0 ,  %%  等级
	career = 0,  %%  职业
	guild_name = <<"">>,  %%  所在行会名
	fight = 0,  %%  战斗力
	is_online = 0   %%  是否在线 0离线 1在线
}).

%% 附近玩家信息(组队系统)
-record(proto_near_by_player, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家姓名
	lv = 0 ,  %%  等级
	career = 0,  %%  职业
	guild_name = <<"">>  %%  所在行会名
}).

%% 附近玩家信息(组队系统)
-record(proto_near_by_team, {
	team_id = 0,  %%  队伍id
	name = <<"">>,  %%  队长姓名
	lv = 0 ,  %%  队长等级
	career = 0,  %%  队长职业
	memeber_num = 0,  %%  队伍人数
	guild_name = <<"">>  %%  所在行会名
}).

%% 地图队友标识
-record(proto_map_teammate_flag, {
	point = #proto_point{}  %%  坐标
}).

%% 竞技场挑战玩家信息
-record(proto_arena_challenge_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	career = 0,  %%  玩家职业
	sex = 0 ,  %%  玩家性别
	fight = 0,  %%  玩家战斗力
	rank = 0  %%  玩家排名
}).

%% 竞技场排行榜信息
-record(proto_arena_rank_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	career = 0,  %%  玩家职业
	fight = 0,  %%  玩家战斗力
	lv = 0,  %%  等级
	guild_name = <<"">>,  %%  公会名
	rank = 0  %%  玩家排名
}).

%% 活动排行榜信息
-record(proto_active_rank_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	score = 0,  %%  玩家积分
	rank = 0  %%  玩家排名
}).

%% 获取开服活动类型列表
-record(proto_active_service_type_info, {
	type_id = 0,  %%  类型id
	state = 0   %%  状态 0,未开启,1，进行中，2，结束
}).

%% 挑战记录
-record(proto_arena_record, {
	type = 0,  %%  记录类型 1挑战成功 2被击败 3挑战失败 4防守成功 
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	rank = 0,  %%  名次
	time = 0  %%  时间戳
}).

%% 社交关系信息
-record(proto_relationship_info, {
	tplayer_id = 0,  %%  好友id
	name = <<"">>,  %%  姓名
	lv = 0 ,  %%  等级
	career = 0,  %%  职业
	fight = 0,  %%  战力
	isonline = 0 ,  %%  是否在线 1在线，0不在线
	last_offline_time = <<"">>  %%  最后离线时间
}).

%% 城市官员信息
-record(proto_city_officer_info, {
	officer_id = 0 ,  %%  官员id
	tplayer_id = 0,  %%  被任命的玩家id
	tname = <<"">>,  %%  任命的玩家名称
	guise = #proto_guise{},  %%  外观属性
	sex = 0 ,  %%  性别
	career = 0  %%  职业
}).

%% 导航列表任务信息
-record(proto_navigate_task_info, {
	task_id = 0,  %%  任务id
	state = 0 ,  %%  任务状态 接取状态 0,任务进行中 1，任务完成  2，任务接取状态，3删除，10 记录信息开始和结束一起
	now_num = 0  %%  当前数量
}).

%% 各个职业的第一名的信息
-record(proto_worship_first_career_info, {
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	name = <<"">>,  %%  姓名
	fight = 0,  %%  战力
	player_id = 0  %%  玩家id
}).

%% 各个职业的第一名的信息
-record(proto_activity_info, {
	activity_id = 0,  %%  活动id
	now_num = 0,  %%  当前数量
	max_num = 0  %%  最大数量
}).

%% 活动信息
-record(proto_active_info, {
	key = 0,  %%  活动id
	state = 0   %%  奖励领取状态0未领取 1已领取 2条件未达到
}).

%% 拍卖场物品信息
-record(proto_sale_info, {
	sale_id = 0,  %%  拍卖id
	goods_id = 0,  %%  物品id
	jade = 0,  %%  价格
	num = 0,  %%  出售的数量
	time = 0,  %%  剩余时间
	stren_lv = 0 ,  %%  强化等级
	soul = 0 ,  %%  铸魂
	secure = 0 ,  %%  投保次数
	baptize_attr_list = [],  %%  装备的洗练属性
	artifact_star = 0 ,  %%  神器星级
	artifact_lv = 0 ,  %%  神器等级
	artifact_exp = 0   %%  神器经验
}).

%% 拍卖场玩家物品信息
-record(proto_player_sale_info, {
	id = 0,  %%  编号id
	goods_id = 0,  %%  物品id
	jade = 0,  %%  价格
	num = 0,  %%  出售的数量
	time = 0,  %%  过期时间
	state = 0 ,  %%  状态 状态 1 已退出，2 出售成功，3 表示已下架,4 已购买
	stren_lv = 0 ,  %%  强化等级
	soul = 0 ,  %%  铸魂
	secure = 0 ,  %%  投保次数
	baptize_attr_list = [],  %%  装备的洗练属性
	artifact_star = 0 ,  %%  神器星级
	artifact_lv = 0 ,  %%  神器等级
	artifact_exp = 0   %%  神器经验
}).

%% 按钮提示
-record(proto_button_tips, {
	id = 0,  %%  id
	num = 0  %%  数量
}).

%% 屠龙大会排行
-record(proto_world_boss_rank, {
	rank = 0,  %%  排名
	name = <<"">>,  %%  名字
	harm = 0  %%  造成伤害
}).

%% 怪物攻城排行
-record(proto_attack_city_rank, {
	rank = 0,  %%  排名
	name = <<"">>,  %%  名字
	score = 0  %%  积分
}).

%% 云游商品信息
-record(proto_wander_shop, {
	shop_id = 0,  %%  商品id
	count = 0  %%  剩余购买次数
}).

%% 神秘商人商品信息
-record(proto_mystery_shop, {
	mystery_shop_id = 0,  %%  神秘商品id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0,  %%  数量
	curr_type = 0 ,  %%  货币类型
	price = 0,  %%  出售价格
	vip = 0,  %%  vip等级限制
	is_buy = 0 ,  %%  1 已经被购买，0还未购买
	discount = <<"">>  %%  折扣横幅
}).

%% 活动商品信息
-record(proto_active_shop, {
	id = 0,  %%  神秘商品id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0,  %%  数量
	buy_num = 0,  %%  以购买次数
	limit_num = 0,  %%  购买的上限次数
	curr_type = 0 ,  %%  货币类型
	price = 0,  %%  出售价格
	price_old = 0  %%  出售价格
}).

%% 等级排行信息
-record(proto_lv_rank_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	career = 0,  %%  玩家职业
	lv = 0,  %%  等级
	guild_name = <<"">>,  %%  公会名
	rank = 0  %%  玩家排名
}).

%% 战斗力排行信息
-record(proto_fight_rank_info, {
	player_id = 0,  %%  玩家id
	name = <<"">>,  %%  玩家名字
	career = 0,  %%  玩家职业
	fight = 0,  %%  玩家战斗力
	guild_name = <<"">>,  %%  公会名
	rank = 0  %%  玩家排名
}).

%% 行会排行信息
-record(proto_guild_rank_info, {
	guild_id = 0,  %%  行会id
	chief_name = <<"">>,  %%  会长名字
	member_num = 0,  %%  成员数量
	guild_lv = 0,  %%  行会等级
	guild_name = <<"">>,  %%  公会名
	rank = 0  %%  行会排名
}).

%% fb信息
-record(proto_fb_info, {
	scene_id = 0,  %%  场景id
	now_times = 0,  %%  剩余进入次数
	buy_times = 0,  %%  已购买次数
	limit_buy_times = 0,  %%  购买上限次数
	next_scene_id = 0,  %%  下一级场景id
	need_jade = 0  %%  需要多少元宝
}).

%% 扫荡物品信息
-record(proto_raids_goods_info, {
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0  %%  数量
}).

%% 开服活动信息
-record(proto_active_service_info, {
	active_service_id = 0,  %%  活动id
	is_receive = 0 ,  %%  (全服击杀) 是否可以领取   0可以领取1,未达到条件，2，已经领取，3，已经领取完了
	state2 = 0 ,  %%  (单次击杀) 是否可以领取   0可以领取1,未达到条件，2，已经领取
	name = <<"">>,  %%  (全服击杀)玩家名字
	num = 0  %%  还剩余数量
}).

%% 开服活动排名信息
-record(proto_active_service_rank_info, {
	rank = 0,  %%  排名
	name = <<"">>,  %%  名称
	player_id = 0,  %%  玩家id
	value = 0  %%  玩家排名的值
}).

%% 公会红包信息
-record(proto_guild_red_info, {
	name = <<"">>,  %%  发送的玩家名字
	position = 0,  %%  发送玩家的职位
	num = 0,  %%  发送的红包数量
	red_id = 0,  %%  红包id
	des = <<"">>,  %%  说明
	state = 0   %%  红包当前状态  0正常，1，已结领取过了，2，已结领取完了
}).

%% 开服活动信息
-record(proto_guild_red_log, {
	id = 0,  %%  日志id
	name = <<"">>,  %%  领取玩家的名称
	jade = 0  %%  领取的元宝数量
}).

%% 抽奖日志
-record(proto_lottery_log_info, {
	id = 0,  %%  日志id
	name = <<"">>,  %%  领取玩家的名称
	goods_id = 0,  %%  道具id
	player_id = 0  %%  玩家id
}).

%% 抽奖物品信息
-record(proto_lottery_goods_info, {
	id = 0,  %%  lottery唯一id
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0  %%  数量
}).

%% 世界聊天信息
-record(proto_world_chat_info, {
	player_id = 0,  %%  玩家id
	player_name = <<"">>,  %%  玩家姓名
	vip = 0 ,  %%  vip等级
	time = 0,  %%  发送时间
	content = <<"">>,  %%  内容
	team_id = 0,  %%  队伍id
	guild_id = 0,  %%  帮派id
	legion_id = 0  %%  军团id
}).

%% 线路信息
-record(proto_line_info, {
	line_num = 0,  %%  线路
	state = 0 ,  %%  线路状态 0，绿色，1，红色
	player_num = 0  %%  当前线路的人数
}).

%% 运营活动信息
-record(proto_operate_active_info, {
	active_id = 0,  %%  活动编号
	mark = 0 ,  %%  活动标签0无 1限时 2火爆 3推荐
	model = 0 ,  %%  模版 0默认 1累计充值消费  2限时购买
	title = <<"">>,  %%  活动标题
	content = <<"">>,  %%  活动内容
	show_reward = [],  %%  奖励展示
	is_button = 0 ,  %%  是否有领取按钮0没有 1有
	button_content = <<"">>,  %%  按钮描述
	is_window = 0 ,  %%  是否弹窗0不弹窗 1弹窗
	window_content = <<"">>,  %%  弹窗内容文字
	start_time = 0,  %%  开始时间戳
	end_time = 0,  %%  结束时间戳
	state = 0  %%  按钮状态1按钮显示  2按钮变灰
}).

%% 运营活动信息模版2
-record(proto_operate_active_info_model_2, {
	active_id = 0,  %%  活动编号
	mark = 0 ,  %%  活动标签0无 1限时 2火爆 3推荐
	model = 0 ,  %%  模版 0默认 1累计充值消费 2限时购买 3公告模版
	title = <<"">>,  %%  活动标题
	content = <<"">>,  %%  描述内容
	content_value = 0,  %%  描述参数
	sub_list = [],  %%  模版2内容
	start_time = 0,  %%  开始时间戳
	end_time = 0,  %%  结束时间戳
	cur_time = 0,  %%  当前服务器时间
	is_count_down = 0   %%  0不显示倒计时 1显示倒计时
}).

%% 运营活动信息模版2
-record(proto_model_2, {
	sub_type = 0,  %%  子类型
	content = <<"">>,  %%  参数内容
	show_reward = [],  %%  奖励展示
	state = 0  %%  0不可领取 1可领取
}).

%% 运营活动信息模版3
-record(proto_operate_active_info_model_3, {
	active_id = 0,  %%  活动编号
	mark = 0 ,  %%  活动标签0无 1限时 2火爆 3推荐
	model = 0 ,  %%  模版 0默认 1累计充值消费  2限时购买
	title = <<"">>,  %%  活动标题
	sub_list = [],  %%  模版3内容
	start_time = 0,  %%  开始时间戳
	end_time = 0,  %%  结束时间戳
	cur_time = 0,  %%  当前服务器时间
	is_count_down = 0   %%  0不显示倒计时 1显示倒计时
}).

%% 运营活动信息模版3
-record(proto_model_3, {
	sub_type = 0,  %%  活动子类型
	content = <<"">>,  %%  参数内容
	old_price = [],  %%  原价
	new_price = [],  %%  现价
	shop = [],  %%  商品
	count = 0  %%  剩余购买次数
}).

%% 运营活动信息
-record(proto_operate_holiday_active_info, {
	active_id = 0,  %%  活动编号
	type = 0,  %%  活动类型1文字 2双倍 3条件 4节日杀怪 5节日掉落
	start_time = 0,  %%  开始时间戳
	end_time = 0  %%  结束时间戳
}).

%% 运营活动兑换信息
-record(proto_operate_holiday_change_info, {
	active_id = 0,  %%  活动编号
	fusion_id = 0,  %%  兑换配方id
	count = 0  %%  已兑换次数
}).

%% 答题排行信息
-record(proto_exam_rank_info, {
	name = <<"">>,  %%  玩家名字
	score = 0,  %%  积分
	rank = 0  %%  排名
}).

%% 关注boss
-record(proto_monster_follow, {
	scene_id = 0,  %%  场景id
	monster_id = 0  %%  怪物id
}).

%% boss掉落
-record(proto_monster_boss_drop, {
	planer_name = <<"">>,  %%  玩家名称
	scene_id = 0,  %%  场景id
	monster_id = 0,  %%  怪物id
	monster_goods = [],  %%  掉落物品
	kill_time = 0  %%  击杀时间
}).

%% boss刷新时间和关注
-record(proto_boss_time_and_follow, {
	scene_id = 0,  %%  场景id
	monster_id = 0,  %%  怪物id
	refresh_time = 0,  %%  刷新时长
	follow = 0   %%  是否关注刷新，0未关注1关注
}).

%% 城市boss最后击杀者
-record(proto_city_boss_killer, {
	monster_id = 0,  %%  怪物id
	player_name = <<"">>  %%  击杀者
}).

%% 世界地图信息
-record(proto_word_map_info, {
	scene_id = 0,  %%  场景id
	state = 0  %%  1,表示合服地图没有开启
}).

%% 一生一次性物品状态
-record(proto_shop_once_state, {
	lv = 0,  %%  级别
	pos = 0 ,  %%  位置
	state = 0   %%  0未购买，1已购买，2过期
}).

%% 王城乱斗排行
-record(proto_instance_king_rank, {
	rank = 0,  %%  排名
	name = <<"">>,  %%  名字
	score = 0  %%  积分
}).

%% 王城乱斗战报排行
-record(proto_instance_king_rank_full, {
	rank = 0,  %%  排名
	name = <<"">>,  %%  名字
	lv = 0,  %%  等级
	career = 0,  %%  职业
	score = 0  %%  积分
}).

%% 幻境之城排名信息
-record(proto_hjzc_rank_info, {
	player_id = 0,  %%  玩家唯一id
	rank = 0,  %%  排名
	name = <<"">>,  %%  名字
	num = 0  %%  点亮房间数
}).

%% 变异地宫场景剩余时间
-record(proto_palace_scene, {
	scene_id = 0,  %%  场景id
	time = 0  %%  时间
}).

%% 变异地宫boss击杀数量
-record(proto_palace_boss_num, {
	scene_id = 0,  %%  场景id
	boss_id = 0,  %%  bossid
	num = 0  %%  数量
}).

%% 获取按钮提示
-record(req_get_button_tips, {
}).

%% 获取按钮提示
-record(rep_get_button_tips, {
	button_list = []  %%  按钮列表
}).

%% 更新按钮提示
-record(req_update_button_tips, {
	id = 0,  %%  id
	num = 0  %%  数量
}).

%% 更新按钮提示
-record(rep_update_button_tips, {
	button_list = []  %%  按钮列表
}).

%% 获取军团的tips
-record(req_legion_button_tips, {
}).

%% 错误提示
-record(rep_err_result, {
	result = 0  %%  返回错误码信息
}).

%% 公告
-record(rep_notice, {
	notice_id = 0,  %%  公告id
	arg_list = []  %%  参数列表
}).

%% 玩家下线
-record(rep_login_out, {
	result = 0  %%  错误码
}).

%% 获取角色列表
-record(req_player_list, {
	open_id = <<"">>,  %%  平台id
	platform = 0,  %%  渠道编号
	server_id = 0  %%  服务器编号，合服用
}).

%% 获取角色列表
-record(rep_player_list, {
	result = 0,  %%  结果: 0 成功, 非零失败
	player_list = []  %%  角色信息
}).

%% 创建角色
-record(req_create, {
	open_id = <<"">>,  %%  平台id
	platform = 0,  %%  渠道编号
	name = <<"">>,  %%  玩家名
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	server_id = 0  %%  服务器编号，合服用
}).

%% 创建角色
-record(rep_create, {
	result = 0,  %%  结果: 0 成功, 非零失败
	player_info = #proto_login_info{}  %%  角色信息
}).

%% 进入游戏
-record(req_enter, {
	player_id = 0,  %%  玩家唯一id
	open_id = <<"">>,  %%  平台id
	platform = 0,  %%  渠道编号
	os_type = 0   %%  系统类型：1 ios, 2 android
}).

%% 进入游戏
-record(rep_enter, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取自己属性
-record(req_player_info, {
}).

%% 获取自己属性
-record(rep_player_info, {
	result = 0,  %%  结果: 0 成功, 非零失败
	player_info = #proto_player_info{}  %%  玩家信息
}).

%% 更新玩家信息
-record(rep_update_player, {
	update_list = []  %%  玩家信息
}).

%% 玩家复活
-record(req_revive, {
	type = 0   %%  复活类型: 1 复活点复活, 2 原地复活
}).

%% 玩家复活
-record(rep_revive, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 心跳包
-record(req_heart, {
	client_time = 0  %%  客户端时间
}).

%% 心跳包
-record(rep_heart, {
	server_time = 0  %%  服务器当前时间
}).

%% 退出
-record(req_logout, {
	flag = 0   %%  退出标识: 1 退出角色, 2 退出账号
}).

%% 退出
-record(rep_logout, {
	flag = 0   %%  退出标识: 1 退出角色, 2 退出账号, 3 其他设备登陆
}).

%% 修改pk模式
-record(req_change_pk_mode, {
	pk_mode = 0   %%  pk模式: 1 和平，2 全体，3 帮派，4 队伍，5 善恶
}).

%% 修改pk模式
-record(rep_change_pk_mode, {
	result = 0,  %%  结果: 0 成功, 非零失败
	pk_mode = 0   %%  pk模式: 1 和平，2 全体，3 帮派，4 队伍，5 善恶
}).

%% 删除角色
-record(req_delete_player, {
	player_id = 0  %%  角色id
}).

%% 删除角色
-record(rep_delete_player, {
	player_id = 0  %%  角色id
}).

%% 玩家死亡验证
-record(req_player_die, {
	caster_name = <<"">>  %%  凶手名
}).

%% 玩家死亡
-record(rep_player_die, {
	caster_name = <<"">>,  %%  凶手名
	fh_vip_num = 0  %%  vip复活次数
}).

%% 获取玩家详细信息
-record(req_get_player_info, {
	player_id = 0  %%  玩家id
}).

%% 获取玩家详细信息
-record(rep_get_player_info, {
	player_id = 0,  %%  玩家唯一id
	name = <<"">>,  %%  玩家名
	guild_name = <<"">>,  %%  帮会名称
	lv = 0,  %%  玩家等级
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	fight = 0,  %%  战斗力
	equips_list = [],  %%  装备信息列表
	guise = #proto_guise{},  %%  外观属性
	mark = #proto_mark{},  %%  印记属性
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取玩家身上效果标识
-record(req_get_player_buff_flag, {
}).

%% 获取玩家身上效果标识
-record(rep_get_player_buff_flag, {
	spec_buff_list = [],  %%  特殊buff列表
	buff_list = []  %%  buff列表
}).

%% 改变翅膀外观状态
-record(req_change_wing_state, {
	subtype = 0,  %%  装备类型　13 翅膀，21 特武器 
	state = 0   %%  0显示 1不现实
}).

%% 改变翅膀外观状态
-record(rep_change_wing_state, {
	state = 0 ,  %%  0显示 1不现实
	subtype = 0  %%  装备类型
}).

%% 切换宠物攻击模式
-record(req_change_pet_att_type, {
}).

%% 印记升级
-record(req_upgrade_mark, {
	type = 0   %%  1hp 2atk 3def 4res 5holy
}).

%% 印记升级
-record(rep_upgrade_mark, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取自己的扩展属性
-record(req_player_extra_info, {
}).

%% 获取自己的扩展属性
-record(rep_player_extra_info, {
	result = 0,  %%  结果: 0 成功, 非零失败
	instance_left_time = 0  %%  副本剩余时间
}).

%% 获取跟自己的相关的状态数据
-record(req_player_extra_push, {
	push_list = []  %%  需要推送的协议
}).

%% 获取服务器时间
-record(req_time_info, {
}).

%% 获取服务器时间
-record(rep_time_info, {
	open_days = 0,  %%  开服天数
	server_time = 0  %%  服务器当前时间
}).

%% 机器人进入游戏 进入游戏
-record(req_enter_robot, {
	player_id = 0,  %%  玩家唯一id
	open_id = <<"">>,  %%  平台id
	platform = 0,  %%  渠道编号
	os_type = 0 ,  %%  系统类型：1 ios, 2 android
	key = <<"">>  %%  机器人登录key值验证
}).

%% 切换场景
-record(req_enter_scene, {
}).

%% 切换场景
-record(rep_change_scene, {
	result = 0,  %%  结果: 0 成功, 非零失败
	scene_id = 0,  %%  场景id
	player_list = [],  %%  场景角色信息
	monster_list = [],  %%  场景怪物信息
	drop_list = [],  %%  场景掉落信息
	fire_wall_list = []  %%  场景火墙信息
}).

%% 开始移动
-record(req_start_move, {
	direction = 0 ,  %%  朝向
	begin_point = #proto_point{},  %%  起始坐标
	end_point = #proto_point{}  %%  结束坐标
}).

%% 开始移动
-record(rep_start_move, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	direction = 0 ,  %%  朝向
	begin_point = #proto_point{},  %%  起始坐标
	end_point = #proto_point{}  %%  结束坐标
}).

%% 移动同步
-record(req_move_sync, {
	direction = 0 ,  %%  朝向
	point = #proto_point{}  %%  坐标
}).

%% 移动同步
-record(rep_move_sync, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	direction = 0 ,  %%  朝向
	point = #proto_point{},  %%  坐标
	end_point = #proto_point{}  %%  结束坐标
}).

%% 对象离屏
-record(rep_obj_leave, {
	obj_list = []  %%  离屏对象列表
}).

%% 对象进屏/或者更新
-record(rep_obj_enter, {
	player_list = [],  %%  场景角色信息
	monster_list = [],  %%  场景怪物信息
	drop_list = [],  %%  场景掉落信息
	fire_wall_list = []  %%  场景火墙信息
}).

%% 拾取掉落
-record(req_pickup, {
	drop_id = 0  %%  掉落物品唯一id
}).

%% 拾取掉落
-record(rep_pickup, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% buff变更
-record(rep_buff_operate, {
	buff_list = []  %%  buff列表
}).

%% 伤害
-record(rep_harm_list, {
	harm_list = []  %%  伤害列表
}).

%% 获取世界boss刷新时间
-record(req_world_boss_refresh, {
}).

%% 获取世界boss刷新时间
-record(rep_world_boss_refresh, {
	refresh_list = []  %%  boss刷新时间列表
}).

%% 获取打宝地图boss刷新时间
-record(req_treasure_refresh, {
}).

%% 获取打宝地图boss刷新时间
-record(rep_treasure_refresh, {
	refresh_list = []  %%  boss刷新时间列表
}).

%% 对象更新
-record(rep_obj_update, {
	player_list = []  %%  场景角色信息
}).

%% 场景复活广播
-record(rep_scene_revive, {
	obj_flag = #proto_obj_flag{}  %%  对象唯一标识
}).

%% 获取副本入口信息
-record(req_instance_entry_info, {
	scene_id = 0  %%  场景id
}).

%% 获取副本入口信息
-record(rep_instance_entry_info, {
	scene_id = 0,  %%  场景id
	enter_times = 0   %%  进入次数
}).

%% 获取副本场景统计
-record(req_instance_info, {
}).

%% 个人副本场景统计
-record(rep_single_instance_info, {
	scene_id = 0,  %%  场景id
	monster_count = 0,  %%  怪物总数量
	kill_monster = 0,  %%  杀死怪物数量
	boss_count = 0 ,  %%  boss总数量
	kill_boss = 0 ,  %%  杀死boss数量
	end_time = 0,  %%  结束倒计时
	round = 0  %%  当前波数
}).

%% 退出副本
-record(req_exit_instance, {
}).

%% 个人副本挑战结果
-record(rep_single_instance_result, {
	scene_id = 0,  %%  场景id
	instance_result = 0   %%  副本结果: 1 副本通关成功， 2 副本通关失败
}).

%% 获取沙城活动信息
-record(req_shacheng_info, {
}).

%% 获取沙城活动信息
-record(rep_shacheng_info, {
	activity = 0 ,  %%  是否是活动状态: 0 非活动状态, 1 活动状态
	guild_id = 0,  %%  占领沙城的帮派id
	guild_name = <<"">>  %%  占领沙城的帮派名字
}).

%% 场景地图标识
-record(req_scene_map_flag, {
}).

%% 场景地图标识
-record(rep_scene_map_flag, {
	flag_list = []  %%  玩家队员标识
}).

%% 对象频繁数据更新
-record(rep_obj_often_update, {
	obj_list = []  %%  场景对象信息
}).

%% 获取场景内存活的某个怪物坐标点
-record(req_monster_point, {
}).

%% 获取场景内存活的某个怪物坐标点
-record(rep_monster_point, {
	can_find = 0 ,  %%  是否能找到怪物, 0 找不到, 1 能找到
	point = #proto_point{}  %%  坐标
}).

%% 传送阵传送
-record(req_transfer, {
	id = 0  %%  传送阵id
}).

%% 传送阵传送
-record(rep_transfer, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 更新对象仇恨目标
-record(rep_update_enmity, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	enmity = #proto_enmity{},  %%  仇恨目标
	drop_owner = #proto_drop_owner{}  %%  掉落归属
}).

%% 传送点传送
-record(req_transport, {
	id = 0  %%  传送点id
}).

%% 传送点传送
-record(rep_transport, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取npc状态
-record(req_get_npc_state, {
	id = 0  %%  npcId
}).

%% 获取npc状态
-record(rep_get_npc_state, {
	type = 0  %%  0:开启对应功能  其他:任务id
}).

%% 获取npc状态
-record(req_get_guide_state, {
	guide_step_id = 0  %%  新手步数信息
}).

%% 获取npc状态
-record(rep_get_guide_state, {
	result = 0  %%  结果: 1 已经做过了该新手,0 还未做过该新手
}).

%% 宠物更新
-record(rep_pet_update, {
	pet_list = []  %%  场景宠物信息
}).

%% 世界boss副本信息
-record(rep_dragon_instance_info, {
	type = 0 ,  %%  1副本面板信息 2奖励面板信息
	player_rank = 0,  %%  玩家自己排名
	player_harm = 0,  %%  玩家自己造成伤害
	rank_list = []  %%  排名信息
}).

%% 胜者为王副本信息
-record(rep_szww_instance_info, {
	total_time = 0,  %%  活动总时间
	time = 0,  %%  剩余时间(秒)
	the_number = 0  %%  人数
}).

%% 胜者为王奖励通知
-record(rep_szww_reward, {
	rank = 0  %%  自己排名
}).

%% 快速场景传送
-record(req_quick_change_scene, {
	scene_id = 0  %%  场景id
}).

%% 获取世界boss免费传送次数
-record(req_get_free_transfer_num, {
}).

%% 获取世界boss免费传送次数
-record(rep_get_free_transfer_num, {
	num = 0   %%  可传送次数
}).

%% boss传送，11049
-record(req_get_free_transfer, {
	scene_id = 0  %%  场景id
}).

%% boss传送
-record(rep_get_free_transfer, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取单人副本列表
-record(req_get_fb_list, {
}).

%% 获取副本列表
-record(rep_get_fb_list, {
	fb_list = []  %%  副本列表
}).

%% 购买副本次数
-record(req_buy_fb_num, {
	scene_id = 0  %%  场景id
}).

%% 购买副本次数返回
-record(rep_buy_fb_num, {
	result = 0  %%  0成功，不是0查看错误码
}).

%% 购买副本次数返回
-record(rep_ref_fb_info, {
	fb_info = #proto_fb_info{}  %%  0成功，不是0查看错误码
}).

%% 地图信息加载完成发送玩家信息
-record(req_load_map_over, {
}).

%% 获取当前场景的线路信息
-record(req_get_line_list, {
}).

%% 获取当前场景的线路信息
-record(rep_get_line_list, {
	now_line = 0,  %%  当前所在线路
	line_info_list = []  %%  线路id列表
}).

%% 跳转到指定的线路
-record(req_change_scene_line, {
	line = 0  %%  跳转到的线路
}).

%% 获取玩家的仇人列表
-record(req_get_foe_list, {
}).

%% 获取玩家的仇人列表
-record(rep_get_foe_list, {
	player_id_list = []  %%  仇人列表
}).

%% 获取玩家的仇人列表
-record(rep_ref_foe_info, {
	del_player_id = 0,  %%  删除仇人id 为0表示不删除
	add_player_id = 0  %%  添加仇人id 为0表示不添加
}).

%% 怪物攻城副本信息
-record(rep_attack_city_instance_info, {
	type = 0 ,  %%  1副本面板信息 2奖励面板信息胜利 3奖励面板信息失败
	round = 0 ,  %%  怪物波数
	box = 0,  %%  剩余宝箱个数
	time = 0,  %%  下一波还剩的秒数
	player_rank = 0,  %%  玩家自己排名
	player_score = 0,  %%  玩家自己积分
	boss_hp = 0,  %%  龙柱总血量
	boss_cur_hp = 0,  %%  龙柱当前血量
	rank_list = []  %%  排名信息
}).

%% 场景采集
-record(req_collection, {
	id = 0  %%  目标对象唯一标识
}).

%% 拾取掉落
-record(rep_collection, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 离开boss信息界面
-record(req_world_boss_out, {
}).

%% 个人boss成果
-record(req_single_boss_result, {
}).

%% 个人boss成果
-record(rep_single_boss_result, {
	left_time = 0,  %%  剩余时间
	left_boss = 0   %%  剩余boss
}).

%% boss掉落
-record(req_monster_boss_drop, {
}).

%% boss掉落
-record(rep_monster_boss_drop, {
	drop_list = []  %%  boss掉落记录
}).

%% 返回跨服boss相关副本信息
-record(req_cross_boss_result, {
}).

%% 返回跨服boss相关副本信息
-record(rep_cross_boss_result, {
	left_time = 0  %%  剩余时间
}).

%% boss刷新时间和关注
-record(req_boss_time_and_follow, {
	type = 0   %%  1世界boss,2boss之家
}).

%% boss刷新时间和关注
-record(rep_boss_time_and_follow, {
	type = 0 ,  %%  1世界boss,2boss之家
	boss_list = []  %%  列表
}).

%% boss刷新推送
-record(rep_boss_refresh_notice, {
	scene_id = 0,  %%  场景id
	monster_id = 0  %%  怪物id
}).

%% 城市boss最后击杀者
-record(req_city_boss_last_killers, {
}).

%% 城市boss最后击杀者
-record(rep_city_boss_last_killers, {
	killer_list = []  %%  列表
}).

%% 留在副本场景中
-record(req_scene_stay, {
}).

%% 怪物预警
-record(rep_monster_warning, {
	warning_id = 0  %%  预警id
}).

%% 获取同场景的玩家外观信息
-record(req_guise_list, {
	top = 0  %%  材质上限
}).

%% 获取同场景的玩家外观信息
-record(rep_guise_list, {
	weapon_list = [],  %%  武器外观list
	clothes_list = [],  %%  衣服外观list
	wing_list = [],  %%  翅膀外观list
	monster_list = []  %%  怪物外观list
}).

%% 火龙神殿杀怪数量
-record(req_dragon_kill_num, {
}).

%% 火龙神殿杀怪数量
-record(rep_dragon_kill_num, {
	kill_num = 0  %%  数量
}).

%% 获取世界地图
-record(req_word_map_list, {
}).

%% 获取世界地图
-record(rep_word_map_list, {
	map_info_list = []  %%  场景列表
}).

%% 王城乱斗敌我关系变化时间预告
-record(rep_instance_king_round_time_left, {
	time_left = 0  %%  敌我关系变化剩余时间
}).

%% 王城乱斗排行信息
-record(rep_instance_king_info, {
	player_rank = 0,  %%  玩家自己排名
	player_score = 0,  %%  玩家自己的积分
	rank_list = []  %%  排名信息
}).

%% 王城乱斗战报信息
-record(rep_instance_king_result, {
	player_rank = 0,  %%  玩家自己排名
	player_score = 0,  %%  玩家自己的积分
	rank_list = []  %%  排名信息
}).

%% 更新采集状态
-record(req_update_collection_state, {
	state = 0   %%  0不采集 1采集中
}).

%% 获取变异地宫信息
-record(req_palace_boss_result, {
}).

%% 获取变异地宫boss击杀数量
-record(rep_palace_boss_result, {
	left_time = [],  %%  剩余时间
	kill_boss = []  %%  击杀boss数量
}).

%% 场景背景图片加载信息
-record(req_scene_pic, {
	scene_pic = <<"">>  %%  场景背景图片信息 0是默认用场景本身的图片，不为0调用对应图片信息
}).

%% 幻境之城玩家通关信息 
-record(req_hjzc_pass, {
	room_pass = 0   %%  当前房间状态  0 该场景还未通关，1，该场景已经通关
}).

%% 获取幻境之城的排名信息
-record(req_get_hjzc_rank_list, {
}).

%% 获取幻境之城的排名信息
-record(rep_get_hjzc_rank_list, {
	rank_list = []  %%  排名列表
}).

%% 获取玩家幻境之城的点亮信息
-record(req_get_hjzc_plyaer_info, {
}).

%% 获取玩家幻境之城的点亮信息
-record(rep_get_hjzc_plyaer_info, {
	room_num = 0 ,  %%  当前房间编号
	pass_room_num_list = []  %%  玩家已经通关的房间编号
}).

%% 幻境之城传送戒指传送
-record(req_hjzc_send_change, {
	room_num = 0   %%  传送房间号
}).

%% 幻境之城传送戒指传送
-record(rep_hjzc_send_change, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取当前学习的技能列表
-record(req_skill_list, {
}).

%% 获取当前学习的技能列表
-record(rep_skill_list, {
	result = 0,  %%  结果: 0 成功, 非零失败
	skill_list = []  %%  技能信息
}).

%% 开始释放技能
-record(req_start_use_skill, {
	direction = 0 ,  %%  朝向
	skill_id = 0,  %%  技能模板id
	target_type = 0 ,  %%  目标类型: 1 对象, 2 地面坐标
	target_flag = #proto_obj_flag{},  %%  目标对象唯一标识
	target_point = #proto_point{}  %%  目标坐标
}).

%% 开始释放技能
-record(rep_start_use_skill, {
	result = 0,  %%  结果: 0 成功, 非零失败
	caster_flag = #proto_obj_flag{},  %%  施法者唯一标识
	caster_point = #proto_point{},  %%  施法者坐标
	direction = 0 ,  %%  朝向
	skill_id = 0,  %%  技能模板id
	skill_lv = 0,  %%  技能等级
	target_type = 0 ,  %%  目标类型: 1 对象, 2 地面坐标
	target_flag = #proto_obj_flag{},  %%  目标对象唯一标识
	target_point = #proto_point{}  %%  目标坐标
}).

%% 推送技能信息变更
-record(rep_skill_info, {
	skill_info = #proto_skill{}  %%  技能信息
}).

%% 升级与学习技能
-record(req_upgrade_skill, {
	skill_id = 0,  %%  技能id
	lv = 0   %%  学习或升级到的等级
}).

%% 升级与学习技能
-record(rep_upgrade_skill, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 技能设置快捷键
-record(req_set_pos, {
	skill_id = 0,  %%  技能id
	pos = 0   %%  设置快捷键的位置
}).

%% 技能设置快捷键
-record(rep_set_pos, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 清空快捷键
-record(req_clear_pos, {
	skill_id = 0  %%  技能id
}).

%% 清空快捷键
-record(rep_clear_pos, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 激活自动技能
-record(req_active_auto_skill, {
	skill_id = 0,  %%  技能id
	switch = 0   %%  0关闭 1激活
}).

%% 激活自动技能
-record(rep_active_auto_skill, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 设置与获取群体技能开关
-record(req_set_group_switch, {
	type = 0   %%  0关 1开  其他获取开关
}).

%% 设置与获取群体技能开关
-record(rep_set_group_switch, {
	type = 0   %%  当前设置状态0关 1开
}).

%% 增加技能熟练度
-record(req_add_skill_exp, {
	skill_id = 0,  %%  技能id
	goods_id = 0,  %%  道具id
	num = 0  %%  数量
}).

%% 增加技能熟练度
-record(rep_add_skill_exp, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 触发技能效果
-record(req_trigger_skill, {
}).

%% 触发非伤害型技能效果
-record(rep_trigger_skill, {
	target_list = [],  %%  目标列表
	buff_list = [],  %%  buff列表
	move_list = [],  %%  移动列表
	knockback_list = []  %%  击退列表
}).

%% 直接切换挂机场景(不等待回合结束)
-record(req_change_hook_scene, {
	scene_id = 0  %%  场景id
}).

%% 直接切换挂机场景(不等待回合结束)
-record(rep_change_hook_scene, {
	result = 0,  %%  结果: 0 成功, 非零失败
	scene_id = 0  %%  场景id
}).

%% 获取场景刷怪信息
-record(req_get_hook_monster, {
}).

%% 获取场景刷怪信息
-record(rep_get_hook_monster, {
	monster_type = 0 ,  %%  刷怪类型: 1 小怪, 2 boss
	monster_list = []  %%  挂机怪物信息
}).

%% 挂机释放技能
-record(req_hook_use_skill, {
	caster_flag = #proto_obj_flag{},  %%  施法者唯一标识
	skill_id = 0,  %%  技能模板id
	target_point = #proto_point{},  %%  目标坐标
	target_list = []  %%  受击者列表
}).

%% 挂机释放技能
-record(rep_hook_use_skill, {
	harm_list = [],  %%  伤害列表
	cure_list = [],  %%  治疗列表
	buff_list = []  %%  buff列表
}).

%% 回合结果
-record(rep_round_result, {
	status = 0 ,  %%  回合结果: 0 战斗失败, 1 战斗胜利, 2 等待
	next_time = 0   %%  下回合开始倒计时(单位秒)
}).

%% 产生掉落
-record(rep_drop, {
	obj_flag = #proto_obj_flag{},  %%  死亡怪物id
	drop_list = []  %%  掉落列表
}).

%% 获取boss可用挑战次数
-record(req_challenge_num, {
}).

%% 获取boss可用挑战次数
-record(rep_challenge_num, {
	challenge_num = 0 ,  %%  可挑战次数
	need_jade = 0  %%  购买次数需要元宝
}).

%% 挑战boss
-record(req_challenge_boos, {
	scene_id = 0  %%  场景id
}).

%% 挑战boss
-record(rep_challenge_boos, {
	result = 0,  %%  结果: 0 成功, 非零失败
	scene_id = 0  %%  场景id
}).

%% 切换挂机场景(等待回合结束)
-record(req_change_hook_scene1, {
	scene_id = 0  %%  场景id
}).

%% 切换挂机场景(等待回合结束)
-record(rep_change_hook_scene1, {
	result = 0,  %%  结果: 0 成功, 非零失败
	scene_id = 0  %%  场景id
}).

%% 获取离线报告
-record(req_offline_report, {
}).

%% 获取离线报告
-record(rep_offline_report, {
	hook_report = #proto_hook_report{}  %%  挂机报告
}).

%% 快速挂机
-record(req_quick_hook, {
	times = 0   %%  次数
}).

%% 快速挂机
-record(rep_quick_hook, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 购买boss挑战次数
-record(req_buy_challenge, {
}).

%% 购买boss挑战次数
-record(rep_buy_challenge, {
	result = 0,  %%  结果: 0 成功, 非零失败
	challenge_num = 0 ,  %%  可挑战次数
	need_jade = 0  %%  购买次数需要元宝
}).

%% 获取挂机统计
-record(req_hook_statistics, {
}).

%% 获取挂机统计
-record(rep_hook_statistics, {
	hour_kill_num = 0,  %%  每小时杀怪数量
	hour_coin_gain = 0,  %%  每小时金币收益
	hour_exp_gain = 0,  %%  每小时经验收益
	drop_rate = 0   %%  物品掉落概率
}).

%% 获取当前挂机数据
-record(req_cur_power, {
}).

%% 获取当前挂机数据
-record(rep_cur_power, {
	need_jade = 0,  %%  购买次数需要元宝
	buy_num = 0 ,  %%  已经购买次数
	all_buy_num = 0 ,  %%  总购买次数
	remain_times = 0 ,  %%  剩余挑战次数
	hook_info = #proto_hook_report{}  %%  挂机信息
}).

%% 购买挂机次数
-record(req_buy_power, {
}).

%% 购买挂机次数
-record(rep_buy_power, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取挂机星级列表
-record(req_hook_star_list, {
}).

%% 获取挂机星级列表
-record(rep_hook_star_list, {
	hook_star_list = [],  %%  挂机星级列表
	hook_star_reward_list = []  %%  挂机星级奖励列表
}).

%% 更新挂机星级
-record(rep_update_hook_star, {
	hook_star = #proto_hook_star{}  %%  挂机星级
}).

%% 挑战boss结果
-record(rep_challenge_boos_result, {
	status = 0 ,  %%  回合结果: 0 战斗失败, 1 战斗胜利
	scene_id = 0  %%  场景id
}).

%% 添加挂机场景对象
-record(rep_add_hook_obj, {
	hook_obj_list = []  %%  挂机对象列表
}).

%% 添加挂机火墙
-record(rep_add_hook_fire_wall, {
	hook_fire_wall_list = []  %%  挂机火墙列表
}).

%% 火墙攻击
-record(req_hook_fire_wall_attack, {
	fire_wall_attack_list = []  %%  挂机火墙攻击列表
}).

%% buff变更
-record(rep_hook_buff_operate, {
	buff_list = []  %%  buff列表
}).

%% 领取挂机星级奖励
-record(req_draw_star_reward, {
	chapter = 0,  %%  章节
	step = 0   %%  阶段
}).

%% 领取挂机星级奖励
-record(rep_draw_star_reward, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 更新挂机星级奖励
-record(rep_update_star_reward, {
	hook_star_reward = #proto_hook_star_reward{}  %%  挂机星级奖励
}).

%% 领取首通奖励
-record(req_draw_first_reward, {
	scene_id = 0  %%  场景id
}).

%% 领取首通奖励
-record(rep_draw_first_reward, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 领取挂机奖励
-record(req_receive_hook_draw, {
}).

%% 领取挂机奖励
-record(rep_receive_hook_draw, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 请求道具信息列表
-record(req_goods_list, {
}).

%% 道具信息列表
-record(rep_goods_list, {
	goods_list = []  %%  道具信息列表
}).

%% 道具信息变更广播
-record(rep_broadcast_goods_info, {
	goods_list = []  %%  道具信息列表
}).

%% 添加道具
-record(req_add_goods, {
	goods_id = 0,  %%  道具id
	is_bind = 0 ,  %%  是否绑定 0非绑 1绑定
	num = 0  %%  数量
}).

%% 添加道具
-record(rep_add_goods, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 根据装备品质批量出售装备
-record(req_batch_sell_equips, {
	quality = 0   %%  装备品质
}).

%% 根据装备品质批量出售装备
-record(rep_batch_sell_equips, {
	goods_list = [],  %%  道具id列表
	get_coin = 0,  %%  获得金币数
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 根据唯一id批量出售道具
-record(req_sell_goods_list_by_id, {
	goods_list = []  %%  道具id列表
}).

%% 根据唯一id批量出售道具
-record(rep_sell_goods_list_by_id, {
	goods_list = [],  %%  道具id列表
	get_coin = 0,  %%  获得金币数
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 出售指定数量的道具
-record(req_sell_goods_by_num, {
	id = 0,  %%  道具唯一id
	num = 0  %%  数量
}).

%% 出售指定数量的道具
-record(rep_sell_goods_by_num, {
	get_coin = 0,  %%  获得金币数
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 使用道具
-record(req_use_goods, {
	goods_id = 0,  %%  道具id
	num = 0  %%  使用数量
}).

%% 使用道具
-record(rep_use_goods, {
	result = 0  %%  结果: 0成功,1道具不能使用,2道具不足
}).

%% 扩展背包
-record(req_expand_bag, {
}).

%% 扩展背包
-record(rep_expand_bag, {
	result = 0  %%  结果: 0成功,非0见错误码
}).

%% 礼包奖励
-record(req_bag_reward, {
	goods_id = 0  %%  道具id
}).

%% 礼包奖励
-record(rep_bag_reward, {
	goods_list = []  %%  道具列表
}).

%% 获取血包参数
-record(req_get_blood_bag, {
}).

%% 获取血包参数
-record(rep_get_blood_bag, {
	value = 0  %%  参数
}).

%% 推送变更的道具列表
-record(rep_goods_change, {
	goods_id = 0,  %%  消耗道具id
	num = 0,  %%  消耗数量
	type = 0 ,  %%  0默认 3膜拜 4功勋任务 5每日任务 6交易所购买扣除 7交易所获得
	goods_list = []  %%  获得道具列表 1体力 2行会声望
}).

%% 请求装备信息列表
-record(req_equips_list, {
}).

%% 装备信息列表
-record(rep_equips_list, {
	equips_list = []  %%  装备信息列表
}).

%% 装备信息变更广播
-record(rep_broadcast_equips_info, {
	equips_list = []  %%  装备信息列表
}).

%% 装备更换
-record(req_change_equips, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	grid = 0  %%  装备穿戴的格子
}).

%% 装备更换
-record(rep_change_equips, {
	result = 0  %%  结果: 0成功1装备不存在2等级不足3穿戴位置不正确4职业不符
}).

%% 装备拆卸
-record(req_get_off_equips, {
	grid = 0  %%  装备穿戴的格子
}).

%% 装备拆卸
-record(rep_get_off_equips, {
	result = 0  %%  结果: 0成功,1装备不存在
}).

%% 装备强化
-record(req_equips_upgrade, {
	id = 0,  %%  装备唯一id
	goods_list = []  %%  强化辅助道具列表
}).

%% 装备强化
-record(rep_equips_upgrade, {
	result = 0  %%  结果: 0成功1装备不存在2金币不足3道具不足
}).

%% 装备熔炼
-record(req_equips_smelt, {
	id_list = []  %%  装备唯一id列表
}).

%% 装备熔炼
-record(rep_equips_smelt, {
	result = 0,  %%  结果: 0 成功, 非零失败
	smelt = 0,  %%  得到的熔炼值
	goods_id_list = []  %%  熔炼得到的装备列表
}).

%% 装备洗练
-record(req_equips_baptize, {
	id = 0  %%  装备唯一id列表
}).

%% 装备洗练
-record(rep_equips_baptize, {
	result = 0,  %%  结果: 0成功1金币不足2道具不足3该装备不能洗练4装备不存在
	attr_list = []  %%  洗练后得到的属性列表
}).

%% 装备洗练保存
-record(req_equips_baptize_save, {
	id = 0  %%  装备唯一id列表
}).

%% 装备洗练保存
-record(rep_equips_baptize_save, {
	result = 0  %%  结果: 0成功1失败
}).

%% 请求锻造的装备信息
-record(req_equips_forge_info, {
}).

%% 请求锻造的装备信息回复
-record(rep_equips_forge_id, {
	goods_id = 0,  %%  锻造道具id
	star = 0 ,  %%  道具神器星级
	forge_num = 0,  %%  今日免费刷新次数
	smelt = 0  %%  锻造需要消耗的熔炼值
}).

%% 请求锻造装备
-record(req_equips_forge, {
}).

%% 请求锻造的装备
-record(rep_equips_forge, {
	result = 0  %%  结果:0成功1熔炼值不足2背包不足
}).

%% 请求刷新锻造信息
-record(req_update_forge_info, {
	type = 0   %%  刷新类型1次数刷新 2元宝刷新
}).

%% 请求刷新锻造信息
-record(rep_update_forge_info, {
	result = 0  %%  结果:0成功1刷新次数不足
}).

%% 道具合成
-record(req_goods_fusion, {
	formula_id = 0  %%  配方id
}).

%% 道具合成
-record(rep_goods_fusion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 神器吞噬
-record(req_art_devour, {
	id = 0,  %%  神器道具唯一id
	devour_list = []  %%  吞噬的道具id列表
}).

%% 神器吞噬
-record(rep_art_devour, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 神器传承
-record(req_art_inherit, {
	idA = 0,  %%  传承的道具唯一id
	idB = 0  %%  被传承的道具唯一id
}).

%% 神器传承
-record(rep_art_inherit, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 勋章升级
-record(req_medal_upgrade, {
	id = 0  %%  勋章升级id
}).

%% 勋章升级
-record(rep_medal_upgrade, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 道具合成扩展
-record(req_goods_fusion_plus, {
	formula_id = 0,  %%  配方id
	num = 0  %%  合成数量
}).

%% 道具合成扩展
-record(rep_goods_fusion_plus, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 分解装备
-record(req_decompose_equips, {
	id = 0  %%  道具唯一id
}).

%% 分解装备
-record(rep_decompose_equips, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 分解选中的装备
-record(req_decompose_equips_by_list, {
	goods_list = []  %%  道具唯一id列表
}).

%% 分解选中的装备
-record(rep_decompose_equips_by_list, {
	goods_list = [],  %%  道具唯一id列表
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 分解选中品质的装备
-record(req_decompose_equips_by_quality, {
	quality_list = []  %%  品质列表
}).

%% 分解选中品质的装备
-record(rep_decompose_equips_by_quality, {
	goods_list = [],  %%  道具唯一id列表
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 请求仓库道具信息列表
-record(req_store_list, {
}).

%% 仓库道具信息列表
-record(rep_store_list, {
	store_cell = 0 ,  %%  仓库格子数
	goods_list = []  %%  道具信息列表
}).

%% 仓库道具信息变更广播
-record(rep_broadcast_store_goods_info, {
	goods_info = #proto_goods_full_info{}  %%  变更的道具信息
}).

%% 道具存入仓库
-record(req_bag_to_store, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	num = 0  %%  道具数量
}).

%% 道具存入仓库
-record(rep_bag_to_store, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 仓库取出道具
-record(req_store_to_bag, {
	id = 0,  %%  道具唯一id
	goods_id = 0,  %%  道具id
	num = 0  %%  道具数量
}).

%% 仓库取出道具
-record(rep_store_to_bag, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 翅膀升级
-record(req_wing_upgrade, {
	id = 0,  %%  勋章升级id
	type = 0   %%  是否用元宝补足0不用 1用
}).

%% 翅膀升级
-record(rep_wing_upgrade, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 强化转移
-record(req_strengthen_change, {
	idA = 0,  %%  继承道具id
	idB = 0  %%  被继承道具id
}).

%% 强化转移
-record(rep_strengthen_change, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 装备铸魂
-record(req_soul_equips, {
	id = 0  %%  继承道具id
}).

%% 装备铸魂
-record(rep_soul_equips, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 装备洗练锁定
-record(req_equips_baptize_lock, {
	id = 0,  %%  装备唯一id
	baptize_id = 0 ,  %%  锁定条数id
	state = 0   %%  0解锁 1锁定
}).

%% 装备洗练锁定
-record(rep_equips_baptize_lock, {
	result = 0  %%  结果: 0成功1金币不足2道具不足3该装备不能洗练4装备不存在
}).

%% 装备投保
-record(req_equips_secure, {
	id = 0,  %%  装备唯一id
	count = 0   %%  投保次数
}).

%% 装备投保
-record(rep_equips_secure, {
	result = 0  %%  结果: 0成功1金币不足2道具不足3该装备不能洗练4装备不存在
}).

%% 铸魂回收
-record(req_soul_change, {
	id = 0  %%  道具id
}).

%% 铸魂回收
-record(rep_soul_change, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 洗练转移
-record(req_baptiz_change, {
	idA = 0,  %%  继承道具id
	idB = 0  %%  被继承道具id
}).

%% 洗练转移
-record(rep_baptiz_change, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 挖藏宝图
-record(req_goods_map, {
	id = 0  %%  道具唯一id
}).

%% 挖藏宝图
-record(rep_goods_map, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 翅膀到期推送
-record(rep_goods_expire, {
	result = 0  %%  0翅膀到期
}).

%% 坐骑升级
-record(req_mounts_upgrade, {
	id = 0  %%  坐骑升级id
}).

%% 坐骑升级
-record(rep_mounts_upgrade, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 坐骑装备升级
-record(req_mounts_mark_upgrade, {
	mark_type = 0,  %%  装备印记类型
	type = 0   %%  0道具不足不使用元宝代替 1道具不足使用元宝代替
}).

%% 坐骑装备升级
-record(rep_mounts_mark_upgrade, {
	result = 0,  %%  结果:0成功 非0请见错误码
	mark_type = 0,  %%  装备印记类型
	bless = 0  %%  最新的祝福值
}).

%% 获取坐骑装备祝福值
-record(req_get_mounts_mark_bless, {
	mark_type = 0  %%  装备印记类型
}).

%% 获取坐骑装备祝福值
-record(rep_get_mounts_mark_bless, {
	bless = 0,  %%  祝福值
	mark_type = 0  %%  装备印记类型
}).

%% 申请邮件列表
-record(req_mail_list, {
}).

%% 邮件信息列表
-record(rep_mail_list, {
	mail_list = []  %%  邮件信息列表
}).

%% 新邮件推送广播
-record(rep_broadcast_mail_info, {
	mail_info = #proto_mail_info{}  %%  新邮件信息
}).

%% 领取邮件奖励
-record(req_open_mail, {
	id = 0  %%  邮件唯一id
}).

%% 领取邮件奖励
-record(rep_open_mail, {
	id = 0,  %%  邮件唯一id
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 删除邮件
-record(req_remove_mail, {
	id = 0  %%  邮件唯一id
}).

%% 删除邮件
-record(rep_remove_mail, {
	id = 0,  %%  邮件唯一id
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 购买商品
-record(req_buy_shop, {
	id = 0,  %%  商品id
	num = 0  %%  商品数量
}).

%% 购买商品
-record(rep_buy_shop, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取云游商人商品列表
-record(req_get_wander_shop_list, {
}).

%% 获取云游商人商品列表
-record(rep_get_wander_shop_list, {
	shop_list = []  %%  商品信息
}).

%% 商品数量限制
-record(req_buy_limit, {
	id = 0  %%  商品id
}).

%% 商品数量限制
-record(rep_buy_limit, {
	use_num = 0,  %%  已经使用限额
	limit_num = 0  %%  限额
}).

%% 一生一次性礼包
-record(req_shop_once_list, {
	lv = 0  %%  级别
}).

%% 一生一次性礼包
-record(rep_shop_once_list, {
	state_list = [],  %%  状态列表,不存在可标识为过期
	expire_time = 0  %%  剩余时间(秒)
}).

%% 一生一次性礼包
-record(req_shop_once_buy, {
	lv = 0,  %%  级别
	pos = 0   %%  位置(1-3)
}).

%% 一生一次性礼包
-record(rep_shop_once_buy, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取神秘商人物品列表
-record(req_get_mystery_shop_list, {
}).

%% 获取神秘商人物品列表
-record(rep_get_mystery_shop_list, {
	is_open = 0 ,  %%  是否开启 1，开启，0关闭
	mystery_shop_list = [],  %%  神秘商人物品列表
	count = 0,  %%  剩余购买次数
	ref_time = 0,  %%  剩余刷新时间（秒）
	need_jade = 0  %%  刷新神秘商店需要的元宝
}).

%% 购买神秘商人物品
-record(req_buy_mystery_shop, {
	mystery_shop_id = 0  %%  商品id
}).

%% 购买神秘商人物品
-record(rep_buy_mystery_shop, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 元宝刷新神秘商人列表
-record(req_ref_mystery_shop_list, {
}).

%% 元宝刷新神秘商人列表
-record(rep_ref_mystery_shop_list, {
	mystery_shop_list = [],  %%  神秘商人物品列表
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 创建帮派
-record(req_create_guild, {
	guild_name = <<"">>,  %%  名字
	is_jade = 0   %%  是否是使用元宝创建 1是0不是
}).

%% 创建帮派
-record(rep_create_guild, {
	result = 0,  %%  结果:0成功 非0请见错误码
	need_jade = 0  %%  需要的元宝数量
}).

%% 获取入帮条件
-record(req_enter_guild_cond, {
	guild_id = 0  %%  帮派id
}).

%% 获取入帮条件
-record(rep_enter_guild_cond, {
	fight = 0,  %%  所需战斗力
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 设置入帮条件
-record(req_set_guild_cond, {
	fight = 0  %%  所需战斗力
}).

%% 设置入帮条件
-record(rep_set_guild_cond, {
	fight = 0,  %%  所需战斗力
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取所有帮派总数
-record(req_get_guild_num, {
}).

%% 获取所有帮派总数
-record(rep_get_guild_num, {
	guild_num = 0  %%  帮派数
}).

%% 获取帮派列表
-record(req_get_guild_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取帮派列表
-record(rep_get_guild_list, {
	guild_info = []  %%  帮派信息
}).

%% 申请加入帮派
-record(req_apply_enter_guild, {
	guild_id = 0  %%  帮派id
}).

%% 申请加入帮派
-record(rep_apply_enter_guild, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取申请帮派人数
-record(req_apply_guild_num, {
}).

%% 获取申请帮派人数
-record(rep_apply_guild_num, {
	num = 0  %%  人数
}).

%% 获取申请列表
-record(req_apply_guild_info, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取申请列表
-record(rep_apply_guild_info, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0,  %%  所需列表最大数
	apply_guild_info = []  %%  申请信息
}).

%% 同意玩家加入帮派
-record(req_agree_join_guild, {
	player_id = 0,  %%  玩家id
	type = 0   %%  1同意 2拒绝
}).

%% 同意玩家加入帮派
-record(rep_agree_join_guild, {
	player_id = 0,  %%  玩家id
	type = 0 ,  %%  1同意 2拒绝
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取帮派详细信息
-record(req_guild_detailed_info, {
}).

%% 获取帮派详细信息
-record(rep_guild_detailed_info, {
	guild_detailed_info = #proto_guild_detailed_info{}  %%  帮派详细 信息
}).

%% 获取玩家帮派信息
-record(req_get_guild_member_info, {
}).

%% 获取玩家帮派信息
-record(rep_get_guild_member_info, {
	player_guild_info = #proto_player_guild_info{}  %%  玩家帮派信息
}).

%% 获取帮派成员信息列表
-record(req_guild_member_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取帮派成员信息列表
-record(rep_guild_member_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0,  %%  所需列表最大数
	guild_member_info_list = []  %%  帮派成员信息
}).

%% 退出帮派
-record(req_leave_guild, {
}).

%% 退出帮派
-record(rep_leave_guild, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 解除帮派
-record(req_remove_guild, {
}).

%% 解除帮派
-record(rep_remove_guild, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取帮派人数
-record(req_get_guild_member_num, {
}).

%% 获取帮派人数
-record(rep_get_guild_member_num, {
	num = 0  %%  帮派成员人数
}).

%% 修改帮会公告
-record(req_write_announce, {
	content = <<"">>  %%  内容
}).

%% 修改帮会公告
-record(rep_write_announce, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取帮派成员详细信息
-record(req_get_member_info, {
	player_id = 0  %%  玩家id
}).

%% 获取帮派成员详细信息
-record(rep_get_member_info, {
	player_id = 0,  %%  玩家唯一id
	name = <<"">>,  %%  玩家名
	lv = 0,  %%  玩家等级
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	fight = 0,  %%  战斗力
	equips_list = [],  %%  装备信息列表
	guise = #proto_guise{},  %%  外观属性
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 剔除成员
-record(req_reject_member, {
	player_id = 0  %%  玩家唯一id
}).

%% 剔除成员
-record(rep_reject_member, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 委任职位
-record(req_appoint_member, {
	player_id = 0,  %%  玩家唯一id
	position = 0   %%  职位
}).

%% 委任职位
-record(rep_appoint_member, {
	player_id = 0,  %%  玩家唯一id
	position = 0 ,  %%  职位
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 清空申请列表
-record(req_clear_apply_list, {
}).

%% 清空申请列表
-record(rep_clear_apply_list, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 行会捐献
-record(req_guild_donation, {
	type = 0   %%  捐献类型
}).

%% 行会捐献
-record(rep_guild_donation, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 行会商店兑换
-record(req_guild_shop, {
	shop_id = 0,  %%  商品id
	num = 0  %%  购买数量
}).

%% 行会商店兑换
-record(rep_guild_shop, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取捐献信息
-record(req_guild_donation_info, {
}).

%% 获取捐献信息
-record(rep_guild_donation_info, {
	donation_info = []  %%  捐献信息
}).

%% 行会日志信息
-record(req_guild_log_info, {
}).

%% 行会日志信息
-record(rep_guild_log_info, {
	guild_log_info = []  %%  日志信息
}).

%% 邀请加入行会
-record(req_guild_ask, {
	tplayer_id = 0  %%  玩家唯一id
}).

%% 邀请加入行会返回
-record(rep_guild_ask, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 推送的玩家行会邀请信息
-record(rep_guild_ask_player_info, {
	guild_name = <<"">>,  %%  行会名称
	guild_id = <<"">>,  %%  行会id
	tname = <<"">>  %%  邀请玩家的名称
}).

%% 同意会长得邀请
-record(req_guild_agree_ask, {
	guild_id = 0  %%  行会id
}).

%% 同意会长得邀请返回
-record(rep_guild_agree_ask, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 进入行会秘境
-record(req_enter_guild_fam, {
}).

%% 进入行会秘境
-record(rep_enter_guild_fam, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 开启沙巴克秘境
-record(req_open_sbk_fam, {
}).

%% 开启沙巴克秘境
-record(rep_open_sbk_fam, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 进入沙巴克秘境
-record(req_enter_sbk_fam, {
}).

%% 进入沙巴克秘境
-record(rep_enter_sbk_fam, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 挑战公会boss
-record(req_challenge_guild_active, {
	id = 0   %%  活动id
}).

%% 挑战公会boss
-record(rep_challenge_guild_active, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取行会秘境信息
-record(req_guild_fam_info, {
}).

%% 获取行会秘境信息
-record(rep_guild_fam_info, {
	num = 0 ,  %%  层数
	lv = 0 ,  %%  进入等级
	open_time = 0,  %%  开始时间戳
	close_time = 0  %%  关闭时间戳
}).

%% 获取沙巴克秘境信息
-record(req_sbk_fam_info, {
}).

%% 获取沙巴克秘境信息
-record(rep_sbk_fam_info, {
	sbk_name = <<"">>,  %%  归属公会名字
	lv = 0 ,  %%  限制等级
	state = 0,  %%  开启状态
	timestamp = 0  %%  还剩多少秒关闭
}).

%% 获取公会红包信息
-record(req_get_guild_red_list, {
}).

%% 获取公会红包信息
-record(rep_get_guild_red_list, {
	red_list = [],  %%  红包列表
	red_log_list = []  %%  红包日志列表
}).

%% 获取下一页的红包信息
-record(req_get_guild_red_info_page, {
	last_red_id = 0  %%  红包id
}).

%% 获取下一页的红包信息
-record(rep_get_guild_red_info_page, {
	red_list = []  %%  红包列表
}).

%% 获取下一页的红包日志信息
-record(req_get_guild_red_log_page, {
	last_id = 0  %%  日志id
}).

%% 获取下一页的红包日志信息
-record(rep_get_guild_red_log_page, {
	red_log_list = []  %%  红包日志列表
}).

%% 新的行会红包
-record(rep_send_guild_red_info, {
	red_info = #proto_guild_red_info{}  %%  新加的红包信息
}).

%% 新的红包日志
-record(rep_send_guild_red_log, {
	red_log = #proto_guild_red_log{}  %%  新的红包日志
}).

%% 有行会红包
-record(rep_send_guild_red, {
}).

%% 退出公会红包ui
-record(req_goout_guild_red_ui, {
}).

%% 领取公会红包
-record(req_receive_red_guild, {
	red_id = 0  %%  公会红包
}).

%% 获取下一页的红包信息
-record(rep_receive_red_guild, {
	result = 0,  %%  0,表示领取成功，不为0表示错误码
	red_id = 0,  %%  公会红包id
	jade = 0  %%  总元宝数
}).

%% 发送公会红包
-record(req_send_red_guild, {
	jade = 0,  %%  总元宝数
	num = 0,  %%  发送数量
	type = 0 ,  %%  红包类型 1 手气红包,2 定额红包
	des = <<"">>  %%  说明
}).

%% 获取下一页的红包信息
-record(rep_send_red_guild, {
	result = 0  %%  0,表示发送成功，不为0表示错误码
}).

%% 发起行会挑战
-record(req_guild_challenge_apply, {
	guild_id_b = 0  %%  被挑战方帮派id
}).

%% 发起行会挑战
-record(rep_guild_challenge_apply, {
	result = 0,  %%  0,表示成功，不为0表示错误码
	guild_name_b = <<"">>  %%  被挑战方帮派名称
}).

%% 收到行会挑战请求
-record(rep_guild_challenge_invite, {
	guild_id_a = 0,  %%  发起方帮派id
	guild_name_a = <<"">>  %%  发起方帮派名称
}).

%% 同意行会挑战
-record(req_guild_challenge_answer, {
	guild_id_a = 0,  %%  发起方对方帮派id
	type = 0   %%  同意或拒绝,0拒绝，1同意
}).

%% 同意行会挑战
-record(rep_guild_challenge_answer, {
	result = 0  %%  0,表示成功，不为0表示错误码
}).

%% 推送行会挑战成绩
-record(rep_guild_challenge_result, {
	guild_id_a = 0,  %%  发起方帮派id
	guild_name_a = <<"">>,  %%  发起方帮派名称
	guild_id_b = 0,  %%  被挑战方帮派id
	guild_name_b = <<"">>,  %%  被挑战方帮派名称
	kill_a = 0,  %%  发起方击杀人数
	kill_b = 0,  %%  被挑战方击杀人数
	time_left = 0  %%  剩余时间,当为0时表示结束
}).

%% 行会宣战信息
-record(req_guild_challenge_info, {
}).

%% 行会宣战信息
-record(rep_guild_challenge_info, {
	guild_id_a = 0,  %%  发起方帮派id
	guild_name_a = <<"">>,  %%  发起方帮派名称
	guild_id_b = 0,  %%  被挑战方帮派id
	guild_name_b = <<"">>  %%  被挑战方帮派名称
}).

%% 发起结盟
-record(req_guild_alliance_apply, {
	server_id_b = 0,  %%  接收方区服id
	guild_id_b = 0,  %%  接收方帮派id
	player_id_b = 0  %%  接收方的玩家id
}).

%% 发起结盟
-record(rep_guild_alliance_apply, {
	result = 0  %%  0,表示成功，不为0表示错误码
}).

%% 收到行会结盟请求
-record(rep_guild_alliance_invite, {
	server_id_a = 0,  %%  发起方区服id
	guild_id_a = 0,  %%  发起方帮派id
	guild_name_a = <<"">>,  %%  发起方帮派名称
	player_id_a = 0,  %%  发起的玩家id
	player_name_a = <<"">>  %%  发起的玩家姓名
}).

%% 同意行会结盟
-record(req_guild_alliance_answer, {
	server_id_a = 0,  %%  发起方区服id
	guild_id_a = 0,  %%  发起方对方帮派id
	player_id_a = 0,  %%  发起的玩家id
	type = 0   %%  同意或拒绝,0拒绝，1同意
}).

%% 同意行会挑战
-record(rep_guild_alliance_answer, {
	result = 0,  %%  0,表示成功，不为0表示错误码
	type = 0   %%  同意或拒绝,0拒绝，1同意
}).

%% 反馈给发起方结盟请求
-record(rep_guild_alliance_result, {
	server_id_b = 0,  %%  接收方区服id
	guild_id_b = 0,  %%  接收方帮派id
	guild_name_b = <<"">>,  %%  接收方帮派名称
	player_id_b = 0,  %%  接收方玩家id
	player_name_b = <<"">>  %%  接收方玩家姓名
}).

%% 退出行会结盟
-record(req_guild_alliance_exit, {
}).

%% 退出行会挑战
-record(rep_guild_alliance_exit, {
	result = 0  %%  0,表示成功，不为0表示错误码
}).

%% 踢出行会结盟
-record(req_guild_alliance_kick, {
	server_id_b = 0,  %%  接收方区服id
	guild_id_b = 0  %%  接收方帮派id
}).

%% 踢出行会挑战
-record(rep_guild_alliance_kick, {
	result = 0  %%  0,表示成功，不为0表示错误码
}).

%% 收到踢出行会结盟
-record(rep_guild_alliance_out, {
	guild_id = 0,  %%  被踢帮派id
	guild_name = <<"">>,  %%  被踢帮派名称
	player_name = <<"">>  %%  踢人的玩家名
}).

%% 推送结盟状态
-record(rep_guild_alliance_state_push, {
	list = []  %%  结盟帮派列表
}).

%% 结盟信息
-record(req_guild_alliance_info, {
}).

%% 结盟信息
-record(rep_guild_alliance_info, {
	list = []  %%  结盟帮派列表
}).

%% 跨服帮会信息
-record(req_guild_alliance_guild, {
	guild_id = 0  %%  帮会id
}).

%% 跨服帮会信息
-record(rep_guild_alliance_guild, {
	result = 0,  %%  0,表示成功，不为0表示错误码，跨服状态才能调用
	guild_info = #proto_guild_standard_info{}  %%  帮会信息
}).

%% 世界聊天
-record(req_world_chat, {
	content = <<"">>  %%  内容
}).

%% 世界聊天
-record(rep_world_chat, {
	chat_info = #proto_world_chat_info{}  %%  世界聊天信息
}).

%% 私聊
-record(req_friend_chat, {
	player_id = 0,  %%  私聊的玩家id
	player_name = <<"">>,  %%  私聊玩家姓名
	content = <<"">>  %%  内容
}).

%% 私聊
-record(rep_friend_chat, {
	chat_info = #proto_world_chat_info{}  %%  私聊
}).

%% 公会聊天
-record(req_guild_chat, {
	content = <<"">>  %%  内容
}).

%% 公会聊天
-record(rep_guild_chat, {
	chat_info = #proto_world_chat_info{}  %%  公会聊天
}).

%% 队伍聊天
-record(req_team_chat, {
	content = <<"">>  %%  内容
}).

%% 队伍liaot
-record(rep_team_chat, {
	chat_info = #proto_world_chat_info{}  %%  队伍liaot
}).

%% 聊天结果通知
-record(rep_friend_chat_result, {
	result = 0  %%  错误码
}).

%% 获取容联md5和时间字符串
-record(req_md5_and_timestamp, {
}).

%% 获取容联md5和时间字符串
-record(rep_md5_and_timestamp, {
	md5 = <<"">>,  %%  账号md5
	timestamp = <<"">>  %%  时间戳字符串
}).

%% 获取世界聊天列表
-record(req_get_chat_word_list, {
}).

%% 获取世界聊天列表
-record(rep_get_chat_word_list, {
	chat_info_list = [],  %%  世界聊天信息列表
	chat_player_list = [],  %%  玩家聊天列表
	chat_guild_list = [],  %%  公会聊天列表
	chat_legion_list = []  %%  军团聊天列表
}).

%% 同屏动态聊天信息
-record(req_screen_chat, {
	content = <<"">>  %%  内容
}).

%% 同屏动态聊天信息
-record(rep_screen_chat, {
	obj_flag = #proto_obj_flag{},  %%  对象唯一标识
	content = <<"">>  %%  内容
}).

%% 军团聊天
-record(req_legion_chat, {
	content = <<"">>  %%  内容
}).

%% 军团聊天
-record(rep_legion_chat, {
	chat_info = #proto_world_chat_info{}  %%  军团聊天内容
}).

%% 获取任务列表
-record(req_task_list, {
	player_id = 0  %%  角色id
}).

%% 获取玩家的任务信息
-record(rep_task_list, {
	player_tasklist = [],  %%  玩家任务列表
	player_reward_list = []  %%  已结领取的奖励信息
}).

%% 领取任务奖励
-record(req_task_reward, {
	player_id = 0,  %%  角色id
	active = 0  %%  领取奖励的活跃值
}).

%% 领取任务奖励
-record(rep_task_reward, {
	result = 0  %%  领取奖励信息 成功返回
}).

%% 发起交易邀请A->B
-record(req_apply_trade, {
	player_id = 0  %%  玩家b
}).

%% 发起交易邀请A->B
-record(rep_apply_trade, {
	result = 0,  %%  错误码
	player_name = 0,  %%  玩家B姓名
	player_lv = 0   %%  玩家B等级
}).

%% 玩家B收到交易邀请
-record(rep_trade_invite, {
	player_id = 0,  %%  玩家A
	player_name = <<"">>,  %%  玩家A姓名
	player_lv = 0   %%  玩家A等级
}).

%% 玩家B反馈交易请求
-record(req_trade_feedback, {
	player_id = 0,  %%  玩家A
	player_name = <<"">>,  %%  玩家A姓名
	player_lv = 0 ,  %%  玩家A等级
	type = 0   %%  0拒绝1同意
}).

%% 玩家B反馈交易请求
-record(rep_trade_feedback, {
	result = 0,  %%  错误码
	player_name = 0,  %%  玩家A姓名
	player_lv = 0   %%  玩家A等级
}).

%% 取消交易
-record(req_clean_trade, {
}).

%% 取消交易
-record(rep_clean_trade, {
	result = 0  %%  错误码
}).

%% 变更交易数据
-record(req_trade_info, {
	jade = 0,  %%  元宝
	trade_list = []  %%  道具信息列表
}).

%% 变更交易数据
-record(rep_trade_info, {
	result = 0  %%  错误码
}).

%% 玩家b变更交易数据
-record(rep_b_trade_info, {
	jade = 0,  %%  元宝
	goods_list = []  %%  道具信息列表
}).

%% 确认交易
-record(req_confirm_trade, {
}).

%% 确认交易
-record(rep_confirm_trade, {
	result = 0  %%  错误码
}).

%% 通知对方交易异常取消
-record(rep_fail_trade, {
	result = 0  %%  错误码
}).

%% 交易成功
-record(rep_success_trade, {
	result = 0  %%  错误码
}).

%% 创建队伍
-record(req_create_team, {
}).

%% 创建队伍
-record(rep_create_team, {
	result = 0  %%  错误码
}).

%% 获取自身队伍信息
-record(req_team_info, {
}).

%% 获取自身队伍信息
-record(rep_team_info, {
	switch1 = 0 ,  %%  组队开关1 0不勾选 1勾选
	switch2 = 0 ,  %%  组队开关2 0不勾选 1勾选
	member_list = []  %%  队伍信息列表
}).

%% 开启关闭队伍开关
-record(req_team_switch, {
	switch_type = 0 ,  %%  开关类型1 2
	status = 0   %%  0不勾选 1勾选
}).

%% 开启关闭队伍开关
-record(rep_team_switch, {
	switch_type = 0 ,  %%  开关类型1 2
	status = 0   %%  0不勾选 1勾选
}).

%% 队伍相关通知
-record(rep_team_notice, {
	value = <<"">>,  %%  参数
	type = 0   %%  通知类型1玩家加入队伍 2玩家离队 3队伍解散 4队长变更
}).

%% 邀请玩家入队
-record(req_invite_join_team, {
	player_id = 0  %%  玩家id
}).

%% 邀请玩家入队
-record(rep_invite_join_team, {
	result = 0  %%  错误码
}).

%% 广播邀请
-record(rep_broadcast_invite, {
	team_id = 0,  %%  队伍id
	player_name = <<"">>,  %%  邀请人姓名
	player_id = <<"">>  %%  邀请人id
}).

%% 是否同意加入
-record(req_agree_join_team, {
	team_id = 0,  %%  队伍id
	type = 0 ,  %%  0拒绝 1同意
	player_id = 0  %%  玩家id
}).

%% 是否同意加入
-record(rep_agree_join_team, {
	result = 0  %%  错误码
}).

%% 玩家申请加入队伍
-record(req_apply_join_team, {
	team_id = 0  %%  队伍id
}).

%% 玩家申请加入队伍
-record(rep_apply_join_team, {
	result = 0  %%  错误码
}).

%% 广播申请给队长
-record(rep_broadcast_apply, {
	player_id = 0,  %%  玩家id
	player_name = <<"">>  %%  玩家姓名
}).

%% 队长同意申请
-record(req_agree_apply_team, {
	player_id = 0,  %%  玩家id
	type = 0   %%  0拒绝 1同意
}).

%% 队长同意申请
-record(rep_agree_apply_team, {
	result = 0  %%  错误码
}).

%% 获取附近玩家信息
-record(req_near_by_player, {
}).

%% 获取附近玩家信息
-record(rep_near_by_player, {
	info_list = []  %%  队伍玩家信息
}).

%% 获取附近队伍信息
-record(req_near_by_team, {
}).

%% 获取附近队伍信息
-record(rep_near_by_team, {
	info_list = []  %%  队伍信息列表
}).

%% 转移队长
-record(req_change_team, {
	player_id = 0  %%  玩家id
}).

%% 转移队长
-record(rep_change_team, {
	result = 0  %%  错误码
}).

%% 剔出队伍
-record(req_remove_team, {
	player_id = 0  %%  玩家id
}).

%% 剔出队伍
-record(rep_remove_team, {
	result = 0  %%  错误码
}).

%% 解散队伍
-record(req_clear_team, {
}).

%% 解散队伍
-record(rep_clear_team, {
	result = 0  %%  错误码
}).

%% 离开队伍
-record(req_leave_team, {
}).

%% 离开队伍
-record(rep_leave_team, {
	result = 0  %%  错误码
}).

%% 队伍信息更新
-record(rep_update_team_info, {
	member_list = []  %%  队伍信息列表
}).

%% 传送会长
-record(req_transfer_hz, {
}).

%% 传送会长
-record(rep_transfer_hz, {
	result = 0  %%  错误码
}).

%% 设置玩家自动加血的百分比
-record(req_set_hpmp, {
	hp_set = #proto_hp_set{},  %%  血量回复百分比
	hpmp_set = #proto_hpmp_set{}  %%  瞬间回复百分比
}).

%% 设置玩家的自动拾取，自动卖出
-record(req_set_pickup_sell, {
	pickup_set = #proto_pickup_set{}  %%  拾取设置
}).

%% 使用激活码
-record(req_use_code, {
	code = <<"">>  %%  激活码
}).

%% 使用激活码
-record(rep_use_code, {
	result = 0  %%  0成功 ，错误码
}).

%% 设置玩家挂机自动卖出
-record(req_set_equip_sell, {
	equip_sell_set = #proto_equip_sell_set{}  %%  自动卖出
}).

%% boss刷新关注列表
-record(req_monster_follow, {
}).

%% boss刷新关注列表
-record(rep_monster_follow, {
	follows = []  %%  关注列表
}).

%% boss刷新关注
-record(req_monster_follow_action, {
	scene_id = 0,  %%  场景id
	monster_id = 0,  %%  怪物id
	action = 0   %%  动作，0取消关注1关注
}).

%% boss刷新关注
-record(rep_monster_follow_action, {
	result = 0  %%  结果: 0 成功, 非零失败
}).

%% 获取竞技场排名
-record(req_get_arena_rank, {
}).

%% 获取竞技场排名
-record(rep_get_arena_rank, {
	rank = 0  %%  排名
}).

%% 获取挑战次数
-record(req_get_arena_count, {
}).

%% 获取挑战次数
-record(rep_get_arena_count, {
	count = 0   %%  挑战次数
}).

%% 获取竞技场挑战列表
-record(req_arena_challenge_list, {
}).

%% 获取竞技场挑战列表
-record(rep_arena_challenge_list, {
	list = []  %%  挑战玩家信息
}).

%% 获取竞技场排行列表
-record(req_arena_rank_list, {
}).

%% 获取竞技场排行列表
-record(rep_arena_rank_list, {
	list = []  %%  排名信息
}).

%% 获取竞技场挑战记录列表
-record(req_arena_record_list, {
}).

%% 获取竞技场挑战记录列表
-record(rep_arena_record_list, {
	list = []  %%  挑战记录
}).

%% 竞技场商店兑换
-record(req_arena_shop, {
	id = 0  %%  商品id
}).

%% 获取竞技场挑战记录列表
-record(rep_arena_shop, {
	result = 0  %%  错误码
}).

%% 获取竞技场声望
-record(req_get_arena_reputation, {
}).

%% 获取竞技场声望
-record(rep_get_arena_reputation, {
	reputation = 0  %%  声望
}).

%% 发起挑战
-record(req_challenge_arena, {
	player_id = 0  %%  挑战玩家id
}).

%% 发起挑战反回
-record(rep_challenge_arena, {
	result = 0  %%  错误码
}).

%% 刷新匹配列表
-record(req_refuse_match_list, {
}).

%% 刷新匹配列表
-record(rep_refuse_match_list, {
	result = 0  %%  错误码
}).

%% 清空竞技场记录
-record(req_clear_arena_record, {
}).

%% 清空竞技场记录
-record(rep_clear_arena_record, {
	result = 0  %%  错误码
}).

%% 挑战结果广播
-record(rep_arena_result, {
	result = 0,  %%  结果 0成功 1失败
	goods_list = [],  %%  道具列表
	rank = 0  %%  胜利后排名
}).

%% 声望发生变化
-record(rep_change_reputation, {
	reputation = 0  %%  声望
}).

%% 获取玩家的关系信息
-record(req_relationship_list, {
	type = 0   %%  1,标示好友，3，标示黑名单，4标示仇人
}).

%% 获取玩家的关系信息
-record(rep_relationship_list, {
	type = 0 ,  %%  1,标示好友，3，标示黑名单，4标示仇人
	relationship_list = []  %%  好友信息
}).

%% 移除列表元素操作信息
-record(req_relationship_operate, {
	type = 0 ,  %%  1,标示好友，3，标示黑名单，4标示仇人
	tplayer_id = 0  %%  目标的玩家Id
}).

%% 移除列表元素操作信息返回
-record(rep_relationship_operate, {
	tplayer_id = 0,  %%  目标的玩家Id
	type = 0 ,  %%  1,标示好友，3，标示黑名单，4标示仇人
	result = 0  %%  返回信息
}).

%% 拉黑
-record(req_relationship_black, {
	tplayer_id = 0  %%  目标的玩家Id
}).

%% 拉黑信息返回
-record(rep_relationship_black, {
	tplayer_id = 0,  %%  目标的玩家Id
	result = 0  %%  返回信息
}).

%% 申请成为好友
-record(req_relationship_friend_ask, {
	tplayerId = 0  %%  目标的玩家Id
}).

%% 申请成为好友返回
-record(rep_relationship_friend_ask, {
	result = 0  %%  返回信息
}).

%% 通过玩家id获取玩家的信息
-record(req_relationship_playerinfo_playerid, {
	tplayerId = 0  %%  目标的玩家Id
}).

%% 通过玩家id获取玩家的信息返回
-record(rep_relationship_playerinfo_playerid, {
	name = <<"">>,  %%  名称
	lv = 0,  %%  等级
	career = 0,  %%  职业
	tplayer_id = 0  %%  玩家id
}).

%% 通过玩家名称获取玩家的信息
-record(req_relationship_playerinfo_playername, {
	name = <<"">>  %%  目标的玩家名称
}).

%% 通过玩家名称获取玩家的信息返回
-record(rep_relationship_playerinfo_playername, {
	name = <<"">>,  %%  名称
	lv = 0,  %%  等级
	career = 0,  %%  职业
	tplayer_id = 0  %%  玩家id
}).

%% 刷新好友列表
-record(rep_relationship_ref_friend_list, {
	type = 0 ,  %%  1,标示好友，3，标示黑名单，4标示仇人
	relationship_list = []  %%  好友信息
}).

%% 推送的玩家申请信息
-record(rep_relationship_friend_ask_send, {
	tname = <<"">>,  %%  目标的玩家名称
	tplayer_id = 0  %%  目标玩家Id
}).

%% 同意玩家的申请
-record(req_relationship_friend_ask_isok, {
	tplayer_id = 0  %%  目标玩家Id
}).

%% 通过玩家名称获取玩家的信息返回
-record(rep_relationship_friend_ask_isok, {
	result = 0  %%  返回信息
}).

%% 添加仇人
-record(req_relationship_foe, {
	tplayer_id = 0  %%  目标的玩家Id
}).

%% 添加仇人信息返回
-record(rep_relationship_foe, {
	tplayer_id = 0,  %%  目标的玩家Id
	result = 0  %%  返回信息
}).

%% 获取沙巴克管理信息
-record(req_city_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取玩家的关系信息
-record(rep_city_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0,  %%  所需列表最大数
	member_num = 0,  %%  帮会拥有的成员数量
	city_officer_list = [],  %%  城市沙巴克官员列表信息
	guild_member_list = []  %%  成员信息列表
}).

%% 任命官员
-record(req_city_appoint_officer, {
	officer_id = 0 ,  %%  官员id
	tplayerId = 0  %%  目标的玩家Id
}).

%% 任命官员
-record(rep_city_appoint_officer, {
	result = 0  %%  任命官员返回
}).

%% 解雇官员
-record(req_city_recall_officer, {
	tplayerId = 0  %%  目标的玩家Id
}).

%% 解雇官员
-record(rep_city_recall_officer, {
	result = 0  %%  任命官员返回
}).

%% 获取领取界面的奖励信息
-record(req_city_reward_info, {
}).

%% 获取领取界面的奖励信息
-record(rep_city_reward_info, {
	officer_id = 0,  %%  领取的档次奖励信息 officer_id 官员id
	isday = 0 ,  %%  是否可以领取每日奖励 1，不能领取， 0可以领取
	frist_player_name = <<"">>,  %%  第一次领取的帮派名称
	isfrist = 0 ,  %%  是否可以领取 第一次奖励 1，不能领取， 0可以领取
	title_player_name = <<"">>,  %%  获取称号的帮主名称
	isexery = 0 ,  %%  是否可以领取  每一次攻城奖励 1，不能领取， 0可以领取
	every_player_name = <<"">>  %%  领取每次占领奖励的信息
}).

%% 领取第一次奖励
-record(req_city_receive_frist, {
}).

%% 领取第一次奖励返回
-record(rep_city_receive_frist, {
	result = 0  %%  领取第一奖励返回
}).

%% 领取每日奖励
-record(req_city_receive_day, {
}).

%% 领取每日奖励返回
-record(rep_city_receive_day, {
	result = 0  %%  每日领取奖励返回
}).

%% 获取沙巴克主界面信息
-record(req_city_info, {
}).

%% 获取玩家的关系信息
-record(rep_city_info, {
	city_officer_list = [],  %%  城市沙巴克官员列表信息
	guild_name = <<"">>,  %%  占领帮会名称
	occupy_day = 0,  %%  占领天数
	officer_id = 0,  %%  玩家的官职id信息
	next_open_time = 0  %%  下次开启时间
}).

%% 获取玩家的关系信息
-record(rep_city_ref__info, {
	city_officer_list = []  %%  刷新官员列表信息
}).

%% 领取每一次占领的奖励
-record(req_city_receive_every, {
}).

%% 领取每一次占领的奖励
-record(rep_city_receive_every, {
	result = 0  %%  领取每一次占领的奖励返回
}).

%% 获取导航列表
-record(req_navigate_task_list, {
}).

%% 获取导航列表 主推就全部从新加载
-record(rep_navigate_task_list, {
	navigate_task_list = []  %%  列表信息
}).

%% 接取任务
-record(req_navigate_accept_task, {
	task_id = 0  %%  任务id
}).

%% 接取任务
-record(rep_navigate_accept_task, {
	result = 0,  %%  接取任务返回
	task_id = 0  %%  任务id
}).

%% 完成任务
-record(req_navigate_finish_task, {
	task_id = 0  %%  任务id
}).

%% 完成任务
-record(rep_navigate_finish_task, {
	result = 0,  %%  完成任务返回
	task_id = 0  %%  任务id
}).

%% 刷新导航列表 主推就单独刷新
-record(rep_navigate_ref_task_list, {
	navigate_task_list = []  %%  列表信息
}).

%% 快速完成功勋任务
-record(req_fast_finish_task, {
	task_id = 0  %%  任务id
}).

%% 快速完成功勋任务
-record(rep_fast_finish_task, {
	result = 0,  %%  完成任务返回
	task_id = 0  %%  任务id
}).

%% 记录日常任务信息
-record(rep_record_task, {
	record_task_info = #proto_navigate_task_info{}  %%  日常任务信息
}).

%% 快速完成任务需要元宝
-record(req_get_task_complete_jade, {
	task_type = 0  %%  任务类型
}).

%% 快速完成功勋任务
-record(rep_get_task_complete_jade, {
	result = 0  %%  返回多少元宝
}).

%% 获取各个职业的第一名
-record(req_worship_frist_career_list, {
}).

%% 获取各个职业的第一名
-record(rep_worship_frist_career_list, {
	worship_frist_career_list = []  %%  列表信息
}).

%% 获取玩家的朝拜信息
-record(req_worship_info, {
}).

%% 获取玩家的朝拜信息
-record(rep_worship_info, {
	num = 0,  %%  免费朝拜已经使用的次数
	jade_num = 0  %%  元宝朝拜已经使用的次数
}).

%% 玩家朝拜
-record(req_worship, {
	is_jade = 0   %%  是否元宝朝拜
}).

%% 玩家朝拜
-record(rep_worship, {
	result = 0  %%  完成任务返回
}).

%% 刷新开启功能
-record(rep_ref_function_open_list, {
	function_open_list = []  %%  刷新开启功能
}).

%% 获取活动剩余次数信息
-record(req_get_activity_list, {
}).

%% 获取活动剩余次数信息
-record(rep_get_activity_list, {
	activity_list = []  %%  免费朝拜已经使用的次数
}).

%% 关闭开启功能
-record(rep_ref_function_close_list, {
	function_close_list = []  %%  关闭开启功能
}).

%% 获取新手卡开启状态
-record(req_noob_card_state, {
	channel = <<"">>,  %%  渠道
	cps = <<"">>  %%  子渠道
}).

%% 获取新手卡开启状态
-record(rep_noob_card_state, {
	state = 0   %%  0关闭 1开启
}).

%% 获取vip信息
-record(req_get_vip_state, {
	vip_lv = 0  %%  vip等级
}).

%% 获取vip信息
-record(rep_get_vip_state, {
	result = 0,  %%  vip状态 0可以领取，其他查看错误码
	vip_exp = 0  %%  vip经验
}).

%% 领取vip奖励
-record(req_receive_vip_goods, {
	vip_lv = 0  %%  vip等级
}).

%% 领取vip奖励
-record(rep_receive_vip_goods, {
	result = 0  %%  0成功，不是0查看错误码
}).

%% 清理pk值
-record(req_clear_pk, {
}).

%% 清理pk值
-record(rep_clear_pk, {
	result = 0  %%  0成功，不是0查看错误码
}).

%% 小飞鞋传送
-record(req_flying_shoes, {
	scene_id = 0,  %%  场景id
	x = 0,  %%  场景坐标x
	y = 0,  %%  场景坐标y
	is_equip = 0   %%  1 表示装备，0表示小飞鞋
}).

%% 小飞鞋传送
-record(rep_flying_shoes, {
	result = 0  %%  0成功，不是0查看错误码
}).

%% 添加vip经验
-record(req_add_vip_exp, {
	vip_exp = 0  %%  vip等级
}).

%% 添加vip经验
-record(rep_add_vip_exp, {
	result = 0  %%  0成功，不是0查看错误码
}).

%% 获取玩家vip经验
-record(req_get_vip_exp, {
}).

%% 获取玩家vip经验
-record(rep_get_vip_exp, {
	vip_exp = 0  %%  vip经验
}).

%% 购买充值
-record(req_buy_charge, {
	key = 0,  %%  key id
	order_id = <<"">>  %%  订单id
}).

%% 购买充值
-record(rep_buy_charge, {
	order_id = <<"">>,  %%  订单id
	result = 0,  %%  0成功，不是0查看错误码
	pay_type = 0   %%  支付类型,0默认1支付宝11浩宇
}).

%% 获取购买过的充值列表
-record(req_get_charge_list, {
}).

%% 获取购买过的充值列表
-record(rep_get_charge_list, {
	key_list = []  %%  key列表
}).

%% 月卡信息
-record(req_get_charge_month_info, {
}).

%% 月卡信息
-record(rep_get_charge_month_info, {
	state = 0 ,  %%  1，没有购买月卡，2，可以领取奖励，3，奖励已经领取过了
	over_day = 0  %%  剩余天数
}).

%% 领取月卡奖励
-record(req_receive_charge_month, {
}).

%% 领取月卡奖励
-record(rep_receive_charge_month, {
	result = 0  %%  0成功，大于0 错误码
}).

%% 获取分包状态信息
-record(req_package_list, {
}).

%% 购买充值
-record(rep_package_list, {
	lv_list = []  %%  已经领取了的包等级列表信息
}).

%% 领取分包奖励
-record(req_reward_package_goods, {
	lv = 0  %%  领取奖励的等级
}).

%% 领取分包奖励
-record(rep_reward_package_goods, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 获取活动信息
-record(req_get_active_info, {
}).

%% 获取活动信息
-record(rep_get_active_info, {
	info_list = []  %%  活动基础信息(包括7天与在线)
}).

%% 获取玩家当天登录游戏时长
-record(req_get_login_times, {
}).

%% 获取玩家当天登录游戏时长
-record(rep_get_login_times, {
	times = 0  %%  当天在线时长(秒)
}).

%% 领取活动奖励
-record(req_get_active_reward, {
	key = 0  %%  key id
}).

%% 领取活动奖励
-record(rep_get_active_reward, {
	key = 0,  %%  key id
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 更新满足条件活动状态
-record(rep_update_active_state, {
	info_list = []  %%  满足条件活动列表
}).

%% 获取首充奖励列表
-record(req_get_first_charge_reward, {
}).

%% 获取首充奖励列表
-record(rep_get_first_charge_reward, {
	goods_list = []  %%  道具列表
}).

%% 获取每日签到信息
-record(req_everyday_sign_info, {
}).

%% 获取每日签到信息
-record(rep_everyday_sign_info, {
	is_sign = 0 ,  %%  今日是否签到0未签到 1已签到
	sign_count = 0   %%  本月已签到次数
}).

%% 签到领奖
-record(req_everyday_sign, {
}).

%% 签到领奖
-record(rep_everyday_sign, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 进入活动副本
-record(req_enter_active_instance, {
	active_id = 0  %%  活动id
}).

%% 进入活动副本
-record(rep_enter_active_instance, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 获取等级力排行榜信息
-record(req_get_lv_rank_info, {
	type = 0 ,  %%  0全部 1战士 2法师 3道士
	page = 0   %%  页数
}).

%% 获取等级排行榜信息
-record(rep_get_lv_rank_info, {
	rank = 0,  %%  我的排名
	rank_list = []  %%  等级排行信息
}).

%% 获取战力排行榜信息
-record(req_get_fight_rank_info, {
	type = 0 ,  %%  0全部 1战士 2法师 3道士
	page = 0   %%  页数
}).

%% 获取战力排行榜信息
-record(rep_get_fight_rank_info, {
	rank = 0,  %%  我的排名
	rank_list = []  %%  战力排行信息
}).

%% 获取行会排行榜信息
-record(req_get_guild_rank_info, {
	page = 0   %%  页数
}).

%% 获取行会排行榜信息
-record(rep_get_guild_rank_info, {
	rank = 0,  %%  我的行会排名
	rank_list = []  %%  行会排行信息
}).

%% 获取开服活动相关列表
-record(req_active_service_list, {
	type = 0   %%  开服活动类型
}).

%% 获取开服活动相关列表
-record(rep_active_service_list, {
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	my_value = 0,  %%  自己的值
	active_service_list = []  %%  道具列表
}).

%% 领取开服活动奖励
-record(req_receive_goods, {
	active_service_id = 0  %%  活动id
}).

%% 领取开服活动奖励
-record(rep_receive_goods, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 获取签到日期列表
-record(req_sign_list, {
}).

%% 领取开服活动奖励
-record(rep_sign_list, {
	sign_list = [],  %%  签到日期列表
	reward_list = [],  %%  已领取奖励日期列表
	count = 0   %%  剩余补签次数
}).

%% 玩家签到
-record(req_player_sign, {
}).

%% 玩家签到
-record(rep_player_sign, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 玩家补签
-record(req_player_repair_sign, {
}).

%% 玩家补签
-record(rep_player_repair_sig, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 玩家领取签到奖励
-record(req_player_sign_reward, {
	days = 0   %%  领取奖励的天数
}).

%% 玩家领取签到奖励
-record(rep_player_sign_reward, {
	result = 0  %%  0 领取成，不为0领取失败,错误码
}).

%% 限时活动通知
-record(req_active_time_notice, {
}).

%% 限时活动通知
-record(rep_active_time_notice, {
	start_id = 0 ,  %%  即将开始的活动id
	open_list = []  %%  已经开始的活动id
}).

%% 获取开服活动类型列表
-record(req_get_active_service_type_list, {
}).

%% 获取开服活动类型列表
-record(rep_get_active_service_type_list, {
	type_info_list = []  %%  类型列表
}).

%% 获取运营活动信息列表
-record(req_get_operate_active_info, {
}).

%% 获取运营活动信息列表
-record(rep_get_operate_active_info, {
	list = [],  %%  活动信息列表
	list2 = [],  %%  活动信息列表模版2
	list3 = []  %%  活动信息列表模版3
}).

%% 领取运营活动奖励
-record(req_receive_reward, {
	active_id = 0  %%  活动id
}).

%% 领取运营活动奖励
-record(rep_receive_reward, {
	result = 0  %%  1领取成功按钮不变  2领取成功按钮变灰，不为0领取失败,错误码
}).

%% 开始答题
-record(req_exam_start, {
}).

%% 开始答题
-record(rep_exam_start, {
	result = 0,  %%  错误码，0正常，非0错误
	tools1 = 0 ,  %%  积分双倍道具数量
	tools2 = 0 ,  %%  难度减半道具数量
	tools3 = 0 ,  %%  免答道具数量
	ex_ids = [],  %%  题库列表
	rank = 0,  %%  我的排名
	time_left = 0  %%  剩余时间,当为0时表示结束
}).

%% 答题
-record(req_exam_choice, {
	ex_index = 0,  %%  题库序号(1-30)
	choice = 0   %%  答案,1-4
}).

%% 答题
-record(rep_exam_choice, {
	result = 0,  %%  错误码，0正常，非0错误
	rank = 0,  %%  排名
	is_right = 0 ,  %%  是否正确，1正确，0错误
	total_score = 0,  %%  总分
	right_num = 0 ,  %%  正确数量
	error_num = 0 ,  %%  错误数量
	exp = 0,  %%  获得经验
	coin = 0  %%  获得金币
}).

%% 答题排行
-record(req_exam_rank, {
}).

%% 答题排行
-record(rep_exam_rank, {
	ranks = []  %%  
}).

%% 积分双倍道具
-record(req_exam_tool, {
	ex_index = 0,  %%  题库序号
	type = 0   %%  道具类型1积分双倍,2难度减半,3免答
}).

%% 积分双倍道具
-record(rep_exam_tool, {
	result = 0,  %%  错误码，0正常，非0错误
	type = 0 ,  %%  道具类型
	params = [],  %%  返回参数，难度减半是两个错误的答案
	tools_num = 0   %%  剩余道具数量
}).

%% 触发活动条件
-record(req_activity_trigger, {
	type = 0  %%  活动条件，1下载完整资源
}).

%% 触发活动条件
-record(rep_activity_trigger, {
	result = 0  %%  错误码，0正常完成，非0未完成
}).

%% 获取活动相关排名
-record(req_active_rank, {
	active_id = 0  %%  活动id
}).

%% 获取活动相关排名
-record(rep_active_rank, {
	rank = 0,  %%  个人排名
	score = 0,  %%  个人积分
	rank_list = []  %%  排名列表
}).

%% 获取节日活动信息列表
-record(req_get_operate_holiday_active_info, {
}).

%% 获取节日活动信息列表
-record(rep_get_operate_holiday_active_info, {
	list = []  %%  活动信息列表
}).

%% 功能预告礼包状态
-record(req_function_notice_state, {
}).

%% 功能预告礼包状态
-record(rep_function_notice_state, {
	key = 0  %%  第一个可以领取功能预告礼包id，没有则返回0
}).

%% 功能预告礼包领取
-record(req_function_notice_get, {
	key = 0  %%  功能预告key
}).

%% 功能预告礼包领取
-record(rep_function_notice_get, {
	result = 0  %%  错误码，0正常完成，非0未完成
}).

%% 获取服务器排名活动列表
-record(rep_active_service_rank_list, {
	my_rank = 0,  %%  我的排名
	my_lv = <<"">>,  %%  我的等级
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	rank_list = []  %%  道具列表
}).

%% 获取服务器排名活动列表
-record(rep_active_shop_list, {
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	goods_list = []  %%  道具列表
}).

%% 购买活动活动商品列表物品信息
-record(req_buy_active_shop, {
	id = 0,  %%  活动商品id
	num = 0  %%  购买的数量
}).

%% 获取活动相关排名
-record(rep_buy_active_shop, {
	result = 0,  %%  返回 大于0表示错误吗，等于0表示成功
	active_shop_info = #proto_active_shop{}  %%  刷新商品信息
}).

%% 刷新红点信
-record(req_active_service_red, {
	list_id = 0  %%  分页id
}).

%% 获取节日活动兑换信息列表
-record(req_get_operate_holiday_change_info, {
	active_id = 0  %%  活动id
}).

%% 获取节日活动兑换信息列表
-record(rep_get_operate_holiday_change_info, {
	list = []  %%  活动兑换信息列表
}).

%% 领取运营活动奖励
-record(req_new_receive_reward, {
	active_id = 0,  %%  活动id
	sub_type = 0   %%  子类型
}).

%% 领取运营活动奖励
-record(rep_new_receive_reward, {
	active_id = 0,  %%  活动id
	sub_type = 0 ,  %%  子类型
	result = 0,  %%  结果
	value = 0  %%  参数
}).

%% 根据活动类型获取内容信息
-record(req_get_type_active_info, {
	type = 0  %%  活动类型
}).

%% 获取活动信息
-record(rep_get_type_active_info, {
	info_list = []  %%  活动基础信息(包括7天与在线)
}).

%% 获取拍卖的物品信息-类型
-record(req_get_sale_goodslist, {
	page = 0 ,  %%  第几页
	order = 0 ,  %%  0,表示降序 1,表示升序
	sort1 = 0 ,  %%  标签id1
	sort2 = 0,  %%  标签id2
	sort3 = 0  %%  标签id3
}).

%% 获取拍卖的物品信息-类型
-record(rep_get_sale_goodslist, {
	num = 0,  %%  拥有的物品数量
	sale_goods_list = []  %%  拍卖物品列表
}).

%% 获取拍卖的物品信息-模糊搜索
-record(req_get_sale_goodslist_name, {
	page = 0 ,  %%  第几页
	order = 0 ,  %%  0,表示降序 1,表示升序
	name = <<"">>  %%  查询的名称
}).

%% 获取拍卖的物品信息-模糊搜索
-record(rep_get_sale_goodslist_name, {
	num = 0,  %%  拥有的物品数量
	sale_goods_list = []  %%  拍卖物品列表
}).

%% 获取玩家上架的物品列表
-record(req_get_sale_sell_goodslist, {
}).

%% 获取玩家上架的物品列表
-record(rep_get_sale_sell_goodslist, {
	sale_goods_list = []  %%  上架物品信息
}).

%% 玩家查看领取物品信息
-record(req_get_player_sale_goods_list, {
}).

%% 玩家查看领取物品信息
-record(rep_get_player_sale_goods_list, {
	sale_goods_list = []  %%  领取物品信息
}).

%% 玩家上架物品
-record(req_add_sale, {
	bag_id = 0,  %%  背包id
	goods_id = 0,  %%  物品id
	num = 0,  %%  出售数量
	jade = 0,  %%  出售元宝
	hour = 0  %%  出售小时
}).

%% 玩家上架物品
-record(rep_add_sale, {
	result = 0  %%  0 上架成功，不为0错误码
}).

%% 玩家购买拍卖物品
-record(req_buy_sale, {
	sale_id = 0  %%  购买拍卖id
}).

%% 玩家购买拍卖物品
-record(rep_buy_sale, {
	result = 0  %%  0 购买成功，不为0错误码
}).

%% 物品下架
-record(req_del_sale, {
	sale_id = 0  %%  拍卖id
}).

%% 物品下架
-record(rep_del_sale, {
	result = 0  %%  0 下架成功，不为0错误码
}).

%% 玩家领取物品
-record(req_receive_sale_goods, {
	id = 0  %%  拍卖id 为0表示全部领取，不为0表示单个领取
}).

%% 玩家领取物品
-record(rep_receive_sale_goods, {
	result = 0  %%  0 成功，不为0错误码
}).

%% 获取交易税
-record(req_get_sale_tax, {
	sale_id = 0  %%  拍卖id
}).

%% 获取交易税
-record(rep_get_sale_tax, {
	result = 0  %%  交易税
}).

%% 获取出售需要的金币
-record(req_get_sale_sell, {
	hour = 0  %%  拍卖需要时间
}).

%% 获取出售需要的金币
-record(rep_get_sale_sell, {
	result = 0  %%  出售需要金币
}).

%% 获取出售需要的金币
-record(req_get_receive_sale_goods_coin, {
	id = 0  %%  拍卖id 为0表示全部领取，不为0表示单个领取
}).

%% 获取出售需要的金币
-record(rep_get_receive_sale_goods_coin, {
	result = 0  %%  需要的金币
}).

%% 领取开服红包信息
-record(req_receive_red, {
	red_id = 0  %%  红包id
}).

%% 领取开服红包信息
-record(rep_receive_red, {
	result = 0  %%  0领取成功，不为0，错误码
}).

%% 开服红包可以领取的状态推送
-record(rep_send_red_info, {
	red_id = 0  %%  红包id
}).

%% 获取抽奖日志 last_id大于0表示翻页，默认为0
-record(req_get_lottery_info, {
	last_id = 0  %%   最后的日志id
}).

%% 获取抽奖日志
-record(rep_get_lottery_info, {
	log_lists = [],  %%  日志列表
	lottery_goods_list = [],  %%  抽奖id列表
	num1_need_jade = 0,  %%  抽奖1次需要消耗元宝  为0表示活动关闭
	num10_need_jade = 0,  %%  抽奖10次需要消耗元宝 为0表示活动关闭
	begin_time = 0,  %%  开启时间
	end_time = 0  %%  结束时间
}).

%% 开始抽奖
-record(req_lottery_begin, {
	num = 0  %%   抽奖次数
}).

%% 开始抽奖
-record(rep_lottery_begin, {
	lottery_id_list = [],  %%  获取的id列表
	goods_list = [],  %%  获取道具列表
	equip_list = [],  %%  获取的装备类别
	result = 0  %%  抽奖返回 0，成功，大于0 错误码
}).

%% 抽奖日志推送
-record(rep_send_lottery_log_list, {
	log_lists = []  %%  日志列表
}).

%% 离开抽奖
-record(req_logout_lottery, {
}).

%% 获取神皇秘境抽奖日志 last_id大于0表示翻页，默认为0
-record(req_lottery_info_shmj, {
	last_id = 0  %%   最后的日志id
}).

%% 获取神皇秘境抽奖日志
-record(rep_lottery_info_shmj, {
	all_log_lists = [],  %%  全服日志列表
	my_log_lists = [],  %%  我的日志列表
	group_id = 0,  %%  分组
	lottery_score = 0,  %%  剩余积分
	num1_need_jade = 0,  %%  抽奖1次需要消耗元宝  为0表示活动关闭
	num5_need_jade = 0,  %%  抽奖5次需要消耗元宝  为0表示活动关闭
	num10_need_jade = 0,  %%  抽奖10次需要消耗元宝 为0表示活动关闭
	begin_time = 0,  %%  开启时间
	end_time = 0  %%  结束时间
}).

%% 神皇秘境开始抽奖
-record(req_lottery_begin_shmj, {
	num = 0  %%   抽奖次数
}).

%% 神皇秘境开始抽奖
-record(rep_lottery_begin_shmj, {
	lottery_id_list = [],  %%  获取的id列表
	goods_list = [],  %%  获取道具列表
	equip_list = [],  %%  获取的装备类别
	lottery_score = 0,  %%  剩余积分
	result = 0  %%  抽奖返回 0，成功，大于0 错误码
}).

%% 神皇秘境抽奖积分兑换物品
-record(req_lottery_exchange_shmj, {
	id = 0  %%  物品id
}).

%% 神皇秘境抽奖积分兑换物品
-record(rep_lottery_exchange_shmj, {
	lottery_score = 0,  %%  剩余积分
	result = 0  %%  抽奖返回 0，成功，大于0 错误码
}).

%% 抽奖日志推送
-record(rep_lottery_log_shmj, {
	type = 0 ,  %%  抽奖类型,1神皇秘境
	log_lists = []  %%  日志列表
}).

%% 获取抽奖日志 last_id大于0表示翻页，默认为0
-record(req_get_lottery_coin_log_list, {
	last_id = 0  %%   最后的日志id
}).

%% 获取抽奖日志
-record(rep_get_lottery_coin_log_list, {
	log_lists = []  %%  日志列表
}).

%% 开始抽奖
-record(req_lottery_coin_begin, {
	num = 0  %%   抽奖次数
}).

%% 开始抽奖
-record(rep_lottery_coin_begin, {
	lottery_id_list = [],  %%  获取的id列表
	goods_list = [],  %%  获取道具列表
	equip_list = [],  %%  获取的装备类别
	result = 0  %%  抽奖返回 0，成功，大于0 错误码
}).

%% 抽奖日志推送
-record(rep_send_lottery_coin_log_list, {
	log_lists = []  %%  日志列表
}).

%% 离开抽奖
-record(req_logout_lottery_coin, {
}).

%% 创建军团
-record(req_create_legion, {
	legion_name = <<"">>,  %%  名字
	is_jade = 0   %%  是否是使用元宝创建 1是0不是
}).

%% 创建军团
-record(rep_create_legion, {
	result = 0,  %%  结果:0成功 非0请见错误码
	need_jade = 0  %%  需要的元宝数量
}).

%% 获取入帮条件
-record(req_enter_legion_cond, {
	legion_id = 0  %%  军团id
}).

%% 获取入帮条件
-record(rep_enter_legion_cond, {
	fight = 0,  %%  所需战斗力
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 设置入帮条件
-record(req_set_legion_cond, {
	fight = 0  %%  所需战斗力
}).

%% 设置入帮条件
-record(rep_set_legion_cond, {
	fight = 0,  %%  所需战斗力
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取所有军团总数
-record(req_get_legion_num, {
}).

%% 获取所有军团总数
-record(rep_get_legion_num, {
	legion_num = 0  %%  军团数
}).

%% 获取军团列表
-record(req_get_legion_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取军团列表
-record(rep_get_legion_list, {
	legion_info = []  %%  军团信息
}).

%% 申请加入军团
-record(req_apply_enter_legion, {
	legion_id = 0  %%  军团id
}).

%% 申请加入军团
-record(rep_apply_enter_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取申请军团人数
-record(req_apply_legion_num, {
}).

%% 获取申请军团人数
-record(rep_apply_legion_num, {
	num = 0  %%  人数
}).

%% 获取申请列表
-record(req_apply_legion_info, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取申请列表
-record(rep_apply_legion_info, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0,  %%  所需列表最大数
	apply_legion_info = []  %%  申请信息
}).

%% 同意玩家加入军团
-record(req_agree_join_legion, {
	player_id = 0,  %%  玩家id
	type = 0   %%  1同意 2拒绝
}).

%% 同意玩家加入军团
-record(rep_agree_join_legion, {
	player_id = 0,  %%  玩家id
	type = 0 ,  %%  1同意 2拒绝
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取军团详细信息
-record(req_legion_detailed_info, {
}).

%% 获取军团详细信息
-record(rep_legion_detailed_info, {
	legion_detailed_info = #proto_legion_detailed_info{}  %%  军团详细 信息
}).

%% 获取玩家军团信息
-record(req_get_legion_member_info, {
}).

%% 获取玩家军团信息
-record(rep_get_legion_member_info, {
	player_legion_info = #proto_player_legion_info{}  %%  玩家军团信息
}).

%% 获取军团成员信息列表
-record(req_legion_member_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0  %%  所需列表最大数
}).

%% 获取军团成员信息列表
-record(rep_legion_member_info_list, {
	min_value = 0,  %%  所需列表最小数
	max_value = 0,  %%  所需列表最大数
	legion_member_info_list = []  %%  军团成员信息
}).

%% 退出军团
-record(req_leave_legion, {
}).

%% 退出军团
-record(rep_leave_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 解除军团
-record(req_remove_legion, {
}).

%% 解除军团
-record(rep_remove_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取军团人数
-record(req_get_legion_member_num, {
}).

%% 获取军团人数
-record(rep_get_legion_member_num, {
	num = 0  %%  军团成员人数
}).

%% 修改军团公告
-record(req_write_announce_legion, {
	content = <<"">>  %%  内容
}).

%% 修改帮会公告
-record(rep_write_announce_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取军团成员详细信息
-record(req_get_member_info_legion, {
	player_id = 0  %%  玩家id
}).

%% 获取军团成员详细信息
-record(rep_get_member_info_legion, {
	player_id = 0,  %%  玩家唯一id
	name = <<"">>,  %%  玩家名
	lv = 0,  %%  玩家等级
	sex = 0 ,  %%  性别
	career = 0,  %%  职业
	fight = 0,  %%  战斗力
	equips_list = [],  %%  装备信息列表
	guise = #proto_guise{},  %%  外观属性
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 剔除成员
-record(req_reject_member_legion, {
	player_id = 0  %%  玩家唯一id
}).

%% 剔除成员
-record(rep_reject_member_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 委任职位
-record(req_appoint_member_legion, {
	player_id = 0,  %%  玩家唯一id
	position = 0   %%  职位
}).

%% 委任职位
-record(rep_appoint_member_legion, {
	player_id = 0,  %%  玩家唯一id
	position = 0 ,  %%  职位
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 清空申请列表
-record(req_clear_apply_list_legion, {
}).

%% 清空申请列表
-record(rep_clear_apply_list_legion, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 行会日志信息
-record(req_legion_log_info, {
}).

%% 行会日志信息
-record(rep_legion_log_info, {
	legion_log_info = []  %%  日志信息
}).

%% 邀请加入行会
-record(req_legion_ask, {
	tplayer_id = 0  %%  玩家唯一id
}).

%% 邀请加入行会返回
-record(rep_legion_ask, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 推送的玩家行会邀请信息
-record(rep_legion_ask_player_info, {
	legion_name = <<"">>,  %%  行会名称
	legion_id = <<"">>,  %%  行会id
	tname = <<"">>  %%  邀请玩家的名称
}).

%% 同意会长得邀请
-record(req_legion_agree_ask, {
	legion_id = 0  %%  行会id
}).

%% 同意会长得邀请返回
-record(rep_legion_agree_ask, {
	result = 0  %%  结果:0成功 非0请见错误码
}).

%% 获取开服活动相关列表
-record(req_active_service_merge_list, {
	type = 0   %%  开服活动类型
}).

%% 获取开服活动相关列表
-record(rep_active_service_merge_list, {
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	my_value = 0,  %%  自己的值
	active_service_list = []  %%  道具列表
}).

%% 领取开服活动奖励
-record(req_receive_merge_goods, {
	active_service_id = 0  %%  活动id
}).

%% 领取开服活动奖励
-record(rep_receive_merge_goods, {
	result = 0,  %%  0 领取成，不为0领取失败,错误码
	active_service_id = 0  %%  活动id
}).

%% 获取开服活动类型列表
-record(req_get_active_service_merge_type_list, {
}).

%% 获取开服活动类型列表
-record(rep_get_active_service_merge_type_list, {
	type_info_list = []  %%  类型列表
}).

%% 获取服务器排名活动列表
-record(rep_active_service_merge_rank_list, {
	my_rank = 0,  %%  我的排名
	my_lv = <<"">>,  %%  我的等级
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	rank_list = []  %%  道具列表
}).

%% 商店物品礼包
-record(rep_active_shop_merge_list, {
	begin_time = 0,  %%  活动开启时间
	end_time = 0,  %%  活动结束时间
	goods_list = []  %%  道具列表
}).

%% 购买礼包
-record(req_buy_active_merge_shop, {
	id = 0,  %%  活动商品id
	num = 0  %%  购买的数量
}).

%% 返回刷新礼包信息
-record(rep_buy_active_merge_shop, {
	result = 0,  %%  返回 大于0表示错误吗，等于0表示成功
	active_shop_info = #proto_active_shop{}  %%  刷新商品信息
}).

%% 刷新红点信
-record(req_active_service_merge_red, {
	list_id = 0  %%  分页id
}).

