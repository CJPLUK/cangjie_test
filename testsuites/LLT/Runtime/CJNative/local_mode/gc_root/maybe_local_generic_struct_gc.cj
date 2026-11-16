// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify that a generic value containing a heap reference can be written into
// a local owner and keeps the referenced heap object alive across GC.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan generic struct gc: 73

import std.runtime.*

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

struct Payload {
    var value: HeapValue

    init(value: HeapValue) {
        this.value = value
    }
}

class Box<T> {
    demode var value: T

    exclave init(this @local!, value: T) {
        this.value = value
    }
}

main(): Unit {
    let box: Box<Payload> @local! = Box<Payload>(Payload(HeapValue(73)))
    gc()
    gc()
    println("generic struct gc: ${box.value.value.value}")
}
