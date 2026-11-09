// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args2>&1 | compare %f
// ASSERT: scan-begin eq_same=true
// ASSERT: scan-next eq_diff=false

package demo
import std.core.*

func readAt(a: Array<Int64> @local?, i: Int64): Int64 {
    let o: Option<Int64> @local? = a.get(i)
    match (o) {
        case Some(v) => v
        case None => -1
    }
}

main(): Int64 {
    let a1: Array<Int64> @local? = [1, 2, 3]

    // 具体类型 Int64 @local? 的 ==（非泛型）
    let e1: Int64 @local? = readAt(a1, 1)
    let e2: Int64 @local? = readAt(a1, 1)
    let r1 = (e1 == e2)
    println("eq_same=${r1}")

    let e3: Int64 @local? = readAt(a1, 0)
    let r2 = (e1 == e3)
    println("eq_diff=${r2}")
    return 0
}
