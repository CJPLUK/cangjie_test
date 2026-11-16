/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

class MyException <: Exception {
    public init() {
        super("my custom exception")
    }
}

func raise(): Int64 {
    try {
        throw MyException()
    } catch (e: MyException) {
        if (e.message != "my custom exception") {
            return 1
        }
        return 0
    }
    0
}

main() {
    if (raise() != 0) {
        return 1
    }
    0
}
