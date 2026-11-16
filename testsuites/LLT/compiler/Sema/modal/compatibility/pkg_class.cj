// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_class

public class C {
    public init() {}
    public func mFull(this @local!): Int64 {
        1
    }
    public func mHalf(this @local?): Int64 {
        1
    }
}

public class P {
    public init() {}
    public prop fullProp: Int64 @local! {
        get() {
            1
        }
    }
    public prop halfProp: Int64 @local? {
        get() {
            1
        }
    }
    public prop nestedProp: ((Int64 @local!) -> Int64) -> Int64 {
        get() {
            { a => 0 }
        }
    }
}

public class Ctor {
    public init(a: Int64 @local!) {}
}
