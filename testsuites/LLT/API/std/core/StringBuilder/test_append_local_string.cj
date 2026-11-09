/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

func builderFromLocalString(): StringBuilder {
    let builder = StringBuilder(1)
    let runes: Array<Rune> @local! = [r'你', r'🙂']
    let text: String @local! = String(runes)
    builder.append(text)
    builder
}

func appendLocalModesAndEmptyString(): Bool {
    let builder = StringBuilder(1)
    let text: String @local! = "a你🙂"
    let shared: String @local? = text
    let empty: String @local? = ""

    builder.append(empty)
    if (builder.size != 0) {
        return false
    }
    builder.append(text)
    builder.append(shared)
    builder.append(empty)
    builder.toString() == "a你🙂a你🙂" && builder.size == 16
}

func appendContentOutlivesLocalSource(): Bool {
    let builder = builderFromLocalString()
    if (builder.toString() != "你🙂") {
        return false
    }
    builder.append("!")
    builder.toString() == "你🙂!"
}

func interpolatesLocalString(): Bool {
    let text: String @local! = "你🙂"
    let result: String = "<${text}>"
    result == "<你🙂>"
}

@Test
class AppendLocalStringTest {
    @TestCase
    func testLocalModesAndEmptyString(): Unit {
        @Expect(appendLocalModesAndEmptyString())
    }

    @TestCase
    func testContentOutlivesLocalSource(): Unit {
        @Expect(appendContentOutlivesLocalSource())
    }

    @TestCase
    func testInterpolationOfLocalString(): Unit {
        @Expect(interpolatesLocalString())
    }
}
