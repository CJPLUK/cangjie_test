// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

/**
 * Testing for expr using parameters of init.
 * DTS
 */

import java.lang.*


@Java
public class Impl <: MyObject {

    // Test Case: reference to the same param
    public init(val: Int64) {
        super(val, val)
    }

    // Test Case: reference to the same param in nested expression
    public init(val: Int64, _unused: Bool) {
        super(val, val * 1000)
    }

    // Test Case: reference to the same param in nested expression but more complicated
    public init(v1: Int64, v2: Int64) {
        super(v1 + v2, v1 * 1000 + v2)
    }
}
