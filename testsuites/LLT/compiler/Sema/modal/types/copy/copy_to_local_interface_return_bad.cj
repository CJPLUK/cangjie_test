// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %diag_json %f --error-count-limit 20 -Woff all -o %output 2>&1

interface I {}
struct S <: Copyable & I {}
func explicitFull(x: S @~local): I @local! { return x }
func explicitHalf(x: S @~local): I @local? { return x }
func implicitFull(): I @local! {
    let x: S @~local = S()
    x
}
func implicitHalf(): I @local? {
    let x: S @~local = S()
    x
}
func primitiveFull(x: Int64 @~local): ToString @local! { x }
func primitiveHalf(x: Int64 @~local): ToString @local? { x }
func optionalFull(x: S): ?I @local! { x }
func optionalHalf(x: S): ?I @local? { x }
func nestedFull(x: S): ??I @local! { x }
func nestedHalf(x: S): ??I @local? { x }
main() {}

// ASSERT: scan-10 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 10,
