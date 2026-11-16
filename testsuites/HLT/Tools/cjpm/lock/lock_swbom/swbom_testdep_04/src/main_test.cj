// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal import std.unittest.*
internal import t4_devDep.*

@Test
public class AppTest {
    @TestCase
    func checkDev(): Unit {
        @Assert(devDep_x, 3)
    }
}
