// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// The finalizer starts a nested local region, then replaces both a local field
// and a local-to-heap field.  The writes are consumed while that nested frame
// is still active.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested finalizer local: 99, true
// ASSERT: scan nested finalizer heap: 42, false
// ASSERT: scan nested finalizer reassign count: 1

import std.runtime.*

var finalizedCount: Int64 = 0
var finalizedSum: Int64 = 0

class Data {
    var value: Int64
    var onRegion: Bool

    exclave init(this @local!, value: Int64) {
        this.value = value
        this.onRegion = true
    }

    init(value: Int64) {
        this.value = value
        this.onRegion = false
    }
}

class NestedRegionFinalizer {
    var localData: Data
    demode var heapData: Data

    exclave init(this @local!, value: Int64) {
        this.localData = Data(value) @local!
        this.heapData = Data(value + 1) @~local
    }

    ~init(this @local?) {
        let replacementLocal: Data @local! = Data(99) @local!
        let replacementHeap = Data(42) @~local
        this.localData = replacementLocal
        this.heapData = replacementHeap
        gc()
        if (localData.value != 99 || !localData.onRegion ||
            heapData.value != 42 || heapData.onRegion) {
            throw Exception("nested finalizer field replacement was corrupted")
        }
        finalizedSum = localData.value + heapData.value
        finalizedCount++
        println("nested finalizer local: ${localData.value}, ${localData.onRegion}")
        println("nested finalizer heap: ${heapData.value}, ${heapData.onRegion}")
    }
}

func createFinalizer(): Unit {
    let value: NestedRegionFinalizer @local! = NestedRegionFinalizer(1) @local!
    if (value.localData.value != 1 || value.heapData.value != 2) {
        throw Exception("finalizer input was corrupted")
    }
}

main(): Unit {
    createFinalizer()
    if (finalizedCount != 1 || finalizedSum != 141) {
        throw Exception("nested finalizer did not run exactly once")
    }
    println("nested finalizer reassign count: ${finalizedCount}")
}
