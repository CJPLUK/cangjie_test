// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

import std.core.*

main(): Int64 {
    let direct: Option<Int64> @local! = Some<Int64>(42)
    match (direct) {
        case Some(v) => println("sameFn_some=${v}")   // 输出 some=0，期望 42
        case None => println("sameFn_none")
    }
    return 0
}

/* SCAN
sameFn_some=42
*/
