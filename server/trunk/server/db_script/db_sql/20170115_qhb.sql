
ALTER TABLE `player_goods` ADD COLUMN `server_id` int DEFAULT 0 COMMENT '区服id' AFTER `expire_time`;