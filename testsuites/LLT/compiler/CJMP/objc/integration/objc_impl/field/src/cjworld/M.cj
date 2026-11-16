// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class M <: ProtoM {
    init()
}

@ObjC
public foreign class M1 <: ProtoM {
    init()
}

@ObjC
public foreign interface ProtoM {
    func identity(): Unit
}

@ObjC
public foreign interface Checker {
    func check(): Unit
}
