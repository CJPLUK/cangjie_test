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

// T507 / S507 / P507: valid UTF-8 at EOF preserves the documented exception type.

import stdx.encoding.json.*

func check(condition: Bool, label: String): Unit {
    if (!condition) { throw Exception(label) }
}

func heapFailure(source: String): Int64 {
    try { let _: JsonValue = JsonValue.fromStr(source) }
    catch (_: JsonException) { return 0 }
    catch (_: Exception) { return 1 }
    1
}

exclave func localFailure(source: String @local!): Int64 {
    try { let _: JsonValue @local! = JsonValue.fromStr(source) }
    catch (_: JsonException) { return 0 }
    catch (_: Exception) { return 1 }
    1
}

main(): Int64 {
    var heapFailures: Int64 = 0
    var localFailures: Int64 = 0
    for (source in ["\"\u{80}", "\"中", "\"\u{10000}", "{\"中", "[\"\\n中",
        "\"x", "[\"中\"", "\"中\\"]) {
        heapFailures += heapFailure(source)
        let localSource: String @local! = String(source) @local!
        localFailures += localFailure(localSource)
    }
    let recovered: JsonValue @local! = JsonValue.fromStr("[1]")
    check(recovered.asArray()[0].asInt().getValue() == 1, "independent parsing after EOF errors")
    println("Unexpected results: heap=${heapFailures}, local=${localFailures}")
    check(heapFailures == 0, "unterminated heap JSON must throw JsonException")
    check(localFailures == 0, "unterminated local JSON must throw JsonException")
    println("ALL PASSED")
    0
}
