#!/bin/bash
# 合服
# @author: qhb
# @date: 2016.10.25
#

MERGE_DB_LIST=(8031 8032)
MERGE_DB_RANGE=(8031 8032)
MERGE_HOST="59.110.18.25"
MERGE_TIMES=1

DBUSER=root
DBPWD=123456
MYSQL_PATH=/usr/local/mysql
DB_BACKUP_DIR=/mnt/merge
source `dirname $0`/merge_cfg/merge_cfg.sh

app=$2
merge_db=chuanqi_db_0
init_env(){
	#source `dirname $0`/merge_cfg/merge_cfg.sh

	if [ -z "$app" ];then
    		app=1
    fi
    merge_db=$MERGE_DB_PRE$app

	cfg_file=`dirname $0`/merge_cfg/merge_cfg_$app.sh
	if [ -f $cfg_file ];then
		source $cfg_file
	else
		echo "miss config file $cfg_file"
		exit 1
	fi

	bak_dir=$DB_BACKUP_DIR/`date +%Y%m%d`
	if [ ! -d $bak_dir ];then
		mkdir $bak_dir
	fi
	log_dir=$DB_BACKUP_DIR/log
	if [ ! -d $log_dir ];then
		mkdir $log_dir
	fi
}
confirm(){
	echo -n "continue?[y/n/yes/no]: "
	read input

	ret=`echo $input | tr '[a-z]' '[A-Z]' | cut -c1`

	if [ $ret = "Y" ]; then
	  echo "start."
	else
	  exit 1
	fi
}
init_env

fun_before(){
	echo "------------------------------------------------"
}

