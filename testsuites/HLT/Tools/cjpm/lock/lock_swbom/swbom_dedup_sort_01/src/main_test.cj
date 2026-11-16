// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal import std.unittest.*
internal import d_adapter.*

@Test
public class AppTest {
    @TestCase
    func checkAdapter(): Unit {
        @Assert(adapter_x, 111)
    }
}
