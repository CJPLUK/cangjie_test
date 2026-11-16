// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Exercise maybe-local-write and relocation of a heap target held by a local owner.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan maybe local gc: 73

import std.runtime.*

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

class Box<T> {
    var value: T

    exclave init(this @local?, value: T) {
        this.value = value
    }
}

main(): Unit {
    let heapValue = HeapValue(73)
    let box: Box<HeapValue> @local? = Box<HeapValue>(heapValue) @local?
    gc()
    gc()
    println("maybe local gc: ${box.value.value}")
}
