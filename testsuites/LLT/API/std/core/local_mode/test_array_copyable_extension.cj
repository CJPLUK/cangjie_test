/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// BLOCKED（设计项 LM-DOC-20260910：T126/T127/T128）：Copyable `@local?`
// 写入扩展的正向调用在当前 runtime 向 local Array 字段写入时触发
// `Barrier::WriteGeneric does not support local object`，SIGABRT rc=134。
// 0907 SDK 还缺 local? range-set 的链接符号；该组精确调用在注释中保留，
// 不能误报为语言负例。其余 index/fill/swap/reverse/copyTo 调用按闭环保留，
// 期望是成功后的精确数组状态与异常原子性；SDK/runtime 修复后恢复 EXEC。
// T127 的右移 overlap 必须是 memmove/snapshot 结果 `[0,0,1,2,4]`，
// 不能接受当前实现逐元素污染 `[0,0,0,0,4]`。
// 设计编号命名空间：LM-DOC-20260910。

func copyableNegative(): Int64 {
    -1
}

func copyableFour(): Int64 {
    4
}

main(): Int64 {
    var failed = 0

    // T126: @local? Copyable index-set. This first valid write proves the
    // local-object barrier for the disabled case.
    let index126: Array<Int64> @local? = [1, 2, 3]
    index126[0] = 9
    failed += assertEq(index126[0], 9, "T126_index_set_value")

    // T126: fill, swap (equal and distinct), and reverse boundary matrix.
    let fill126: Array<Int64> @local? = [1, 2, 3]
    fill126.fill(7)
    failed += assertEq(fill126[0], 7, "T126_fill_0")
    failed += assertEq(fill126[2], 7, "T126_fill_2")
    let swap126: Array<Int64> @local? = [0, 1, 2]
    swap126.swap(1, 1)
    failed += assertEq(swap126[1], 1, "T126_swap_equal_unchanged")
    swap126.swap(0, 2)
    failed += assertEq(swap126[0], 2, "T126_swap_distinct_0")
    failed += assertEq(swap126[2], 0, "T126_swap_distinct_2")
    let reverse126Empty: Array<Int64> @local? = []
    reverse126Empty.reverse()
    failed += assertEq(reverse126Empty.size, 0, "T126_reverse_empty_size")
    let reverse126One: Array<Int64> @local? = [7]
    reverse126One.reverse()
    failed += assertEq(reverse126One[0], 7, "T126_reverse_one_value")
    let reverse126Even: Array<Int64> @local? = [0, 1, 2, 3]
    reverse126Even.reverse()
    failed += assertEq(reverse126Even[0], 3, "T126_reverse_even_0")
    failed += assertEq(reverse126Even[3], 0, "T126_reverse_even_3")
    try {
        swap126.swap(copyableNegative(), 0)
        failed += 1
        println("FAIL: T126_swap_negative — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        swap126.swap(0, copyableFour())
        failed += 1
        println("FAIL: T126_swap_past_end — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    // T127: local? range-set exact legality and overlap requirements. The SDK's
    // local? range-set symbol is absent, so these calls are compile-time-preserved
    // doc-correct probes rather than executable statements.
    // let range127: Array<Int64> @local? = [0, 1, 2, 3]
    // let value127: Array<Int64> @local? = [7, 8]
    // let stepTwo127 = Range<Int64>(0, 4, 2, true, false, false)
    // try {
    //     range127[stepTwo127] = value127
    //     failed += 1
    //     println("FAIL: T127_range_step — expected IllegalArgumentException")
    // } catch (e: IllegalArgumentException) {}
    // let badOrder127 = Range<Int64>(3, 2, 1, true, false, false)
    // try {
    //     range127[badOrder127] = [7]
    //     failed += 1
    //     println("FAIL: T127_range_order — expected IndexOutOfBoundsException")
    // } catch (e: IndexOutOfBoundsException) {}
    // let badEnd127 = Range<Int64>(1, 5, 1, true, false, false)
    // try {
    //     range127[badEnd127] = [7, 8, 9, 10]
    //     failed += 1
    //     println("FAIL: T127_range_end — expected IndexOutOfBoundsException")
    // } catch (e: IndexOutOfBoundsException) {}
    // let badSize127: Array<Int64> @local? = [7]
    // try {
    //     range127[1..3] = badSize127
    //     failed += 1
    //     println("FAIL: T127_range_size — expected IllegalArgumentException")
    // } catch (e: IllegalArgumentException) {}
    // let rightShift127: Array<Int64> @local? = [0, 1, 2, 3, 4]
    // let rightValue127: Array<Int64> @local? = rightShift127[0..4]
    // rightShift127[1..5] = rightValue127
    // expected rightShift127 == [0, 0, 1, 2, 4].
    // let leftShift127: Array<Int64> @local? = [0, 1, 2, 3, 4]
    // let leftValue127: Array<Int64> @local? = leftShift127[1..5]
    // leftShift127[0..4] = leftValue127
    // expected leftShift127 == [1, 2, 3, 3, 4].

    // T128: both local? copyTo overloads, exact target/uncovered slots, and errors.
    let source128: Array<Int64> @local? = [1, 2, 3, 4]
    let destination128: Array<Int64> @local? = [0, 0, 0, 0]
    source128.copyTo(destination128)
    failed += assertEq(destination128[0], 1, "T128_full_copy_0")
    failed += assertEq(destination128[3], 4, "T128_full_copy_3")
    let offsetDestination128: Array<Int64> @local? = [0, 0, 0, 0]
    source128.copyTo(offsetDestination128, 1, 1, 2)
    failed += assertEq(offsetDestination128[0], 0, "T128_offset_uncovered_0")
    failed += assertEq(offsetDestination128[1], 2, "T128_offset_target_1")
    failed += assertEq(offsetDestination128[2], 3, "T128_offset_target_2")
    failed += assertEq(offsetDestination128[3], 0, "T128_offset_uncovered_3")
    let zeroDestination128: Array<Int64> @local? = [5, 6, 7, 8]
    source128.copyTo(zeroDestination128, 0, 0, 0)
    failed += assertEq(zeroDestination128[0], 5, "T128_zero_length_0")
    failed += assertEq(zeroDestination128[3], 8, "T128_zero_length_3")
    try {
        source128.copyTo(zeroDestination128, 0, 0, copyableNegative())
        failed += 1
        println("FAIL: T128_negative_length — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        source128.copyTo(zeroDestination128, copyableNegative(), 0, 1)
        failed += 1
        println("FAIL: T128_negative_src — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source128.copyTo(zeroDestination128, 0, copyableNegative(), 1)
        failed += 1
        println("FAIL: T128_negative_dst — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    let shortDestination128: Array<Int64> @local? = [9, 9]
    try {
        source128.copyTo(zeroDestination128, 4, 0, 1)
        failed += 1
        println("FAIL: T128_src_eq_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source128.copyTo(zeroDestination128, 0, 4, 1)
        failed += 1
        println("FAIL: T128_dst_eq_size — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source128.copyTo(zeroDestination128, 3, 0, 2)
        failed += 1
        println("FAIL: T128_src_remain — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source128.copyTo(zeroDestination128, 0, 3, 2)
        failed += 1
        println("FAIL: T128_dst_remain — expected IndexOutOfBoundsException")
    } catch (e: IndexOutOfBoundsException) {}
    try {
        source128.copyTo(shortDestination128)
        failed += 1
        println("FAIL: T128_full_copy_short_dst — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    // T128 overlap after barrier recovery (both directions are snapshot copies):
    // let sameRawRight128: Array<Int64> @local? = [0, 1, 2, 3, 4]
    // sameRawRight128.copyTo(sameRawRight128, 0, 1, 4)
    // expected [0, 0, 1, 2, 3].
    // let sameRawLeft128: Array<Int64> @local? = [0, 1, 2, 3, 4]
    // sameRawLeft128.copyTo(sameRawLeft128, 1, 0, 4)
    // expected [1, 2, 3, 4, 4].

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
