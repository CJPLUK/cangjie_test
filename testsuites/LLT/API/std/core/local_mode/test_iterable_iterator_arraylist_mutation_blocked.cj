/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// FIXED-RUNTIME: T405 历史 blocker（local remove(at:) 触发 Barrier::WriteGeneric abort）已随
//   runtime write_generic 修复消失。doc-correct 行为已实测：public mutation 后
//   iterator.next() 抛出 ConcurrentModificationException，本用例恢复活跃。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.collection.*

main(): Int64 {
    let source: Array<Int64> @local! = [1, 2]
    let list: ArrayList<Int64> @local! = ArrayList<Int64>(source) @local!
    let iterator: Iterator<Int64> @local! = list.iterator()
    list.remove(at: 0)

    try {
        let _ = iterator.next()
        println("FAIL: T405_arraylist_mutation — expected ConcurrentModificationException")
        return 1
    } catch (e: ConcurrentModificationException) {
        // barrier reached: the version check fired and CME surfaced to the caller
        return 0
    }
}
