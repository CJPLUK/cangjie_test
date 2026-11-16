// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_1.com.bs.impl

import pkg_tf_0.gfunc_524404

enum Enu_373888 {
    | Ctor_65785489
    | Ctor_859767108(Int64)
    | Ctor_1047111988
}

func Enu_373888_match_test(value: Enu_373888): Unit {
    match (value) {
        case Enu_373888.Ctor_859767108(mc_0) => "matched Enu_373888.Ctor_859767108"

        case Enu_373888.Ctor_65785489 | Enu_373888.Ctor_1047111988 => "matched Enu_373888.Ctor_65785489"

        case _ => "other"
    }
}

public func gfunc_524341(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v7212057: Bool = false
    let v12285109: String = "hello world"
    gfunc_524404(depth - 1i64)
    let obj887269 = Clazz_699516()
    obj887269.analyze_i2_1(depth - 1i64)
    obj887269.update_i2_8(depth - 1i64)
}

public func gfunc_524342(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1008377: Int64 = 114514i64
}
