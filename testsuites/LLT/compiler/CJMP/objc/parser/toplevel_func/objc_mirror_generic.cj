// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %frontendCompiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f

import objc.lang.*

@ObjC
foreign func foo<T>(): Int64

// ASSERT: scan parse_objc_mirror_func_cannot_be_generic
// ASSERT: scan "Errors": 1
