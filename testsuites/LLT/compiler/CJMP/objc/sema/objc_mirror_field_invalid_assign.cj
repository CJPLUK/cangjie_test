// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f
// ASSERT: scan error: cannot assign to immutable value

import objc.lang.*

@ObjC["M"]
open foreign class M {
   init()
   public let x: Int64
}

@ObjC
class A <: M {
   init() {
      x = 5
   }
}
