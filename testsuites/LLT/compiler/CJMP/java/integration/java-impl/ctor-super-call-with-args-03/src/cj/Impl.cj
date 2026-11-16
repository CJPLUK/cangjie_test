// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

/**
 * Testing for sema type of using constructor parameter
 * Primitive: Int64
 * JavaMirror: MyObject
 * JavaImpl: Impl
 * String: 
 */

import java.lang.*

func id<T>(x: T): T {
    x
}

func idMyObject(x: MyObject): MyObject { x }
func idImpl(x: Impl): Impl { x }
func idJString(x: JString): JString { x }

@Java
public class Impl <: MyObject {
    public init(value: Int64) {
        // Primitive argument
        super(id(value))
    }

    public init(value: MyObject) {
        // JavaMirror argument
        super(idMyObject(value))
    }

    public init(value: Impl) {
        // JavaImpl argument
        super(idImpl(value))
    }

    public init(value: JString) {
        // String
        super(idJString(value))
    }
}
