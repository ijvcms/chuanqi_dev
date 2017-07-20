@echo off

set COOKIE=chuanqi_mmo

set NODE=1
set GAME_NODE_NAME=chuanqi_game_%NODE%@127.0.0.1
set GAME_CONFIG_FILE=normal_1

set SMP=auto
set ERL_PROCESSES=102400

cd ../config
erl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -name %GAME_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %GAME_CONFIG_FILE% -s main server_start -- node_normal

pause