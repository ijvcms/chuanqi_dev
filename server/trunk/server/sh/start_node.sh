#!/bin/bash
# 开启节点
# @author: zhengsiying
# @date: 2015.04.09
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${CONFIG_PATH}

fun_start_node(){
	NODE_NAME=$1
	NODE_NUM=$2
	erl +P 1024000 \
		-smp auto \
		-name ${NODE_NAME}_${NODE_NUM}@${DOMAIN} \
		-setcookie ${ERL_COOKIE} \
		-boot start_sasl \
		-config ${NODE_NAME}_${NODE_NUM} \
		-pa ../ebin \
		-detached \
		-kernel inet_dist_listen_min 40001 inet_dist_listen_max 40100 \
		-hidden \
		-s main server_start \
		-- node_${NODE_NAME}
}

START_DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo ""
echo "========================================================="
echo "start ${1} ${2} node, data: ${START_DATE} ip:${DOMAIN}"
echo "---------------------------------------------------------"

fun_start_node $1 $2