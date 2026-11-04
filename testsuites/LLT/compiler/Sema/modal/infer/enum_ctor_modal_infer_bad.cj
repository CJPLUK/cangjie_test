// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
// ERRCHECK: %frontendCompiler %local %f -Woff all %diag_json 2>&1

open class C {
    init() {}
    init(this @local!) { exclave { } }
}

// The result mode of an enum constructor call follows the expected type, which must not make an
// argument whose own mode does not fit the constructor parameter acceptable.
func notLocalArg(c: C @~local) {
    let v: ?C @local! = Some(c)
}

// The modal written at the call site is adopted only when it is a submodal of the expected mode:
// @local? is the join of @local! and @~local, hence not a submodal of the expected @local! here.
func halfCtorCall() {
    let v: ?Int64 @local! = Some(1) @local?
}

// @local! and @~local are not comparable, so this call cannot satisfy the expected mode either.
func fullCtorCallToNotTarget() {
    let v: ?Int64 = Some(1) @local!
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_mismatched_types",
// ASSERT: scan-1 "DiagKind": "sema_unable_to_infer_generic_func",
// ASSERT: scan "Errors": 3,
