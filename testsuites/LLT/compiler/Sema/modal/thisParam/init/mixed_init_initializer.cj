// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

main() {}
class F {
    init() {}
    init(this @local!) { exclave {}}
    init(this @local?) { exclave {}}
    func foo(a: Int) {}
}

class C {
    let f: F@~local = F()
    init(this @local!) { exclave {}}
    init() {}
}

class C2 {
    let f: F@~local = F()
    init(this @local?) { exclave {}}
    init(this @local!) { exclave {}}
}

class C3 {
    let f: F@~local = F()
    init(this @local!) { exclave {}}
    init() {}
}
class C4 {
    let f: F@~local = F()
    init(this @~local) {}
    init(this @local!) { exclave {}}
}

struct S1 {
    let f: F@~local = F()
    init(this @local!) { exclave {}}
    init() {}
}

struct S2 {
    let f: F@~local = F()
    init(this @local?) { exclave {}}
    init(this @~local) {}
}

struct S3 {
    let f: F@~local = F()
    init(this @local!) { exclave {}}
    init() {}
}
struct S4 {
    let f: F@~local = F()
    init(this @~local) {}
    init(this @local!) { exclave {}}
}

// ASSERT: scan-8 "DiagKind": "sema_member_var_initalizer_in_mixed_init",
// ASSERT: scan "Errors": 8,
