/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// LM-DOC-20260910: T330 all/any/none vacuous values, short-circuit and
// full-scan behavior.  Mutating removeIf is covered only by the disabled
// ArrayList set/extension fixtures, not used to infer judge behavior.

import std.collection.*
import std.core.*

class JudgeState {
    var count: Int64 = 0
    var trace: Int64 = 0
}

func emptyJudge(a: ArrayList<Int64> @local?): Int64 {
    let allResult: Bool = a.all({x: Int64 @local? =>
        throw ArithmeticException("T330_empty_all_callback")
    })
    let anyResult: Bool = a.any({x: Int64 @local? =>
        throw ArithmeticException("T330_empty_any_callback")
    })
    let noneResult: Bool = a.none({x: Int64 @local? =>
        throw ArithmeticException("T330_empty_none_callback")
    })
    if (allResult && !anyResult && noneResult) { 0 } else { 1 }
}

func shortCircuitAll(a: ArrayList<Int64> @local?, state: JudgeState): Int64 {
    try {
        let result = a.all({x: Int64 @local? =>
            state.count++
            if (state.count == 1) { false } else { throw ArithmeticException("T330_all_second") }
        })
        if (!result && state.count == 1) { 0 } else { 1 }
    } catch (e: ArithmeticException) {
        1
    }
}

func shortCircuitAny(a: ArrayList<Int64> @local?, state: JudgeState): Int64 {
    try {
        let result = a.any({x: Int64 @local? =>
            state.count++
            if (state.count == 1) { true } else { throw ArithmeticException("T330_any_second") }
        })
        if (result && state.count == 1) { 0 } else { 1 }
    } catch (e: ArithmeticException) {
        1
    }
}

func shortCircuitNone(a: ArrayList<Int64> @local?, state: JudgeState): Int64 {
    try {
        let result = a.none({x: Int64 @local? =>
            state.count++
            if (state.count == 1) { true } else { throw ArithmeticException("T330_none_second") }
        })
        if (!result && state.count == 1) { 0 } else { 1 }
    } catch (e: ArithmeticException) {
        1
    }
}

func fullScan(a: ArrayList<Int64> @local?, state: JudgeState): Int64 {
    let allResult = a.all({x: Int64 @local? =>
        state.count++
        state.trace = state.trace * 10 + x
        x > 0
    })
    let anyResult = a.any({x: Int64 @local? =>
        state.count++
        state.trace = state.trace * 10 + x
        x == 3
    })
    let noneResult = a.none({x: Int64 @local? =>
        state.count++
        state.trace = state.trace * 10 + x
        x < 0
    })
    if (allResult && anyResult && noneResult && state.count == 9 && state.trace == 123123123) {
        0
    } else {
        1
    }
}

main(): Int64 {
    var failed = 0
    let emptySource: Array<Int64> @local! = []
    let empty: ArrayList<Int64> @local? = ArrayList<Int64>(emptySource) @local!
    failed += assertEq(emptyJudge(empty), 0, "T330_empty_vacuous")

    let source: Array<Int64> @local! = [1, 2, 3]
    let values: ArrayList<Int64> @local? = ArrayList<Int64>(source) @local!
    let allState = JudgeState()
    failed += assertEq(shortCircuitAll(values, allState), 0, "T330_all_short_circuit")
    let anyState = JudgeState()
    failed += assertEq(shortCircuitAny(values, anyState), 0, "T330_any_short_circuit")
    let noneState = JudgeState()
    failed += assertEq(shortCircuitNone(values, noneState), 0, "T330_none_short_circuit")
    let scanState = JudgeState()
    failed += assertEq(fullScan(values, scanState), 0, "T330_full_scan")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
