#!/bin/bash
# 热更
# @author: zhengsiying
# @date: 2015.04.09
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${CONFIG_PATH}

NODE_COUNT=${#NODES[*]}
for ((i=0; i<${NODE_COUNT}; i++));
do
    NODE=(${NODES[$i]})
    NODE_NAME=${NODE[0]}
    NODE_NUM=${NODE[1]}
    erl -noshell -hidden -name stop_${NODE_NAME}_${NODE_NUM}@${DOMAIN} -setcookie ${ERL_COOKIE} -pa ../ebin -eval "rpc:call('${NODE_NAME}_${NODE_NUM}@${DOMAIN}', u, u, [])." -s c q
done