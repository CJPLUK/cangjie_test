#!/bin/sh
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# gen mirrors for ObjC api as klib
cinterop -def api.def -o apilib.klib
if [ $? -ne 0 ]; then
    exit $?
fi

# gen implementation of ObjC api as dylib
#clang -fobjc-arc -shared -lobjc objcsample/M.m -Iobjcsample -o libmmm.dylib
clang -fobjc-arc -shared objcsample/M.m -Iobjcsample -o libmmm.dylib
if [ $? -ne 0 ]; then
    exit $?
fi

# build Kotlin test entry point and classes dependent on apilib.klib into ktsample framework
kotlinc-native -p framework -l apilib.klib -linker-options "-L. -lmmm" -Xbinary=bundleId=ktsample KTWorld.kt -o ktsample
if [ $? -ne 0 ]; then
    exit $?
fi

# Test.m into main
clang -fobjc-arc -rpath . -F. -framework ktsample objcsample/Test.m -Iobjcsample -o main
if [ $? -ne 0 ]; then
    exit $?
fi

echo Compiled successfully

cd ../
