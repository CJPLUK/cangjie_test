/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.runtime.*

var gCopyLen: Int64 = 8

func doRound(): Int64 {
    let src = Array<String>(16, {i => "item${i}"})
    let dst = Array<String>(16, {i => ""})
    src.copyTo(dst, 4, 0, gCopyLen)
    for (i in 0..gCopyLen) {
        if (dst[i] != src[i + 4]) {
            return 1
        }
    }
    gc()
    0
}

main() {
    for (roundIndex in 0..100) {
        if (doRound() != 0) {
            return 1
        }
    }
    0
}
