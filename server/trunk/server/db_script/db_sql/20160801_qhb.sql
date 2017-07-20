
ALTER TABLE `player_base` ADD COLUMN `instance_left_time` int DEFAULT 0 COMMENT '个人boss剩余时间' AFTER `is_robot`;

update player_base set instance_left_time=3600;