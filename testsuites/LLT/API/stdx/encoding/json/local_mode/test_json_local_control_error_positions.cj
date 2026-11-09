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

// T402 / S402 / P402: local controls, escaped bytes, and documented error positions.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

exclave func expectRejected(source: String @local!): Unit {
    var rejected = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (_: JsonException) { rejected = true }
    check(rejected, "raw control must be rejected")
}

func canonicalControl(code: Int64): String {
    if (code == 8) { return "\"\\b\"" }
    if (code == 9) { return "\"\\t\"" }
    if (code == 10) { return "\"\\n\"" }
    if (code == 12) { return "\"\\f\"" }
    if (code == 13) { return "\"\\r\"" }
    let digits: Array<Byte> = [b'0', b'1', b'2', b'3', b'4', b'5', b'6', b'7',
        b'8', b'9', b'a', b'b', b'c', b'd', b'e', b'f']
    String.fromUtf8([b'"', b'\\', b'u', b'0', b'0', digits[code / 16], digits[code % 16], b'"'])
}

func checkControls(): Unit {
    let digits: Array<Byte> = [b'0', b'1', b'2', b'3', b'4', b'5', b'6', b'7',
        b'8', b'9', b'a', b'b', b'c', b'd', b'e', b'f']
    for (code in 0..32) {
        let plainBytes: Array<Byte> @local! = [b'"', UInt8(code), b'"']
        let plain: String @local! = String.fromUtf8(plainBytes)
        expectRejected(plain)
        let afterEscapeBytes: Array<Byte> @local! = [b'"', b'\\', b'n', UInt8(code), b'"']
        let afterEscape: String @local! = String.fromUtf8(afterEscapeBytes)
        expectRejected(afterEscape)

        let escapedBytes: Array<Byte> @local! = [b'"', b'\\', b'u', b'0', b'0',
            digits[code / 16], digits[code % 16], b'"']
        let escaped: String @local! = String.fromUtf8(escapedBytes)
        let value: JsonValue @local! = JsonValue.fromStr(escaped)
        let payload: String @local! = value.asString().getValue()
        let bytes: Array<Byte> @local! = payload.toArray()
        check(bytes.size == 1 && bytes[0] == UInt8(code), "escaped control payload")
        let encoded: String @local! = value.toString()
        check(encoded == canonicalControl(code), "escaped control output bytes")
    }
}

exclave func expectPosition(source: String @local!, line: String, position: String, character: String): Unit {
    var rejected = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (error: JsonException) {
        rejected = true
        check(error.message.contains(line), "error line")
        check(error.message.contains(position), "error character column")
        check(error.message.contains(character), "error character")
    }
    check(rejected, "invalid input must report its position")
}

main(): Int64 {
    checkControls()
    expectPosition("{\n  \"中\": @}", "[Line]: 2,", "[Pos]: 6,", "Unexpected character: '@'.")
    expectPosition("{\r\n  \"中\": @}", "[Line]: 2,", "[Pos]: 6,", "Unexpected character: '@'.")
    expectPosition("[\r\n  \"中\", @]", "[Line]: 2,", "[Pos]: 6,", "Unexpected character: '@'.")
    println("ALL PASSED")
    0
}
