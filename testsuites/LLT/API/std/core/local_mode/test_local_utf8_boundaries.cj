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

func checkBytes(actual: Array<UInt8> @local?, expected: Array<UInt8>): Unit {
    check(actual.size == expected.size, "byte array size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "byte array contents") }
}

func expectDecodeError(bytes: Array<UInt8> @local?, index: Int64): Unit {
    var caught = false
    try { let _ = Rune.fromUtf8(bytes, index) }
    catch (_: IllegalArgumentException) { caught = true }
    check(caught, "invalid UTF-8 or index must be rejected")
}

exclave func checkInvalidBytes(bytes: Array<UInt8> @local!): Unit {
    expectDecodeError(bytes, 0)
}

func checkRoundTrips(): Unit {
    let runes = [r'\u{0}', r'\u{7f}', r'\u{80}', r'\u{7ff}',
        r'\u{800}', r'\u{d7ff}', r'\u{e000}', r'\u{ffff}',
        r'\u{10000}', r'\u{10ffff}']
    let encodings: Array<Array<UInt8>> = [[0x00], [0x7F], [0xC2, 0x80], [0xDF, 0xBF],
        [0xE0, 0xA0, 0x80], [0xED, 0x9F, 0xBF], [0xEE, 0x80, 0x80], [0xEF, 0xBF, 0xBF],
        [0xF0, 0x90, 0x80, 0x80], [0xF4, 0x8F, 0xBF, 0xBF]]
    for (i in 0..runes.size) {
        let bytes: Array<UInt8> @local! = Array<UInt8>(6, repeat: 0x55)
        let view: Array<UInt8> @local? = bytes
        let count = Rune.intoUtf8Array(runes[i], view, 1)
        let (decoded, read) = Rune.fromUtf8(bytes, 1)
        check(count == encodings[i].size && read == count && decoded == runes[i], "UTF-8 boundary round trip")
        for (j in 0..bytes.size) {
            if (j >= 1 && j <= count) {
                check(bytes[j] == encodings[i][j - 1], "literal UTF-8 encoding")
            } else {
                check(bytes[j] == 0x55, "encoding must preserve every neighboring byte")
            }
        }
        let exact: Array<UInt8> @local! = Array<UInt8>(count, repeat: 0)
        check(Rune.intoUtf8Array(runes[i], exact, 0) == count, "exact destination size")
        checkBytes(exact, encodings[i])
        check(Rune.fromUtf8(exact, 0)[0] == runes[i], "exact destination contents")
    }
}

func checkInvalidSequences(): Unit {
    checkInvalidBytes([])
    checkInvalidBytes([0x80])
    checkInvalidBytes([0xFF])
    checkInvalidBytes([0xC2])
    checkInvalidBytes([0xE0, 0xA0])
    checkInvalidBytes([0xF0, 0x90, 0x80])
    checkInvalidBytes([0xC0, 0x80])
    checkInvalidBytes([0xC2, 0x41])
    checkInvalidBytes([0xE1, 0x41, 0x80])
    checkInvalidBytes([0xE1, 0x80, 0x41])
    checkInvalidBytes([0xE0, 0x80, 0x80])
    checkInvalidBytes([0xED, 0xA0, 0x80])
    checkInvalidBytes([0xF0, 0x80, 0x80, 0x80])
    checkInvalidBytes([0xF1, 0x41, 0x80, 0x80])
    checkInvalidBytes([0xF1, 0x80, 0x41, 0x80])
    checkInvalidBytes([0xF1, 0x80, 0x80, 0x41])
    checkInvalidBytes([0xF4, 0x90, 0x80, 0x80])
    checkInvalidBytes([0xF5, 0x80, 0x80, 0x80])
    let text: Array<UInt8> @local! = [0xC2, 0xA2]
    expectDecodeError(text, 1)
    expectDecodeError(text, text.size)
}

func checkDecodeViewBounds(): Unit {
    let backing: Array<UInt8> @local! = [0x41, 0x42, 0x43]
    let view: Array<UInt8> @local? = backing.slice(1, 1)
    expectDecodeError(view, -1)
    expectDecodeError(view, 1)
    check(Rune.fromUtf8(view, 0) == (r'B', 1), "decoding must honor the slice offset")
    let heap = [0x41u8, 0x42u8].slice(1, 1)
    var rejected = false
    try { let _ = Rune.fromUtf8(heap, -1) }
    catch (_: IllegalArgumentException) { rejected = true }
    check(rejected, "heap decoding must reject negative indices too")

    // Continuation bytes outside a view cannot complete its final character.
    let multibyte: Array<UInt8> @local! = [0x55, 0xC2, 0xA2, 0x55, 0xE4, 0xBD, 0xA0,
        0x55, 0xF0, 0x9F, 0x99, 0x82, 0x55]
    for ((start, size) in [(1, 1), (4, 1), (4, 2), (8, 1), (8, 2), (8, 3)]) {
        let truncated: Array<UInt8> @local? = multibyte.slice(start, size)
        expectDecodeError(truncated, 0)
        checkBytes(multibyte, [0x55, 0xC2, 0xA2, 0x55, 0xE4, 0xBD, 0xA0,
            0x55, 0xF0, 0x9F, 0x99, 0x82, 0x55])
    }
    let two: Array<UInt8> @local? = multibyte.slice(1, 2)
    let three: Array<UInt8> @local? = multibyte.slice(4, 3)
    let four: Array<UInt8> @local? = multibyte.slice(8, 4)
    check(Rune.fromUtf8(two, 0) == (r'\u{a2}', 2), "complete two-byte view")
    check(Rune.fromUtf8(three, 0) == (r'你', 3), "complete three-byte view")
    check(Rune.fromUtf8(four, 0) == (r'🙂', 4), "complete four-byte view")
}

func checkEncodingErrors(): Unit {
    let bytes: Array<UInt8> @local! = [0x55, 0x55, 0x55]
    let view: Array<UInt8> @local? = bytes
    for (index in [-1, 3, Int64.Max]) {
        var caught = false
        try { let _ = Rune.intoUtf8Array(r'A', view, index) }
        catch (_: IllegalArgumentException) { caught = true }
        check(caught, "encoding must reject invalid indices without overflow")
        checkBytes(bytes, [0x55, 0x55, 0x55])
    }
    var caught = false
    try { let _ = Rune.intoUtf8Array(r'\u{10000}', bytes, 0) }
    catch (_: IllegalArgumentException) { caught = true }
    check(caught, "short destination must reject the character")
    checkBytes(bytes, [0x55, 0x55, 0x55])
}

func checkEncodingViews(): Unit {
    let backing: Array<UInt8> @local! = Array<UInt8>(14, repeat: 0x55)
    let view: Array<UInt8> @local? = backing.slice(2, 10)
    check(Rune.intoUtf8Array(r'A', view, 0) == 1, "offset ASCII encoding length")
    check(Rune.intoUtf8Array(r'\u{a2}', view, 1) == 2, "offset two-byte encoding length")
    check(Rune.intoUtf8Array(r'你', view, 3) == 3, "offset three-byte encoding length")
    check(Rune.intoUtf8Array(r'🙂', view, 6) == 4, "offset four-byte encoding length")
    checkBytes(backing, [0x55, 0x55, 0x41, 0xC2, 0xA2, 0xE4, 0xBD, 0xA0,
        0xF0, 0x9F, 0x99, 0x82, 0x55, 0x55])

    let rejectedBacking: Array<UInt8> @local! = Array<UInt8>(8, repeat: 0x55)
    let short: Array<UInt8> @local? = rejectedBacking.slice(2, 3)
    for ((rune, index) in [(r'🙂', 0), (r'你', 1), (r'\u{a2}', 2),
        (r'A', -1), (r'A', 3), (r'A', Int64.Max)]) {
        var caught = false
        try { let _ = Rune.intoUtf8Array(rune, short, index) }
        catch (_: IllegalArgumentException) { caught = true }
        check(caught, "encoding cannot use capacity beyond the logical view")
        checkBytes(rejectedBacking, [0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55])
    }
    let empty: Array<UInt8> @local? = rejectedBacking.slice(2, 0)
    var caught = false
    try { let _ = Rune.intoUtf8Array(r'A', empty, 0) }
    catch (_: IllegalArgumentException) { caught = true }
    check(caught, "encoding into an empty offset view must fail")
    checkBytes(rejectedBacking, [0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55])
}

main(): Int64 {
    checkRoundTrips()
    checkInvalidSequences()
    checkDecodeViewBounds()
    checkEncodingErrors()
    checkEncodingViews()
    println("ALL PASSED")
    0
}
