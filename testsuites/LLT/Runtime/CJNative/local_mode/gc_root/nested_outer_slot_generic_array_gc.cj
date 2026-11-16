// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// Verify that preforward updates a heap object graph reachable from an outer
// local slot written in a nested region.  Before the preforward root scan
// included registered local slots, the second iteration could read a stale
// Array reference in Barrier::ReadGeneric.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested generic array gc: passed

import std.collection.*
import std.runtime.*

class Payload {
    var values: Array<Int64>

    init(seed: Int64) {
        values = Array<Int64>(64, repeat: seed)
    }

    func read(this @~local): Int64 {
        values[0]
    }
}

class Holder {
    demode var payload: Payload

    exclave init(this @local!) {
        payload = Payload(0) @~local
    }
}

func makeGarbage(seed: Int64): Unit {
    let objects = ArrayList<Payload>()
    for (i in 0..512) {
        objects.add(Payload(seed + i) @~local)
    }
    blackBox(objects.size)
}

main(): Unit {
    let holder: Holder @local! = Holder() @local!

    @local? func updateInNestedRegion(localHolder: Holder @local?, seed: Int64): Unit {
        localHolder.payload = Payload(seed) @~local
        makeGarbage(seed + 1000)
        gc(heavy: true)
    }

    // The first round is valid. The second requires preforward to update the
    // outer local slot before the from-space target can be reclaimed.
    for (round in 0..2) {
        updateInNestedRegion(holder, round)
        makeGarbage(round + 1000)
        gc(heavy: true)
        if (holder.payload.read() != round) {
            throw Exception("payload reference was corrupted")
        }
    }
    println("nested generic array gc: passed")
}
