/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T412。
// heap `ReadOnlyList<String>` 静态接收者：first/last/get/[] 原读契约；
// None（get 越界）与抛异常（[] 越界）严格区分（修正旧 Spec AG8 的
// 「get(999) 抛异常」错误）。heap 接口分派无 local 依赖，当前 SDK 即可执行。
// 设计编号命名空间：LM-DOC-20260910。

import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0

    // T412: 空 List 的 first/last/get(0)/get(-1) 均为 None
    let empty412 = ArrayList<String>()
    let rl412e: ReadOnlyList<String> = empty412
    failed += assertB(rl412e.first.isNone(), "T412_empty_first_none")
    failed += assertB(rl412e.last.isNone(), "T412_empty_last_none")
    let neg412: Int64 = -1
    failed += assertB(rl412e.get(0).isNone(), "T412_empty_get0_none")
    failed += assertB(rl412e.get(neg412).isNone(), "T412_empty_getNeg_none")

    // T412: 非空 first=a last=b get(1)=b [1]=b
    let al412 = ArrayList<String>(["a", "b"])
    let rl412: ReadOnlyList<String> = al412
    failed += assertB(rl412.first.getOrThrow() == "a", "T412_first")
    failed += assertB(rl412.last.getOrThrow() == "b", "T412_last")
    failed += assertB(rl412.get(1).getOrThrow() == "b", "T412_get1")
    failed += assertB(rl412[1] == "b", "T412_index1")

    // T412: [] 越界抛 IndexOutOfBoundsException（get 越界 None，二者严格区分）
    try {
        let _ = rl412[2]
        failed += 1
        println("FAIL: T412_index_oob — expected IndexOutOfBoundsException")
    } catch (err: IndexOutOfBoundsException) {}
    try {
        let _ = rl412[neg412]
        failed += 1
        println("FAIL: T412_index_neg — expected IndexOutOfBoundsException")
    } catch (err: IndexOutOfBoundsException) {}
    failed += assertB(rl412.get(2).isNone(), "T412_get_oob_none")
    failed += assertB(rl412.get(neg412).isNone(), "T412_get_neg_none")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
