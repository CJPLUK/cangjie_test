// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py nested_default_param_region01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default5outerHv" | compare %f
// ASSERT: scan-2 StartRegion()
// ASSERT: scan-2 EndRegion()

// The default-value lambda must allocate in its caller's region. Only outer
// and inner open regions; closing a region in the default-value lambda lets
// junk1 overwrite the returned Box before inner reads it (issue #1350).
class Box {
    public var v: Int64 = 0
    public var f1: Int64 = 1
    public var f2: Int64 = 2
    public var f3: Int64 = 3

    public init(t: Int64) {
        v = t
        f1 = t
        f2 = t
        f3 = t
    }

    public init(this @local!, t: Int64) {
        exclave {
            v = t
            f1 = t
            f2 = t
            f3 = t
        }
    }
}

func outer(): Int64 {
    func inner(a!: Box @local! = Box(9) @local!): Int64 {
        let junk1 = Box(111) @local!
        let junk2 = Box(222) @local!
        let junk3 = Box(333) @local!
        let junk4 = Box(444) @local!
        a.v + a.f1 + a.f2 + a.f3
    }
    inner()
}

main(): Int64 {
    let result = outer()
    if (result != 36) {
        throw Exception("Nested default parameter lost its local region: ${result}")
    }
    0
}
