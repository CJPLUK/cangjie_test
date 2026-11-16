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

import stdx.encoding.json.*

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkLengthPaths(): Unit {
    for (size in [0, 1, 30, 31, 32, 33, 47, 48, 49, 96, 97]) {
        let heapPayload = "a" * size
        let payload: String @local! = String(heapPayload) @local!
        let value: JsonString @local! = JsonString(payload) @local!
        let expected = "\"" + heapPayload + "\""
        check(value.toString() == expected, "writer length and capacity boundaries")
        let heapEscaped = "&" * size
        let escaped: String @local! = String(heapEscaped) @local!
        let escapedValue: JsonString @local! = JsonString(escaped) @local!
        let escapedExpected = "\"" + "\\u0026" * size + "\""
        let rawExpected = "\"" + heapEscaped + "\""
        check(escapedValue.toString() == escapedExpected, "escape expansion across capacity boundaries")
        check(escapedValue.toStringWithoutEscaping() == rawExpected, "HTML-safe flag must not leak between calls")
    }
}

func checkErrorRecoveryAndModes(): Unit {
    let source = "[1,\"&\",{\"n\":null},true]"
    let expected = "[1,\"\\u0026\",{\"n\":null},true]"
    let heap = JsonValue.fromStr(source)
    let value: JsonValue @local! = JsonValue.fromStr(source)
    check(heap.toString() == expected && value.toString() == expected, "heap and local graph rendering")
    let array: JsonArray @local! = value.asArray()
    var caught = false
    try { let _: String @local! = array.toJsonString(100, indent: " ") }
    catch (_: JsonException) { caught = true }
    check(caught, "nested output exceeds the depth limit")
    check(array.toString() == expected, "compact output recovers after a writer error")
    check(array.toStringWithoutEscaping() == source, "escaping option recovers after a writer error")
    let result: String @local! = array.toString()
    let parsed: JsonArray @local! = JsonValue.fromStr(result).asArray()
    check(parsed.size() == 4 && parsed[0].asInt().getValue() == 1, "round trip after a writer error")
    check(parsed[1].asString().getValue() == "&" && parsed[3].asBool().getValue(), "round trip payloads")
}

func checkArrayMutation(): Unit {
    let array: JsonArray @local! = JsonArray() @local!
    array.add(JsonInt(1) @local!)
    let first: String @local! = array.toString()
    check(first == "[1]", "initial array rendering")
    let items = array.getItems()
    items.add(JsonString("longer value") @local!)
    check(array.toString() == "[1,\"longer value\"]", "writer must recompute capacity after external append")
    items[0] = JsonInt(9) @local!
    items.remove(at: 1)
    check(array.toString() == "[9]" && first == "[1]", "replacement, removal, and snapshot independence")
    items.clear()
    check(array.toString() == "[]", "writer after external clear")
    array.add(JsonBool(true) @local!)
    check(array.toString() == "[true]", "writer after clear and refill")
}

func checkObjectMutation(): Unit {
    let object: JsonObject @local! = JsonObject() @local!
    object.put("k", JsonInt(1) @local!)
    let before: String @local! = object.toString()
    let fields = object.getFields()
    fields.add("k", JsonString("&") @local!)
    check(object.toString() == "{\"k\":\"\\u0026\"}", "writer observes external map replacement")
    check(object.toStringWithoutEscaping() == "{\"k\":\"&\"}", "writer escaping option")
    fields.remove("k")
    check(object.toString() == "{}" && before == "{\"k\":1}", "writer observes external removal")
    object.put("n", JsonNull() @local!)
    let text: String @local! = object.toString()
    let parsed: JsonObject @local! = JsonValue.fromStr(text).asObject()
    check(parsed.size() == 1, "object round trip size after mutation")
    match (parsed["n"].kind()) {
        case JsonKind.JsNull => ()
        case _ => throw Exception("object round trip null value")
    }
}

main(): Int64 {
    checkLengthPaths()
    checkErrorRecoveryAndModes()
    checkArrayMutation()
    checkObjectMutation()
    println("ALL PASSED")
    0
}
