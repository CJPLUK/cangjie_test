// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %compile_lib_opt %diag_json 2>&1 | compare %f

@Annotation
public class local {
    public const init() {}
}

@local
public class C {
}

main() {
    @local @local? func foo() {}
}

// ASSERT: scan-1 "DiagKind": "sema_annotation_custom_place",
// ASSERT: scan "Errors": 1,