// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// A belongs to an outer region, but its local-to-heap field is written while
// an inner region is current. The field must be registered in A's owner frame,
// not in currentFrame: after the inner region ends, a moving GC must still
// retain and update heap B.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested owner frame slot: 246

import std.collection.*
import std.runtime.*

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

class OuterOwner {
    demode var payload: HeapPayload

    exclave init(this @local!) {
        payload = HeapPayload(-1) @~local
    }
}

func makeGarbage(seed: Int64): Unit {
    let objects = ArrayList<HeapPayload>()
    for (i in 0..512) {
        objects.add(HeapPayload(seed + i) @~local)
    }
    blackBox(objects.size)
}

func run(): Int64 {
    let outer: OuterOwner @local! = OuterOwner() @local!

    @local? func writeFromInner(localOuter: OuterOwner @local?): Unit {
        // outer is not owned by this inner RegionFrame.
        localOuter.payload = HeapPayload(123) @~local
        makeGarbage(1000)
        gc(heavy: true)
    }

    writeFromInner(outer)
    // writeFromInner's RegionFrame has now ended. A currentFrame-only
    // registration would have been destroyed with it.
    makeGarbage(2000)
    gc()
    gc(heavy: true)
    outer.payload.checksum()
}

main(): Unit {
    println("nested owner frame slot: ${run()}")
}
