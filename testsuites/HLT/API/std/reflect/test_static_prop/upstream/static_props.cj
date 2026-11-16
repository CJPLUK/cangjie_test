/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

public class SimpleStaticPropClass {
    public init() {
    }
    public static prop appName: String {
        get() {
            "MyApp"
        }
    }

    public static mut prop counter: Int64 {
        get() {
            0i64
        }
        set(v) {
        }
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

public class MutableStaticPropClass {
    public init() {
    }
    public static mut prop config: String {
        get() {
            "default"
        }
        set(v) {
        }
    }
}

public class AnnotatedStaticPropClass {
    public init() {
    }
    @Deprecated
    public static prop version: String {
        get() {
            "1.0"
        }
    }
}
