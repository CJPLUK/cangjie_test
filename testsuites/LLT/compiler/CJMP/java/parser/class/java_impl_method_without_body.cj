// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f

/*
SCAN-IN

error: function 'f' can not be abstract
  ==> java_impl_method_without_body.cj:24:5:
   | 
24 |     func f(): Unit
   |     ^ 
   |

*/

@Java
public class C {
    init() {}
    func f(): Unit
}
