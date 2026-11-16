// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.MyObject"]
public open foreign class MyObject <: JObject {
    public init()
    public func isValid(): Bool
}

@Java["com.java.lib.FakeObject"]
public foreign class FakeObject <: JObject {
    public init()
}
