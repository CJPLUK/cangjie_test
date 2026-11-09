// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

// RT-1 复现：@local! Array 的元素写入触发 Barrier::WriteGeneric SIGABRT
// 实测：直接崩溃
//   Barrier::WriteGeneric does not support local object: obj 0x..., src 0x...
//   CJNative Handle signal: 6.
// 位置：runtime/src/Heap/Barrier/Barrier.cpp:216-218（// todo del 占位检查）
package demo
import std.collection.*
import std.core.*

main(): Int64 {
    // 路径1：Array initElement @local! 构造（内部 arraySet2 写 local RawArray）
    let a1 = Array<Int64>(3, {i => i}) @local!
    println("a1=${a1[0]}")

    // 路径2：ArrayList @local! add（内部 myData[mySize] = element）
    let a2 = ArrayList<Int64>() @local!
    a2.add(1)
    println("a2=${a2[0]}")
    return 0
}
