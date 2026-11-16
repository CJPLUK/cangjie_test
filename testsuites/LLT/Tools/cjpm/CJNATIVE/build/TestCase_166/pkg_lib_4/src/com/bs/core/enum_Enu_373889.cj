// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

protected package pkg_lib_4.com.bs.core

import pkg_lib_4.com.bs.service.gfunc_524393
import pkg_lib_3.com.bs.infra.web.gfunc_524372
import pkg_lib_3.com.bs.infra.gfunc_524363

public enum Enu_373889 {
    | Ctor_99504875
    | Ctor_1061227879(Bool, String)
    | Ctor_1005285108
}

public func Enu_373889_match_test(value: Enu_373889): Bool {
    match (value) {
        case Enu_373889.Ctor_1061227879(mc_0, mc_1) where mc_0 => false

        case Enu_373889.Ctor_1061227879(mc_0, mc_1) => true

        case Enu_373889.Ctor_99504875 | Enu_373889.Ctor_1005285108 => true

        case _ => true
    }
}

public func gfunc_524400(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v11579102: Float64 = 114.514000f64
}

protected func gfunc_524401(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v90109105: Bool = false
    let v69109117: String = "hello world"
}

private func gfunc_524402(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v12151121: String = "hello world"
    let v8489111: String = "hello world"
    gfunc_524400(depth - 1i64)
    gfunc_524393(depth - 1i64)
    gfunc_524372(depth - 1i64)
    gfunc_524363(depth - 1i64)
}
