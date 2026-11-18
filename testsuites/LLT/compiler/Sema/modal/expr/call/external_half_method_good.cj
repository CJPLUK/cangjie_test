// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

class C {
    public func read(this @local?): Int64 { 1 }
    public func explicitThis(this @local!) { this.read() }
    public func implicitThis(this @local!) { read() }
}
func object(c: C @local!) { c.read() }
main() {}
