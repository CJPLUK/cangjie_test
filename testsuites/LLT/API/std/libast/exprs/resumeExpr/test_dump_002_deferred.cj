// EXEC: %compiler %enableEH %cmp_opt_chir2hlir %f -o %output
// RUN-EXEC-PIPE-0: %run %set_stdx_path %run_opt %output %run_args 2>&1 | compare %f
internal import std.ast.*

main() : Int64 {
    let tokens = quote( resume next with bla )
    let aa = ResumeExpr(tokens)
    aa.dump()
    let bb = ResumeExpr()
    bb.keywordR = aa.keywordR
    bb.expr = aa.expr
    bb.keywordW = aa.keywordW
    bb.withExpr = aa.withExpr
    bb.keywordT = aa.keywordT
    bb.throwingExpr = aa.throwingExpr
    bb.dump()
    return 0
}

/* SCAN
ResumeExpr {
  -keywordR: Token {
    value: "resume"
    kind: RESUME
    pos: 6: 25
  }
  -expr: RefExpr {
    -identifier: Token {
      value: "next"
      kind: IDENTIFIER
      pos: 6: 32
    }
  }
  -withExpr: RefExpr {
    -identifier: Token {
      value: "bla"
      kind: IDENTIFIER
      pos: 6: 42
    }
  }
}
ResumeExpr {
  -keywordR: Token {
    value: "resume"
    kind: RESUME
    pos: 6: 25
  }
  -expr: RefExpr {
    -identifier: Token {
      value: "next"
      kind: IDENTIFIER
      pos: 6: 32
    }
  }
  -withExpr: RefExpr {
    -identifier: Token {
      value: "bla"
      kind: IDENTIFIER
      pos: 6: 42
    }
  }
}
*/
