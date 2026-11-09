/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func assertEq<T>(actual: T, expected: T, name: String): Int64 where T <: ToString & Equatable<T> {
    if (actual != expected) {
        println("FAIL: ${name} — expected ${expected}, got ${actual}")
        return 1
    }
    return 0
}

func transferArrayToCallerRegion(seed: Int64): Array<Int64> @local! {
    exclave {
        let result: Array<Int64> @local! = [seed, seed + 1, seed + 2]
        result
    }
}

func probeLocalIterator(a: Array<Int64> @local!, expected: Array<Int64> @local!): Int64 {
    exclave {
        let it: Iterator<Int64> @local! = a.iterator()
        var index: Int64 = 0
        var failure: Int64 = 0
        var running: Bool = true
        while (running) {
            match (it.next()) {
                case Some(v) =>
                    if (index >= expected.size || v != expected[index]) { failure = 1 }
                    index += 1
                case None =>
                    running = false
            }
        }
        if (index != expected.size) { failure = 2 }
        failure
    }
}

main(): Int64 {
    var failed = 0

    let transferred: Array<Int64> @local! = transferArrayToCallerRegion(40)

    transferred[2] = 99

    failed += assertEq(transferred.size, 3, "h06_size")
    failed += assertEq(transferred[0], 40, "h06_elem0")
    failed += assertEq(transferred[1], 41, "h06_elem1")
    failed += assertEq(transferred[2], 99, "h06_elem2")

    // iterator()/next() on @local! 由 std 库提供；Option @local! 无跨 mode 比较
    // 重载，因此逐元素窄化并与期望序列比对。
    let expectedIterated: Array<Int64> @local! = [40, 41, 99]
    failed += assertEq(probeLocalIterator(transferred, expectedIterated), 0, "h06_iterated_payload")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
