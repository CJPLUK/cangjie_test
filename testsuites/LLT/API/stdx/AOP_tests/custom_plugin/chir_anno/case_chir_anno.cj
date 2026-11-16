/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// DEPENDENCE: plugin_chir_anno.cj
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler -L $CANGJIE_STDX_PATH -lstdx.chir -lstdx.plugin.manager -lstdx --import-path $CANGJIE_STDX_PATH %compile_shared_lib_opt plugin_chir_anno.cj -o libplugin_chir_anno.%dylib_suffix
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$CANGJIE_STDX_PATH:$LD_LIBRARY_PATH && %compiler %cmp_opt -Woff unused %f -o %output --plugin=./libplugin_chir_anno.%dylib_suffix 2>&1 | compare %f
// ASSERT: scan has checkTypeCast: true\n
// ASSERT: scan has GeneratedFromForIn: true\n
// ASSERT: scan has skip dce: true\n
// ASSERT: scan has skip forin: true\n
// ASSERT: scan has linkType external: true\n
// ASSERT: scan has linkType internal: true\n
// ASSERT: scan has linkType weak_odr: true\n
// ASSERT: scan has warning loc: true\n
// ASSERT: scan has sourceExpr IfExpr: true\n
// ASSERT: scan has sourceExpr WhileExpr: true\n
// ASSERT: scan has sourceExpr MatchExpr: true\n
// ASSERT: scan has sourceExpr ForInExpr: true\n
// ASSERT: scan has sourceExpr Binary: true\n
// ASSERT: scan has sourceExpr Quest: true\n
// ASSERT: scan user ext linkage: 3\n
// ASSERT: scan user non-ext linkage: 9\n
// ASSERT: scan closure types: 0\n
// ASSERT: scan chir anno probe ok\n
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

open class Base {
    public open func id(): Int64 {
        1
    }
}

class Derived <: Base {
    public func id(): Int64 {
        2
    }
}

enum Color {
    | Red
    | Green(Int64)
}

main() {
    var arr = [1, 2, 3]
    let idx: Int64 = 1
    let x = arr[idx]
    arr[0] = x

    let b: Base = Derived()
    let d = (b as Derived).getOrThrow()

    var sum = 0
    for (e in arr) {
        sum += e
    }
    for (i in 0..2) {
        sum += i
    }

    var i = 0
    while (i < 1) {
        i += 1
    }
    if (sum > 0) {
        sum += 1
    } else {
        sum -= 1
    }

    let c = Color.Green(3)
    match (c) {
        case Red => ()
        case Green(v) => sum += v
    }

    let opt: ?Int64 = 1
    let q = opt ?? 0
    println(sum + d.id() + q)
    0
}
