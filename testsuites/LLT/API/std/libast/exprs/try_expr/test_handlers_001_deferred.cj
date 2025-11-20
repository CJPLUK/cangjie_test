// EXEC: %compiler %enableEH %cmp_opt_chir2hlir %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output %run_args | compare %f

internal import std.ast.*
internal import std.collection.*

main(): Int64 {
    let tokens = quote(
        try {
            let lastElement = arrayTest[3]
        } handle(e: Eff, next: Resumption<Unit, Unit>) {
            print("exception info:" + e)
        }
    )
    let aa = TryExpr(tokens)
    aa.dump()

    return 0
}

/* SCAN
TryExpr {
  -keywordT: Token {
    value: "try"
    kind: TRY
    pos: 9: 9
  }
  -tryBlock: Block {
    -nodes: 0, VarDecl {
      -keyword: Token {
        value: "let"
        kind: LET
        pos: 10: 13
      }
      -identifier: Token {
        value: "lastElement"
        kind: IDENTIFIER
        pos: 10: 17
      }
      -assign: Token {
        value: "="
        kind: ASSIGN
        pos: 10: 29
      }
      -expr: SubscriptExpr {
        -baseExpr: RefExpr {
          -identifier: Token {
            value: "arrayTest"
            kind: IDENTIFIER
            pos: 10: 31
          }
        }
        -indexList: 0, LitConstExpr {
          -literal: Token {
            value: "3"
            kind: INTEGER_LITERAL
            pos: 10: 41
          }
        }
      }
    }
  }
  -keywordsH: 0, Token {
    value: "handle"
    kind: HANDLE
    pos: 11: 11
  }
  -commandPattern: 0, CommandTypePattern {
    -pattern: VarPattern {
      -identifier: Token {
        value: "e"
        kind: IDENTIFIER
        pos: 11: 18
      }
    }
    -colon: Token {
      value: ":"
      kind: COLON
      pos: 11: 19
    }
    -types: 0, RefType {
      -identifier: Token {
        value: "Eff"
        kind: IDENTIFIER
        pos: 11: 21
      }
    }
  }
  -resumptionPattern: 0, ResumptionTypePattern {
    -pattern: VarPattern {
      -identifier: Token {
        value: "next"
        kind: IDENTIFIER
        pos: 11: 26
      }
    }
    -colon: Token {
      value: ":"
      kind: COLON
      pos: 11: 30
    }
    -types: 0, RefType {
      -identifier: Token {
        value: "Resumption"
        kind: IDENTIFIER
        pos: 11: 32
      }
      -typeArguments: 0, PrimitiveType {
        -keyword: Token {
          value: "Unit"
          kind: UNIT
          pos: 11: 43
        }
      }
      -typeArguments: 1, PrimitiveType {
        -keyword: Token {
          value: "Unit"
          kind: UNIT
          pos: 11: 49
        }
      }
    }
  }
  -handleBlocks: 0, Block {
    -nodes: 0, CallExpr {
      -callFunc: RefExpr {
        -identifier: Token {
          value: "print"
          kind: IDENTIFIER
          pos: 12: 13
        }
      }
      -arguments: 0, Argument {
        -expr: BinaryExpr {
          -leftExpr: LitConstExpr {
            -literal: Token {
              value: "exception info:"
              kind: STRING_LITERAL
              pos: 12: 19
            }
          }
          -op: Token {
            value: "+"
            kind: ADD
            pos: 12: 37
          }
          -rightExpr: RefExpr {
            -identifier: Token {
              value: "e"
              kind: IDENTIFIER
              pos: 12: 39
            }
          }
        }
      }
    }
  }
}
*/
