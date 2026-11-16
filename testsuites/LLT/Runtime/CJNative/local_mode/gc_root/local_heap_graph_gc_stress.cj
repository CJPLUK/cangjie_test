// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Stress GC root discovery for a mixed graph:
//   local root -> local branches -> local leaves -> heap objects
//   local generic box -> heap object
//   local reference array -> heap objects
// A nested function owns another local region and triggers GC while the outer
// region is still live. Heap targets are repeatedly replaced so that barriers,
// root registries and relocation are exercised together.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan mixed graph stress: 3717660

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

    func checksum(): Int64 {
        value + (guard0 ^ 0x55) + (guard1 ^ 0xaa)
    }
}

class LocalLeaf {
    demode var first: HeapPayload
    demode var second: HeapPayload

    exclave init(this @local!, first: HeapPayload, second: HeapPayload) {
        this.first = first
        this.second = second
    }

    func checksum(this @local?): Int64 {
        first.checksum() + second.checksum()
    }
}

class LocalBranch {
    var left: LocalLeaf
    var right: LocalLeaf
    demode var direct: HeapPayload

    exclave init(this @local!, left: LocalLeaf @local!, right: LocalLeaf @local!, direct: HeapPayload) {
        this.left = left
        this.right = right
        this.direct = direct
    }

    exclave func checksum(this @local!): Int64 {
        let leftLocal: LocalLeaf @local! = left
        let rightLocal: LocalLeaf @local! = right
        leftLocal.checksum() + rightLocal.checksum() + direct.checksum()
    }
}

class LocalRoot {
    var first: LocalBranch
    var second: LocalBranch
    demode var direct: HeapPayload

    exclave init(this @local!, first: LocalBranch @local!, second: LocalBranch @local!, direct: HeapPayload) {
        this.first = first
        this.second = second
        this.direct = direct
    }

    exclave func checksum(this @local!): Int64 {
        let firstLocal: LocalBranch @local! = first
        let secondLocal: LocalBranch @local! = second
        firstLocal.checksum() + secondLocal.checksum() + direct.checksum()
    }
}

class LocalBox {
    demode var value: HeapPayload

    exclave init(this @local?, value: HeapPayload) {
        this.value = value
    }
}

class LocalRefs {
    demode var first: HeapPayload
    demode var second: HeapPayload
    demode var third: HeapPayload

    exclave init(this @local?, first: HeapPayload, second: HeapPayload, third: HeapPayload) {
        this.first = first
        this.second = second
        this.third = third
    }
}

func makeGarbage(seed: Int64): Int64 {
    var result: Int64 = 0
    for (i in 0..64) {
        let garbage = HeapPayload(seed + i) @~local
        result = result ^ garbage.guard0
    }
    result
}

func nestedRegionStress(seed: Int64): Int64 {
    let leaf: LocalLeaf @local! = LocalLeaf(
        HeapPayload(seed + 1) @~local,
        HeapPayload(seed + 2) @~local
    ) @local!
    var noise: Int64 = 0
    for (i in 0..4) {
        leaf.first = HeapPayload(seed + i + 10) @~local
        noise = noise ^ makeGarbage(seed + i * 100)
        gc()
    }
    leaf.checksum() + (noise - noise)
}

func runStress(): Int64 {
    let leaf0: LocalLeaf @local! = LocalLeaf(HeapPayload(1), HeapPayload(2)) @local!
    let leaf1: LocalLeaf @local! = LocalLeaf(HeapPayload(3), HeapPayload(4)) @local!
    let leaf2: LocalLeaf @local! = LocalLeaf(HeapPayload(5), HeapPayload(6)) @local!
    let leaf3: LocalLeaf @local! = LocalLeaf(HeapPayload(7), HeapPayload(8)) @local!
    let branch0: LocalBranch @local! = LocalBranch(leaf0, leaf1, HeapPayload(9)) @local!
    let branch1: LocalBranch @local! = LocalBranch(leaf2, leaf3, HeapPayload(10)) @local!
    let root: LocalRoot @local! = LocalRoot(branch0, branch1, HeapPayload(11)) @local!
    let box: LocalBox @local? = LocalBox(HeapPayload(12)) @local?
    let refs: LocalRefs @local? = LocalRefs(HeapPayload(13), HeapPayload(14), HeapPayload(15)) @local?

    var nestedSum: Int64 = 0
    var noise: Int64 = 0
    for (round in 0..200) {
        let base = round * 100
        leaf0.first = HeapPayload(base + 1) @~local
        leaf0.second = HeapPayload(base + 2) @~local
        leaf1.first = HeapPayload(base + 3) @~local
        leaf1.second = HeapPayload(base + 4) @~local
        leaf2.first = HeapPayload(base + 5) @~local
        leaf2.second = HeapPayload(base + 6) @~local
        leaf3.first = HeapPayload(base + 7) @~local
        leaf3.second = HeapPayload(base + 8) @~local
        branch0.direct = HeapPayload(base + 9) @~local
        branch1.direct = HeapPayload(base + 10) @~local
        root.direct = HeapPayload(base + 11) @~local
        box.value = HeapPayload(base + 12) @~local
        refs.first = HeapPayload(base + 13) @~local
        refs.second = HeapPayload(base + 14) @~local
        refs.third = HeapPayload(base + 15) @~local

        noise = noise ^ makeGarbage(base + 1000)
        if (round % 5 == 0) {
            nestedSum += nestedRegionStress(base + 2000)
        }
        gc()
        gc()

        // Read every edge after relocation. The guard fields catch stale or
        // partially updated heap references instead of checking only identity.
        let live = root.checksum() + box.value.checksum() +
            refs.first.checksum() + refs.second.checksum() + refs.third.checksum()
        if (live != (base + 1 + base + 2 + base + 3 + base + 4 + base + 5 +
            base + 6 + base + 7 + base + 8 + base + 9 + base + 10 + base + 11 +
            base + 12 + base + 13 + base + 14 + base + 15) * 3) {
            throw Exception("mixed local/heap graph corrupted at round ${round}")
        }
    }

    let finalValue = root.checksum() + box.value.checksum() +
        refs.first.checksum() + refs.second.checksum() + refs.third.checksum()
    finalValue + nestedSum + (noise - noise)
}

main(): Unit {
    println("mixed graph stress: ${runStress()}")
}
