%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%        自动生成文件，不要手动修改
%%% @end
%%% Created : 2017/03/29
%%%-------------------------------------------------------------------

-module(proto_config).
-include("common.hrl").
-export([
	type/1,
	read/1,
	write/1
]).

%% 用户自定义类型
type(proto_login_info) ->
	[64, string, 8, 16, 16];
type(proto_attr_base) ->
	[32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 16, 16, 32, 32, 32, 32, 8, 8, 8, 8, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 16, 16, 32, 32, 32, 32, 8, 8, 8, 8];
type(proto_guise) ->
	[32, 32, 32, 32, 32, 32];
type(proto_money) ->
	[32, 32, 32, 32, 32, 32, 32, 32, 32];
type(proto_mark) ->
	[16, 16, 16, 16, 16, 16, 16, 16, 16];
type(proto_hp_set) ->
	[8, 8, 32, 8, 32];
type(proto_hpmp_set) ->
	[8, 8, 32];
type(proto_equip_sell_set) ->
	[8, 8, 8, 8, 8];
type(proto_pickup_set) ->
	[8, [8], [8], [8]];
type(proto_player_info) ->
	[64, string, 8, 16, 16, 32, proto_attr_base, proto_guise, proto_money, proto_mark, 16, 16, 32, 32, 64, 64, 8, 16, 8, 8, proto_hp_set, proto_hpmp_set, 16, proto_equip_sell_set, proto_pickup_set, [16], [16], 32, 8, 8, 8, 8, 32, 64];
type(proto_obj_flag) ->
	[8, 64];
type(proto_point) ->
	[16, 16];
type(proto_buff) ->
	[16, 16, 32];
type(proto_spec_buff) ->
	[16, 32, 32];
type(proto_scene_player) ->
	[proto_obj_flag, string, 8, 16, 16, 32, 32, 32, 32, 8, proto_point, proto_point, proto_guise, [proto_buff], 64, string, 64, string, 64, 8, 16, 8, string, 8];
type(proto_scene_player_update) ->
	[proto_obj_flag, 64, string, 64, string, 64, 8, 16, 8, 8];
type(proto_scene_obj_often_update) ->
	[proto_obj_flag, proto_obj_flag, 8, 8, 32, 32, 32, 32, 32, 32];
type(proto_scene_pet_update) ->
	[proto_obj_flag, 64, 64, 64, 8];
type(proto_enmity) ->
	[proto_obj_flag, string, 16, 8, 16];
type(proto_drop_owner) ->
	[proto_obj_flag, string];
type(proto_scene_monster) ->
	[proto_obj_flag, proto_obj_flag, 16, string, 32, 32, 32, 32, 8, proto_point, proto_point, [proto_buff], proto_enmity, 64, 64, 64, 8, proto_drop_owner, string];
type(proto_scene_drop) ->
	[proto_obj_flag, 32, proto_point, 16, 64, 16, 64];
type(proto_fire_wall) ->
	[proto_obj_flag, proto_point];
type(proto_skill) ->
	[32, 8, 32, 8, 8];
type(proto_player_update) ->
	[16, 32];
type(proto_attr_value) ->
	[16, 32];
type(proto_attr_baptize_value) ->
	[8, 8, 16, 32];
type(proto_harm) ->
	[proto_obj_flag, 8, 32, 32, 32];
type(proto_cure) ->
	[proto_obj_flag, 32, 32, 32];
type(proto_buff_operate) ->
	[proto_obj_flag, 8, 16, 16, 32];
type(proto_hook_monster) ->
	[proto_obj_flag, proto_obj_flag, 16, 32, 32, 32, 32, 64, 64, 64, 8];
type(proto_goods_info) ->
	[64, 32, 8, 32, 8, 8, 8, 32, 16, 16, 16];
type(proto_equips_info) ->
	[64, 32, 8, 32, 8, 8, 8, [proto_attr_baptize_value], 8, 8, 32, 8, 32, 32, 32];
type(proto_goods_full_info) ->
	[64, 32, 8, 32, 8, 8, 8, [proto_attr_baptize_value], 8, 8, 8];
type(proto_goods_list) ->
	[32, 8, 32];
type(proto_trade_list) ->
	[64, 32, 32];
type(proto_mail_info) ->
	[64, string, string, [proto_mail_award], 8, 32];
type(proto_mail_award) ->
	[32, 8, 32];
type(proto_guild_info) ->
	[64, 16, string, string, 8, 32, 16];
type(proto_guild_simple_info) ->
	[32, 64, string];
type(proto_guild_standard_info) ->
	[32, 64, string, string, 8, 16];
type(proto_apply_guild_info) ->
	[string, string, 16, 16, 32, 32];
type(proto_guild_detailed_info) ->
	[64, string, string, 8, 16, 16, 32, 32, string];
type(proto_guild_member_info) ->
	[64, string, 8, 16, 16, 32, 32];
type(proto_guild_log_info) ->
	[8, 32, string, 32];
type(proto_player_guild_info) ->
	[64, string, 8, 32, 16];
type(proto_donation_info) ->
	[8, 8];
type(proto_legion_info) ->
	[64, 16, string, string, 8, 32, 16];
type(proto_apply_legion_info) ->
	[string, string, 16, 16, 32, 32];
type(proto_legion_detailed_info) ->
	[64, string, string, 8, 16, 16, 32, 32, string];
type(proto_legion_member_info) ->
	[64, string, 8, 16, 16, 32, 32];
type(proto_legion_log_info) ->
	[8, 32, string, 32];
type(proto_player_legion_info) ->
	[64, string, 8, 32, 16];
type(proto_hook_drop) ->
	[32, 32];
type(proto_goods_report) ->
	[8, 32, 32];
type(proto_hook_report) ->
	[32, 32, 16, 32, 32, [proto_goods_report], [proto_hook_drop]];
type(proto_hook_star) ->
	[16, 8, 8];
type(proto_hook_star_reward) ->
	[16, 8, [8]];
type(proto_hook_fire_wall) ->
	[proto_obj_flag, proto_point, 16, 16];
type(proto_fire_wall_attack) ->
	[64, 64];
type(proto_point_change) ->
	[proto_obj_flag, proto_point, proto_point];
type(proto_taskinfo) ->
	[32, 32, 8];
type(proto_boss_refresh) ->
	[8, 32];
type(proto_team_member_info) ->
	[64, string, 8, 8, 16, string, 32, 8];
type(proto_near_by_player) ->
	[64, string, 8, 16, string];
type(proto_near_by_team) ->
	[64, string, 8, 16, 16, string];
type(proto_map_teammate_flag) ->
	[proto_point];
type(proto_arena_challenge_info) ->
	[64, string, 16, 8, 32, 32];
type(proto_arena_rank_info) ->
	[64, string, 16, 32, 16, string, 32];
type(proto_active_rank_info) ->
	[64, string, 32, 32];
type(proto_active_service_type_info) ->
	[16, 8];
type(proto_arena_record) ->
	[64, 64, string, 16, 32];
type(proto_relationship_info) ->
	[64, string, 8, 16, 32, 8, string];
type(proto_city_officer_info) ->
	[8, 64, string, proto_guise, 8, 16];
type(proto_navigate_task_info) ->
	[32, 8, 32];
type(proto_worship_first_career_info) ->
	[8, 16, string, 32, 64];
type(proto_activity_info) ->
	[16, 16, 16];
type(proto_active_info) ->
	[16, 8];
type(proto_sale_info) ->
	[64, 32, 32, 32, 32, 8, 8, 8, [proto_attr_baptize_value], 8, 8, 8];
type(proto_player_sale_info) ->
	[64, 32, 32, 32, 32, 8, 8, 8, 8, [proto_attr_baptize_value], 8, 8, 8];
type(proto_button_tips) ->
	[16, 16];
type(proto_world_boss_rank) ->
	[16, string, 32];
type(proto_attack_city_rank) ->
	[16, string, 32];
type(proto_wander_shop) ->
	[16, 16];
type(proto_mystery_shop) ->
	[16, 32, 8, 32, 8, 32, 16, 8, string];
type(proto_active_shop) ->
	[16, 32, 8, 32, 32, 32, 8, 32, 32];
type(proto_lv_rank_info) ->
	[64, string, 16, 16, string, 16];
type(proto_fight_rank_info) ->
	[64, string, 16, 32, string, 16];
type(proto_guild_rank_info) ->
	[64, string, 16, 16, string, 16];
type(proto_fb_info) ->
	[16, 16, 16, 16, 16, 16];
type(proto_raids_goods_info) ->
	[32, 8, 32];
type(proto_active_service_info) ->
	[32, 8, 8, string, 32];
type(proto_active_service_rank_info) ->
	[16, string, 64, 32];
type(proto_guild_red_info) ->
	[string, 32, 32, 64, string, 8];
type(proto_guild_red_log) ->
	[64, string, 32];
type(proto_lottery_log_info) ->
	[64, string, 32, 64];
type(proto_lottery_goods_info) ->
	[32, 32, 8, 32];
type(proto_world_chat_info) ->
	[64, string, 8, 32, string, 64, 64, 64];
type(proto_line_info) ->
	[16, 8, 16];
type(proto_operate_active_info) ->
	[16, 8, 8, string, string, [proto_goods_list], 8, string, 8, string, 32, 32, 32];
type(proto_operate_active_info_model_2) ->
	[16, 8, 8, string, string, 32, [proto_model_2], 32, 32, 32, 8];
type(proto_model_2) ->
	[16, string, [proto_goods_list], 32];
type(proto_operate_active_info_model_3) ->
	[16, 8, 8, string, [proto_model_3], 32, 32, 32, 8];
type(proto_model_3) ->
	[16, string, [proto_goods_list], [proto_goods_list], [proto_goods_list], 32];
type(proto_operate_holiday_active_info) ->
	[16, 16, 32, 32];
type(proto_operate_holiday_change_info) ->
	[16, 16, 32];
type(proto_exam_rank_info) ->
	[string, 32, 32];
type(proto_monster_follow) ->
	[32, 32];
type(proto_monster_boss_drop) ->
	[string, 32, 32, [32], 32];
type(proto_boss_time_and_follow) ->
	[32, 32, 32, 8];
type(proto_city_boss_killer) ->
	[32, string];
type(proto_word_map_info) ->
	[32, 16];
type(proto_shop_once_state) ->
	[16, 8, 8];
type(proto_instance_king_rank) ->
	[16, string, 32];
type(proto_instance_king_rank_full) ->
	[16, string, 16, 16, 32];
type(proto_hjzc_rank_info) ->
	[64, 16, string, 32];
type(proto_palace_scene) ->
	[32, 32];
type(proto_palace_boss_num) ->
	[32, 32, 32];
type(Type) ->
	Trace = try throw(42) catch 42 -> erlang:get_stacktrace() end, 
	?ERR("undefined type ~p ~p", [Type,Trace]).

%% 获取按钮提示
read(9000) ->
	{req_get_button_tips, []};
%% 更新按钮提示
read(9001) ->
	{req_update_button_tips, [16, 16]};
