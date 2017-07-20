#!/bin/bash
# 连接远程服务器
# @author: zhengsiying
# @date: 2015.05.27
#

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

cd ${CONFIG_PATH}

NODE_NAME=$1
MY_IP=`ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}'`
erl -name conn@${MY_IP} -setcookie ${ERL_COOKIE} -pa ../ebin -eval "net_adm:ping('${NODE_NAME}')."
