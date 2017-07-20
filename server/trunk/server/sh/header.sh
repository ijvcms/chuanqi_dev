#!/bin/bash
# 头文件
# @author: zhengsiying
# @date: 2015.04.09
#

ERL_COOKIE=cq_game_erl
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # 运行脚本目录
cd ${SCRIPT_PATH}
cd ../
PROJECT_PATH=`pwd` # ERL服务端安装目录
CONFIG_PATH=${PROJECT_PATH}/config # 配置目录
LOG_PATH=${PROJECT_PATH}/log # 日志目录
DB_SCRIPT_PATH=${PROJECT_PATH}/db_script # 数据库脚本目录