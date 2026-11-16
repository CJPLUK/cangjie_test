/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

var gMax: Int64 = 9223372036854775807

func overflow(): Int64 {
    gMax + 1
}

func raiseOverflow(): Int64 {
    try {
        overflow()
    } catch (e: OverflowException) {
        return 0
    }
    1
}

main() {
    if (raiseOverflow() != 0) {
        return 1
    }
    0
}
