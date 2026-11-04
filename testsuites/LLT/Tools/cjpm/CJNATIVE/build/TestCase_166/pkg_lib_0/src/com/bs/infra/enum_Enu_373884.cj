// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_0.com.bs.infra

import pkg_macro_1.mfunc_920837
import pkg_lib_0.com.bs.infra.model.gfunc_524319
import pkg_tf_0.gfunc_524404

enum Enu_373884 {
    | Ctor_11510210351

    func mefn_7677118118(depth: Int64): String {
        return "hello world"
    }

    func mefn_100887488(depth: Int64): String {
        return "hello world"
    }
}

func Enu_373884_match_test(value: Enu_373884): Unit {
    match (value) {
        case Enu_373884.Ctor_11510210351 => "matched Enu_373884.Ctor_11510210351"

        case _ => "other"
    }
}

public func gfunc_524304(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1104865: String = "hello world"
    let v1028250: Int64 = 114514i64
    gfunc_524313(depth - 1i64)
    gfunc_524319(depth - 1i64)
    gfunc_524314(depth - 1i64)
    gfunc_524404(depth - 1i64)
}

@mfunc_920837[true]
public func gfunc_524305(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v12011897: Int64 = 114514i64
    let v797376: String = "hello world"
}
