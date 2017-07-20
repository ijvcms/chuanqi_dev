#!/bin/bash
# 编译
# @author: zhengsiying
# @date: 2015.04.09
#
source `dirname $0`/header.sh

cd ${PROJECT_PATH}
erl -make
chmod +x ebin/*.*
