/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

// Range clone over the local receiver: clone(this @local!, range: Range<Int64>): Array<T> @local!.
// The range parameter is an ordinary Range<Int64> (a Range<...>@local? parameter is not part of
// the adapted surface and aborts the obfuscation pass), so the range values are built locally and
// passed as plain values. These are positive compile-and-run tests; a rejected call is a failure.
var failed: Int64 = 0
var executedRows: Int64 = 0
var executedAssertions: Int64 = 0

func expect(want: Int64, got: Int64, label: String): Unit {
    executedAssertions++
    if (want != got) {
        failed++
        println("MISMATCH " + label + ": want " + want.toString() + " got " + got.toString())
    }
}

func heapReceiver(range: Range<Int64>, label: String): Unit {
    let source: Array<Int64> = [90, 10, 20, 30, 80]
    let originalSize = source.size
    let leftSentinel = source[0]
    let rightSentinel = source[source.size - 1]
    let selected = source[range.start]
    let expectedSize = range.end - range.start
    let copy: Array<Int64> = source.clone(range)
    executedRows++
    expect(expectedSize, copy.size, label + " size")
    if (copy.size == expectedSize) {
        for (i in 0..expectedSize) {
            expect(source[range.start + i], copy[i], label + " payload[" + i.toString() + "]")
        }
        copy[0] = selected + 17
        expect(selected, source[range.start], label + " clone mutation preserves source")
        source[range.start] = selected + 23
        expect(selected + 17, copy[0], label + " source mutation preserves clone")
    }
    expect(originalSize, source.size, label + " source size")
    expect(leftSentinel, source[0], label + " left sentinel")
    expect(rightSentinel, source[source.size - 1], label + " right sentinel")
}

func localReceiver(range: Range<Int64>, label: String): Unit {
    let source: Array<Int64> @local! = [90, 10, 20, 30, 80]
    let originalSize = source.size
    let leftSentinel = source[0]
    let rightSentinel = source[source.size - 1]
    let selected = source[range.start]
    let expectedSize = range.end - range.start
    let copy: Array<Int64> @local! = source.clone(range)
    executedRows++
    expect(expectedSize, copy.size, label + " size")
    if (copy.size == expectedSize) {
        for (i in 0..expectedSize) {
            expect(source[range.start + i], copy[i], label + " payload[" + i.toString() + "]")
        }
        copy[0] = selected + 17
        expect(selected, source[range.start], label + " clone mutation preserves source")
        source[range.start] = selected + 23
        expect(selected + 17, copy[0], label + " source mutation preserves clone")
    }
    expect(originalSize, source.size, label + " source size")
    expect(leftSentinel, source[0], label + " left sentinel")
    expect(rightSentinel, source[source.size - 1], label + " right sentinel")
}

main(): Int64 {
    let heapRange: Range<Int64> = 1..4
    let localRange: Range<Int64> = 1..4
    heapReceiver(heapRange, "heap/range<-heap")
    heapReceiver(localRange, "heap/range<-heap2")
    localReceiver(heapRange, "local!/range<-heap")
    localReceiver(localRange, "local!/range<-heap2")
    let plannedRows = 4
    let plannedAssertions = plannedRows * (1 + 3 + 2 + 3)
    expect(plannedRows, executedRows, "executed rows")
    // The count assertion itself is included in the reported executed count.
    expect(plannedAssertions + 1, executedAssertions, "executed semantic assertions plus row count")
    println("clone q_range planned=" + plannedRows.toString() + " executed=" + executedRows.toString() +
        " failed=" + failed.toString() + " disabled=0 executed_assertions=" + executedAssertions.toString())
    if (failed > 0 && failed % 256 == 0) { return 1 }
    failed
}
