#!/bin/bash
# kill服务器
# @author: zhengsiying
# @date: 2015.04.09
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

NODE_NAME=$1
NODE_NUM=$2
NODE_FLAG=${NODE_NAME}_${NODE_NUM}
PID=`ps -ef | grep "\-name ${NODE_FLAG}@${DOMAIN}" | grep erl | awk '{print $2}'`
if [ -n "${PID}" ]; then
    kill -9 ${PID}
fi