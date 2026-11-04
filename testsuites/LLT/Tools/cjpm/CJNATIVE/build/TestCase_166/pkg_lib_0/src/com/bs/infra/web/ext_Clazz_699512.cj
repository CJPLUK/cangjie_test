// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra.web

extend Clazz_699512 {
    private func extm_737531(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let obj695597 = Clazz_699496()
        obj695597.calculate_i9_7(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        obj695597.query_i8_3(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        obj695597.calculate_i1_1(depth - 1i64)
    }
    public func extm_737532(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v6911671: Bool = false
        let obj1075679 = Clazz_699496()
        obj1075679.validate_i1_5(depth - 1i64)
        obj1075679.validate_i1_5(depth - 1i64)
        obj1075679.fetch_i1_8(depth - 1i64)
        obj1075679.update_i8_2(depth - 1i64)
        this.query_i8_3(depth - 1i64)
        obj1075679.update_i8_2(depth - 1i64)
        this.calculate_i2_5(depth - 1i64)
        this.synthesize_i8_4(depth - 1i64)
        obj1075679.update_i8_2(depth - 1i64)
        obj1075679.validate_i1_5(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.transform_i8_0(depth - 1i64)
        this.synthesize_i8_4(depth - 1i64)
        obj1075679.fetch_i9_4(depth - 1i64)
        obj1075679.calculate_i9_7(depth - 1i64)
    }
    func extm_737533(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        this.analyze_i12_4(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        this.analyze_i12_4(depth - 1i64)
        this.update_i2_2(depth - 1i64)
        let obj8211685 = Clazz_699496()
        obj8211685.query_i8_3(depth - 1i64)
        obj8211685.fetch_i1_8(depth - 1i64)
        this.execute_i12_0(depth - 1i64)
    }
    protected func extm_737534(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v1197165: Bool = true
        let v10210657: Bool = false
        let obj784897 = Clazz_699496()
        obj784897.update_i8_2(depth - 1i64)
        obj784897.validate_i1_5(depth - 1i64)
        this.update_i8_2(depth - 1i64)
        obj784897.calculate_i1_1(depth - 1i64)
        obj784897.resolve_i1_7(depth - 1i64)
        this.transform_i8_0(depth - 1i64)
        obj784897.calculate_i9_7(depth - 1i64)
        obj784897.query_i9_2(depth - 1i64)
        obj784897.query_i9_2(depth - 1i64)
        this.serialize_i12_1(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.serialize_i12_1(depth - 1i64)
        obj784897.fetch_i9_4(depth - 1i64)
        obj784897.update_i8_2(depth - 1i64)
        obj784897.calculate_i1_1(depth - 1i64)
        this.synthesize_i8_4(depth - 1i64)
    }
}