%% 获取军团的tips
read(9002) ->
	{req_legion_button_tips, []};
%% 获取角色列表
read(10000) ->
	{req_player_list, [string, 16, 16]};
%% 创建角色
read(10001) ->
	{req_create, [string, 16, string, 8, 16, 16]};
%% 进入游戏
read(10002) ->
	{req_enter, [64, string, 16, 8]};
%% 获取自己属性
read(10003) ->
	{req_player_info, []};
%% 玩家复活
read(10005) ->
	{req_revive, [8]};
%% 心跳包
read(10006) ->
	{req_heart, [32]};
%% 退出
read(10007) ->
	{req_logout, [8]};
%% 修改pk模式
read(10008) ->
	{req_change_pk_mode, [8]};
%% 删除角色
read(10009) ->
	{req_delete_player, [64]};
%% 玩家死亡验证
read(10010) ->
	{req_player_die, [string]};
%% 获取玩家详细信息
read(10011) ->
	{req_get_player_info, [64]};
%% 获取玩家身上效果标识
read(10012) ->
	{req_get_player_buff_flag, []};
%% 改变翅膀外观状态
read(10013) ->
	{req_change_wing_state, [16, 8]};
%% 切换宠物攻击模式
read(10014) ->
	{req_change_pet_att_type, []};
%% 印记升级
read(10015) ->
	{req_upgrade_mark, [8]};
%% 获取自己的扩展属性
read(10016) ->
	{req_player_extra_info, []};
%% 获取跟自己的相关的状态数据
read(10017) ->
	{req_player_extra_push, [[32]]};
%% 获取服务器时间
read(10018) ->
	{req_time_info, []};
%% 机器人进入游戏 进入游戏
read(10099) ->
	{req_enter_robot, [64, string, 16, 8, string]};
%% 切换场景
read(11001) ->
	{req_enter_scene, []};
%% 开始移动
read(11002) ->
	{req_start_move, [8, proto_point, proto_point]};
%% 移动同步
read(11003) ->
	{req_move_sync, [8, proto_point]};
%% 拾取掉落
read(11006) ->
	{req_pickup, [64]};
%% 获取世界boss刷新时间
read(11009) ->
	{req_world_boss_refresh, []};
%% 获取打宝地图boss刷新时间
read(11010) ->
	{req_treasure_refresh, []};
%% 获取副本入口信息
read(11013) ->
	{req_instance_entry_info, [16]};
%% 获取副本场景统计
read(11014) ->
	{req_instance_info, []};
%% 退出副本
read(11016) ->
	{req_exit_instance, []};
%% 获取沙城活动信息
read(11018) ->
	{req_shacheng_info, []};
%% 场景地图标识
read(11019) ->
	{req_scene_map_flag, []};
%% 获取场景内存活的某个怪物坐标点
read(11021) ->
	{req_monster_point, []};
%% 传送阵传送
read(11022) ->
	{req_transfer, [16]};
%% 传送点传送
read(11024) ->
	{req_transport, [16]};
%% 获取npc状态
read(11025) ->
	{req_get_npc_state, [32]};
%% 获取npc状态
read(11026) ->
	{req_get_guide_state, [32]};
%% 快速场景传送
read(11031) ->
	{req_quick_change_scene, [16]};
%% 获取世界boss免费传送次数
read(11032) ->
	{req_get_free_transfer_num, []};
%% boss传送，11049
read(11033) ->
	{req_get_free_transfer, [16]};
%% 获取单人副本列表
read(11034) ->
	{req_get_fb_list, []};
%% 购买副本次数
read(11035) ->
	{req_buy_fb_num, [16]};
%% 地图信息加载完成发送玩家信息
read(11037) ->
	{req_load_map_over, []};
%% 获取当前场景的线路信息
read(11038) ->
	{req_get_line_list, []};
%% 跳转到指定的线路
read(11039) ->
	{req_change_scene_line, [16]};
%% 获取玩家的仇人列表
read(11040) ->
	{req_get_foe_list, []};
%% 场景采集
read(11043) ->
	{req_collection, [64]};
%% 离开boss信息界面
read(11044) ->
	{req_world_boss_out, []};
%% 个人boss成果
read(11045) ->
	{req_single_boss_result, []};
%% boss掉落
read(11046) ->
	{req_monster_boss_drop, []};
%% 返回跨服boss相关副本信息
read(11047) ->
	{req_cross_boss_result, []};
%% boss刷新时间和关注
read(11048) ->
	{req_boss_time_and_follow, [8]};
%% 城市boss最后击杀者
read(11050) ->
	{req_city_boss_last_killers, []};
%% 留在副本场景中
read(11051) ->
	{req_scene_stay, []};
%% 获取同场景的玩家外观信息
read(11053) ->
	{req_guise_list, [16]};
%% 火龙神殿杀怪数量
read(11054) ->
	{req_dragon_kill_num, []};
%% 获取世界地图
read(11055) ->
	{req_word_map_list, []};
%% 更新采集状态
read(11060) ->
	{req_update_collection_state, [8]};
%% 获取变异地宫信息
read(11061) ->
	{req_palace_boss_result, []};
%% 获取幻境之城的排名信息
read(11103) ->
	{req_get_hjzc_rank_list, []};
%% 获取玩家幻境之城的点亮信息
read(11104) ->
	{req_get_hjzc_plyaer_info, []};
%% 幻境之城传送戒指传送
read(11105) ->
	{req_hjzc_send_change, [8]};
%% 获取当前学习的技能列表
read(12001) ->
	{req_skill_list, []};
%% 开始释放技能
read(12002) ->
	{req_start_use_skill, [8, 32, 8, proto_obj_flag, proto_point]};
%% 升级与学习技能
read(12004) ->
	{req_upgrade_skill, [32, 8]};
%% 技能设置快捷键
read(12005) ->
	{req_set_pos, [32, 8]};
%% 清空快捷键
read(12006) ->
	{req_clear_pos, [32]};
%% 激活自动技能
read(12007) ->
	{req_active_auto_skill, [32, 8]};
%% 设置与获取群体技能开关
read(12008) ->
	{req_set_group_switch, [8]};
%% 增加技能熟练度
read(12009) ->
	{req_add_skill_exp, [32, 32, 16]};
%% 触发技能效果
read(12010) ->
	{req_trigger_skill, []};
%% 直接切换挂机场景(不等待回合结束)
read(13001) ->
	{req_change_hook_scene, [16]};
%% 获取场景刷怪信息
read(13002) ->
	{req_get_hook_monster, []};
%% 挂机释放技能
read(13003) ->
	{req_hook_use_skill, [proto_obj_flag, 32, proto_point, [proto_obj_flag]]};
%% 获取boss可用挑战次数
read(13006) ->
	{req_challenge_num, []};
%% 挑战boss
read(13007) ->
	{req_challenge_boos, [16]};
%% 切换挂机场景(等待回合结束)
read(13008) ->
	{req_change_hook_scene1, [16]};
%% 获取离线报告
read(13009) ->
	{req_offline_report, []};
%% 快速挂机
read(13010) ->
	{req_quick_hook, [8]};
%% 购买boss挑战次数
read(13011) ->
	{req_buy_challenge, []};
%% 获取挂机统计
read(13012) ->
	{req_hook_statistics, []};
%% 获取当前挂机数据
read(13013) ->
	{req_cur_power, []};
%% 购买挂机次数
read(13014) ->
	{req_buy_power, []};
%% 获取挂机星级列表
read(13015) ->
	{req_hook_star_list, []};
%% 火墙攻击
read(13020) ->
	{req_hook_fire_wall_attack, [[proto_fire_wall_attack]]};
%% 领取挂机星级奖励
read(13022) ->
	{req_draw_star_reward, [16, 8]};
%% 领取首通奖励
read(13024) ->
	{req_draw_first_reward, [16]};
%% 领取挂机奖励
read(13025) ->
	{req_receive_hook_draw, []};
%% 请求道具信息列表
read(14001) ->
	{req_goods_list, []};
%% 添加道具
read(14003) ->
	{req_add_goods, [32, 8, 32]};
%% 根据装备品质批量出售装备
read(14004) ->
	{req_batch_sell_equips, [8]};
%% 根据唯一id批量出售道具
read(14005) ->
	{req_sell_goods_list_by_id, [[64]]};
%% 出售指定数量的道具
read(14006) ->
	{req_sell_goods_by_num, [64, 32]};
%% 使用道具
read(14007) ->
	{req_use_goods, [32, 16]};
%% 扩展背包
read(14008) ->
	{req_expand_bag, []};
%% 礼包奖励
read(14009) ->
	{req_bag_reward, [32]};
%% 获取血包参数
read(14010) ->
	{req_get_blood_bag, []};
%% 请求装备信息列表
read(14020) ->
	{req_equips_list, []};
%% 装备更换
read(14022) ->
	{req_change_equips, [64, 32, 32]};
%% 装备拆卸
read(14023) ->
	{req_get_off_equips, [32]};
%% 装备强化
read(14024) ->
	{req_equips_upgrade, [64, [32]]};
%% 装备熔炼
read(14025) ->
	{req_equips_smelt, [[64]]};
%% 装备洗练
read(14026) ->
	{req_equips_baptize, [64]};
%% 装备洗练保存
read(14027) ->
	{req_equips_baptize_save, [64]};
%% 请求锻造的装备信息
read(14028) ->
	{req_equips_forge_info, []};
%% 请求锻造装备
read(14029) ->
	{req_equips_forge, []};
%% 请求刷新锻造信息
read(14030) ->
	{req_update_forge_info, [8]};
%% 道具合成
read(14031) ->
	{req_goods_fusion, [16]};
%% 神器吞噬
read(14032) ->
	{req_art_devour, [64, [64]]};
%% 神器传承
read(14033) ->
	{req_art_inherit, [64, 64]};
%% 勋章升级
read(14034) ->
	{req_medal_upgrade, [16]};
%% 道具合成扩展
read(14035) ->
	{req_goods_fusion_plus, [16, 16]};
%% 分解装备
read(14036) ->
	{req_decompose_equips, [64]};
%% 分解选中的装备
read(14037) ->
	{req_decompose_equips_by_list, [[64]]};
%% 分解选中品质的装备
read(14038) ->
	{req_decompose_equips_by_quality, [[8]]};
%% 请求仓库道具信息列表
read(14040) ->
	{req_store_list, []};
%% 道具存入仓库
read(14042) ->
	{req_bag_to_store, [64, 32, 32]};
%% 仓库取出道具
read(14043) ->
	{req_store_to_bag, [64, 32, 32]};
%% 翅膀升级
read(14044) ->
	{req_wing_upgrade, [16, 8]};
%% 强化转移
read(14045) ->
	{req_strengthen_change, [64, 64]};
%% 装备铸魂
read(14046) ->
	{req_soul_equips, [64]};
%% 装备洗练锁定
read(14047) ->
	{req_equips_baptize_lock, [64, 8, 8]};
%% 装备投保
read(14048) ->
	{req_equips_secure, [64, 8]};
