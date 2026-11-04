// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

func f(_: VArray<Byte, $3>) {}

main() {
    f("123".toArray())
}

// Match the diagnostic contract independently of standard-library source positions.
// ASSERT: regex error: mismatched types
// ASSERT: regex expected 'VArray<UInt8, \$3>', found 'Struct-Array<UInt8>'
// ASSERT: regex error: no matching function declaration for function call 'toArray'
// ASSERT: regex note: found function member of 'Struct-String'
// ASSERT: regex 2 errors generated, 2 errors printed\.
