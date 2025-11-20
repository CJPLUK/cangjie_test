// EXEC: %compiler %enableEH %cmp_opt_chir2hlir %f -o %output
// RUN-EXEC-PIPE-0: %run %set_stdx_path %run_opt %output %run_args 2>&1 | compare %f
internal import std.ast.*

main() : Int64 {
    let tokens = quote( r: Resumption<Unit, Unit> )
    let aa = ResumptionTypePattern(tokens)
    aa.dump()
    let bb = ResumptionTypePattern()
    bb.pattern = aa.pattern
    bb.colon = aa.colon
    bb.types = aa.types
    bb.dump()

    return 0
}

/* SCAN
ResumptionTypePattern {
  -pattern: VarPattern {
    -identifier: Token {
      value: "r"
      kind: IDENTIFIER
      pos: 6: 25
    }
  }
  -colon: Token {
    value: ":"
    kind: COLON
    pos: 6: 26
  }
  -types: 0, RefType {
    -identifier: Token {
      value: "Resumption"
      kind: IDENTIFIER
      pos: 6: 28
    }
    -typeArguments: 0, PrimitiveType {
      -keyword: Token {
        value: "Unit"
        kind: UNIT
        pos: 6: 39
      }
    }
    -typeArguments: 1, PrimitiveType {
      -keyword: Token {
        value: "Unit"
        kind: UNIT
        pos: 6: 45
      }
    }
  }
}
ResumptionTypePattern {
  -pattern: VarPattern {
    -identifier: Token {
      value: "r"
      kind: IDENTIFIER
      pos: 6: 25
    }
  }
  -colon: Token {
    value: ":"
    kind: COLON
    pos: 6: 26
  }
  -types: 0, RefType {
    -identifier: Token {
      value: "Resumption"
      kind: IDENTIFIER
      pos: 6: 28
    }
    -typeArguments: 0, PrimitiveType {
      -keyword: Token {
        value: "Unit"
        kind: UNIT
        pos: 6: 39
      }
    }
    -typeArguments: 1, PrimitiveType {
      -keyword: Token {
        value: "Unit"
        kind: UNIT
        pos: 6: 45
      }
    }
  }
}
*/
