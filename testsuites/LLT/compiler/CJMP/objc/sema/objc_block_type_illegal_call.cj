// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-2 error: 'ObjCBlock' property 'call' can only be called directly, no other operations are permitted

import objc.lang.*

func aa(f: (Float64) -> Float64) {}

func a(f: ObjCBlock<(Float64) -> Float64>): Unit {
    let x = f.call
    x(3.14)
    aa(f.call)
}
