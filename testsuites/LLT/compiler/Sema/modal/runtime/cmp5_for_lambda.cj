// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

package demo
import std.core.*

// 形态1：exclave func 声明级 + for 循环内调用 lambda —— 返回值丢失
func form1(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave {
        var acc: Int64 = 0
        for (i in 0..x.size) {
            acc = f(x[i])   // 返回值丢失，acc 恒 0
        }
        acc
    }
}

// 形态2：func + 体内 exclave 表达式调用 —— 正常
func form2(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave { f(x[0]) }
}

// 形态3：exclave func 声明级 + let 中间量 + 单次调用 —— 正常
func form3(x: Array<Int64> @local!, f: (Int64) -> Int64 @local!): Int64 @local! {
    exclave {
        let r: Int64 = f(x[0])
        r
    }
}

main(): Int64 {
    let a: Array<Int64> @local! = [5, 6, 7]
    let r1 = form1(a, {v => v * 2})
    let r2 = form2(a, {v => v * 3})
    let r3 = form3(a, {v => v * 4})
    println("form1=${r1} form2=${r2} form3=${r3}")
    return 0
}

/* SCAN
form1=14 form2=15 form3=20
*/
