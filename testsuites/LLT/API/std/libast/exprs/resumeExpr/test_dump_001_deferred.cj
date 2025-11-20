// EXEC: %compiler %enableEH %cmp_opt_chir2hlir %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output

internal import std.ast.*
internal import std.collection.*

class MyVisitor <: Visitor {
    var num = 0
    override public func visit(curNode: ResumeExpr) {
        num++
    }
}

let myVisitor = MyVisitor()

main(): Int64 {
    let input = quote(
        resume next with 42
    )
    let te = parseExpr(input)
    let flag = compareTokens(input, te.toTokens())
    if (!flag) {
        return 1
    }
    te.traverse(myVisitor)
    if (myVisitor.num != 1) {
        return 2
    }
    return 0
}
