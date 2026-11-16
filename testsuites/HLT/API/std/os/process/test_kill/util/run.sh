#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

run="$1"

# 清理本目录上一次运行可能遗留的 test.out：按 test.txt 记录的 pid 精确清理，
# 并校验进程名，避免全局 pkill 误杀其他并行用例的 test.out/clang/pkill 进程
if [ -f test.txt ]; then
  oldpid=`cat test.txt 2>/dev/null`
  if [ -n "$oldpid" ] && [ "`ps -p "$oldpid" -o comm= 2>/dev/null`" = "test.out" ]; then
    kill -9 "$oldpid" 2>/dev/null || true
  fi
fi
sleep 0.1

clang test.c -o test.out
nohup ./test.out > /dev/null 2>&1 &
echo $! > test.txt

sleep 0.2

pid=`eval $run`

if [ -n "$pid" ]; then
  echo "pass1"
  str=`ps -p "$pid" -o comm= 2>/dev/null`
  if [ -n "$str" ] && echo "$str" | grep -q "test.out"; then
    echo "pass3"
  else
    echo "pass2"
  fi
fi

# 清理本用例自己的 test.out（同样按 pid 精确清理，不做全局 pkill）
mypid=`cat test.txt 2>/dev/null`
if [ -n "$mypid" ] && [ "`ps -p "$mypid" -o comm= 2>/dev/null`" = "test.out" ]; then
  kill -9 "$mypid" 2>/dev/null || true
fi
