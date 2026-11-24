// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan runtime wcollector finalizer pass

import std.collection.*
import std.ref.*
import std.runtime.*
import std.sync.*

let finalizedObjects = AtomicInt64(0)

class FinalizableNode {
    let id: Int64
    let payload: Array<Int64>
    var next: ?FinalizableNode = None

    init(id: Int64) {
        this.id = id
        this.payload = Array<Int64>(256, repeat: id)
    }

    ~init() {
        finalizedObjects.fetchAdd(1)
    }
}

func createUnreachableList(seed: Int64): WeakRef<ArrayList<Int64>> {
    let values = ArrayList<Int64>([seed, seed + 1, seed + 2])
    return WeakRef<ArrayList<Int64>>(values, CleanupPolicy.EAGER)
}

func churn(seed: Int64): Int64 {
    var checksum: Int64 = 0
    for (round in 0..10) {
        let garbage = ArrayList<FinalizableNode>()
        for (index in 0..120) {
            let node = FinalizableNode(seed + Int64(round * 1000 + index))
            checksum += node.id
            garbage.add(node)
        }
        blackBox(garbage.size)
        gc(heavy: round % 2 == 0)
    }
    return checksum
}

main(): Int64 {
    let strongRoots = Array<FinalizableNode>(16, {index => FinalizableNode(Int64(index + 1))})
    let weakValues = ArrayList<WeakRef<ArrayList<Int64>>>()
    for (index in 0..32) {
        weakValues.add(createUnreachableList(1000 + Int64(index * 10)))
    }

    for (_ in 0..2048) {
        blackBox(Array<UInt8>(1024, repeat: 0))
    }
    let worker1 = spawn { => churn(100000) }
    let worker2 = spawn { => churn(200000) }
    var cleared: Int64 = 0
    for (attempt in 0..30) {
        gc(heavy: attempt % 2 == 0)
        sleep(10 * Duration.millisecond)
        cleared = 0
        for (weak in weakValues) {
            match (weak.value) {
                case Some(values) => blackBox(values.size)
                case None => cleared++
            }
        }
        blackBox(strongRoots[attempt % strongRoots.size].id)
        if (cleared == Int64(weakValues.size) && finalizedObjects.load() >= 64) {
            break
        }
    }

    let checksum = worker1.get() + worker2.get()
    for (index in 0..strongRoots.size) {
        if (strongRoots[index].id != Int64(index + 1)) {
            return 1
        }
    }
    if (cleared != Int64(weakValues.size) || finalizedObjects.load() < 64 || checksum <= 0) {
        println("wcollector diagnostic: cleared=${cleared}, weak=${weakValues.size}, " +
            "finalized=${finalizedObjects.load()}, checksum=${checksum}")
        return 2
    }
    println("runtime wcollector finalizer pass")
    return 0
}
