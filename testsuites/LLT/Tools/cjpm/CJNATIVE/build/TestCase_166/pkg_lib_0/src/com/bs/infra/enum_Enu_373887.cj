// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra

import pkg_macro_1.mfunc_920838
import pkg_lib_3.com.bs.infra.web.Clazz_699504
internal import pkg_lib_0.com.bs.Clazz_699490
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_0.com.bs.gfunc_524301

protected enum Enu_373887 {
    | Ctor_1088110856

    protected func mefn_66518889(depth: Int64): Bool {
        return true
    }
}

protected func Enu_373887_match_test(value: Enu_373887): Unit {
    match (value) {
        case Enu_373887.Ctor_1088110856 => "matched Enu_373887.Ctor_1088110856"

        case _ => "other"
    }
}

protected func gfunc_524310(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8467122: String = "hello world"
    let v1008549: Float64 = 114.514000f64
}

@mfunc_920838
public func gfunc_524311(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v10011370: String = "hello world"
    let v7654122: Int64 = 114514i64
    gfunc_524303(depth - 1i64)
    let obj705569 = Clazz_699504()
    obj705569.validate_i11_3(depth - 1i64)
    let obj11749111 = Clazz_699490()
    obj11749111.update_i8_2(depth - 1i64)
    let obj897887 = Clazz_699505(42u8, 114514i64)
    obj897887.synthesize_i8_4(depth - 1i64)
    let obj1078880 = Clazz_699489("hello world", 3.140000f32)
    obj1078880.checkState_i3_1(depth - 1i64)
}

public func gfunc_524312(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1098070: Int64 = 114514i64
    let v10811586: String = "hello world"
    gfunc_524301(depth - 1i64)
}
