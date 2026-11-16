/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Issue: https://atomgit.com/Cangjie/cangjie_runtime/issues/586
// LEVEL: 1
// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.testmacro.*

/**
 * Compatibility anchors for String.hashCode / wyhash after Issue #586 opts
 * (empty fast-path + long-string wide loads). Values must stay stable.
 */
@Test
class TestStringHashCodeIssue586 {
    @TestCase
    func test_empty_and_short_stable(): Unit {
        let empty = ""
        let a = "a"
        let ab = "ab"
        let hello = "hello"
        @Assert(empty.hashCode(), 2302960717771869484)
        @Assert(a.hashCode(), -9156465752413365139)
        @Assert(ab.hashCode(), -490330207908981162)
        @Assert(hello.hashCode(), -5973392143591194711)
        @Assert(empty.hashCode() == String().hashCode(), true)
    }

    @TestCase
    func test_long_paths_stable(): Unit {
        // len 64 / 256 exercise the >16 (and >48) wyhash branches.
        let len64 = String.fromUtf8(Array<UInt8>(64, {i => UInt8(65 + (i % 26))}))
        let len256 = String.fromUtf8(Array<UInt8>(256, {i => UInt8(65 + (i % 26))}))
        @Assert(len64.hashCode(), 3658220647498281512)
        @Assert(len256.hashCode(), 3276219243328047661)
        // identical content -> identical hash
        let len64b = String.fromUtf8(Array<UInt8>(64, {i => UInt8(65 + (i % 26))}))
        @Assert(len64.hashCode() == len64b.hashCode(), true)
    }
}
