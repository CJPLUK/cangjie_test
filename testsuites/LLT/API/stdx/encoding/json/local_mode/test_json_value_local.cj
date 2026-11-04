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
// T500, T501, T504: check local JsonValue kinds and conversions.

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

exclave func checkLocalDocument(src: String @local!, expectedKind: Int64, expectedText: String, label: String): Int64 {
    var failed: Int64 = 0
    let value: JsonValue @local! = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != expectedKind) { failed += fail("${label}_kind") }
    let text: String @local! = value.toString()
    if (text != expectedText) { failed += fail("${label}_toString") }
    let valueHalf: JsonValue @local? = value
    if (kindCode(valueHalf.kind()) != expectedKind) { failed += fail("${label}_half_kind") }
    let halfText: String @local! = valueHalf.toString()
    if (halfText != expectedText) { failed += fail("${label}_half_toString") }
    failed
}

exclave func checkLocalAsSuccess(src: String @local!, expectedKind: Int64, label: String): Int64 {
    var failed: Int64 = 0
    let value: JsonValue @local! = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != expectedKind) { failed += fail("${label}_source_kind") }
    if (expectedKind == 0) {
        let converted: JsonNull @local! = value.asNull()
        if (kindCode(converted.kind()) != 0) { failed += fail("${label}_asNull_kind") }
    } else if (expectedKind == 1) {
        let converted: JsonBool @local! = value.asBool()
        if (converted.getValue() != true) { failed += fail("${label}_asBool_value") }
    } else if (expectedKind == 2) {
        let converted: JsonInt @local! = value.asInt()
        if (converted.getValue() != -42) { failed += fail("${label}_asInt_value") }
    } else if (expectedKind == 3) {
        let converted: JsonFloat @local! = value.asFloat()
        if (converted.getValue() != 1.5) { failed += fail("${label}_asFloat_value") }
    } else if (expectedKind == 4) {
        let converted: JsonString @local! = value.asString()
        let payload: String @local! = converted.getValue()
        if (payload != "payload") { failed += fail("${label}_asString_value") }
    } else if (expectedKind == 5) {
        let converted: JsonArray @local! = value.asArray()
        if (converted.size() != 1) { failed += fail("${label}_asArray_size") }
    } else {
        let converted: JsonObject @local! = value.asObject()
        if (converted.size() != 1) { failed += fail("${label}_asObject_size") }
    }
    failed
}

exclave func checkIntToFloatValue(source: String @local!, wanted: Int64): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(source)
    var failed: Int64 = 0
    if (kindCode(value.kind()) != 2 || value.asInt().getValue() != wanted) {
        failed += fail("T401_int_to_float_source")
    }
    let converted: JsonFloat @local! = value.asFloat()
    if (kindCode(converted.kind()) != 3) { failed += fail("T401_int_to_float_kind") }
    if (converted.getValue() != Float64(wanted)) { failed += fail("T401_int_to_float_value") }
    if (kindCode(value.kind()) != 2 || value.asInt().getValue() != wanted) {
        failed += fail("T401_int_to_float_source_unchanged")
    }
    failed
}

func checkIntToFloat(): Int64 {
    var failed: Int64 = 0
    failed += checkIntToFloatValue("-42", -42)
    failed += checkIntToFloatValue("0", 0)
    failed += checkIntToFloatValue("-9223372036854775808", Int64.Min)
    failed += checkIntToFloatValue("9223372036854775807", Int64.Max)
    failed
}

exclave func expectWrongKind(value: JsonValue @local!, target: Int64, label: String): Int64 {
    try {
        if (target == 0) { let _: JsonNull @local! = value.asNull() }
        else if (target == 1) { let _: JsonBool @local! = value.asBool() }
        else if (target == 2) { let _: JsonInt @local! = value.asInt() }
        else if (target == 3) { let _: JsonFloat @local! = value.asFloat() }
        else if (target == 4) { let _: JsonString @local! = value.asString() }
        else if (target == 5) { let _: JsonArray @local! = value.asArray() }
        else { let _: JsonObject @local! = value.asObject() }
        fail("${label}_returned")
    } catch (_: JsonException) {
        0
    }
}

