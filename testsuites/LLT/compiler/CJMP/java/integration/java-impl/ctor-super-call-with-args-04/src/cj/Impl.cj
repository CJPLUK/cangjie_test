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

func idI2(x: I2): I2 { x }
func idMyObject(x: MyObject): MyObject { x }
func idJString(x: JString): JString { x }
func idJArray(x: JArray<?MyObject>): JArray<?MyObject> { x }


func a2(v0: ?MyObject, v1: ?MyObject): JArray<?MyObject> {
    var ret = JArray<?MyObject>(2)
    ret[0] = v0
    ret[1] = v1
    return ret
}

@Java
public class Impl <: MyObject & I2 {
    public init(value: I2) {
        // Primitive argument
        super(idI2(value))
    }

    public init(value: MyObject) {
        // JavaMirror argument
        super(idMyObject(value))
    }

    public init(value: JString) {
        // String
        super(idJString(value))
    }

    public init(value: JArray<?MyObject>) {
        // String
        super(idJArray(value))
    }

    public init(v0: ?MyObject, v1: ?MyObject) {
        super(a2(v0, v1))
    }

    public func test(): Bool {
        true
    }
}
