// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f
// ASSERT: scan-8 error: type of member variable in '@ObjC' foreign declaration must be Objective-C compatible
// ASSERT: scan 8 errors generated, 8 errors printed

import objc.lang.*

class A {}

@ObjC["M1"]
foreign class M {
   init()
   public let a: String
   public let b: Array<Int64>
   public let c: A
   public let d: Unit

   public var aMut: String
   public var bMut: Array<Int64>
   public var cMut: A
   public var dMut: Unit
}
