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
// 覆盖设计项（LM-DOC-20260910）：T130/T131。
// T130 覆盖 isEmpty 两值及 all/any/none 的空集真值；T131 覆盖决定值短路、
// callback 次数以及首项异常原样传播。搜索重载的 T132/T133 在
// test_array_local_judge_copyable.cj，非 Copyable 正向阻塞项 T134 在
// test_array_local_noncopyable_search_blocked.cj。
// 设计编号命名空间：LM-DOC-20260910。

class CallbackCounter {
    var count: Int64

    init() {
        this.count = 0
    }

    func increment(): Unit {
        this.count += 1
    }
}

main(): Int64 {
    var failed = 0

    // T130: isEmpty 两值与空集的 vacuous truth（all/none=true, any=false）。
    let empty130: Array<Int64> @local? = Array<Int64>() @local!
    let values130: Array<Int64> @local? = [1, 2, 3]
    failed += assertB(empty130.isEmpty(), "T130_empty_isEmpty_true")
    failed += assertB(!values130.isEmpty(), "T130_nonempty_isEmpty_false")

    let emptyAll130 = empty130.all({ _ =>
        throw IllegalArgumentException("sentinel")
    })
    failed += assertB(emptyAll130, "T130_empty_all_vacuous_true")
    let emptyAny130 = empty130.any({ _ =>
        throw IllegalArgumentException("sentinel")
    })
    failed += assertB(!emptyAny130, "T130_empty_any_vacuous_false")
    let emptyNone130 = empty130.none({ _ =>
        throw IllegalArgumentException("sentinel")
    })
    failed += assertB(emptyNone130, "T130_empty_none_vacuous_true")

    // T130: non-empty true/false decision values.
    failed += assertB(values130.all({ x => x > 0 }), "T130_all_true")
    failed += assertB(!values130.all({ x => x < 3 }), "T130_all_false")
    failed += assertB(values130.any({ x => x == 2 }), "T130_any_true")
    failed += assertB(!values130.any({ x => x > 3 }), "T130_any_false")
    failed += assertB(values130.none({ x => x > 3 }), "T130_none_true")
    failed += assertB(!values130.none({ x => x == 2 }), "T130_none_false")

    // T131: all false / any true / none false at element 1 stop before 99.
    let shortAll131: Array<Int64> @local? = [1, 0, 99]
    let allCounter131 = CallbackCounter()
    let all131 = shortAll131.all({ x =>
        allCounter131.increment()
        if (x == 99) {
            throw IllegalArgumentException("sentinel")
        }
        x > 0
    })
    failed += assertB(!all131, "T131_all_decision_false")
    failed += assertEq(allCounter131.count, 2, "T131_all_short_circuit_count")

    let shortAny131: Array<Int64> @local? = [0, 1, 99]
    let anyCounter131 = CallbackCounter()
    let any131 = shortAny131.any({ x =>
        anyCounter131.increment()
        if (x == 99) {
            throw IllegalArgumentException("sentinel")
        }
        x > 0
    })
    failed += assertB(any131, "T131_any_decision_true")
    failed += assertEq(anyCounter131.count, 2, "T131_any_short_circuit_count")

    let shortNone131: Array<Int64> @local? = [0, 1, 99]
    let noneCounter131 = CallbackCounter()
    let none131 = shortNone131.none({ x =>
        noneCounter131.increment()
        if (x == 99) {
            throw IllegalArgumentException("sentinel")
        }
        x > 0
    })
    failed += assertB(!none131, "T131_none_decision_false")
    failed += assertEq(noneCounter131.count, 2, "T131_none_short_circuit_count")

    // T131: the first callback exception is propagated unchanged in type.
    let one131: Array<Int64> @local? = [1, 2]
    try {
        let _ = one131.all({ _ => throw IllegalArgumentException("sentinel") })
        failed += 1
        println("FAIL: T131_all_first_throw — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = one131.any({ _ => throw IllegalArgumentException("sentinel") })
        failed += 1
        println("FAIL: T131_any_first_throw — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}
    try {
        let _ = one131.none({ _ => throw IllegalArgumentException("sentinel") })
        failed += 1
        println("FAIL: T131_none_first_throw — expected IllegalArgumentException")
    } catch (e: IllegalArgumentException) {}

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
