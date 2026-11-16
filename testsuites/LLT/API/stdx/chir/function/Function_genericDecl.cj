/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: sourceFile/generic_decl_source.cj
// Emit with specialization enabled so identity<Int64> has a generic declaration.
// EXEC: %compiler %cmp_opt -O2 --emit-chir=raw --output-type=staticlib generic_decl_source.cj -o generic_decl_source.chir
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f

/* SCAN
constructed declaration absent: true
instantiated declaration: true
ordinary declaration absent: true
template declaration absent: true
*/

import std.fs.*
import stdx.chir.*

main() {
    let created = Package("demo", AccessLevel.Public)
    let function = created.addFunction(FuncType.get([], UnitType.get()), "f_m", "f", "demo")
    println("constructed declaration absent: ${function.genericDecl.isNone()}")

    let bytes = File.readFrom("generic_decl_source.chir")
    let pkg = unsafe {
        let raw = acquireArrayRawData(bytes)
        let result = deserializePackage(CPointer<UInt8>(raw.pointer), bytes.size)
        releaseArrayRawData(raw)
        result
    }
    let functions = pkg.functions.filter({ f => f.packageName == pkg.name })
    let declaration = functions.filter({ f => f.srcCodeName == "identity" && !f.genericTypeParams.isEmpty() })[0]
    let instance = functions.filter({ f => f.srcCodeName == "identity" && f.genericDecl.isSome() })[0]
    let ordinary = functions.filter({ f => f.srcCodeName == "main" })[0]
    println("instantiated declaration: ${instance.genericDecl.getOrThrow() == declaration}")
    println("ordinary declaration absent: ${ordinary.genericDecl.isNone()}")
    println("template declaration absent: ${declaration.genericDecl.isNone()}")
}
