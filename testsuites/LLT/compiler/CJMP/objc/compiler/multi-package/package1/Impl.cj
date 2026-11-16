// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package1

import objc.lang.*
// It is important to not use the wildcard import
import package0.I

@ObjC
class Impl <: M & I {
    public init() {}
    public func foo(): Unit {}
    public override func boo(): I {
        super.boo()
    }
    public func fooBoo(boo: I): ?I {
        Some(boo)
    }
}
