#!/bin/bash
# 关闭节点
# @author: zhengsiying
# @date: 2015.04.09
#
source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${CONFIG_PATH}

NODE_NAME=$1
NODE_NUM=$2
erl -noshell -hidden -name stop_${NODE_NAME}_${NODE_NUM}@${DOMAIN} -setcookie ${ERL_COOKIE} -pa ../ebin -eval "rpc:call('${NODE_NAME}_${NODE_NUM}@${DOMAIN}', main, server_stop, [])." -s c q

# echo "-------------------------------------------"
# echo "stop ${1}_${2} node"
# echo "-------------------------------------------"