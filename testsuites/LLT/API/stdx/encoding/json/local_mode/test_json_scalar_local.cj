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
// T502, T503, T505: check local scalar values, serialization boundaries, and escaping.

import stdx.encoding.json.*

func fail(label: String): Int64 {
    println("FAIL: ${label}")
    1
}

func kindCode(kind: JsonKind): Int64 {
    match (kind) {
        case JsonKind.JsNull => 0
        case JsonKind.JsBool => 1
        case JsonKind.JsInt => 2
        case JsonKind.JsFloat => 3
        case JsonKind.JsString => 4
        case JsonKind.JsArray => 5
        case JsonKind.JsObject => 6
    }
}

func checkHeapSerializers(label: String, value: JsonValue, want: String): Int64 {
    var failed: Int64 = 0
    if (value.toString() != want) { failed += fail("${label}_toString") }
    if (value.toJsonString() != want) { failed += fail("${label}_toJsonString") }
    if (value.toStringWithoutEscaping() != want) { failed += fail("${label}_toStringWithoutEscaping") }
    if (value.toJsonStringWithoutEscaping() != want) { failed += fail("${label}_toJsonStringWithoutEscaping") }
    failed
}

func checkLocalNull(): Int64 {
    var failed: Int64 = 0
    let value: JsonNull @local! = JsonNull() @local!
    if (kindCode(value.kind()) != 0) { failed += fail("T502_null_kind") }
    if (value.toString() != "null") { failed += fail("T503_null_toString") }
    if (value.toJsonString() != "null") { failed += fail("T503_null_toJsonString") }
    if (value.toStringWithoutEscaping() != "null") { failed += fail("T503_null_unescaped_toString") }
    if (value.toJsonStringWithoutEscaping() != "null") { failed += fail("T503_null_unescaped_toJsonString") }
    failed
}

func checkLocalBool(raw: Bool, want: String, suffix: String): Int64 {
    var failed: Int64 = 0
    let value: JsonBool @local! = JsonBool(raw) @local!
    if (kindCode(value.kind()) != 1) { failed += fail("T502_bool_${suffix}_kind") }
    let payload: Bool @local? = value.getValue()
    if (payload != raw) { failed += fail("T502_bool_${suffix}_getValue") }
    if (value.toString() != want) { failed += fail("T503_bool_${suffix}_toString") }
    if (value.toJsonString() != want) { failed += fail("T503_bool_${suffix}_toJsonString") }
    if (value.toStringWithoutEscaping() != want) { failed += fail("T503_bool_${suffix}_unescaped_toString") }
    if (value.toJsonStringWithoutEscaping() != want) { failed += fail("T503_bool_${suffix}_unescaped_toJsonString") }
    let view: JsonBool @local? = value
    let halfPayload: Bool @local? = view.getValue()
    if (halfPayload != raw) { failed += fail("T502_bool_${suffix}_half_getValue") }
    failed
}

func checkLocalInt(raw: Int64, want: String, suffix: String): Int64 {
    var failed: Int64 = 0
    let value: JsonInt @local! = JsonInt(raw) @local!
    if (kindCode(value.kind()) != 2) { failed += fail("T502_int_${suffix}_kind") }
    let payload: Int64 @local? = value.getValue()
    if (payload != raw) { failed += fail("T502_int_${suffix}_getValue") }
    if (value.toString() != want) { failed += fail("T503_int_${suffix}_toString") }
    if (value.toJsonString() != want) { failed += fail("T503_int_${suffix}_toJsonString") }
    if (value.toStringWithoutEscaping() != want) { failed += fail("T503_int_${suffix}_unescaped_toString") }
    if (value.toJsonStringWithoutEscaping() != want) { failed += fail("T503_int_${suffix}_unescaped_toJsonString") }
    let view: JsonInt @local? = value
    let halfPayload: Int64 @local? = view.getValue()
    if (halfPayload != raw) { failed += fail("T502_int_${suffix}_half_getValue") }
    failed
}

