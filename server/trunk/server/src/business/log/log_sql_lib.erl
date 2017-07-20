%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 三月 2016 11:11
%%%-------------------------------------------------------------------
-module(log_sql_lib).


-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-compile([export_all]).
get_sql(db_log_money, TableName) ->
	io_lib:format("CREATE TABLE ~s (
				  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
				  `num` int(11) DEFAULT '0' COMMENT '数量',
				  `current_num` bigint(20) DEFAULT '0' COMMENT '变化后的数量',
				  `key` int(11) DEFAULT '0' COMMENT '3，金币',
				  `type` int(11) DEFAULT '0' COMMENT '消耗的类型',
				  `time` int(11) unsigned DEFAULT '0' COMMENT '时间'
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
				", [TableName]);
get_sql(db_log_account, TableName) ->
	io_lib:format("CREATE TABLE ~s (
				  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '删除的玩家id',
				  `open_id` varchar(128) DEFAULT NULL COMMENT '账号',
				  `platform` int(11) DEFAULT '0' COMMENT '平台id',
				  `time` int(11) unsigned DEFAULT '0' COMMENT '删除时间'
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
				", [TableName]);
get_sql(db_log_exp, TableName) ->
	io_lib:format("CREATE TABLE ~s (
					  `id` bigint(20) NOT NULL AUTO_INCREMENT,
					  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
					  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '角色名',
					  `server_id` int(11) DEFAULT NULL COMMENT '区服',
					  `exp` bigint(11) DEFAULT NULL COMMENT '增加的经验值',
					  `old_exp` bigint(11) DEFAULT NULL COMMENT '原经验值',
					  `new_exp` bigint(11) DEFAULT NULL COMMENT '新的经验值',
					  `old_lv` int(11) DEFAULT NULL COMMENT '老等级',
					  `new_lv` int(11) DEFAULT NULL COMMENT '新等级',
					  `reason` int(11) DEFAULT NULL COMMENT '原因',
					  `createtime` int(11) DEFAULT NULL COMMENT '时间',
					  `message` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '额外信息 原因是92 场景id,怪物id',
					  PRIMARY KEY (`id`)
					) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家经验值变化记录';
					", [TableName]);
get_sql(TN, TableName) ->
	?ERR("not log talbe ~p ~p", [TN, TableName]).



