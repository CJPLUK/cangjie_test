// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-ir --dump-to-screen %f 2>&1 | compare %f

import objc.lang.*

@ObjC
foreign class Foo {
    init()
}

main() {}

/* SCAN-IN
; Function Attrs: nounwind
define void @"_CN7default3Foo5~initHv"
*/
