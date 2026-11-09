// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// A local finalizer overwrites a previously registered local-to-heap slot.
// The registry must retain the replacement, rather than the stale target,
// across a moving collection.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan finalizer heap before: 2
// ASSERT: scan finalizer heap after: 84
// ASSERT: scan finalizer heap reassign count: 1

import std.collection.*
import std.runtime.*

var finalizedCount: Int64 = 0
var finalizedValue: Int64 = 0

class HeapData {
    var value: Int64
    var guard: Int64
    var values: Array<Int64>

    init(value: Int64) {
        this.value = value
        this.guard = value ^ 0x5a
        this.values = Array<Int64>(32, repeat: value)
    }

    func checksum(this @~local): Int64 {
        value + (guard ^ 0x5a) + values[0] - value
    }
}

func makeGarbage(seed: Int64): Unit {
    let values = ArrayList<HeapData>()
    for (i in 0..512) {
        values.add(HeapData(seed + i) @~local)
    }
    blackBox(values.size)
}

class ReassigningFinalizer {
    demode var heapData: HeapData

    exclave init(this @local!, value: Int64) {
        this.heapData = HeapData(value) @~local
    }

    ~init(this @local?) {
        println("finalizer heap before: ${heapData.checksum()}")
        this.heapData = HeapData(42) @~local
        makeGarbage(1000)
        gc()
        gc(heavy: true)
        finalizedValue = heapData.checksum()
        finalizedCount++
        println("finalizer heap after: ${finalizedValue}")
    }
}

func createFinalizer(): Unit {
    let value: ReassigningFinalizer @local! = ReassigningFinalizer(1) @local!
    if (value.heapData.checksum() != 2) {
        throw Exception("finalizer input was corrupted")
    }
}

main(): Unit {
    createFinalizer()
    if (finalizedCount != 1 || finalizedValue != 84) {
        throw Exception("finalizer heap field replacement was corrupted")
    }
    println("finalizer heap reassign count: ${finalizedCount}")
}