func checkWrongKinds(): Int64 {
    var failed: Int64 = 0
    let nullSrc: String @local! = "null"
    let boolSrc: String @local! = "true"
    let intSrc: String @local! = "1"
    let floatSrc: String @local! = "1.5"
    let stringSrc: String @local! = "\"payload\""
    let arraySrc: String @local! = "[1]"
    let objectSrc: String @local! = "{\"k\":1}"
    let nullValue: JsonValue @local! = JsonValue.fromStr(nullSrc)
    let boolValue: JsonValue @local! = JsonValue.fromStr(boolSrc)
    let intValue: JsonValue @local! = JsonValue.fromStr(intSrc)
    let floatValue: JsonValue @local! = JsonValue.fromStr(floatSrc)
    let stringValue: JsonValue @local! = JsonValue.fromStr(stringSrc)
    let arrayValue: JsonValue @local! = JsonValue.fromStr(arraySrc)
    let objectValue: JsonValue @local! = JsonValue.fromStr(objectSrc)

    failed += expectWrongKind(nullValue, 1, "T507_null_asBool")
    failed += expectWrongKind(nullValue, 2, "T507_null_asInt")
    failed += expectWrongKind(nullValue, 3, "T507_null_asFloat")
    failed += expectWrongKind(nullValue, 4, "T507_null_asString")
    failed += expectWrongKind(nullValue, 5, "T507_null_asArray")
    failed += expectWrongKind(nullValue, 6, "T507_null_asObject")
    failed += expectWrongKind(boolValue, 0, "T507_bool_asNull")
    failed += expectWrongKind(boolValue, 2, "T507_bool_asInt")
    failed += expectWrongKind(intValue, 0, "T507_int_asNull")
    failed += expectWrongKind(intValue, 1, "T507_int_asBool")
    failed += expectWrongKind(intValue, 4, "T507_int_asString")
    failed += expectWrongKind(floatValue, 0, "T507_float_asNull")
    failed += expectWrongKind(floatValue, 2, "T507_float_asInt")
    failed += expectWrongKind(stringValue, 0, "T507_string_asNull")
    failed += expectWrongKind(stringValue, 2, "T507_string_asInt")
    failed += expectWrongKind(stringValue, 3, "T507_string_asFloat")
    failed += expectWrongKind(stringValue, 5, "T507_string_asArray")
    failed += expectWrongKind(arrayValue, 0, "T507_array_asNull")
    failed += expectWrongKind(arrayValue, 4, "T507_array_asString")
    failed += expectWrongKind(arrayValue, 6, "T507_array_asObject")
    failed += expectWrongKind(objectValue, 0, "T507_object_asNull")
    failed += expectWrongKind(objectValue, 2, "T507_object_asInt")
    failed += expectWrongKind(objectValue, 5, "T507_object_asArray")
    failed
}

main(): Int64 {
    var failed: Int64 = 0

    // T500, T501: check all seven kinds through JsonValue.
    let nullSrc: String @local! = "null"
    let boolSrc: String @local! = "true"
    let intSrc: String @local! = "1"
    let floatSrc: String @local! = "1.5"
    let stringSrc: String @local! = "\"payload\""
    let arraySrc: String @local! = "[1]"
    let objectSrc: String @local! = "{\"k\":1}"
    failed += checkLocalDocument(nullSrc, 0, "null", "T500_T501_null")
    failed += checkLocalDocument(boolSrc, 1, "true", "T500_T501_bool")
    failed += checkLocalDocument(intSrc, 2, "1", "T500_T501_int")
    failed += checkLocalDocument(floatSrc, 3, "1.500000", "T500_T501_float")
    failed += checkLocalDocument(stringSrc, 4, "\"payload\"", "T500_T501_string")
    failed += checkLocalDocument(arraySrc, 5, "[1]", "T500_T501_array")
    failed += checkLocalDocument(objectSrc, 6, "{\"k\":1}", "T500_T501_object")

    // Check concrete conversions and integer-to-float widening.
    let asIntSrc: String @local! = "-42"
    failed += checkLocalAsSuccess(nullSrc, 0, "T506_null")
    failed += checkLocalAsSuccess(boolSrc, 1, "T506_bool")
    failed += checkLocalAsSuccess(asIntSrc, 2, "T506_int")
    failed += checkLocalAsSuccess(floatSrc, 3, "T506_float")
    failed += checkLocalAsSuccess(stringSrc, 4, "T506_string")
    failed += checkLocalAsSuccess(arraySrc, 5, "T506_array")
    failed += checkLocalAsSuccess(objectSrc, 6, "T506_object")
    failed += checkIntToFloat()
    failed += checkWrongKinds()

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
