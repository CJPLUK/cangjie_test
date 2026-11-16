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

// T505 / S505 / P505: map constructors and accessors retain member storage.

import std.collection.*
import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func checkHeap(): Unit {
    let fields: HashMap<String, JsonValue> = HashMap<String, JsonValue>()
    let value: JsonObject = JsonObject(fields)
    fields.add("seed", JsonInt(1))
    check(value.size() == 1 && value["seed"].asInt().getValue() == 1, "heap empty map is retained")
    value.put("seed", JsonInt(2))
    value.put("added", JsonInt(3))
    check(fields.size == 2 && fields["seed"].asInt().getValue() == 2, "heap JSON updates source map")
    check(fields["added"].asInt().getValue() == 3, "heap JSON insert is visible")
    let child: JsonArray = JsonArray()
    child.add(JsonInt(4))
    fields.add("child", child)
    let second: JsonObject = JsonObject(fields)
    second["child"].asArray().add(JsonInt(5))
    check(value["child"].asArray().size() == 2, "heap nested child is retained")
    check(child[1].asInt().getValue() == 5, "heap nested child payload")
    second.getFields().add("last", JsonInt(6))
    check(value.size() == 4 && fields["last"].asInt().getValue() == 6, "heap fields accessor retains map")
}

func checkLocal(): Unit {
    let fields: HashMap<String, JsonValue> @local! = HashMap<String, JsonValue>() @local!
    let value: JsonObject @local! = JsonObject(fields) @local!
    fields.add("seed", JsonInt(1) @local!)
    check(value.size() == 1 && value["seed"].asInt().getValue() == 1, "local empty map is retained")
    value.put("seed", JsonInt(2) @local!)
    value.put("added", JsonInt(3) @local!)
    check(fields.size == 2 && fields["seed"].asInt().getValue() == 2, "local JSON updates source map")
    check(fields["added"].asInt().getValue() == 3, "local JSON insert is visible")
    let child: JsonArray @local! = JsonArray() @local!
    child.add(JsonInt(4) @local!)
    fields.add("child", child)
    let second: JsonObject @local! = JsonObject(fields) @local!
    second["child"].asArray().add(JsonInt(5) @local!)
    check(value["child"].asArray().size() == 2, "local nested child is retained")
    check(child[1].asInt().getValue() == 5, "local nested child payload")
    let exposed: HashMap<String, JsonValue> @local! = second.getFields()
    exposed.add("last", JsonInt(6) @local!)
    check(value.size() == 4 && fields["last"].asInt().getValue() == 6, "local fields accessor retains map")
}

main(): Int64 {
    checkHeap()
    checkLocal()
    println("ALL PASSED")
    0
}
