// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Irrefutable tuple payloads cover every value in the Some/Some combination.
// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f

func bindings(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some((x, y)), Some(_)) => 1
        case (Some(_), None) => 2
        case (None, Some(_)) => 3
        case (None, None) => 4
    }
}

func wildcards(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some((_, _)), Some(_)) => 1
        case (Some(_), None) => 2
        case (None, Some(_)) => 3
        case (None, None) => 4
    }
}

main() {
    println(bindings(Some((1, 2)), Some((3, 4))))
    println(bindings(Some((1, 2)), None))
    println(bindings(None, Some((3, 4))))
    println(bindings(None, None))
    println(wildcards(Some((1, 2)), Some((3, 4))))
    println(wildcards(Some((1, 2)), None))
    println(wildcards(None, Some((3, 4))))
    println(wildcards(None, None))
}

/* SCAN-IN
1
2
3
4
1
2
3
4
*/
