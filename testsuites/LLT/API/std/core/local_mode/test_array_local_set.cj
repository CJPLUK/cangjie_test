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
// T121-T125: check local array writes, boundaries, and failed-copy atomicity.

func setNegative(): Int64 {
    -1
}

func setFour(): Int64 {
    4
}


main(): Int64 {
    var failed = 0

    // T121: local element assignment supports non-Copyable values.
    let text121: Array<String> @local! = ["before", "keep"]
    let replacement121: String @local! = "after"
    text121[0] = replacement121
    failed += assertB(text121[0] == "after", "T121_string_index_set_value")
    // Check the same assignment with Int64 elements.
    let ints121: Array<Int64> @local! = [1, 2]
    ints121[1] = 9
    failed += assertEq(ints121[1], 9, "T121_int64_index_set_value")
    try {
        let _ = text121[setNegative()]
        failed += 1
        println("FAIL: T121_index_negative — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        text121[setFour()] = replacement121
        failed += 1
        println("FAIL: T121_index_past_end — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}

    // Range arguments use the ordinary mode required by the current API.
    let srcBang: Array<Int64> @local! = [7, 8, 9]
    let arrE1: Array<Int64> @local! = [0, 0, 0, 9]
    let rE1: Range<Int64> = 0..3
    arrE1[rE1] = srcBang
    failed += assertEq(arrE1[0], 7, "E1_range_local_q_set_0")
    failed += assertEq(arrE1[1], 8, "E1_range_local_q_set_1")
    failed += assertEq(arrE1[2], 9, "E1_range_local_q_set_2")
    failed += assertEq(arrE1[3], 9, "E1_range_local_q_set_outside")
    // Check range assignment with a literal range.
    let arrE1b: Array<Int64> @local! = [1, 2, 3, 4]
    arrE1b[1..3] = [5, 6]
    failed += assertEq(arrE1b[1], 5, "E1_range_literal_set_1")
    failed += assertEq(arrE1b[2], 6, "E1_range_literal_set_2")

    // Range-assignment overlap is covered in test_array_local_overlap_assignment.cj.

    // T123: check fill, swap, and reverse boundaries.
    let empty123: Array<Int64> @local! = []
    empty123.fill(9)
    failed += assertEq(empty123.size, 0, "T123_fill_empty_size")
    let filled123: Array<Int64> @local! = [1, 2, 3]
    filled123.fill(9)
    failed += assertEq(filled123[0], 9, "T123_fill_0")
    failed += assertEq(filled123[1], 9, "T123_fill_1")
    failed += assertEq(filled123[2], 9, "T123_fill_2")
    let swap123: Array<Int64> @local! = [0, 1, 2]
    try {
        swap123.swap(setNegative(), 0)
        failed += 1
        println("FAIL: T123_swap_first_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        swap123.swap(0, setFour())
        failed += 1
        println("FAIL: T123_swap_second_past_end — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    swap123.swap(1, 1)
    failed += assertEq(swap123[1], 1, "T123_swap_same_index_unchanged")
    swap123.swap(0, 2)
    failed += assertEq(swap123[0], 2, "T123_swap_distinct_0")
    failed += assertEq(swap123[2], 0, "T123_swap_distinct_2")
    let reverseEmpty123: Array<Int64> @local! = []
    reverseEmpty123.reverse()
    failed += assertEq(reverseEmpty123.size, 0, "T123_reverse_empty_size")
    let reverseOne123: Array<Int64> @local! = [7]
    reverseOne123.reverse()
    failed += assertEq(reverseOne123[0], 7, "T123_reverse_one_value")
    let reverseEven123: Array<Int64> @local! = [0, 1, 2, 3]
    reverseEven123.reverse()
    failed += assertEq(reverseEven123[0], 3, "T123_reverse_even_0")
    failed += assertEq(reverseEven123[3], 0, "T123_reverse_even_3")
    let reverseOdd123: Array<Int64> @local! = [0, 1, 2, 3, 4]
    reverseOdd123.reverse()
    failed += assertEq(reverseOdd123[0], 4, "T123_reverse_odd_0")
    failed += assertEq(reverseOdd123[2], 2, "T123_reverse_odd_middle")
    failed += assertEq(reverseOdd123[4], 0, "T123_reverse_odd_4")

    // T124: rejected copyTo calls must leave the destination unchanged.
    let source124: Array<Int64> @local! = [1, 2, 3, 4]
    let destination124: Array<Int64> @local! = [0, 0, 0, 0]
    source124.copyTo(destination124, 1, 1, 2)
    failed += assertEq(destination124[0], 0, "T124_offset_uncovered_0")
    failed += assertEq(destination124[1], 2, "T124_offset_target_1")
    failed += assertEq(destination124[2], 3, "T124_offset_target_2")
    failed += assertEq(destination124[3], 0, "T124_offset_uncovered_3")
    let zeroDestination124: Array<Int64> @local! = [5, 6, 7, 8]
    source124.copyTo(zeroDestination124, 0, 0, 0)
    failed += assertEq(zeroDestination124[0], 5, "T124_zero_length_noop_0")
    failed += assertEq(zeroDestination124[3], 8, "T124_zero_length_noop_3")
    try {
        source124.copyTo(zeroDestination124, 0, 0, setNegative())
        failed += 1
        println("FAIL: T124_negative_length — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        source124.copyTo(zeroDestination124, setNegative(), 0, 1)
        failed += 1
        println("FAIL: T124_negative_src — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source124.copyTo(zeroDestination124, 0, setNegative(), 1)
        failed += 1
        println("FAIL: T124_negative_dst — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source124.copyTo(zeroDestination124, setFour(), 0, 1)
        failed += 1
        println("FAIL: T124_src_at_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source124.copyTo(zeroDestination124, 0, setFour(), 1)
        failed += 1
        println("FAIL: T124_dst_at_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source124.copyTo(zeroDestination124, 3, 0, 2)
        failed += 1
        println("FAIL: T124_src_remaining — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source124.copyTo(zeroDestination124, 0, 3, 2)
        failed += 1
        println("FAIL: T124_dst_remaining — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    let shortDestination124: Array<Int64> @local! = [9, 9]
    try {
        source124.copyTo(shortDestination124)
        failed += 1
        println("FAIL: T124_full_copy_short_dst — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T125: copyTo overlap requires a separate compiler-lowering regression test.

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
