// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

/*
  @Name:            01_03_06_a09_056

  @Level:         1

  @Assertion:       1.3.6(9) The syntax of the multi-line string literal is:
                       multiLineStringLiteral
                           : '"""' NL (multiLineStringExpression | multiLineStringContent)* '"""'
                           ;
                       multiLineStringExpression
                           : '${' end* (expressionOrDeclaration (end+ expressionOrDeclaration?)*) end* '}'
                           ;
                       multiLineStringContent
                           : MultiLineStrText
                           ;
                       MultiLineStrText
                           : ~('\\')
                           | EscapeSeq ;

  @Description:     Check positive cases of `end` in a multiLineStringExpression: after an opening brace, before a
                    closing brace, and as an expression (or declaration) separator.

  @Mode:            run
  @Negative:        no
  @Structure:       single
 */

import utils.assert.Assert

main() {
    Assert.equals("Check zero `end` at start and end", """
${"Check zero `end` at start and end"}""")

    Assert.equals("Check NL at start", """
${"Check NL at start"}""")

    Assert.equals("Check SEMI at start", """
${"Check SEMI at start"}""")

    Assert.equals("Check NL+NL at start", """
${"Check NL+NL at start"}""")

    Assert.equals("Check NL+SEMI at start", """
${"Check NL+SEMI at start"}""")

    Assert.equals("Check SEMI+NL at start", """
${"Check SEMI+NL at start"}""")

    Assert.equals("Check SEMI+SEMI at start", """
${"Check SEMI+SEMI at start"}""")

    Assert.equals("Check SEMI+SEMI with spaces at start", """
${"Check SEMI+SEMI with spaces at start"}""")

    Assert.equals("Check NL at end", """
${"Check NL at end"}""")

    Assert.equals("Check SEMI at end", """
${"Check SEMI at end";}""")

    Assert.equals("Check NL+NL at end", """
${"Check NL+NL at end"}""")

    Assert.equals("Check NL+SEMI at end", """
${"Check NL+SEMI at end";}""")

    Assert.equals("Check SEMI+NL at end", """
${"Check SEMI+NL at end";}""")

    Assert.equals("Check SEMI+SEMI at end", """
${"Check SEMI+SEMI at end";}""")

    Assert.equals("Check SEMI+SEMI with spaces at end", """
${"Check SEMI+SEMI with spaces at end";}""")

    var a = 0
    // Check NL as an expression separator.
    Assert.equals("1", """
${
    a++
    a
}""")

    // Check SEMI as an expression separator.
    Assert.equals("2", """
${
    let a = 2;
    a
}""")

    // Check NL+NL as an expression separator.
    Assert.equals("3", """
${
    a << 3
    3
}""")

    // Check NL+SEMI as an expression separator.
    Assert.equals("4", """
${
    a *= 4
    a
}""")

    // Check SEMI+NL as an expression separator.
    Assert.equals("5", """
${
    func f() {
        1
    };
    a + f()
}""")

    // Check SEMI+SEMI as an expression separator.
    Assert.equals("2", """
${
    """
${a}""";
    2
}""")

    // Complex case.
    Assert.equals("3\n7\n", """
${
    let a = """
    ${let a = ""}""";
    func one() {
        1
    };
    func two() {
        2
    };
    one() + two();
    func three() {
        one() + two()
    }
    three()
}
${
    a++;
    a++;
    a++;
    a
}
""")
}
