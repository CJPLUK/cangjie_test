/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: printf 'package initializer_sample\npublic func initialize(): Int64 { 42 }\npublic let value = initialize()\n' > initializer_source.cj
// EXEC: %compiler %cmp_opt --emit-chir=raw --output-type=staticlib initializer_source.cj -o initializer_source.chir
// EXEC: printf 'main() {}\n' > no_initializers_source.cj
// EXEC: %compiler %cmp_opt --emit-chir=raw --output-type=staticlib no_initializers_source.cj -o no_initializers_source.chir
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f

/* SCAN
initializer target: true
no variable initializers: true
non-package function rejected: true
*/

import std.fs.*
import stdx.chir.*

func loadPackage(path: String): Package {
    let bytes = File.readFrom(path)
    return unsafe {
        let raw = acquireArrayRawData(bytes)
        let result = deserializePackage(CPointer<UInt8>(raw.pointer), bytes.size)
        releaseArrayRawData(raw)
        result
    }
}

main() {
    let pkg = loadPackage("initializer_source.chir")
    let variable = pkg.globalVars.filter({ v => v.srcCodeName == "value" })[0]
    let call = (pkg.packageInitFunc.getOrThrow().getFirstInitializerCall().getOrThrow() as Apply).getOrThrow()
    // The package initializer calls the file initializer, which calls the variable initializer.
    let fileInitializer = (call.callee as Function).getOrThrow()
    let calls = fileInitializer.body.getOrThrow().entryBlock.exprs.filter({ expr => (expr as Apply).isSome() })
    let variableCall = (calls[0] as Apply).getOrThrow()
    println("initializer target: ${variableCall.callee == variable.initializer.getOrThrow()}")

    let noInitializers = loadPackage("no_initializers_source.chir")
    println("no variable initializers: ${noInitializers.packageInitFunc.getOrThrow().getFirstInitializerCall().isNone()}")

    let mainFunction = noInitializers.functions.filter({ fn => fn.srcCodeName == "main" && fn.packageName == noInitializers.name })[0]
    var rejected = false
    try {
        mainFunction.getFirstInitializerCall()
    } catch (e: CHIRException) {
        rejected = e.message.contains("only available on the package initialization function")
    }
    println("non-package function rejected: ${rejected}")
}
