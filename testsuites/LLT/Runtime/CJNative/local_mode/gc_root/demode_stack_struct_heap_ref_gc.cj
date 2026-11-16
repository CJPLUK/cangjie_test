// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify that a demode field in a stack struct keeps its heap target alive
// across GC. Codegen passes a null managed base pointer for this value owner.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan stack demode gc: 91

import std.runtime.*

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

struct StackHolder {
    demode var value: HeapValue

    init(this @local!, value: HeapValue) {
        exclave {
            this.value = value
        }
    }
}

main(): Unit {
    var holder: StackHolder @local! = StackHolder(HeapValue(90)) @local!
    holder.value = HeapValue(91) @~local
    gc()
    gc()
    println("stack demode gc: ${holder.value.value}")
}
