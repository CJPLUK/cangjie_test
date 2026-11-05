// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra.model.config

import pkg_macro_1.mfunc_920837
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504

@mfunc_920837["v"]
internal interface I_489862 {
    func process_i14_0(depth: Int64): Int64

    func synthesize_i14_1(depth: Int64): Unit

    func convert_i14_2(depth: Int64): Int16

    func query_i14_3(depth: Int64): Bool

    func query_i14_4(depth: Int64): Rune
}

public func gfunc_524320(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8711499: Int64 = 114514i64
    Clazz_699489.create_O2(depth - 1i64)
    let obj12011388 = Clazz_699504()
    obj12011388.compute_i5_4(depth - 1i64)
    obj12011388.validate_i5_2(depth - 1i64)
}

public func gfunc_524321(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8610484: Float64 = 114.514000f64
}
