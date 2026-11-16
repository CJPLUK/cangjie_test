// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_types

public func accept(value: PlainCallback): Unit {}
public func acceptLocal(value: LocalCallback): Unit {}
public func acceptArray(value: Array<(String @local?) -> Unit>): Unit {}
public func acceptTuple(value: ((String @local?) -> Unit, Int64)): Unit {}
public func useHolder(value: Holder): Unit {}
public func inferredCallback() { { value: String @local? => } }
public func constrained<T>(): Unit where T <: Marker<LocalCallback> {}

main() {}
