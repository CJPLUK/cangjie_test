/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.runtime.*

class StressException <: Exception {
    public init() {
        super("gc stress exception")
    }
}

func throwStress(): Int64 {
    throw StressException()
    0
}

func doRound(round: Int64): Int64 {
    let src = Array<String>(8, {i => "round${round}-item${i}"})
    try {
        throwStress()
    } catch (e: StressException) {
        if (e.message != "gc stress exception") {
            return 1
        }
        if (src[0] != "round${round}-item0" || src[7] != "round${round}-item7") {
            return 2
        }
    }
    gc()
    0
}

main() {
    for (round in 0..100) {
        if (doRound(round) != 0) {
            return 1
        }
    }
    0
}
