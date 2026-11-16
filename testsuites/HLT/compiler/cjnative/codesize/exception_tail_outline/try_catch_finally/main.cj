/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

var finallyCount: Int64 = 0

class InnerException <: Exception {
    public init() {
        super("inner exception")
    }
}

func inner(): Int64 {
    try {
        throw InnerException()
    } catch (e: InnerException) {
        throw e
    } finally {
        finallyCount++
    }
}

func outer(): Int64 {
    try {
        inner()
    } catch (e: InnerException) {
        if (e.message != "inner exception") {
            return 1
        }
        return 0
    }
    1
}

main() {
    if (outer() != 0) {
        return 1
    }
    if (finallyCount != 1) {
        return 2
    }
    0
}
