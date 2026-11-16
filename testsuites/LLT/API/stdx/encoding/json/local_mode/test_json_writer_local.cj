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
// T524, T525, T529, T530: check local JSON formatting, escaping, depth, and buffer boundaries.

import stdx.encoding.json.*

func fail(label: String): Int64 {
    println("FAIL: ${label}")
    1
}

func expectedPadding(indent: String, depth: Int64): String {
    var result = ""
    for (_ in 0..depth) { result = result + indent }
    result
}

exclave func expectWriterError(array: JsonArray @local!, depth: Int64, label: String): Int64 {
    try {
        let _: String @local! = array.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: JsonException) {
        0
    }
}

func checkCompactAndPretty(): Int64 {
    var failed: Int64 = 0
    let mixedSrc: String @local! = "[\"s\",true,-17,2.5,null,[],{}]"
    let mixedValue: JsonValue @local! = JsonValue.fromStr(mixedSrc)
    let mixed: JsonArray @local! = mixedValue.asArray()
    let compact: String @local! = mixed.toString()
    if (compact != "[\"s\",true,-17,2.5,null,[],{}]") {
        failed += fail("T524_compact_seven_kinds")
    }
    let emptyArray_value_value2: JsonValue @local! = JsonValue.fromStr("[]")
    let emptyArray_value: JsonValue @local! = emptyArray_value_value2.asArray()
    let emptyArray: String @local! = emptyArray_value.toString()
    let emptyObject_value: JsonValue @local! = JsonValue.fromStr("{}")
    let emptyObject: String @local! = emptyObject_value.toString()
    if (emptyArray != "[]") { failed += fail("T524_compact_empty_array") }
    if (emptyObject != "{}") { failed += fail("T524_compact_empty_object") }
    let nestedSrc: String @local! = "{\"a\":[1,{\"b\":true}]}"
    let nestedValue: JsonValue @local! = JsonValue.fromStr(nestedSrc)
    if (nestedValue.toString() != nestedSrc) { failed += fail("T524_compact_nested") }

    let pretty: String @local! = mixed.toJsonString()
    if (pretty != "[\n  \"s\",\n  true,\n  -17,\n  2.5,\n  null,\n  [],\n  {}\n]") {
        failed += fail("T524_pretty_mixed")
    }

    // Compare object members after reparsing, without relying on map order.
    let objectSrc: String @local! = "{\"a\":1,\"b\":[2]}"
    let objectValue: JsonValue @local! = JsonValue.fromStr(objectSrc)
    let object: JsonObject @local! = objectValue.asObject()
    let objectText: String @local! = object.toString()
    let roundTrip_value: JsonValue @local! = JsonValue.fromStr(objectText)
    let roundTrip: JsonObject @local! = roundTrip_value.asObject()
    if (roundTrip.size() != 2 || !roundTrip.containsKey("a") || !roundTrip.containsKey("b")) {
        failed += fail("T524_multikey_roundtrip_shape")
    }
    if (roundTrip["a"].asInt().getValue() != 1 || roundTrip["b"].asArray().size() != 1) {
        failed += fail("T524_multikey_roundtrip_values")
    }

    // Check exact pretty formatting for a nested single-key object.
    let oneKey_value: JsonValue @local! = JsonValue.fromStr("{\"a\":[1,2]}")
    let oneKey: JsonObject @local! = oneKey_value.asObject()
    let oneKeyPretty: String @local! = oneKey.toJsonString()
    if (oneKeyPretty != "{\n  \"a\": [\n    1,\n    2\n  ]\n}") {
        failed += fail("T524_pretty_nested_object")
    }
    failed
}

