// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz

import std.env.*
import pkg_tf_0.tf_oracle_main
import package_fuzz.com.bs.infra.model.config.Clazz_699487
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699498
import package_fuzz.com.bs.infra.model.Clazz_699500
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import package_fuzz.com.bs.core.Clazz_699508
import package_fuzz.com.bs.impl.Clazz_699517
import pkg_lib_4.com.bs.service.Clazz_699523
import pkg_lib_4.com.bs.service.Clazz_699523_match_test
import package_fuzz.com.bs.infra.gfunc_524262
import package_fuzz.com.bs.infra.model.gfunc_524265
import package_fuzz.com.bs.infra.model.gfunc_524266
import package_fuzz.com.bs.infra.model.config.gfunc_524269
import package_fuzz.com.bs.core.gfunc_524272
import package_fuzz.com.bs.core.gfunc_524274
import package_fuzz.com.bs.model.gfunc_524275
import package_fuzz.com.bs.impl.gfunc_524277
import package_fuzz.com.bs.impl.gfunc_524278
import package_fuzz.com.bs.impl.gfunc_524279
import package_fuzz.com.bs.service.gfunc_524280
import package_fuzz.com.bs.service.gfunc_524281
import app_1.com.bs.gfunc_524283
import app_1.com.bs.infra.gfunc_524287
import app_1.com.bs.infra.gfunc_524288
import app_1.com.bs.model.gfunc_524292
import pkg_lib_2.com.bs.infra.gfunc_524358
import pkg_lib_2.com.bs.infra.gfunc_524359
import pkg_lib_2.com.bs.impl.gfunc_524360
import pkg_lib_3.com.bs.infra.gfunc_524363
import pkg_lib_3.com.bs.infra.gfunc_524365
import pkg_lib_3.com.bs.infra.gfunc_524366
import pkg_lib_3.com.bs.infra.gfunc_524369
import pkg_lib_3.com.bs.infra.web.gfunc_524371
import pkg_lib_3.com.bs.infra.web.gfunc_524372
import pkg_lib_4.com.bs.service.gfunc_524393
private import pkg_lib_4.com.bs.service.gfunc_524395
internal import pkg_lib_4.com.bs.model.gfunc_524396
import pkg_lib_4.com.bs.model.gfunc_524397
import pkg_tf_0.gfunc_524403
import pkg_tf_0.gfunc_524404

