/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

public interface AnotherCangjieInterface {
    public func getValue(): Int64
}

public class CangjieClassThatImplementsAnotherCangjieInterface <: AnotherCangjieInterface {
    public func getValue(): Int64 {
        114514i64
    }
}

@Java
public class JavaImplClass {
    public var value: Int64 = 114514i64

    public func getValue(): Int64 {
        this.value
    }
}

public enum CangjieEnum {
    | A
    | B
    | C

    public func foo(param0: AnotherCangjieInterface, param1!: JArray<UInt16>, param2!: Float32 = 114.514000f32): JavaImplClass {
        JavaImplClass()
    }
}
