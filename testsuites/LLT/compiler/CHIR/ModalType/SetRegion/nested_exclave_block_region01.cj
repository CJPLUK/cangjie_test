// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %export cjLocalRegionMaxSize=64KB && %run %run_opt %output
// EXEC: %python pick_defination.py nested_exclave_block_region01_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default5outerHv(" | compare %f --assert_flag=ASSERT_1
// ASSERT_1: scan-3 StartRegion()
// ASSERT_1: scan-3 EndRegion()
// EXEC: %python pick_defination.py nested_exclave_block_region01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default5outerHvE4makeHv(" | compare %f --assert_flag=ASSERT_2
// ASSERT_2: scan-not StartRegion()
// ASSERT_2: scan-not EndRegion()
// EXEC: %python pick_defination.py nested_exclave_block_region01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default5outerHvE4makeHvE7scratchHv(" | compare %f --assert_flag=ASSERT_3
// ASSERT_3: scan-1 StartRegion()
// ASSERT_3: scan-1 EndRegion()

// The block spelling of exclave must preserve scratch's own region just like
// the modifier spelling. Check the lifted functions separately to exclude
// a compensating make/scratch region-count regression.
// Each scratch call allocates an 8KB payload. Its region must be released on
// return: skipping the exclave subtree makes 64 calls exceed the 64KB local
// allocation budget, even though each individual call fits comfortably.
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
    func make(): Box @local! {
        exclave {
            func scratch(): Int64 {
                let values = Array<Int64>(1024, { i => i }) @local!
                values[1023]
            }
            for (_ in 0..64) {
                if (scratch() != 1023) {
                    throw Exception("Nested ordinary function lost its local value")
                }
            }
            Box(9) @local!
        }
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
