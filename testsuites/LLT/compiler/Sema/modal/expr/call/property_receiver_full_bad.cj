// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

class C {
    public mut prop value: Int64 @local! {
        get() { 1 }
        set(v) {}
    }
    public func explicitThis(this @local!) {
        this.value
        this.value = 0
    }
    public func implicitThis(this @local!) {
        value
        value = 0
    }
}
func object(c: C @local!) {
    c.value
    c.value = 0
}
main() {}

// ASSERT: scan-6 "DiagKind": "sema_external_local_arg",
// ASSERT: scan-6 "Message": "cannot pass argument of external @local! to @local! this parameter",
// ASSERT: scan "Errors": 6,
