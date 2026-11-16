// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

class C {
    public mut prop value: String @local? {
        get() { throw Exception() }
        set(v) {}
    }
    public func explicitThis(this @local?, s: String @local!) { this.value = s }
    public func implicitThis(this @local?, s: String @local!) { value = s }
}
func object(c: C, s: String @local!) { c.value = s }
struct S <: Copyable {
    public prop result: String @local! {
        get() { exclave { "value" } }
    }
}
func propertyResult(c: C, s: S @local!) { c.value = s.result }
main() {}
