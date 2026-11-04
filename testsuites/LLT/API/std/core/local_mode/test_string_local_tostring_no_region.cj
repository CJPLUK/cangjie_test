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
// 覆盖设计项（LM-DOC-20260910）：T208。
// 隔离场景：独立 main，除被测 heap-origin String @local? 外无任何无关 local
// 绑定；toString() 在无显式 region 的 heap 来源上分配 local 结果。
// 历史 F-P01/F-P02（无 active region / heap-origin 经 exclave 分配 abort）在本
// SDK（0907）已修复，实测通过；设计原状态 NOT-RUN 据此升级为活跃用例。
// 设计编号命名空间：LM-DOC-20260910。

main(): Int64 {
    var failed = 0
    let ab: String = "ab"
    let q: String @local? = ab
    let out: String @local! = q.toString()
    let raw: Array<Byte> @local! = out.toArray()
    failed += assertEq(out.size, 2, "T208_toString_size")
    failed += assertEq(raw.size, 2, "T208_toArray_size")
    failed += assertEq(raw[0], 0x61u8, "T208_bytes_0")
    failed += assertEq(raw[1], 0x62u8, "T208_bytes_1")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
