// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func mk(): C { C() }

class ClassInferred {
    var c = mk()
    init(this @local!) { exclave {} }
}

struct StructTyped {
    var c: C = mk()
    init(this @local!) { exclave {} }
}

struct StructInferred {
    var c = mk()
    init(this @local!) { exclave {} }
}

class ClassOverloaded {
    var c: C = mk()
    init(this @local!) { exclave {} }
    init(this @local!, _: Int64) { exclave {} }
    static init() {}
}

struct StructOverloaded {
    var c: C = mk()
    init(this @local!) { exclave {} }
    init(this @local!, _: Int64) { exclave {} }
}

func mkLocal(): C @local! { exclave { C() @local! } }

class ClassNonLocal {
    var c: C = mkLocal()
    init() {}
}

struct StructNonLocal {
    var c = mkLocal()
    init() {}
}

main() {}

// ASSERT: scan-7 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 7,
