#!/bin/bash
# 开启服务器
# @author: zhengsiying
# @date: 2015.04.09
#
#获取当前 sh 文件的目录

myPath=/mnt/data/sql_data/`date +%Y%m%d`

if [ ! -x $myPath ]; then
mkdir  $myPath
fi

NODES=("1016" "1020" "1024" "1032" "1040" "1048" "1056" "1064" "1065" "1066" "1067" "1068" "1069" "1070" "1071" "1072" "1073" "1074" "1075" "1076" "1077" "1078" "1079" "1080" "1081" "1082" "1083" "1084" "1085" "1086" "1087" "1088" "1089" "1090" "1091" "1092" "1093" "1094")

echo "======================================================="
#获取数组的 个数
NODE_COUNT=${#NODES[*]}
for ((i=0; i<${NODE_COUNT}; i++));
do
	if [ ${i} -gt 0 ]; then
		echo "-------------------------------------------------------"
	fi

	NODE=(${NODES[$i]})
	NODE_NAME=${NODE[0]}
	NODE_FLAG=chuanqi_db_${NODE_NAME}

	/usr/local/mysql/bin/mysqldump --opt -uroot -p123456 $NODE_FLAG | gzip \
    > $myPath/$NODE_FLAG.dump_`date +%Y%m%d_%H%M%S`.sql.gz
done

echo "======================================================="

/usr/local/mysql/bin/mysqldump --opt -uroot -p123456 chuanqi_mg | gzip \
> $myPath/chuanqi_mg.dump_`date +%Y%m%d_%H%M%S`.sql.gz


find /mnt/data/sql_data/  -mtime +5 -type f  -name "*.gz" | xargs rm -rf;
find /data/web/chuanqi/Runtime/LOG_LOGIN/  -mtime +5 -type f  -name "*.log" | xargs rm -rf;

