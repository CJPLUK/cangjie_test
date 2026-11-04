// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_types
public type PlainCallback = (String) -> Unit
public interface Marker<T> {}
public class PlainMarker <: Marker<PlainCallback> {}
public class Holder {
    public let plain: PlainCallback = { value => }
}
public class Primary {
    public func keep(): Unit
}
public enum Variant { | Plain }