%% 铸魂回收
read(14049) ->
	{req_soul_change, [64]};
%% 洗练转移
read(14050) ->
	{req_baptiz_change, [64, 64]};
%% 挖藏宝图
read(14051) ->
	{req_goods_map, [64]};
%% 坐骑升级
read(14053) ->
	{req_mounts_upgrade, [16]};
%% 坐骑装备升级
read(14054) ->
	{req_mounts_mark_upgrade, [16, 8]};
%% 获取坐骑装备祝福值
read(14055) ->
	{req_get_mounts_mark_bless, [16]};
%% 申请邮件列表
read(15001) ->
	{req_mail_list, []};
%% 领取邮件奖励
read(15003) ->
	{req_open_mail, [64]};
%% 删除邮件
read(15004) ->
	{req_remove_mail, [64]};
%% 购买商品
read(16001) ->
	{req_buy_shop, [32, 16]};
%% 获取云游商人商品列表
read(16002) ->
	{req_get_wander_shop_list, []};
%% 商品数量限制
read(16003) ->
	{req_buy_limit, [32]};
%% 一生一次性礼包
read(16004) ->
	{req_shop_once_list, [16]};
%% 一生一次性礼包
read(16005) ->
	{req_shop_once_buy, [16, 8]};
%% 获取神秘商人物品列表
read(16100) ->
	{req_get_mystery_shop_list, []};
%% 购买神秘商人物品
read(16101) ->
	{req_buy_mystery_shop, [32]};
%% 元宝刷新神秘商人列表
read(16102) ->
	{req_ref_mystery_shop_list, []};
%% 创建帮派
read(17001) ->
	{req_create_guild, [string, 8]};
%% 获取入帮条件
read(17002) ->
	{req_enter_guild_cond, [64]};
%% 设置入帮条件
read(17003) ->
	{req_set_guild_cond, [32]};
%% 获取所有帮派总数
read(17004) ->
	{req_get_guild_num, []};
%% 获取帮派列表
read(17005) ->
	{req_get_guild_list, [16, 16]};
%% 申请加入帮派
read(17006) ->
	{req_apply_enter_guild, [64]};
%% 获取申请帮派人数
read(17007) ->
	{req_apply_guild_num, []};
%% 获取申请列表
read(17008) ->
	{req_apply_guild_info, [16, 16]};
%% 同意玩家加入帮派
read(17009) ->
	{req_agree_join_guild, [64, 8]};
%% 获取帮派详细信息
read(17010) ->
	{req_guild_detailed_info, []};
%% 获取玩家帮派信息
read(17011) ->
	{req_get_guild_member_info, []};
%% 获取帮派成员信息列表
read(17012) ->
	{req_guild_member_info_list, [16, 16]};
%% 退出帮派
read(17013) ->
	{req_leave_guild, []};
%% 解除帮派
read(17014) ->
	{req_remove_guild, []};
%% 获取帮派人数
read(17015) ->
	{req_get_guild_member_num, []};
%% 修改帮会公告
read(17016) ->
	{req_write_announce, [string]};
%% 获取帮派成员详细信息
read(17017) ->
	{req_get_member_info, [64]};
%% 剔除成员
read(17018) ->
	{req_reject_member, [64]};
%% 委任职位
read(17019) ->
	{req_appoint_member, [64, 8]};
%% 清空申请列表
read(17020) ->
	{req_clear_apply_list, []};
%% 行会捐献
read(17050) ->
	{req_guild_donation, [8]};
%% 行会商店兑换
read(17051) ->
	{req_guild_shop, [16, 16]};
%% 获取捐献信息
read(17052) ->
	{req_guild_donation_info, []};
%% 行会日志信息
read(17053) ->
	{req_guild_log_info, []};
%% 邀请加入行会
read(17054) ->
	{req_guild_ask, [64]};
%% 同意会长得邀请
read(17056) ->
	{req_guild_agree_ask, [64]};
%% 进入行会秘境
read(17057) ->
	{req_enter_guild_fam, []};
%% 开启沙巴克秘境
read(17058) ->
	{req_open_sbk_fam, []};
%% 进入沙巴克秘境
read(17059) ->
	{req_enter_sbk_fam, []};
%% 挑战公会boss
read(17060) ->
	{req_challenge_guild_active, [8]};
%% 获取行会秘境信息
read(17061) ->
	{req_guild_fam_info, []};
%% 获取沙巴克秘境信息
read(17062) ->
	{req_sbk_fam_info, []};
%% 获取公会红包信息
read(17063) ->
	{req_get_guild_red_list, []};
%% 获取下一页的红包信息
read(17064) ->
	{req_get_guild_red_info_page, [64]};
%% 获取下一页的红包日志信息
read(17065) ->
	{req_get_guild_red_log_page, [64]};
%% 退出公会红包ui
read(17069) ->
	{req_goout_guild_red_ui, []};
%% 领取公会红包
read(17070) ->
	{req_receive_red_guild, [64]};
%% 发送公会红包
read(17071) ->
	{req_send_red_guild, [32, 32, 8, string]};
%% 发起行会挑战
read(17080) ->
	{req_guild_challenge_apply, [64]};
%% 同意行会挑战
read(17082) ->
	{req_guild_challenge_answer, [64, 8]};
%% 行会宣战信息
read(17084) ->
	{req_guild_challenge_info, []};
%% 发起结盟
read(17085) ->
	{req_guild_alliance_apply, [32, 64, 64]};
%% 同意行会结盟
read(17087) ->
	{req_guild_alliance_answer, [32, 64, 64, 8]};
%% 退出行会结盟
read(17089) ->
	{req_guild_alliance_exit, []};
%% 踢出行会结盟
read(17090) ->
	{req_guild_alliance_kick, [32, 64]};
%% 结盟信息
read(17093) ->
	{req_guild_alliance_info, []};
%% 跨服帮会信息
read(17094) ->
	{req_guild_alliance_guild, [64]};
%% 世界聊天
read(18001) ->
	{req_world_chat, [string]};
%% 私聊
read(18002) ->
	{req_friend_chat, [64, string, string]};
%% 公会聊天
read(18003) ->
	{req_guild_chat, [string]};
%% 队伍聊天
read(18006) ->
	{req_team_chat, [string]};
%% 获取容联md5和时间字符串
read(18005) ->
	{req_md5_and_timestamp, []};
%% 获取世界聊天列表
read(18008) ->
	{req_get_chat_word_list, []};
%% 同屏动态聊天信息
read(18009) ->
	{req_screen_chat, [string]};
%% 军团聊天
read(18010) ->
	{req_legion_chat, [string]};
%% 获取任务列表
read(19000) ->
	{req_task_list, [64]};
%% 领取任务奖励
read(19001) ->
	{req_task_reward, [64, 32]};
%% 发起交易邀请A->B
read(20001) ->
	{req_apply_trade, [64]};
%% 玩家B反馈交易请求
read(20003) ->
	{req_trade_feedback, [64, string, 8, 8]};
%% 取消交易
read(20004) ->
	{req_clean_trade, []};
%% 变更交易数据
read(20005) ->
	{req_trade_info, [32, [proto_trade_list]]};
%% 确认交易
read(20007) ->
	{req_confirm_trade, []};
%% 创建队伍
read(21000) ->
	{req_create_team, []};
%% 获取自身队伍信息
read(21001) ->
	{req_team_info, []};
%% 开启关闭队伍开关
read(21002) ->
	{req_team_switch, [8, 8]};
%% 邀请玩家入队
read(21004) ->
	{req_invite_join_team, [64]};
%% 是否同意加入
read(21006) ->
	{req_agree_join_team, [64, 8, 64]};
%% 玩家申请加入队伍
read(21007) ->
	{req_apply_join_team, [64]};
%% 队长同意申请
read(21009) ->
	{req_agree_apply_team, [64, 8]};
%% 获取附近玩家信息
read(21010) ->
	{req_near_by_player, []};
%% 获取附近队伍信息
read(21011) ->
	{req_near_by_team, []};
%% 转移队长
read(21012) ->
	{req_change_team, [64]};
%% 剔出队伍
read(21013) ->
	{req_remove_team, [64]};
%% 解散队伍
read(21014) ->
	{req_clear_team, []};
%% 离开队伍
read(21015) ->
	{req_leave_team, []};
%% 传送会长
read(21017) ->
	{req_transfer_hz, []};
%% 设置玩家自动加血的百分比
read(22000) ->
	{req_set_hpmp, [proto_hp_set, proto_hpmp_set]};
%% 设置玩家的自动拾取，自动卖出
read(22001) ->
	{req_set_pickup_sell, [proto_pickup_set]};
%% 使用激活码
read(22002) ->
	{req_use_code, [string]};
%% 设置玩家挂机自动卖出
read(22003) ->
	{req_set_equip_sell, [proto_equip_sell_set]};
%% boss刷新关注列表
read(22004) ->
	{req_monster_follow, []};
%% boss刷新关注
read(22005) ->
	{req_monster_follow_action, [32, 32, 8]};
%% 获取竞技场排名
read(23001) ->
	{req_get_arena_rank, []};
%% 获取挑战次数
read(23002) ->
	{req_get_arena_count, []};
%% 获取竞技场挑战列表
read(23003) ->
	{req_arena_challenge_list, []};
%% 获取竞技场排行列表
read(23004) ->
	{req_arena_rank_list, []};
%% 获取竞技场挑战记录列表
read(23005) ->
	{req_arena_record_list, []};
%% 竞技场商店兑换
read(23006) ->
	{req_arena_shop, [32]};
%% 获取竞技场声望
read(23007) ->
	{req_get_arena_reputation, []};
%% 发起挑战
read(23008) ->
	{req_challenge_arena, [64]};
%% 刷新匹配列表
read(23009) ->
	{req_refuse_match_list, []};
%% 清空竞技场记录
read(23010) ->
	{req_clear_arena_record, []};
%% 获取玩家的关系信息
read(24000) ->
	{req_relationship_list, [8]};
%% 移除列表元素操作信息
read(24001) ->
	{req_relationship_operate, [8, 64]};
%% 拉黑
read(24002) ->
	{req_relationship_black, [64]};
%% 申请成为好友
read(24003) ->
	{req_relationship_friend_ask, [64]};
%% 通过玩家id获取玩家的信息
read(24004) ->
	{req_relationship_playerinfo_playerid, [64]};
%% 通过玩家名称获取玩家的信息
read(24005) ->
	{req_relationship_playerinfo_playername, [string]};
%% 同意玩家的申请
read(24008) ->
	{req_relationship_friend_ask_isok, [64]};
%% 添加仇人
read(24009) ->
	{req_relationship_foe, [64]};
%% 获取沙巴克管理信息
read(25000) ->
	{req_city_info_list, [16, 16]};
%% 任命官员
read(25001) ->
	{req_city_appoint_officer, [8, 64]};
%% 解雇官员
read(25002) ->
	{req_city_recall_officer, [64]};
%% 获取领取界面的奖励信息
read(25003) ->
	{req_city_reward_info, []};
