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

// T501 / S501 / P501: signed radix endpoints and overflow fallback.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

exclave func expectValue(source: String @local!, expected: Int64): Unit {
    let value: JsonValue @local! = JsonValue.fromStr(source)
    check(value.asInt().getValue() == expected, "radix root value")
    let prefix: String @local! = "[7,"
    let suffix: String @local! = ",9]"
    let nestedText: String @local! = prefix + source + suffix
    let nested: JsonArray @local! = JsonValue.fromStr(nestedText).asArray()
    check(nested.size() == 3 && nested[0].asInt().getValue() == 7, "radix prefix member")
    check(nested[1].asInt().getValue() == expected, "radix nonzero offset")
    check(nested[2].asInt().getValue() == 9, "radix suffix member")
}

exclave func expectError(source: String @local!): Unit {
    var caught = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (_: JsonException) { caught = true }
    check(caught, "out-of-range integer must throw JsonException")
}

main(): Int64 {
    expectValue("0b111111111111111111111111111111111111111111111111111111111111111", Int64.Max)
    expectValue("0B111111111111111111111111111111111111111111111111111111111111111", Int64.Max)
    expectValue("0b111111111111111111111111111111111111111111111111111111111111110", Int64.Max - 1)
    expectValue("0B111111111111111111111111111111111111111111111111111111111111110", Int64.Max - 1)
    expectValue("-0b1000000000000000000000000000000000000000000000000000000000000000", Int64.Min)
    expectValue("-0B1000000000000000000000000000000000000000000000000000000000000000", Int64.Min)
    expectValue("-0b111111111111111111111111111111111111111111111111111111111111111", Int64.Min + 1)
    expectValue("-0B111111111111111111111111111111111111111111111111111111111111111", Int64.Min + 1)
    expectValue("0o777777777777777777777", Int64.Max)
    expectValue("0O777777777777777777777", Int64.Max)
    expectValue("0o777777777777777777776", Int64.Max - 1)
    expectValue("0O777777777777777777776", Int64.Max - 1)
    expectValue("-0o1000000000000000000000", Int64.Min)
    expectValue("-0O1000000000000000000000", Int64.Min)
    expectValue("-0o777777777777777777777", Int64.Min + 1)
    expectValue("-0O777777777777777777777", Int64.Min + 1)
    expectValue("0x7fffffffffffffff", Int64.Max)
    expectValue("0X7fffffffffffffff", Int64.Max)
    expectValue("0x7ffffffffffffffe", Int64.Max - 1)
    expectValue("0X7ffffffffffffffe", Int64.Max - 1)
    expectValue("-0x8000000000000000", Int64.Min)
    expectValue("-0X8000000000000000", Int64.Min)
    expectValue("-0x7fffffffffffffff", Int64.Min + 1)
    expectValue("-0X7fffffffffffffff", Int64.Min + 1)
    expectError("18446744073709551615")
    expectError("[7,18446744073709551615,9]")
    expectError("-18446744073709551615")
    expectError("[7,-18446744073709551615,9]")
    expectError("0b1000000000000000000000000000000000000000000000000000000000000000")
    expectError("[7,0b1000000000000000000000000000000000000000000000000000000000000000,9]")
    expectError("-0b1000000000000000000000000000000000000000000000000000000000000001")
    expectError("[7,-0b1000000000000000000000000000000000000000000000000000000000000001,9]")
    expectError("0b1111111111111111111111111111111111111111111111111111111111111111")
    expectError("[7,0b1111111111111111111111111111111111111111111111111111111111111111,9]")
    expectError("0o1000000000000000000000")
    expectError("[7,0o1000000000000000000000,9]")
    expectError("-0o1000000000000000000001")
    expectError("[7,-0o1000000000000000000001,9]")
    expectError("0o1777777777777777777777")
    expectError("[7,0o1777777777777777777777,9]")
    expectError("0x8000000000000000")
    expectError("[7,0x8000000000000000,9]")
    expectError("-0x8000000000000001")
    expectError("[7,-0x8000000000000001,9]")
    expectError("0xffffffffffffffff")
    expectError("[7,0xffffffffffffffff,9]")
    println("ALL PASSED")
    0
}
