// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra.model

import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_0.com.bs.Clazz_699490

public enum Clazz_699521 {
    | Ctor_661017184
    | Ctor_1018810289(Float64)
}

public func Clazz_699521_match_test(value: Clazz_699521): Unit {
    match (value) {
        case Clazz_699521.Ctor_1018810289(mc_0) where mc_0 > 0.0 => "matched Clazz_699521.Ctor_1018810289"

        case Clazz_699521.Ctor_1018810289(mc_0) => "matched Clazz_699521.Ctor_1018810289"

        case Clazz_699521.Ctor_661017184 => "matched Clazz_699521.Ctor_661017184"

        case _ => "other"
    }
}

protected func gfunc_524318(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1116879: Float64 = 114.514000f64
    let v71112100: Bool = false
}

protected func gfunc_524319(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v769052: String = "hello world"
    let v9878120: Float64 = 114.514000f64
    let obj6610775 = Clazz_699504()
    obj6610775.update_i5_3(depth - 1i64)
    let obj10211875 = Clazz_699490()
    obj10211875.query_i9_2(depth - 1i64)
    obj10211875.update_i8_2(depth - 1i64)
    obj10211875.compare_i9_5(depth - 1i64)
}