%% 领取第一次奖励
read(25004) ->
	{req_city_receive_frist, []};
%% 领取每日奖励
read(25005) ->
	{req_city_receive_day, []};
%% 获取沙巴克主界面信息
read(25006) ->
	{req_city_info, []};
%% 领取每一次占领的奖励
read(25008) ->
	{req_city_receive_every, []};
%% 获取导航列表
read(26000) ->
	{req_navigate_task_list, []};
%% 接取任务
read(26001) ->
	{req_navigate_accept_task, [32]};
%% 完成任务
read(26002) ->
	{req_navigate_finish_task, [32]};
%% 快速完成功勋任务
read(26007) ->
	{req_fast_finish_task, [32]};
%% 快速完成任务需要元宝
read(26009) ->
	{req_get_task_complete_jade, [32]};
%% 获取各个职业的第一名
read(27000) ->
	{req_worship_frist_career_list, []};
%% 获取玩家的朝拜信息
read(27001) ->
	{req_worship_info, []};
%% 玩家朝拜
read(27002) ->
	{req_worship, [8]};
%% 获取活动剩余次数信息
read(28001) ->
	{req_get_activity_list, []};
%% 获取新手卡开启状态
read(28003) ->
	{req_noob_card_state, [string, string]};
%% 获取vip信息
read(29001) ->
	{req_get_vip_state, [16]};
%% 领取vip奖励
read(29002) ->
	{req_receive_vip_goods, [16]};
%% 清理pk值
read(29004) ->
	{req_clear_pk, []};
%% 小飞鞋传送
read(29005) ->
	{req_flying_shoes, [16, 16, 16, 8]};
%% 添加vip经验
read(29006) ->
	{req_add_vip_exp, [16]};
%% 获取玩家vip经验
read(29007) ->
	{req_get_vip_exp, []};
%% 购买充值
read(30001) ->
	{req_buy_charge, [16, string]};
%% 获取购买过的充值列表
read(30002) ->
	{req_get_charge_list, []};
%% 月卡信息
read(30003) ->
	{req_get_charge_month_info, []};
%% 领取月卡奖励
read(30004) ->
	{req_receive_charge_month, []};
%% 获取分包状态信息
read(31001) ->
	{req_package_list, []};
%% 领取分包奖励
read(31002) ->
	{req_reward_package_goods, [16]};
%% 获取活动信息
read(32001) ->
	{req_get_active_info, []};
%% 获取玩家当天登录游戏时长
read(32002) ->
	{req_get_login_times, []};
%% 领取活动奖励
read(32003) ->
	{req_get_active_reward, [16]};
%% 获取首充奖励列表
read(32005) ->
	{req_get_first_charge_reward, []};
%% 获取每日签到信息
read(32006) ->
	{req_everyday_sign_info, []};
%% 签到领奖
read(32007) ->
	{req_everyday_sign, []};
%% 进入活动副本
read(32008) ->
	{req_enter_active_instance, [16]};
%% 获取等级力排行榜信息
read(32009) ->
	{req_get_lv_rank_info, [8, 8]};
%% 获取战力排行榜信息
read(32010) ->
	{req_get_fight_rank_info, [8, 8]};
%% 获取行会排行榜信息
read(32011) ->
	{req_get_guild_rank_info, [8]};
%% 获取开服活动相关列表
read(32012) ->
	{req_active_service_list, [8]};
%% 领取开服活动奖励
read(32013) ->
	{req_receive_goods, [16]};
%% 获取签到日期列表
read(32014) ->
	{req_sign_list, []};
%% 玩家签到
read(32015) ->
	{req_player_sign, []};
%% 玩家补签
read(32016) ->
	{req_player_repair_sign, []};
%% 玩家领取签到奖励
read(32017) ->
	{req_player_sign_reward, [8]};
%% 限时活动通知
read(32018) ->
	{req_active_time_notice, []};
%% 获取开服活动类型列表
read(32019) ->
	{req_get_active_service_type_list, []};
%% 获取运营活动信息列表
read(32020) ->
	{req_get_operate_active_info, []};
%% 领取运营活动奖励
read(32021) ->
	{req_receive_reward, [32]};
%% 开始答题
read(32030) ->
	{req_exam_start, []};
%% 答题
read(32031) ->
	{req_exam_choice, [32, 8]};
%% 答题排行
read(32032) ->
	{req_exam_rank, []};
%% 积分双倍道具
read(32033) ->
	{req_exam_tool, [32, 8]};
%% 触发活动条件
read(32034) ->
	{req_activity_trigger, [32]};
%% 获取活动相关排名
read(32035) ->
	{req_active_rank, [32]};
%% 获取节日活动信息列表
read(32036) ->
	{req_get_operate_holiday_active_info, []};
%% 功能预告礼包状态
read(32037) ->
	{req_function_notice_state, []};
%% 功能预告礼包领取
read(32038) ->
	{req_function_notice_get, [32]};
%% 购买活动活动商品列表物品信息
read(32042) ->
	{req_buy_active_shop, [32, 32]};
%% 刷新红点信
read(32043) ->
	{req_active_service_red, [32]};
%% 获取节日活动兑换信息列表
read(32044) ->
	{req_get_operate_holiday_change_info, [32]};
%% 领取运营活动奖励
read(32045) ->
	{req_new_receive_reward, [32, 8]};
%% 根据活动类型获取内容信息
read(32046) ->
	{req_get_type_active_info, [16]};
%% 获取拍卖的物品信息-类型
read(33000) ->
	{req_get_sale_goodslist, [8, 8, 8, 16, 32]};
%% 获取拍卖的物品信息-模糊搜索
read(33001) ->
	{req_get_sale_goodslist_name, [8, 8, string]};
%% 获取玩家上架的物品列表
read(33002) ->
	{req_get_sale_sell_goodslist, []};
%% 玩家查看领取物品信息
read(33003) ->
	{req_get_player_sale_goods_list, []};
%% 玩家上架物品
read(33004) ->
	{req_add_sale, [64, 32, 32, 32, 32]};
%% 玩家购买拍卖物品
read(33005) ->
	{req_buy_sale, [64]};
%% 物品下架
read(33006) ->
	{req_del_sale, [64]};
%% 玩家领取物品
read(33007) ->
	{req_receive_sale_goods, [64]};
%% 获取交易税
read(33008) ->
	{req_get_sale_tax, [64]};
%% 获取出售需要的金币
read(33009) ->
	{req_get_sale_sell, [64]};
%% 获取出售需要的金币
read(33010) ->
	{req_get_receive_sale_goods_coin, [64]};
%% 领取开服红包信息
read(34000) ->
	{req_receive_red, [64]};
%% 获取抽奖日志 last_id大于0表示翻页，默认为0
read(35000) ->
	{req_get_lottery_info, [32]};
%% 开始抽奖
read(35001) ->
	{req_lottery_begin, [32]};
%% 离开抽奖
read(35003) ->
	{req_logout_lottery, []};
%% 获取神皇秘境抽奖日志 last_id大于0表示翻页，默认为0
read(35004) ->
	{req_lottery_info_shmj, [32]};
%% 神皇秘境开始抽奖
read(35005) ->
	{req_lottery_begin_shmj, [32]};
%% 神皇秘境抽奖积分兑换物品
read(35006) ->
	{req_lottery_exchange_shmj, [32]};
%% 获取抽奖日志 last_id大于0表示翻页，默认为0
read(36000) ->
	{req_get_lottery_coin_log_list, [32]};
%% 开始抽奖
read(36001) ->
	{req_lottery_coin_begin, [32]};
%% 离开抽奖
read(36003) ->
	{req_logout_lottery_coin, []};
%% 创建军团
read(37001) ->
	{req_create_legion, [string, 8]};
%% 获取入帮条件
read(37002) ->
	{req_enter_legion_cond, [64]};
%% 设置入帮条件
read(37003) ->
	{req_set_legion_cond, [32]};
%% 获取所有军团总数
read(37004) ->
	{req_get_legion_num, []};
%% 获取军团列表
read(37005) ->
	{req_get_legion_list, [16, 16]};
%% 申请加入军团
read(37006) ->
	{req_apply_enter_legion, [64]};
%% 获取申请军团人数
read(37007) ->
	{req_apply_legion_num, []};
%% 获取申请列表
read(37008) ->
	{req_apply_legion_info, [16, 16]};
%% 同意玩家加入军团
read(37009) ->
	{req_agree_join_legion, [64, 8]};
%% 获取军团详细信息
read(37010) ->
	{req_legion_detailed_info, []};
%% 获取玩家军团信息
read(37011) ->
	{req_get_legion_member_info, []};
%% 获取军团成员信息列表
read(37012) ->
	{req_legion_member_info_list, [16, 16]};
%% 退出军团
read(37013) ->
	{req_leave_legion, []};
%% 解除军团
read(37014) ->
	{req_remove_legion, []};
%% 获取军团人数
read(37015) ->
	{req_get_legion_member_num, []};
%% 修改军团公告
read(37016) ->
	{req_write_announce_legion, [string]};
%% 获取军团成员详细信息
read(37017) ->
	{req_get_member_info_legion, [64]};
%% 剔除成员
read(37018) ->
	{req_reject_member_legion, [64]};
%% 委任职位
read(37019) ->
	{req_appoint_member_legion, [64, 8]};
%% 清空申请列表
read(37020) ->
	{req_clear_apply_list_legion, []};
%% 行会日志信息
read(37053) ->
	{req_legion_log_info, []};
%% 邀请加入行会
read(37054) ->
	{req_legion_ask, [64]};
%% 同意会长得邀请
read(37056) ->
	{req_legion_agree_ask, [64]};
%% 获取开服活动相关列表
read(38012) ->
	{req_active_service_merge_list, [8]};
%% 领取开服活动奖励
read(38013) ->
	{req_receive_merge_goods, [16]};
%% 获取开服活动类型列表
read(38019) ->
	{req_get_active_service_merge_type_list, []};
%% 购买礼包
read(38042) ->
	{req_buy_active_merge_shop, [32, 32]};
%% 刷新红点信
read(38043) ->
	{req_active_service_merge_red, [32]};
read(N) ->
	Trace = try throw(42) catch 42 -> erlang:get_stacktrace() end, 
	?ERR("undefined read protocol ~p ~p", [N,Trace]).

%% 获取按钮提示
write(9000) ->
	{rep_get_button_tips, [[proto_button_tips]]};
%% 更新按钮提示
write(9001) ->
	{rep_update_button_tips, [[proto_button_tips]]};
%% 错误提示
write(9998) ->
	{rep_err_result, [16]};
%% 公告
write(9999) ->
	{rep_notice, [16, [string]]};
%% 玩家下线
write(9997) ->
	{rep_login_out, [16]};
%% 获取角色列表
write(10000) ->
	{rep_player_list, [16, [proto_login_info]]};
%% 创建角色
write(10001) ->
	{rep_create, [16, proto_login_info]};
%% 进入游戏
write(10002) ->
	{rep_enter, [16]};
%% 获取自己属性
write(10003) ->
	{rep_player_info, [16, proto_player_info]};
