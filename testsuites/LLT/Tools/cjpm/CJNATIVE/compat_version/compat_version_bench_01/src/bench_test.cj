// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package demo

import std.unittest.*
import std.unittest.testmacro.*
import demo.pkg1.value

@Test
class BenchValue {
    @Bench
    func benchValue(): Unit {
        let _ = value()
    }
}
