// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug %disableFuncInlining -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py nothing_type_region_pair02_CHIR/[0-9]*_UnreachableBlockElimination.chirtxt "Func @_CN7default3fooHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-2 EndRegion()
// ASSERT: regex-1 Nothing = TryApply\(@_CN7default5neverHv, normal: #\d+, exception: #\d+\)

// `foo` holds a region and calls a Nothing-returning function inside a try with a
// same-frame catch, so the call is a TryApply whose result type is Nothing. That
// takes HandleNothingTerminator rather than the plain-Apply path: it redirects the
// success edge to a freshly created block. The new block never runs, but it is the
// terminator's normal successor and ends in Exit, so it must close the region --
// exactly one EndRegion. The second EndRegion is the pre-existing catch path.
class C {
    var x: Int64
    exclave init(this @local!, v: Int64) {
        x = v
    }
}

func never(): Nothing {
    throw Exception()
}

func foo(): Int64 {
    let v: C @local! = C(1) @local!
    try {
        never()
    } catch (_: Exception) {
        return v.x
    }
}

main() {
    println(foo())
}
