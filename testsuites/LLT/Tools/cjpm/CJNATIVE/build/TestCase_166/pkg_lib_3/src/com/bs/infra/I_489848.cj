// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_lib_3.com.bs.infra

import pkg_lib_3.com.bs.infra.model.Clazz_699497

public interface I_489848 {
    func update_i0_0(depth: Int64): Float32

    func compute_i0_1(depth: Int64): Int64

    public static func handleEvent_i0_2(depth: Int64): UInt64 {
        return 42u64
    }

    public static func compute_i0_3(depth: Int64): Int8 {
        return 42i8
    }

    public static func resolve_i0_4(depth: Int64): Float64 {
        return 114.514000f64
    }
}

public func gfunc_524363(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

protected func gfunc_524364(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    Clazz_699489.create_O2(depth - 1i64)
    let obj775375 = Clazz_699498()
    obj775375.resolve_i1_7(depth - 1i64)
    Clazz_699497.create_C0(depth - 1i64)
    let obj1187479 = Clazz_699497()
    obj1187479.synthesize_i14_1(depth - 1i64)
}
