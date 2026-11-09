// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %diag_json %f 2>&1
interface I1 {
    prop foo: Int64 {
        get() {
            1
        }
    }
}
interface I2 {
    prop foo: Int32 {
        get() {
            2
        }
    }
}
class C1 {}
extend C1 <: I1 & I2 {
}

main() {}
// ASSERT: scan-1 "DiagKind": "sema_inherit_member_type_inconsistent",
// ASSERT: scan "Errors": 1,