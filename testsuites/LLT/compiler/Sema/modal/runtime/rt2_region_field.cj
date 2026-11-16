// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan copy done

package demo
import std.collection.*
import std.core.*

main(): Int64 {
    // @local! Array @local! 元素逐元素写入新 @local! Array
    let inner: Array<Int64> @local! = [1, 2]
    let copy: Array<Int64> @local! = Array<Int64>(2, repeat: 0)
    var i: Int64 = 0
    while (i < 2) {
        copy[i] = inner[i]   // 触发 region 断言崩溃
        i = i + 1
    }
    println("copy done")
    return 0
}
