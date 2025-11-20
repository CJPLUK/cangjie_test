// EXEC: %compiler %enableEH %cmp_opt_chir2hlir %f -o %output
// RUN-EXEC-PIPE-0: %run %set_stdx_path %run_opt %output %run_args 2>&1 | compare %f
internal import std.ast.*

main() : Int64 {
    let tokens = quote( resume throwing bla )
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
  -keywordT: Token {
    value: "throwing"
    kind: THROWING
    pos: 6: 32
  }
  -throwingExpr: RefExpr {
    -identifier: Token {
      value: "bla"
      kind: IDENTIFIER
      pos: 6: 41
    }
  }
}
ResumeExpr {
  -keywordR: Token {
    value: "resume"
    kind: RESUME
    pos: 6: 25
  }
  -keywordT: Token {
    value: "throwing"
    kind: THROWING
    pos: 6: 32
  }
  -throwingExpr: RefExpr {
    -identifier: Token {
      value: "bla"
      kind: IDENTIFIER
      pos: 6: 41
    }
  }
}
*/
