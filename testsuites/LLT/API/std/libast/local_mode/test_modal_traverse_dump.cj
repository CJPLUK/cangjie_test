// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler --experimental --enable-local-mode %cmp_opt_chir2hlir -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// ASSERT: regex BEGIN_FUNC[\s\S]*mode: MODAL_HALF[\s\S]*-thisParam: ThisParam[\s\S]*mode: MODAL_FULL[\s\S]*END_FUNC
// ASSERT: regex BEGIN_CALL[\s\S]*mode: MODAL_FULL[\s\S]*END_CALL
// ASSERT: regex BEGIN_PRIMITIVE_EXPR[\s\S]*mode: MODAL_FULL[\s\S]*END_PRIMITIVE_EXPR
// ASSERT: regex BEGIN_TYPE_0[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_0
// ASSERT: regex BEGIN_TYPE_1[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_1
// ASSERT: regex BEGIN_TYPE_2[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_2
// ASSERT: regex BEGIN_TYPE_3[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_3
// ASSERT: regex BEGIN_TYPE_4[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_4
// ASSERT: regex BEGIN_TYPE_5[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_5
// ASSERT: regex BEGIN_TYPE_6[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_6
// ASSERT: regex BEGIN_TYPE_7[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_7
// ASSERT: regex BEGIN_TYPE_8[\s\S]*mode: MODAL_FULL[\s\S]*END_TYPE_8
// ASSERT: scan Modal traversal and dump passed

import std.ast.*

func check(condition: Bool, message: String): Unit {
    if (!condition) { throw Exception(message) }
}

class ModalCounter <: Visitor {
    public var modals: Int64 = 0
    public var receivers: Int64 = 0
    public var stopAtFunction: Bool = false
    public var stopAtModal: Bool = false
    public override func visit(_: FuncDecl): Unit {
        if (stopAtFunction) { breakTraverse() }
    }
    public override func visit(_: ModalInfo): Unit {
        modals++
        if (stopAtModal) { breakTraverse() }
    }
    public override func visit(_: ThisParam): Unit { receivers++ }
}

func inspect(node: Node, label: String, expected: Int64): ModalCounter {
    let visitor = ModalCounter()
    node.traverse(visitor)
    check(visitor.modals == expected, "Modal visit count for ${label}: ${visitor.modals}")
    println("BEGIN_${label}")
    node.dump()
    println("END_${label}")
    visitor
}

main(): Int64 {
    let full = parseType(cangjieLex("Value @local!")).modal
    let half = parseType(cangjieLex("Value @local?")).modal
    let receiver = ThisParam()
    receiver.modal = full
    let function = FuncDecl(cangjieLex("func f() { 0 }"))
    function.modal = half
    function.thisParam = Some(receiver)
    let functionVisitor = inspect(function, "FUNC", 2)
    check(functionVisitor.receivers == 1, "FuncDecl must visit its receiver exactly once")

    let stopped = ModalCounter()
    stopped.stopAtFunction = true
    function.traverse(stopped)
    check(stopped.modals == 0 && stopped.receivers == 0, "breakTraverse must skip function children")
    let leafStopped = ModalCounter()
    leafStopped.stopAtModal = true
    function.traverse(leafStopped)
    check(leafStopped.modals == 2 && leafStopped.receivers == 1,
        "Stopping a modal leaf must not skip the function's other children")

    let call = CallExpr(cangjieLex("f()"))
    call.modal = full
    inspect(call, "CALL", 1)
    let primitive = PrimitiveTypeExpr(cangjieLex("Int64"))
    primitive.modal = full
    inspect(primitive, "PRIMITIVE_EXPR", 1)

    let types: Array<TypeNode> = [PrimitiveType(), RefType(), QualifiedType(), ParenType(), TupleType(),
        ThisType(), PrefixType(), FuncType(), VArrayType()]
    for (i in 0..types.size) {
        types[i].modal = full
        inspect(types[i], "TYPE_${i}", 1)
    }

    let empty = ModalCounter()
    parseType(cangjieLex("Value")).traverse(empty)
    check(empty.modals == 0, "Absent modal metadata must not introduce a visit")
    let notLocal = ModalCounter()
    parseType(cangjieLex("Value @~local")).traverse(notLocal)
    check(notLocal.modals == 1, "The @~local modifier must be visited")
    println("Modal traversal and dump passed")
    0
}
