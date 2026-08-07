// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output 2>&1

type Word = UInt16
type SameWord = Word
type Ratio = Float32
type CodePoint = Rune

main() {
    let a: Word = Word(20)
    let b: SameWord = SameWord(a)
    let c: Word = Word(20.05)
    let floatValue: Float32 = 20.05
    let d: Word = Word(floatValue)
    let intValue: Int64 = 20
    let e: Ratio = Ratio(intValue)
    let runeValue: Int16 = 97
    let f: CodePoint = CodePoint(runeValue)
    0
}
