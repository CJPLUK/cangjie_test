/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

public class SimplePropClass {
    public init() {
    }
    public prop label: String {
        get() {
            "default-label"
        }
    }

    private var _count: Int64 = 0i64

    public mut prop count: Int64 {
        get() {
            this._count
        }
        set(v) {
            this._count = v
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

public class MutablePropClass {
    public init() {
    }
    private var _value: String = ""

    public mut prop value: String {
        get() {
            this._value
        }
        set(v) {
            this._value = v
        }
    }
}

public class AnnotatedPropClass {
    public init() {
    }
    @Deprecated
    public prop info: String {
        get() {
            "info"
        }
    }
}
