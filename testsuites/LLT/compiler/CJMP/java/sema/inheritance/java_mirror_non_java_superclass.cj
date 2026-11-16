// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.JObject

open class PureCangjie {
    init() {}
}

@Java
foreign class JMirror <: PureCangjie {
}

// ASSERT: scan sema_java_mirror_cannot_inherit_pure_cangjie_type
// ASSERT: scan 'PureCangjie' is not a java-compatible type
