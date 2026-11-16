// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output 2>& 1 | compare %f

@Java
foreign interface I {
    @JavaHasDefault[""]
    func foo(): Unit
    
    @JavaHasDefault["", 1]
    func foo1(): Unit
}

// ASSERT: scan-2 parse_annotation_no_arguments
// ASSERT: scan-2 @JavaHasDefault accepts no arguments
// ASSERT: scan "Errors": 2
