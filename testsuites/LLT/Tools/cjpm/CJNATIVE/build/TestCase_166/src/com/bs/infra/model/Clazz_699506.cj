// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.infra.model

import package_fuzz.com.bs.core.Clazz_699508
import package_fuzz.com.bs.impl.Clazz_699517
import package_fuzz.com.bs.infra.model.config.Clazz_699487
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import package_fuzz.com.bs.core.gfunc_524274
import pkg_tf_0.gfunc_524403
import pkg_lib_4.com.bs.service.gfunc_524395
import pkg_lib_3.com.bs.infra.gfunc_524363
import pkg_lib_4.com.bs.model.gfunc_524396
import package_fuzz.com.bs.core.Clazz_699508
import package_fuzz.com.bs.infra.model.config.Clazz_699487
import package_fuzz.com.bs.impl.gfunc_524279
import pkg_lib_3.com.bs.infra.gfunc_524369
import pkg_lib_3.com.bs.infra.gfunc_524365
import package_fuzz.com.bs.core.gfunc_524272

internal class Clazz_699506 {
    internal Clazz_699506() {
    }
    public open func analyze_i2_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        this.update_i2_8(depth - 1i64)
        let obj7411983 = Clazz_699504()
        obj7411983.setValue_i5_5(depth - 1i64)
        let obj8568102 = Clazz_699487(false)
        obj8568102.calculate_i9_7(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        obj7411983.validate_i5_2(depth - 1i64)
        let obj1035548 = Clazz_699498()
        obj1035548.calculate_i1_10(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        let obj1206883 = Clazz_699492()
        obj1206883.update_i5_3(depth - 1i64)
        obj1206883.setValue_i5_5(depth - 1i64)
        obj1206883.analyze_i12_4(depth - 1i64)
        obj1206883.fetch_i5_1(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return 42u8
    }

    public open func update_i2_2(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v747156: String = "hello world"
        let obj88108110 = Clazz_699492()
        obj88108110.analyze_i12_4(depth - 1i64)
        let obj858748 = Clazz_699489("hello world", 3.140000f32)
        obj858748.query_i14_3(depth - 1i64)
        let obj107109105 = Clazz_699517()
        obj107109105.update_i2_2(depth - 1i64)
        let obj998073 = Clazz_699508()
        obj998073.synthesize_i14_1(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        return 114514i64
    }

    public open func serialize_i2_3(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        this.update_i2_2(depth - 1i64)
        let obj654983 = Clazz_699489("hello world", 3.140000f32)
        obj654983.handleEvent_i3_7(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj11112089 = Clazz_699517()
        obj11112089.serialize_i2_3(depth - 1i64)
        let obj828655 = Clazz_699487(false)
        obj828655.calculate_i1_3(depth - 1i64)
        obj654983.query_i14_3(depth - 1i64)
        let obj988152 = Clazz_699504()
        obj988152.fetch_i5_1(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        obj11112089.serialize_i2_3(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj867450 = Clazz_699492()
        obj867450.initialize_i10_5(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        obj654983.buildResult_i3_6(depth - 1i64)
        obj867450.validate_i5_2(depth - 1i64)
        return 42u8
    }

    public open func buildResult_i2_4(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v7610356: String = "hello world"
        let v808557: String = "hello world"
        this.update_i2_8(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        let obj6672120 = Clazz_699492()
        obj6672120.fetch_i5_1(depth - 1i64)
        obj6672120.filter_i10_2(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        let obj73102111 = Clazz_699489("hello world", 3.140000f32)
        obj73102111.query_i14_3(depth - 1i64)
        Clazz_699517.create_C20(depth - 1i64)
        return 42u8
    }

    public open func calculate_i2_5(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v726785: String = "hello world"
        let v11011671: Int64 = 114514i64
        let obj869987 = Clazz_699504()
        obj869987.calculate_i11_5(depth - 1i64)
        let obj1127251 = Clazz_699498()
        obj1127251.resolve_i1_7(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        let obj1167088 = Clazz_699489("hello world", 3.140000f32)
        obj1167088.checkState_i3_1(depth - 1i64)
        return Rune(82)
    }

    public open func update_i2_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return true
        }
        let obj11366110 = Clazz_699517()
        obj11366110.filter_i2_0(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        obj11366110.filter_i2_0(depth - 1i64)
        obj11366110.serialize_i2_3(depth - 1i64)
        let obj7173107 = Clazz_699504()
        obj7173107.fetch_i5_1(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        let obj9810776 = Clazz_699489("hello world", 3.140000f32)
        obj9810776.finalize_i3_5(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        obj7173107.validate_i11_3(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj1128499 = Clazz_699492()
        obj1128499.evaluate_i10_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return false
    }
}

public func gfunc_524266(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v725166: Int64 = 114514i64
    gfunc_524279(depth - 1i64)
    gfunc_524369(depth - 1i64)
    gfunc_524365(depth - 1i64)
    let obj848073 = Clazz_699508()
    obj848073.checkState_i3_1(depth - 1i64)
    let obj11811082 = Clazz_699504()
    obj11811082.fetch_i5_1(depth - 1i64)
    let obj11867101 = Clazz_699506()
    obj11867101.analyze_i2_1(depth - 1i64)
    let obj1115069 = Clazz_699489("hello world", 3.140000f32)
    obj1115069.synthesize_i14_1(depth - 1i64)
}

func gfunc_524267(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1157676: Bool = true
    gfunc_524268(depth - 1i64)
    gfunc_524274(depth - 1i64)
    gfunc_524272(depth - 1i64)
    gfunc_524274(depth - 1i64)
    gfunc_524395(depth - 1i64)
}

func gfunc_524268(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524274(depth - 1i64)
    gfunc_524266(depth - 1i64)
    gfunc_524403(depth - 1i64)
    gfunc_524395(depth - 1i64)
    gfunc_524363(depth - 1i64)
    gfunc_524396(depth - 1i64)
    let obj7948116 = Clazz_699492()
    obj7948116.evaluate_i4_1(depth - 1i64)
    let obj867771 = Clazz_699508()
    obj867771.process_i3_3(depth - 1i64)
    let obj87119107 = Clazz_699498()
    obj87119107.calculate_i1_10(depth - 1i64)
    obj867771.buildResult_i3_6(depth - 1i64)
    obj867771.query_i14_3(depth - 1i64)
    let obj11610851 = Clazz_699487(true)
    obj11610851.handleEvent_i1_4(depth - 1i64)
    let obj1095589 = Clazz_699489("hello world", 3.140000f32)
    obj1095589.synthesize_i14_1(depth - 1i64)
}
