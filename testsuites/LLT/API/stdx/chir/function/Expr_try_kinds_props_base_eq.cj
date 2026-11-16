/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f
// Try* all try-capable kinds, public getters, *Base Equatable, Lambda.paramDftValHostParam

/* SCAN
try kinds props: true
base eq: true
lambda dft host: true
try and rejected: true
getter throws: true
*/

import std.collection.*
import stdx.chir.*
import stdx.chir.Box as BoxExpr

main() {
    let i32 = IntType.getInt32()
    let boolTy = BoolType.get()
    let unit = UnitType.get()
    let i64 = IntType.getInt64()
    let pkg = Package("pkg.tryprops", AccessLevel.Public)

    let tryBinKinds = [
        BinaryExprKind.Add, BinaryExprKind.Sub, BinaryExprKind.Mul, BinaryExprKind.Div,
        BinaryExprKind.Mod, BinaryExprKind.Exp, BinaryExprKind.LShift, BinaryExprKind.RShift
    ]
    var tryOk = true
    var idx: Int64 = 0
    for (k in tryBinKinds) {
        let fn = pkg.addFunction(FuncType.get(Array<Type>(), unit), "tb${idx}", "tb${idx}", "pkg.tryprops")
        fn.initBody()
        let bg = fn.body.getOrThrow()
        let bn = bg.appendBlock()
        let be = bg.appendBlock()
        let x = Constant.create(IntLiteral.get(i32, 1u64))
        let y = Constant.create(IntLiteral.get(i32, 2u64))
        bg.entryBlock.appendExpr(x)
        bg.entryBlock.appendExpr(y)
        let tb = TryBinaryExpression.create(k, x.result, y.result, bn, be)
        bg.entryBlock.appendExpr(tb)
        tryOk = tryOk && tb.normalBranch == bn && tb.errorBranch == be
        bn.appendExpr(Exit.create())
        be.appendExpr(Exit.create())
        idx += 1
    }

    let fn = pkg.addFunction(FuncType.get([boolTy], unit), "host", "host", "pkg.tryprops")
    fn.initBody()
    let bg = fn.body.getOrThrow()
    let bb = bg.entryBlock
    let c = Constant.create(IntLiteral.get(i32, 1u64))
    bb.appendExpr(c)
    let alloc = Allocate.create(i32)
    bb.appendExpr(alloc)
    let ld = Load.create(alloc.result)
    bb.appendExpr(ld)
    tryOk = tryOk && ld.srcAddress == alloc.result

    let bt = bg.appendBlock()
    let bf = bg.appendBlock()
    let br = Branch.create(fn.parameters[0], bt, bf)
    bb.appendExpr(br)
    tryOk = tryOk && br.condition == fn.parameters[0] && br.trueTarget == bt && br.falseTarget == bf
    bt.appendExpr(Exit.create())
    bf.appendExpr(Exit.create())

    let fnMb = pkg.addFunction(FuncType.get([i32], unit), "mb", "mb", "pkg.tryprops")
    fnMb.initBody()
    let bgMb = fnMb.body.getOrThrow()
    let defB = bgMb.appendBlock()
    let t0 = bgMb.appendBlock()
    let t1 = bgMb.appendBlock()
    let targets = ArrayList<Block>()
    targets.add(t0)
    targets.add(t1)
    let cases = ArrayList<UInt64>()
    cases.add(0)
    cases.add(1)
    let mb = MultiBranch.create(fnMb.parameters[0], defB, targets, cases)
    bgMb.entryBlock.appendExpr(mb)
    tryOk = tryOk && mb.defaultTarget == defB && mb.condition == fnMb.parameters[0]
    defB.appendExpr(Exit.create())
    t0.appendExpr(Exit.create())
    t1.appendExpr(Exit.create())

    let fnRa = pkg.addFunction(FuncType.get(Array<Type>(), unit), "ra", "ra", "pkg.tryprops")
    fnRa.initBody()
    let bgRa = fnRa.body.getOrThrow()
    let nRa = bgRa.appendBlock()
    let eRa = bgRa.appendBlock()
    let sz = Constant.create(IntLiteral.get(i32, 4u64))
    bgRa.entryBlock.appendExpr(sz)
    let tra = TryRawArrayAllocate.create(i32, sz.result, nRa, eRa)
    bgRa.entryBlock.appendExpr(tra)
    tryOk = tryOk && tra.normalBranch == nRa && tra.errorBranch == eRa
    nRa.appendExpr(Exit.create())
    eRa.appendExpr(Exit.create())

    println("try kinds props: ${tryOk}")

    let fnEq = pkg.addFunction(FuncType.get(Array<Type>(), unit), "eq", "eq", "pkg.tryprops")
    fnEq.initBody()
    let bgEq = fnEq.body.getOrThrow()
    let bbEq = bgEq.entryBlock
    let n1 = bgEq.appendBlock()
    let e1 = bgEq.appendBlock()
    let cv = Constant.create(IntLiteral.get(i32, 3u64))
    bbEq.appendExpr(cv)
    let vv = cv.result
    let al = Allocate.create(i32)
    bbEq.appendExpr(al)
    let bin = BinaryExpression.create(BinaryExprKind.Add, vv, vv)
    let bin2 = BinaryExpression.create(BinaryExprKind.Mul, vv, vv)
    bbEq.appendExpr(bin)
    bbEq.appendExpr(bin2)
    let un1 = UnaryExpression.create(UnaryExprKind.Neg, vv)
    let un2 = UnaryExpression.create(UnaryExprKind.BitNot, vv)
    bbEq.appendExpr(un1)
    bbEq.appendExpr(un2)
    let nc1 = NumericCast.create(vv, i64, OverflowStrategy.NA)
    let nc2 = NumericCast.create(vv, i64, OverflowStrategy.Wrapping)
    bbEq.appendExpr(nc1)
    bbEq.appendExpr(nc2)
    let ra1 = RawArrayAllocate.create(i32, vv)
    bbEq.appendExpr(ra1)
    let sc1 = StaticCast.create(vv, i64)
    let sc2 = BoxExpr.create(vv, i64)
    bbEq.appendExpr(sc1)
    bbEq.appendExpr(sc2)
    let callee = pkg.addFunction(FuncType.get([i32], i32), "callee", "callee", "pkg.tryprops")
    callee.initBody()
    callee.body.getOrThrow().entryBlock.appendExpr(Exit.create())
    let ap1 = Apply.create(callee, FuncCallContext([vv], Array<Type>(), None))
    let ap2 = Apply.create(callee, FuncCallContext([vv], Array<Type>(), None))
    bbEq.appendExpr(ap1)
    bbEq.appendExpr(ap2)
    let ta = TryAllocate.create(i32, n1, e1)
    bbEq.appendExpr(ta)
    n1.appendExpr(Exit.create())
    e1.appendExpr(Exit.create())

    let ab1: AllocateBase = al
    let ab2: AllocateBase = ta
    let beb1: BinaryExpressionBase = bin
    let beb2: BinaryExpressionBase = bin2
    let ub1: UnaryExpressionBase = un1
    let ub2: UnaryExpressionBase = un2
    let ncb1: NumericCastBase = nc1
    let ncb2: NumericCastBase = nc2
    let rab1: RawArrayAllocateBase = ra1
    let tc1: TypeCast = sc1
    let tc2: TypeCast = sc2
    let fc1: FuncCall = ap1
    let fc2: FuncCall = ap2
    let apb1: ApplyBase = ap1
    let apb2: ApplyBase = ap2

    println(
        "base eq: ${ab1 == ab1 && !(ab1 == ab2) && beb1 == beb1 && !(beb1 == beb2) && ub1 == ub1 && !(ub1 == ub2) && ncb1 == ncb1 && !(ncb1 == ncb2) && rab1 == rab1 && tc1 == tc1 && !(tc1 == tc2) && fc1 == fc1 && !(fc1 == fc2) && apb1 == apb1 && !(apb1 == apb2)}"
    )

    let fnLam = pkg.addFunction(FuncType.get(Array<Type>(), unit), "lam", "lam", "pkg.tryprops")
    fnLam.initBody()
    let bbLam = fnLam.body.getOrThrow().entryBlock
    let hostLam = Lambda.create(FuncType.get([i32], i32), "HostLam", "", ArrayList<GenericType>())
    bbLam.appendExpr(hostLam)
    hostLam.initParameters()
    hostLam.initBody()
    hostLam.body.entryBlock.appendExpr(Exit.create())
    let child = Lambda.create(FuncType.get([i32], i32), "ChildLam", "ChildLam", ArrayList<GenericType>())
    bbLam.appendExpr(child)
    child.initParameters()
    child.initBody()
    child.body.entryBlock.appendExpr(Exit.create())
    child.paramDftValHostParam = hostLam.parameters[0]
    let got = child.paramDftValHostParam
    let dump = child.toString()
    let emptyDump = hostLam.toString()
    bbLam.appendExpr(Exit.create())
    println("lambda dft host: ${got == Some(hostLam.parameters[0]) && dump.contains("paramDftValHostParam") && emptyDump.size >= 0}")

    var rejected = false
    try {
        let fnBad = pkg.addFunction(FuncType.get(Array<Type>(), unit), "bad", "bad", "pkg.tryprops")
        fnBad.initBody()
        let bgBad = fnBad.body.getOrThrow()
        let nb = bgBad.appendBlock()
        let eb = bgBad.appendBlock()
        let bx = Constant.create(BoolLiteral.get(true))
        bgBad.entryBlock.appendExpr(bx)
        TryBinaryExpression.create(BinaryExprKind.And, bx.result, bx.result, nb, eb)
        rejected = false
    } catch (_: CHIRException) {
        rejected = true
    }
    println("try and rejected: ${rejected}")

    var throwsOk = true
    let orphan = Constant.create(IntLiteral.get(i32, 0u64))
    try {
        let unusedOwner = orphan.owner
        throwsOk = unusedOwner != unusedOwner
    } catch (_: CHIRException) {
    }
    try {
        Apply.create(orphan.result, FuncCallContext(Array<Value>(), Array<Type>(), None))
        throwsOk = false
    } catch (_: CHIRException) {
    }

    let fnTh = pkg.addFunction(FuncType.get(Array<Type>(), unit), "th", "th", "pkg.tryprops")
    fnTh.initBody()
    let bgTh = fnTh.body.getOrThrow()
    let nTh = bgTh.appendBlock()
    let eTh = bgTh.appendBlock()
    let szTh = Constant.create(IntLiteral.get(i32, 1u64))
    bgTh.entryBlock.appendExpr(szTh)
    let traTh = TryRawArrayAllocate.create(i32, szTh.result, nTh, eTh)
    bgTh.entryBlock.appendExpr(traTh)
    throwsOk = throwsOk && traTh.normalBranch == nTh
    traTh.replaceOperand(nTh, szTh.result)
    try {
        let unusedNb = traTh.normalBranch
        throwsOk = unusedNb != unusedNb
    } catch (_: CHIRException) {
    }
    traTh.replaceOperand(eTh, szTh.result)
    try {
        let unusedEb = traTh.errorBranch
        throwsOk = unusedEb != unusedEb
    } catch (_: CHIRException) {
    }

    let fnBr = pkg.addFunction(FuncType.get([boolTy], unit), "brth", "brth", "pkg.tryprops")
    fnBr.initBody()
    let bgBr = fnBr.body.getOrThrow()
    let btTh = bgBr.appendBlock()
    let bfTh = bgBr.appendBlock()
    let brTh = Branch.create(fnBr.parameters[0], btTh, bfTh)
    bgBr.entryBlock.appendExpr(brTh)
    brTh.replaceOperand(btTh, fnBr.parameters[0])
    try {
        let unusedTt = brTh.trueTarget
        throwsOk = unusedTt != unusedTt
    } catch (_: CHIRException) {
    }
    brTh.replaceOperand(bfTh, fnBr.parameters[0])
    try {
        let unusedFt = brTh.falseTarget
        throwsOk = unusedFt != unusedFt
    } catch (_: CHIRException) {
    }

    let fnTu = pkg.addFunction(FuncType.get([i32], unit), "tuth", "tuth", "pkg.tryprops")
    fnTu.initBody()
    let bgTu = fnTu.body.getOrThrow()
    let nTu = bgTu.appendBlock()
    let eTu = bgTu.appendBlock()
    let tu = TryUnaryExpression.create(fnTu.parameters[0], nTu, eTu)
    bgTu.entryBlock.appendExpr(tu)
    throwsOk = throwsOk && tu.normalBranch == nTu && tu.errorBranch == eTu
    tu.replaceOperand(nTu, fnTu.parameters[0])
    try {
        let unusedTuN = tu.normalBranch
        throwsOk = unusedTuN != unusedTuN
    } catch (_: CHIRException) {
    }
    tu.replaceOperand(eTu, fnTu.parameters[0])
    try {
        let unusedTuE = tu.errorBranch
        throwsOk = unusedTuE != unusedTuE
    } catch (_: CHIRException) {
    }
    nTu.appendExpr(Exit.create())
    eTu.appendExpr(Exit.create())

    let fnTs = pkg.addFunction(FuncType.get(Array<Type>(), unit), "tsth", "tsth", "pkg.tryprops")
    fnTs.initBody()
    let bgTs = fnTs.body.getOrThrow()
    let lamTs = Lambda.create(FuncType.get(Array<Type>(), unit), "Lts", "Lts", ArrayList<GenericType>())
    bgTs.entryBlock.appendExpr(lamTs)
    lamTs.initBody()
    lamTs.body.entryBlock.appendExpr(Exit.create())
    let nTs = bgTs.appendBlock()
    let eTs = bgTs.appendBlock()
    let ts = TrySpawn.create(unit, lamTs.result, nTs, eTs)
    bgTs.entryBlock.appendExpr(ts)
    let sp = Spawn.create(unit, lamTs.result)
    bgTs.entryBlock.appendExpr(sp)
    let sb1: SpawnBase = sp
    let sb2: SpawnBase = ts
    throwsOk = throwsOk && (sb1 == sb1) && !(sb1 == sb2) && (ts == ts)
    ts.replaceOperand(nTs, lamTs.result)
    try {
        let unusedTsN = ts.normalBranch
        throwsOk = unusedTsN != unusedTsN
    } catch (e: Exception) {
        throwsOk = throwsOk && true
    }

    println("getter throws: ${throwsOk}")
}
