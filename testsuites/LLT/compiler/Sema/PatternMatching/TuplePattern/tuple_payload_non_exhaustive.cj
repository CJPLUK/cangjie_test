// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Refutable payloads and missing constructor combinations must remain non-exhaustive.
// ERRCHECK: %compiler %cmp_opt %compile_lib_opt %f -o %output

func partialPayload(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some((0, _)), Some(_)) => 1
        case (Some(_), None) => 2
        case (None, Some(_)) => 3
        case (None, None) => 4
    }
}

func missingCombination(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some((x, y)), Some(_)) => 1
        case (Some(_), None) => 2
        case (None, Some(_)) => 3
    }
}

/* SCAN-IN
error: non-exhaustive patterns
  ==> tuple_payload_non_exhaustive.cj:11:12:
   | 
11 |     match ((a, b)) {
   |            ^^^^^^ the selector is of type 'Tuple<Enum-Option<Tuple<Int64, Int64>>, Enum-Option<Tuple<Int64, Int64>>>'
   | 
   # note: (Some((_, _)), Some(_)) is not covered
*/

/* SCAN-IN
error: non-exhaustive patterns
  ==> tuple_payload_non_exhaustive.cj:20:12:
   | 
20 |     match ((a, b)) {
   |            ^^^^^^ the selector is of type 'Tuple<Enum-Option<Tuple<Int64, Int64>>, Enum-Option<Tuple<Int64, Int64>>>'
   | 
   # note: (None, None) is not covered
*/

/* SCAN-IN
2 errors generated, 2 errors printed.
*/
