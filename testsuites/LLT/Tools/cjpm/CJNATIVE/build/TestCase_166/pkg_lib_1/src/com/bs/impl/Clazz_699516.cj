// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_1.com.bs.impl

import pkg_macro_0.mfunc_920831
import pkg_macro_0.mfunc_920834

@mfunc_920831
public class Clazz_699516 {
    public Clazz_699516() {
    }
    public open func filter_i2_0(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v7911680: Float64 = 114.514000f64
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        return 42u8
    }

    public open func analyze_i2_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return 42u8
    }

    public open func serialize_i2_3(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v1085469: Bool = false
        this.analyze_i2_1(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        return 42u8
    }

    public open func update_i2_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return true
        }
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return false
    }
}

internal func gfunc_524346(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8776114: Bool = true
}

@mfunc_920834[42i64]
protected func gfunc_524347(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

internal func gfunc_524348(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1069786: Int64 = 114514i64
    let v9882109: Int64 = 114514i64
    gfunc_524343(depth - 1i64)
}
