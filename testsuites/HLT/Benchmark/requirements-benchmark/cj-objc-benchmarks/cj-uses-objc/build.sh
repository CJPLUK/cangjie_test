#!/bin/sh
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

OS=$(uname -s)
case "$OS" in
    Linux*)
        ARCH=linux_x86_64_cjnative
        OBJC_FLAGS="$(gnustep-config --objc-flags) $(gnustep-config --base-libs) -lobjc -fobjc-arc"
        ;;
    Darwin*)
        ARCH=darwin_aarch64_cjnative
        OBJC_FLAGS="-fmodules -fblocks -fobjc-arc"
        ;;
    *)
        echo "Unsupported OS detected"
        exit 1
        ;;
esac

CANGJIE_RUNTIME_LIB_PATH=${CANGJIE_HOME}/runtime/lib/${ARCH}

export DYLD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$DYLD_LIBRARY_PATH" 
export LD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$LD_LIBRARY_PATH"

mkdir -p ./output
cd ./output

CJFILES="../M.cj ../M1.cj ../M2.cj ../M3.cj ../M4.cj ../M5.cj ../Test.cj ../Payload.cj"

echo compiling macro
cjc --compile-macro ../Macro.cj

echo compiling mirror class
cjc --output-type=dylib -O2  --int-overflow wrapping $CJFILES --disable-reflection -L. \
    --experimental -lobjc.lang -lobjc.internal
if [ $? -ne 0 ]; then
    exit $?
fi

echo compiling ObjC main
clang $OBJC_FLAGS ../objcsample/*.m -o main -L. -lobjc.sample -L${CANGJIE_RUNTIME_LIB_PATH} -lobjc.internal
if [ $? -ne 0 ]; then
    exit $?
fi

echo Compiled successfully
cd ../
