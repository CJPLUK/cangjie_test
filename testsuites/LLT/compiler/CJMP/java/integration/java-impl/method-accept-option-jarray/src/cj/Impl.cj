// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: JObject {
    public init() {
        print("Impl()\n", flush: true)
    }

    private var isImplNullCalled = false

    public func wasImplNullCalled(): Bool {
        return isImplNullCalled
    }

    public func isNull(arr: ?JArray<Impl>): Bool {
        isImplNullCalled = true
        match (arr) {
            case Some(a) => print("cj: isNull(arr) = false\n", flush: true)
            case None => print("cj: isNull(arr) = true\n", flush: true)
        }
        return arr.isNone()
    }
}
