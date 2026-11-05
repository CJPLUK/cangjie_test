// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.core

import pkg_lib_0.com.bs.Clazz_699490
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_macro_1.mfunc_920838
import pkg_macro_0.mfunc_920833
import pkg_lib_3.com.bs.infra.gfunc_524365
import pkg_lib_3.com.bs.infra.web.gfunc_524371
import pkg_lib_0.com.bs.gfunc_524300
import pkg_lib_3.com.bs.infra.gfunc_524369
import pkg_lib_0.com.bs.Clazz_699490
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.gfunc_524363
import pkg_lib_0.com.bs.gfunc_524301
import pkg_lib_0.com.bs.gfunc_524299

internal abstract class Clazz_699485 {
    Clazz_699485() {
    }
}

@mfunc_920838
func gfunc_524325(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v7990108: Int64 = 114514i64
    let v1146587: Int64 = 114514i64
    gfunc_524365(depth - 1i64)
    gfunc_524371(depth - 1i64)
    gfunc_524300(depth - 1i64)
    gfunc_524371(depth - 1i64)
    gfunc_524369(depth - 1i64)
    gfunc_524369(depth - 1i64)
    let obj1008978 = Clazz_699490()
    obj1008978.analyze_i9_3(depth - 1i64)
    let obj1158187 = Clazz_699504()
    obj1158187.compute_i5_4(depth - 1i64)
}

@mfunc_920833[true]
public func gfunc_524326(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v758384: String = "hello world"
    let v847051: Bool = true
    gfunc_524363(depth - 1i64)
    gfunc_524301(depth - 1i64)
    gfunc_524299(depth - 1i64)
}
