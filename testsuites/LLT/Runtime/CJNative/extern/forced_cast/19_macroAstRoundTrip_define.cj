// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package forced_cast_macro

import std.ast.*

class ForcedCastOperandRewriter <: Visitor {
    public override func visit(forced: AmbiguousForcedCastExpr): Unit {
        forced.expr = RefExpr(quote(e))
    }
}

public macro DeclRoundTrip(input: Tokens): Tokens {
    quote($(parseDecl(input)))
}

public macro ExprRoundTrip(input: Tokens): Tokens {
    quote($(parseExpr(input)))
}

// Converts an arbitrary expression into a forced-cast-shaped AST by replacing
// the operand of a freshly parsed AmbiguousForcedCastExpr.
public macro MakeForcedCast(input: Tokens): Tokens {
    let forced = AmbiguousForcedCastExpr(quote((Int64)placeholder))
    forced.expr = parseExpr(input)
    quote($(forced))
}

// Converts an AmbiguousForcedCastExpr back to its ordinary operand expression.
public macro StripForcedCast(input: Tokens): Tokens {
    let forced = (parseExpr(input) as AmbiguousForcedCastExpr).getOrThrow()
    quote($(forced.expr))
}

// Mutates the operand while retaining the forced-cast node itself.
public macro WrapForcedCastOperand(input: Tokens): Tokens {
    let forced = (parseExpr(input) as AmbiguousForcedCastExpr).getOrThrow()
    forced.expr = ParenExpr(quote(($(forced.expr))))
    quote($(forced))
}

// Replaces the type child independently from the operand child.
public macro RetargetForcedCast(input: Tokens): Tokens {
    let forced = (parseExpr(input) as AmbiguousForcedCastExpr).getOrThrow()
    let intCast = AmbiguousForcedCastExpr(quote((Int64)placeholder))
    forced.targetType = intCast.targetType
    quote($(forced))
}

// Exercises Visitor dispatch and mutation rather than accessing the root node
// through a direct cast in the macro implementation.
public macro RewriteForcedCastWithVisitor(input: Tokens): Tokens {
    let expr = parseExpr(input)
    expr.traverse(ForcedCastOperandRewriter())
    quote($(expr))
}