fun_clean_db(){
	today=`date +%Y-%m-%d`
	merge_time="$today 18:00:00"
	sid_start=${MERGE_DB_RANGE[0]}
	sid_end=${MERGE_DB_RANGE[1]}
	port=$[10000+sid_end]
	port_b=$[20000+sid_end]
	db_sql="mysql://yu:123456@127.0.0.1:3306/chuanqi_db_$sid_end"
	index=0
	#修改数据库连接
	sqls[index++]="update chuanqi_mg.my_service set begin_time=UNIX_TIMESTAMP('$merge_time'),merge_time=UNIX_TIMESTAMP('$merge_time'),merge_times=$MERGE_TIMES where service_id>=$sid_start and service_id<=$sid_end;"
	sqls[index++]="update chuanqi_mg.my_service set service_port=$port,port=$port_b,service_merge=$sid_end where service_id>=$sid_start and service_id<=$sid_end;"
	sqls[index++]="update chuanqi_mg.my_service set ip='$MERGE_HOST',db_sql='$db_sql' where service_id>=$sid_start and service_id<=$sid_end;"
	sqls[index++]="update chuanqi_mg.my_ga set server_id=$sid_end where server_id>=$sid_start and server_id<=$sid_end;"
	
	#清除游戏库无用数据
	clean_time="$today 10:00:00"
	count_db=${#MERGE_DB_LIST[*]}
	for((i=0;i<$count_db;i++));
	do
		s1="delete from chuanqi_db_${MERGE_DB_LIST[$i]}.player_mail where limit_time<UNIX_TIMESTAMP('$clean_time');"
		sqls[index++]=$s1
	done

	#生成准备清理的sql文件
	sql_file=$DB_BACKUP_DIR/`date +%Y%m%d`/clean_$sid_end.sql
	echo "-- merge sql" > $sql_file
	count_sql=${#sqls[*]}
	for((i=0; i<$count_sql; i++));
	do
		echo ${sqls[$i]} >> $sql_file
	done

	fun_log "clean&update"
	fun_log "$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD < $sql_file"
	$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD < $sql_file
}

#备份游戏数据库
fun_backup(){
	fun_log "backup"
	count=${#MERGE_DB_LIST[*]}
	for((i=0;i<${count};i++));
	do
		item=${MERGE_DB_LIST[$i]}
        db_name=chuanqi_db_$item

		bak_dir=$DB_BACKUP_DIR/`date +%Y%m%d`
		bak_file=$bak_dir/$db_name.dump_`date +%Y%m%d`.sql
		if [ -f $bak_file ];then
			echo "exist file $bak_file"
			exit 1
		fi

        fun_log "$MYSQL_PATH/bin/mysqldump --opt -u$DBUSER -p$DBPWD $db_name > $bak_file"
        $MYSQL_PATH/bin/mysqldump --opt -u$DBUSER -p$DBPWD $db_name > $bak_file
	done
}

#导出数据库结构
fun_struct(){
	sid_end=${MERGE_DB_RANGE[1]}
	db_name=chuanqi_db_$sid_end
	struct_file=$bak_dir/chuanqi_db_$sid_end.struct.sql
	fun_log "export struct"
	fun_log "$MYSQL_PATH/bin/mysqldump -u$DBUSER -p$DBPWD -d $db_name > $struct_file"
	$MYSQL_PATH/bin/mysqldump -u$DBUSER -p$DBPWD -d $db_name > $struct_file
}

#初始化合并数据库
fun_init_merge_db(){
	sid_end=${MERGE_DB_RANGE[1]}
	db_name=$merge_db
	struct_file=$bak_dir/chuanqi_db_$sid_end.struct.sql
	fun_log "init merge db"
	fun_log "$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD $db_name < $struct_file"
	$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD $db_name < $struct_file
}

#更新程序配置
fun_config(){
	apppath=${path_map[$app]}
	if [ "$apppath" == "" ];then
			apppath=.
	fi

	fun_log "update config ${app}"
	db_list_str="${MERGE_DB_LIST[*]}"
	db_list_str=${db_list_str// /,}
	sed -i "s/{source_servers, .*}/{source_servers, [$db_list_str]}/g" $apppath/config/merge_$app.config
}

#启动合服
fun_start(){
	apppath=${path_map[$app]}
	if [ "$apppath" == "" ];then
			apppath=.
	fi

	cmd="$apppath/sh/restart_one.sh merge $app"
	fun_log "start ${app}:$cmd"
	$cmd

	sleep 5
	fun_start_app
}

fun_start_app(){
	NODE_NAME="merge"
	NODE_NUM=$app
	DOMAIN=10.45.15.33
	ERL_COOKIE=td_game_erl
	if [ $app = 2 ];then
			ERL_COOKIE=td_game_erl
	elif [ $app = 6 ];then
			ERL_COOKIE=td_game_erl
	elif [ $app = 7 ];then
			ERL_COOKIE=td_game_erl_wojiao
	elif [ $app = 8 ];then
			ERL_COOKIE=td_game_erl_bt
	elif [ $app = 9 ];then
			ERL_COOKIE=td_game_erl
	else
			ERL_COOKIE=td_game_erl
	fi
	erl -noshell -hidden -name stop_${NODE_NAME}_${NODE_NUM}@${DOMAIN} -setcookie ${ERL_COOKIE} -pa ../ebin -eval "rpc:call('${NODE_NAME}_${NODE_NUM}@${DOMAIN}', merge_lib, start, [])." -s c q
}


#导出合并后数据库
fun_export_merge_db(){
	sid_end=${MERGE_DB_RANGE[1]}
	db_name=$merge_db
	export_file=$bak_dir/chuanqi_db_${app}_$sid_end.sql
	if [ -f $export_file ];then
		echo "exist file $export_file"
		exit 1
	fi
	fun_log "export merge db ${app}"
	fun_log "$MYSQL_PATH/bin/mysqldump -u$DBUSER -p$DBPWD $db_name > $export_file"
	$MYSQL_PATH/bin/mysqldump -u$DBUSER -p$DBPWD $db_name > $export_file
}

#导入合并了的数据库
fun_import_merge_db(){
	sid_end=${MERGE_DB_RANGE[1]}
	db_name=chuanqi_db_$sid_end
	import_file=$bak_dir/chuanqi_db_${app}_$sid_end.sql
	if [ ! -f $import_file ];then
		echo "not exist file $import_file"
		exit 1
	fi
	fun_log "import merge db ${app}"
	fun_log "$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD $db_name < $import_file"
	$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD $db_name < $import_file
}

#开始合服
fun_merge(){
	fun_log "--------- start merge ---------"
}

#维护时间
fun_begine_time(){
	#sid_start=${MERGE_DB_RANGE[0]}
    #sid_end=${MERGE_DB_RANGE[1]}
    sid_start=$2
    sid_end=$3
	today=`date +%Y-%m-%d`
	sql="update chuanqi_mg.my_service set begin_time=UNIX_TIMESTAMP('$today $1') where service_id between $sid_start and $sid_end"
	fun_log "$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD -e \"$sql\""
	$MYSQL_PATH/bin/mysql -u$DBUSER -p$DBPWD -e "$sql"
}

#输出日志
fun_log(){
	logtime=`date +%Y-%m-%d\ %H:%M:%S`
	echo [$logtime] $1 |tee -a $log_dir/merge_`date +%Y%m%d`.log
}

_func_echo(){
	echo "dblist:("${MERGE_DB_LIST[@]:0}") range:["${MERGE_DB_RANGE[@]:0}"]"
	echo "ip:$MERGE_HOST"
	echo "times:$MERGE_TIMES"
	echo "app:$app"
	echo "merge_db:$merge_db"
}

func_help(){
	_func_echo;
}


case $1 in
	ready)
		_func_echo;
		confirm;
		fun_before;
		fun_clean_db;
		fun_backup;
		fun_struct;
		fun_init_merge_db;
		fun_merge;
		;;
	config)
    		fun_config;
    		;;
    start)
    		fun_config;
			fun_start;
			;;
	export)
		fun_export_merge_db;
		;;
	import)
		fun_import_merge_db;
		;;
	ini_merge)
		fun_init_merge_db;
		;;
	begin_time)
		fun_begine_time $3 $4 $5;
		;;
	test)
		fun_before;
		fun_struct;
		fun_init_merge_db;
		fun_merge;
		;;		
	*)
		func_help
		;;	
esac


#erl -noshell -hidden -name stop_${NODE_NAME}_${NODE_NUM}@${DOMAIN} -setcookie ${ERL_COOKIE} -pa ../ebin -eval "rpc:call('${NODE_NAME}_${NODE_NUM}@${DOMAIN}', u, u, [])." -s c q
