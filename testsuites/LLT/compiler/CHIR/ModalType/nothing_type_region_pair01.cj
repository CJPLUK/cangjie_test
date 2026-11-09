// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug %disableFuncInlining -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py nothing_type_region_pair01_CHIR/[0-9]*_UnreachableBlockElimination.chirtxt "Func @_CN7default3fooHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// `foo` opens a region then calls a Nothing-returning function. NothingType
// elimination deletes everything after that Apply and inserts a new Exit; the
// new exit path must still close the region.
class C {
    var x: Int64
    exclave init(this @local!, v: Int64) {
        x = v
    }
}

func never(): Nothing {
    throw Exception()
}

func foo(): Nothing {
    let v: C @local! = C(1) @local!
    never()
}

main() {
    try {
        foo()
    } catch (_: Exception) {
    }
}
