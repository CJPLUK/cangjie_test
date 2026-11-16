// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package app_1.com.bs

import pkg_macro_0.mfunc_920832
import pkg_macro_0.mfunc_920831
import app_1.com.bs.web.Clazz_699527
import pkg_lib_2.com.bs.infra.Clazz_699492
public import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.Clazz_699489

protected open class Clazz_699495 {
    protected Clazz_699495(public var f_O8_62401_606228: Int32, public let f_O8_62402_402495: Float32) {
    }
    public open func checkState_i11_0(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v818282: String = "hello world"
        let v106109100: Bool = false
        this.handleEvent_i11_9(depth - 1i64)
        let obj7911465 = Clazz_699498()
        obj7911465.calculate_i1_3(depth - 1i64)
        let obj799769 = Clazz_699492()
        obj799769.compare_i4_0(depth - 1i64)
        let obj10499107 = Clazz_699489("hello world", 3.140000f32)
        obj10499107.handleEvent_i3_7(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        return 42u8
    }

    public open func setValue_i11_2(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        this.checkState_i5_0(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        let obj66106108 = Clazz_699489("hello world", 3.140000f32)
        obj66106108.process_i3_3(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        obj66106108.query_i14_3(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        let obj6610876 = Clazz_699504()
        obj6610876.checkState_i5_6(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        obj6610876.calculate_i11_7(depth - 1i64)
        obj6610876.process_i11_6(depth - 1i64)
        obj66106108.finalize_i3_5(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        return 3.140000f32
    }

    @mfunc_920832[42i64]
    public open func validate_i11_3(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let obj1139948 = Clazz_699504()
        obj1139948.process_i11_8(depth - 1i64)
        let obj113115110 = Clazz_699489("hello world", 3.140000f32)
        obj113115110.buildResult_i3_6(depth - 1i64)
        obj1139948.handleEvent_i11_9(depth - 1i64)
        let obj8877112 = Clazz_699498()
        obj8877112.calculate_i1_1(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        obj1139948.checkState_i5_6(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        obj8877112.calculate_i1_1(depth - 1i64)
        obj113115110.convert_i14_2(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        obj113115110.process_i14_0(depth - 1i64)
        return 3.140000f32
    }

    public open func fetch_i11_4(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v1175250: Int64 = 114514i64
        let v1068484: Bool = true
        this.calculate_i11_7(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        let obj879049 = Clazz_699489("hello world", 3.140000f32)
        obj879049.checkState_i3_1(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.calculate_i11_5(depth - 1i64)
        let obj9768117 = Clazz_699504()
        obj9768117.setValue_i5_5(depth - 1i64)
        let obj11950109 = Clazz_699492()
        obj11950109.serialize_i12_1(depth - 1i64)
        let obj8374114 = Clazz_699498()
        obj8374114.fetch_i1_8(depth - 1i64)
        obj879049.finalize_i3_5(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        return 114514i64
    }

    public open func calculate_i11_5(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let v10712056: Float64 = 114.514000f64
        this.compute_i5_4(depth - 1i64)
        let obj1118977 = Clazz_699489("hello world", 3.140000f32)
        obj1118977.filter_i3_4(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        obj1118977.query_i14_4(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        this.process_i11_8(depth - 1i64)
        obj1118977.process_i3_3(depth - 1i64)
        obj1118977.convert_i14_2(depth - 1i64)
        obj1118977.handleEvent_i3_7(depth - 1i64)
        return 3.140000f32
    }

    public open func process_i11_6(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let v857066: String = "hello world"
        let v6911456: Float64 = 114.514000f64
        this.validate_i5_2(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        let obj9011273 = Clazz_699504()
        obj9011273.calculate_i11_7(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        obj9011273.calculate_i11_7(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        obj9011273.process_i11_8(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        let obj986990 = Clazz_699492()
        obj986990.fetch_i5_1(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.calculate_i11_5(depth - 1i64)
        this.calculate_i11_5(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        return 3.140000f32
    }

    public open func calculate_i11_7(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let v7990109: Int64 = 114514i64
        let v8710170: Bool = true
        let obj10410049 = Clazz_699492()
        obj10410049.getValue_i10_0(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        let obj854865 = Clazz_699498()
        obj854865.query_i8_3(depth - 1i64)
        this.calculate_i11_5(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        obj854865.transform_i8_0(depth - 1i64)
        let obj1035784 = Clazz_699504()
        obj1035784.process_i11_8(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        obj10410049.execute_i10_4(depth - 1i64)
        let obj120104122 = Clazz_699489("hello world", 3.140000f32)
        obj120104122.query_i14_3(depth - 1i64)
        obj10410049.transform_i12_3(depth - 1i64)
        obj120104122.checkState_i3_1(depth - 1i64)
        return 3.140000f32
    }

    public open func process_i11_8(depth: Int64): Int32 {
        if (depth <= 0i64) {
            return 42i32
        }
        let v8912150: String = "hello world"
        let v7453117: Bool = true
        this.f_O8_62402_402495
        this.validate_i11_3(depth - 1i64)
        let obj708269 = Clazz_699504()
        obj708269.validate_i5_2(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        obj708269.setValue_i5_5(depth - 1i64)
        obj708269.checkState_i5_6(depth - 1i64)
        let obj1106957 = Clazz_699492()
        obj1106957.execute_i10_4(depth - 1i64)
        let obj887999 = Clazz_699498()
        obj887999.calculate_i1_1(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        obj708269.process_i11_6(depth - 1i64)
        return 42i32
    }

    @mfunc_920831
    public open func handleEvent_i11_9(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v11566120: String = "hello world"
        this.f_O8_62401_606228
        this.checkState_i5_6(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        let obj734883 = Clazz_699498()
        obj734883.compare_i9_5(depth - 1i64)
        let obj120102119 = Clazz_699492()
        obj120102119.getValue_i10_0(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        let obj1005588 = Clazz_699504()
        obj1005588.process_i11_6(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        let obj11390110 = Clazz_699489("hello world", 3.140000f32)
        obj11390110.convert_i14_2(depth - 1i64)
        obj734883.calculate_i1_3(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        obj11390110.query_i14_3(depth - 1i64)
        obj120102119.serialize_i12_1(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        return Rune(82)
    }

    public open func checkState_i5_0(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        let v7349111: Float64 = 114.514000f64
        let v836856: Float64 = 114.514000f64
        this.validate_i5_2(depth - 1i64)
        let obj106117106 = Clazz_699492()
        obj106117106.convert_i14_2(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        let obj8511398 = Clazz_699504()
        obj8511398.process_i11_8(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.calculate_i11_5(depth - 1i64)
        let obj73116101 = Clazz_699489("hello world", 3.140000f32)
        obj73116101.synthesize_i14_1(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        return 42u16
    }

    public open func fetch_i5_1(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        this.f_O8_62401_606228
        let obj10811087 = Clazz_699498()
        obj10811087.transform_i8_0(depth - 1i64)
        obj10811087.compare_i9_5(depth - 1i64)
        obj10811087.calculate_i1_3(depth - 1i64)
        let obj80105108 = Clazz_699492()
        obj80105108.checkState_i4_2(depth - 1i64)
        obj10811087.calculate_i1_1(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        obj10811087.calculate_i1_1(depth - 1i64)
        obj80105108.analyze_i12_4(depth - 1i64)
        let obj11711054 = Clazz_699489("hello world", 3.140000f32)
        obj11711054.buildResult_i3_6(depth - 1i64)
        obj11711054.checkState_i3_1(depth - 1i64)
        obj80105108.execute_i12_0(depth - 1i64)
        return 42u16
    }

    public open func validate_i5_2(depth: Int64): String {
        if (depth <= 0i64) {
            return "hello world"
        }
        let v1047652: Bool = true
        this.calculate_i11_5(depth - 1i64)
        let obj1219068 = Clazz_699489("hello world", 3.140000f32)
        obj1219068.checkState_i3_1(depth - 1i64)
        this.process_i11_8(depth - 1i64)
        obj1219068.convert_i14_2(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        let obj707989 = Clazz_699492()
        obj707989.query_i14_4(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        obj707989.evaluate_i10_3(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        return "hello world"
    }

    public open func update_i5_3(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        this.handleEvent_i11_9(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        let obj71115104 = Clazz_699504()
        obj71115104.process_i11_8(depth - 1i64)
        this.handleEvent_i11_9(depth - 1i64)
        let obj8050115 = Clazz_699498()
        obj8050115.calculate_i1_10(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        obj71115104.process_i11_8(depth - 1i64)
        obj8050115.query_i8_3(depth - 1i64)
        obj8050115.fetch_i9_4(depth - 1i64)
        obj8050115.compare_i9_5(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        obj8050115.fetch_i1_8(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        let obj9710869 = Clazz_699492()
        obj9710869.compute_i10_6(depth - 1i64)
        return 114514i64
    }

    public open func compute_i5_4(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v10210386: Bool = false
        this.f_O8_62401_606228
        this.checkState_i5_6(depth - 1i64)
        let obj7611057 = Clazz_699504()
        obj7611057.compute_i5_4(depth - 1i64)
        let obj12066112 = Clazz_699489("hello world", 3.140000f32)
        obj12066112.process_i14_0(depth - 1i64)
        obj7611057.handleEvent_i11_9(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        this.validate_i11_3(depth - 1i64)
        this.process_i11_8(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.checkState_i11_0(depth - 1i64)
        obj7611057.setValue_i5_5(depth - 1i64)
        this.setValue_i11_2(depth - 1i64)
        let obj699750 = Clazz_699498()
        obj699750.fetch_i9_4(depth - 1i64)
        this.fetch_i11_4(depth - 1i64)
        obj7611057.calculate_i11_5(depth - 1i64)
        obj699750.compare_i9_5(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        return 114514i64
    }

    public open func setValue_i5_5(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v7299110: Bool = false
        let v6573110: Float64 = 114.514000f64
        this.validate_i11_3(depth - 1i64)
        this.process_i11_6(depth - 1i64)
        let obj11110082 = Clazz_699504()
        obj11110082.validate_i11_3(depth - 1i64)
        obj11110082.checkState_i5_6(depth - 1i64)
        let obj1077877 = Clazz_699498()
        obj1077877.resolve_i1_7(depth - 1i64)
        obj1077877.query_i9_2(depth - 1i64)
        obj1077877.query_i9_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        obj1077877.resolve_i1_7(depth - 1i64)
        return 42u64
    }

    public open func checkState_i5_6(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let v757968: Float64 = 114.514000f64
        let obj894887 = Clazz_699498()
        obj894887.fetch_i1_8(depth - 1i64)
        obj894887.update_i8_2(depth - 1i64)
        let obj1047887 = Clazz_699504()
        obj1047887.fetch_i5_1(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.calculate_i11_7(depth - 1i64)
        let obj11481118 = Clazz_699489("hello world", 3.140000f32)
        obj11481118.synthesize_i14_1(depth - 1i64)
        obj894887.calculate_i1_1(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        return Rune(82)
    }
}

internal func gfunc_524284(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v887270: Float64 = 114.514000f64
    let obj66107122 = Clazz_699498()
    obj66107122.query_i9_2(depth - 1i64)
}
