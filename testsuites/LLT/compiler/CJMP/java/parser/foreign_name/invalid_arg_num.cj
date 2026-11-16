// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>& 1 | compare %f

@Java
foreign class C {
    @ForeignName[]
    public func foo(): Unit
}

/* SCAN-IN
error: @ForeignName requires exactly one 'String' literal argument
 ==> invalid_arg_num.cj:5:5:
  | 
5 |     @ForeignName[]
  |     ^^^^^^^^^^^^^^ expected single 'String' literal for @ForeignName here
  | 
*/
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
