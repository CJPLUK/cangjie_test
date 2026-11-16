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
    private prop privprop: String {
        get() { "" }
    }

    public prop pubprop: String {
        get() { privprop }
    }

    internal prop interprop: String {
        get() { privprop }
    }

    protected prop protprop: String {
        get() { privprop }
    }

    // Checks mutable properties
    private mut prop mutprivprop: String {
        get() { "" }
        set(s) { println(s) }
    }

    public mut prop mutpubprop: String {
        get() { privprop }
        set(s) { println(s) }
    }

    internal mut prop mutinterprop: String {
        get() { privprop }
        set(s) { println(s) }
    }

    protected mut prop mutprotprop: String {
        get() { privprop }
        set(s) { println(s) }
    }
}
