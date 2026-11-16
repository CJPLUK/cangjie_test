/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */


// EXEC: %compiler %cmp_opt_chir2hlir %coverage_opt %f -o %output
// RUN-EXEC: %run %run_opt %output | compare %f

internal import std.ast.{ClassDecl, Annotation}

main() {
    let classDecl = ClassDecl(quote(
        @Attribute[a0, a1, a2] class A<T> where T <: Hashable {}
    ))
    classDecl.annotations.add(Annotation(quote(@!Anno)))
    classDecl.dump()
    classDecl.toTokens() |> println
    let toks = classDecl.getAttrs()
    toks.dump()
    classDecl.hasAttr("a0") |> println
    classDecl.hasAttr("a1") |> println
    classDecl.hasAttr("a2") |> println
}

// ASSERT: scan ClassDecl {
// ASSERT: scan -annotations: 0, Annotation {
// ASSERT: scan -identifier: Attribute
// ASSERT: scan -attributes: 0,     a0: Token {
// ASSERT: scan value: "a0"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -attributes: 1,     a1: Token {
// ASSERT: scan value: "a1"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -attributes: 2,     a2: Token {
// ASSERT: scan value: "a2"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -annotations: 1, Annotation {
// ASSERT: scan -identifier: Anno
// ASSERT: scan -keyword: Token {
// ASSERT: scan value: "class"
// ASSERT: scan kind: CLASS
// ASSERT: scan -identifier: Token {
// ASSERT: scan value: "A"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -genericParam: GenericParam {
// ASSERT: scan -parameters: 0, T: Token {
// ASSERT: scan value: "T"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -genericConstraint: 0, GenericConstraint {
// ASSERT: scan -keyword: Token {
// ASSERT: scan value: "where"
// ASSERT: scan kind: WHERE
// ASSERT: scan -typeArgument: RefType {
// ASSERT: scan -identifier: Token {
// ASSERT: scan value: "T"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -upperBound: Token {
// ASSERT: scan value: "<:"
// ASSERT: scan kind: UPPERBOUND
// ASSERT: scan -upperBounds: 0, RefType {
// ASSERT: scan -identifier: Token {
// ASSERT: scan value: "Hashable"
// ASSERT: scan kind: IDENTIFIER
// ASSERT: scan -body: Body {
// ASSERT: scan @Attribute[a0, a1, a2]
// ASSERT: scan @!Anno
// ASSERT: scan class A < T > where T <: Hashable {
// ASSERT: scan description: identifier, token_id: 137, token_literal_value: a0
// ASSERT: scan description: identifier, token_id: 137, token_literal_value: a1
// ASSERT: scan description: identifier, token_id: 137, token_literal_value: a2
// ASSERT: scan true
// ASSERT: scan true
// ASSERT: scan true
