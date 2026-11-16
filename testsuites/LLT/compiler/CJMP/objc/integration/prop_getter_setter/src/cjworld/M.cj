// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    @ForeignGetterName["getFoo"]
    @ForeignSetterName["updateFoo:"]
    public mut prop foo: Int64

    @ForeignGetterName["getBar"]
    public prop bar: Float64

    @ForeignSetterName["applyBaz:"]
    public mut prop baz: Int32

    @ForeignName["_qux"]
    @ForeignGetterName["isQux"]
    public mut prop qux: Bool

    @ForeignName["_car"]
    @ForeignSetterName["writeCar:"]
    public mut prop car: Int64

    @ForeignGetterName["takeHat"]
    @ForeignSetterName["putHat:"]
    public static mut prop hat: Int32

    public init()
}
