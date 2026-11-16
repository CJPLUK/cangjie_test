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
// T505, T508-T517, T535: check local parsing, malformed input, escapes, and depth limits.

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

exclave func parseLocal(src: String @local!, wantedKind: Int64, wantedText: String, label: String): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(src)
    var failed: Int64 = 0
    if (kindCode(value.kind()) != wantedKind) { failed += fail("${label}_kind") }
    let text: String @local! = value.toString()
    if (text != wantedText) { failed += fail("${label}_text") }
    failed
}

// This helper returns a Copyable value and does not require exclave.
func parseLocalQuestion(src: String @local?, wantedKind: Int64, wantedText: String, label: String): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(src)
    var failed: Int64 = 0
    if (kindCode(value.kind()) != wantedKind) { failed += fail("${label}_kind") }
    let text: String @local! = value.toString()
    if (text != wantedText) { failed += fail("${label}_text") }
    failed
}

func parseHeap(src: String, wantedKind: Int64, wantedText: String, label: String): Int64 {
    let value = JsonValue.fromStr(src)
    var failed: Int64 = 0
    if (kindCode(value.kind()) != wantedKind) { failed += fail("${label}_kind") }
    if (value.toString() != wantedText) { failed += fail("${label}_text") }
    failed
}

exclave func expectLocalError(src: String @local!, label: String): Int64 {
    try {
        let _: JsonValue @local! = JsonValue.fromStr(src)
        fail("${label}_accepted")
    } catch (_: JsonException) {
        0
    }
}

func expectHeapError(src: String, label: String): Int64 {
    try {
        let _ = JsonValue.fromStr(src)
        fail("${label}_accepted")
    } catch (_: JsonException) {
        0
    }
}

exclave func expectLocalInt(src: String @local!, wanted: Int64, label: String): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != 2) { return fail("${label}_kind") }
    if (value.asInt().getValue() != wanted) { return fail("${label}_value") }
    0
}

func expectHeapInt(src: String, wanted: Int64, label: String): Int64 {
    let value = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != 2) { return fail("${label}_kind") }
    if (value.asInt().getValue() != wanted) { return fail("${label}_value") }
    0
}

exclave func expectLocalFloat(src: String @local!, wanted: Float64, label: String): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != 3) { return fail("${label}_kind") }
    if (value.asFloat().getValue() != wanted) { return fail("${label}_value") }
    0
}

func expectHeapFloat(src: String, wanted: Float64, label: String): Int64 {
    let value = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != 3) { return fail("${label}_kind") }
    if (value.asFloat().getValue() != wanted) { return fail("${label}_value") }
    0
}

exclave func expectLocalString(src: String @local!, wantedPayload: String @local!, wantedText: String @local!, label: String): Int64 {
    let value: JsonValue @local! = JsonValue.fromStr(src)
    if (kindCode(value.kind()) != 4) { return fail("${label}_kind") }
    let payload: String @local! = value.asString().getValue()
    if (payload != wantedPayload) { return fail("${label}_payload") }
    let text: String @local! = value.toString()
    if (text != wantedText) { return fail("${label}_text") }
    0
}

func checkDepthBoundary(): Int64 {
    var failed: Int64 = 0
    var depth100: String @local! = ""
    for (_ in 0..100) { depth100 = depth100 + "[" }
    depth100 = depth100 + "0"
    for (_ in 0..100) { depth100 = depth100 + "]" }
    let value: JsonValue @local! = JsonValue.fromStr(depth100)
    var leaf: JsonValue @local! = value
    for (_ in 0..100) {
        let array: JsonArray @local! = leaf.asArray()
        leaf = array[0]
    }
    if (kindCode(leaf.kind()) != 2 || leaf.asInt().getValue() != 0) {
        failed += fail("T517_depth_100_leaf")
    }

    var depth101: String @local! = ""
    for (_ in 0..101) { depth101 = depth101 + "[" }
    depth101 = depth101 + "0"
    for (_ in 0..101) { depth101 = depth101 + "]" }
    failed += expectLocalError(depth101, "T517_depth_101")
    var objectDepth100: String @local! = ""
    for (_ in 0..100) { objectDepth100 = objectDepth100 + "{\"a\":" }
    objectDepth100 = objectDepth100 + "0"
    for (_ in 0..100) { objectDepth100 = objectDepth100 + "}" }
    let objectValue100: JsonValue @local! = JsonValue.fromStr(objectDepth100)
    var objectLeaf: JsonValue @local! = objectValue100
    for (_ in 0..100) {
        match (objectLeaf.asObject().get("a")) {
            case Some(next) => objectLeaf = next
            case None => failed += fail("T517_object_depth_100_missing")
        }
    }
    if (kindCode(objectLeaf.kind()) != 2 || objectLeaf.asInt().getValue() != 0) {
        failed += fail("T517_object_depth_100_leaf")
    }
    var objectDepth101: String @local! = ""
    for (_ in 0..101) { objectDepth101 = objectDepth101 + "{\"a\":" }
    objectDepth101 = objectDepth101 + "0"
    for (_ in 0..101) { objectDepth101 = objectDepth101 + "}" }
    failed += expectLocalError(objectDepth101, "T517_object_depth_101")
    failed
}

