// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An exception raised by a local finalizer must be contained by Runtime. The
// finalizer is still completed exactly once, later finalizers still run, and
// the mutator must be able to throw and catch an ordinary exception afterward.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan throwing finalizer: 10
// ASSERT: scan normal finalizer: 20
// ASSERT: scan finalizer exception escaped: false
// ASSERT: scan finalizer attempts: 2
// ASSERT: scan finalizer sum: 30
// ASSERT: scan follow-up exception caught
// ASSERT: scan after finalizer exception: 99

var finalizerAttempts: Int64 = 0
var finalizedSum: Int64 = 0

class LocalFinalizerError <: Exception {}

class FollowUpError <: Exception {}

class ThrowingFinalized {
    var value: Int64
    var shouldThrow: Bool

    exclave init(this @local!, value: Int64, shouldThrow: Bool) {
        this.value = value
        this.shouldThrow = shouldThrow
    }

    ~init(this @local?) {
        finalizerAttempts++
        finalizedSum += value
        if (shouldThrow) {
            println("throwing finalizer: ${value}")
            throw LocalFinalizerError()
        }
        println("normal finalizer: ${value}")
    }
}

class FinalizerLocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func createFinalizers(): Unit {
    let throwing: ThrowingFinalized @local! = ThrowingFinalized(10, true) @local!
    let normal: ThrowingFinalized @local! = ThrowingFinalized(20, false) @local!
    println("inside throwing finalizer scope: ${throwing.value + normal.value}")
}

func throwFollowUpException(): Nothing {
    throw FollowUpError()
}

main(): Unit {
    var escaped = false
    try {
        createFinalizers()
    } catch (_: LocalFinalizerError) {
        escaped = true
    }

    println("finalizer exception escaped: ${escaped}")
    println("finalizer attempts: ${finalizerAttempts}")
    println("finalizer sum: ${finalizedSum}")

    try {
        throwFollowUpException()
    } catch (_: FollowUpError) {
        println("follow-up exception caught")
    }

    let reused: FinalizerLocalValue @local! = FinalizerLocalValue(99) @local!
    println("after finalizer exception: ${reused.value}")
}
