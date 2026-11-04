// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_lib_2.com.bs.infra

import pkg_macro_0.mfunc_920832
import pkg_macro_1.mfunc_920835
import pkg_lib_2.com.bs.impl.Clazz_699503
import pkg_lib_3.com.bs.infra.Clazz_699489
internal import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699489

@mfunc_920832["v"]
public open class Clazz_699492 {
    public Clazz_699492() {
    }
    public open func process_i14_0(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v7087120: String = "hello world"
        this.compute_i10_6(depth - 1i64)
        let obj105102107 = Clazz_699503()
        obj105102107.handleEvent_i11_9(depth - 1i64)
        let obj6690117 = Clazz_699498()
        obj6690117.update_i8_2(depth - 1i64)
        let obj11375110 = Clazz_699504()
        obj11375110.handleEvent_i11_9(depth - 1i64)
        this.compare_i4_0(depth - 1i64)
        obj11375110.fetch_i5_1(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        obj6690117.calculate_i1_3(depth - 1i64)
        return 114514i64
    }

    public open func synthesize_i14_1(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        this.transform_i12_3(depth - 1i64)
        this.filter_i10_8(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        let obj10984105 = Clazz_699503()
        obj10984105.validate_i5_2(depth - 1i64)
        let obj1094855 = Clazz_699498()
        obj1094855.resolve_i1_7(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        let obj1129073 = Clazz_699504()
        obj1129073.process_i11_6(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        obj1094855.calculate_i1_3(depth - 1i64)
        let obj705197 = Clazz_699489("hello world", 3.140000f32)
        obj705197.process_i14_0(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        obj1094855.compare_i9_5(depth - 1i64)
        obj1129073.calculate_i11_5(depth - 1i64)
        obj1094855.resolve_i1_7(depth - 1i64)
        obj10984105.process_i11_6(depth - 1i64)
    }

    public open func convert_i14_2(depth: Int64): Int16 {
        if (depth <= 0i64) {
            return 42i16
        }
        let v1127768: Float64 = 114.514000f64
        let v74107117: Int64 = 114514i64
        this.execute_i10_4(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        return 42i16
    }

    public open func query_i14_3(depth: Int64): Bool {
        if (depth <= 0i64) {
            return true
        }
        let v11656116: Int64 = 114514i64
        let v108113108: String = "hello world"
        this.merge_i10_1(depth - 1i64)
        let obj7869120 = Clazz_699504()
        obj7869120.validate_i11_3(depth - 1i64)
        this.process_i14_0(depth - 1i64)
        let obj11211079 = Clazz_699489("hello world", 3.140000f32)
        obj11211079.filter_i3_4(depth - 1i64)
        obj11211079.finalize_i3_5(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.compare_i4_0(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        let obj1035698 = Clazz_699503()
        obj1035698.validate_i11_3(depth - 1i64)
        obj11211079.synthesize_i14_1(depth - 1i64)
        return true
    }

    public open func query_i14_4(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        let obj10410771 = Clazz_699489("hello world", 3.140000f32)
        obj10410771.process_i3_3(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        let obj855665 = Clazz_699498()
        obj855665.calculate_i1_1(depth - 1i64)
        obj855665.compare_i9_5(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        this.transform_i12_3(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        return Rune(82)
    }

    public open func getValue_i10_0(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        let v8510950: String = "hello world"
        let v11985109: Int64 = 114514i64
        this.filter_i10_2(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        this.compute_i10_6(depth - 1i64)
        let obj80113112 = Clazz_699498()
        obj80113112.fetch_i9_4(depth - 1i64)
        this.compare_i4_0(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        obj80113112.calculate_i1_10(depth - 1i64)
        let obj837772 = Clazz_699504()
        obj837772.compute_i5_4(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        obj837772.checkState_i5_6(depth - 1i64)
        this.execute_i12_0(depth - 1i64)
        obj80113112.resolve_i1_7(depth - 1i64)
        let obj112117104 = Clazz_699503()
        obj112117104.validate_i11_3(depth - 1i64)
        return false
    }

    public open func merge_i10_1(depth: Int64): UInt32 {
        if (depth <= 0i64) {
            return 42u32
        }
        let obj10811681 = Clazz_699504()
        obj10811681.compute_i5_4(depth - 1i64)
        let obj1128884 = Clazz_699503()
        obj1128884.validate_i5_2(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        this.filter_i10_8(depth - 1i64)
        obj1128884.handleEvent_i11_9(depth - 1i64)
        return 42u32
    }

    public open func filter_i10_2(depth: Int64): UInt32 {
        if (depth <= 0i64) {
            return 42u32
        }
        let v867986: Float64 = 114.514000f64
        let v8186100: String = "hello world"
        let obj794868 = Clazz_699503()
        obj794868.handleEvent_i11_9(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        let obj102105100 = Clazz_699504()
        obj102105100.update_i5_3(depth - 1i64)
        let obj12074107 = Clazz_699498()
        obj12074107.transform_i8_0(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        let obj12287103 = Clazz_699489("hello world", 3.140000f32)
        obj12287103.finalize_i3_5(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        return 42u32
    }

    public open func evaluate_i10_3(depth: Int64): UInt32 {
        if (depth <= 0i64) {
            return 42u32
        }
        let v837377: String = "hello world"
        let v728773: Bool = false
        this.initialize_i10_5(depth - 1i64)
        this.filter_i10_2(depth - 1i64)
        let obj864866 = Clazz_699504()
        obj864866.calculate_i11_5(depth - 1i64)
        let obj1046773 = Clazz_699489("hello world", 3.140000f32)
        obj1046773.query_i14_3(depth - 1i64)
        obj1046773.filter_i3_4(depth - 1i64)
        let obj656978 = Clazz_699498()
        obj656978.query_i9_2(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.filter_i10_2(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        this.merge_i10_1(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        obj864866.calculate_i11_5(depth - 1i64)
        obj864866.calculate_i11_5(depth - 1i64)
        this.transform_i12_3(depth - 1i64)
        return 42u32
    }

    public open func execute_i10_4(depth: Int64): UInt32 {
        if (depth <= 0i64) {
            return 42u32
        }
        let v6612098: String = "hello world"
        let v8310268: String = "hello world"
        this.checkState_i5_0(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        let obj1044865 = Clazz_699504()
        obj1044865.update_i5_3(depth - 1i64)
        let obj898687 = Clazz_699498()
        obj898687.query_i9_2(depth - 1i64)
        this.filter_i10_8(depth - 1i64)
        obj898687.fetch_i1_8(depth - 1i64)
        return 42u32
    }

    public open func initialize_i10_5(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        let v1137290: Int64 = 114514i64
        this.execute_i12_0(depth - 1i64)
        let obj1154856 = Clazz_699498()
        obj1154856.fetch_i9_4(depth - 1i64)
        this.evaluate_i10_3(depth - 1i64)
        let obj8548111 = Clazz_699504()
        obj8548111.validate_i11_3(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        let obj7811386 = Clazz_699489("hello world", 3.140000f32)
        obj7811386.query_i14_3(depth - 1i64)
        this.transform_i12_3(depth - 1i64)
        return true
    }

    public open func compute_i10_6(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        let obj72104106 = Clazz_699489("hello world", 3.140000f32)
        obj72104106.convert_i14_2(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        let obj1079774 = Clazz_699504()
        obj1079774.handleEvent_i11_9(depth - 1i64)
        this.filter_i10_2(depth - 1i64)
        return false
    }

    public open func filter_i10_8(depth: Int64): Bool {
        if (depth <= 0i64) {
            return false
        }
        let v1128457: Float64 = 114.514000f64
        this.checkState_i5_6(depth - 1i64)
        let obj8011278 = Clazz_699504()
        obj8011278.process_i11_6(depth - 1i64)
        obj8011278.compute_i5_4(depth - 1i64)
        let obj9011978 = Clazz_699489("hello world", 3.140000f32)
        obj9011978.query_i14_3(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        let obj8911756 = Clazz_699498()
        obj8911756.calculate_i1_3(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        obj9011978.convert_i14_2(depth - 1i64)
        obj9011978.process_i3_3(depth - 1i64)
        obj8011278.update_i5_3(depth - 1i64)
        obj9011978.handleEvent_i3_7(depth - 1i64)
        this.merge_i10_1(depth - 1i64)
        this.process_i14_0(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        obj8911756.query_i8_3(depth - 1i64)
        this.filter_i10_2(depth - 1i64)
        obj8011278.setValue_i5_5(depth - 1i64)
        return true
    }

    public open func analyze_i10_9(depth: Int64): UInt32 {
        if (depth <= 0i64) {
            return 42u32
        }
        let obj8252112 = Clazz_699489("hello world", 3.140000f32)
        obj8252112.process_i3_3(depth - 1i64)
        let obj76115108 = Clazz_699504()
        obj76115108.validate_i5_2(depth - 1i64)
        obj76115108.process_i11_6(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        let obj88117104 = Clazz_699498()
        obj88117104.calculate_i1_3(depth - 1i64)
        obj76115108.compute_i5_4(depth - 1i64)
        obj76115108.calculate_i11_7(depth - 1i64)
        obj88117104.fetch_i9_4(depth - 1i64)
        obj8252112.buildResult_i3_6(depth - 1i64)
        obj76115108.update_i5_3(depth - 1i64)
        return 42u32
    }

    public open func execute_i12_0(depth: Int64): String {
        if (depth <= 0i64) {
            return "hello world"
        }
        this.checkState_i4_2(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        let obj11170113 = Clazz_699489("hello world", 3.140000f32)
        obj11170113.query_i14_3(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        obj11170113.finalize_i3_5(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        let obj717088 = Clazz_699498()
        obj717088.query_i9_2(depth - 1i64)
        return "hello world"
    }

    public open func serialize_i12_1(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v10680105: Bool = true
        let obj108105122 = Clazz_699498()
        obj108105122.resolve_i1_7(depth - 1i64)
        let obj7597111 = Clazz_699489("hello world", 3.140000f32)
        obj7597111.process_i3_3(depth - 1i64)
        let obj10081119 = Clazz_699504()
        obj10081119.validate_i5_2(depth - 1i64)
        obj108105122.calculate_i1_3(depth - 1i64)
        this.filter_i10_8(depth - 1i64)
        obj10081119.process_i11_8(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        obj10081119.compute_i5_4(depth - 1i64)
        this.evaluate_i4_1(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        return 42u8
    }

    public open func transform_i12_3(depth: Int64): Float32 {
        if (depth <= 0i64) {
            return 3.140000f32
        }
        let v8888108: Float64 = 114.514000f64
        let v1054976: String = "hello world"
        let obj837798 = Clazz_699504()
        obj837798.setValue_i5_5(depth - 1i64)
        obj837798.compute_i5_4(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        let obj7911390 = Clazz_699503()
        obj7911390.checkState_i5_0(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        obj837798.process_i11_8(depth - 1i64)
        let obj1077897 = Clazz_699489("hello world", 3.140000f32)
        obj1077897.process_i3_3(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.process_i14_0(depth - 1i64)
        this.evaluate_i4_1(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        obj1077897.convert_i14_2(depth - 1i64)
        this.analyze_i12_4(depth - 1i64)
        this.process_i14_0(depth - 1i64)
        return 3.140000f32
    }

    public open func analyze_i12_4(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v1137973: Float64 = 114.514000f64
        this.initialize_i10_5(depth - 1i64)
        this.transform_i12_3(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        this.validate_i5_2(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        this.filter_i10_8(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        this.evaluate_i10_3(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        let obj988080 = Clazz_699504()
        obj988080.fetch_i5_1(depth - 1i64)
        let obj7871100 = Clazz_699498()
        obj7871100.transform_i8_0(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        obj7871100.calculate_i1_10(depth - 1i64)
        let obj101111107 = Clazz_699489("hello world", 3.140000f32)
        obj101111107.query_i14_3(depth - 1i64)
    }

    public open func compare_i4_0(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v70104121: Int64 = 114514i64
        let v11980104: Bool = false
        let obj6811254 = Clazz_699504()
        obj6811254.validate_i5_2(depth - 1i64)
        let obj1047975 = Clazz_699498()
        obj1047975.query_i9_2(depth - 1i64)
        obj1047975.fetch_i9_4(depth - 1i64)
        obj6811254.checkState_i5_6(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        obj6811254.update_i5_3(depth - 1i64)
        this.execute_i12_0(depth - 1i64)
        let obj1188368 = Clazz_699489("hello world", 3.140000f32)
        obj1188368.filter_i3_4(depth - 1i64)
        obj6811254.compute_i5_4(depth - 1i64)
        obj1047975.transform_i8_0(depth - 1i64)
        obj6811254.process_i11_6(depth - 1i64)
        obj6811254.checkState_i5_6(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        obj1188368.query_i14_3(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        return 42u64
    }

    public open func evaluate_i4_1(depth: Int64): Int16 {
        if (depth <= 0i64) {
            return 42i16
        }
        let v75115115: Bool = false
        let v6811866: Int64 = 114514i64
        this.synthesize_i14_1(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        let obj1197398 = Clazz_699504()
        obj1197398.setValue_i5_5(depth - 1i64)
        let obj10910777 = Clazz_699498()
        obj10910777.calculate_i1_10(depth - 1i64)
        obj1197398.process_i11_8(depth - 1i64)
        let obj769790 = Clazz_699489("hello world", 3.140000f32)
        obj769790.query_i14_3(depth - 1i64)
        return 42i16
    }

    public open func checkState_i4_2(depth: Int64): Int32 {
        if (depth <= 0i64) {
            return 42i32
        }
        let v11710051: Float64 = 114.514000f64
        let v81120114: String = "hello world"
        this.filter_i10_8(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        let obj11510975 = Clazz_699503()
        obj11510975.validate_i11_3(depth - 1i64)
        let obj11011778 = Clazz_699504()
        obj11011778.process_i11_8(depth - 1i64)
        let obj7210752 = Clazz_699498()
        obj7210752.fetch_i1_8(depth - 1i64)
        let obj898369 = Clazz_699489("hello world", 3.140000f32)
        obj898369.convert_i14_2(depth - 1i64)
        obj7210752.calculate_i1_3(depth - 1i64)
        obj11510975.checkState_i5_0(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.compare_i4_0(depth - 1i64)
        obj898369.process_i3_3(depth - 1i64)
        obj7210752.calculate_i1_10(depth - 1i64)
        obj11510975.handleEvent_i11_9(depth - 1i64)
        this.fetch_i5_1(depth - 1i64)
        this.synthesize_i14_1(depth - 1i64)
        this.compare_i4_0(depth - 1i64)
        this.serialize_i12_1(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        return 42i32
    }

    public open func checkState_i5_0(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        let obj12212167 = Clazz_699498()
        obj12212167.calculate_i1_10(depth - 1i64)
        let obj1087265 = Clazz_699489("hello world", 3.140000f32)
        obj1087265.process_i14_0(depth - 1i64)
        this.merge_i10_1(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.compute_i10_6(depth - 1i64)
        this.analyze_i10_9(depth - 1i64)
        obj12212167.resolve_i1_7(depth - 1i64)
        let obj1219756 = Clazz_699503()
        obj1219756.calculate_i11_5(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        obj1219756.update_i5_3(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        obj1219756.update_i5_3(depth - 1i64)
        let obj10710669 = Clazz_699504()
        obj10710669.validate_i5_2(depth - 1i64)
        obj10710669.compute_i5_4(depth - 1i64)
        obj10710669.checkState_i5_6(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        obj12212167.compare_i9_5(depth - 1i64)
        return 42u16
    }

    public open func fetch_i5_1(depth: Int64): UInt16 {
        if (depth <= 0i64) {
            return 42u16
        }
        let obj737979 = Clazz_699498()
        obj737979.calculate_i1_3(depth - 1i64)
        let obj8110585 = Clazz_699503()
        obj8110585.handleEvent_i11_9(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        this.convert_i14_2(depth - 1i64)
        this.compute_i5_4(depth - 1i64)
        let obj8499120 = Clazz_699489("hello world", 3.140000f32)
        obj8499120.query_i14_3(depth - 1i64)
        this.evaluate_i4_1(depth - 1i64)
        Clazz_699489.create_O2(depth - 1i64)
        obj8110585.checkState_i11_0(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        return 42u16
    }

    public open func validate_i5_2(depth: Int64): String {
        if (depth <= 0i64) {
            return "hello world"
        }
        let v885366: Int64 = 114514i64
        let obj74101113 = Clazz_699503()
        obj74101113.checkState_i11_0(depth - 1i64)
        this.serialize_i12_1(depth - 1i64)
        this.execute_i12_0(depth - 1i64)
        this.query_i14_3(depth - 1i64)
        this.getValue_i10_0(depth - 1i64)
        this.evaluate_i10_3(depth - 1i64)
        let obj7250117 = Clazz_699504()
        obj7250117.handleEvent_i11_9(depth - 1i64)
        this.merge_i10_1(depth - 1i64)
        return "hello world"
    }

    public open func update_i5_3(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v1029897: Bool = true
        let v73118102: Float64 = 114.514000f64
        let obj7810999 = Clazz_699489("hello world", 3.140000f32)
        obj7810999.finalize_i3_5(depth - 1i64)
        obj7810999.query_i14_4(depth - 1i64)
        let obj117116110 = Clazz_699503()
        obj117116110.process_i11_6(depth - 1i64)
        this.analyze_i12_4(depth - 1i64)
        this.checkState_i5_6(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        obj117116110.validate_i11_3(depth - 1i64)
        let obj11167105 = Clazz_699504()
        obj11167105.validate_i11_3(depth - 1i64)
        let obj99100116 = Clazz_699498()
        obj99100116.calculate_i1_10(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.filter_i10_2(depth - 1i64)
        obj7810999.handleEvent_i3_7(depth - 1i64)
        return 114514i64
    }

    public open func compute_i5_4(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v1225755: Bool = true
        this.synthesize_i14_1(depth - 1i64)
        let obj9810171 = Clazz_699498()
        obj9810171.query_i9_2(depth - 1i64)
        obj9810171.fetch_i9_4(depth - 1i64)
        let obj895175 = Clazz_699503()
        obj895175.checkState_i5_0(depth - 1i64)
        let obj668990 = Clazz_699489("hello world", 3.140000f32)
        obj668990.query_i14_3(depth - 1i64)
        this.checkState_i4_2(depth - 1i64)
        return 114514i64
    }

    @mfunc_920835["v"]
    public open func setValue_i5_5(depth: Int64): UInt64 {
        if (depth <= 0i64) {
            return 42u64
        }
        let v8049108: String = "hello world"
        this.compute_i5_4(depth - 1i64)
        this.initialize_i10_5(depth - 1i64)
        this.transform_i12_3(depth - 1i64)
        let obj6710753 = Clazz_699503()
        obj6710753.checkState_i5_0(depth - 1i64)
        let obj71103122 = Clazz_699489("hello world", 3.140000f32)
        obj71103122.filter_i3_4(depth - 1i64)
        this.execute_i10_4(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        return 42u64
    }

    public open func checkState_i5_6(depth: Int64): Rune {
        if (depth <= 0i64) {
            return Rune(82)
        }
        this.merge_i10_1(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        this.evaluate_i4_1(depth - 1i64)
        let obj1056781 = Clazz_699504()
        obj1056781.checkState_i5_6(depth - 1i64)
        obj1056781.fetch_i5_1(depth - 1i64)
        let obj844867 = Clazz_699503()
        obj844867.calculate_i11_5(depth - 1i64)
        obj1056781.validate_i11_3(depth - 1i64)
        let obj1045157 = Clazz_699489("hello world", 3.140000f32)
        obj1045157.handleEvent_i3_7(depth - 1i64)
        let obj11410854 = Clazz_699498()
        obj11410854.query_i9_2(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.evaluate_i10_3(depth - 1i64)
        this.checkState_i5_0(depth - 1i64)
        this.query_i14_4(depth - 1i64)
        this.update_i5_3(depth - 1i64)
        return Rune(82)
    }
}

@mfunc_920835[cfg]
public func gfunc_524358(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

public func gfunc_524359(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let obj11312199 = Clazz_699504()
    obj11312199.process_i11_6(depth - 1i64)
    let obj66116120 = Clazz_699492()
    obj66116120.serialize_i12_1(depth - 1i64)
}
