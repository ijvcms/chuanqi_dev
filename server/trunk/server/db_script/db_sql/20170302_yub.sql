ALTER TABLE `player_base` ADD COLUMN `weapon_state` int DEFAULT 0 COMMENT '特武外观状态0显示 1不显示' AFTER `wing_state`;
DELETE FROM player_foe where tplayer_id not in (select player_id from player_base);