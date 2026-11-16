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

// T508 / S508 / P508: raw and escaped Unicode scalar byte boundaries.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

exclave func checkPayload(source: String @local!, expected: Array<Byte>): Unit {
    let value: JsonValue @local! = JsonValue.fromStr(source)
    let payload: String @local! = value.asString().getValue()
    let bytes: Array<Byte> @local! = payload.toArray()
    check(bytes.size == expected.size, "Unicode payload byte count")
    for (index in 0..expected.size) { check(bytes[index] == expected[index], "Unicode payload byte") }
    let encoded: String @local! = value.toString()
    let reparsed: JsonValue @local! = JsonValue.fromStr(encoded)
    let again: String @local! = reparsed.asString().getValue()
    let againBytes: Array<Byte> @local! = again.toArray()
    check(againBytes.size == expected.size, "Unicode roundtrip byte count")
    for (index in 0..expected.size) { check(againBytes[index] == expected[index], "Unicode roundtrip byte") }
}

main(): Int64 {
    checkPayload("\"\u{7f}\"", [0x7f])
    checkPayload("\"\\u007f\"", [0x7f])
    checkPayload("\"\u{80}\"", [0xc2, 0x80])
    checkPayload("\"\\u0080\"", [0xc2, 0x80])
    checkPayload("\"\u{7ff}\"", [0xdf, 0xbf])
    checkPayload("\"\\u07ff\"", [0xdf, 0xbf])
    checkPayload("\"\u{800}\"", [0xe0, 0xa0, 0x80])
    checkPayload("\"\\u0800\"", [0xe0, 0xa0, 0x80])
    checkPayload("\"\u{d7ff}\"", [0xed, 0x9f, 0xbf])
    checkPayload("\"\\ud7ff\"", [0xed, 0x9f, 0xbf])
    checkPayload("\"\u{e000}\"", [0xee, 0x80, 0x80])
    checkPayload("\"\\ue000\"", [0xee, 0x80, 0x80])
    checkPayload("\"\u{ffff}\"", [0xef, 0xbf, 0xbf])
    checkPayload("\"\\uffff\"", [0xef, 0xbf, 0xbf])
    checkPayload("\"\u{10000}\"", [0xf0, 0x90, 0x80, 0x80])
    checkPayload("\"\\ud800\\udc00\"", [0xf0, 0x90, 0x80, 0x80])
    checkPayload("\"\u{10ffff}\"", [0xf4, 0x8f, 0xbf, 0xbf])
    checkPayload("\"\\udbff\\udfff\"", [0xf4, 0x8f, 0xbf, 0xbf])
    println("ALL PASSED")
    0
}
