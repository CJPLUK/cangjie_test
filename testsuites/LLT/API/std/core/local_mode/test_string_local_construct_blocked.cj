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
// FIXED（设计项 LM-DOC-20260910：T203）：非 Array Collection（heap
// ArrayList widen QH）作为 String(Collection<Rune> @local?) 构造入参是规范
// 正例。std.core string.cj 的 @local? 构造已补非 Array 来源的接口迭代路径
// （RunesToUtf8Bytes.getBytesLocalCollection），本用例恢复活跃。
import std.collection.*
import std.core.*

main(): Int64 {
    var failed = 0
    // T203: 非 Array Collection（heap ArrayList widen QH）规范正例
    let al = ArrayList<Rune>([r'A', r'\u{00A2}'])
    let qc: Collection<Rune> @local? = al
    let s3: String @local! = String(qc)
    failed += assertB(s3 == "A¢", "T203_nonArray_value")
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
