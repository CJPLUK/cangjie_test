/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

public class SimpleFuncClass {
    public var value: Int64 = 0i64

    public init() {
    }
    public func getValue(): Int64 {
        this.value
    }

    public func setValue(v: Int64): Unit {
        this.value = v
    }
}

public class HelperClass {
    public init() {
    }
}

public struct HelperStruct {
    public var x: Int64 = 0i64

    public init() {
    }
}

public class MultiFuncClass {
    public init() {
    }
    public func add(a: Int64, b: Int64): Int64 {
        a + b
    }

    public func greet(name: String): String {
        "Hello " + name
    }
}

public class AnnotatedFuncClass {
    public init() {
    }
    @Deprecated
    public func deprecatedMethod(): Unit {
    }
}

public class GenericFuncClass {
    public init() {
    }
    public func identity<T>(x: T): T {
        x
    }
}
