// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.impl

import pkg_macro_1.mfunc_920835
import package_fuzz.com.bs.core.Clazz_699508
import package_fuzz.com.bs.infra.model.config.Clazz_699487
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_lib_3.com.bs.infra.web.Clazz_699504
import pkg_lib_3.com.bs.infra.Clazz_699498

@mfunc_920835[cfg]
public class Clazz_699517 {
    public Clazz_699517() {
    }
    public open func filter_i2_0(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v1229951: Bool = false
        let obj102119117 = Clazz_699504()
        obj102119117.validate_i5_2(depth - 1i64)
        let obj108113121 = Clazz_699498()
        obj108113121.resolve_i1_7(depth - 1i64)
        let obj75116118 = Clazz_699492()
        obj75116118.evaluate_i4_1(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        let obj10311788 = Clazz_699489("hello world", 3.140000f32)
        obj10311788.filter_i3_4(depth - 1i64)
        obj75116118.analyze_i10_9(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        return 42u8
    }

    public open func update_i2_2(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let v707898: Float64 = 114.514000f64
        let v10386122: Int64 = 114514i64
        let obj817966 = Clazz_699504()
        obj817966.validate_i11_3(depth - 1i64)
        let obj998065 = Clazz_699489("hello world", 3.140000f32)
        obj998065.buildResult_i3_6(depth - 1i64)
        obj817966.setValue_i5_5(depth - 1i64)
        obj998065.buildResult_i3_6(depth - 1i64)
        obj817966.fetch_i5_1(depth - 1i64)
        return 114514i64
    }

    public open func serialize_i2_3(depth: Int64): UInt8 {
        if (depth <= 0i64) {
            return 42u8
        }
        let v7875116: Bool = true
        let obj1155774 = Clazz_699492()
        obj1155774.validate_i5_2(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        let obj1218889 = Clazz_699504()
        obj1218889.validate_i5_2(depth - 1i64)
        obj1155774.compare_i4_0(depth - 1i64)
        let obj1229888 = Clazz_699498()
        obj1229888.calculate_i1_1(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        let obj11878109 = Clazz_699489("hello world", 3.140000f32)
        obj11878109.buildResult_i3_6(depth - 1i64)
        obj1155774.serialize_i12_1(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        obj1229888.calculate_i1_3(depth - 1i64)
        let obj11683109 = Clazz_699508()
        obj11683109.process_i3_3(depth - 1i64)
        obj1155774.checkState_i5_6(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        obj1218889.process_i11_8(depth - 1i64)
        return 42u8
    }

    public static func create_C20(depth: Int64): Int64 {
        if (depth <= 0i64) {
            return 114514i64
        }
        let obj838857 = Clazz_699489("hello world", 3.140000f32)
        obj838857.finalize_i3_5(depth - 1i64)
        let obj12056122 = Clazz_699498()
        obj12056122.transform_i8_0(depth - 1i64)
        let obj8168103 = Clazz_699504()
        obj8168103.handleEvent_i11_9(depth - 1i64)
        obj838857.query_i14_4(depth - 1i64)
        obj838857.process_i3_3(depth - 1i64)
        obj838857.buildResult_i3_6(depth - 1i64)
        let obj10665117 = Clazz_699492()
        obj10665117.update_i5_3(depth - 1i64)
        obj838857.query_i14_3(depth - 1i64)
        obj12056122.update_i8_2(depth - 1i64)
        obj12056122.transform_i8_0(depth - 1i64)
        obj12056122.transform_i8_0(depth - 1i64)
        let obj10810277 = Clazz_699508()
        obj10810277.query_i14_4(depth - 1i64)
        return 114514i64
    }
}

private func gfunc_524276(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}
