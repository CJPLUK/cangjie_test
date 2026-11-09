// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Recursively scan a local A -> B -> C graph and retain C's heap target.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local graph gc: 1234

import std.runtime.*

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

class LocalC {
    demode var heap: HeapValue

    exclave init(this @local!, heap: HeapValue) {
        this.heap = heap
    }
}

class LocalB {
    var child: LocalC

    exclave init(this @local!, child: LocalC @local!) {
        this.child = child
    }
}

class LocalA {
    var child: LocalB

    exclave init(this @local!, child: LocalB @local!) {
        this.child = child
    }
}

main(): Unit {
    let c: LocalC @local! = LocalC(HeapValue(1234)) @local!
    let b: LocalB @local! = LocalB(c) @local!
    let a: LocalA @local! = LocalA(b) @local!
    gc()
    gc()
    println("local graph gc: ${a.child.child.heap.value}")
}
