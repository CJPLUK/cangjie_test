// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py throw_leave01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default1fHv" | compare %f
// ASSERT: scan-1 StartRegion()
// ASSERT: scan-1 EndRegion()

// Region is held in f; throw leaves this frame (no same-frame catch), so
// RaiseException has no exception block. Covers the path that used to insert
// EndRegion before such RaiseException (now only Exit gets EndRegion).
func f() {
    var x: Option<Int64>@local! = 1
    throw Exception("e")
}

main() {
    try {
        f()
    } catch (e: Exception) {
        println(0)
    }
}
