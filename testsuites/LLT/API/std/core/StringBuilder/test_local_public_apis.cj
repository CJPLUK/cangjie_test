/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

func constructsAndAppendsLocalBuilder(): Bool {
    let builder: StringBuilder @local! = StringBuilder()
    let text: String @local! = "你🙂"
    builder.append(text)
    builder.append<Int64>(42)
    let result: String @local! = builder.toString()
    result == "你🙂42"
}

func snapshotsHeapBuilderThroughLocalView(): Bool {
    let builder = StringBuilder("ab")
    let view: StringBuilder @local? = builder
    let snapshot: String @local! = view.toString()
    builder.append("cd")
    let result: String = builder.toString()
    snapshot == "ab" && result == "abcd"
}

func growsLocalBuilderAndKeepsSnapshot(): Bool {
    let runes: Array<Rune> @local! = Array<Rune>(64, repeat: r'你')
    let text: String @local! = String(runes)
    let builder: StringBuilder @local! = StringBuilder()
    builder.append(text)
    let view: StringBuilder @local? = builder
    let snapshot: String @local! = view.toString()
    builder.append(text)
    let printable: ToString @local? = builder
    let result: String @local! = printable.toString()
    snapshot == text && result.size == 384 && result == text * 2
}

@Test
class LocalStringBuilderPublicApisTest {
    @TestCase
    func testConstructionAndAppend(): Unit {
        @Expect(constructsAndAppendsLocalBuilder())
    }

    @TestCase
    func testHeapBuilderLocalView(): Unit {
        @Expect(snapshotsHeapBuilderThroughLocalView())
    }

    @TestCase
    func testGrowthAndSnapshot(): Unit {
        @Expect(growsLocalBuilderAndKeepsSnapshot())
    }
}
