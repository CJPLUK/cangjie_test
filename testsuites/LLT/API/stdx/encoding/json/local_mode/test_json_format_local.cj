/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// UPDATE 2026-09-21: 本地重建 stdx (feat-stdx-json-local-mode-session) 提供 JSON local surface；0917 SDK 实证通过，恢复 EXEC。
// Evidence: cjc+run ALL PASSED (T526/T527/T528)。
// EXEC: %compiler %local %import-cangjie-stdx %cmp_opt %f -o %output
// EXEC: %set_stdx_path %run %run_opt %output %run_args
//
// LM-DOC-20260910: T526/T528.  Formatted output is compared byte-for-byte
// against an independent indentation oracle.  Invalid format arguments catch
// only IllegalArgumentException; no exception message is an oracle (F15/F16).

import stdx.encoding.json.*

func fail(label: String): Int64 {
    println("FAIL: ${label}")
    1
}

func pad(indent: String, depth: Int64): String {
    var out = ""
    for (_ in 0..depth) { out = out + indent }
    out
}

func expectedArray(depth: Int64, indent: String, bracketInNewLine: Bool): String {
    let prefix = if (bracketInNewLine) { pad(indent, depth) } else { "" }
    "${prefix}[\n${pad(indent, depth + 1)}1,\n${pad(indent, depth + 1)}2\n${pad(indent, depth)}]"
}

