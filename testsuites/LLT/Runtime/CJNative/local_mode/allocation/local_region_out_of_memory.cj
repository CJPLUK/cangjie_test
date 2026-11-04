// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A local region has an independent allocation limit. The configured 4KB limit
// is smaller than the local Int64 array payload, so the allocation must throw
// LocalRegionOutOfMemoryError instead of falling back to the tracing heap.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: export cjLocalRegionMaxSize=4KB && %run %run_opt %output %run_args | compare %f
// ASSERT: scan caught local region out of memory

func exceedLocalRegionLimit(): Unit {
    let values: Array<Int64> @local! = Array<Int64>(1024, { i => i }) @local!
    println("unexpected local array value: ${values[1023]}")
}

main(): Int64 {
    try {
        exceedLocalRegionLimit()
    } catch (_: LocalRegionOutOfMemoryError) {
        println("caught local region out of memory")
        return 0
    }
    println("LocalRegionOutOfMemoryError was not thrown")
    return 1
}
