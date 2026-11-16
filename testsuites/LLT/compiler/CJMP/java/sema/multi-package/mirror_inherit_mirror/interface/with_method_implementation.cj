// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ./I.cj
// (CJNATIVE and not Windows) EXEC-0: %compiler %cmp_opt ./I.cj %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L. -li

package n

import java.lang.JObject
import i.I

@Java
open foreign class N <: I {
    public open func foo(): Unit
}
