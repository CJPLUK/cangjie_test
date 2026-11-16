// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify CJ_MCC_GetAllocatedLocalObjectSize: it is zero without active local
// regions, reports allocated native chunk bytes while a scope is active,
// excludes the current chunk's unused tail, ignores heap objects, and falls
// back once the owning scope returns.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local object size pass

foreign func CJ_MCC_GetAllocatedLocalObjectSize(): UIntNative

func localObjectBytes(): Int64 {
    return Int64(unsafe { CJ_MCC_GetAllocatedLocalObjectSize() })
}

class LocalValue {
    var value: Int64
    var pad0: Int64 = 0
    var pad1: Int64 = 0

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

class HeapValue {
    var value: Int64

    init(value: Int64) {
        this.value = value
    }
}

var failures: Int64 = 0

func check(condition: Bool, label: String): Unit {
    if (!condition) {
        failures += 1
        println("local object size check failed: ${label}")
    }
}

// Live local objects are counted while their scope is active. The scope ends
// when this function returns, reclaiming all of its local objects.
func scopedLocalObjects(): Int64 {
    let scopeStart = localObjectBytes()
    var sum: Int64 = 0
    var afterFirst: Int64 = 0
    var afterSecond: Int64 = 0
    for (i in 0..100) {
        let value: LocalValue @local! = LocalValue(i) @local!
        sum += value.value
        if (i == 0) {
            afterFirst = localObjectBytes()
        }
        if (i == 1) {
            afterSecond = localObjectBytes()
        }
    }
    let scopeEnd = localObjectBytes()
    // Two small local objects fit in the initial 4 KiB native chunk. Only the
    // allocated [base, top) prefix is reported for that current chunk.
    check(afterFirst > scopeStart, "first local object increases accounted bytes")
    check(afterFirst - scopeStart < 4 * 1024, "current chunk unused tail is not counted")
    check(afterSecond > afterFirst, "second local object increases accounted bytes")
    check(scopeEnd >= afterSecond && scopeEnd >= scopeStart, "active local region remains accounted")

    // Heap allocations must not be counted as local object bytes.
    let beforeHeap = localObjectBytes()
    let heapValue = HeapValue(7)
    if (heapValue.value != 7) {
        failures += 1
        println("local object size check failed: heap object is broken")
    }
    let afterHeap = localObjectBytes()
    check(afterHeap == beforeHeap, "heap objects are not counted")
    return sum
}

main(): Int64 {
    let baseline = localObjectBytes()
    check(baseline == 0, "baseline is zero")

    let sum = scopedLocalObjects()
    check(sum == 4950, "scope produced expected values")

    // After the scope returns, its local objects are reclaimed.
    let afterScope = localObjectBytes()
    check(afterScope == baseline, "counter falls back after scope end")

    if (failures == 0) {
        println("local object size pass")
        return 0
    }
    return 1
}
