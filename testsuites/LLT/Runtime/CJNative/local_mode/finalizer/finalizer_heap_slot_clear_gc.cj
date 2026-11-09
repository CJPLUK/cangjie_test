// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// A demode field has heap-only static type, so the source-level equivalent of
// replacing it with a local object is clearing it.  The old direct-root entry
// must then skip the null slot during GC rather than retaining or dereferencing
// its old heap target.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan finalizer heap slot cleared: true
// ASSERT: scan finalizer heap slot clear count: 1

import std.collection.*
import std.runtime.*

var finalizedCount: Int64 = 0
var slotWasCleared: Bool = false

class HeapData {
    var value: Int64
    var values: Array<Int64>

    init(value: Int64) {
        this.value = value
        this.values = Array<Int64>(32, repeat: value)
    }
}

func makeGarbage(seed: Int64): Unit {
    let values = ArrayList<HeapData>()
    for (i in 0..512) {
        values.add(HeapData(seed + i) @~local)
    }
    blackBox(values.size)
}

class HeapSlotClearingFinalizer {
    demode var data: ?HeapData

    exclave init(this @local!, value: Int64) {
        this.data = HeapData(value) @~local
    }

    ~init(this @local?) {
        this.data = None
        makeGarbage(1000)
        gc()
        gc(heavy: true)
        slotWasCleared = data.isNone()
        finalizedCount++
        println("finalizer heap slot cleared: ${slotWasCleared}")
    }
}

func createFinalizer(): Unit {
    let value: HeapSlotClearingFinalizer @local! = HeapSlotClearingFinalizer(1) @local!
    if (value.data.isNone()) {
        throw Exception("finalizer input was not initialized")
    }
}

main(): Unit {
    createFinalizer()
    if (finalizedCount != 1 || !slotWasCleared) {
        throw Exception("finalizer heap slot clear did not complete")
    }
    println("finalizer heap slot clear count: ${finalizedCount}")
}
