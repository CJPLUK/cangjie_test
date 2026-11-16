// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra

import pkg_macro_1.mfunc_920836
import pkg_macro_0.mfunc_920831
import pkg_tf_0.gfunc_524404
import pkg_lib_3.com.bs.infra.gfunc_524366
import pkg_lib_3.com.bs.infra.Clazz_699489
import pkg_tf_0.gfunc_524403
import pkg_lib_3.com.bs.infra.web.gfunc_524371

@mfunc_920836
internal interface I_489857 {
    func validate_i9_0(depth: Int64): Int64

    public static func evaluate_i9_1(depth: Int64): Int16 {
        return 42i16
    }

    func query_i9_2(depth: Int64): Int16 {
        return 42i16
    }

    func analyze_i9_3(depth: Int64): UInt16 {
        return 42u16
    }

    func fetch_i9_4(depth: Int64): Int64

    func compare_i9_5(depth: Int64): Int64

    func checkState_i9_6(depth: Int64): Int64

    func calculate_i9_7(depth: Int64): Int64
}

@mfunc_920831
internal func gfunc_524302(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524404(depth - 1i64)
    gfunc_524366(depth - 1i64)
    Clazz_699489.create_O2(depth - 1i64)
}

internal func gfunc_524303(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524310(depth - 1i64)
    gfunc_524403(depth - 1i64)
    gfunc_524310(depth - 1i64)
    gfunc_524371(depth - 1i64)
    gfunc_524317(depth - 1i64)
}
