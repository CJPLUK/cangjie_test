// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cacheprobe.tests

internal import std.unittest.*
import std.unittest.testmacro.*

@Test
public class OlderTest {
    @TestCase
    func check(): Unit {
        @Assert(1, 1)
    }
}
