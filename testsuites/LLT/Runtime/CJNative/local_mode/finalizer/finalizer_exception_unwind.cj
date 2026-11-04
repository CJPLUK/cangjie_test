// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Exception control flow must finalize every local object exactly once, either
// at its LLVM-computed live-range end or while its owning scope is unwound.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan unwind finalizer: 10
// ASSERT: scan unwind finalizer: 20
// ASSERT: scan caught finalizer exception
// ASSERT: scan unwind finalizer sum: 30

var finalizedSum: Int64 = 0

class FinalizerError <: Exception {}

class Finalized {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }

    ~init(this @local?) {
        finalizedSum += value
        println("unwind finalizer: ${value}")
    }
}

func inner(): Nothing {
    let value: Finalized @local! = Finalized(20) @local!
    if (value.value == 20) {
        throw FinalizerError()
    }
    throw FinalizerError()
}

func outer(): Nothing {
    let value: Finalized @local! = Finalized(10) @local!
    if (value.value == 10) {
        inner()
    }
    throw FinalizerError()
}

main(): Unit {
    try {
        outer()
    } catch (_: FinalizerError) {
        println("caught finalizer exception")
    }
    println("unwind finalizer sum: ${finalizedSum}")
}
