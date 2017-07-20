ALTER TABLE `log_drop_20169` ADD COLUMN `owner_id` bigint(20) DEFAULT NULL COMMENT '归属id' AFTER `server_id`;
ALTER TABLE `log_drop_20169` ADD COLUMN `team_id` bigint(20) DEFAULT NULL COMMENT '归属队伍id' AFTER `owner_id`;

ALTER TABLE `log_drop_20168` ADD COLUMN `owner_id` bigint(20) DEFAULT NULL COMMENT '归属id' AFTER `server_id`;
ALTER TABLE `log_drop_20168` ADD COLUMN `team_id` bigint(20) DEFAULT NULL COMMENT '归属队伍id' AFTER `owner_id`;