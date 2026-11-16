// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

import objc.lang.*

@ObjC
public open foreign class M {
    init()
}

@ObjC
class A <: M {
    @ForeignName[true]
    public init() {
    }
}

/* SCAN-IN
error: @ForeignName requires exactly one 'String' literal argument
  ==> objc_impl_ctor_foreign_name_bad_arg.cj:18:18:
   | 
18 |     @ForeignName[true]
   |                  ^^^^ expected 'String' literal here
   | 

1 error generated, 1 error printed.
*/
