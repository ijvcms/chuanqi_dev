@echo off

rem -------------------------------------------
rem 控制脚本（windows版本）
rem -------------------------------------------

rem 主目录
set COOKIE=chuanqi_mmo

set NODE=1
set GAME_NODE_NAME=chuanqi_game_%NODE%@127.0.0.1
set GAME_CONFIG_FILE=normal_1

set SMP=auto
set ERL_PROCESSES=102400
set MMAKE_PROCESS=50

:fun_wait_input
	set inp=
	echo.
	echo ===============================
	echo make:编译服务端代码
	echo update:编译最新代码
	echo start:启动所有服务器
	echo debug:启动所有服务器(用于start启动服务器的时候服务器闪退，查看报错)
	echo game:启动游戏服
	echo cross:启动跨服
	echo clean:清理beam文件
	echo clean_log:清理日志
	echo all:kill、清理、编译、重启
	echo kill:kill服务
	echo quit:结束运行控制台
	echo -------------------------------
	set /p inp=请输入指令：
	echo -------------------------------
	goto fun_run

:where_to_go
	rem 区分是否带有命令行参数
	if [%1]==[] goto fun_wait_input
	goto end

:fun_run
	if [%inp%]==[all] goto fun_all
	if [%inp%]==[make] goto fun_make
	if [%inp%]==[update] goto fun_update
	if [%inp%]==[start] goto fun_start_all
	if [%inp%]==[game] goto fun_start_game
	if [%inp%]==[clean] goto fun_clean_beam
	if [%inp%]==[clean_log] goto fun_clean_log
	if [%inp%]==[kill] goto fun_kill
	if [%inp%]==[quit] goto end
	goto where_to_go

:fun_all
	taskkill /F /IM werl.exe
	cd ../ebin
	del *.beam
	cd ../logs
	rd /s /q flash
	rd /s /q cross
	rd /s /q game
	rd /s /q mgr
	cd ..
	erl -pa ./ebin -noshell -eval "mmake:all(%MMAKE_PROCESS%), init:stop()"
	cd config
	start werl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -name %GAME_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %GAME_CONFIG_FILE% -s main server_start -- node_normal
	goto where_to_go

:fun_make
	echo 稍等几分钟
	cd ../ebin
	del *.beam
	cd ..
	erl -pa ./ebin -noshell -eval "mmake:all(%MMAKE_PROCESS%), init:stop()"
	cd config
	goto where_to_go

:fun_update
	echo 稍等几分钟
	cd ..
	rem erl -pa ./ebin -make
	erl -pa ./ebin -noshell -eval "mmake:all(%MMAKE_PROCESS%), init:stop()" 
	cd config
	goto where_to_go

:fun_start_all
	cd ../config
	start werl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -name %GAME_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %GAME_CONFIG_FILE% -s main server_start -- node_normal
	goto where_to_go

:fun_start_game
	cd ../config
	start werl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -name %GAME_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %GAME_CONFIG_FILE% -s main server_start -- node_normal
	goto where_to_go

:fun_start_cross
	cd ../config
	start werl +P %ERL_PROCESSES% -smp %SMP% -env ERL_MAX_PORTS 5000 -pa ../ebin -name %CROSS_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %CROSS_CONFIG_FILE% -s main server_start -s reloader
	goto where_to_go

:fun_clean_beam
	cd ../ebin
	del *.beam
	goto where_to_go

:fun_clean_log
	cd ../logs
	rd /s /q flash
	rd /s /q cross
	rd /s /q game
	rd /s /q mgr
	cd ../config
	goto where_to_go

:fun_kill
	taskkill /F /IM werl.exe
	goto where_to_go

:end