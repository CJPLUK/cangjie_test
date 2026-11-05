// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package app_1.com.bs.core

import app_1.com.bs.Clazz_699495
import app_1.com.bs.web.Clazz_699527
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699489
import app_1.com.bs.Clazz_699495
import app_1.com.bs.model.gfunc_524292
import app_1.com.bs.gfunc_524282
import pkg_lib_3.com.bs.infra.gfunc_524365
import pkg_lib_2.com.bs.impl.gfunc_524360
import pkg_lib_3.com.bs.infra.gfunc_524366

public class Clazz_699511 {
    public Clazz_699511(public var f_C14_62432_68149: UInt64, public var f_C14_62433_829941: UInt32,
        public let f_C14_62434_872065: Int8) {
    }
    public func update_i0_0(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let v1147882: String = "hello world"
        let obj9810482 = Clazz_699498()
        obj9810482.query_i9_2(depth - 1i64)
        let obj978888 = Clazz_699489("hello world", 3.140000f32)
        obj978888.process_i14_0(depth - 1i64)
        this.compute_i0_1(depth - 1i64)
        let obj687570 = Clazz_699492()
        obj687570.filter_i10_8(depth - 1i64)
        obj978888.handleEvent_i3_7(depth - 1i64)
        let obj10190117 = Clazz_699504()
        obj10190117.handleEvent_i11_9(depth - 1i64)
        this.compute_i0_1(depth - 1i64)
        this.compute_i0_1(depth - 1i64)
        return 3.140000f32
    }

    public func compute_i0_1(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        let obj7588103 = Clazz_699495(42i32, 3.140000f32)
        obj7588103.fetch_i11_4(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        this.update_i0_0(depth - 1i64)
        return 114514i64
    }

    public static func create_C14(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v111103101: Int64 = 114514i64
        let v986671: Bool = false
        let obj6910974 = Clazz_699504()
        obj6910974.checkState_i5_6(depth - 1i64)
        let obj7872103 = Clazz_699492()
        obj7872103.validate_i5_2(depth - 1i64)
        obj7872103.checkState_i4_2(depth - 1i64)
        obj6910974.process_i11_8(depth - 1i64)
        obj6910974.fetch_i5_1(depth - 1i64)
        obj7872103.evaluate_i4_1(depth - 1i64)
        let obj12110687 = Clazz_699498()
        obj12110687.calculate_i1_3(depth - 1i64)
        let obj11572108 = Clazz_699495(42i32, 3.140000f32)
        obj11572108.checkState_i5_0(depth - 1i64)
        let obj10378117 = Clazz_699489("hello world", 3.140000f32)
        obj10378117.buildResult_i3_6(depth - 1i64)
        obj6910974.handleEvent_i11_9(depth - 1i64)
        return 114514i64
    }
}

public func gfunc_524294(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v7711457: Float64 = 114.514000f64
    let v8511051: Bool = true
    Clazz_699489.create_O2(depth - 1i64)
    let obj1178776 = Clazz_699495(42i32, 3.140000f32)
    obj1178776.process_i11_8(depth - 1i64)
    obj1178776.checkState_i5_0(depth - 1i64)
}

protected func gfunc_524295(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524282(depth - 1i64)
    gfunc_524365(depth - 1i64)
    gfunc_524365(depth - 1i64)
    gfunc_524294(depth - 1i64)
    gfunc_524360(depth - 1i64)
    gfunc_524366(depth - 1i64)
    gfunc_524365(depth - 1i64)
}

public func gfunc_524296(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524292(depth - 1i64)
}
