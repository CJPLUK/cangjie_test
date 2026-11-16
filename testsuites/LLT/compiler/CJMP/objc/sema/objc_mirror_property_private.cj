// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-4 error: 'private' members are not allowed within '@ObjC' foreign declaration
// ASSERT: scan 4 errors generated

package cjworld

import objc.lang.*

@ObjC
foreign class Foo {
    private prop a: Int64
    private static prop b: Int64
    private mut prop c: Int64
    private static mut prop d: Int64
}
