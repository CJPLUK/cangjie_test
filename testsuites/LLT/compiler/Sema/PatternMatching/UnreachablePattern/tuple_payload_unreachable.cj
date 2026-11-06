// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Irrefutable tuple payloads in either column cover a later Some/Some case.
// EXEC-PIPE: %compiler %cmp_opt %diag_json %compile_lib_opt %f -o %output 2>&1 | compare %f --assert_flag=ASSERT-JSON
// ASSERT-JSON: scan-2 "DiagKind": "sema_unreachable_pattern"
// EXEC-PIPE: %compiler %cmp_opt %compile_lib_opt %f -o %output 2>&1 | compare %f

func firstColumn(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some((x, y)), Some(_)) => 1
        case (Some(_), Some(_)) => 5
        case (Some(_), None) => 2
        case (None, _) => 3
    }
}

func secondColumn(a: Option<(Int64, Int64)>, b: Option<(Int64, Int64)>): Int64 {
    match ((a, b)) {
        case (Some(_), Some((x, y))) => 1
        case (Some(_), Some(_)) => 5
        case (Some(_), None) => 2
        case (None, _) => 3
    }
}

/* SCAN-IN
warning: unreachable pattern
  ==> tuple_payload_unreachable.cj:15:14:
   | 
15 |         case (Some(_), Some(_)) => 5
   |              ^^^^^^^^^^^^^^^^^^ 
   | 
*/

/* SCAN-IN
warning: unreachable pattern
  ==> tuple_payload_unreachable.cj:24:14:
   | 
24 |         case (Some(_), Some(_)) => 5
   |              ^^^^^^^^^^^^^^^^^^ 
   | 
*/
