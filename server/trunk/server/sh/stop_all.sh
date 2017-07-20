#!/bin/bash
# 关闭服务器
# @author: zhengsiying
# @date: 2015.04.09
#
source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

NODE_COUNT=${#NODES[*]}
for ((i=0; i<${NODE_COUNT}; i++));
do
	NODE=(${NODES[$i]})
	NODE_NAME=${NODE[0]}
	NODE_NUM=${NODE[1]}
	${SCRIPT_PATH}/stop_node.sh ${NODE_NAME} ${NODE_NUM}
done

sleep 2

STOP_ERR=
for ((i=0; i<${NODE_COUNT}; i++));
do
	NODE=(${NODES[$i]})
	NODE_NAME=${NODE[0]}
	NODE_NUM=${NODE[1]}
	NODE_FLAG=${NODE_NAME}_${NODE_NUM}
	PID=`ps -ef | grep "\-name ${NODE_FLAG}@${DOMAIN}" | grep erl | awk '{print $2}'`
	if [ ! ${PID} ]; then
		echo "stop ${NODE_FLAG}@${DOMAIN} success!"
	else
		STOP_ERR=true
		echo "stop ${NODE_FLAG}@${DOMAIN} fail!"
	fi
done

if [ ${STOP_ERR} ]; then
	echo "stop fail"
else
	echo "stop success"
fi