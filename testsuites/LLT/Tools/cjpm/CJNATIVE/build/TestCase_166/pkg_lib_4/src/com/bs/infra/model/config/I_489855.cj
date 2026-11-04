// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_4.com.bs.infra.model.config

import pkg_macro_0.mfunc_920832
import pkg_lib_4.com.bs.service.Clazz_699501
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_2.com.bs.infra.gfunc_524359
import pkg_lib_4.com.bs.infra.gfunc_524381

@mfunc_920832[42i64]
protected interface I_489855 {
    func convert_i7_0(depth: Int64): Float32

    func validate_i7_1(depth: Int64): Float32

    func compare_i7_2(depth: Int64): Bool

    func fetch_i7_3(depth: Int64): UInt16

    func handleEvent_i7_4(depth: Int64): Unit

    func serialize_i7_5(depth: Int64): UInt64

    func evaluate_i7_6(depth: Int64): Bool
}

public func gfunc_524384(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

@mfunc_920832["v"]
public func gfunc_524385(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v11812248: Int64 = 114514i64
    gfunc_524359(depth - 1i64)
    gfunc_524381(depth - 1i64)
}

internal func gfunc_524386(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v9057104: Float64 = 114.514000f64
    let v1218055: Int64 = 114514i64
    let obj9082106 = Clazz_699501()
    obj9082106.setValue_i5_5(depth - 1i64)
    let obj10386120 = Clazz_699492()
    obj10386120.query_i14_3(depth - 1i64)
}
