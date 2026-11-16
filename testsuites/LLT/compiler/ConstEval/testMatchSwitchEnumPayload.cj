// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %compile_exe_opt %enableO2 %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests constant evaluation of a match on an enum with payload. With -O2 the match is lowered to a
// first-level switch on the constructor index and a second-level switch on the payload value.

enum Payload {
    | Num(Int64)
    | Chr(Rune)
    | Empty
}

const func matchPayload(x: Payload): Int64 {
    match (x) {
        case Num(44) => 1
        case Num(300) => 2
        case Num(-1) => 3
        case Chr(r'\u{1F600}') => 4
        case Num(_) => 5
        case _ => 0
    }
}

const P_300 = matchPayload(Num(300))
const P_44 = matchPayload(Num(44))
const P_556 = matchPayload(Num(556))
const P_M1 = matchPayload(Num(-1))
const P_255 = matchPayload(Num(255))
const P_1F600 = matchPayload(Chr(r'\u{1F600}'))
const P_A = matchPayload(Chr(r'A'))
const P_EMPTY = matchPayload(Empty)

func check(name: String, c: Int64, r: Int64, expected: Int64): Int64 {
    if (c == expected && r == expected) {
        return 0
    }
    println("${name}: const=${c} runtime=${r} expected=${expected}")
    return 1
}

main(): Int64 {
    var failures = 0
    var n300 = 300
    var n44 = 44
    var n556 = 556
    var nM1 = -1
    var n255 = 255
    var smiley = r'\u{1F600}'
    var a = r'A'
    failures += check("P_300", P_300, matchPayload(Num(n300)), 2)
    failures += check("P_44", P_44, matchPayload(Num(n44)), 1)
    failures += check("P_556", P_556, matchPayload(Num(n556)), 5)
    failures += check("P_M1", P_M1, matchPayload(Num(nM1)), 3)
    failures += check("P_255", P_255, matchPayload(Num(n255)), 5)
    failures += check("P_1F600", P_1F600, matchPayload(Chr(smiley)), 4)
    failures += check("P_A", P_A, matchPayload(Chr(a)), 0)
    failures += check("P_EMPTY", P_EMPTY, matchPayload(Empty), 0)
    return failures
}
