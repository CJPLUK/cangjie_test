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
// (Android) EXEC: %java %java_mirror_gen com.Init04
// (Android) ERRCHECK: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) ASSERT: scan sema_non_inheritable_super_class

package UNNAMED

import java.lang.*

// error
@Java
public class CangjieInvoke <: Init04 {
    public init() {
        let class_01 = Init04()
        var class_02 = Init04(false)
        let class_03 = Init04(1i8)
        var class_04 = Init04(0i16)
        let class_05 = Init04(-1i32)
        var class_06 = Init04(1) //1i64?
        let class_07 = Init04(1u16)
        var class_08 = Init04(3.14f32)
        let class_09 = Init04(3.14) // 3.14f64
    }
}
