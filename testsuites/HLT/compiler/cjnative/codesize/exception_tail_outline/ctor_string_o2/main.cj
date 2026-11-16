/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func raiseFirst(): Int64 {
    throw Exception("first message")
    0
}

func raiseSecond(): Int64 {
    throw Exception("second message")
    0
}

main() {
    var caught = 0
    try {
        raiseFirst()
    } catch (e: Exception) {
        if (e.message != "first message") {
            return 1
        }
        caught++
    }
    try {
        raiseSecond()
    } catch (e: Exception) {
        if (e.message != "second message") {
            return 2
        }
        caught++
    }
    if (caught != 2) {
        return 3
    }
    0
}
