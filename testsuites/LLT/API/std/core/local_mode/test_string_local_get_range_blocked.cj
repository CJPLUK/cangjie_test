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
// Check local String slices and their exact boundary exceptions.

main(): Int64 {
    var failed = 0
    let sL: String @local! = "A¢仓\u{1F600}"
    let subL: String @local! = sL[1..3]
    failed += assertB(subL == "¢", "T229_localBang_value")
    let sQ: String @local? = "A¢仓\u{1F600}"
    let subQ: String @local? = sQ[3..6]
    failed += assertB(subQ == "仓", "T229_localQ_value")
    let subC: String @local? = sQ[1..=2]
    failed += assertB(subC == "¢", "T229_closed_value")
    let neg: Int64 = -1
    try { let _ = sQ[neg..3]; failed += 1; println("FAIL: T230_negStart") }
    catch (e: IndexOutOfBoundsException) {}
    let stepRange: Range<Int64> = Range(0, 6, 2, true, true, false)
    try { let _ = sQ[stepRange]; failed += 1; println("FAIL: T230_step2") }
    catch (e: IllegalArgumentException) {}
    let contStart: Int64 = 2
    try { let _ = sQ[contStart..3]; failed += 1; println("FAIL: T230_contStart") }
    catch (e: IllegalArgumentException) {}
    // Open-ended and empty slices preserve the declared result mode.
    let openEnd: String @local? = sQ[6..]
    failed += assertB(openEnd == "\u{1F600}", "T229_openEnd_value")
    let emptyRange: String @local? = sQ[3..3]
    failed += assertB(emptyRange == "", "T229_emptyRange_value")
    // Reject an out-of-bounds end and a continuation-byte end.
    let oobEnd: Int64 = 11
    try { let _ = sQ[3..oobEnd]; failed += 1; println("FAIL: T230_oobEnd") }
    catch (e: IndexOutOfBoundsException) {}
    try { let _ = sQ[1..2]; failed += 1; println("FAIL: T230_endContinuation") }
    catch (e: IllegalArgumentException) {}
    if (failed > 0) { println("${failed} test(s) FAILED"); return 1 }
    println("ALL PASSED")
    return 0
}
