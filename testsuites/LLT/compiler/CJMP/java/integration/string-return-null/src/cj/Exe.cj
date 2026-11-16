// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

//import java.lang.*

@Java["com.java.lib.Exe"]
public open foreign class Exe {
    public init()

    // intentionally used type String to throw exception
    public open func ReturnNull(): String
}
