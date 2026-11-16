// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

// ASSERT: scan-not error

// info: checks that declaration order (mirror is before impl and vice versa) does not matter

import java.lang.JObject

@Java
open foreign class M {
    init(a: Bool)
    init()
}

@Java
class A <: M {
    A() {
        super()
    }
}

// MMI is declared above MM
@Java
class MMI <: MM {
    init() {
    }
}

// MMM is declared above MM
@Java
foreign class MMM <: MM {
    init()
}

@Java
open foreign class MM {
    init(a: Bool)
    init()
}

// B is declared below MM
@Java
class B <: MM {
    B() {
        super()   
    }
}
