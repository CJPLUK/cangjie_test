/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

main() {
    let runes: Array<Rune> @local! = [r'你', r'🙂']
    let text: String @local! = String(runes)
    print(text)
    println(text)

    let localView: String @local? = text
    print(localView, flush: true)
    println(localView)

    let heapText = String([r'h', r'e', r'a', r'p'])
    let heapView: String @local? = heapText
    print(heapView, flush: false)
    println(heapView)

    let empty: String @local! = ""
    let emptyView: String @local? = empty
    print("empty:")
    print(empty, flush: true)
    print(emptyView)
    println(emptyView)
    print("empty:")
    println(empty)

    // Check bytes after NUL through both local argument modes.
    let nulRunes: Array<Rune> @local! = [r'A', r'\u{0}', r'你', r'🙂', r'Z']
    let nulText: String @local! = String(nulRunes)
    print("nul-owned:")
    print(nulText)
    println(nulText)

    let nulView: String @local? = nulText
    print("nul-shared:")
    print(nulView, flush: true)
    println(nulView)

    let heapNul: String = String([r'H', r'\u{0}', r'后'])
    let heapNulView: String @local? = heapNul
    print("nul-heap-view:")
    print(heapNulView)
    println(heapNulView)
}

// Keep NUL out of the source and require the entire output to match.
// ASSERT: regex \A你🙂你🙂\n你🙂你🙂\nheapheap\nempty:\nempty:\nnul-owned:A\x00你🙂ZA\x00你🙂Z\nnul-shared:A\x00你🙂ZA\x00你🙂Z\nnul-heap-view:H\x00后H\x00后\n\Z
