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
// gap audit 2026-09-24 #20‡/#21‡（§4 G5）：Array/String 的 toArray(this @local?) 覆写。
// 只断言具体类型接收者；静态 `Collection<T> @local?` 接收者的分派受 NEW-C1
// （接口接收者 + @local? 期望类型绑定默认体）阻塞，不在本用例中断言。

import std.core.*

func gaArrayCopySize(a: Array<Int64> @local?): Int64 {
    a.toArray().size
}

func gaArrayCopyIsIndependent(a: Array<Int64> @local?): Bool {
    let copy: Array<Int64> @local? = a.toArray()
    copy[0] = 99
    a[0] == 1 && copy[0] == 99
}

func gaStringCopySize(s: String @local?): Int64 {
    s.toArray().size
}

main(): Int64 {
    var failed = 0
    let src: Array<Int64> @local! = [1, 2, 3]
    let q: Array<Int64> @local? = src
    failed += assertEq(gaArrayCopySize(q), 3, "GA20_array_toarray_local_q_size")
    failed += assertB(gaArrayCopyIsIndependent(q), "GA20_array_toarray_local_q_independent")
    let s: String @local? = "AB"
    failed += assertEq(gaStringCopySize(s), 2, "GA21_string_toarray_local_q_size")
    let bytes: Array<Byte> @local? = s.toArray()
    failed += assertB(bytes[0] == 0x41u8, "GA21_string_toarray_local_q_byte0")
    failed += assertB(bytes[1] == 0x42u8, "GA21_string_toarray_local_q_byte1")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
