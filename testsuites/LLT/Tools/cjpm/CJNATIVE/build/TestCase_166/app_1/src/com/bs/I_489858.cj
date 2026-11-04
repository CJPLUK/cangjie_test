// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package app_1.com.bs

import pkg_macro_1.mfunc_920837
import pkg_tf_0.gfunc_524404
import app_1.com.bs.web.gfunc_524298
import pkg_lib_2.com.bs.infra.gfunc_524359

@mfunc_920837[cfg]
protected interface I_489858 {
    func getValue_i10_0(depth: Int64): Bool

    func merge_i10_1(depth: Int64): UInt32

    func filter_i10_2(depth: Int64): UInt32

    func evaluate_i10_3(depth: Int64): UInt32

    func execute_i10_4(depth: Int64): UInt32

    func initialize_i10_5(depth: Int64): Bool

    func compute_i10_6(depth: Int64): Bool

    public static func compare_i10_7(depth: Int64): Int8 {
        return 42i8
    }

    func filter_i10_8(depth: Int64): Bool

    func analyze_i10_9(depth: Int64): UInt32
}

protected func gfunc_524282(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v122112118: String = "hello world"
    let v10556120: Bool = false
    gfunc_524404(depth - 1i64)
    gfunc_524298(depth - 1i64)
    gfunc_524359(depth - 1i64)
    gfunc_524283(depth - 1i64)
}

public func gfunc_524283(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v857275: String = "hello world"
    let v110112108: Float64 = 114.514000f64
}
