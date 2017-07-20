cd /d %~dp0
set NODE=1002
set COOKIE=ming_local
set NODE_NAME=ming%NODE%
set CONFIG_FILE=normal_%NODE%

set SMP=auto
set ERL_PROCESSES=102400

cd config
start werl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -sname %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %CONFIG_FILE% -s main server_start -- node_normal