// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra

import pkg_macro_0.mfunc_920832

public enum Enu_373886 {
    | Ctor_121745390
    | Ctor_82101111104(Bool)
    | Ctor_113122108106(String, Int64)

    public static func mefn_1126988119(depth: Int64): Bool {
        return false
    }
}

public func Enu_373886_match_test(value: Enu_373886): Float64 {
    match (value) {
        case Enu_373886.Ctor_82101111104(mc_0) => 114.514000f64

        case Enu_373886.Ctor_113122108106(mc_0, mc_1) where mc_0 != "" => 114.514000f64

        case Enu_373886.Ctor_113122108106(mc_0, mc_1) => 114.514000f64

        case Enu_373886.Ctor_121745390 => 114.514000f64

        case _ => 114.514000f64
    }
}

@mfunc_920832[42i64]
private func gfunc_524309(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}
