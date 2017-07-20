

CREATE TABLE `player_monster_drop` (
  `id` bigint(20) NOT NULL,
  `player_id` bigint(20) DEFAULT NULL COMMENT '玩家id',
  `player_name` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家名称',
  `scene_id` int(11) DEFAULT NULL COMMENT '场景id',
  `monster_id` int(11) DEFAULT NULL COMMENT '怪物id',
  `monster_goods` varchar(1000) DEFAULT '' COMMENT '怪物掉落物品id列表',
  `add_time` int(11) DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='击杀boss的掉落';

CREATE TABLE `player_monster_follow` (
  `scene_id` int(11) NOT NULL COMMENT '场景',
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_id` bigint(20) NOT NULL COMMENT '玩家id',
  `open_id` varchar(128) DEFAULT NULL,
  `channel` int(11) DEFAULT NULL COMMENT '渠道',
  PRIMARY KEY (`scene_id`,`monster_id`,`player_id`),
  KEY `idx_player_id` (`player_id`) USING BTREE,
  KEY `idx_open_id` (`open_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家关注的boss';

CREATE TABLE `player_monster_killer_last` (
  `monster_id` int(11) NOT NULL COMMENT '怪物id',
  `player_name` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '玩家名字',
  `update_time` int(11) DEFAULT '0' COMMENT ' 更新时间',
  PRIMARY KEY (`monster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='击杀游荡boss的最后一个玩家';