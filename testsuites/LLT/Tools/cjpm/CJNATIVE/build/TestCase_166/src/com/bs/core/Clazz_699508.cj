// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.core

import package_fuzz.com.bs.infra.model.config.Clazz_699487
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_macro_1.mfunc_920838
import pkg_lib_4.com.bs.service.gfunc_524395
import pkg_lib_2.com.bs.impl.gfunc_524360
import pkg_tf_0.gfunc_524403
import pkg_lib_3.com.bs.infra.web.gfunc_524372
import package_fuzz.com.bs.infra.model.config.Clazz_699487
import app_1.com.bs.gfunc_524283
import pkg_lib_3.com.bs.infra.gfunc_524366
import pkg_lib_3.com.bs.infra.gfunc_524363
import pkg_lib_4.com.bs.model.gfunc_524396
import package_fuzz.com.bs.infra.model.config.gfunc_524269
import pkg_lib_3.com.bs.infra.gfunc_524365

protected class Clazz_699508 {
    protected Clazz_699508() {
    }
    public open func checkState_i3_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v1146974: Int64 = 114514i64
        let v10211579: Bool = true
        this.handleEvent_i3_7(depth - 1i64)
        this.handleEvent_i3_7(depth - 1i64)
        this.handleEvent_i3_7(depth - 1i64)
        let obj118104116 = Clazz_699492()
        obj118104116.merge_i10_1(depth - 1i64)
        let obj9767111 = Clazz_699489("hello world", 3.140000f32)
        obj9767111.query_i14_4(depth - 1i64)
        let obj6612190 = Clazz_699504()
        obj6612190.calculate_i11_7(depth - 1i64)
        return 42u8
    }

    public open func process_i3_3(depth: Int64): Int32 {
        if (depth <= 0i64) {
            return 42i32
        }
        let v1059872: Int64 = 114514i64
        let v7711181: Bool = false
        this.query_i14_3(depth - 1i64)
        let obj65111109 = Clazz_699489("hello world", 3.140000f32)
        obj65111109.filter_i3_4(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        let obj8649115 = Clazz_699492()
        obj8649115.fetch_i5_1(depth - 1i64)
        obj8649115.process_i14_0(depth - 1i64)
        let obj10510767 = Clazz_699487(true)
        obj10510767.compare_i9_5(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        obj10510767.fetch_i9_4(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        obj65111109.buildResult_i3_6(depth - 1i64)
        obj8649115.compute_i10_6(depth - 1i64)
        let obj9811268 = Clazz_699504()
        obj9811268.validate_i11_3(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        return 42i32
    }

    public open func buildResult_i3_6(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v1015048: Float64 = 114.514000f64
        let v7810074: Float64 = 114.514000f64
        this.synthesize_i14_1(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        let obj1038852 = Clazz_699492()
        obj1038852.process_i14_0(depth - 1i64)
        this.checkState_i3_1(depth - 1i64)
        this.process_i3_3(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        this.handleEvent_i3_7(depth - 1i64)
        let obj1127477 = Clazz_699498()
        obj1127477.update_i8_2(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        obj1127477.query_i9_2(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        obj1127477.calculate_i1_3(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        return 42u8
    }

    public open func handleEvent_i3_7(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        let obj8410251 = Clazz_699487(false)
        obj8410251.update_i8_2(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        obj8410251.calculate_i1_1(depth - 1i64)
        obj8410251.query_i8_3(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        let obj10586116 = Clazz_699498()
        obj10586116.update_i8_2(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        this.checkState_i3_1(depth - 1i64)
        return false
    }

    public open func synthesize_i14_1(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v8710283: Bool = false
        this.handleEvent_i3_7(depth - 1i64)
        let obj1026679 = Clazz_699492()
        obj1026679.convert_i14_2(depth - 1i64)
        let obj84109119 = Clazz_699489("hello world", 3.140000f32)
        obj84109119.synthesize_i14_1(depth - 1i64)
        this.process_i3_3(depth - 1i64)
        this.checkState_i3_1(depth - 1i64)
        obj1026679.filter_i10_2(depth - 1i64)
        let obj10011487 = Clazz_699498()
        obj10011487.compare_i9_5(depth - 1i64)
        this.checkState_i3_1(depth - 1i64)
    }

    public open func query_i14_3(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        this.query_i14_4(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        let obj8580104 = Clazz_699504()
        obj8580104.handleEvent_i11_9(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        let obj718180 = Clazz_699492()
        obj718180.execute_i10_4(depth - 1i64)
        this.process_i3_3(depth - 1i64)
        this.handleEvent_i3_7(depth - 1i64)
        this.buildResult_i3_6(depth - 1i64)
        this.checkState_i3_1(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        obj8580104.calculate_i11_5(depth - 1i64)
        let obj1096787 = Clazz_699489("hello world", 3.140000f32)
        obj1096787.process_i3_3(depth - 1i64)
        obj718180.evaluate_i4_1(depth - 1i64)
        obj1096787.query_i14_3(depth - 1i64)
        let obj72101115 = Clazz_699498()
        obj72101115.fetch_i9_4(depth - 1i64)
        obj1096787.finalize_i3_5(depth - 1i64)
        return false
    }

    public open func query_i14_4(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v100122116: Bool = true
        this.checkState_i3_1(depth - 1i64)
        let obj75109121 = Clazz_699489("hello world", 3.140000f32)
        obj75109121.convert_i14_2(depth - 1i64)
        obj75109121.checkState_i3_1(depth - 1i64)
        this.process_i3_3(depth - 1i64)
        let obj73112121 = Clazz_699487(false)
        obj73112121.analyze_i9_3(depth - 1i64)
        this.handleEvent_i3_7(depth - 1i64)
        this.process_i3_3(depth - 1i64)
        return Rune(82)
    }
}

@mfunc_920838
internal func gfunc_524273(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v9010386: Float64 = 114.514000f64
    let v6948122: String = "hello world"
    gfunc_524283(depth - 1i64)
    gfunc_524366(depth - 1i64)
    gfunc_524363(depth - 1i64)
    gfunc_524396(depth - 1i64)
    gfunc_524269(depth - 1i64)
    gfunc_524365(depth - 1i64)
    gfunc_524269(depth - 1i64)
    gfunc_524271(depth - 1i64)
    let obj7311098 = Clazz_699487(false)
    obj7311098.serialize_i1_9(depth - 1i64)
    let obj1086576 = Clazz_699498()
    obj1086576.query_i8_3(depth - 1i64)
    let obj1179752 = Clazz_699504()
    obj1179752.update_i5_3(depth - 1i64)
    let obj80103120 = Clazz_699508()
    obj80103120.checkState_i3_1(depth - 1i64)
    Clazz_699489.create_O2(depth - 1i64)
    obj80103120.handleEvent_i3_7(depth - 1i64)
    obj1086576.fetch_i9_4(depth - 1i64)
    obj1086576.fetch_i9_4(depth - 1i64)
    let obj82110107 = Clazz_699492()
    obj82110107.checkState_i5_0(depth - 1i64)
}

public func gfunc_524274(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v11812253: Int64 = 114514i64
    gfunc_524395(depth - 1i64)
    gfunc_524360(depth - 1i64)
    gfunc_524403(depth - 1i64)
    gfunc_524372(depth - 1i64)
    let obj887975 = Clazz_699508()
    obj887975.checkState_i3_1(depth - 1i64)
    let obj897157 = Clazz_699487(true)
    obj897157.fetch_i1_8(depth - 1i64)
    Clazz_699489.create_O2(depth - 1i64)
}
