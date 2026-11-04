// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A local finalizer must be registered without allocation-domain failure and
// run exactly once before its owning scope is released.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan inside finalizer scope: 5
// ASSERT: scan local finalizer: 5
// ASSERT: scan finalizer count: 1

var finalizerCount: Int64 = 0

class Finalized {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }

    ~init(this @local?) {
        finalizerCount++
        println("local finalizer: ${value}")
    }
}

func createFinalized(): Unit {
    let value: Finalized @local! = Finalized(5) @local!
    println("inside finalizer scope: ${value.value}")
}

main(): Unit {
    createFinalized()
    println("finalizer count: ${finalizerCount}")
}
