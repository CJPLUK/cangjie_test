/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

public class SimpleVarClass {
    public init() {
    }
    public let label: String = "default-label"

    public var count: Int64 = 0i64
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

public class MutableVarClass {
    public init() {
    }
    public var value: String = ""
}

public class AnnotatedVarClass {
    public init() {
    }
    @Deprecated
    public let info: String = "info"
}
