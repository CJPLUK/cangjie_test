/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

func localRuneUtf8RoundTrip(): Bool {
    let bytes: Array<UInt8> @local! = Array<UInt8>(7, repeat: 0)
    let view: Array<UInt8> @local? = bytes
    let firstSize = Rune.intoUtf8Array(r'你', bytes, 0)
    let secondSize = Rune.intoUtf8Array(r'🙂', view, firstSize)
    let (first, decodedFirstSize) = Rune.fromUtf8(bytes, 0)
    let (second, decodedSecondSize) = Rune.fromUtf8(view, firstSize)
    firstSize == 3 && secondSize == 4 && first == r'你' && second == r'🙂' &&
        decodedFirstSize == firstSize && decodedSecondSize == secondSize
}

func constructsStringFromLocalRawData(): Bool {
    let bytes: Array<UInt8> @local! = [0xE4, 0xBD, 0xA0, 0xF0, 0x9F, 0x99, 0x82]
    let text: String @local! = unsafe { String.withRawData(bytes) }
    text == "你🙂" && text.size == 7
}

@Test
class LocalUtf8PublicApisTest {
    @TestCase
    func testRuneUtf8RoundTrip(): Unit {
        @Expect(localRuneUtf8RoundTrip())
    }

    @TestCase
    func testStringWithRawData(): Unit {
        @Expect(constructsStringFromLocalRawData())
    }
}
