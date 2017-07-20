%%开发用配置

-record(restore_batch_conf, {
	player_id, %% 玩家id
	target_serverid, %% 当前区服(合服）
	source_serverid, %% 原区服(合服）
	server_id, %% 原区服（未合服）
	goods_clear, %% 清除物品
	goods_replace, %% 替换物品
	goods_add %% 新加或补偿物品
}).