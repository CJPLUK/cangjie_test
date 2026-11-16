// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt -O2 %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan finalized after throw started: true
// ASSERT: scan caught original exception: original
// ASSERT: scan finalizer count: 1
// ASSERT: scan follow-up catch succeeded

var throwStarted = false
var finalizerCount: Int64 = 0

class OriginalException <: Exception {
    init() { super("original") }
}

class KeptAlive {
    var value: Int64
    exclave init(this @local!) { value = 42 }
    ~init(this @local?) {
        finalizerCount++
        println("finalized after throw started: ${throwStarted}")
    }
}

// Recursive calls keep a real unwind boundary even under LLVM inlining.
// The object is used after each call on the normal path.
func throwOrReturn(object: KeptAlive @local?, depth: Int64, shouldThrow: Bool): Unit {
    if (depth > 0) {
        throwOrReturn(object, depth - 1, shouldThrow)
    } else if (shouldThrow) {
        throwStarted = true
        throw OriginalException()
    }
    object.value++
    println("normal recursive return: ${object.value}")
}

// The normal successor uses the object, so it must remain alive across the
// throwing call. Finalizing it before that call would also fail the assertion.
func keepAliveAcrossCall(shouldThrow: Bool): Unit {
    let object: KeptAlive @local! = KeptAlive()
    throwOrReturn(object, 4, shouldThrow)
    println("normal successor: ${object.value}")
}

main(): Int64 {
    try {
        keepAliveAcrossCall(true)
        return 1
    } catch (error: OriginalException) {
        println("caught original exception: ${error.message}")
    }
    println("finalizer count: ${finalizerCount}")
    if (finalizerCount != 1 || !throwStarted) { return 2 }
    try { throw Exception("after unwind") }
    catch (_: Exception) { println("follow-up catch succeeded") }
    0
}
