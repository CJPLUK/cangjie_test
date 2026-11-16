// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Exercise demode-write and relocation of heap fields in local storage.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan demode gc: 91

import std.runtime.*

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

class LocalHolder {
    demode var value: HeapValue

    exclave init(this @local!, value: HeapValue) {
        this.value = value
    }
}

main(): Unit {
    let holder: LocalHolder @local! = LocalHolder(HeapValue(90)) @local!
    holder.value = HeapValue(91) @~local
    gc()
    gc()
    println("demode gc: ${holder.value.value}")
}
