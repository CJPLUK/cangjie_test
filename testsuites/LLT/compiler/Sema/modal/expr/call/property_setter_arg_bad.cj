// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

struct S <: Copyable {
    public mut prop item: String @local! {
        get() { exclave { "value" } }
        set(v) {}
    }
    public mut func explicitThis(this @local!, value: String @local!) { this.item = value }
    public mut func implicitThis(this @local!, value: String @local!) { item = value }
}
func object(s: S @local!, value: String @local!) {
    var receiver: S @local! = s
    receiver.item = value
}
main() {}

// ASSERT: scan-3 "DiagKind": "sema_external_local_arg",
// ASSERT: scan "Errors": 3,
