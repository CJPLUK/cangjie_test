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

// The adapted surface exposes clone(this @local?) with no range argument; there is no
// clone(range) overload on an @local? receiver. This case covers the copy semantics of
// clone(this @local?) so the local? receiver path stays exercised: the clone is an
// independent copy that neither observes nor causes mutations of the source.
// These are positive compile-and-run tests; a rejected call is a failure.
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

func check(receiver: Array<Int64> @local?, expected: Array<Int64>, label: String): Unit {
    let originalSize = expected.size
    let leftSentinel = expected[0]
    let rightSentinel = expected[expected.size - 1]
    let copy: Array<Int64> @local? = receiver.clone()
    executedRows++
    expect(expected.size, copy.size, label + " size")
    if (copy.size == expected.size) {
        for (i in 0..expected.size) {
            expect(expected[i], copy[i], label + " payload[" + i.toString() + "]")
        }
        // The clone is an independent copy: source mutations do not leak into it.
        copy[0] = copy[0] + 17
        expect(expected[0], receiver[0], label + " clone mutation preserves source")
    }
    expect(originalSize, expected.size, label + " source size")
    expect(leftSentinel, expected[0], label + " left sentinel")
    expect(rightSentinel, expected[expected.size - 1], label + " right sentinel")
}

func fromHeap(label: String): Unit {
    let backing: Array<Int64> = [90, 10, 20, 30, 80]
    let source: Array<Int64> @local? = backing
    check(source, backing, label)
}

func fromLocal(label: String): Unit {
    let backing: Array<Int64> @local! = [90, 10, 20, 30, 80]
    let source: Array<Int64> @local? = backing
    // Compare against a heap copy: the @local! backing cannot be widened into the
    // plain Array parameter of check().
    check(source, [90, 10, 20, 30, 80], label)
}

main(): Int64 {
    fromHeap("q-receiver<-heap")
    fromLocal("q-receiver<-local!")
    let plannedRows = 2
    let plannedAssertions = plannedRows * (1 + 5 + 1 + 3)
    expect(plannedRows, executedRows, "executed rows")
    // The count assertion itself is included in the reported executed count.
    expect(plannedAssertions + 1, executedAssertions, "executed semantic assertions plus row count")
    println("clone q_receiver planned=" + plannedRows.toString() + " executed=" + executedRows.toString() +
        " failed=" + failed.toString() + " disabled=0 executed_assertions=" + executedAssertions.toString())
    if (failed > 0 && failed % 256 == 0) { return 1 }
    failed
}
