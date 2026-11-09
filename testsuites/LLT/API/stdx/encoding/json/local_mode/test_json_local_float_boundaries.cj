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

// T502 / S502 / P502: independent IEEE-754 boundary bit patterns.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func checkHeap(source: String, expected: UInt64): Unit {
    let value: JsonValue = JsonValue.fromStr(source)
    check(value.asFloat().getValue().toBits() == expected, "heap float bits")
}

exclave func checkLocal(source: String @local!, expected: UInt64): Unit {
    let value: JsonValue @local! = JsonValue.fromStr(source)
    check(value.asFloat().getValue().toBits() == expected, "local float bits")
    let prefix: String @local! = "[7,"
    let suffix: String @local! = ",9]"
    let nestedText: String @local! = prefix + source + suffix
    let nested: JsonArray @local! = JsonValue.fromStr(nestedText).asArray()
    check(nested.size() == 3 && nested[0].asInt().getValue() == 7, "float prefix member")
    check(nested[1].asFloat().getValue().toBits() == expected, "float bits at nonzero offset")
    check(nested[2].asInt().getValue() == 9, "float suffix member")
}

exclave func expectOverflow(source: String @local!): Unit {
    var caught = false
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (_: JsonException) { caught = true }
    check(caught, "infinite float result must throw JsonException")
}

main(): Int64 {
    checkHeap("1.7976931348623157e308", 0x7fefffffffffffff)
    checkLocal("1.7976931348623157e308", 0x7fefffffffffffff)
    checkHeap("-1.7976931348623157e308", 0xffefffffffffffff)
    checkLocal("-1.7976931348623157e308", 0xffefffffffffffff)
    checkHeap("2.2250738585072014e-308", 0x0010000000000000)
    checkLocal("2.2250738585072014e-308", 0x0010000000000000)
    checkHeap("-2.2250738585072014e-308", 0x8010000000000000)
    checkLocal("-2.2250738585072014e-308", 0x8010000000000000)
    checkHeap("2.225073858507201e-308", 0x000fffffffffffff)
    checkLocal("2.225073858507201e-308", 0x000fffffffffffff)
    checkHeap("-2.225073858507201e-308", 0x800fffffffffffff)
    checkLocal("-2.225073858507201e-308", 0x800fffffffffffff)
    checkHeap("4.9406564584124654e-324", 0x0000000000000001)
    checkLocal("4.9406564584124654e-324", 0x0000000000000001)
    checkHeap("-4.9406564584124654e-324", 0x8000000000000001)
    checkLocal("-4.9406564584124654e-324", 0x8000000000000001)
    checkHeap("2.4703282292062327e-324", 0x0000000000000000)
    checkLocal("2.4703282292062327e-324", 0x0000000000000000)
    checkHeap("2.4703282292062328e-324", 0x0000000000000001)
    checkLocal("2.4703282292062328e-324", 0x0000000000000001)
    checkHeap("-2.4703282292062327e-324", 0x8000000000000000)
    checkLocal("-2.4703282292062327e-324", 0x8000000000000000)
    checkHeap("-2.4703282292062328e-324", 0x8000000000000001)
    checkLocal("-2.4703282292062328e-324", 0x8000000000000001)
    checkHeap("0.0", 0x0000000000000000)
    checkLocal("0.0", 0x0000000000000000)
    checkHeap("-0.0", 0x8000000000000000)
    checkLocal("-0.0", 0x8000000000000000)
    expectOverflow("1.7976931348623159e308")
    expectOverflow("[7,1.7976931348623159e308,9]")
    expectOverflow("-1.7976931348623159e308")
    expectOverflow("[7,-1.7976931348623159e308,9]")
    println("ALL PASSED")
    0
}
