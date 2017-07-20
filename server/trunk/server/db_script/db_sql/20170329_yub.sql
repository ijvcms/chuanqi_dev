CREATE TABLE `guild_alliance` (
  `guild_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '工会id',
  `alliance_id` bigint(19) unsigned NOT NULL DEFAULT '0' COMMENT '结盟id',
  PRIMARY KEY (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='帮派结盟信息';