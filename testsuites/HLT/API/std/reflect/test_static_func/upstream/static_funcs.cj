/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

public class SimpleStaticClass {
    public init() {
    }
    public static func staticAdd(a: Int64, b: Int64): Int64 {
        a + b
    }

    public static func staticGreet(name: String): String {
        "Hi " + name
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

public class MultiStaticClass {
    public init() {
    }
    public static func multiply(a: Int64, b: Int64, c: Int64): Int64 {
        a * b * c
    }

    public static func concat(a: String, b: String): String {
        a + b
    }
}

public class AnnotatedStaticClass {
    public init() {
    }
    @Deprecated
    public static func deprecatedStatic(): Unit {
    }
}
