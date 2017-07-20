
CREATE TABLE `lottery_box_db` (
  `lottery_id` int(11) NOT NULL DEFAULT '0' COMMENT '奖励id',
  `day_num` int(11) DEFAULT '0' COMMENT '每次抽取次数记录',
  `ref_time` int(11) unsigned DEFAULT '0' COMMENT '刷新时间',
  PRIMARY KEY (`lottery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖箱每日数次记录';

CREATE TABLE `lottery_box_log` (
  `id` bigint(19) NOT NULL DEFAULT '0' COMMENT '编号id',
  `player_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `lottery_id` int(11) DEFAULT '0' COMMENT '奖励id',
  `lottery_type` int(11) DEFAULT '0' COMMENT '抽奖类型',
  `time` int(11) unsigned DEFAULT '0' COMMENT '抽取时间',
  `group_num` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '属于哪个轮数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖箱玩家记录';