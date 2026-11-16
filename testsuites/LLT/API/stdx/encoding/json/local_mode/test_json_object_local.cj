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
// T520-T523, T532: check local JsonObject construction, lookup, mutation, and shared heap views.

import stdx.encoding.json.*
import std.collection.*

func fail(label: String): Int64 {
    println("FAIL: ${label}")
    1
}

exclave func expectIndexError(object: JsonObject @local!, label: String): Int64 {
    try {
        let _: JsonValue @local! = object["missing"]
        fail("${label}_accepted")
    } catch (_: JsonException) {
        0
    }
}

exclave func checkLocalObject(object: JsonObject @local!, label: String): Int64 {
    var failed: Int64 = 0
    match (object.kind()) {
        case JsonKind.JsObject => ()
        case _ => failed += fail("${label}_kind")
    }
    if (object.size() != 2) { failed += fail("${label}_size") }
    if (!object.containsKey("n") || !object.containsKey("x") || object.containsKey("missing")) {
        failed += fail("${label}_contains")
    }
    match (object.get("n")) {
        case Some(value) =>
            match (value.kind()) {
                case JsonKind.JsNull => ()
                case _ => failed += fail("${label}_null_kind")
            }
        case None => failed += fail("${label}_null_missing")
    }
    match (object.get("x")) {
        case Some(value) =>
            if (value.toString() != "1") { failed += fail("${label}_get_x") }
        case None => failed += fail("${label}_x_missing")
    }
    match (object.get("missing")) {
        case Some(_) => failed += fail("${label}_get_missing_hit")
        case None => ()
    }
    if (object["x"].toString() != "1") { failed += fail("${label}_index_x") }
    failed += expectIndexError(object, "${label}_index_missing")
    if (object.getFields().size != 2) { failed += fail("${label}_getFields_size") }
    failed
}

exclave func checkLocalObjectHalf(object: JsonObject @local!, label: String): Int64 {
    let view: JsonObject @local? = object
    var failed: Int64 = 0
    match (view.kind()) {
        case JsonKind.JsObject => ()
        case _ => failed += fail("${label}_kind")
    }
    if (view.size() != 2) { failed += fail("${label}_size") }
    if (!view.containsKey("n") || !view.containsKey("x") || view.containsKey("missing")) {
        failed += fail("${label}_contains")
    }
    match (view.get("n")) {
        case Some(value) =>
            match (value.kind()) {
                case JsonKind.JsNull => ()
                case _ => failed += fail("${label}_null_kind")
            }
        case None => failed += fail("${label}_null_missing")
    }
    match (view.get("missing")) {
        case Some(_) => failed += fail("${label}_get_missing_hit")
        case None => ()
    }
    if (view["x"].toString() != "1") { failed += fail("${label}_index_x") }
    try {
        let _: JsonValue @local? = view["missing"]
        failed += fail("${label}_index_missing_accepted")
    } catch (_: JsonException) {
        ()
    }
    if (view.getFields().size != 2) { failed += fail("${label}_getFields_size") }
    failed
}

func checkHeapObjectHalf(object: JsonObject, label: String): Int64 {
    let view: JsonObject @local? = object
    var failed: Int64 = 0
    match (view.kind()) {
        case JsonKind.JsObject => ()
        case _ => failed += fail("${label}_kind")
    }
    if (view.size() != 2 || view.getFields().size != 2) {
        failed += fail("${label}_size")
    }
    if (!view.containsKey("n") || !view.containsKey("x") || view.containsKey("missing")) {
        failed += fail("${label}_contains")
    }
    match (view.get("n")) {
        case Some(value) =>
            match (value.kind()) {
                case JsonKind.JsNull => ()
                case _ => failed += fail("${label}_null_kind")
            }
        case None => failed += fail("${label}_null_missing")
    }
    match (view.get("missing")) {
        case Some(_) => failed += fail("${label}_get_missing_hit")
        case None => ()
    }
    let _: JsonValue @local? = view["x"]
    try {
        let _: JsonValue @local? = view["missing"]
        failed += fail("${label}_index_missing_accepted")
    } catch (_: JsonException) {
        ()
    }
    let compact: String = object.toString()
    let compactRoundTrip: JsonObject = JsonValue.fromStr(compact).asObject()
    if (compactRoundTrip.size() != 2 || !compactRoundTrip.containsKey("n") ||
        !compactRoundTrip.containsKey("x")) {
        failed += fail("${label}_toString_shape")
    }
    let pretty: String = object.toJsonString()
    let prettyRoundTrip: JsonObject = JsonValue.fromStr(pretty).asObject()
    if (prettyRoundTrip.size() != 2 || !prettyRoundTrip.containsKey("n") ||
        !prettyRoundTrip.containsKey("x")) {
        failed += fail("${label}_toJsonString_shape")
    }
    failed
}

main(): Int64 {
    var failed: Int64 = 0

    // T520: preserve initial map members without relying on iteration order.
    let initialFields: HashMap<String, JsonValue> @local! = HashMap<String, JsonValue>(2)
    let initial: JsonObject @local! = JsonObject(initialFields) @local!
    if (initial.size() != 0 || initial.getFields().size != 0) {
        failed += fail("T520_map_ctor_empty_size")
    }

    // T520: check heap construction and parsed local objects.
    let heapObject = JsonObject()
    if (heapObject.size() != 0) { failed += fail("T520_heap_noarg_size") }
    let source: String @local! = "{\"n\":null,\"x\":1}"
    let value: JsonValue @local! = JsonValue.fromStr(source)
    let object: JsonObject @local! = value.asObject()
    failed += checkLocalObject(object, "T520_parser_object")
    failed += checkLocalObjectHalf(object, "T520_parser_object_half")

    // T523: distinguish a missing key from an explicit JsonNull.
    let heapSource: String = "{\"n\":null,\"x\":1}"
    let heapValue: JsonValue = JsonValue.fromStr(heapSource)
    let heapObjectSource: JsonObject = heapValue.asObject()
    failed += checkHeapObjectHalf(heapObjectSource, "T531_heap_object_half")
    match (object.get("n")) {
        case Some(nullValue) =>
            if (nullValue.toString() != "null") { failed += fail("T523_explicit_null") }
        case None => failed += fail("T523_explicit_null_missing")
    }
    match (object.get("missing")) {
        case Some(_) => failed += fail("T523_missing_some")
        case None => ()
    }
    if (object["x"].asInt().getValue() != 1) { failed += fail("T523_index_value") }

    // T522: read inserted values through local and shared receivers.
    let mutated: JsonObject @local! = JsonObject() @local!
    let key: String @local! = "local"
    mutated.put(key, JsonInt(1) @local!)
    let halfKey: String @local? = "half"
    mutated.put(halfKey, JsonInt(2) @local!)
    if (mutated.size() != 2) { failed += fail("T522_object_put_local_key_size") }
    let localKey: String @local! = "local"
    let halfKeyCheck: String @local! = "half"
    if (!mutated.containsKey(localKey)) { failed += fail("T522_object_put_local_key_missing") }
    if (!mutated.containsKey(halfKeyCheck)) { failed += fail("T522_object_put_half_key_missing") }
    if (mutated[localKey].asInt().getValue() != 1) { failed += fail("T522_object_put_local_value") }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
