// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.model

import pkg_macro_1.mfunc_920836
import package_fuzz.com.bs.core.Clazz_699508
import package_fuzz.com.bs.impl.Clazz_699517
import package_fuzz.com.bs.infra.model.Clazz_699500
import package_fuzz.com.bs.infra.model.config.Clazz_699487
public import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_2.com.bs.infra.Clazz_699492
import package_fuzz.com.bs.impl.gfunc_524277
import pkg_lib_2.com.bs.infra.gfunc_524358
import pkg_lib_2.com.bs.infra.gfunc_524359

@mfunc_920836
internal class Clazz_699515 {
    Clazz_699515() {
    }
    public func filter_i2_0(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v11073121: String = "hello world"
        let v71106110: Int64 = 114514i64
        this.checkState_i5_0(depth - 1i64)
        let obj747277 = Clazz_699489("hello world", 3.140000f32)
        obj747277.process_i14_0(depth - 1i64)
        obj747277.finalize_i3_5(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.serialize_i1_9(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        let obj7950107 = Clazz_699492()
        obj7950107.compute_i10_6(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        return 42u8
    }

    public func analyze_i2_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v11710797: Float64 = 114.514000f64
        let v11711686: Float64 = 114.514000f64
        let obj7010588 = Clazz_699492()
        obj7010588.analyze_i12_4(depth - 1i64)
        let obj1047155 = Clazz_699504()
        obj1047155.handleEvent_i11_9(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        obj1047155.validate_i11_3(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        let obj836673 = Clazz_699498()
        obj836673.resolve_i1_7(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        obj836673.update_i8_2(depth - 1i64)
        obj7010588.checkState_i4_2(depth - 1i64)
        obj836673.fetch_i1_8(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        return 42u8
    }

    public open func update_i2_2(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        this.checkState_i5_6(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        this.calculate_i1_1(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        let obj112118120 = Clazz_699498()
        obj112118120.calculate_i1_1(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        obj112118120.calculate_i1_10(depth - 1i64)
        obj112118120.calculate_i1_3(depth - 1i64)
        return 114514i64
    }

    public func serialize_i2_3(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v7748121: Bool = false
        let v12210887: String = "hello world"
        let obj1218671 = Clazz_699489("hello world", 3.140000f32)
        obj1218671.convert_i14_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        let obj798167 = Clazz_699517()
        obj798167.serialize_i2_3(depth - 1i64)
        obj1218671.process_i3_3(depth - 1i64)
        let obj73115103 = Clazz_699498()
        obj73115103.update_i8_2(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        obj73115103.calculate_i1_1(depth - 1i64)
        obj798167.serialize_i2_3(depth - 1i64)
        obj798167.update_i2_2(depth - 1i64)
        obj73115103.resolve_i1_7(depth - 1i64)
        let obj7465121 = Clazz_699492()
        obj7465121.fetch_i5_1(depth - 1i64)
        obj1218671.convert_i14_2(depth - 1i64)
        let obj10311282 = Clazz_699504()
        obj10311282.compute_i5_4(depth - 1i64)
        obj798167.filter_i2_0(depth - 1i64)
        obj10311282.compute_i5_4(depth - 1i64)
        return 42u8
    }

    public func buildResult_i2_4(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        this.update_i2_2(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        let obj115118104 = Clazz_699487(true)
        obj115118104.analyze_i9_3(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        let obj8056116 = Clazz_699489("hello world", 3.140000f32)
        obj8056116.synthesize_i14_1(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        obj8056116.process_i14_0(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        let obj7810479 = Clazz_699498()
        obj7810479.calculate_i1_10(depth - 1i64)
        let obj12211698 = Clazz_699492()
        obj12211698.process_i14_0(depth - 1i64)
        obj12211698.checkState_i4_2(depth - 1i64)
        obj7810479.transform_i8_0(depth - 1i64)
        let obj12211587 = Clazz_699517()
        obj12211587.filter_i2_0(depth - 1i64)
        return 42u8
    }

    public func calculate_i2_5(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v8190103: Bool = false
        let obj1009098 = Clazz_699508()
        obj1009098.process_i3_3(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        let obj7011886 = Clazz_699504()
        obj7011886.process_i11_6(depth - 1i64)
        let obj11750112 = Clazz_699487(false)
        obj11750112.validate_i1_5(depth - 1i64)
        obj11750112.query_i9_2(depth - 1i64)
        obj11750112.calculate_i1_3(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        obj7011886.calculate_i11_5(depth - 1i64)
        return Rune(82)
    }

    public func update_i2_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        this.serialize_i2_3(depth - 1i64)
        let obj1075654 = Clazz_699504()
        obj1075654.setValue_i5_5(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj8080100 = Clazz_699489("hello world", 3.140000f32)
        obj8080100.handleEvent_i3_7(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        return false
    }

    public func checkState_i5_0(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        let v11880113: Int64 = 114514i64
        let v12110952: String = "hello world"
        this.handleEvent_i1_4(depth - 1i64)
        let obj727288 = Clazz_699487(true)
        obj727288.compare_i9_5(depth - 1i64)
        let obj825081 = Clazz_699492()
        obj825081.process_i14_0(depth - 1i64)
        let obj7065104 = Clazz_699489("hello world", 3.140000f32)
        obj7065104.buildResult_i3_6(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        let obj7866122 = Clazz_699504()
        obj7866122.compute_i5_4(depth - 1i64)
        obj7866122.process_i11_6(depth - 1i64)
        return 42u16
    }

    public func fetch_i5_1(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        this.calculate_i1_10(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        let obj105115101 = Clazz_699489("hello world", 3.140000f32)
        obj105115101.buildResult_i3_6(depth - 1i64)
        let obj9012171 = Clazz_699498()
        obj9012171.query_i9_2(depth - 1i64)
        obj9012171.query_i9_2(depth - 1i64)
        let obj102115109 = Clazz_699487(true)
        obj102115109.resolve_i1_7(depth - 1i64)
        obj9012171.calculate_i1_10(depth - 1i64)
        return 42u16
    }

    public func validate_i5_2(depth: Int64): String {
        if (depth <= 0i64) {
            return "hello world"
        }
        let v7066114: Bool = true
        let v88104107: Int64 = 114514i64
        this.update_i2_2(depth - 1i64)
        let obj12280114 = Clazz_699498()
        obj12280114.update_i8_2(depth - 1i64)
        let obj1146976 = Clazz_699487(false)
        obj1146976.transform_i8_0(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
        let obj835178 = Clazz_699492()
        obj835178.update_i5_3(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        let obj11610467 = Clazz_699504()
        obj11610467.calculate_i11_5(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        obj835178.process_i14_0(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.handleEvent_i1_4(depth - 1i64)
        obj1146976.calculate_i9_7(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        let obj7310453 = Clazz_699489("hello world", 3.140000f32)
        obj7310453.checkState_i3_1(depth - 1i64)
        return "hello world"
    }

    public func update_i5_3(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let obj809950 = Clazz_699504()
        obj809950.update_i5_3(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        let obj9711468 = Clazz_699492()
        obj9711468.update_i5_3(depth - 1i64)
        let obj1125055 = Clazz_699498()
        obj1125055.calculate_i1_1(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        obj1125055.update_i8_2(depth - 1i64)
        let obj7710285 = Clazz_699489("hello world", 3.140000f32)
        obj7710285.finalize_i3_5(depth - 1i64)
        let obj7910167 = Clazz_699517()
        obj7910167.update_i2_2(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        return 114514i64
    }

    public func compute_i5_4(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v7510871: Float64 = 114.514000f64
        let v688284: Float64 = 114.514000f64
        this.checkState_i5_0(depth - 1i64)
        let obj1127387 = Clazz_699489("hello world", 3.140000f32)
        obj1127387.synthesize_i14_1(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        let obj678650 = Clazz_699504()
        obj678650.validate_i5_2(depth - 1i64)
        return 114514i64
    }

    public func setValue_i5_5(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v8086118: Int64 = 114514i64
        let obj8187121 = Clazz_699498()
        obj8187121.query_i9_2(depth - 1i64)
        let obj1085070 = Clazz_699508()
        obj1085070.query_i14_3(depth - 1i64)
        let obj1128977 = Clazz_699517()
        obj1128977.update_i2_2(depth - 1i64)
        obj8187121.compare_i9_5(depth - 1i64)
        let obj667053 = Clazz_699489("hello world", 3.140000f32)
        obj667053.synthesize_i14_1(depth - 1i64)
        obj1085070.query_i14_4(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        obj667053.process_i14_0(depth - 1i64)
        obj667053.finalize_i3_5(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj10711885 = Clazz_699504()
        obj10711885.validate_i11_3(depth - 1i64)
        obj1085070.query_i14_4(depth - 1i64)
        obj8187121.query_i9_2(depth - 1i64)
        return 42u64
    }

    @mfunc_920836
    public func checkState_i5_6(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v788686: Bool = true
        let v765249: Float64 = 114.514000f64
        this.validate_i1_5(depth - 1i64)
        this.serialize_i1_9(depth - 1i64)
        let obj10548110 = Clazz_699498()
        obj10548110.transform_i8_0(depth - 1i64)
        this.calculate_i1_1(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        let obj707750 = Clazz_699487(true)
        obj707750.calculate_i1_1(depth - 1i64)
        let obj676790 = Clazz_699489("hello world", 3.140000f32)
        obj676790.process_i3_3(depth - 1i64)
        return Rune(82)
    }

    public func calculate_i1_1(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        let v1086974: Bool = true
        Clazz_699489.create_O2(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        let obj697768 = Clazz_699489("hello world", 3.140000f32)
        obj697768.process_i14_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        let obj6668111 = Clazz_699517()
        obj6668111.update_i2_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        let obj12211365 = Clazz_699492()
        obj12211365.validate_i5_2(depth - 1i64)
        let obj1069073 = Clazz_699498()
        obj1069073.calculate_i1_1(depth - 1i64)
        return 42u16
    }

    public func calculate_i1_3(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v1018666: Float64 = 114.514000f64
        let obj1118074 = Clazz_699504()
        obj1118074.handleEvent_i11_9(depth - 1i64)
        obj1118074.fetch_i5_1(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        let obj818268 = Clazz_699498()
        obj818268.calculate_i1_3(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        let obj74122110 = Clazz_699489("hello world", 3.140000f32)
        obj74122110.process_i3_3(depth - 1i64)
        obj74122110.finalize_i3_5(depth - 1i64)
        this.serialize_i1_9(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.calculate_i1_1(depth - 1i64)
        let obj6599119 = Clazz_699492()
        obj6599119.update_i5_3(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        return 42u64
    }

    public func handleEvent_i1_4(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let obj819798 = Clazz_699489("hello world", 3.140000f32)
        obj819798.buildResult_i3_6(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.fetch_i1_8(depth - 1i64)
        let obj1199076 = Clazz_699504()
        obj1199076.process_i11_8(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        obj819798.filter_i3_4(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        let obj785286 = Clazz_699498()
        obj785286.calculate_i1_1(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        let obj6611182 = Clazz_699508()
        obj6611182.checkState_i3_1(depth - 1i64)
        let obj995074 = Clazz_699492()
        obj995074.getValue_i10_0(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        return 42u64
    }

    public func validate_i1_5(depth: Int64): Bool {
        if (depth <= 0i64) {
            return true
        }
        let v104108101: Float64 = 114.514000f64
        this.buildResult_i2_4(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        let obj728074 = Clazz_699504()
        obj728074.validate_i11_3(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj9010084 = Clazz_699508()
        obj9010084.handleEvent_i3_7(depth - 1i64)
        obj9010084.query_i14_3(depth - 1i64)
        obj728074.checkState_i5_6(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        obj728074.handleEvent_i11_9(depth - 1i64)
        return true
    }

    public func resolve_i1_7(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v789083: Int64 = 114514i64
        let v69116116: Float64 = 114.514000f64
        let obj7353110 = Clazz_699489("hello world", 3.140000f32)
        obj7353110.buildResult_i3_6(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj715668 = Clazz_699492()
        obj715668.evaluate_i10_3(depth - 1i64)
        let obj11188114 = Clazz_699508()
        obj11188114.handleEvent_i3_7(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        let obj798674 = Clazz_699487(true)
        obj798674.fetch_i9_4(depth - 1i64)
        this.serialize_i1_9(depth - 1i64)
        obj715668.setValue_i5_5(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.serialize_i1_9(depth - 1i64)
        let obj1096887 = Clazz_699517()
        obj1096887.filter_i2_0(depth - 1i64)
        let obj100112100 = Clazz_699498()
        obj100112100.calculate_i1_1(depth - 1i64)
        obj715668.filter_i10_2(depth - 1i64)
        obj7353110.filter_i3_4(depth - 1i64)
        obj7353110.query_i14_4(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.validate_i1_5(depth - 1i64)
        obj798674.update_i8_2(depth - 1i64)
        return 42u64
    }

    public func fetch_i1_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return true
        }
        let v90114100: Int64 = 114514i64
        let obj1137853 = Clazz_699492()
        obj1137853.checkState_i5_6(depth - 1i64)
        let obj10750104 = Clazz_699487(true)
        obj10750104.calculate_i9_7(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        let obj10979119 = Clazz_699489("hello world", 3.140000f32)
        obj10979119.process_i14_0(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.calculate_i1_10(depth - 1i64)
        obj1137853.setValue_i5_5(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        let obj9977100 = Clazz_699498()
        obj9977100.calculate_i1_1(depth - 1i64)
        let obj7665115 = Clazz_699504()
        obj7665115.setValue_i5_5(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        obj9977100.calculate_i1_3(depth - 1i64)
        return true
    }

    public func serialize_i1_9(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v8877122: Int64 = 114514i64
        let v11711557: Float64 = 114.514000f64
        let obj1044978 = Clazz_699504()
        obj1044978.process_i11_6(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        obj1044978.calculate_i11_5(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        let obj835369 = Clazz_699508()
        obj835369.query_i14_4(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        let obj1115584 = Clazz_699489("hello world", 3.140000f32)
        obj1115584.convert_i14_2(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        obj1115584.finalize_i3_5(depth - 1i64)
        obj1044978.calculate_i11_5(depth - 1i64)
        obj1044978.validate_i5_2(depth - 1i64)
        return 42u64
    }

    public func calculate_i1_10(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        this.calculate_i1_1(depth - 1i64)
        let obj1025352 = Clazz_699492()
        obj1025352.fetch_i5_1(depth - 1i64)
        let obj865785 = Clazz_699489("hello world", 3.140000f32)
        obj865785.filter_i3_4(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.calculate_i1_3(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        obj865785.convert_i14_2(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        let obj10711553 = Clazz_699517()
        obj10711553.update_i2_2(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        let obj8982102 = Clazz_699504()
        obj8982102.compute_i5_4(depth - 1i64)
        return Rune(82)
    }
}

public func gfunc_524275(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8610679: Int64 = 114514i64
    let v765351: Float64 = 114.514000f64
    gfunc_524277(depth - 1i64)
    gfunc_524358(depth - 1i64)
    gfunc_524359(depth - 1i64)
    gfunc_524358(depth - 1i64)
    let obj86117110 = Clazz_699492()
    obj86117110.merge_i10_1(depth - 1i64)
}
