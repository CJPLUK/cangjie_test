/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt_chir2hlir %coverage_opt %f -o %output
// EXEC: %run %run_opt %output | compare %f

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

/* SCAN
ClassDecl {
  -annotations: 0, Annotation {
    -identifier: Attribute
    -attributes: 0,     a0: Token {
      value: "a0"
      kind: IDENTIFIER
    }
    -attributes: 1,     a1: Token {
      value: "a1"
      kind: IDENTIFIER
    }
    -attributes: 2,     a2: Token {
      value: "a2"
      kind: IDENTIFIER
    }
  }
  -annotations: 1, Annotation {
    -identifier: Anno
  }
  -keyword: Token {
    value: "class"
    kind: CLASS
    pos: 16: 32
  }
  -identifier: Token {
    value: "A"
    kind: IDENTIFIER
    pos: 16: 38
  }
  -genericParam: GenericParam {
    -parameters: 0, T: Token {
      value: "T"
      kind: IDENTIFIER
      pos: 16: 40
    }
  }
  -genericConstraint: 0, GenericConstraint {
    -keyword: Token {
      value: "where"
      kind: WHERE
      pos: 16: 43
    }
    -typeArgument: RefType {
      -identifier: Token {
        value: "T"
        kind: IDENTIFIER
        pos: 16: 49
      }
    }
    -upperBound: Token {
      value: "<:"
      kind: UPPERBOUND
      pos: 16: 51
    }
    -upperBounds: 0, RefType {
      -identifier: Token {
        value: "Hashable"
        kind: IDENTIFIER
        pos: 16: 54
      }
    }
  }
  -body: Body {
  }
}
@Attribute[a0, a1, a2]
@!Anno
class A < T > where T <: Hashable {
}

description: identifier, token_id: 137, token_literal_value: a0, fileID: 16, line: 178, column: 22
description: identifier, token_id: 137, token_literal_value: a1, fileID: 16, line: 178, column: 22
description: identifier, token_id: 137, token_literal_value: a2, fileID: 16, line: 178, column: 22
true
true
true
*/
