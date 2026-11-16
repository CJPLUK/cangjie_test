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

// T503 / S503 / P503: array slots are copied and child references are retained.

import std.collection.*
import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func checkHeap(): Unit {
    let child: JsonArray = JsonArray()
    child.add(JsonInt(1))
    let source: Array<JsonValue> = [child, JsonInt(10)]
    let value: JsonArray = JsonArray(source)
    source[1] = JsonInt(99)
    check(value[1].asInt().getValue() == 10, "heap array source slots are copied")
    value.getItems()[1] = JsonInt(20)
    check(source[1].asInt().getValue() == 99, "heap JSON slot does not replace source slot")
    child.add(JsonInt(2))
    value[0].asArray().add(JsonInt(3))
    check(source[0].asArray().size() == 3, "heap nested child is retained")
    check(value[0].asArray()[2].asInt().getValue() == 3, "heap nested child payload")
    value.add(JsonInt(30))
    check(source.size == 2 && value.size() == 3, "heap array length is independent")
    let empty: Array<JsonValue> = []
    let grown: JsonArray = JsonArray(empty)
    grown.add(JsonInt(40))
    check(empty.size == 0 && grown[0].asInt().getValue() == 40, "heap empty array storage")
}

func checkLocal(): Unit {
    let child: JsonArray @local! = JsonArray() @local!
    child.add(JsonInt(1) @local!)
    let source: Array<JsonValue> @local! = [child, JsonInt(10) @local!]
    let value: JsonArray @local! = JsonArray(source) @local!
    source[1] = JsonInt(99) @local!
    check(value[1].asInt().getValue() == 10, "local array source slots are copied")
    let items: ArrayList<JsonValue> @local! = value.getItems()
    items[1] = JsonInt(20) @local!
    check(source[1].asInt().getValue() == 99, "local JSON slot does not replace source slot")
    child.add(JsonInt(2) @local!)
    value[0].asArray().add(JsonInt(3) @local!)
    check(source[0].asArray().size() == 3, "local nested child is retained")
    check(value[0].asArray()[2].asInt().getValue() == 3, "local nested child payload")
    value.add(JsonInt(30) @local!)
    check(source.size == 2 && value.size() == 3, "local array length is independent")
    let empty: Array<JsonValue> @local! = []
    let grown: JsonArray @local! = JsonArray(empty) @local!
    grown.add(JsonInt(40) @local!)
    check(empty.size == 0 && grown[0].asInt().getValue() == 40, "local empty array storage")
}

main(): Int64 {
    checkHeap()
    checkLocal()
    println("ALL PASSED")
    0
}
