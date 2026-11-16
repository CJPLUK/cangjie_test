/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: ../../benchmark.cj
// EXEC: %compiler %cmp_macro benchmark.cj
// EXEC: %compiler %cmp_opt %f

package test

import std.time.*
import std.convert.*
import std.math.*

import bench.*

var f64min : Float64 = Float64.Min
var f64max : Float64 = Float64.Max

@BENCHMARK[10000000]
func abs_min_float64(){abs(f64min)}

@BENCHMARK[10000000]
func abs_max_float64(){abs(f64max)}

@MAIN
main(){
    return 0
}
