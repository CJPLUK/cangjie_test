#!/bin/sh
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

OS=$(uname -s)
case "$OS" in
    Linux*)
        ARCH=linux_x86_64_cjnative
        ;;
    Darwin*)
        ARCH=darwin_aarch64_cjnative
        ;;
    *)
        echo "Unsupported OS detected"
        exit 1
        ;;
esac

CANGJIE_RUNTIME_LIB_PATH=${CANGJIE_HOME}/runtime/lib/${ARCH}

cd output

DYLD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$LD_LIBRARY_PATH" ./main

cd ..
