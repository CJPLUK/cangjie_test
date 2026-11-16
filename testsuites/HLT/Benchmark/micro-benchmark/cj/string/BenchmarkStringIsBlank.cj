/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping --no-sub-pkg %cmp_utest_opt -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run %run_opt %output %run_utest_opt %run_args --bench --no-color

import std.unicode.*
import std.time.*

var sink = 0

@Test
@Configure[minDuration: Duration.second * 3]
@Measure[TimeNow(Nanos)]
@Configure[warmup: Duration.second]
public class Test_string_isBlank_bench {
    let emptyStrings = Array<String>(256 * 1024) { _ => "" }
    let asciiBlankStrings = Array<String>(256 * 1024) { _ => "    " }
    let asciiNonBlankStrings = Array<String>(256 * 1024) { _ => "abc" }

    // 空白前缀 + 非空白后缀：官方版需解码全部前缀 rune（每 rune 一次 Option 装箱），收益随前缀长度线性增长
    let blankPrefixTail = " " * 1023 + "a"

    // Unicode 空白兜底路径：仍省迭代器分配与每 rune 装箱，fromUtf8 保留
    let unicodeBlank = "\u{3000}" * 256

    // 混合：ASCII 空白前缀走字节路径，Unicode 空白走兜底路径，非空白尾部短路
    let mixedBlank = " " * 512 + "\u{3000}" * 128 + "a"

    // 非空白前缀 + 大段空白后缀：两版均应首字节短路 O(1)，作为防劣化回归监控
    // （d23b4589 时代的快路径版本曾在此场景劣化 0.47ns/字节）
    let nonBlankPrefixTail = "a" + " " * 1023

    // 命中 isEmpty() 快速路径（O(1)，跳过 runes 迭代器初始化）
    @Bench
    func BenchmarkStringIsBlank_EmptyFastPath(): Unit {
        var count = 0
        for (str in emptyStrings) {
            if (str.isBlank()) {
                count++
            }
        }
        sink = count
    }

    // 命中 isAscii() 快速路径 + isAsciiBlank() => true（避免 UTF-8 解码）
    @Bench
    func BenchmarkStringIsBlank_AsciiBlankFastPath(): Unit {
        var count = 0
        for (str in asciiBlankStrings) {
            if (str.isBlank()) {
                count++
            }
        }
        sink = count
    }

    // 命中 isAscii() 快速路径 + isAsciiBlank() => false（首字节短路）
    @Bench
    func BenchmarkStringIsBlank_AsciiNonBlankFastPath(): Unit {
        var count = 0
        for (str in asciiNonBlankStrings) {
            if (!str.isBlank()) {
                count++
            }
        }
        sink = count
    }

    @Bench
    func BenchmarkStringIsBlank_BlankPrefixTail(): Unit {
        sink = if (blankPrefixTail.isBlank()) { 1 } else { 0 }
    }

    @Bench
    func BenchmarkStringIsBlank_UnicodeBlank(): Unit {
        sink = if (unicodeBlank.isBlank()) { 1 } else { 0 }
    }

    @Bench
    func BenchmarkStringIsBlank_MixedBlank(): Unit {
        sink = if (mixedBlank.isBlank()) { 1 } else { 0 }
    }

    @Bench
    func BenchmarkStringIsBlank_NonBlankPrefixTail(): Unit {
        sink = if (nonBlankPrefixTail.isBlank()) { 1 } else { 0 }
    }
}
