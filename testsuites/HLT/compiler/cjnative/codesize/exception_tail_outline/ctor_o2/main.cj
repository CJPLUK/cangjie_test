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

func raise1(): Int64 {
    throw MyException()
    0
}

func raise2(): Int64 {
    throw MyException()
    0
}

func raise3(): Int64 {
    throw MyException()
    0
}

main() {
    var caught = 0
    try {
        raise1()
    } catch (e: MyException) {
        if (e.message != "my custom exception") {
            return 1
        }
        caught++
    }
    try {
        raise2()
    } catch (e: MyException) {
        if (e.message != "my custom exception") {
            return 2
        }
        caught++
    }
    try {
        raise3()
    } catch (e: MyException) {
        if (e.message != "my custom exception") {
            return 3
        }
        caught++
    }
    if (caught != 3) {
        return 4
    }
    0
}
