// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_macro
import localapi.*
@local public func kept(): Unit {}
@local public func hidden(value: String @local?): Unit {}
@local public class Wrapped {
    public func keep(): Unit {}
    public func hidden(this @local?): Unit {}
}
@local public func inferredMacroCallback() { { value: String @local? => } }
main() {}
