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
// (Android) EXEC: %java %java_mirror_gen com.Init03
// (Android) ERRCHECK: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) ASSERT: scan sema_wrong_number_of_arguments

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: Init03 {
    public init() {
        let class_01 = Init03(1, 1, 1)
    }
}
