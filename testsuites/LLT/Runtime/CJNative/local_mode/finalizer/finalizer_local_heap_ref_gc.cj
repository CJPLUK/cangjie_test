// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// A running local finalizer must keep its local-to-heap field and the target's
// heap object graph alive across re-entrant GC.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan finalizer heap ref scope
// ASSERT: scan finalizer heap payload: 246
// ASSERT: scan finalizer heap ref count: 1

import std.collection.*
import std.runtime.*

var finalizerCount: Int64 = 0
var finalizerChecksum: Int64 = 0

class HeapPayload {
    var value: Int64
    var guard: Int64
    var values: Array<Int64>

    init(value: Int64) {
        this.value = value
        this.guard = value ^ 0x55
        this.values = Array<Int64>(64, repeat: value)
    }

    func checksum(this @~local): Int64 {
        value + (guard ^ 0x55) + values[0] - value
    }
}

func makeGarbage(seed: Int64): Unit {
    let objects = ArrayList<HeapPayload>()
    for (i in 0..512) {
        objects.add(HeapPayload(seed + i) @~local)
    }
    blackBox(objects.size)
}

class FinalizedWithHeapRef {
    demode var payload: HeapPayload

    exclave init(this @local!, value: Int64) {
        payload = HeapPayload(value) @~local
    }

    ~init(this @local?) {
        // The registry marks this finalizer RUNNING before entering user code.
        // Both collections must retain and update payload and payload.values.
        makeGarbage(1000)
        gc()
        gc(heavy: true)
        finalizerChecksum = payload.checksum()
        finalizerCount++
        println("finalizer heap payload: ${finalizerChecksum}")
    }
}

func createFinalized(): Unit {
    let value: FinalizedWithHeapRef @local! = FinalizedWithHeapRef(123) @local!
    println("finalizer heap ref scope")
}

main(): Unit {
    createFinalized()
    if (finalizerChecksum != 246 || finalizerCount != 1) {
        throw Exception("local finalizer heap reference was corrupted")
    }
    println("finalizer heap ref count: ${finalizerCount}")
}
