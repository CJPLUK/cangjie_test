// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ./A.cj
// (CJNATIVE and not Windows) EXEC-0: %compiler %cmp_opt ./A.cj %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L. -la

package n

import java.lang.JObject
import a.A

@Java
class N <: A {
    init() {}
    public func foo(): Unit {}
}
