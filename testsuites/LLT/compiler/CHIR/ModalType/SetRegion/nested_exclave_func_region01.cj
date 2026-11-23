// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py nested_exclave_func_region01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default5outerHv" | compare %f --assert_flag=ASSERT_1
// ASSERT_1: scan-3 StartRegion()
// ASSERT_1: scan-3 EndRegion()
// EXEC: %python pick_defination.py nested_exclave_func_region01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default5outerHvE4makeHv(" | compare %f --assert_flag=ASSERT_2
// ASSERT_2: scan-not StartRegion()
// ASSERT_2: scan-not EndRegion()
// EXEC: %python pick_defination.py nested_exclave_func_region01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default5outerHvE4makeHvE7scratchHv(" | compare %f --assert_flag=ASSERT_3
// ASSERT_3: scan-1 StartRegion()
// ASSERT_3: scan-1 EndRegion()

// make is exclave and must allocate the returned Box in outer's region.
// Its ordinary nested scratch function must still open its own region, so
// region collection must visit nested lambdas inside an exclave lambda.
// The three region pairs belong to outer, inner, and scratch.
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
    exclave func make(): Box @local! {
        func scratch(): Int64 {
            let temporary = Box(777) @local!
            temporary.v
        }
        if (scratch() != 777) {
            throw Exception("Nested ordinary function lost its local value")
        }
        Box(9) @local!
    }
    func inner(a: Box @local!): Int64 {
        let junk1 = Box(111) @local!
        let junk2 = Box(222) @local!
        let junk3 = Box(333) @local!
        let junk4 = Box(444) @local!
        a.v + a.f1 + a.f2 + a.f3
    }
    inner(make())
}

main(): Int64 {
    let result = outer()
    if (result != 36) {
        throw Exception("Nested exclave function lost its returned local value: ${result}")
    }
    0
}
