/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f
// GlobalValue 可见谓词与 set*；GlobalVar initializer / setInitializer；Function 基础属性

/* SCAN
gv ro: true init lit: true
gv str has id: true
fn public abstract: true true
fn has body: true params: 1
linkage defaults: true true
linkage repeated: true
linkage transitions: true
*/

import stdx.chir.*

main() {
    let pkg = Package("pkg.gv", AccessLevel.Public)
    let i32 = IntType.getInt32()
    let gv = pkg.addGlobalVar(i32, "g1", "g1", "pkg.gv")
    gv.setReadOnly(true)
    gv.setInitializer(IntLiteral.get(i32, 1u64))
    println("gv ro: ${gv.isReadOnly()} init lit: ${gv.initializer.getOrThrow().isLiteral()}")
    println("gv str has id: ${gv.toString().contains("g1")}")

    let ft = FuncType.get(Array<Type>(1, { _ => i32 }), i32)
    let fn = pkg.addFunction(ft, "f1", "f1", "pkg.gv")
    fn.setPublic()
    fn.setAbstract(true)
    println("fn public abstract: ${fn.isPublic()} ${fn.isAbstract()}")
    fn.initBody()
    println("fn has body: ${fn.body.isSome()} params: ${fn.parameters.size}")

    println("linkage defaults: ${gv.isExternalLinkage()} ${fn.isExternalLinkage()}")
    let values: Array<GlobalValue> = [fn, gv]
    let linkages = [LinkType.External, LinkType.ExternalWeak, LinkType.Internal, LinkType.LinkonceOdr, LinkType.WeakOdr]
    var transitions = true
    var repeated = true
    for (value in values) {
        for (previous in linkages) {
            for (item in linkages) {
                value.setLinkageType(previous)
                value.setLinkageType(item)
                let text = value.toString()
                transitions = transitions && (value.isExternalLinkage() == (item == LinkType.External))
                for (candidate in linkages) {
                    transitions = transitions && (text.contains("linkType: ${candidate},") == (item == candidate))
                }
                value.setLinkageType(item)
                repeated = repeated && value.toString() == text
            }
        }
    }
    println("linkage repeated: ${repeated}")
    println("linkage transitions: ${transitions}")
}
