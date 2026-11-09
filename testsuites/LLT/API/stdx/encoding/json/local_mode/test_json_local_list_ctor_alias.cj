/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %import-cangjie-stdx %cmp_opt %f -o %output
// EXEC: %set_stdx_path %run %run_opt %output %run_args

// T504 / S504 / P504: list mutations remain visible through JSON constructors.

import std.collection.*
import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func checkHeap(): Unit {
    let source: ArrayList<JsonValue> = ArrayList<JsonValue>()
    let value: JsonArray = JsonArray(source)
    for (index in 0..10) { source.add(JsonInt(index * 3)) }
    check(value.size() == 10, "heap source growth is visible")
    for (index in 0..10) { check(value[index].asInt().getValue() == index * 3, "heap list payload") }
    source[0] = JsonInt(-1)
    check(value[0].asInt().getValue() == -1, "heap source replacement is visible")
    value.getItems()[1] = JsonInt(-2)
    value.add(JsonInt(30))
    check(source.size == 11 && source[1].asInt().getValue() == -2, "heap JSON replacement is visible")
    check(source[10].asInt().getValue() == 30, "heap JSON append is visible")
    let second: JsonArray = JsonArray(source)
    second.add(JsonInt(33))
    check(value.size() == 12 && value[11].asInt().getValue() == 33, "heap nonempty constructor aliases list")
}

func checkLocal(): Unit {
    let source: ArrayList<JsonValue> @local! = ArrayList<JsonValue>() @local!
    let value: JsonArray @local! = JsonArray(source) @local!
    for (index in 0..10) { source.add(JsonInt(index * 3) @local!) }
    check(value.size() == 10, "local source growth is visible")
    for (index in 0..10) { check(value[index].asInt().getValue() == index * 3, "local list payload") }
    source[0] = JsonInt(-1) @local!
    check(value[0].asInt().getValue() == -1, "local source replacement is visible")
    let items: ArrayList<JsonValue> @local! = value.getItems()
    items[1] = JsonInt(-2) @local!
    value.add(JsonInt(30) @local!)
    check(source.size == 11 && source[1].asInt().getValue() == -2, "local JSON replacement is visible")
    check(source[10].asInt().getValue() == 30, "local JSON append is visible")
    let second: JsonArray @local! = JsonArray(source) @local!
    second.add(JsonInt(33) @local!)
    check(value.size() == 12 && value[11].asInt().getValue() == 33, "local nonempty constructor aliases list")
}

main(): Int64 {
    checkHeap()
    checkLocal()
    println("ALL PASSED")
    0
}
