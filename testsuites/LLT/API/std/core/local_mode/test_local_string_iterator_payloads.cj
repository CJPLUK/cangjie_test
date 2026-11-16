/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkRunes(text: String @local?, expected: Array<Rune>): Unit {
    let iterator: Iterator<Rune> @local? = text.runes()
    for (i in 0..expected.size) {
        match (iterator.next()) {
            case Some(value) => check(value == expected[i], "shared Rune payload and order")
            case None => throw Exception("shared Rune payload missing")
        }
    }
    check(iterator.next().isNone(), "shared Rune iterator exhausted")
    check(iterator.next().isNone(), "shared Rune iterator remains exhausted")
}

func checkSharedRunePayloads(): Unit {
    let expected = [r'A', r'¢', r'仓', r'😀']
    let heap = String(expected)
    let heapView: String @local? = heap
    checkRunes(heapView, expected)
    let owned: String @local! = "A¢仓😀"
    let localView: String @local? = owned
    checkRunes(localView, expected)
    let backing: String @local! = "!A¢仓😀?"
    let slice: String @local? = backing[1..11]
    checkRunes(slice, expected)
    let combining: String @local? = "e\u{0301}😀"
    checkRunes(combining, [r'e', r'\u{0301}', r'😀'])
    let empty: String @local? = ""
    checkRunes(empty, [])
}

func checkByte(item: Option<Byte> @local?, expected: Byte): Unit {
    match (item) {
        case Some(value) => check(value == expected, "shared cursor byte payload")
        case None => throw Exception("shared cursor byte missing")
    }
}

func checkOwnedIteratorIdentity(): Unit {
    let text: String @local! = "A¢"
    let iterator: Iterator<Byte> @local! = text.iterator()
    checkByte(iterator.next(), 0x41)
    let alias: Iterator<Byte> @local! = iterator.iterator()
    checkByte(alias.next(), 0xC2)
    checkByte(iterator.next(), 0xA2)
    check(alias.next().isNone(), "owned alias exhausted")
    check(iterator.next().isNone(), "owned original remains exhausted")
    check(alias.next().isNone(), "owned alias remains exhausted")
}

func checkSharedIteratorIdentity(): Unit {
    let text: String @local! = "A¢"
    let view: String @local? = text
    let iterator: Iterator<Byte> @local? = view.iterator()
    checkByte(iterator.next(), 0x41)
    let alias: Iterator<Byte> @local? = iterator.iterator()
    checkByte(alias.next(), 0xC2)
    checkByte(iterator.next(), 0xA2)
    check(alias.next().isNone(), "shared alias exhausted")
    check(iterator.next().isNone(), "shared original remains exhausted")
    check(alias.next().isNone(), "shared alias remains exhausted")
}

main(): Int64 {
    checkSharedRunePayloads()
    checkOwnedIteratorIdentity()
    checkSharedIteratorIdentity()
    println("ALL PASSED")
    0
}
