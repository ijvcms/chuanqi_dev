#!/bin/bash
# 开启服务器
# @author: zhengsiying
# @date: 2015.04.09
#
#获取当前 sh 文件的目录

myPath=/data/102db/db

if [ ! -x $myPath ]; then
mkdir  $myPath
fi

NODES=("1031" "1032" "1033" "1034" "1035" "1036" "1037" "1038" "1039" "1040" "1041" "1042" "1043" "1044" "1045" "1046" "1047" "1048" "1049" "1050" "1051" "1052")

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
	NODE_FLAG_LOG=chuanqi_log_${NODE_NAME}

	/usr/local/mysql/bin/mysql -uroot -p123456 $NODE_FLAG <$myPath/$NODE_FLAG.sql

    /usr/local/mysql/bin/mysql -uroot -p123456  $NODE_FLAG_LOG <$myPath/$NODE_FLAG_LOG.sql

done

echo "======================================================="


