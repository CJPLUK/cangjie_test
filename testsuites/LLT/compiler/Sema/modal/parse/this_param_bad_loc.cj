// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json 2>&1 | compare %f

class C {
    func foo(this @local?) {
        func bar(this @local!) {
        }
    }
}

struct S {
    func foo(this @local?) {
        func bar(this @local!) {
        }
    }
}

func foo() {
    func bar(this @local!) {
    }
}

func jez(this @local!) {
}

enum E {
    | A
    func foo(this @local?) {
        func bar(this @local!) {
        }
    }
}
main(this @local!) {}

// ASSERT: scan-6 "DiagKind": "parse_unexpected_this_param",
// ASSERT: scan "Errors": 6,