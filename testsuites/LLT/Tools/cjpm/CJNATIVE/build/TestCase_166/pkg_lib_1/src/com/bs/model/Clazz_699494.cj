// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_1.com.bs.model

import pkg_macro_1.mfunc_920835

public open class Clazz_699494 {
    public Clazz_699494() {
    }
    public open func filter_i2_0(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v8110955: Bool = false
        let v8510776: Bool = false
        this.update_i2_8(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return 42u8
    }

    public open func analyze_i2_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v1027981: Bool = false
        this.serialize_i2_3(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        return 42u8
    }

    public open func update_i2_2(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v104112107: Float64 = 114.514000f64
        this.calculate_i2_5(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        return 114514i64
    }

    public open func serialize_i2_3(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v10211053: String = "hello world"
        let v12111956: Int64 = 114514i64
        this.calculate_i2_5(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        return 42u8
    }

    @mfunc_920835[42i64]
    public open func buildResult_i2_4(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v9788112: Bool = false
        let v1054890: Int64 = 114514i64
        this.calculate_i2_5(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        return 42u8
    }

    public open func calculate_i2_5(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v1095650: Float64 = 114.514000f64
        this.buildResult_i2_4(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        return Rune(82)
    }

    public open func update_i2_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        this.update_i2_2(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        return false
    }
}

internal func gfunc_524352(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v10510049: Bool = true
    let obj1089967 = Clazz_699494()
    obj1089967.serialize_i2_3(depth - 1i64)
}

internal func gfunc_524353(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v677167: Int64 = 114514i64
    let v9710274: String = "hello world"
}

func gfunc_524354(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v7076118: String = "hello world"
    let v11081112: Float64 = 114.514000f64
}
