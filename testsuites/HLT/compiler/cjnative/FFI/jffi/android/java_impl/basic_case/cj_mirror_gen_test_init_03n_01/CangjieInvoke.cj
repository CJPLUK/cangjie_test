/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (Android) DEPENDENCE: com  
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %java %java_mirror_gen com.Init03

// (Android) ERRCHECK: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) ASSERT: scan sema_

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let class_01 = Init03(1, 1)
    }
}
