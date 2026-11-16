/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: ./unwriteable
// DEPENDENCE: ./data
// (!host_win) EXEC: %chmod -w ./unwriteable
// (!host_win) EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output
// (!host_win) RUN-EXEC: %run_stdx %output %run_args
// (!host_win) EXEC: %chmod +w ./unwriteable

import std.fs.*
import stdx.net.http.*

main(): Int64 {
    var ss = canonicalize(Path("./data/../")).toString()

    FileHandler(ss + "/unwriteable", handlerType: UpLoad)
    FileHandler(ss + "/unwriteable", handlerType: UpLoad, bufferSize: 4 * 1024 / 2)
    FileHandler(ss + "/unwriteable", handlerType: UpLoad, bufferSize: 4 * 1024 * 2)
    FileHandler(ss + "/unwriteable", handlerType: UpLoad, bufferSize: 64 * 1024 / 2)
    FileHandler(ss + "/unwriteable", handlerType: UpLoad, bufferSize: 64 * 1024 * 2)
    return 0
}
