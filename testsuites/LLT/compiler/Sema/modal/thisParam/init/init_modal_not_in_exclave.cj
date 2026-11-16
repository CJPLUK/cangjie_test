// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -o %output %diag_json 2>&1 | compare %f

class C {
    init(this @local!) {
        println("C.init @local!")
    }
    init(this @local?) {
        println("C.init @local?")
    }
}

struct S {
    init(this @local!) {
        println("S.init @local!")
    }
    init(this @local?) {
        println("S.init @local?")
    }
}
main() {

}

// ASSERT: scan-4 "DiagKind": "sema_init_modal_must_be_in_exclave"
// ASSERT: scan "Errors": 4