main(): Int64 {
    var failed: Int64 = 0

    // T508: check root kinds and equality with heap parsing.
    let nullSrc: String @local! = "null"
    let trueSrc: String @local! = "true"
    let falseSrc: String @local! = "false"
    let intSrc: String @local! = "1"
    let floatSrc: String @local! = "1.5"
    let stringSrc: String @local! = "\"s\""
    let arraySrc: String @local! = "[]"
    let objectSrc: String @local! = "{}"
    let qNull: String @local? = nullSrc
    let qTrue: String @local? = trueSrc
    let qFalse: String @local? = falseSrc
    let qInt: String @local? = intSrc
    let qFloat: String @local? = floatSrc
    let qString: String @local? = stringSrc
    let qArray: String @local? = arraySrc
    let qObject: String @local? = objectSrc
    failed += parseLocalQuestion(qNull, 0, "null", "T508_local_question_null")
    failed += parseLocalQuestion(qTrue, 1, "true", "T508_local_question_true")
    failed += parseLocalQuestion(qFalse, 1, "false", "T508_local_question_false")
    failed += parseLocalQuestion(qInt, 2, "1", "T508_local_question_int")
    failed += parseLocalQuestion(qFloat, 3, "1.500000", "T508_local_question_float")
    failed += parseLocalQuestion(qString, 4, "\"s\"", "T508_local_question_string")
    failed += parseLocalQuestion(qArray, 5, "[]", "T508_local_question_array")
    failed += parseLocalQuestion(qObject, 6, "{}", "T508_local_question_object")
    failed += parseLocal(nullSrc, 0, "null", "T508_null")
    failed += parseLocal(trueSrc, 1, "true", "T508_true")
    failed += parseLocal(falseSrc, 1, "false", "T508_false")
    failed += parseLocal(intSrc, 2, "1", "T508_int")
    failed += parseLocal(floatSrc, 3, "1.500000", "T508_float")
    failed += parseLocal(stringSrc, 4, "\"s\"", "T508_string")
    failed += parseLocal(arraySrc, 5, "[]", "T508_array")
    failed += parseLocal(objectSrc, 6, "{}", "T508_object")
    failed += parseHeap("null", 0, "null", "T508_heap_null")
    failed += parseHeap("[1,true]", 5, "[1,true]", "T508_heap_array")

    let spacedArray: String @local! = "[\r\n\t 1 , 2 ]"
    failed += parseLocal(spacedArray, 5, "[1,2]", "T508_whitespace_array")
    failed += parseHeap("[\r\n\t 1 , 2 ]", 5, "[1,2]", "T508_whitespace_heap_array")
    let trailing: String @local! = "1\t "
    failed += parseLocal(trailing, 2, "1", "T508_trailing_whitespace")
    failed += parseHeap("1\t ", 2, "1", "T508_trailing_heap")

    // T510: reject malformed keywords and trailing text.
    let nul: String @local! = "nul"
    let nulL: String @local! = "nulL"
    let n: String @local! = "n"
    let tru: String @local! = "tru"
    let tRue: String @local! = "tRue"
    let upperTrue: String @local! = "TRUE"
    let fals: String @local! = "fals"
    let falseCase: String @local! = "False"
    let upperFalse: String @local! = "FALSE"
    let at: String @local! = "@"
    let plus: String @local! = "+1"
    failed += expectLocalError(nul, "T510_nul")
    failed += expectLocalError(nulL, "T510_nulL")
    failed += expectLocalError(n, "T510_n")
    failed += expectLocalError(tru, "T510_tru")
    failed += expectLocalError(tRue, "T510_tRue")
    failed += expectLocalError(upperTrue, "T510_TRUE")
    failed += expectLocalError(fals, "T510_fals")
    failed += expectLocalError(falseCase, "T510_False")
    failed += expectLocalError(upperFalse, "T510_FALSE")
    failed += expectLocalError(at, "T510_at")
    failed += expectLocalError(plus, "T510_plus")
    failed += expectHeapError("nul", "T510_heap_nul")
    failed += expectHeapError("TRUE", "T510_heap_TRUE")
    failed += expectHeapError("FALSE", "T510_heap_FALSE")

    // T511: check array separators and closing brackets.
    let emptyArray: String @local! = "[]"
    let oneArray: String @local! = "[1]"
    let manyArray: String @local! = "[1,2,\"x\"]"
    let nestedArray: String @local! = "[[1],[]]"
    failed += parseLocal(emptyArray, 5, "[]", "T511_empty_array")
    failed += parseLocal(oneArray, 5, "[1]", "T511_one_array")
    failed += parseLocal(manyArray, 5, "[1,2,\"x\"]", "T511_many_array")
    failed += parseLocal(nestedArray, 5, "[[1],[]]", "T511_nested_array")
    failed += expectLocalError("[1 2]", "T511_missing_comma")
    failed += expectLocalError("[1,]", "T511_trailing_comma")
    failed += expectLocalError("[,1]", "T511_leading_comma")
    failed += expectLocalError("[1,", "T511_eof_after_comma")
    failed += expectLocalError("[", "T511_eof_after_open")
    failed += expectHeapError("[1 2]", "T511_heap_missing_comma")
    failed += expectHeapError("[1,]", "T511_heap_trailing_comma")

    // T512: check object members without relying on map order.
    let emptyObject: String @local! = "{}"
    let oneObject: String @local! = "{\"\":1}"
    let nestedObject: String @local! = "{\"中\":[null,{\"k\":\"v\"}]}"
    failed += parseLocal(emptyObject, 6, "{}", "T512_empty_object")
    failed += parseLocal(oneObject, 6, "{\"\":1}", "T512_empty_key_object")
    let nestedValue: JsonValue @local! = JsonValue.fromStr(nestedObject)
    let nested: JsonObject @local! = nestedValue.asObject()
    if (nested.size() != 1 || !nested.containsKey("中")) { failed += fail("T512_nested_object_shape") }
    match (nested.get("中")) {
        case Some(value) =>
            let items: JsonArray @local! = value.asArray()
            if (items.size() != 2) { failed += fail("T512_nested_object_array") }
            match (items[0].kind()) {
                case JsonKind.JsNull => ()
                case _ => failed += fail("T512_nested_object_null")
            }
            if (items[1].asObject()["k"].asString().getValue() != "v") {
                failed += fail("T512_nested_object_string")
            }
        case None => failed += fail("T512_nested_object_missing")
    }
    failed += expectLocalError("{a:1}", "T512_unquoted_key")
    failed += expectLocalError("{\"a\" 1}", "T512_missing_colon")
    failed += expectLocalError("{\"a\":}", "T512_missing_value")
    failed += expectLocalError("{\"a\":1 \"b\":2}", "T512_missing_object_comma")
    failed += expectLocalError("{", "T512_eof_after_open")
    failed += expectHeapError("{a:1}", "T512_heap_unquoted_key")

    // T514: check supported radix prefixes and reject malformed numbers.
    let bLower: String @local! = "0b101"
    let bUpper: String @local! = "0B101"
    let oLower: String @local! = "0o17"
    let oUpper: String @local! = "0O17"
    let xLower: String @local! = "0x1f"
    let xUpper: String @local! = "0X1F"
    failed += expectLocalInt(bLower, 5, "T514_0b101_local")
    failed += expectLocalInt(bUpper, 5, "T514_0B101_local")
    failed += expectLocalInt(oLower, 15, "T514_0o17_local")
    failed += expectLocalInt(oUpper, 15, "T514_0O17_local")
    failed += expectLocalInt(xLower, 31, "T514_0x1f_local")
    failed += expectLocalInt(xUpper, 31, "T514_0X1F_local")
    // T513: decimal points and exponents produce JsonFloat values.
    failed += expectLocalInt("0", 0, "T513_zero")
    failed += expectLocalInt("-0", 0, "T513_negative_zero")
    failed += expectLocalInt("-42", -42, "T513_negative_int")
    failed += expectLocalInt("-9223372036854775808", Int64.Min, "T513_int_min")
    failed += expectLocalInt("9223372036854775807", Int64.Max, "T513_int_max")
    failed += expectHeapInt("0", 0, "T513_heap_zero")
    failed += expectHeapInt("-0", 0, "T513_heap_negative_zero")
    failed += expectHeapInt("-42", -42, "T513_heap_negative_int")
    failed += expectHeapInt("-9223372036854775808", Int64.Min, "T513_heap_int_min")
    failed += expectHeapInt("9223372036854775807", Int64.Max, "T513_heap_int_max")
    failed += expectLocalFloat("1.5", 1.5, "T513_float_fraction")
    failed += expectLocalFloat("0.5", 0.5, "T513_float_half")
    failed += expectLocalFloat("-2.5e-3", -0.0025, "T513_float_exponent")
    failed += expectLocalFloat("1E3", 1000.0, "T513_float_upper_exponent")
    failed += expectLocalFloat("1e+2", 100.0, "T513_float_signed_exponent")
    failed += expectLocalFloat("1e-999", 0.0, "T513_float_underflow")
    failed += expectHeapFloat("1.5", 1.5, "T513_heap_float_fraction")
    failed += expectHeapFloat("-2.5e-3", -0.0025, "T513_heap_float_exponent")

    failed += expectHeapInt("0b101", 5, "T514_0b101_heap")
    failed += expectHeapInt("0B101", 5, "T514_0B101_heap")
    failed += expectHeapInt("0o17", 15, "T514_0o17_heap")
    failed += expectHeapInt("0O17", 15, "T514_0O17_heap")
    let badOctal: String @local! = "0o"
    let badOctalDigit: String @local! = "0o8"
    let badHexPrefix: String @local! = "0x"
    let infExponent: String @local! = "1e999"
    let nanToken: String @local! = "NaN"
    let infinityToken: String @local! = "Infinity"
    failed += expectLocalError(badOctal, "T514_bad_0o")
    failed += expectLocalError(badOctalDigit, "T514_bad_0o8")
    failed += expectLocalError(badHexPrefix, "T514_bad_0x")
    failed += expectLocalError(infExponent, "T514_bad_inf_exponent")
    failed += expectLocalError(nanToken, "T514_bad_nan")
    failed += expectLocalError(infinityToken, "T514_bad_infinity")

    failed += expectHeapInt("0x1f", 31, "T514_0x1f_heap")
    failed += expectHeapInt("0X1F", 31, "T514_0X1F_heap")
    let badRadix: String @local! = "0b"
    let badRadixDigit: String @local! = "0b2"
    let badHex: String @local! = "0xG"
    let leadingZero: String @local! = "01"
    let minusOnly: String @local! = "-"
    let pointOnly: String @local! = "1."
    let expOnly: String @local! = "1e"
    let expSignOnly: String @local! = "1e+"
    let expJunk: String @local! = "1eX"
    let overMax: String @local! = "9223372036854775808"
    let underMin: String @local! = "-9223372036854775809"
    failed += expectLocalError(badRadix, "T514_bad_0b")
    failed += expectLocalError(badRadixDigit, "T514_bad_0b2")
    failed += expectLocalError(badHex, "T514_bad_0xG")
    failed += expectLocalError(leadingZero, "T514_bad_leading_zero")
    failed += expectLocalError(minusOnly, "T514_bad_minus")
    failed += expectLocalError(pointOnly, "T514_bad_point")
    failed += expectLocalError(expOnly, "T514_bad_exp")
    failed += expectLocalError(expSignOnly, "T514_bad_exp_sign")
    failed += expectLocalError(expJunk, "T514_bad_exp_junk")
    failed += expectLocalError(overMax, "T514_over_max")
    failed += expectLocalError(underMin, "T514_under_min")
    failed += expectHeapError("0b", "T514_heap_bad_0b")
    failed += expectHeapError("0b2", "T514_heap_bad_0b2")
    failed += expectHeapError("0o", "T514_heap_bad_0o")
    failed += expectHeapError("0o8", "T514_heap_bad_0o8")
    failed += expectHeapError("0x", "T514_heap_bad_0x")
    failed += expectHeapError("0xG", "T514_heap_bad_0xG")
    failed += expectHeapError("01", "T514_heap_bad_leading_zero")
    failed += expectHeapError("1e999", "T514_heap_bad_inf_exponent")
    failed += expectHeapError("NaN", "T514_heap_bad_nan")
    failed += expectHeapError("Infinity", "T514_heap_bad_infinity")

    // T515: decode escapes, BMP characters, and surrogate pairs.
    let plainPayload: String @local! = "abc"
    let plainText: String @local! = "\"abc\""
    let plainSrc: String @local! = "\"abc\""
    failed += expectLocalString(plainSrc, plainPayload, plainText, "T515_plain")
    let simplePayload: String @local! = "q\"bs/\b\f\n\r\t"
    let simpleText: String @local! = "\"q\\\"bs/\\b\\f\\n\\r\\t\""
    let simpleSrc: String @local! = "\"q\\\"bs\\/\\b\\f\\n\\r\\t\""
    failed += expectLocalString(simpleSrc, simplePayload, simpleText, "T515_simple_escapes")
    let asciiPayload: String @local! = "A"
    let asciiText: String @local! = "\"A\""
    failed += expectLocalString("\"\\u0041\"", asciiPayload, asciiText, "T515_u0041")
    let accentPayload: String @local! = "é"
    let accentText: String @local! = "\"é\""
    failed += expectLocalString("\"\\u00e9\"", accentPayload, accentText, "T515_u00e9")
    let cjkPayload: String @local! = "中"
    let cjkText: String @local! = "\"中\""
    failed += expectLocalString("\"\\u4e2d\"", cjkPayload, cjkText, "T515_u4e2d")
    let emojiPayload: String @local! = "😀"
    let emojiText: String @local! = "\"😀\""
    failed += expectLocalString("\"\\ud83d\\ude00\"", emojiPayload, emojiText, "T515_surrogate_pair")

    // T516: reject malformed escapes, surrogates, and unterminated strings.
    failed += expectLocalError("\"\\x\"", "T516_unknown_escape")
    failed += expectLocalError("\"\\u00\"", "T516_short_unicode")
    failed += expectLocalError("\"\\u00ZZ\"", "T516_nonhex_unicode")
    failed += expectLocalError("\"\\ud800\"", "T516_lone_high_surrogate")
    failed += expectLocalError("\"\\udc00\\udc00\"", "T516_lone_low_surrogate")
    failed += expectLocalError("\"\\ud800\\u0041\"", "T516_wrong_surrogate_pair")
    failed += expectLocalError("\"abc", "T516_unterminated_string")
    failed += expectHeapError("\"\\x\"", "T516_heap_unknown_escape")
    failed += expectHeapError("\"\\ud800\"", "T516_heap_lone_surrogate")

    // T517: accept 100 nested layers and reject 101.
    failed += checkDepthBoundary()

    // T535: reject empty input and trailing root content.
    let emptyRoot: String @local! = ""
    let spacesRoot: String @local! = "   "
    let tabsRoot: String @local! = "\t"
    let crlfRoot: String @local! = "\r\n"
    failed += expectLocalError(emptyRoot, "T535_empty")
    failed += expectLocalError(spacesRoot, "T535_spaces_only")
    failed += expectLocalError(tabsRoot, "T535_tabs_only")
    failed += expectLocalError(crlfRoot, "T535_crlf_only")
    let tailZero: String @local! = "0 \t\r\n"
    let tailTrue: String @local! = "true   "
    let tailArray: String @local! = "[]\r\n\t"
    failed += parseLocal(tailZero, 2, "0", "T535_tail_zero")
    failed += parseLocal(tailTrue, 1, "true", "T535_tail_true")
    failed += parseLocal(tailArray, 5, "[]", "T535_tail_array")
    failed += expectLocalError("1 2", "T535_second_number")
    failed += expectLocalError("true false", "T535_second_boolean")
    failed += expectLocalError("[]x", "T535_second_junk")
    failed += expectHeapError("1 2", "T535_heap_second_number")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
