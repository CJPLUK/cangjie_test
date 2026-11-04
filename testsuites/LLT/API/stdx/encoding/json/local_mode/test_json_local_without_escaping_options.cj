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

// T404 / S404 / P404: exact parameterized output and owned/shared contracts.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func pad(indent: String, depth: Int64): String {
    var result = ""
    for (_ in 0..depth) { result = result + indent }
    result
}

func expectedArray(depth: Int64, indent: String, bracketInNewLine: Bool): String {
    let prefix = if (bracketInNewLine) { pad(indent, depth) } else { "" }
    prefix + "[\n" + pad(indent, depth + 1) + "\"&\\\"\\n\"\n" + pad(indent, depth) + "]"
}

func expectedObject(depth: Int64, indent: String, bracketInNewLine: Bool): String {
    let prefix = if (bracketInNewLine) { pad(indent, depth) } else { "" }
    prefix + "{\n" + pad(indent, depth + 1) + "\"&\\\"\": \"v&\\\"\\n\"\n" + pad(indent, depth) + "}"
}

exclave func expectBadArguments(array: JsonArray @local!, object: JsonObject @local!,
    depth: Int64, indent: String): Unit {
    var rejected = false
    try { let _: String @local! = array.toJsonStringWithoutEscaping(depth, indent: indent) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "owned array rejects invalid arguments")
    rejected = false
    try { let _: String @local! = object.toJsonStringWithoutEscaping(depth, indent: indent) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "owned object rejects invalid arguments")

    let arrayView: JsonArray @local? = array
    let objectView: JsonObject @local? = object
    rejected = false
    try { let _: String = arrayView.toJsonStringWithoutEscaping(depth, indent: indent) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "shared array rejects invalid arguments")
    rejected = false
    try { let _: String = objectView.toJsonStringWithoutEscaping(depth, indent: indent) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "shared object rejects invalid arguments")
}

main(): Int64 {
    let arraySource: String @local! = "[\"&\\\"\\n\"]"
    let arrayValue: JsonValue @local! = JsonValue.fromStr(arraySource)
    let array: JsonArray @local! = arrayValue.asArray()
    let objectSource: String @local! = "{\"&\\\"\":\"v&\\\"\\n\"}"
    let objectValue: JsonValue @local! = JsonValue.fromStr(objectSource)
    let object: JsonObject @local! = objectValue.asObject()
    let arrayView: JsonArray @local? = array
    let objectView: JsonObject @local? = object
    for (depth in [0, 2]) {
        for (indent in ["", " ", "\t", " \t"]) {
            for (bracketInNewLine in [false, true]) {
                let arrayWant = expectedArray(depth, indent, bracketInNewLine)
                let objectWant = expectedObject(depth, indent, bracketInNewLine)
                let arrayText: String @local! = array.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                let objectText: String @local! = object.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                check(arrayText == arrayWant, "owned array exact output")
                check(objectText == objectWant, "owned object exact output")
                let sharedArray: String = arrayView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                let sharedObject: String = objectView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: indent)
                check(sharedArray == arrayWant, "shared array heap indent")
                check(sharedObject == objectWant, "shared object heap indent")
                let localIndent: String @local! = String(indent) @local!
                let borrowedIndent: String @local? = localIndent
                let localIndentArray: String = arrayView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: localIndent)
                let localIndentObject: String = objectView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: localIndent)
                check(localIndentArray == arrayWant, "shared array owned indent")
                check(localIndentObject == objectWant, "shared object owned indent")
                let borrowedIndentArray: String = arrayView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: borrowedIndent)
                let borrowedIndentObject: String = objectView.toJsonStringWithoutEscaping(depth,
                    bracketInNewLine: bracketInNewLine, indent: borrowedIndent)
                check(borrowedIndentArray == arrayWant, "shared array shared indent")
                check(borrowedIndentObject == objectWant, "shared object shared indent")
            }
        }
    }
    let arrayDefault: String @local! = array.toJsonStringWithoutEscaping(0)
    let objectDefault: String @local! = object.toJsonStringWithoutEscaping(0)
    check(arrayDefault == expectedArray(0, "  ", false), "owned array default options")
    check(objectDefault == expectedObject(0, "  ", false), "owned object default options")
    let arraySharedDefault: String = arrayView.toJsonStringWithoutEscaping(0)
    let objectSharedDefault: String = objectView.toJsonStringWithoutEscaping(0)
    check(arraySharedDefault == expectedArray(0, "  ", false), "shared array default options")
    check(objectSharedDefault == expectedObject(0, "  ", false), "shared object default options")
    expectBadArguments(array, object, -1, " ")
    expectBadArguments(array, object, Int64.Min, " ")
    for (indent in ["x", "\n", "\r", "\u{0000}", " \n", "中"]) {
        expectBadArguments(array, object, 0, indent)
    }
    check(array.toJsonStringWithoutEscaping(0) == arrayDefault, "array recovery after invalid arguments")
    check(object.toJsonStringWithoutEscaping(0) == objectDefault, "object recovery after invalid arguments")
    println("ALL PASSED")
    0
}
