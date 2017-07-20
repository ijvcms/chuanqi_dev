#!/bin/bash
# 合服
# @author: qhb
# @date: 2016.10.25
#

#合服数据库
MERGE_DB_LIST=(101 102 103)

#合服服务器区间
MERGE_DB_RANGE=(101 103)

#合服后的IP
MERGE_HOST="123.56.196.102"

#合服次数
MERGE_TIMES=1

#合服临时数据库前缀
MERGE_DB_PRE=chuanqi_db_

#应用路径
declare -A path_map=()
path_map["1"]="/data/service/servier_1_4"
path_map["6"]="/data/sctl/server_6000"
path_map["7"]="/data/wojiao/server_7000"
path_map["8"]="/data/bt/server_8000"
path_map["9"]="/data/yuntiankong/server_9000"