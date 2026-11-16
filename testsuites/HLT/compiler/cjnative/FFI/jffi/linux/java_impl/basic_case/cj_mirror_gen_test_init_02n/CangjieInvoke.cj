/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: com
// (Android) EXEC: %javac com/*.java
// (Android) EXEC: %java %java_mirror_gen com.Init02
// (Android) ERRCHECK: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) ASSERT: scan sema_mismatched_types

package UNNAMED

import java.lang.*

@Java["CangjieInvoke"]
public class CangjieInvoke <: JObject {
    public init() {
        let class_01 = Init02(true, "")
    }
}
