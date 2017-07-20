#!/usr/bin/env bash
## 安装服务器运行环境

source `dirname $0`/header.sh
source ${SCRIPT_PATH}/config.sh

ulimit -SHn 102400
ulimit -c unlimited

export LC_CTYPE=en_US.UTF-8

## 配置日志记录
cd ${SCRIPT_PATH}

echo "============================================================"
echo "开始安装"
echo "-----------------------------------------------------------"
echo "安装screen"
case `uname -s` in
    Darwin)
        cp ./screenrc ~/.screenrc
        echo mac ok
        ;;
    Linux)
        TEMP=`yum list installed | grep screen`
        if [ -n "$TEMP" ];then
            echo screen installed
        elif [ -z "$TEMP" ];then
            yum install screen
            echo screen install ok
        fi
        cp ./screenrc ~/.screenrc
        echo linux ok
        ;;
    *)
        echo "error：未知系统"
        exit
        ;;
esac

## 创建数据库
echo "-----------------------------------------------------------"
echo "创建游戏数据库"
echo "请输入：用户名 密码 游戏数据库名"
user=${1:?no user}
passwd=${2:?no password}
game=${3:?no game db}

cd ${DB_SCRIPT_PATH}
mysql -u$user -p$passwd -e "create database $game; use $game; source chuanqi_db.sql;"

echo "-----------------------------------------------------------"
echo "安装完成"
echo "============================================================"