func checkLocalFloat(raw: Float64, want: String, suffix: String): Int64 {
    var failed: Int64 = 0
    let value: JsonFloat @local! = JsonFloat(raw) @local!
    if (kindCode(value.kind()) != 3) { failed += fail("T502_float_${suffix}_kind") }
    let payload: Float64 @local? = value.getValue()
    if (payload != raw) { failed += fail("T502_float_${suffix}_getValue") }
    if (value.toString() != want) { failed += fail("T503_float_${suffix}_toString") }
    if (value.toJsonString() != want) { failed += fail("T503_float_${suffix}_toJsonString") }
    if (value.toStringWithoutEscaping() != want) { failed += fail("T503_float_${suffix}_unescaped_toString") }
    if (value.toJsonStringWithoutEscaping() != want) { failed += fail("T503_float_${suffix}_unescaped_toJsonString") }
    let view: JsonFloat @local? = value
    if (view.toString() != want) { failed += fail("T503_float_${suffix}_half_toString") }
    failed
}

func checkLocalFloatIntCtor(): Int64 {
    let value: JsonFloat @local! = JsonFloat(42) @local!
    var failed: Int64 = 0
    if (value.getValue() != 42.0) { failed += fail("T502_float_int_ctor_getValue") }
    if (value.toString() != "42.000000") { failed += fail("T503_float_int_ctor_toString") }
    if (value.toJsonString() != "42.000000") { failed += fail("T503_float_int_ctor_toJsonString") }
    let view: JsonFloat @local? = value
    let halfPayload: Float64 @local? = view.getValue()
    if (halfPayload != 42.0) { failed += fail("T502_float_int_ctor_half_getValue") }
    failed
}

exclave func checkLocalString(raw: String @local!, escaped: String @local!, plain: String @local!, suffix: String): Int64 {
    var failed: Int64 = 0
    let value: JsonString @local! = JsonString(raw) @local!
    if (kindCode(value.kind()) != 4) { failed += fail("T502_string_${suffix}_kind") }
    let payload: String @local! = value.getValue()
    if (payload != raw) { failed += fail("T502_string_${suffix}_getValue") }
    if (value.toString() != escaped) { failed += fail("T505_string_${suffix}_toString") }
    if (value.toJsonString() != escaped) { failed += fail("T505_string_${suffix}_toJsonString") }
    if (value.toStringWithoutEscaping() != plain) { failed += fail("T505_string_${suffix}_unescaped_toString") }
    if (value.toJsonStringWithoutEscaping() != plain) { failed += fail("T505_string_${suffix}_unescaped_toJsonString") }
    let view: JsonString @local? = value
    let halfPayload: String @local? = view.getValue()
    if (halfPayload != raw) { failed += fail("T502_string_${suffix}_half_getValue") }
    if (view.toString() != escaped) { failed += fail("T505_string_${suffix}_half_toString") }
    failed
}

func floatOutcomeHeap(raw: Float64, method: Int64): Int64 {
    let value = JsonFloat(raw)
    try {
        if (method == 0) { let _: String = value.toString() }
        else if (method == 1) { let _: String = value.toJsonString() }
        else if (method == 2) { let _: String = value.toStringWithoutEscaping() }
        else { let _: String = value.toJsonStringWithoutEscaping() }
        1
    } catch (_: JsonException) {
        0
    } catch (_: IllegalArgumentException) {
        -1
    }
}

func floatOutcomeLocal(raw: Float64, method: Int64): Int64 {
    let value: JsonFloat @local! = JsonFloat(raw) @local!
    try {
        if (method == 0) { let _: String @local! = value.toString() }
        else if (method == 1) { let _: String @local! = value.toJsonString() }
        else if (method == 2) { let _: String @local! = value.toStringWithoutEscaping() }
        else { let _: String @local! = value.toJsonStringWithoutEscaping() }
        1
    } catch (_: JsonException) {
        0
    } catch (_: IllegalArgumentException) {
        -1
    }
}

