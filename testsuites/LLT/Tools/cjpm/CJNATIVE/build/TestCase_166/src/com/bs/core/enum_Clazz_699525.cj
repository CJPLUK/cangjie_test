// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package package_fuzz.com.bs.core

import app_1.com.bs.infra.gfunc_524288
import pkg_lib_4.com.bs.model.gfunc_524396
import app_1.com.bs.gfunc_524283
import pkg_tf_0.gfunc_524404
import pkg_lib_2.com.bs.impl.gfunc_524360
import package_fuzz.com.bs.infra.model.config.gfunc_524269
public import pkg_lib_4.com.bs.service.gfunc_524395
import pkg_tf_0.gfunc_524403
import pkg_lib_3.com.bs.infra.web.gfunc_524371
import pkg_lib_3.com.bs.infra.web.Clazz_699504

protected enum Clazz_699525 {
    | Ctor_651038656
    | Ctor_67888650
}

protected func Clazz_699525_match_test(value: Clazz_699525): Unit {
    match (value) {
        case Clazz_699525.Ctor_651038656 | Clazz_699525.Ctor_67888650 => "matched Clazz_699525.Ctor_651038656"

        case _ => "other"
    }
}

func gfunc_524271(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524404(depth - 1i64)
    gfunc_524274(depth - 1i64)
    gfunc_524360(depth - 1i64)
    gfunc_524269(depth - 1i64)
    gfunc_524395(depth - 1i64)
    gfunc_524403(depth - 1i64)
    gfunc_524288(depth - 1i64)
    gfunc_524371(depth - 1i64)
    let obj122113101 = Clazz_699504()
    obj122113101.process_i11_6(depth - 1i64)
    obj122113101.calculate_i11_7(depth - 1i64)
}

protected func gfunc_524272(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    gfunc_524288(depth - 1i64)
    gfunc_524396(depth - 1i64)
    gfunc_524283(depth - 1i64)
}
