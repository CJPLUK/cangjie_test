// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// RUN-EXEC: %export cjLocalRegionMaxSize=64KB && %run %run_opt %output
// EXEC: %python pick_defination.py exclave_lambda_enum_boundary01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default4makeHNNat6OptionIlEQlE(" | compare %f --assert_flag=ASSERT_1
// ASSERT_1: scan-not StartRegion()
// ASSERT_1: scan-not EndRegion()
// EXEC: %python pick_defination.py exclave_lambda_enum_boundary01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default4makeHNNat6OptionIlEQlEE7scratchHNNat6OptionIlEQlE(" | compare %f --assert_flag=ASSERT_2
// ASSERT_2: scan-1 StartRegion()
// ASSERT_2: scan-1 EndRegion()
// EXEC: %python pick_defination.py exclave_lambda_enum_boundary01_CHIR/[0-9]*_ClosureConversion.chirtxt "Func @_CN7default4makeHNNat6OptionIlEQlEE8pressureHv(" | compare %f --assert_flag=ASSERT_3
// ASSERT_3: scan-1 StartRegion()
// ASSERT_3: scan-1 EndRegion()

// The returned enum slot belongs to scratch, not to the surrounding exclave.
// IsInExclave must stop at the Lambda boundary when classifying its stores.
// Keep scratch free of other allocations so its enum return slot alone must
// request a region. The sibling pressure function makes a skipped exclave
// subtree observable at run time: 64 unreleased 8KB allocations exceed 64KB.
func make(seed: Option<Int64> @local?): Option<Int64> @local? {
    exclave {
        func scratch(value: Option<Int64> @local?): Option<Int64> @local? { value }
        func pressure(): Int64 {
            let values = Array<Int64>(1024, { i => i }) @local!
            values[1023]
        }
        for (_ in 0..64) {
            if (pressure() != 1023) { throw Exception("bad scratch array") }
        }
        scratch(seed)
    }
}
main() {
    let seed: Option<Int64> @local? = Some(777)
    let result = make(seed)
    match (result) {
        case Some(value) => if (value != 777) { throw Exception("bad enum") }
        case None => throw Exception("missing enum")
    }
}
