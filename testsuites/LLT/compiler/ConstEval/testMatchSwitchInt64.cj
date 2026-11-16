// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %compile_exe_opt %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests constant evaluation of match expressions lowered to a switch whose selector or
// case values do not fit in 8 bits. The compile-time result must be the same as the runtime one.

const func orPattern(x: Int64): Int64 {
    match (x) {
        case 44 | 45 => 222
        case 300 | 301 => 111
        case _ => 0
    }
}

const func negative(x: Int64): Int64 {
    match (x) {
        case -1 | -2 => 1
        case 255 | 254 => 2
        case _ => 0
    }
}

const func boundaries(x: Int64): Int64 {
    match (x) {
        case 9223372036854775807 | 256 => 1
        case -9223372036854775808 | 0 => 2
        case _ => 0
    }
}

const func single(x: Int64): Int64 {
    match (x) {
        case -1 => 1
        case 255 => 2
        case 256 => 3
        case 300 => 4
        case -9223372036854775808 => 5
        case _ => 0
    }
}

const func unsigned(x: UInt64): Int64 {
    match (x) {
        case 0 | 1 => 1
        case 18446744073709551615 | 18446744073709551614 => 2
        case 256 | 65536 => 3
        case _ => 0
    }
}

const OR_300 = orPattern(300)
const OR_44 = orPattern(44)
const OR_556 = orPattern(556)
const NEG_M1 = negative(-1)
const NEG_255 = negative(255)
const NEG_M255 = negative(-255)
const MAX = boundaries(9223372036854775807)
const MIN = boundaries(-9223372036854775808)
const B_256 = boundaries(256)
const S_M1 = single(-1)
const S_255 = single(255)
const S_256 = single(256)
const S_300 = single(300)
const S_44 = single(44)
const S_MIN = single(-9223372036854775808)
const U_MAX = unsigned(18446744073709551615)
const U_256 = unsigned(256)
const U_65536 = unsigned(65536)
const U_255 = unsigned(255)

func check(name: String, c: Int64, r: Int64, expected: Int64): Int64 {
    if (c == expected && r == expected) {
        return 0
    }
    println("${name}: const=${c} runtime=${r} expected=${expected}")
    return 1
}

main(): Int64 {
    var failures = 0
    failures += check("OR_300", OR_300, orPattern(300), 111)
    failures += check("OR_44", OR_44, orPattern(44), 222)
    failures += check("OR_556", OR_556, orPattern(556), 0)
    failures += check("NEG_M1", NEG_M1, negative(-1), 1)
    failures += check("NEG_255", NEG_255, negative(255), 2)
    failures += check("NEG_M255", NEG_M255, negative(-255), 0)
    failures += check("MAX", MAX, boundaries(9223372036854775807), 1)
    failures += check("MIN", MIN, boundaries(-9223372036854775808), 2)
    failures += check("B_256", B_256, boundaries(256), 1)
    failures += check("S_M1", S_M1, single(-1), 1)
    failures += check("S_255", S_255, single(255), 2)
    failures += check("S_256", S_256, single(256), 3)
    failures += check("S_300", S_300, single(300), 4)
    failures += check("S_44", S_44, single(44), 0)
    failures += check("S_MIN", S_MIN, single(-9223372036854775808), 5)
    failures += check("U_MAX", U_MAX, unsigned(18446744073709551615), 2)
    failures += check("U_256", U_256, unsigned(256), 3)
    failures += check("U_65536", U_65536, unsigned(65536), 3)
    failures += check("U_255", U_255, unsigned(255), 0)
    return failures
}
