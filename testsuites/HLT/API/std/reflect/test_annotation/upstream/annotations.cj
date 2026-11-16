/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package upstream

@Deprecated
public class AnnotatedClass {
    public init() {
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

public class AnnotatedMembersClass {
    public init() {
    }
    @Deprecated
    public func annotatedFunc(): Unit {
    }

    @Deprecated
    public var annotatedVar: Int64 = 0i64
}

public class NoAnnotationClass {
    public init() {
    }
}
