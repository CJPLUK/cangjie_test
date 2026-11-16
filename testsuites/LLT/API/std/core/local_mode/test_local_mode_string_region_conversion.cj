/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
// T204, T205, T207: string copies and returned strings survive their source frame.

// Return a heap copy of a local string.
func produceHeapCopy(): String {
    let source: String @local! = "L仓\u{1F600}"
    let q: String @local? = source
    return String(q)
}

// Return a local string allocated in the callee.
exclave func produceLocalToString(q: String @local?): String @local! {
    return q.toString()
}

main(): Int64 {
    var failed = 0

    // Copy a shared local string into a fully local string.
    let src204: String @local! = "region-value"
    let q204: String @local? = src204
    let out204: String @local! = String(q204)
    failed += assertB(out204 == "region-value", "T204_regionQ_toLocal_value")
    failed += assertEq(out204.size, 12, "T204_regionQ_toLocal_size")
    // Copy a shared local string to the heap.
    let out204b: String = String(q204)
    failed += assertB(out204b == "region-value", "T204_regionQ_toHeap_value")

    // Read the heap copy after its source frame returns.
    let heapCopy205: String = produceHeapCopy()
    failed += assertB(heapCopy205 == "L仓\u{1F600}", "T205_afterExit_value")
    failed += assertEq(heapCopy205.size, 8, "T205_afterExit_size")
    let raw205: Array<Byte> = heapCopy205.toArray()
    failed += assertEq(raw205.size, 8, "T205_afterExit_bytes_size")
    failed += assertEq(raw205[0], 0x4Cu8, "T205_bytes_0")
    failed += assertEq(raw205[1], 0xE4u8, "T205_bytes_1")
    failed += assertEq(raw205[3], 0x93u8, "T205_bytes_3")
    failed += assertEq(raw205[4], 0xF0u8, "T205_bytes_4")
    failed += assertEq(raw205[7], 0x80u8, "T205_bytes_7")
    // Read the same heap copy from another local region.
    let again205: String @local! = String("again")
    failed += assertB(heapCopy205 == "L仓\u{1F600}", "T205_newRegion_value")
    failed += assertEq(again205.size, 5, "T205_newRegion_local_ok")

    // Read a local result after the callee returns.
    let heap207: String = "仓颉Jie"
    let q207: String @local? = heap207
    let out207: String @local! = produceLocalToString(q207)
    failed += assertB(out207 == "仓颉Jie", "T207_toString_value")
    failed += assertEq(out207.size, 9, "T207_toString_size")
    let raw207: Array<Byte> @local! = out207.toArray()
    failed += assertEq(raw207[0], 0xE4u8, "T207_bytes_0")
    failed += assertEq(raw207[6], 0x4Au8, "T207_bytes_6")
    // Check the same return path for a shared local source.
    let local207: String @local! = "ab¢"
    let q207b: String @local? = local207
    let out207b: String @local! = produceLocalToString(q207b)
    failed += assertB(out207b == "ab¢", "T207_toString_regionQ_value")
    failed += assertEq(out207b.size, 4, "T207_toString_regionQ_size")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
