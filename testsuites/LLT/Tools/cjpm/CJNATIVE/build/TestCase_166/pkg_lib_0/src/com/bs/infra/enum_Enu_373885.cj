// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra

import pkg_lib_3.com.bs.infra.Clazz_699498

public enum Enu_373885 {
    | Ctor_106105110114(Bool, String)
    | Ctor_1031178266(Float64, String)

    public func mefn_898897121(depth: Int64): Float64 {
        return 114.514000f64
    }

    public static func mefn_1117353114(depth: Int64): Int64 {
        return 114514i64
    }
}

public func Enu_373885_match_test(value: Enu_373885): Unit {
    match (value) {
        case Enu_373885.Ctor_106105110114(mc_0, mc_1) => "matched Enu_373885.Ctor_106105110114"

        case Enu_373885.Ctor_1031178266(mc_0, mc_1) => "matched Enu_373885.Ctor_1031178266"

        case _ => "other"
    }
}

protected func gfunc_524306(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

public func gfunc_524307(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v11980102: String = "hello world"
    let obj6585118 = Clazz_699498()
    obj6585118.transform_i8_0(depth - 1i64)
}

public func gfunc_524308(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1059873: Int64 = 114514i64
    let v11010170: Int64 = 114514i64
}
