// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify that local allocation works without cjEnableLocalRegion.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local object: 42

class LocalValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }

    func get(this @local!): Int64 {
        value
    }
}

main(): Unit {
    let value: LocalValue @local! = LocalValue(42) @local!
    println("local object: ${value.get()}")
}
