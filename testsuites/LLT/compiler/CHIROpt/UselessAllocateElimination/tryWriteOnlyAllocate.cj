// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %set_stdx_path %compiler %cangjie-stdx-import-path -L $CANGJIE_STDX_PATH -lstdx.chir -lstdx.plugin.manager --output-type=dylib input_plugin.cj -o libinput_plugin.%dylib_suffix
// EXEC: %set_stdx_path %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all --plugin=./libinput_plugin.%dylib_suffix source.cj -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4test" | compare %f

// Expand A.init into its field write so TryAllocate is only written.
// The optimized function must replace TryAllocate with a GoTo to its success block.

// ASSERT: scan-not = TryAllocate(
// ASSERT: scan-not = StoreElementRef(
// ASSERT: regex-begin %\d+: Int64 = Constant\(1i\)
// ASSERT: regex-next ^\s*GoTo\(#(?P<success>\d+)\)
// ASSERT: regex-after ^Block #(?P=success):

// SEPARATE-FILE: input_plugin.cj
package input_plugin

import std.collection.*
import stdx.chir.*
import stdx.plugin.*

@CHIRPlugin
class WriteOnlyAllocateInput {
    public override func run(pkg: Package): Bool {
        let classA = pkg.getSpecifiedClassDef(pkg.name, "A").getOrThrow()
        var changed = 0
        for (f in pkg.functions) {
            if (f.srcCodeName != "test") { continue }
            for (block in f.body.getOrThrow().blocks) {
                for (expr in block.exprs) {
                    if (let Some(call) <- (expr as TryApply) &&
                        let Some(callee) <- (call.callee as Function) &&
                        callee.isClassConstructor() && callee.srcCodeName == "init" &&
                        let Some(parent) <- callee.declaredParent && parent == classA) {
                        let args = call.getArgs()
                        let builder = CHIRBuilder(InsertPosition.Before(call))
                        builder.createStoreElementRef(args[1], args[0], ArrayList<UInt64>([0u64]))
                        builder.createGoTo(call.normalBranch)
                        call.destroySelf()
                        changed++
                    }
                }
            }
        }
        return changed == 1
    }
}

// SEPARATE-FILE: source.cj
class A {
    var value: Int64
    init(value: Int64) { this.value = value }
}

public func test() {
    try {
        let unused = A(1)
    } catch (e: Exception) {}
}

main() {
    test()
}
