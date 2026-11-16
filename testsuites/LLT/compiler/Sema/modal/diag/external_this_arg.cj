// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -Woff all 2>&1 | compare %f
func first(xs: Array<Int64> @local!): Int64 {
    xs[0]
}
main() {}
/* SCAN
error: cannot pass argument of external @local! to @local! this parameter
 ==> external_this_arg.cj:9:5:
  | 
9 |     xs[0]
  |     ^^ 
  | 

1 error generated, 1 error printed.
*/