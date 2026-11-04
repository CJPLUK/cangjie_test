// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class D {
    var v = 1
    init() {}
    init(this @local!) { exclave { v = 1 } }
}

class C {
    var d: D
    init() { d = D() }
    init(this @local!) { exclave { d = D() } }
}

func externalBaseReceivesInternal(pc: C@local!) {
    var d: D@local! = D()
    pc.d = d
    d = pc.d
}

func externalLocalHalf(pc: C@local?) {
    var d: D@local? = D() @local!
    pc.d = d
    d = pc.d
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-1 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 3,
