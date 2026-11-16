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
// 覆盖设计项（LM-DOC-20260910）：T111,T305,T313,T321（T314 range 交接见 blocked 文件）。

import std.collection.*
import std.core.*

// e1: Array get 越界返回 None（@local!）
func e1GetOob(a: Array<Int64> @local!): Bool {
    exclave {
        let o: Option<Int64> @local! = a.get(999)
        match (o) {
            case Some(_) => false
            case None => true
        }
    }
}

// e2: Array 下标越界抛 IndexOutOfBoundsException（@local!）
func e2IndexOob(a: Array<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a[999]
            1  // 未抛
        } catch (e: IndexOutOfBoundsException) {
            0
        }
    }
}

// e3: ArrayList [] 越界抛异常（@local!）
func e3AlIndexOob(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a[999]
            1
        } catch (e: IndexOutOfBoundsException) {
            0
        }
    }
}

// e4: Array repeat 非法参数抛 IllegalArgumentException（@local!）
func e4RepeatBad(a: Array<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a.repeat(0)
            1
        } catch (e: IllegalArgumentException) {
            0
        }
    }
}

// e5: ArrayList take 非法参数抛异常（@local!）
func e5TakeBad(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a.take(-1)
            1
        } catch (e: IllegalArgumentException) {
            0
        }
    }
}


// e7/e8: local! ArrayList remove(at:) validates before any write.
func e7AlRemoveNegative(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a.remove(at: -1)
            1
        } catch (e: IndexOutOfBoundsException) {
            if (a.size == 3) { 0 } else { 1 }
        }
    }
}

func e8AlRemoveSize(a: ArrayList<Int64> @local!): Int64 {
    exclave {
        try {
            let _ = a.remove(at: a.size)
            1
        } catch (e: IndexOutOfBoundsException) {
            if (a.size == 3) { 0 } else { 1 }
        }
    }
}

main(): Int64 {
    var failed = 0

    let src: Array<Int64> @local! = [1, 2, 3]
    let a1: Array<Int64> @local! = src
    failed += assertB(e1GetOob(a1), "T305_array_get_oob_none")
    failed += assertB(e2IndexOob(a1) == 0, "T305_array_index_oob")
    failed += assertB(e4RepeatBad(a1) == 0, "T111_array_repeat_invalid")

    let srcAl: Array<Int64> @local! = [1, 2, 3]
    let al = ArrayList<Int64>(srcAl) @local!
    failed += assertB(e3AlIndexOob(al) == 0, "T305_arraylist_index_oob")
    failed += assertB(e5TakeBad(al) == 0, "T321_arraylist_take_invalid")
    failed += assertB(e7AlRemoveNegative(al) == 0, "T313_remove_negative")
    failed += assertB(e8AlRemoveSize(al) == 0, "T313_remove_size")
    // T314 range-invalid probes are retained in
    // test_arraylist_local_set_range_blocked.cj: this SDK links no
    // local ArrayList.remove(Range) overload, even for write-free errors.
    // String [](Range) error remains a doc-correct blocked probe because the
    // 0907 SDK links no local String range-index overload.


    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
