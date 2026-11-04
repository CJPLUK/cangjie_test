// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal package pkg_lib_3.com.bs.util

extend Clazz_699529 {
    protected mut func extm_737523(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let obj818855 = Clazz_699518()
        obj818855.analyze_i9_3(depth - 1i64)
        obj818855.resolve_i1_7(depth - 1i64)
        obj818855.calculate_i9_7(depth - 1i64)
        obj818855.calculate_i1_3(depth - 1i64)
        obj818855.calculate_i1_3(depth - 1i64)
        obj818855.calculate_i9_7(depth - 1i64)
        obj818855.compare_i9_5(depth - 1i64)
        obj818855.update_i8_2(depth - 1i64)
    }
    private func extm_737524(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let obj11486121 = Clazz_699518()
        obj11486121.analyze_i9_3(depth - 1i64)
        obj11486121.update_i8_2(depth - 1i64)
        obj11486121.compare_i9_5(depth - 1i64)
        obj11486121.analyze_i9_3(depth - 1i64)
        obj11486121.compare_i9_5(depth - 1i64)
        obj11486121.calculate_i9_7(depth - 1i64)
        obj11486121.analyze_i9_3(depth - 1i64)
        obj11486121.update_i8_2(depth - 1i64)
        obj11486121.resolve_i1_7(depth - 1i64)
        obj11486121.calculate_i1_3(depth - 1i64)
        obj11486121.calculate_i9_7(depth - 1i64)
        obj11486121.compare_i9_5(depth - 1i64)
        obj11486121.update_i8_2(depth - 1i64)
        obj11486121.resolve_i1_7(depth - 1i64)
    }
    protected static func extm_737525(depth: Int64): Unit {
        if (depth <= 0i64) {
            return
        }
        let v7811679: Int64 = 114514i64
        let obj979785 = Clazz_699518()
        obj979785.resolve_i1_7(depth - 1i64)
        obj979785.calculate_i1_3(depth - 1i64)
        obj979785.calculate_i1_3(depth - 1i64)
        obj979785.calculate_i9_7(depth - 1i64)
        obj979785.calculate_i1_1(depth - 1i64)
        obj979785.calculate_i1_3(depth - 1i64)
        obj979785.update_i8_2(depth - 1i64)
        obj979785.analyze_i9_3(depth - 1i64)
        obj979785.calculate_i1_1(depth - 1i64)
        obj979785.calculate_i9_7(depth - 1i64)
        obj979785.calculate_i1_1(depth - 1i64)
        obj979785.calculate_i1_3(depth - 1i64)
        obj979785.resolve_i1_7(depth - 1i64)
        obj979785.calculate_i1_1(depth - 1i64)
        obj979785.resolve_i1_7(depth - 1i64)
        obj979785.calculate_i9_7(depth - 1i64)
        obj979785.compare_i9_5(depth - 1i64)
    }
}
