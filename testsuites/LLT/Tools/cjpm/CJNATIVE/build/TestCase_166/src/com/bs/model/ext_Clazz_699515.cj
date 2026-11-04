// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.model

extend Clazz_699515 {
    internal func extm_737535(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        this.validate_i1_5(depth - 1i64)
        this.update_i5_3(depth - 1i64)
    }
    internal func extm_737536(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v678682: Bool = true
        let v10110149: Bool = false
        this.calculate_i1_1(depth - 1i64)
        this.buildResult_i2_4(depth - 1i64)
        this.update_i2_8(depth - 1i64)
        this.filter_i2_0(depth - 1i64)
        this.serialize_i2_3(depth - 1i64)
        this.resolve_i1_7(depth - 1i64)
        this.setValue_i5_5(depth - 1i64)
        this.analyze_i2_1(depth - 1i64)
    }
}
