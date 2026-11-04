// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Stack trace collection must retain all Cangjie frames when an exception
// unwinds nested functions that each own a local object scope.
// Backend optimization can inline internal frames, so force O0 to make the
// stack-shape assertion deterministic in every LLT configuration.
// EXEC: %compiler %local %cmp_opt -O0 %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local stack complete: true
// ASSERT: scan local stack frames:
// ASSERT: scan local stack depth:
// ASSERT: scan after stack trace: 88

class LocalStackError <: Exception {}

class StackLocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func localStackLeaf(total: Int64): Int64 {
    let value: StackLocalValue @local! = StackLocalValue(3) @local!
    if (total + value.value == 6) {
        throw LocalStackError()
    }
    return value.value
}

func localStackMiddle(total: Int64): Int64 {
    let value: StackLocalValue @local! = StackLocalValue(2) @local!
    return localStackLeaf(total + value.value) + value.value
}

func localStackEntry(): Int64 {
    let value: StackLocalValue @local! = StackLocalValue(1) @local!
    return localStackMiddle(value.value) + value.value
}

main(): Unit {
    try {
        localStackEntry()
    } catch (e: LocalStackError) {
        println("[test] Caught exception: ${e.toString()}")
        println(e.printStackTrace())
        var functionStack = ""
        var stackDepth: Int64 = 0
        for (frame in e.getStackTrace()) {
            functionStack += frame.methodName
            stackDepth++
        }
        let complete = functionStack.contains(
            "localStackLeaf(Int64)localStackMiddle(Int64)localStackEntry()main()")
        println("local stack complete: ${complete}")
        println("local stack frames: ${functionStack}")
        println("local stack depth: ${stackDepth}")
    }

    let reused: StackLocalValue @local! = StackLocalValue(88) @local!
    println("after stack trace: ${reused.value}")
}
