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

// T506 / S506 / P506: error coordinates count source characters after escapes.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

exclave func expectPosition(source: String @local!, line: Int64, column: Int64, character: String): Unit {
    var caught = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (error: JsonException) {
        caught = true
        check(error.message.contains("[Line]: ${line}, [Pos]: ${column},"), "escape error coordinates")
        check(error.message.contains("Unexpected character: '${character}'."), "escape error character")
    }
    check(caught, "invalid escape must throw JsonException")
}

main(): Int64 {
    expectPosition("\"\\n\\q\"", 1, 5, "q")
    expectPosition("\"中\\q\"", 1, 4, "q")
    expectPosition("{\n  \"k\": \"\\n\\q\"}", 2, 10, "q")
    expectPosition("{\r\n  \"中\": \"\\n\\q\"}", 2, 10, "q")
    expectPosition("[\"\\u0041\", @]", 1, 12, "@")
    expectPosition("\"\\u12x4\"", 1, 6, "x")
    println("ALL PASSED")
    0
}