func checkEscaping(): Int64 {
    var failed: Int64 = 0
    let source: String @local! = "[\"a&<>\\\"\\\\\\b\\f\\n\\r\\t\\u0001\\u007f中文😀\"]"
    let value_value: JsonValue @local! = JsonValue.fromStr(source)
    let value: JsonArray @local! = value_value.asArray()
    let escaped: String @local! = value.toString()
    let escapedWant: String @local! = "[\"a\\u0026<>\\\"\\\\\\b\\f\\n\\r\\t\\u0001\\u007f中文😀\"]"
    if (escaped != escapedWant) { failed += fail("T525_compact_escape_bytes") }
    let pretty: String @local! = value.toJsonString()
    let prettyWant: String @local! = "[\n  \"a\\u0026<>\\\"\\\\\\b\\f\\n\\r\\t\\u0001\\u007f中文😀\"\n]"
    if (pretty != prettyWant) { failed += fail("T525_pretty_escape_bytes") }
    let raw: String @local! = value.toStringWithoutEscaping()
    let rawWant: String @local! = "[\"a&<>\\\"\\\\\\b\\f\\n\\r\\t\\u0001\\u007f中文😀\"]"
    if (raw != rawWant) { failed += fail("T525_without_escape_bytes") }
    let rawPretty: String @local! = value.toJsonStringWithoutEscaping()
    let rawPrettyWant: String @local! = "[\n  \"a&<>\\\"\\\\\\b\\f\\n\\r\\t\\u0001\\u007f中文😀\"\n]"
    if (rawPretty != rawPrettyWant) { failed += fail("T525_pretty_without_escape_bytes") }
    failed
}

func checkDepthBoundary(): Int64 {
    var failed: Int64 = 0
    let empty_value: JsonValue @local! = JsonValue.fromStr("[]")
    let empty: JsonArray @local! = empty_value.asArray()
    let emptyAt100: String @local! = empty.toJsonString(100, indent: " ")
    if (emptyAt100 != "[]") { failed += fail("T529_empty_depth_100") }
    let one_value: JsonValue @local! = JsonValue.fromStr("[1]")
    let one: JsonArray @local! = one_value.asArray()
    let oneAt99: String @local! = one.toJsonString(99, indent: " ")
    let oneAt99Want = "[\n" + expectedPadding(" ", 100) + "1\n" + expectedPadding(" ", 99) + "]"
    if (oneAt99 != oneAt99Want) { failed += fail("T529_one_depth_99") }
    failed += expectWriterError(one, 100, "T529_one_depth_100")
    failed += expectWriterError(empty, 101, "T529_empty_depth_101")
    failed
}

func checkBufferBoundaries(): Int64 {
    var failed: Int64 = 0
    let plain31: String @local! = "[\"1234567890123456789012345678901\"]"
    let plain32: String @local! = "[\"12345678901234567890123456789012\"]"
    if (JsonValue.fromStr(plain31).asArray().toString() != plain31) {
        failed += fail("T530_plain_31_bytes")
    }
    if (JsonValue.fromStr(plain32).asArray().toString() != plain32) {
        failed += fail("T530_plain_32_bytes")
    }
    let amp3: String @local! = "[\"&&&\"]"
    let amp4: String @local! = "[\"&&&&\"]"
    if (JsonValue.fromStr(amp3).asArray().toString() != "[\"\\u0026\\u0026\\u0026\"]") {
        failed += fail("T530_amp_3_growth")
    }
    if (JsonValue.fromStr(amp4).asArray().toString() != "[\"\\u0026\\u0026\\u0026\\u0026\"]") {
        failed += fail("T530_amp_4_growth")
    }
    let ints: String @local! = "[\"long\",-9223372036854775808,9223372036854775807]"
    if (JsonValue.fromStr(ints).asArray().toString() != ints) {
        failed += fail("T530_int_min_max")
    }
    let floats: String @local! = "[1.5,100.0,-0.0]"
    if (JsonValue.fromStr(floats).asArray().toString() != "[1.5,100,-0]") {
        failed += fail("T530_float_trim")
    }
    let bools: String @local! = "[true,false]"
    if (JsonValue.fromStr(bools).asArray().toString() != bools) {
        failed += fail("T530_bool_widths")
    }
    failed
}

main(): Int64 {
    // Initialize the local region before helper calls. Avoid interpolating a local String.
    let regionWarmup: String @local! = "warmup"
    if (regionWarmup.size != 6) { return 1 }
    var failed: Int64 = 0
    failed += checkCompactAndPretty()
    failed += checkEscaping()
    failed += checkDepthBoundary()
    failed += checkBufferBoundaries()
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
