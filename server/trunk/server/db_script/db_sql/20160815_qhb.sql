

ALTER TABLE `player_monster_state` ADD COLUMN `hp_reset_time` int DEFAULT 0 COMMENT '满血刷新时间' AFTER `refresh_time`;