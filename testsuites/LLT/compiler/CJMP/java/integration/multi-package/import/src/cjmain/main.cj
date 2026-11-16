// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjmain

import cjbase.*
import cjworld.*

import java.lang.*

@Java["com.java.lib.Main"]
public class Main {
    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        if(cangjieMain() != 0) {
            throw Exception("")
        }
    }
}