%% 更新玩家信息
write(10004) ->
	{rep_update_player, [[proto_player_update]]};
%% 玩家复活
write(10005) ->
	{rep_revive, [16]};
%% 心跳包
write(10006) ->
	{rep_heart, [32]};
%% 退出
write(10007) ->
	{rep_logout, [8]};
%% 修改pk模式
write(10008) ->
	{rep_change_pk_mode, [16, 8]};
%% 删除角色
write(10009) ->
	{rep_delete_player, [64]};
%% 玩家死亡
write(10010) ->
	{rep_player_die, [string, 16]};
%% 获取玩家详细信息
write(10011) ->
	{rep_get_player_info, [64, string, string, 16, 8, 16, 32, [proto_equips_info], proto_guise, proto_mark, 16]};
%% 获取玩家身上效果标识
write(10012) ->
	{rep_get_player_buff_flag, [[proto_spec_buff], [proto_buff]]};
%% 改变翅膀外观状态
write(10013) ->
	{rep_change_wing_state, [8, 16]};
%% 印记升级
write(10015) ->
	{rep_upgrade_mark, [16]};
%% 获取自己的扩展属性
write(10016) ->
	{rep_player_extra_info, [16, 32]};
%% 获取服务器时间
write(10018) ->
	{rep_time_info, [32, 32]};
%% 切换场景
write(11001) ->
	{rep_change_scene, [16, 16, [proto_scene_player], [proto_scene_monster], [proto_scene_drop], [proto_fire_wall]]};
%% 开始移动
write(11002) ->
	{rep_start_move, [proto_obj_flag, 8, proto_point, proto_point]};
%% 移动同步
write(11003) ->
	{rep_move_sync, [proto_obj_flag, 8, proto_point, proto_point]};
%% 对象离屏
write(11004) ->
	{rep_obj_leave, [[proto_obj_flag]]};
%% 对象进屏/或者更新
write(11005) ->
	{rep_obj_enter, [[proto_scene_player], [proto_scene_monster], [proto_scene_drop], [proto_fire_wall]]};
%% 拾取掉落
write(11006) ->
	{rep_pickup, [16]};
%% buff变更
write(11007) ->
	{rep_buff_operate, [[proto_buff_operate]]};
%% 伤害
write(11008) ->
	{rep_harm_list, [[proto_harm]]};
%% 获取世界boss刷新时间
write(11009) ->
	{rep_world_boss_refresh, [[proto_boss_refresh]]};
%% 获取打宝地图boss刷新时间
write(11010) ->
	{rep_treasure_refresh, [[proto_boss_refresh]]};
%% 对象更新
write(11011) ->
	{rep_obj_update, [[proto_scene_player_update]]};
%% 场景复活广播
write(11012) ->
	{rep_scene_revive, [proto_obj_flag]};
%% 获取副本入口信息
write(11013) ->
	{rep_instance_entry_info, [16, 8]};
%% 个人副本场景统计
write(11015) ->
	{rep_single_instance_info, [16, 16, 16, 8, 8, 32, 32]};
%% 个人副本挑战结果
write(11017) ->
	{rep_single_instance_result, [16, 8]};
%% 获取沙城活动信息
write(11018) ->
	{rep_shacheng_info, [8, 64, string]};
%% 场景地图标识
write(11019) ->
	{rep_scene_map_flag, [[proto_map_teammate_flag]]};
%% 对象频繁数据更新
write(11020) ->
	{rep_obj_often_update, [[proto_scene_obj_often_update]]};
%% 获取场景内存活的某个怪物坐标点
write(11021) ->
	{rep_monster_point, [8, proto_point]};
%% 传送阵传送
write(11022) ->
	{rep_transfer, [16]};
%% 更新对象仇恨目标
write(11023) ->
	{rep_update_enmity, [proto_obj_flag, proto_enmity, proto_drop_owner]};
%% 传送点传送
write(11024) ->
	{rep_transport, [16]};
%% 获取npc状态
write(11025) ->
	{rep_get_npc_state, [32]};
%% 获取npc状态
write(11026) ->
	{rep_get_guide_state, [16]};
%% 宠物更新
write(11027) ->
	{rep_pet_update, [[proto_scene_pet_update]]};
%% 世界boss副本信息
write(11028) ->
	{rep_dragon_instance_info, [8, 16, 32, [proto_world_boss_rank]]};
%% 胜者为王副本信息
write(11029) ->
	{rep_szww_instance_info, [32, 32, 16]};
%% 胜者为王奖励通知
write(11030) ->
	{rep_szww_reward, [16]};
%% 获取世界boss免费传送次数
write(11032) ->
	{rep_get_free_transfer_num, [8]};
%% boss传送
write(11033) ->
	{rep_get_free_transfer, [16]};
%% 获取副本列表
write(11034) ->
	{rep_get_fb_list, [[proto_fb_info]]};
%% 购买副本次数返回
write(11035) ->
	{rep_buy_fb_num, [16]};
%% 购买副本次数返回
write(11036) ->
	{rep_ref_fb_info, [proto_fb_info]};
%% 获取当前场景的线路信息
write(11038) ->
	{rep_get_line_list, [16, [proto_line_info]]};
%% 获取玩家的仇人列表
write(11040) ->
	{rep_get_foe_list, [[64]]};
%% 获取玩家的仇人列表
write(11041) ->
	{rep_ref_foe_info, [64, 64]};
%% 怪物攻城副本信息
write(11042) ->
	{rep_attack_city_instance_info, [8, 8, 16, 16, 16, 32, 32, 32, [proto_attack_city_rank]]};
%% 拾取掉落
write(11043) ->
	{rep_collection, [16]};
%% 个人boss成果
write(11045) ->
	{rep_single_boss_result, [32, 8]};
%% boss掉落
write(11046) ->
	{rep_monster_boss_drop, [[proto_monster_boss_drop]]};
%% 返回跨服boss相关副本信息
write(11047) ->
	{rep_cross_boss_result, [32]};
%% boss刷新时间和关注
write(11048) ->
	{rep_boss_time_and_follow, [8, [proto_boss_time_and_follow]]};
%% boss刷新推送
write(11049) ->
	{rep_boss_refresh_notice, [32, 32]};
%% 城市boss最后击杀者
write(11050) ->
	{rep_city_boss_last_killers, [[proto_city_boss_killer]]};
%% 怪物预警
write(11052) ->
	{rep_monster_warning, [32]};
%% 获取同场景的玩家外观信息
write(11053) ->
	{rep_guise_list, [[32], [32], [32], [32]]};
%% 火龙神殿杀怪数量
write(11054) ->
	{rep_dragon_kill_num, [32]};
%% 获取世界地图
write(11055) ->
	{rep_word_map_list, [[proto_word_map_info]]};
%% 王城乱斗敌我关系变化时间预告
write(11056) ->
	{rep_instance_king_round_time_left, [16]};
%% 王城乱斗排行信息
write(11057) ->
	{rep_instance_king_info, [16, 32, [proto_instance_king_rank]]};
%% 王城乱斗战报信息
write(11058) ->
	{rep_instance_king_result, [16, 32, [proto_instance_king_rank_full]]};
%% 获取变异地宫boss击杀数量
write(11061) ->
	{rep_palace_boss_result, [[proto_palace_scene], [proto_palace_boss_num]]};
%% 场景背景图片加载信息
write(11101) ->
	{req_scene_pic, [string]};
%% 幻境之城玩家通关信息 
write(11102) ->
	{req_hjzc_pass, [8]};
%% 获取幻境之城的排名信息
write(11103) ->
	{rep_get_hjzc_rank_list, [[proto_hjzc_rank_info]]};
%% 获取玩家幻境之城的点亮信息
write(11104) ->
	{rep_get_hjzc_plyaer_info, [8, [16]]};
%% 幻境之城传送戒指传送
write(11105) ->
	{rep_hjzc_send_change, [16]};
%% 获取当前学习的技能列表
write(12001) ->
	{rep_skill_list, [16, [proto_skill]]};
%% 开始释放技能
write(12002) ->
	{rep_start_use_skill, [16, proto_obj_flag, proto_point, 8, 32, 32, 8, proto_obj_flag, proto_point]};
%% 推送技能信息变更
write(12003) ->
	{rep_skill_info, [proto_skill]};
%% 升级与学习技能
write(12004) ->
	{rep_upgrade_skill, [16]};
%% 技能设置快捷键
write(12005) ->
	{rep_set_pos, [16]};
%% 清空快捷键
write(12006) ->
	{rep_clear_pos, [16]};
%% 激活自动技能
write(12007) ->
	{rep_active_auto_skill, [16]};
%% 设置与获取群体技能开关
write(12008) ->
	{rep_set_group_switch, [8]};
%% 增加技能熟练度
write(12009) ->
	{rep_add_skill_exp, [16]};
%% 触发非伤害型技能效果
write(12010) ->
	{rep_trigger_skill, [[proto_obj_flag], [proto_buff_operate], [proto_point_change], [proto_point_change]]};
%% 直接切换挂机场景(不等待回合结束)
write(13001) ->
	{rep_change_hook_scene, [16, 16]};
%% 获取场景刷怪信息
write(13002) ->
	{rep_get_hook_monster, [8, [proto_hook_monster]]};
%% 挂机释放技能
write(13003) ->
	{rep_hook_use_skill, [[proto_harm], [proto_cure], [proto_buff_operate]]};
%% 回合结果
write(13004) ->
	{rep_round_result, [8, 8]};
%% 产生掉落
write(13005) ->
	{rep_drop, [proto_obj_flag, [proto_hook_drop]]};
%% 获取boss可用挑战次数
write(13006) ->
	{rep_challenge_num, [8, 16]};
%% 挑战boss
write(13007) ->
	{rep_challenge_boos, [16, 16]};
%% 切换挂机场景(等待回合结束)
write(13008) ->
	{rep_change_hook_scene1, [16, 16]};
%% 获取离线报告
write(13009) ->
	{rep_offline_report, [proto_hook_report]};
%% 快速挂机
write(13010) ->
	{rep_quick_hook, [16]};
%% 购买boss挑战次数
write(13011) ->
	{rep_buy_challenge, [16, 8, 16]};
%% 获取挂机统计
write(13012) ->
	{rep_hook_statistics, [16, 32, 32, 8]};
%% 获取当前挂机数据
write(13013) ->
	{rep_cur_power, [16, 8, 8, 8, proto_hook_report]};
%% 购买挂机次数
write(13014) ->
	{rep_buy_power, [16]};
%% 获取挂机星级列表
write(13015) ->
	{rep_hook_star_list, [[proto_hook_star], [proto_hook_star_reward]]};
%% 更新挂机星级
write(13016) ->
	{rep_update_hook_star, [proto_hook_star]};
%% 挑战boss结果
write(13017) ->
	{rep_challenge_boos_result, [8, 16]};
%% 添加挂机场景对象
write(13018) ->
	{rep_add_hook_obj, [[proto_hook_monster]]};
