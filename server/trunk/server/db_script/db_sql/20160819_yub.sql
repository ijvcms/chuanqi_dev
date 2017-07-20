drop table if exists player_active_service_record;
CREATE TABLE `player_active_service_record` (
  `player_id` bigint(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `active_service_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '开服活动类型id记录',
  `value` int(11) DEFAULT '0' COMMENT '玩家值记录',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`player_id`,`active_service_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开服活动记录';

alter table `player_base` drop column stren_lv_sum;
alter table `player_base` drop column wing_lv;
alter table `player_base` drop column medal_lv;
alter table `player_base` drop column mark_lv;