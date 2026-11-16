/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: ./data
// (!host_win) EXEC: %chmod -r ./data/unreadable.txt
// (!host_win) EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output
// (!host_win) RUN-EXEC: %run_stdx %output %run_args

import stdx.net.http.*

main(): Int64 {
    var count = 0

    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 1
        }
    }
    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad, bufferSize: -1)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 2
        }
    }
    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad, bufferSize: 4 * 1024 / 2)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 3
        }
    }
    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad, bufferSize: 4 * 1024 * 2)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 4
        }
    }
    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad, bufferSize: 64 * 1024 / 2)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 5
        }
    }
    try {
        FileHandler("./data/unreadable.txt", handlerType: UpLoad, bufferSize: 64 * 1024 * 2)
    } catch (e: HttpException) {
        count++
        if (e.message != "Path is not a directory: './data/unreadable.txt'.") {
            return 6
        }
    }

    if (count != 6) {
        return 7
    }
    0
}
