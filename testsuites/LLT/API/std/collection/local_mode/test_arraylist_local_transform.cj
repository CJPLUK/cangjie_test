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
// Check empty transforms, callback errors, and fold results.

import std.collection.*
import std.core.*

func t320StepTakeSkipBoundaries(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        var errors: Int64 = 0
        let stepEmpty: ArrayList<Int64> @local! = a.step(1)
        let takeEmpty: ArrayList<Int64> @local! = a.take(0)
        let skipEmpty: ArrayList<Int64> @local! = a.skip(0)
        if (stepEmpty.size != 0 || takeEmpty.size != 0 || skipEmpty.size != 0) { return 1 }
        try {
            let _ = a.step(0)
            errors++
        } catch (e: IllegalArgumentException) {}
        try {
            let _ = a.take(-1)
            errors++
        } catch (e: IllegalArgumentException) {}
        try {
            let _ = a.skip(-1)
            errors++
        } catch (e: IllegalArgumentException) {}
        errors
    }
}

func t323EmptyFilterMap(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let filtered: ArrayList<Int64> @local! = a.filter({x: Int64 @local? =>
            throw ArithmeticException("T323_empty_filter_callback")
        })
        let mapped: ArrayList<String> @local! = a.map({x: Int64 @local! =>
            "unexpected"
        })
        if (filtered.size == 0 && mapped.size == 0) { 0 } else { 1 }
    }
}

func t325T326EmptyAdvanced(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let flat: ArrayList<String> @local! = a.flatMap({x: Int64 @local! =>
            let empty: ArrayList<String> @local! = ArrayList<String>() @local!
            empty
        })
        let selected: ArrayList<String> @local! = a.filterMap<String>({x: Int64 @local! =>
            None<String>
        })
        if (flat.size == 0 && selected.size == 0) { 0 } else { 1 }
    }
}

func t327IntersperseBoundaries(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let empty: ArrayList<Int64> @local! = a.intersperse(0)
        if (empty.size != 0) { return 1 }
        let oneSource: Array<Int64> @local! = [1]
        let one: ArrayList<Int64> @local! = ArrayList<Int64>(oneSource) @local!
        let oneResult: ArrayList<Int64> @local! = one.intersperse(0)
        if (oneResult.size != 1 || oneResult[0] != 1) { return 1 }
        0
    }
}

exclave func t328FoldInt64(a: ArrayList<Int64> @local!): Int64 @local! {
    let initial: Int64 @local! = 10
    a.fold(initial, {acc: Int64 @local!, x: Int64 @local! => acc - x})
}

exclave func t328FoldHeterogeneous(a: ArrayList<Int32> @local!): Int64 @local! {
    let initial: Int64 @local! = 0
    a.fold(initial, {acc: Int64 @local!, x: Int32 @local! => acc + Int64(x)})
}

exclave func t328FoldString(a: ArrayList<Int64> @local!, initial: String @local!): String @local! {
    a.fold(initial, {acc: String @local!, x: Int64 @local! => acc})
}

func t328FoldThrow(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        try {
            let initial: Int64 @local! = 0
            let _: Int64 @local! = a.fold(initial, {acc: Int64 @local!, x: Int64 @local! =>
                if (x == 2) { throw ArithmeticException("T328_fold_sentinel") }
                acc + x
            })
            1
        } catch (e: ArithmeticException) {
            0
        }
    }
}

func t329ReduceEmpty(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        let result: Option<Int64> @local! = a.reduce({x: Int64 @local!, y: Int64 @local! => x + y})
        match (result) {
            case None => 0
            case Some(_) => 1
        }
    }
}

main(): Int64 {
    var failed = 0
    let emptySource: Array<Int64> @local! = []
    let empty: ArrayList<Int64> @local! = ArrayList<Int64>(emptySource) @local!
    failed += assertEq(t320StepTakeSkipBoundaries(empty), 0, "T320_T321_T322_empty_boundaries")
    failed += assertEq(t323EmptyFilterMap(empty), 0, "T323_T324_empty_callbacks")
    failed += assertEq(t325T326EmptyAdvanced(empty), 0, "T325_T326_empty_callbacks")
    failed += assertEq(t327IntersperseBoundaries(empty), 0, "T327_intersperse_boundaries")

    let ints: Array<Int64> @local! = [1, 2, 3]
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(ints) @local!
    failed += assertEq(t328FoldInt64(list), 4, "T328_fold_left_subtraction")
    failed += assertEq(t328FoldThrow(list), 0, "T328_fold_exception")
    let int32s: Array<Int32> @local! = [1, 2, 3]
    let int32List: ArrayList<Int32> @local! = ArrayList<Int32>(int32s) @local!
    failed += assertEq(t328FoldHeterogeneous(int32List), 6, "T328_fold_R_not_T")
    let initialString: String @local! = "seed"
    let foldedString: String @local! = t328FoldString(empty, initialString)
    failed += assertB(foldedString == "seed", "T328_fold_noncopyable_result_mode")
    failed += assertEq(t329ReduceEmpty(empty), 0, "T329_reduce_empty_none")

    // T320-T327 non-empty result payloads and T329 singleton/many Some payloads
    // remain doc-correct in test_arraylist_local_transform_payload_blocked.cj.
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
