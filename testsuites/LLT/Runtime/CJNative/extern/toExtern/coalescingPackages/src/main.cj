// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../src
// EXEC: %compiler %cmp_opt %compile_lib_opt src/lib/lib.cj -o lib.%middle
// EXEC: %compiler %cmp_opt lib.%middle %f -o %n.%suffix
// EXEC: %run %run_opt %n.%suffix

// The conversion in o ?? v is kept in generic and @Frozen functions of another package, which are instantiated or
// inlined in this one.

import lib.*

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func expect(n: Int64, msg: String): Unit {
    check(RT.conversions == n, "${msg}: ${RT.conversions} conversions, expected ${n}")
    RT.conversions = 0
}

main() {
    let none: ?Extern<RT> = None
    check(RT.fromExtern<Int64>(coalesce<RT>(none, 1)) == 1, "generic")
    expect(1, "generic")
    check(RT.fromExtern<Int64>(coalesce(Some(Extern<RT>(0)), 1)) == 0, "generic Some")
    expect(0, "generic Some")
    check(RT.fromExtern<Bool>(coalesceAny<RT, Bool>(none, true)), "generic operand")
    expect(1, "generic operand")
    check(RT.fromExtern<Int64>(coalesceFrozen(none)) == 2, "frozen")
    expect(1, "frozen")
    check(RT.fromExtern<String>(XBox<RT>(none).get("b")) == "b", "generic class")
    expect(1, "generic class")
    0
}
