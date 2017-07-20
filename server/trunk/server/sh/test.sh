#!/bin/bash
# 开启服务器
# @author: zhengsiying
# @date: 2015.04.09
#
#获取当前 sh 文件的目录
local_ip= ifconfig -a|awk '/(cast)/ {print $2}'|cut -d':' -f2|head -1

echo ${local_ip}
echo  "======================================================="

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${SCRIPT_PATH}
rm -rf ../log/*

chmod +x start_one.sh

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
	NODE_NUM=${NODE[1]}
	NODE_FLAG=${NODE_NAME}_${NODE_NUM}
	echo ${NODE_NAME}
	echo ${NODE_NUM}
done

echo "======================================================="

