// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Unwind multiple frames, each owning a local scope, then enter localmode again.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan caught nested: 6
// ASSERT: scan reused: 77

class NestedError <: Exception {}

class LocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func level3(total: Int64): Nothing {
    let value: LocalValue @local! = LocalValue(3) @local!
    if (total + value.value == 6) {
        throw NestedError()
    }
    throw NestedError()
}

func level2(total: Int64): Nothing {
    let value: LocalValue @local! = LocalValue(2) @local!
    level3(total + value.value)
}

func level1(): Nothing {
    let value: LocalValue @local! = LocalValue(1) @local!
    level2(value.value)
}

main(): Unit {
    try {
        level1()
    } catch (_: NestedError) {
        println("caught nested: 6")
    }
    let reused: LocalValue @local! = LocalValue(77) @local!
    println("reused: ${reused.value}")
}
