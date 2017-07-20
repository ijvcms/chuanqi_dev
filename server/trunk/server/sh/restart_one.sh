#!/bin/bash
# 用screen开启单独节点
# @author: zhengsiying
# @date: 2015.04.09
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${SCRIPT_PATH}

chmod +x start_node.sh

NODE_NAME=$1
NODE_NUM=$2
NODE_FLAG=${NODE_NAME}_${NODE_NUM}

PID=`ps -ef | grep "\-name ${NODE_FLAG}@${DOMAIN}" | grep erl | awk '{print $2}'`
SCREEN_PID=`ps -ef | grep "\-dmS ${NODE_FLAG}" | grep SCREEN | awk '{print $2}'`
if [ -n "${PID}" ] || [ -n "${SCREEN_PID}" ]; then
    ${SCRIPT_PATH}/stop_node.sh ${NODE_NAME} ${NODE_NUM}

    PID=`ps -ef | grep "\-name ${NODE_FLAG}@${DOMAIN}" | grep erl | awk '{print $2}'`
    SCREEN_PID=`ps -ef | grep "\-dmS ${NODE_FLAG}" | grep SCREEN | awk '{print $2}'`
    if [ -n "${PID}" ]; then
        kill ${PID}
    fi
    if [ -n "${SCREEN_PID}" ]; then
        kill ${SCREEN_PID}
    fi
    echo "stop ${NODE_FLAG}@${DOMAIN} success!"
fi

echo "start ${NODE_FLAG}"
screen -dmS ${NODE_FLAG} ${SCRIPT_PATH}/start_node.sh ${NODE_NAME} ${NODE_NUM}
sleep 5
PID=`ps -ef | grep "\-name ${NODE_FLAG}@${DOMAIN}" | grep erl | awk '{print $2}'`
if [ ! ${PID} ]; then
    echo "start ${NODE_FLAG}@${DOMAIN} fail!"
else
    echo "start ${NODE_FLAG}@${DOMAIN} success!"
fi