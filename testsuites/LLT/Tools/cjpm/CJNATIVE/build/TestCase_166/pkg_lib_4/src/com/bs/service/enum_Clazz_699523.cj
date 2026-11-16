// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_lib_4.com.bs.service

import pkg_lib_2.com.bs.infra.gfunc_524358
import pkg_lib_3.com.bs.infra.Clazz_699498
import pkg_lib_2.com.bs.infra.Clazz_699492
import pkg_lib_3.com.bs.infra.web.Clazz_699504

public enum Clazz_699523 {
    | Ctor_11010210573

    public static func mefn_102667178(depth: Int64): Bool {
        return true
    }

    public func mefn_115758269(depth: Int64): Int64 {
        return 114514i64
    }
}

public func Clazz_699523_match_test(value: Clazz_699523): Unit {
    match (value) {
        case Clazz_699523.Ctor_11010210573 => "matched Clazz_699523.Ctor_11010210573"

        case _ => "other"
    }
}

public func gfunc_524393(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524358(depth - 1i64)
    gfunc_524358(depth - 1i64)
    let obj11382102 = Clazz_699498()
    obj11382102.update_i8_2(depth - 1i64)
    let obj699986 = Clazz_699492()
    obj699986.synthesize_i14_1(depth - 1i64)
    let obj1035676 = Clazz_699504()
    obj1035676.compute_i5_4(depth - 1i64)
    let obj10111170 = Clazz_699501()
    obj10111170.query_i14_4(depth - 1i64)
    obj10111170.checkState_i5_0(depth - 1i64)
    obj1035676.process_i11_6(depth - 1i64)
}
