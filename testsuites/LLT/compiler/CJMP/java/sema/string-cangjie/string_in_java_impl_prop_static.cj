// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import java.lang.*

@Java
class M {
    // Checks that properties can be of String type
    private static prop privprop: String {
        get() { "" }
    }

    public static prop pubprop: String {
        get() { privprop }
    }

    internal static prop interprop: String {
        get() { privprop }
    }

    protected static prop protprop: String {
        get() { privprop }
    }

    // Checks mutable properties
    private static mut prop mutprivprop: String {
        get() { "" }
        set(s) { println(s) }
    }

    public static mut prop mutpubprop: String {
        get() { privprop }
        set(s) { println(s) }
    }

    internal static mut prop mutinterprop: String {
        get() { privprop }
        set(s) { println(s) }
    }

    protected static mut prop mutprotprop: String {
        get() { privprop }
        set(s) { println(s) }
    }
}
