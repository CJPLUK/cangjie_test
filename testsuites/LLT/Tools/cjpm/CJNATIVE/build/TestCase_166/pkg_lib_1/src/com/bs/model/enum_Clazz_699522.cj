// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_1.com.bs.model

protected enum Clazz_699522 {
    | Ctor_11911511875(Int64, Int64)
    | Ctor_1069071121

    protected func mefn_7210076112(depth: Int64): String {
        return "hello world"
    }
}

protected func Clazz_699522_match_test(value: Clazz_699522): String {
    match (value) {
        case Clazz_699522.Ctor_11911511875(mc_0, mc_1) => "hello world"

        case Clazz_699522.Ctor_1069071121 => "hello world"

        case _ => "hello world"
    }
}

private func gfunc_524349(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v664981: Bool = true
}

private func gfunc_524350(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v11610497: Int64 = 114514i64
    let v6582118: Bool = true
}

public func gfunc_524351(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v1088857: Float64 = 114.514000f64
    let v102111101: Bool = false
}
