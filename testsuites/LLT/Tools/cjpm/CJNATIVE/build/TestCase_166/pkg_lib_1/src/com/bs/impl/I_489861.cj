// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_1.com.bs.impl

import pkg_macro_0.mfunc_920832
import pkg_tf_0.gfunc_524404

protected interface I_489861 {
    func execute_i13_0(depth: Int64): UInt8 {
        return 42u8
    }

    func initialize_i13_1(depth: Int64): UInt16

    func compare_i13_2(depth: Int64): UInt64

    func convert_i13_3(depth: Int64): UInt8

    func process_i13_4(depth: Int64): UInt32 {
        return 42u32
    }

    func getValue_i13_5(depth: Int64): UInt8

    public static func query_i13_6(depth: Int64): Int16 {
        return 42i16
    }

    func getValue_i13_7(depth: Int64): UInt16
}

@mfunc_920832["v"]
public func gfunc_524339(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v10110771: String = "hello world"
    let v1096788: Float64 = 114.514000f64
    gfunc_524341(depth - 1i64)
    gfunc_524404(depth - 1i64)
    gfunc_524346(depth - 1i64)
}

internal func gfunc_524340(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v8669101: Bool = true
    let v667072: Int64 = 114514i64
}
