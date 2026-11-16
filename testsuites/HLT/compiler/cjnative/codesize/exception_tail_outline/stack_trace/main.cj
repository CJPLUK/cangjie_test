/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func level3(): Int64 {
    throw Exception("stack_trace_test")
    0
}

func level2(): Int64 {
    level3()
}

func level1(): Int64 {
    level2()
}

main() {
    try {
        level1()
        1
    } catch (e: Exception) {
        e.printStackTrace()
        if (e.message != "stack_trace_test") {
            return 1
        }
    }
    0
}
