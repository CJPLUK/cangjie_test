// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Catching an exception in the same managed frame must not invalidate that
// frame's local region. A local allocation after the catch must still work.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan caught same frame
// ASSERT: scan after same-frame catch: 91

class SameFrameError <: Exception {}

class LocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

main(): Unit {
    try {
        throw SameFrameError()
    } catch (_: SameFrameError) {
        println("caught same frame")
    }

    let value: LocalValue @local! = LocalValue(91) @local!
    println("after same-frame catch: ${value.value}")
}
