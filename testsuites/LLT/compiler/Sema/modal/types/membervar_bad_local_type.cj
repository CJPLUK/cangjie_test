// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit=all 2>&1 | compare %f

class Data {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

class LocalFullMemberIsNeverAllowed {
    var a: Data @local! = Data()
}

class LocalHalfMemberNotAllowedWithDefaultCtor {
    var a: Data @local? = Data()
}

class LocalHalfMemberNotAllowedWithNotLocalThisCtor {
    var a: Data @local? = Data()
    init() {}
}

class LocalHalfMemberNotAllowedWithExplicitNotLocalThisCtor {
    var a: Data @local? = Data()
    init(this @~local) {}
}

class LocalHalfMemberNotAllowedWithImplicitNotLocalThisCtor {
    var a: Data @local? = Data()
    init(y: Int64) {}
}

struct StructLocalFullMemberIsNeverAllowed {
    var a: Data @local! = Data()
}

struct StructLocalHalfMemberNotAllowedWithDefaultCtor {
    var a: Data @local? = Data()
}

struct StructLocalHalfMemberNotAllowedWithNotLocalThisCtor {
    var a: Data @local? = Data()
    init() {}
}

// Primary constructor test cases
class PrimaryCtorLocalFullMemberIsNeverAllowed {
    PrimaryCtorLocalFullMemberIsNeverAllowed(let x: Int64) {}
    var a: Data @local! = Data()
}

class PrimaryCtorLocalHalfMemberNotAllowedWithImplicitNotLocalThis {
    PrimaryCtorLocalHalfMemberNotAllowedWithImplicitNotLocalThis(let x: Int64) {}
    var a: Data @local? = Data()
}

struct StructPrimaryCtorLocalFullMemberIsNeverAllowed {
    StructPrimaryCtorLocalFullMemberIsNeverAllowed(let x: Int64) {}
    var a: Data @local! = Data()
}

struct StructPrimaryCtorLocalHalfMemberNotAllowedWithImplicitNotLocalThis {
    StructPrimaryCtorLocalHalfMemberNotAllowedWithImplicitNotLocalThis(let x: Int64) {}
    var a: Data @local? = Data()
}

main() {}

// ASSERT: scan-12 "DiagKind": "sema_expected_data_type",
// ASSERT: scan "Errors": 12,
