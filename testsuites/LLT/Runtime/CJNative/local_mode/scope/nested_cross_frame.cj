// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify nested local scopes owned by different managed frames.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested frames: 54

class FrameValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func inner(base: Int64): Int64 {
    let value: FrameValue @local! = FrameValue(base + 20) @local!
    value.value
}

func middle(base: Int64): Int64 {
    let value: FrameValue @local! = FrameValue(base + 10) @local!
    value.value + inner(base)
}

main(): Unit {
    let outer: FrameValue @local! = FrameValue(8) @local!
    let result = outer.value + middle(4) + outer.value
    println("nested frames: ${result}")
}
