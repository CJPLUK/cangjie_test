/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package rcont

public open class C1 {
    public var tag: Int64 = 0
    public init() {}
}

public struct S1 {
    public var x: Int64 = 0
    public init() {}
}

public interface I1 {
    public func ping(): Unit
}
