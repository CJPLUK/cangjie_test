// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify direct local-root slot registration across nested local regions.
//
// A nested @local? function repeatedly replaces heap targets in two fields of
// an outer local owner. Once the nested region has exited, repeated GCs must
// still retain and update those slots. Each round writes the same two fields,
// which verifies that a registered RefField follows its current heap target
// rather than the target present at registration time.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested outer slots: passed

import std.collection.*
import std.runtime.*

class HeapPayload {
    var value: Int64
    var guard0: Int64
    var guard1: Int64

    init(value: Int64) {
        this.value = value
        this.guard0 = value ^ 0x55
        this.guard1 = value ^ 0xaa
    }

    func checksum(this @~local): Int64 {
        value + (guard0 ^ 0x55) + (guard1 ^ 0xaa)
    }
}

class OuterSlots {
    demode var first: HeapPayload
    demode var second: HeapPayload

    exclave init(this @local!) {
        first = HeapPayload(-1) @~local
        second = HeapPayload(-2) @~local
    }
}

func makeGarbage(seed: Int64): Int64 {
    let garbageBatch = ArrayList<HeapPayload>()
    var checksum: Int64 = 0
    // Keep the payload a leaf object: an Array field here would exercise the
    // compiler's stack-copy path, not local-root slot relocation.  A large
    // batch still puts enough pressure on the moving heap to relocate targets.
    for (i in 0..4096) {
        let garbage = HeapPayload(seed + i) @~local
        checksum = checksum ^ garbage.checksum()
        garbageBatch.add(garbage)
    }
    blackBox(garbageBatch.size)
    blackBox(checksum)
}

func updateOuterSlots(holder: OuterSlots @local?, seed: Int64): Unit {
    holder.first = HeapPayload(seed + 1) @~local
    holder.second = HeapPayload(seed + 2) @~local
}

func checkOuterSlots(holder: OuterSlots @local?, seed: Int64): Int64 {
    let expected = (seed + 1 + seed + 2) * 3
    let actual = holder.first.checksum() + holder.second.checksum()
    if (actual != expected) {
        throw Exception("outer local slots corrupted: expected ${expected}, got ${actual}")
    }
    actual
}

func runStress(): Unit {
    let holder: OuterSlots @local! = OuterSlots() @local!
    var noise: Int64 = 0

    @local? func updateInNestedRegion(localHolder: OuterSlots @local?, seed: Int64): Int64 {
        // localHolder belongs to the outer region. Its heap targets are
        // replaced while this nested region is the current allocation frame.
        updateOuterSlots(localHolder, seed)
        let nestedNoise = makeGarbage(seed + 1000)
        gc()
        gc(heavy: true)
        nestedNoise ^ checkOuterSlots(localHolder, seed)
    }

    for (round in 0..512) {
        let seed = round * 97
        noise = noise ^ updateInNestedRegion(holder, seed)

        // The nested region has ended.  The heap objects above must remain
        // reachable through the outer owner's registered slots, and each
        // slot must have been updated if its target moved during collection.
        noise = noise ^ makeGarbage(seed + 10000)
        gc()
        gc(heavy: true)
        let afterNested = checkOuterSlots(holder, seed)
        noise = noise ^ afterNested
    }
    if (noise == -1) {
        throw Exception("unexpected local-root stress checksum")
    }
}

main(): Unit {
    runStress()
    println("nested outer slots: passed")
}
