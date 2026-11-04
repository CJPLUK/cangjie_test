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

func expectError(source: String @local?): Unit {
    var caught = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (_: JsonException) { caught = true }
    check(caught, "malformed JSON must fail")
}

func checkOverflowFallbacks(): Unit {
    expectError("18446744073709551616")
    expectError("184467440737095516150")
    expectError("-18446744073709551616")
    expectError("-184467440737095516150")
    expectError("[1,18446744073709551616,2]")
    expectError("{\"a\":[1,-184467440737095516150]}")
}

func checkMixedNumberOffsets(): Unit {
    let source: String @local! = "[17,1.25,-3e2,0x2a,0o10,0b11,-9223372036854775808,19]"
    let value: JsonValue @local! = JsonValue.fromStr(source)
    let array: JsonArray @local! = value.asArray()
    check(array.size() == 8, "mixed numeric array size")
    check(array[0].asInt().getValue() == 17, "first integer")
    check(array[1].asFloat().getValue() == 1.25, "fraction fallback at nonzero offset")
    check(array[2].asFloat().getValue() == -300.0, "exponent fallback at nonzero offset")
    check(array[3].asInt().getValue() == 42, "hex fallback")
    check(array[4].asInt().getValue() == 8, "octal fallback")
    check(array[5].asInt().getValue() == 3, "binary fallback")
    check(array[6].asInt().getValue() == Int64.Min, "negative integer boundary")
    check(array[7].asInt().getValue() == 19, "parser resumes after fallback")
}

func checkNestedErrorsAndDuplicates(): Unit {
    expectError("{\"a\":[1,{\"b\":\"\\ud800\\u0041\"}]}")
    expectError("{\"a\":[1,{\"b\":0x}]}")
    let source: String @local! = "{\"a\":1,\"a\":2}"
    let object: JsonObject @local! = JsonValue.fromStr(source).asObject()
    check(object.size() == 1 && object["a"].asInt().getValue() == 2, "duplicate keys retain the last value")
    let strings: String @local! = "[\"\\ud800\\udc00\",\"\\udbff\\udfff\"]"
    let array: JsonArray @local! = JsonValue.fromStr(strings).asArray()
    check(array[0].asString().getValue() == "\u{10000}", "minimum surrogate pair")
    check(array[1].asString().getValue() == "\u{10ffff}", "maximum surrogate pair")
    let valid: String @local! = "[1,true,null]"
    let recovered: JsonArray @local! = JsonValue.fromStr(valid).asArray()
    check(recovered.size() == 3 && recovered[0].asInt().getValue() == 1, "independent parsing succeeds after errors")
}

main(): Int64 {
    checkOverflowFallbacks()
    checkMixedNumberOffsets()
    checkNestedErrorsAndDuplicates()
    println("ALL PASSED")
    0
}
