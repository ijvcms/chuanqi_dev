ALTER TABLE `player_mark` ADD COLUMN `mounts_mark_1` int(4) UNSIGNED DEFAULT 0 COMMENT '坐骑装备印记1' AFTER `holy_mark`, ADD COLUMN `mounts_mark_2` int(4) UNSIGNED DEFAULT 0 COMMENT '坐骑装备印记2' AFTER `mounts_mark_1`, ADD COLUMN `mounts_mark_3` int(4) UNSIGNED DEFAULT 0 COMMENT '坐骑装备印记3' AFTER `mounts_mark_2`, ADD COLUMN `mounts_mark_4` int(4) UNSIGNED DEFAULT 0 COMMENT '坐骑装备印记4' AFTER `mounts_mark_3`, CHANGE COLUMN `update_time` `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间' AFTER `mounts_mark_4`;