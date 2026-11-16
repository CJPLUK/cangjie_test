/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

@Java
public class JavaImplClass {
    public var value: Int64 = 114514i64

    public func getValue(): Int64 {
        this.value
    }
}

public class CangjieClass {
    public func foo(param0: Int64, param1!: JArray<Int16>, param2!: JArray<Float32> = JArray<Float32>(114514i32)): JavaImplClass {
        JavaImplClass()
    }
}