func checkNonFinite(raw: Float64, suffix: String): Int64 {
    var failed: Int64 = 0
    for (method in 0..4) {
        let heapOutcome = floatOutcomeHeap(raw, method)
        let localOutcome = floatOutcomeLocal(raw, method)
        if (heapOutcome != localOutcome) {
            failed += fail("T504_${suffix}_method_${method}_heap_local_parity")
        }
    }
    failed
}

main(): Int64 {
    var failed: Int64 = 0

    // T502, T503: check constructors, getters, and all serializers.
    failed += checkLocalNull()
    failed += checkLocalBool(false, "false", "false")
    failed += checkLocalBool(true, "true", "true")
    failed += checkLocalInt(0, "0", "zero")
    failed += checkLocalInt(-7, "-7", "negative")
    failed += checkLocalInt(Int64.Max, "9223372036854775807", "max")
    failed += checkLocalInt(Int64.Min, "-9223372036854775808", "int_min")
    failed += checkLocalFloat(1.5, "1.500000", "fraction")
    failed += checkLocalFloat(42.0, "42.000000", "from_int_value")
    failed += checkLocalFloatIntCtor()

    failed += checkHeapSerializers("T502_heap_null", JsonNull(), "null")
    let heapFalse = JsonBool(false)
    if (heapFalse.getValue() != false) { failed += fail("T502_heap_bool_getValue") }
    failed += checkHeapSerializers("T503_heap_bool", heapFalse, "false")
    let heapInt = JsonInt(Int64.Min)
    if (heapInt.getValue() != Int64.Min) { failed += fail("T502_heap_int_min_getValue") }
    failed += checkHeapSerializers("T503_heap_int_min", heapInt, "-9223372036854775808")
    let heapFloat = JsonFloat(1.5)
    if (heapFloat.getValue() != 1.5) { failed += fail("T502_heap_float_getValue") }
    failed += checkHeapSerializers("T503_heap_float", heapFloat, "1.500000")

    // T505: preserve string payloads and HTML-safe escaping.
    let rawEmpty: String @local! = ""
    let escEmpty: String @local! = "\"\""
    failed += checkLocalString(rawEmpty, escEmpty, escEmpty, "empty")
    let rawAscii: String @local! = "abc"
    failed += checkLocalString(rawAscii, "\"abc\"", "\"abc\"", "ascii")
    let rawAmp: String @local! = "a&b<c>d"
    failed += checkLocalString(rawAmp, "\"a\\u0026b<c>d\"", "\"a&b<c>d\"", "html")
    let rawQuote: String @local! = "say \"hi\""
    failed += checkLocalString(rawQuote, "\"say \\\"hi\\\"\"", "\"say \\\"hi\\\"\"", "quote")
    let rawSlash: String @local! = "back\\slash"
    failed += checkLocalString(rawSlash, "\"back\\\\slash\"", "\"back\\\\slash\"", "backslash")
    let rawEscapes: String @local! = "\b\f\n\r\t"
    failed += checkLocalString(rawEscapes, "\"\\b\\f\\n\\r\\t\"", "\"\\b\\f\\n\\r\\t\"", "controls")
    let rawSoh: String @local! = "a\u{0001}b"
    failed += checkLocalString(rawSoh, "\"a\\u0001b\"", "\"a\\u0001b\"", "soh")
    let rawDel: String @local! = "a\u{007f}b"
    failed += checkLocalString(rawDel, "\"a\\u007fb\"", "\"a\\u007fb\"", "del")
    let rawUnicode: String @local! = "中文😀"
    failed += checkLocalString(rawUnicode, "\"中文😀\"", "\"中文😀\"", "unicode")

    failed += checkNonFinite(Float64.NaN, "nan")
    failed += checkNonFinite(Float64.Inf, "positive_inf")
    failed += checkNonFinite(-Float64.Inf, "negative_inf")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
