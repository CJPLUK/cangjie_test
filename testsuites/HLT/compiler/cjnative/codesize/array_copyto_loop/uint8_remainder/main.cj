/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func remainderOne() {
    let src = Array<UInt8>(4294967281, repeat: 0)
    let dst = Array<UInt8>(4294967281, repeat: 0)
    src.copyTo(dst, 0, 0, 4294967281)
}

func remainderSizeMinusOne() {
    let src = Array<UInt8>(6442450919, repeat: 0)
    let dst = Array<UInt8>(6442450919, repeat: 0)
    src.copyTo(dst, 0, 0, 6442450919)
}

main() {
    remainderOne()
    remainderSizeMinusOne()
    0
}