protected func gfunc_524260(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

func gfunc_524261(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v974978: Bool = false
}

func main_logic() {
    let depth: Int64 = 5
    try {
        tf_oracle_main()
    } catch (e: Exception) {
        println("TF_ORACLE_FAIL: ${e.toString()}")
    }
    let obj_0 = Clazz_699487(false)
    obj_0.validate_i9_0(depth - 1)
    obj_0.query_i9_2(depth - 1)
    obj_0.analyze_i9_3(depth - 1)
    if (obj_0.analyze_i9_3(depth - 1) != 42u16) {
        println("PROBE_FAIL: Clazz_699487.analyze_i9_3")
    }
    obj_0.fetch_i9_4(depth - 1)
    obj_0.compare_i9_5(depth - 1)
    obj_0.checkState_i9_6(depth - 1)
    if (obj_0.checkState_i9_6(depth - 1) != 114514) {
        println("PROBE_FAIL: Clazz_699487.checkState_i9_6")
    }
    obj_0.calculate_i9_7(depth - 1)
    obj_0.calculate_i1_1(depth - 1)
    if (obj_0.calculate_i1_1(depth - 1) != 42u16) {
        println("PROBE_FAIL: Clazz_699487.calculate_i1_1")
    }
    obj_0.calculate_i1_3(depth - 1)
    obj_0.handleEvent_i1_4(depth - 1)
    obj_0.validate_i1_5(depth - 1)
    obj_0.resolve_i1_7(depth - 1)
    obj_0.fetch_i1_8(depth - 1)
    obj_0.serialize_i1_9(depth - 1)
    obj_0.calculate_i1_10(depth - 1)
    obj_0.transform_i8_0(depth - 1)
    obj_0.update_i8_2(depth - 1)
    obj_0.query_i8_3(depth - 1)
    obj_0.synthesize_i8_4(depth - 1)
    let obj_1 = Clazz_699489("hello world", 3.14f32)
    obj_1.checkState_i3_1(depth - 1)
    if (obj_1.checkState_i3_1(depth - 1) != 42u8) {
        println("PROBE_FAIL: Clazz_699489.checkState_i3_1")
    }
    obj_1.process_i3_3(depth - 1)
    obj_1.filter_i3_4(depth - 1)
    obj_1.finalize_i3_5(depth - 1)
    obj_1.buildResult_i3_6(depth - 1)
    obj_1.handleEvent_i3_7(depth - 1)
    obj_1.process_i14_0(depth - 1)
    obj_1.synthesize_i14_1(depth - 1)
    obj_1.convert_i14_2(depth - 1)
    obj_1.query_i14_3(depth - 1)
    obj_1.query_i14_4(depth - 1)
    Clazz_699489.create_O2(depth - 1)
    let obj_2 = Clazz_699492()
    obj_2.process_i14_0(depth - 1)
    obj_2.synthesize_i14_1(depth - 1)
    obj_2.convert_i14_2(depth - 1)
    obj_2.query_i14_3(depth - 1)
    obj_2.query_i14_4(depth - 1)
    obj_2.getValue_i10_0(depth - 1)
    obj_2.merge_i10_1(depth - 1)
    obj_2.filter_i10_2(depth - 1)
    obj_2.evaluate_i10_3(depth - 1)
    obj_2.execute_i10_4(depth - 1)
    obj_2.initialize_i10_5(depth - 1)
    obj_2.compute_i10_6(depth - 1)
    obj_2.filter_i10_8(depth - 1)
    obj_2.analyze_i10_9(depth - 1)
    obj_2.execute_i12_0(depth - 1)
    obj_2.serialize_i12_1(depth - 1)
    if (obj_2.serialize_i12_1(depth - 1) != 42u8) {
        println("PROBE_FAIL: Clazz_699492.serialize_i12_1")
    }
    obj_2.transform_i12_3(depth - 1)
    obj_2.analyze_i12_4(depth - 1)
    obj_2.compare_i4_0(depth - 1)
    if (obj_2.compare_i4_0(depth - 1) != 42u64) {
        println("PROBE_FAIL: Clazz_699492.compare_i4_0")
    }
    obj_2.evaluate_i4_1(depth - 1)
    obj_2.checkState_i4_2(depth - 1)
    obj_2.checkState_i5_0(depth - 1)
    obj_2.fetch_i5_1(depth - 1)
    obj_2.validate_i5_2(depth - 1)
    obj_2.update_i5_3(depth - 1)
    obj_2.compute_i5_4(depth - 1)
    obj_2.setValue_i5_5(depth - 1)
    obj_2.checkState_i5_6(depth - 1)
    let obj_3 = Clazz_699498()
    obj_3.query_i9_2(depth - 1)
    obj_3.fetch_i9_4(depth - 1)
    obj_3.compare_i9_5(depth - 1)
    obj_3.calculate_i1_1(depth - 1)
    obj_3.calculate_i1_3(depth - 1)
    obj_3.resolve_i1_7(depth - 1)
    obj_3.fetch_i1_8(depth - 1)
    obj_3.calculate_i1_10(depth - 1)
    obj_3.transform_i8_0(depth - 1)
    obj_3.update_i8_2(depth - 1)
    obj_3.query_i8_3(depth - 1)
    let obj_4 = Clazz_699500()
    let obj_5 = Clazz_699504()
    obj_5.validate_i11_3(depth - 1)
    obj_5.calculate_i11_5(depth - 1)
    if (obj_5.calculate_i11_5(depth - 1) != 3.14f32) {
        println("PROBE_FAIL: Clazz_699504.calculate_i11_5")
    }
    obj_5.process_i11_6(depth - 1)
    obj_5.calculate_i11_7(depth - 1)
    obj_5.process_i11_8(depth - 1)
    obj_5.handleEvent_i11_9(depth - 1)
    obj_5.fetch_i5_1(depth - 1)
    obj_5.validate_i5_2(depth - 1)
    obj_5.update_i5_3(depth - 1)
    obj_5.compute_i5_4(depth - 1)
    obj_5.setValue_i5_5(depth - 1)
    obj_5.checkState_i5_6(depth - 1)
    let obj_6 = Clazz_699508()
    obj_6.checkState_i3_1(depth - 1)
    obj_6.process_i3_3(depth - 1)
    obj_6.buildResult_i3_6(depth - 1)
    obj_6.handleEvent_i3_7(depth - 1)
    obj_6.synthesize_i14_1(depth - 1)
    obj_6.query_i14_3(depth - 1)
    obj_6.query_i14_4(depth - 1)
    let obj_7 = Clazz_699517()
    obj_7.filter_i2_0(depth - 1)
    if (obj_7.filter_i2_0(depth - 1) != 42u8) {
        println("PROBE_FAIL: Clazz_699517.filter_i2_0")
    }
    obj_7.update_i2_2(depth - 1)
    obj_7.serialize_i2_3(depth - 1)
    Clazz_699517.create_C20(depth - 1)
    let bt_Array_0: Array<Int64> = [1, 2, 3]
    bt_Array_0.extm_737510(depth - 1)
    Array<Int64>.extm_737511(depth - 1)
    bt_Array_0.extm_737512(depth - 1)
    Array<Int64>.extm_737513(depth - 1)
    Array<Int64>.extm_737514(depth - 1)
    let bt_Int8_1: Int8 = 42
    bt_Int8_1.extm_737527(depth - 1)
    bt_Int8_1.extm_737528(depth - 1)
    bt_Int8_1.extm_737529(depth - 1)
    bt_Int8_1.extm_737530(depth - 1)
    let bt_Float64_2: Float64 = 3.14
    Float64.extm_737537(depth - 1)
    bt_Float64_2.extm_737538(depth - 1)
    bt_Float64_2.extm_737539(depth - 1)
    bt_Float64_2.extm_737540(depth - 1)
    Array<Int64>.extm_737542(depth - 1)
    Array<Int64>.extm_737543(depth - 1)
    bt_Array_0.extm_737544(depth - 1)
    bt_Array_0.extm_737545(depth - 1)
    let bt_UInt16_3: UInt16 = 42
    UInt16.extm_737546(depth - 1)
    bt_UInt16_3.extm_737547(depth - 1)
    bt_UInt16_3.extm_737548(depth - 1)

    // ==== enum 类型测试 ====
    let enu_Clazz_699523 = Clazz_699523.Ctor_11010210573
    Clazz_699523_match_test(enu_Clazz_699523)
    // ==== enum 类型测试结束 ====

    gfunc_524260(depth - 1)
    gfunc_524262(depth - 1)
    gfunc_524265(depth - 1)
    gfunc_524266(depth - 1)
    gfunc_524269(depth - 1)
    gfunc_524272(depth - 1)
    gfunc_524274(depth - 1)
    gfunc_524275(depth - 1)
    gfunc_524277(depth - 1)
    gfunc_524278(depth - 1)
    gfunc_524279(depth - 1)
    gfunc_524280(depth - 1)
    gfunc_524281(depth - 1)
    gfunc_524283(depth - 1)
    gfunc_524287(depth - 1)
    gfunc_524288(depth - 1)
    gfunc_524292(depth - 1)
    gfunc_524358(depth - 1)
    gfunc_524359(depth - 1)
    gfunc_524360(depth - 1)
    gfunc_524363(depth - 1)
    gfunc_524365(depth - 1)
    gfunc_524366(depth - 1)
    gfunc_524369(depth - 1)
    gfunc_524371(depth - 1)
    gfunc_524372(depth - 1)
    gfunc_524393(depth - 1)
    gfunc_524395(depth - 1)
    gfunc_524396(depth - 1)
    gfunc_524397(depth - 1)
    gfunc_524403(depth - 1)
    gfunc_524404(depth - 1)
}

@C
public func cangjie_main(): Unit {
    var ret = 1
    try {
        main_logic()
    } catch (e: Exception) {
        ret = 1
        println("RUNTIME_FAIL: ${e.toString()}")
        exit(1)
    } finally {
        print("cj_main_return_start${ret}cj_main_return_end")
    }
}

@When[os != "iOS"]
main(): Unit {
    try {
        main_logic()
    } catch (e: Exception) {
        println("RUNTIME_FAIL: ${e.toString()}")
        exit(1)
    }
}
