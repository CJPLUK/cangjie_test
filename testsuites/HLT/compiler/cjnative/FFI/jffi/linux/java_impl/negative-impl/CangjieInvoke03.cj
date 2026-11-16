/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com 
// (Android) EXEC: %java %java_mirror_gen com.Init01
// (Android) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=. 2>&1 | compare %f
// (Android) ASSERT: scan parse_java_impl_cannot_have_static_init

package UNNAMED

import java.lang.*

@Java["CangjieInvoke"]
public class CangjieInvoke <: JObject {
    public init() {
        let class_01 = Init01()
    }

    public static func cjFoo() {}

    static init() {}
}
