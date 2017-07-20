%% 存储玩具信息
-define(ETS_PLAYER_STATE, ets_player_state).
-record(ets_player_state, {
    player_id = 0, %% 玩家id
    server_pass = null,%% 玩家来源地址
    socket = null, %% socket
    pid = null, %% 玩家pid
    name,%% 玩家名字
    guild_id,   %%行会id
    mian_pid, %% 跨服玩家pid
    equiplist, %% 装备列表
    goodslist, %% 背包列表
    bag_cell = 0, %% 剩余背包数量
    login_time = 0 %% 进入时间
}).

%% 存储玩具信息
-define(ETS_CROSS_SERVER, ets_cross_server).
-record(ets_cross_server, {
    server_id = 0, %% 服务器id
    server_pass = null%% 服务器地址
}).


-record(mian_player_state, {
}).

%% 存储行会信息
-define(ETS_GUILD_INFO, ets_guild_info).
-record(ets_guild_info, {
    guild_id = 0, %% 行会id
    guild_name = <<"">>,
    server_no = 0,
    server = null
}).







