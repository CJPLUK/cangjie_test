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

// T403 / S403 / P403: constructor members and complete payloads across growth.

import std.collection.*
import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func elementValue(index: Int64): Int64 { index * 17 - 3 }

func arraySource(count: Int64): String {
    var source = "["
    for (index in 0..count) {
        if (index > 0) { source = source + "," }
        source = source + elementValue(index).toString()
    }
    source + "]"
}

func objectSource(count: Int64): String {
    var source = "{"
    for (index in 0..count) {
        if (index > 0) { source = source + "," }
        source = source + "\"k" + index.toString() + "\":" + elementValue(index).toString()
    }
    source + "}"
}

exclave func checkArray(array: JsonArray @local!, count: Int64, changed: Bool): Unit {
    let wantedSize = if (changed) { count + 1 } else { count }
    check(array.size() == wantedSize, "array size")
    for (index in 0..count) {
        let wanted = if (changed && index == 0) { -999 } else { elementValue(index) }
        check(array[index].asInt().getValue() == wanted, "array element payload")
    }
    if (changed) { check(array[count].asInt().getValue() == 700 + count, "array appended payload") }
}

exclave func checkObject(object: JsonObject @local!, count: Int64, changed: Bool): Unit {
    let wantedSize = if (changed) { count + 1 } else { count }
    check(object.size() == wantedSize, "object size")
    for (index in 0..wantedSize) {
        let key: String @local! = String("k" + index.toString()) @local!
        check(object.containsKey(key), "object key")
        let wanted = if (changed && index == 0) { -999 }
            else if (index == count) { 700 + count } else { elementValue(index) }
        check(object[key].asInt().getValue() == wanted, "object member payload")
    }
}

func checkMapConstructor(): Unit {
    let fields: HashMap<String, JsonValue> @local! = HashMap<String, JsonValue>(2) @local!
    let nullKey: String @local! = "n"
    let stringKey: String @local! = "s"
    fields.add(nullKey, JsonNull() @local!)
    fields.add(stringKey, JsonString("seed&") @local!)
    let object: JsonObject @local! = JsonObject(fields) @local!
    check(object.size() == 2, "nonempty map constructor size")
    match (object["n"].kind()) {
        case JsonKind.JsNull => ()
        case _ => throw Exception("nonempty map constructor null payload")
    }
    check(object["s"].asString().getValue() == "seed&", "nonempty map constructor string payload")
    let encoded: String @local! = object.toString()
    let parsedValue: JsonValue @local! = JsonValue.fromStr(encoded)
    let parsed: JsonObject @local! = parsedValue.asObject()
    check(parsed.size() == 2 && parsed["s"].asString().getValue() == "seed&", "constructor round trip payload")
    match (parsed["n"].kind()) {
        case JsonKind.JsNull => ()
        case _ => throw Exception("constructor round trip null payload")
    }
}

func checkGrowth(count: Int64): Unit {
    let arrayText: String @local! = String(arraySource(count)) @local!
    let arrayValue: JsonValue @local! = JsonValue.fromStr(arrayText)
    let array: JsonArray @local! = arrayValue.asArray()
    checkArray(array, count, false)
    let beforeArray: String @local! = array.toString()
    let items: ArrayList<JsonValue> @local! = array.getItems()
    items[0] = JsonInt(-999) @local!
    let returned: JsonArray @local! = array.add(JsonInt(700 + count) @local!)
    checkArray(returned, count, true)
    checkArray(array, count, true)
    let compactArray: String @local! = array.toString()
    let compactArrayValue: JsonValue @local! = JsonValue.fromStr(compactArray)
    let compactArrayResult: JsonArray @local! = compactArrayValue.asArray()
    checkArray(compactArrayResult, count, true)
    let prettyArray: String @local! = array.toJsonString()
    let prettyArrayValue: JsonValue @local! = JsonValue.fromStr(prettyArray)
    let prettyArrayResult: JsonArray @local! = prettyArrayValue.asArray()
    checkArray(prettyArrayResult, count, true)
    check(beforeArray == arrayText, "array output before mutation")

    let objectText: String @local! = String(objectSource(count)) @local!
    let objectValue: JsonValue @local! = JsonValue.fromStr(objectText)
    let object: JsonObject @local! = objectValue.asObject()
    checkObject(object, count, false)
    let beforeObject: String @local! = object.toString()
    object.put("k0", JsonInt(-999) @local!)
    let lastKey: String @local! = String("k" + count.toString()) @local!
    object.put(lastKey, JsonInt(700 + count) @local!)
    checkObject(object, count, true)
    let compactObject: String @local! = object.toString()
    let compactObjectValue: JsonValue @local! = JsonValue.fromStr(compactObject)
    let compactObjectResult: JsonObject @local! = compactObjectValue.asObject()
    checkObject(compactObjectResult, count, true)
    let prettyObject: String @local! = object.toJsonString()
    let prettyObjectValue: JsonValue @local! = JsonValue.fromStr(prettyObject)
    let prettyObjectResult: JsonObject @local! = prettyObjectValue.asObject()
    checkObject(prettyObjectResult, count, true)
    let oldObjectValue: JsonValue @local! = JsonValue.fromStr(beforeObject)
    let oldObject: JsonObject @local! = oldObjectValue.asObject()
    checkObject(oldObject, count, false)
}

main(): Int64 {
    checkMapConstructor()
    for (count in [7, 8, 9, 12]) { checkGrowth(count) }
    println("ALL PASSED")
    0
}