exclave func expectBadDepthArray(array: JsonArray @local!, depth: Int64, label: String): Int64 {
    try {
        let _: String @local! = array.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

func expectBadDepthHeap(array: JsonArray, depth: Int64, label: String): Int64 {
    try {
        let _ = array.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadIndentArray(array: JsonArray @local!, indent: String, label: String): Int64 {
    try {
        let _: String @local! = array.toJsonString(0, indent: indent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

func expectBadIndentHeap(array: JsonArray, indent: String, label: String): Int64 {
    try {
        let _ = array.toJsonString(0, indent: indent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadDepthObject(object: JsonObject @local!, depth: Int64, label: String): Int64 {
    try {
        let _: String @local! = object.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadIndentObject(object: JsonObject @local!, indent: String, label: String): Int64 {
    try {
        let _: String @local! = object.toJsonString(0, indent: indent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}
exclave func expectBadDepthArrayHalf(array: JsonArray @local!, depth: Int64, label: String): Int64 {
    let view: JsonArray @local? = array
    try {
        let _: String = view.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadIndentArrayHalf(array: JsonArray @local!, label: String): Int64 {
    let view: JsonArray @local? = array
    let badIndent: String @local? = "x"
    try {
        let _: String = view.toJsonString(0, indent: badIndent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadDepthObjectHalf(object: JsonObject @local!, depth: Int64, label: String): Int64 {
    let view: JsonObject @local? = object
    try {
        let _: String = view.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

exclave func expectBadIndentObjectHalf(object: JsonObject @local!, label: String): Int64 {
    let view: JsonObject @local? = object
    let badIndent: String @local? = "x"
    try {
        let _: String = view.toJsonString(0, indent: badIndent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

func expectBadDepthHeapObject(object: JsonObject, depth: Int64, label: String): Int64 {
    try {
        let _ = object.toJsonString(depth, indent: " ")
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}

func expectBadIndentHeapObject(object: JsonObject, indent: String, label: String): Int64 {
    try {
        let _ = object.toJsonString(0, indent: indent)
        fail("${label}_accepted")
    } catch (_: IllegalArgumentException) {
        0
    }
}


main(): Int64 {
    var failed: Int64 = 0

    let pairSource: String @local! = "[1,2]"
    let pairValue: JsonValue @local! = JsonValue.fromStr(pairSource)
    let pair: JsonArray @local! = pairValue.asArray()

    // T526: exact layouts for empty, flat, nested arrays and a single-key
    // object (single key avoids any HashMap order assumption).
    let emptyArray_value: JsonValue @local! = JsonValue.fromStr("[]")
    let emptyArray: JsonArray @local! = emptyArray_value.asArray()
    let emptyObject_value: JsonValue @local! = JsonValue.fromStr("{}")
    let emptyObject: JsonObject @local! = emptyObject_value.asObject()
    if (emptyArray.toJsonString() != "[]") { failed += fail("T526_empty_array") }
    if (emptyObject.toJsonString() != "{}") { failed += fail("T526_empty_object") }
    if (pair.toJsonString() != "[\n  1,\n  2\n]") { failed += fail("T526_pair_default") }
    let oneKey_value: JsonValue @local! = JsonValue.fromStr("{\"a\":[1,2]}")
    let oneKey: JsonObject @local! = oneKey_value.asObject()
    if (oneKey.toJsonString() != "{\n  \"a\": [\n    1,\n    2\n  ]\n}") {
        failed += fail("T526_one_key_nested")
    }
    let nested_value: JsonValue @local! = JsonValue.fromStr("[[1],3]")
    let nested: JsonArray @local! = nested_value.asArray()
    if (nested.toJsonString() != "[\n  [\n    1\n  ],\n  3\n]") {
        failed += fail("T526_nested_array")
    }

    // T526/T527: independent derived oracle for depth, bracket prefix and
    // valid indent bytes.  The half-mode receiver has the heap-returning
    // formatter declared by JsonArray and must produce the same bytes.
    for (depth in [0, 1, 2]) {
        for (indent in ["", " ", "\t"]) {
            for (bracketInNewLine in [false, true]) {
                let want = expectedArray(depth, indent, bracketInNewLine)
                let got: String @local! = pair.toJsonString(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                if (got != want) { failed += fail("T526_matrix_local") }
                let view: JsonArray @local? = pair
                let gotView: String = view.toJsonString(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                if (gotView != want) { failed += fail("T526_matrix_half") }
                let heap: JsonArray = JsonValue.fromStr("[1,2]").asArray()
                if (heap.toJsonString(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent) != want) {
                    failed += fail("T526_matrix_heap")
                }
            }
        }
    }
    let defaultExplicit: String @local! = pair.toJsonString(0,
        bracketInNewLine: false, indent: "  ")
    if (defaultExplicit != pair.toJsonString()) { failed += fail("T526_default_equivalence") }
    // T536: omitted depth/option defaults and explicit false/two-space
    // arguments are byte-identical for local! and concrete local? receivers.
    let arrayDefault: String @local! = pair.toJsonString(2)
    let arrayExplicit: String @local! = pair.toJsonString(2,
        bracketInNewLine: false, indent: "  ")
    if (arrayDefault != arrayExplicit) { failed += fail("T536_array_defaults") }
    let pairView: JsonArray @local? = pair
    let arrayHalfDefault: String = pairView.toJsonString(2)
    let arrayHalfExplicit: String = pairView.toJsonString(2,
        bracketInNewLine: false, indent: "  ")
    if (arrayHalfDefault != arrayHalfExplicit) { failed += fail("T536_array_half_defaults") }
    let objectDefault: String @local! = oneKey.toJsonString(2)
    let objectExplicit: String @local! = oneKey.toJsonString(2,
        bracketInNewLine: false, indent: "  ")
    if (objectDefault != objectExplicit) { failed += fail("T536_object_defaults") }
    let objectView: JsonObject @local? = oneKey
    let objectHalfDefault: String = objectView.toJsonString(2)
    let objectHalfExplicit: String = objectView.toJsonString(2,
        bracketInNewLine: false, indent: "  ")
    if (objectHalfDefault != objectHalfExplicit) { failed += fail("T536_object_half_defaults") }
    // T536 static provenance constraints: an L receiver cannot take an L indent
    // (its indent parameter is `String @~local`); that negative is covered
    // actively by test_json_format_local_neg_indent.cj.  A Q receiver can take
    // H/L/Q indent values and is exercised above.

    // T528: each invalid parameter is isolated and catches the precise public
    // exception type.  These are separate calls so no double-error precedence
    // is inferred from the test.
    failed += expectBadDepthArray(pair, -1, "T528_array_negative_depth")
    failed += expectBadDepthArray(pair, -2, "T528_array_more_negative_depth")
    failed += expectBadIndentArray(pair, "x", "T528_array_bad_indent_char")
    failed += expectBadIndentArray(pair, " \n", "T528_array_bad_indent_newline")
    failed += expectBadDepthObject(oneKey, -1, "T528_object_negative_depth")
    failed += expectBadIndentObject(oneKey, "x", "T528_object_bad_indent_char")
    let heapPair: JsonArray = JsonValue.fromStr("[1,2]").asArray()
    failed += expectBadDepthHeap(heapPair, -1, "T528_heap_negative_depth")
    failed += expectBadIndentHeap(heapPair, "x", "T528_heap_bad_indent_char")
    failed += expectBadDepthArrayHalf(pair, -1, "T528_array_half_negative_depth")
    failed += expectBadIndentArrayHalf(pair, "T528_array_half_bad_indent")
    failed += expectBadDepthObjectHalf(oneKey, -1, "T528_object_half_negative_depth")
    failed += expectBadIndentObjectHalf(oneKey, "T528_object_half_bad_indent")
    let heapObject: JsonObject = JsonValue.fromStr("{\"a\":[1,2]}").asObject()
    failed += expectBadDepthHeapObject(heapObject, -1, "T528_heap_object_negative_depth")
    failed += expectBadIndentHeapObject(heapObject, "x", "T528_heap_object_bad_indent")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
