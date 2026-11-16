// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %compile_exe_opt %enableO2 %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests constant evaluation with -O2 of match expressions lowered to a switch whose selector
// does not fit in 8 bits. The compile-time result must be the same as the runtime one.

const func matchRune(x: Rune): Int64 {
    match (x) {
        case r'A' | r'\u{141}' => 1
        case r'\u{1F600}' | r'B' => 2
        case _ => 0
    }
}

const func matchInt64(x: Int64): Int64 {
    match (x) {
        case 44 | 45 => 222
        case 300 | 301 => 111
        case _ => 0
    }
}

const R_1F600 = matchRune(r'\u{1F600}')
const R_141 = matchRune(r'\u{141}')
const R_B = matchRune(r'B')
const I_300 = matchInt64(300)
const I_44 = matchInt64(44)

func check(name: String, c: Int64, r: Int64, expected: Int64): Int64 {
    if (c == expected && r == expected) {
        return 0
    }
    println("${name}: const=${c} runtime=${r} expected=${expected}")
    return 1
}

main(): Int64 {
    var failures = 0
    var smiley = r'\u{1F600}'
    var lstroke = r'\u{141}'
    var b = r'B'
    var i300 = 300
    var i44 = 44
    failures += check("R_1F600", R_1F600, matchRune(smiley), 2)
    failures += check("R_141", R_141, matchRune(lstroke), 1)
    failures += check("R_B", R_B, matchRune(b), 2)
    failures += check("I_300", I_300, matchInt64(i300), 111)
    failures += check("I_44", I_44, matchInt64(i44), 222)
    return failures
}
