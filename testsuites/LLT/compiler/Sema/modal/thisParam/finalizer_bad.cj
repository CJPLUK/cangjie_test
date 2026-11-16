// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json --error-count-limit=all %f -o %output 2>&1 | compare %f

class C {
    ~init(this @local!) {}
}
class D {
    ~init(this @local?) {}
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_finalizer_this_mode_mismatch",
// ASSERT: scan "Errors": 1,