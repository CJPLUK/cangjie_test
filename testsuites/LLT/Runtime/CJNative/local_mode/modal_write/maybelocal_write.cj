// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A statically maybe-local array may be backed by a heap object at runtime.
// Its reference writes must retain the ordinary heap write-barrier semantics.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan heap maybe local: test1

import std.runtime.*

main(): Unit {
    var values: Array<String> @local? = ["test1", "test2"]
    gc()
    println("heap maybe local: ${values[0]}")
}
