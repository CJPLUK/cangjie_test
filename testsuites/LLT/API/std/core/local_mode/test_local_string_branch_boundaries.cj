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

func checkOwnedLines(text: String @local!, expected: Array<String>): Unit {
    exclave {
        let iterator: Iterator<String> @local! = text.lines()
        for (i in 0..expected.size) {
            match (iterator.next()) {
                case Some(line) => check(line == expected[i], "owned line contents")
                case None => throw Exception("owned line missing")
            }
        }
        check(iterator.next().isNone() && iterator.next().isNone(), "owned iterator remains exhausted")
    }
}

func checkSharedLines(text: String @local?, expected: Array<String>): Unit {
    let iterator: Iterator<String> @local? = text.lines()
    for (i in 0..expected.size) {
        match (iterator.next()) {
            case Some(line) => check(line == expected[i], "shared line contents")
            case None => throw Exception("shared line missing")
        }
    }
    check(iterator.next().isNone() && iterator.next().isNone(), "shared iterator remains exhausted")
}

exclave func checkLineModes(text: String @local!, expected: Array<String>): Unit {
    checkOwnedLines(text, expected)
    checkSharedLines(text, expected)
    let heap = String(text)
    let iterator = heap.lines()
    for (i in 0..expected.size) {
        match (iterator.next()) {
            case Some(line) => check(line == expected[i], "heap line contents")
            case None => throw Exception("heap line missing")
        }
    }
    check(iterator.next().isNone(), "heap iterator exhausted")
}

func checkLines(): Unit {
    checkLineModes("", [])
    checkLineModes("x", ["x"])
    checkLineModes("\n", [""])
    checkLineModes("\r\n", [""])
    checkLineModes("x\ny", ["x", "y"])
    checkLineModes("x\r\ny", ["x", "y"])
    checkLineModes("\rY", ["", "Y"])
    checkLineModes("\r", [""])
    checkLineModes("x\r", ["x"])
    checkLineModes("x\r\r", ["x", ""])
    let backing: String @local! = "!x\r!"
    let slice: String @local? = backing[1..3]
    checkSharedLines(slice, ["x"])
}

func checkSizeSelectedPaths(): Unit {
    for (size in [0, 1, 3, 4, 7, 8, 16, 17, 31, 32, 33, 48, 49, 96, 97]) {
        let heap = "a" * size
        let text: String @local! = String(heap) @local!
        let view: String @local? = text
        check(view.hashCode() == heap.hashCode(), "hash must agree across modes and length paths")
        check(view == heap && view.compare(heap) == Ordering.EQ, "equal comparison at length boundary")
        let greater = heap + "b"
        check(view.compare(greater) == Ordering.LT, "prefix ordering")
        let backing: String @local! = String("!" + heap + "!") @local!
        let slice: String @local? = backing[1..size + 1]
        check(slice == heap && slice.hashCode() == heap.hashCode(), "comparison and hash honor offsets")
    }
}

main(): Int64 {
    checkSizeSelectedPaths()
    checkLines()
    println("ALL PASSED")
    0
}