%% 添加挂机火墙
write(13019) ->
	{rep_add_hook_fire_wall, [[proto_hook_fire_wall]]};
%% buff变更
write(13021) ->
	{rep_hook_buff_operate, [[proto_buff_operate]]};
%% 领取挂机星级奖励
write(13022) ->
	{rep_draw_star_reward, [16]};
%% 更新挂机星级奖励
write(13023) ->
	{rep_update_star_reward, [proto_hook_star_reward]};
%% 领取首通奖励
write(13024) ->
	{rep_draw_first_reward, [16]};
%% 领取挂机奖励
write(13025) ->
	{rep_receive_hook_draw, [16]};
%% 道具信息列表
write(14001) ->
	{rep_goods_list, [[proto_goods_info]]};
%% 道具信息变更广播
write(14002) ->
	{rep_broadcast_goods_info, [[proto_goods_info]]};
%% 添加道具
write(14003) ->
	{rep_add_goods, [16]};
%% 根据装备品质批量出售装备
write(14004) ->
	{rep_batch_sell_equips, [[64], 32, 16]};
%% 根据唯一id批量出售道具
write(14005) ->
	{rep_sell_goods_list_by_id, [[64], 32, 16]};
%% 出售指定数量的道具
write(14006) ->
	{rep_sell_goods_by_num, [32, 16]};
%% 使用道具
write(14007) ->
	{rep_use_goods, [16]};
%% 扩展背包
write(14008) ->
	{rep_expand_bag, [16]};
%% 礼包奖励
write(14009) ->
	{rep_bag_reward, [[proto_goods_list]]};
%% 获取血包参数
write(14010) ->
	{rep_get_blood_bag, [32]};
%% 推送变更的道具列表
write(14011) ->
	{rep_goods_change, [32, 32, 8, [proto_goods_list]]};
%% 装备信息列表
write(14020) ->
	{rep_equips_list, [[proto_equips_info]]};
%% 装备信息变更广播
write(14021) ->
	{rep_broadcast_equips_info, [[proto_equips_info]]};
%% 装备更换
write(14022) ->
	{rep_change_equips, [16]};
%% 装备拆卸
write(14023) ->
	{rep_get_off_equips, [16]};
%% 装备强化
write(14024) ->
	{rep_equips_upgrade, [16]};
%% 装备熔炼
write(14025) ->
	{rep_equips_smelt, [16, 32, [32]]};
%% 装备洗练
write(14026) ->
	{rep_equips_baptize, [16, [proto_attr_baptize_value]]};
%% 装备洗练保存
write(14027) ->
	{rep_equips_baptize_save, [16]};
%% 请求锻造的装备信息回复
write(14028) ->
	{rep_equips_forge_id, [32, 8, 16, 32]};
%% 请求锻造的装备
write(14029) ->
	{rep_equips_forge, [16]};
%% 请求刷新锻造信息
write(14030) ->
	{rep_update_forge_info, [16]};
%% 道具合成
write(14031) ->
	{rep_goods_fusion, [16]};
%% 神器吞噬
write(14032) ->
	{rep_art_devour, [16]};
%% 神器传承
write(14033) ->
	{rep_art_inherit, [16]};
%% 勋章升级
write(14034) ->
	{rep_medal_upgrade, [16]};
%% 道具合成扩展
write(14035) ->
	{rep_goods_fusion_plus, [16]};
%% 分解装备
write(14036) ->
	{rep_decompose_equips, [16]};
%% 分解选中的装备
write(14037) ->
	{rep_decompose_equips_by_list, [[64], 16]};
%% 分解选中品质的装备
write(14038) ->
	{rep_decompose_equips_by_quality, [[64], 16]};
%% 仓库道具信息列表
write(14040) ->
	{rep_store_list, [8, [proto_goods_full_info]]};
%% 仓库道具信息变更广播
write(14041) ->
	{rep_broadcast_store_goods_info, [proto_goods_full_info]};
%% 道具存入仓库
write(14042) ->
	{rep_bag_to_store, [16]};
%% 仓库取出道具
write(14043) ->
	{rep_store_to_bag, [16]};
%% 翅膀升级
write(14044) ->
	{rep_wing_upgrade, [16]};
%% 强化转移
write(14045) ->
	{rep_strengthen_change, [16]};
%% 装备铸魂
write(14046) ->
	{rep_soul_equips, [16]};
%% 装备洗练锁定
write(14047) ->
	{rep_equips_baptize_lock, [16]};
%% 装备投保
write(14048) ->
	{rep_equips_secure, [16]};
%% 铸魂回收
write(14049) ->
	{rep_soul_change, [16]};
%% 洗练转移
write(14050) ->
	{rep_baptiz_change, [16]};
%% 挖藏宝图
write(14051) ->
	{rep_goods_map, [16]};
%% 翅膀到期推送
write(14052) ->
	{rep_goods_expire, [16]};
%% 坐骑升级
write(14053) ->
	{rep_mounts_upgrade, [16]};
%% 坐骑装备升级
write(14054) ->
	{rep_mounts_mark_upgrade, [16, 16, 16]};
%% 获取坐骑装备祝福值
write(14055) ->
	{rep_get_mounts_mark_bless, [32, 16]};
%% 邮件信息列表
write(15001) ->
	{rep_mail_list, [[proto_mail_info]]};
%% 新邮件推送广播
write(15002) ->
	{rep_broadcast_mail_info, [proto_mail_info]};
%% 领取邮件奖励
write(15003) ->
	{rep_open_mail, [64, 16]};
%% 删除邮件
write(15004) ->
	{rep_remove_mail, [64, 16]};
%% 购买商品
write(16001) ->
	{rep_buy_shop, [16]};
%% 获取云游商人商品列表
write(16002) ->
	{rep_get_wander_shop_list, [[proto_wander_shop]]};
%% 商品数量限制
write(16003) ->
	{rep_buy_limit, [16, 16]};
%% 一生一次性礼包
write(16004) ->
	{rep_shop_once_list, [[proto_shop_once_state], 32]};
%% 一生一次性礼包
write(16005) ->
	{rep_shop_once_buy, [16]};
%% 获取神秘商人物品列表
write(16100) ->
	{rep_get_mystery_shop_list, [8, [proto_mystery_shop], 16, 32, 32]};
%% 购买神秘商人物品
write(16101) ->
	{rep_buy_mystery_shop, [16]};
%% 元宝刷新神秘商人列表
write(16102) ->
	{rep_ref_mystery_shop_list, [[proto_mystery_shop], 16]};
%% 创建帮派
write(17001) ->
	{rep_create_guild, [16, 32]};
%% 获取入帮条件
write(17002) ->
	{rep_enter_guild_cond, [32, 16]};
%% 设置入帮条件
write(17003) ->
	{rep_set_guild_cond, [32, 16]};
%% 获取所有帮派总数
write(17004) ->
	{rep_get_guild_num, [16]};
%% 获取帮派列表
write(17005) ->
	{rep_get_guild_list, [[proto_guild_info]]};
%% 申请加入帮派
write(17006) ->
	{rep_apply_enter_guild, [16]};
%% 获取申请帮派人数
write(17007) ->
	{rep_apply_guild_num, [16]};
%% 获取申请列表
write(17008) ->
	{rep_apply_guild_info, [16, 16, [proto_apply_guild_info]]};
%% 同意玩家加入帮派
write(17009) ->
	{rep_agree_join_guild, [64, 8, 16]};
%% 获取帮派详细信息
write(17010) ->
	{rep_guild_detailed_info, [proto_guild_detailed_info]};
%% 获取玩家帮派信息
write(17011) ->
	{rep_get_guild_member_info, [proto_player_guild_info]};
%% 获取帮派成员信息列表
write(17012) ->
	{rep_guild_member_info_list, [16, 16, [proto_guild_member_info]]};
%% 退出帮派
write(17013) ->
	{rep_leave_guild, [16]};
%% 解除帮派
write(17014) ->
	{rep_remove_guild, [16]};
%% 获取帮派人数
write(17015) ->
	{rep_get_guild_member_num, [16]};
%% 修改帮会公告
write(17016) ->
	{rep_write_announce, [16]};
%% 获取帮派成员详细信息
write(17017) ->
	{rep_get_member_info, [64, string, 16, 8, 16, 32, [proto_equips_info], proto_guise, 16]};
%% 剔除成员
write(17018) ->
	{rep_reject_member, [16]};
%% 委任职位
write(17019) ->
	{rep_appoint_member, [64, 8, 16]};
%% 清空申请列表
write(17020) ->
	{rep_clear_apply_list, [16]};
%% 行会捐献
write(17050) ->
	{rep_guild_donation, [16]};
%% 行会商店兑换
write(17051) ->
	{rep_guild_shop, [16]};
%% 获取捐献信息
write(17052) ->
	{rep_guild_donation_info, [[proto_donation_info]]};
%% 行会日志信息
write(17053) ->
	{rep_guild_log_info, [[proto_guild_log_info]]};
%% 邀请加入行会返回
write(17054) ->
	{rep_guild_ask, [16]};
%% 推送的玩家行会邀请信息
write(17055) ->
	{rep_guild_ask_player_info, [string, string, string]};
%% 同意会长得邀请返回
write(17056) ->
	{rep_guild_agree_ask, [16]};
%% 进入行会秘境
write(17057) ->
	{rep_enter_guild_fam, [16]};
%% 开启沙巴克秘境
write(17058) ->
	{rep_open_sbk_fam, [16]};
%% 进入沙巴克秘境
write(17059) ->
	{rep_enter_sbk_fam, [16]};
%% 挑战公会boss
write(17060) ->
	{rep_challenge_guild_active, [16]};
%% 获取行会秘境信息
write(17061) ->
	{rep_guild_fam_info, [8, 8, 32, 32]};
%% 获取沙巴克秘境信息
write(17062) ->
	{rep_sbk_fam_info, [string, 8, 32, 32]};
%% 获取公会红包信息
write(17063) ->
	{rep_get_guild_red_list, [[proto_guild_red_info], [proto_guild_red_log]]};
%% 获取下一页的红包信息
write(17064) ->
	{rep_get_guild_red_info_page, [[proto_guild_red_info]]};
%% 获取下一页的红包日志信息
write(17065) ->
	{rep_get_guild_red_log_page, [[proto_guild_red_log]]};
%% 新的行会红包
write(17066) ->
	{rep_send_guild_red_info, [proto_guild_red_info]};
%% 新的红包日志
write(17067) ->
	{rep_send_guild_red_log, [proto_guild_red_log]};
%% 有行会红包
write(17068) ->
	{rep_send_guild_red, []};
%% 获取下一页的红包信息
write(17070) ->
	{rep_receive_red_guild, [32, 64, 32]};
%% 获取下一页的红包信息
write(17071) ->
	{rep_send_red_guild, [32]};
%% 发起行会挑战
write(17080) ->
	{rep_guild_challenge_apply, [32, string]};
%% 收到行会挑战请求
write(17081) ->
	{rep_guild_challenge_invite, [64, string]};
%% 同意行会挑战
write(17082) ->
	{rep_guild_challenge_answer, [32]};
