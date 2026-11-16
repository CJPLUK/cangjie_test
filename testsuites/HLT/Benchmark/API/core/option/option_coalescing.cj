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

import bench.*

var x : ?Int64 = 123456789

@BENCHMARK[100000]
func test_option_double_quest(){
    x??0
}

@BENCHMARK[10000]
func test_option_double_quest(){
    x??0
}

@BENCHMARK[1000]
func test_option_double_quest(){
    x??0
}


@BENCHMARK[100]
func test_option_double_quest(){
    x??0
}

@BENCHMARK[10]
func test_option_double_quest(){
    x??0
}

@BENCHMARK[1]
func test_option_double_quest(){
    x??0
}



@MAIN
main(){
    return 0
}
