// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug %disableFuncInlining -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py nothing_type_region_pair03_CHIR/[0-9]*_UnreachableBlockElimination.chirtxt "Func @_CN7default3fooHb" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// Counter-example for nothing_type_region_pair02.cj: the region is opened outside
// the exclave, so SetRegions puts EndRegion before the Exclave terminator and
// FlattenExclave then inlines the exclave body into the same block group. Every
// block of that body is therefore entered at region depth 0.
//
// One if branch inside the exclave body calls a Nothing-returning function under a
// same-frame catch, so HandleNothingTerminator builds a new success block there.
// That block must NOT get an EndRegion: the region was already closed on the path
// into it. A heuristic like "the entry block has a StartRegion, so a block without
// an EndRegion still needs one" would double-close it here -- the well-formedness
// check (on by default) would reject the unmatched EndRegion and the runtime would
// call CJ_MCC_EndLocalRegion twice for one region. So the whole function holds
// exactly one EndRegion, the one FlattenExclave left in the entry block.
class C {
    var x: Int64
    init() {
        x = 0
    }
    exclave init(this @local!, v: Int64) {
        x = v
    }
}

func never(): Nothing {
    throw Exception()
}

func foo(flag: Bool): C@local! {
    let v: C @local! = C(1) @local!
    exclave {
        if (flag) {
            try {
                never()
            } catch (_: Exception) {
                return C(3) @local!
            }
        }
        return C(2) @local!
    }
}

main() {
    println(foo(false).x)
    println(foo(true).x)
    return 0
}