%% 推送行会挑战成绩
write(17083) ->
	{rep_guild_challenge_result, [64, string, 64, string, 16, 16, 32]};
%% 行会宣战信息
write(17084) ->
	{rep_guild_challenge_info, [64, string, 64, string]};
%% 发起结盟
write(17085) ->
	{rep_guild_alliance_apply, [32]};
%% 收到行会结盟请求
write(17086) ->
	{rep_guild_alliance_invite, [32, 64, string, 64, string]};
%% 同意行会挑战
write(17087) ->
	{rep_guild_alliance_answer, [32, 8]};
%% 反馈给发起方结盟请求
write(17088) ->
	{rep_guild_alliance_result, [32, 64, string, 64, string]};
%% 退出行会挑战
write(17089) ->
	{rep_guild_alliance_exit, [32]};
%% 踢出行会挑战
write(17090) ->
	{rep_guild_alliance_kick, [32]};
%% 收到踢出行会结盟
write(17091) ->
	{rep_guild_alliance_out, [64, string, string]};
%% 推送结盟状态
write(17092) ->
	{rep_guild_alliance_state_push, [[proto_guild_simple_info]]};
%% 结盟信息
write(17093) ->
	{rep_guild_alliance_info, [[proto_guild_standard_info]]};
%% 跨服帮会信息
write(17094) ->
	{rep_guild_alliance_guild, [32, proto_guild_standard_info]};
%% 世界聊天
write(18001) ->
	{rep_world_chat, [proto_world_chat_info]};
%% 私聊
write(18002) ->
	{rep_friend_chat, [proto_world_chat_info]};
%% 公会聊天
write(18003) ->
	{rep_guild_chat, [proto_world_chat_info]};
%% 队伍liaot
write(18006) ->
	{rep_team_chat, [proto_world_chat_info]};
%% 聊天结果通知
write(18004) ->
	{rep_friend_chat_result, [16]};
%% 获取容联md5和时间字符串
write(18005) ->
	{rep_md5_and_timestamp, [string, string]};
%% 获取世界聊天列表
write(18008) ->
	{rep_get_chat_word_list, [[proto_world_chat_info], [proto_world_chat_info], [proto_world_chat_info], [proto_world_chat_info]]};
%% 同屏动态聊天信息
write(18009) ->
	{rep_screen_chat, [proto_obj_flag, string]};
%% 军团聊天
write(18010) ->
	{rep_legion_chat, [proto_world_chat_info]};
%% 获取玩家的任务信息
write(19000) ->
	{rep_task_list, [[proto_taskinfo], [8]]};
%% 领取任务奖励
write(19001) ->
	{rep_task_reward, [32]};
%% 发起交易邀请A->B
write(20001) ->
	{rep_apply_trade, [16, 64, 8]};
%% 玩家B收到交易邀请
write(20002) ->
	{rep_trade_invite, [64, string, 8]};
%% 玩家B反馈交易请求
write(20003) ->
	{rep_trade_feedback, [16, 64, 8]};
%% 取消交易
write(20004) ->
	{rep_clean_trade, [16]};
%% 变更交易数据
write(20005) ->
	{rep_trade_info, [16]};
%% 玩家b变更交易数据
write(20006) ->
	{rep_b_trade_info, [32, [proto_goods_full_info]]};
%% 确认交易
write(20007) ->
	{rep_confirm_trade, [16]};
%% 通知对方交易异常取消
write(20008) ->
	{rep_fail_trade, [16]};
%% 交易成功
write(20009) ->
	{rep_success_trade, [16]};
%% 创建队伍
write(21000) ->
	{rep_create_team, [16]};
%% 获取自身队伍信息
write(21001) ->
	{rep_team_info, [8, 8, [proto_team_member_info]]};
%% 开启关闭队伍开关
write(21002) ->
	{rep_team_switch, [8, 8]};
%% 队伍相关通知
write(21003) ->
	{rep_team_notice, [string, 8]};
%% 邀请玩家入队
write(21004) ->
	{rep_invite_join_team, [16]};
%% 广播邀请
write(21005) ->
	{rep_broadcast_invite, [64, string, string]};
%% 是否同意加入
write(21006) ->
	{rep_agree_join_team, [16]};
%% 玩家申请加入队伍
write(21007) ->
	{rep_apply_join_team, [16]};
%% 广播申请给队长
write(21008) ->
	{rep_broadcast_apply, [64, string]};
%% 队长同意申请
write(21009) ->
	{rep_agree_apply_team, [16]};
%% 获取附近玩家信息
write(21010) ->
	{rep_near_by_player, [[proto_near_by_player]]};
%% 获取附近队伍信息
write(21011) ->
	{rep_near_by_team, [[proto_near_by_team]]};
%% 转移队长
write(21012) ->
	{rep_change_team, [16]};
%% 剔出队伍
write(21013) ->
	{rep_remove_team, [16]};
%% 解散队伍
write(21014) ->
	{rep_clear_team, [16]};
%% 离开队伍
write(21015) ->
	{rep_leave_team, [16]};
%% 队伍信息更新
write(21016) ->
	{rep_update_team_info, [[proto_team_member_info]]};
%% 传送会长
write(21017) ->
	{rep_transfer_hz, [16]};
%% 使用激活码
write(22002) ->
	{rep_use_code, [16]};
%% boss刷新关注列表
write(22004) ->
	{rep_monster_follow, [[proto_monster_follow]]};
%% boss刷新关注
write(22005) ->
	{rep_monster_follow_action, [16]};
%% 获取竞技场排名
write(23001) ->
	{rep_get_arena_rank, [32]};
%% 获取挑战次数
write(23002) ->
	{rep_get_arena_count, [8]};
%% 获取竞技场挑战列表
write(23003) ->
	{rep_arena_challenge_list, [[proto_arena_challenge_info]]};
%% 获取竞技场排行列表
write(23004) ->
	{rep_arena_rank_list, [[proto_arena_rank_info]]};
%% 获取竞技场挑战记录列表
write(23005) ->
	{rep_arena_record_list, [[proto_arena_record]]};
%% 获取竞技场挑战记录列表
write(23006) ->
	{rep_arena_shop, [16]};
%% 获取竞技场声望
write(23007) ->
	{rep_get_arena_reputation, [32]};
%% 发起挑战反回
write(23008) ->
	{rep_challenge_arena, [16]};
%% 刷新匹配列表
write(23009) ->
	{rep_refuse_match_list, [16]};
%% 清空竞技场记录
write(23010) ->
	{rep_clear_arena_record, [16]};
%% 挑战结果广播
write(23011) ->
	{rep_arena_result, [16, [proto_goods_list], 32]};
%% 声望发生变化
write(23012) ->
	{rep_change_reputation, [32]};
%% 获取玩家的关系信息
write(24000) ->
	{rep_relationship_list, [8, [proto_relationship_info]]};
%% 移除列表元素操作信息返回
write(24001) ->
	{rep_relationship_operate, [64, 8, 16]};
%% 拉黑信息返回
write(24002) ->
	{rep_relationship_black, [64, 16]};
%% 申请成为好友返回
write(24003) ->
	{rep_relationship_friend_ask, [16]};
%% 通过玩家id获取玩家的信息返回
write(24004) ->
	{rep_relationship_playerinfo_playerid, [string, 32, 16, 64]};
%% 通过玩家名称获取玩家的信息返回
write(24005) ->
	{rep_relationship_playerinfo_playername, [string, 32, 16, 64]};
%% 刷新好友列表
write(24006) ->
	{rep_relationship_ref_friend_list, [8, [proto_relationship_info]]};
%% 推送的玩家申请信息
write(24007) ->
	{rep_relationship_friend_ask_send, [string, 64]};
%% 通过玩家名称获取玩家的信息返回
write(24008) ->
	{rep_relationship_friend_ask_isok, [16]};
%% 添加仇人信息返回
write(24009) ->
	{rep_relationship_foe, [64, 16]};
%% 获取玩家的关系信息
write(25000) ->
	{rep_city_info_list, [16, 16, 32, [proto_city_officer_info], [proto_guild_member_info]]};
%% 任命官员
write(25001) ->
	{rep_city_appoint_officer, [16]};
%% 解雇官员
write(25002) ->
	{rep_city_recall_officer, [16]};
%% 获取领取界面的奖励信息
write(25003) ->
	{rep_city_reward_info, [32, 8, string, 8, string, 8, string]};
%% 领取第一次奖励返回
write(25004) ->
	{rep_city_receive_frist, [16]};
%% 领取每日奖励返回
write(25005) ->
	{rep_city_receive_day, [16]};
%% 获取玩家的关系信息
write(25006) ->
	{rep_city_info, [[proto_city_officer_info], string, 16, 16, 32]};
%% 获取玩家的关系信息
write(25007) ->
	{rep_city_ref__info, [[proto_city_officer_info]]};
%% 领取每一次占领的奖励
write(25008) ->
	{rep_city_receive_every, [16]};
%% 获取导航列表 主推就全部从新加载
write(26000) ->
	{rep_navigate_task_list, [[proto_navigate_task_info]]};
%% 接取任务
write(26001) ->
	{rep_navigate_accept_task, [16, 32]};
%% 完成任务
write(26002) ->
	{rep_navigate_finish_task, [16, 32]};
%% 刷新导航列表 主推就单独刷新
write(26003) ->
	{rep_navigate_ref_task_list, [[proto_navigate_task_info]]};
%% 快速完成功勋任务
write(26007) ->
	{rep_fast_finish_task, [16, 32]};
%% 记录日常任务信息
write(26008) ->
	{rep_record_task, [proto_navigate_task_info]};
%% 快速完成功勋任务
write(26009) ->
	{rep_get_task_complete_jade, [16]};
%% 获取各个职业的第一名
write(27000) ->
	{rep_worship_frist_career_list, [[proto_worship_first_career_info]]};
%% 获取玩家的朝拜信息
write(27001) ->
	{rep_worship_info, [32, 32]};
%% 玩家朝拜
write(27002) ->
	{rep_worship, [16]};
%% 刷新开启功能
write(28000) ->
	{rep_ref_function_open_list, [[16]]};
%% 获取活动剩余次数信息
write(28001) ->
	{rep_get_activity_list, [[proto_activity_info]]};
%% 关闭开启功能
write(28002) ->
	{rep_ref_function_close_list, [[16]]};
%% 获取新手卡开启状态
write(28003) ->
	{rep_noob_card_state, [8]};
%% 获取vip信息
write(29001) ->
	{rep_get_vip_state, [16, 32]};
%% 领取vip奖励
write(29002) ->
	{rep_receive_vip_goods, [16]};
%% 清理pk值
write(29004) ->
	{rep_clear_pk, [16]};
%% 小飞鞋传送
write(29005) ->
	{rep_flying_shoes, [16]};
%% 添加vip经验
write(29006) ->
	{rep_add_vip_exp, [16]};
%% 获取玩家vip经验
write(29007) ->
	{rep_get_vip_exp, [32]};
%% 购买充值
write(30001) ->
	{rep_buy_charge, [string, 16, 8]};
