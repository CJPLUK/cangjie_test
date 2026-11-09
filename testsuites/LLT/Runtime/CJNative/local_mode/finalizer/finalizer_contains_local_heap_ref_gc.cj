// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// Before finalization, a local child has a demode local-to-heap edge. During
// finalization, a nested local object creates another local-to-heap edge.
// Repeated region teardown must preserve both heap object graphs through
// re-entrant GC and reclaim each native region exactly once.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan finalizer local child count: 64
// ASSERT: scan finalizer local child checksum: 167552

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

class LocalChild {
    demode var payload: HeapPayload

    exclave init(this @local!, value: Int64) {
        payload = HeapPayload(value) @~local
    }
}

class FinalizerScratch {
    demode var payload: HeapPayload
    var expected: Int64

    exclave init(this @local!, value: Int64) {
        this.payload = HeapPayload(value) @~local
        this.expected = value * 2
    }
}

func makeGarbage(seed: Int64): Unit {
    let objects = ArrayList<HeapPayload>()
    for (i in 0..256) {
        objects.add(HeapPayload(seed + i) @~local)
    }
    blackBox(objects.size)
}

class FinalizedWithLocalChild {
    var child: LocalChild
    var value: Int64
    var expected: Int64

    exclave init(this @local!, child: LocalChild @local!, value: Int64) {
        this.child = child
        this.value = value
        this.expected = value * 2
    }

    ~init(this @local?) {
        // The child belongs to the same native local region. Its heap field
        // must remain valid while this finalizer is RUNNING, including across
        // nested allocation and a moving collection.
        // This is a new local A -> heap B edge created inside ~init. The
        // child.payload edge already existed before finalization started.
        let scratch: FinalizerScratch @local! = FinalizerScratch(value + 1000) @local!
        if (scratch.expected != expected + 2000) {
            throw Exception("nested local allocation in finalizer was corrupted")
        }
        makeGarbage(expected + 1000)
        gc()
        gc(heavy: true)
        let existingEdge = child.payload.checksum()
        let addedEdge = scratch.payload.checksum()
        if (existingEdge != expected || addedEdge != scratch.expected) {
            throw Exception("finalizer local-to-heap reference was corrupted")
        }
        finalizerChecksum += existingEdge + addedEdge
        finalizerCount++
    }
}

func createFinalized(value: Int64): Unit {
    let child: LocalChild @local! = LocalChild(value) @local!
    let finalizer: FinalizedWithLocalChild @local! =
        FinalizedWithLocalChild(child, value) @local!
    println("finalizer local child scope: ${finalizer.expected}")
}

main(): Unit {
    var expectedChecksum: Int64 = 0
    for (i in 0..64) {
        let value = i + 123
        expectedChecksum += value * 4 + 2000
        createFinalized(value)
    }
    if (finalizerCount != 64 || finalizerChecksum != expectedChecksum) {
        throw Exception("local finalizer region was finalized incorrectly")
    }
    println("finalizer local child count: ${finalizerCount}")
    println("finalizer local child checksum: ${finalizerChecksum}")
}
