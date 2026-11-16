// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package dep

public struct Box<T> {
    public var x: Int64
    public var s: String
    public var extra: T

    public init(x: Int64, s: String, extra: T) {
        this.x = x
        this.s = s
        this.extra = extra
    }

    public mut func set(s: String): Unit {
        this.s = s
    }

    public func get(): String {
        return s
    }
}