%% 获取购买过的充值列表
write(30002) ->
	{rep_get_charge_list, [[16]]};
%% 月卡信息
write(30003) ->
	{rep_get_charge_month_info, [8, 32]};
%% 领取月卡奖励
write(30004) ->
	{rep_receive_charge_month, [16]};
%% 购买充值
write(31001) ->
	{rep_package_list, [[16]]};
%% 领取分包奖励
write(31002) ->
	{rep_reward_package_goods, [16]};
%% 获取活动信息
write(32001) ->
	{rep_get_active_info, [[proto_active_info]]};
%% 获取玩家当天登录游戏时长
write(32002) ->
	{rep_get_login_times, [32]};
%% 领取活动奖励
write(32003) ->
	{rep_get_active_reward, [16, 16]};
%% 更新满足条件活动状态
write(32004) ->
	{rep_update_active_state, [[proto_active_info]]};
%% 获取首充奖励列表
write(32005) ->
	{rep_get_first_charge_reward, [[proto_goods_list]]};
%% 获取每日签到信息
write(32006) ->
	{rep_everyday_sign_info, [8, 8]};
%% 签到领奖
write(32007) ->
	{rep_everyday_sign, [16]};
%% 进入活动副本
write(32008) ->
	{rep_enter_active_instance, [16]};
%% 获取等级排行榜信息
write(32009) ->
	{rep_get_lv_rank_info, [16, [proto_lv_rank_info]]};
%% 获取战力排行榜信息
write(32010) ->
	{rep_get_fight_rank_info, [16, [proto_fight_rank_info]]};
%% 获取行会排行榜信息
write(32011) ->
	{rep_get_guild_rank_info, [16, [proto_guild_rank_info]]};
%% 获取开服活动相关列表
write(32012) ->
	{rep_active_service_list, [32, 32, 32, [proto_active_service_info]]};
%% 领取开服活动奖励
write(32013) ->
	{rep_receive_goods, [16]};
%% 领取开服活动奖励
write(32014) ->
	{rep_sign_list, [[8], [8], 8]};
%% 玩家签到
write(32015) ->
	{rep_player_sign, [16]};
%% 玩家补签
write(32016) ->
	{rep_player_repair_sig, [16]};
%% 玩家领取签到奖励
write(32017) ->
	{rep_player_sign_reward, [16]};
%% 限时活动通知
write(32018) ->
	{rep_active_time_notice, [8, [8]]};
%% 获取开服活动类型列表
write(32019) ->
	{rep_get_active_service_type_list, [[proto_active_service_type_info]]};
%% 获取运营活动信息列表
write(32020) ->
	{rep_get_operate_active_info, [[proto_operate_active_info], [proto_operate_active_info_model_2], [proto_operate_active_info_model_3]]};
%% 领取运营活动奖励
write(32021) ->
	{rep_receive_reward, [16]};
%% 开始答题
write(32030) ->
	{rep_exam_start, [16, 8, 8, 8, [32], 32, 32]};
%% 答题
write(32031) ->
	{rep_exam_choice, [16, 32, 8, 32, 8, 8, 32, 32]};
%% 答题排行
write(32032) ->
	{rep_exam_rank, [[proto_exam_rank_info]]};
%% 积分双倍道具
write(32033) ->
	{rep_exam_tool, [16, 8, [string], 8]};
%% 触发活动条件
write(32034) ->
	{rep_activity_trigger, [16]};
%% 获取活动相关排名
write(32035) ->
	{rep_active_rank, [32, 32, [proto_active_rank_info]]};
%% 获取节日活动信息列表
write(32036) ->
	{rep_get_operate_holiday_active_info, [[proto_operate_holiday_active_info]]};
%% 功能预告礼包状态
write(32037) ->
	{rep_function_notice_state, [32]};
%% 功能预告礼包领取
write(32038) ->
	{rep_function_notice_get, [16]};
%% 获取服务器排名活动列表
write(32040) ->
	{rep_active_service_rank_list, [16, string, 32, 32, [proto_active_service_rank_info]]};
%% 获取服务器排名活动列表
write(32041) ->
	{rep_active_shop_list, [32, 32, [proto_active_shop]]};
%% 获取活动相关排名
write(32042) ->
	{rep_buy_active_shop, [32, proto_active_shop]};
%% 获取节日活动兑换信息列表
write(32044) ->
	{rep_get_operate_holiday_change_info, [[proto_operate_holiday_change_info]]};
%% 领取运营活动奖励
write(32045) ->
	{rep_new_receive_reward, [32, 8, 16, 16]};
%% 获取活动信息
write(32046) ->
	{rep_get_type_active_info, [[proto_active_info]]};
%% 获取拍卖的物品信息-类型
write(33000) ->
	{rep_get_sale_goodslist, [32, [proto_sale_info]]};
%% 获取拍卖的物品信息-模糊搜索
write(33001) ->
	{rep_get_sale_goodslist_name, [32, [proto_sale_info]]};
%% 获取玩家上架的物品列表
write(33002) ->
	{rep_get_sale_sell_goodslist, [[proto_sale_info]]};
%% 玩家查看领取物品信息
write(33003) ->
	{rep_get_player_sale_goods_list, [[proto_player_sale_info]]};
%% 玩家上架物品
write(33004) ->
	{rep_add_sale, [16]};
%% 玩家购买拍卖物品
write(33005) ->
	{rep_buy_sale, [16]};
%% 物品下架
write(33006) ->
	{rep_del_sale, [16]};
%% 玩家领取物品
write(33007) ->
	{rep_receive_sale_goods, [16]};
%% 获取交易税
write(33008) ->
	{rep_get_sale_tax, [16]};
%% 获取出售需要的金币
write(33009) ->
	{rep_get_sale_sell, [32]};
%% 获取出售需要的金币
write(33010) ->
	{rep_get_receive_sale_goods_coin, [32]};
%% 领取开服红包信息
write(34000) ->
	{rep_receive_red, [32]};
%% 开服红包可以领取的状态推送
write(34001) ->
	{rep_send_red_info, [64]};
%% 获取抽奖日志
write(35000) ->
	{rep_get_lottery_info, [[proto_lottery_log_info], [proto_lottery_goods_info], 32, 32, 32, 32]};
%% 开始抽奖
write(35001) ->
	{rep_lottery_begin, [[32], [proto_goods_info], [proto_equips_info], 32]};
%% 抽奖日志推送
write(35002) ->
	{rep_send_lottery_log_list, [[proto_lottery_log_info]]};
%% 获取神皇秘境抽奖日志
write(35004) ->
	{rep_lottery_info_shmj, [[proto_lottery_log_info], [proto_lottery_log_info], 32, 32, 32, 32, 32, 32, 32]};
%% 神皇秘境开始抽奖
write(35005) ->
	{rep_lottery_begin_shmj, [[32], [proto_goods_info], [proto_equips_info], 32, 32]};
%% 神皇秘境抽奖积分兑换物品
write(35006) ->
	{rep_lottery_exchange_shmj, [32, 32]};
%% 抽奖日志推送
write(35007) ->
	{rep_lottery_log_shmj, [8, [proto_lottery_log_info]]};
%% 获取抽奖日志
write(36000) ->
	{rep_get_lottery_coin_log_list, [[proto_lottery_log_info]]};
%% 开始抽奖
write(36001) ->
	{rep_lottery_coin_begin, [[32], [proto_goods_info], [proto_equips_info], 32]};
%% 抽奖日志推送
write(36002) ->
	{rep_send_lottery_coin_log_list, [[proto_lottery_log_info]]};
%% 创建军团
write(37001) ->
	{rep_create_legion, [16, 32]};
%% 获取入帮条件
write(37002) ->
	{rep_enter_legion_cond, [32, 16]};
%% 设置入帮条件
write(37003) ->
	{rep_set_legion_cond, [32, 16]};
%% 获取所有军团总数
write(37004) ->
	{rep_get_legion_num, [16]};
%% 获取军团列表
write(37005) ->
	{rep_get_legion_list, [[proto_legion_info]]};
%% 申请加入军团
write(37006) ->
	{rep_apply_enter_legion, [16]};
%% 获取申请军团人数
write(37007) ->
	{rep_apply_legion_num, [16]};
%% 获取申请列表
write(37008) ->
	{rep_apply_legion_info, [16, 16, [proto_apply_legion_info]]};
%% 同意玩家加入军团
write(37009) ->
	{rep_agree_join_legion, [64, 8, 16]};
%% 获取军团详细信息
write(37010) ->
	{rep_legion_detailed_info, [proto_legion_detailed_info]};
%% 获取玩家军团信息
write(37011) ->
	{rep_get_legion_member_info, [proto_player_legion_info]};
%% 获取军团成员信息列表
write(37012) ->
	{rep_legion_member_info_list, [16, 16, [proto_legion_member_info]]};
%% 退出军团
write(37013) ->
	{rep_leave_legion, [16]};
%% 解除军团
write(37014) ->
	{rep_remove_legion, [16]};
%% 获取军团人数
write(37015) ->
	{rep_get_legion_member_num, [16]};
%% 修改帮会公告
write(37016) ->
	{rep_write_announce_legion, [16]};
%% 获取军团成员详细信息
write(37017) ->
	{rep_get_member_info_legion, [64, string, 16, 8, 16, 32, [proto_equips_info], proto_guise, 16]};
%% 剔除成员
write(37018) ->
	{rep_reject_member_legion, [16]};
%% 委任职位
write(37019) ->
	{rep_appoint_member_legion, [64, 8, 16]};
%% 清空申请列表
write(37020) ->
	{rep_clear_apply_list_legion, [16]};
%% 行会日志信息
write(37053) ->
	{rep_legion_log_info, [[proto_legion_log_info]]};
%% 邀请加入行会返回
write(37054) ->
	{rep_legion_ask, [16]};
%% 推送的玩家行会邀请信息
write(37055) ->
	{rep_legion_ask_player_info, [string, string, string]};
%% 同意会长得邀请返回
write(37056) ->
	{rep_legion_agree_ask, [16]};
%% 获取开服活动相关列表
write(38012) ->
	{rep_active_service_merge_list, [32, 32, 32, [proto_active_service_info]]};
%% 领取开服活动奖励
write(38013) ->
	{rep_receive_merge_goods, [16, 32]};
%% 获取开服活动类型列表
write(38019) ->
	{rep_get_active_service_merge_type_list, [[proto_active_service_type_info]]};
%% 获取服务器排名活动列表
write(38040) ->
	{rep_active_service_merge_rank_list, [16, string, 32, 32, [proto_active_service_rank_info]]};
%% 商店物品礼包
write(38041) ->
	{rep_active_shop_merge_list, [32, 32, [proto_active_shop]]};
%% 返回刷新礼包信息
write(38042) ->
	{rep_buy_active_merge_shop, [32, proto_active_shop]};
write(N) ->
	Trace = try throw(42) catch 42 -> erlang:get_stacktrace() end, 
	?ERR("undefined write protocol ~p ~p", [N,Trace]).

