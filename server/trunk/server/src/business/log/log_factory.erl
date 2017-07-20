%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 五月 2016 下午4:47
%%%-------------------------------------------------------------------
-module(log_factory).
-author("qhb").

-include("common.hrl").

%% API
-export([
	get_poolId/1,
	get_tablename/1,
	log_db/1,
	get_create_sql/1
]).

%%获取日志存储数据库的连接
get_poolId(db_log_shop_once) ->
	?DB_POOL_DATA;
get_poolId(_) ->
	?DB_POOL_LOG.

%%自定义日志存储的表名
get_tablename(db_log_shop_once) ->
	"log_shop_once";
get_tablename(RecName) ->
	{{NowYear, NowMonth, _}, {_, _, _}} = calendar:local_time(),
	TableName = re:replace(lists:concat([RecName, '_', NowYear, NowMonth]), "db_", "", [{return, list}]),
	TableName.

log_db(Rc) ->
	cache_log_lib:insert(Rc).

get_create_sql(db_log_chat) ->
	Sql = "
			CREATE TABLE ~s (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '角色id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '聊天内容',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='聊天记录';
		  ",
	Sql;
get_create_sql(db_log_dead) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `reason` int(11) DEFAULT NULL COMMENT '原因,1玩家，2怪物',
			  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='死亡记录';
		  ",
	Sql;
get_create_sql(db_log_trade) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id1` bigint(20) DEFAULT NULL COMMENT '玩家1',
			  `player_name1` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家1昵称',
			  `goods_info1` varchar(1000) DEFAULT NULL COMMENT '物品列表1',
			  `jade1` int(11) DEFAULT NULL COMMENT '元宝1',
			  `player_id2` bigint(20) DEFAULT NULL COMMENT '玩家2',
			  `player_name2` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家2昵称',
			  `goods_info2` varchar(1000) DEFAULT NULL COMMENT '物品列表2',
			  `jade2` int(11) DEFAULT NULL COMMENT '元宝2',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `type` int(11) DEFAULT NULL COMMENT '交易方式,1交易所，2当面',
			  `createtime` int(11) DEFAULT NULL COMMENT '交易时间',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='交易记录';
		  ",
	Sql;
get_create_sql(db_log_goods) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `goods_id` bigint(20) DEFAULT NULL COMMENT '物品id',
			  `num` int(11) DEFAULT NULL COMMENT '物品数量',
			  `current_num` int(11) DEFAULT NULL COMMENT '当前物品数量',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品数量记录';
		  ",
	Sql;
get_create_sql(db_log_goods_attr) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `gid` bigint(20) DEFAULT NULL COMMENT '玩家物品id',
			  `goods_id` bigint(20) DEFAULT NULL COMMENT '物品id',
			  `attrs_old` text COMMENT '旧属性',
			  `attrs_new` text COMMENT '新属性',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品属性记录';
		  ",
	Sql;
get_create_sql(db_log_fight) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `fight_old` int(11) DEFAULT NULL COMMENT '旧战力',
			  `fight_new` int(11) DEFAULT NULL COMMENT '新战力',
			  `attrs_old` text COMMENT '旧属性',
			  `attrs_new` text COMMENT '新属性',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战力记录';
		  ",
	Sql;
get_create_sql(db_log_reputation) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `num` int(11) DEFAULT NULL COMMENT '变化数量',
			  `current_num` int(11) DEFAULT NULL COMMENT '当前数量',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='声望记录';
		  ",
	Sql;
get_create_sql(db_log_drop) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `obj_id` bigint(20) DEFAULT NULL COMMENT '对像id',
			  `obj_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '对像名称',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `owner_id` bigint(20) DEFAULT NULL COMMENT '归属id',
  			  `team_id` bigint(20) DEFAULT NULL COMMENT '归属队伍id',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `obj_type` int(11) DEFAULT NULL COMMENT '对像类型，1玩家，2怪物',
			  `scene_id` int(11) DEFAULT NULL COMMENT '对像id',
			  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
			  `goods_id` int(11) DEFAULT NULL COMMENT '物品id',
			  `is_bind` int(11) DEFAULT NULL COMMENT '是否绑定',
			  `num` int(11) DEFAULT NULL COMMENT '数量',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='怪物掉落记录';
		  ",
	Sql;
get_create_sql(db_log_login) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `openid` varchar(128) DEFAULT NULL COMMENT '账号',
			  `plat` int(11) DEFAULT NULL COMMENT '渠道',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `login_time` int(11) DEFAULT NULL COMMENT '登录时间',
			  `logout_time` int(11) DEFAULT NULL COMMENT '登出时间',
			  `type` int(11) DEFAULT NULL COMMENT '类型，0账号，1角色',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录登出记录';
		  ",
	Sql;
get_create_sql(db_log_mail) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `mail_id` int(11) DEFAULT NULL COMMENT '邮件id',
			  `mail_type` int(11) DEFAULT NULL COMMENT '邮件类型',
			  `sender` varchar(100) DEFAULT NULL COMMENT '发送者',
			  `title` varchar(100) DEFAULT NULL COMMENT '标题',
			  `content` varchar(1024) DEFAULT NULL COMMENT '邮件内容',
			  `award` varchar(500) DEFAULT NULL COMMENT '邮件奖励',
			  `send_time` int(11) DEFAULT NULL COMMENT '发送时间',
			  `limit_time` int(11) DEFAULT NULL COMMENT '到期时间',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件接收记录';
		  ",
	Sql;
get_create_sql(db_log_daily) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `reason` int(11) DEFAULT NULL COMMENT '原因',
			  `jade` int(11) DEFAULT 0 COMMENT '使用元宝数',
			  `status` int(11) DEFAULT 0 COMMENT '状态,0未完成1完成10开始11结束',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日常记录';
		  ",
	Sql;
get_create_sql(db_log_monster_kill) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `monster_id` bigint(20) DEFAULT NULL COMMENT '怪物id',
			  `monster_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '怪物名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
			  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
			  `begin_time` int(11) DEFAULT NULL COMMENT '开始时间',
			  `duration` int(11) DEFAULT NULL COMMENT '时长',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='怪物击杀时长';
		  ",
	Sql;
get_create_sql(db_log_instance_activity) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
			  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
			  `enter_time` int(11) DEFAULT NULL COMMENT '进入时间',
			  `exit_time` int(11) DEFAULT NULL COMMENT '离开时间',
			  `duration` int(11) DEFAULT NULL COMMENT '时长',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='副本记录';
		  ",
	Sql;
get_create_sql(db_log_instance_single) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
			  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
			  `enter_time` int(11) DEFAULT NULL COMMENT '进入时间',
			  `exit_time` int(11) DEFAULT NULL COMMENT '离开时间',
			  `duration` int(11) DEFAULT NULL COMMENT '时长',
			  `jade` int(11) DEFAULT NULL COMMENT '使用元宝',
			  `completed` int(11) DEFAULT NULL COMMENT '完成',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人副本记录';
		  ",
	Sql;
get_create_sql(db_log_activity) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `activity_id` int(11) DEFAULT NULL COMMENT '活动id',
			  `lv` int(11) DEFAULT NULL COMMENT '玩家级别',
			  `vip` int(11) DEFAULT NULL COMMENT 'vip等级',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='运营活动领取记录';
		  ",
	Sql;
get_create_sql(db_log_insurance) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `goods_id` bigint(20) DEFAULT NULL COMMENT '物品id',
			  `num` int(11) DEFAULT NULL COMMENT '投保数量',
			  `current_num` int(11) DEFAULT NULL COMMENT '当前投保数量',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物品投保记录';
		  ",
	Sql;
get_create_sql(db_log_shop_once) ->
	Sql = "
			CREATE TABLE `~s` (
			  `id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
			  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
			  `server_id` int(11) DEFAULT NULL COMMENT '区服',
			  `createtime` int(11) DEFAULT NULL COMMENT '时间',
			  `goods_id` bigint(20) DEFAULT NULL COMMENT '物品id',
			  `num` int(11) DEFAULT NULL COMMENT '数量',
			  `cost` int(11) DEFAULT NULL COMMENT '花费',
			  PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='一生一次购买记录';
		  ",
	Sql;
get_create_sql(TableName) ->
	?WARNING("create_table(~p)sql ~n", [TableName]),
	[].