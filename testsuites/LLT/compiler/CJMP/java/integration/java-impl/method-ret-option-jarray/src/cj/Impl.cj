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
        print("cj: Impl()\n", flush: true)
    }

    private var isImplArrCalled = false

    public func wasImplArrCalled(): Bool {
        return isImplArrCalled
    }

    public func resetImplCalled() {
        isImplArrCalled = false
    }

    public func getArrImpl(retNull: Bool, size: Int32): ?JArray<Impl> {
        isImplArrCalled = true
        print("cj: getArrImpl(retNull: ${retNull}, size: ${size})\n", flush: true)

        if (retNull) {
            return None
        }

        let arr = JArray<Impl>(size)
        for (i in 0..size) {
            arr[i] = this
        }
        return arr
    }
}
