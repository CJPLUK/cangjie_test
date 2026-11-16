/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// DEPENDENCE: plugin_to_string_dump.cj
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler -L $CANGJIE_STDX_PATH -lstdx.chir -lstdx.plugin.manager -lstdx --import-path $CANGJIE_STDX_PATH %compile_shared_lib_opt plugin_to_string_dump.cj -o libplugin_to_string_dump.%dylib_suffix
// EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$CANGJIE_STDX_PATH:$LD_LIBRARY_PATH && %compiler %cmp_opt -Woff unused %f -o %output --plugin=./libplugin_to_string_dump.%dylib_suffix 2>&1 | compare %f
// ASSERT: scan has predecessors: true\n
// ASSERT: scan has funcKind: true\n
// ASSERT: scan has paramDftHost: true\n
// ASSERT: scan has paramDftFunc: true\n
// ASSERT: scan has propLocation: true\n
// ASSERT: scan has fastNative: true\n
// ASSERT: scan toString dump ok\n
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace
// to_string_utils：编译器 IR 经插件 pkg.toString() 覆盖 Function/Block 注释分支

open class Base {
    public var x: Int64 = 1
    public open func id(): Int64 {
        this.x
    }
    public init() {}
}

class Derived <: Base {
    public init() {
        super()
    }
    public func id(): Int64 {
        super.id() + 1
    }
    public mut prop p: Int64 {
        get() {
            this.x
        }
        set(v) {
            this.x = v
        }
    }
}

func withDefault(a: Int64, b!: Int64 = 2): Int64 {
    a + b
}

main() {
    let d = Derived()
    d.p = 3
    let n = withDefault(1)
    println(d.id() + n)
    try {
        throw Exception("e")
    } catch (e: Exception) {
        println(e)
    }
    0
}
