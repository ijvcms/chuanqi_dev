CREATE TABLE `player_active_service_merge` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_service_merge_id` int(11) NOT NULL DEFAULT '0' COMMENT '合服活动id',
  `time` int(11) DEFAULT '0' COMMENT '领取时间',
  PRIMARY KEY (`player_id`,`active_service_merge_id`),
  KEY `fk_active_service_merge_id` (`active_service_merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='领取合服奖励表信息 ';

CREATE TABLE `player_active_service_record_merge` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_service_merge_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '合服活动类型id记录',
  `value` int(11) DEFAULT '0' COMMENT '玩家值记录',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`active_service_merge_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合服活动记录';

CREATE TABLE `player_monster_merge` (
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '击杀时间',
  `is_frist` tinyint(1) unsigned DEFAULT '0' COMMENT '是否是合服首杀 0不是 1是',
  `is_frist_goods` tinyint(1) unsigned DEFAULT '0' COMMENT '是否是领取合服首杀 0不是 1是',
  `is_goods` tinyint(1) unsigned DEFAULT '0' COMMENT '是否领取单次击杀 0不是 1是',
  PRIMARY KEY (`player_id`,`monster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家击杀boss怪物信息';





