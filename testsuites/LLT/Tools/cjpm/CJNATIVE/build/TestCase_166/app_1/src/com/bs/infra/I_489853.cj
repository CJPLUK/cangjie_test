// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package app_1.com.bs.infra

import pkg_macro_0.mfunc_920834
import pkg_lib_2.com.bs.infra.gfunc_524358
import app_1.com.bs.gfunc_524283
import app_1.com.bs.gfunc_524284
import pkg_lib_3.com.bs.infra.gfunc_524363
import pkg_tf_0.gfunc_524403

internal interface I_489853 {
    func checkState_i5_0(depth: Int64): UInt16

    func fetch_i5_1(depth: Int64): UInt16

    func validate_i5_2(depth: Int64): String

    func update_i5_3(depth: Int64): Int64

    func compute_i5_4(depth: Int64): Int64

    func setValue_i5_5(depth: Int64): UInt64

    func checkState_i5_6(depth: Int64): Rune
}

internal func gfunc_524286(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v6910857: Int64 = 114514i64
    gfunc_524288(depth - 1i64)
    gfunc_524283(depth - 1i64)
    gfunc_524284(depth - 1i64)
    gfunc_524363(depth - 1i64)
    gfunc_524403(depth - 1i64)
}

@mfunc_920834[42i64]
public func gfunc_524287(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v6612186: Float64 = 114.514000f64
    gfunc_524358(depth - 1i64)
}

public func gfunc_524288(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v119119111: Float64 = 114.514000f64
}
