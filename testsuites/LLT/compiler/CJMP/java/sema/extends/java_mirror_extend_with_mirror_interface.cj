// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.JObject

@Java
public foreign class MyObject {

}

@Java
public foreign interface MyInterface {
    func foo(): Unit
}

extend MyObject <: MyInterface {
    public func foo(): Unit {

    }
}

// ASSERT: scan java_mirror_extend_with_mirror_interface
