#!/bin/bash
# kill服务器
# @author: zhengsiying
# @date: 2015.04.09
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

${SCRIPT_PATH}/stop_all.sh

NODE_COUNT=${#NODES[*]}
for ((i=0; i<${NODE_COUNT}; i++));
do
    NODE=(${NODES[$i]})
	NODE_NAME=${NODE[0]}
	NODE_NUM=${NODE[1]}
	./kill_one.sh ${NODE_NAME} ${NODE_NUM}
done
echo "kill success"