#!/bin/bash
# 服务器配置
# @author: zhengsiying
# @date: 2015.04.09
#

DOMAIN=127.0.0.1 # 机器ip
#DOMAIN=192.168.10.188 # 机器ip
# 机器ip
#DOMAIN= ifconfig -a|awk '/(cast)/ {print $2}'|cut -d':' -f2|head -1

# 节点信息格式如 ("节点类型 节点编号" ...)
NODES=("normal 1")

