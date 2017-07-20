
CREATE TABLE `player_monster_state` (
  `player_id` bigint(20) NOT NULL,
  `refresh_time` int(11) DEFAULT NULL COMMENT '刷新时间',
  `monster_state` text COMMENT '各场景怪物状态',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人boss怪物状态';