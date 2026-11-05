// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_lib_4.com.bs.web

import pkg_tf_0.gfunc_524403
import pkg_lib_4.com.bs.model.gfunc_524397
import pkg_lib_2.com.bs.infra.gfunc_524358
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_2.com.bs.infra.Clazz_699492

internal enum Clazz_699520 {
    | Ctor_741117098

    internal static func mefn_988910468(depth: Int64): Int64 {
        return 114514i64
    }

    internal func mefn_7053118114(depth: Int64): Float64 {
        return 114.514000f64
    }
}

internal func Clazz_699520_match_test(value: Clazz_699520): Unit {
    match (value) {
        case Clazz_699520.Ctor_741117098 => "matched Clazz_699520.Ctor_741117098"

        case _ => "other"
    }
}

internal func gfunc_524398(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v10211576: Float64 = 114.514000f64
    let v9781119: Float64 = 114.514000f64
}

protected func gfunc_524399(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v12299118: String = "hello world"
    gfunc_524403(depth - 1i64)
    gfunc_524397(depth - 1i64)
    gfunc_524397(depth - 1i64)
    gfunc_524358(depth - 1i64)
    let obj1197876 = Clazz_699489("hello world", 3.140000f32)
    obj1197876.process_i14_0(depth - 1i64)
    let obj757048 = Clazz_699504()
    obj757048.update_i5_3(depth - 1i64)
    let obj9010150 = Clazz_699492()
    obj9010150.analyze_i12_4(depth - 1i64)
}
