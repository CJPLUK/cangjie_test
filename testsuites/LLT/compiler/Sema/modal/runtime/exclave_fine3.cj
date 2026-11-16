// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

package demo
import std.core.*

// 变体A：exclave func 声明级 + 循环内 var = f(...)
func va(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave {
        var acc: Int64 = 0
        for (i in 0..x.size) {
            acc = f(x[i])
        }
        acc
    }
}

// 变体C：循环外 var 赋值（单次）
func vc(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave {
        var acc: Int64 = 0
        acc = f(7)
        acc
    }
}

// 变体D：let 中间量 + 累加
func vd(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave {
        var acc: Int64 = 0
        let n: Int64 = x.size
        for (i in 0..n) {
            let r: Int64 = f(x[i])
            acc = acc + r
        }
        acc
    }
}

main(): Int64 {
    let a: Array<Int64> @local! = [5, 6, 7]
    println("va=${va(a, {v => v * 2})} vc=${vc(a, {v => v * 2})} vd=${vd(a, {v => v * 2})}")
    return 0
}
