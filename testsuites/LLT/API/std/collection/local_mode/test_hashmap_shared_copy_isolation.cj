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

import std.collection.*

func check(condition: Bool, message: String): Unit {
    if (!condition) {
        println("CHECK FAILED: ${message}")
        throw Exception(message)
    }
}

func testHashMapCopy(): Unit {
    let source: HashMap<Int64, Int64> = HashMap<Int64, Int64>()
    source.add(1, 10)
    source.add(2, 20)
    source.remove(2)
    let input: Collection<(Int64, Int64)> @local? = source
    let copied: HashMap<Int64, Int64> @local? = HashMap<Int64, Int64>(input) @local?
    source.add(3, 30)
    source.add(1, 99)
    check(copied.size == 1 && !copied.contains(3) && copied[1] == 10,
        "a copy must retain its original entries when the source changes")
    source.remove(1)
    source.reserve(64)
    source.clear()
    check(copied.size == 1 && copied.contains(1) && copied[1] == 10,
        "removal, resizing and clearing the source must not affect the copy")
    let it: Iterator<(Int64, Int64)> @local? = copied.iterator()
    check(match (it.next()) {
        case Some(pair) => pair[0] == 1 && pair[1] == 10
        case None => false
    }, "the copied iterator must agree with size and lookup")
    check(match (it.next()) { case None => true; case _ => false },
        "the copied iterator must end after the copied entries")

    let strings: HashMap<String, String> = HashMap<String, String>()
    strings.add("key", "original")
    let stringInput: Collection<(String, String)> @local? = strings
    let stringCopy: HashMap<String, String> @local? = HashMap<String, String>(stringInput) @local?
    strings.add("key", "changed")
    check(stringCopy["key"] == "original", "non-Copyable keys and values must remain usable")
}

main(): Int64 {
    testHashMapCopy()
    println("ALL PASSED")
    return 0
}
