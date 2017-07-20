CREATE TABLE `player_shop_once` (
  `player_id` bigint(20) NOT NULL,
  `lv` int(11) NOT NULL COMMENT '级别',
  `pos` smallint(6) NOT NULL DEFAULT '0' COMMENT '位置',
  `state` smallint(6) DEFAULT '0' COMMENT '购买状态0未购买，1已购买',
  `goods_id` int(11) DEFAULT NULL COMMENT '物品id',
  `goods_num` int(11) DEFAULT '0' COMMENT '物品数量',
  `add_time` int(11) DEFAULT '0' COMMENT '添加时间',
  `expire_time` int(11) DEFAULT '0' COMMENT '过期时间',
  `buy_time` int(11) DEFAULT '0' COMMENT '购买时间',
  `money` int(11) DEFAULT '0' COMMENT '金额',
  PRIMARY KEY (`player_id`,`lv`,`pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='一生一次性礼包状态';