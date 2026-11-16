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

    public static let base2: Int64 = 2

    public static prop base4: Int64 {
        get() {
            4
        }
    }

    // Test Case: static member
    public init(val: Int64) {
        super(val + MyObject.base + base + Impl.base2 + base2 + getBase3() + Impl.getBase3() + base4 + Impl.base4)
    }

    public static func getBase3(): Int64 {
        3
    }

}
