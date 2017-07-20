#!/bin/bash
# 用screen开启单独节点
# @author: zhengsiying
# @date: 2017.06.18
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${CONFIG_PATH}

fun_start_node(){
	NODE_NAME=$1
	NODE_NUM=$2
	erl +P 1024000 \
		-smp auto \
		-name debug_${NODE_NAME}_${NODE_NUM}@${DOMAIN} \
		-setcookie ${ERL_COOKIE} \
		-boot start_sasl \
		-config ${NODE_NAME}_${NODE_NUM} \
		-pa ../ebin \
		-remsh ${NODE_NAME}_${NODE_NUM}@${DOMAIN}
}

fun_start_node $1 $2