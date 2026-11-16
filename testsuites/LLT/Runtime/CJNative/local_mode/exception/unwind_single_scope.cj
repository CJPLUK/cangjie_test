// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A thrown exception must close the unwound frame's local scope.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan caught single
// ASSERT: scan after unwind: 64

class LocalError <: Exception {}

class LocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func throwFromLocalScope(): Nothing {
    let value: LocalValue @local! = LocalValue(32) @local!
    if (value.value == 32) {
        throw LocalError()
    }
    throw LocalError()
}

main(): Unit {
    try {
        throwFromLocalScope()
    } catch (_: LocalError) {
        println("caught single")
    }
    let value: LocalValue @local! = LocalValue(64) @local!
    println("after unwind: ${value.value}")
}
