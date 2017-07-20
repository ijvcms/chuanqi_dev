
ALTER TABLE `player_base` ADD COLUMN `lottery_num_1` int DEFAULT 0 COMMENT '神皇秘境抽奖次数' AFTER `state`,
ADD COLUMN `lottery_score_get_1` int DEFAULT 0 COMMENT '神皇秘境得到的积分' AFTER `lottery_num_1`,
ADD COLUMN `lottery_score_use_1` int DEFAULT 0 COMMENT '神皇秘境已经使用的积分' AFTER `lottery_score_get_1`;