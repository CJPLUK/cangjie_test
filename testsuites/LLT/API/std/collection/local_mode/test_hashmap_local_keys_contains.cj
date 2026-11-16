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

func testHashMapKeysContains(): Unit {
    let source: HashMap<Int64, Int64> = HashMap<Int64, Int64>()
    source.add(1, 10)
    source.add(2, 20)
    let view: HashMap<Int64, Int64> @local? = source
    let keys: EquatableCollection<Int64> @local? = view.keys()
    check(keys.contains(1) && !keys.contains(3), "key membership must use the local overload")
    let present: Array<Int64> @local? = [1, 2]
    let missing: Array<Int64> @local? = [1, 3]
    let empty: Array<Int64> @local? = []
    check(keys.contains(all: present), "contains(all:) must accept existing keys")
    check(!keys.contains(all: missing), "contains(all:) must reject a missing key")
    check(keys.contains(all: empty), "contains(all:) must accept an empty collection")
    source.remove(1)
    check(!keys.contains(1), "a key view must reflect subsequent map changes")
}

main(): Int64 {
    testHashMapKeysContains()
    println("ALL PASSED")
    return 0
}
