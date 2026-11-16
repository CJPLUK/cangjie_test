/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

class PoisonException <: Exception {
    public init() {
        super("poison ti exception")
    }
}

func raise(): Int64 {
    throw PoisonException()
    0
}

main() {
    var caught = 0
    try {
        raise()
    } catch (e: PoisonException) {
        if (e.message != "poison ti exception") {
            return 1
        }
        caught++
    }
    if (caught != 1) {
        return 2
    }
    0
}
