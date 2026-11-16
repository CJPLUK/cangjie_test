// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f

import objc.lang.*

@ObjC
foreign class A {
   @ObjCMirror
   func foo(): Int64
}

/* SCAN-IN
error: unexpected annotation '@ObjCMirror' on member or local func
  ==> objc_mirror_not_toplevel.cj:13:4:
   | 
13 |    @ObjCMirror
   |    ^^^^^^^^^^^ unexpected annotation here
14 |    func foo(): Int64
   |    ~~~~~~~~~~~~~~~~~~ on member or local func
   | 
*/
