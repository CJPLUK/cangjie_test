/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_win) EXEC: %compiler %cmp_opt -o %output %f %cmp_utest_opt
// (!target_win) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.io.*
import std.collection.*
import std.fs.*

@When[os == "Linux"]
let b: ArrayList<Int64> = ArrayList<Int64>([1, 10, -1])
@When[os != "Linux"]
let b: ArrayList<Int64> = ArrayList<Int64>([1, 10, 9223372036854775807])

main() {
    var a: ArrayList<Int64> = ArrayList<Int64>()
    var arr: Array<Byte> = Array<Byte>(10, {i => UInt8(i % 256)})
    var fileName = "Begin_03.txt"
    var file = File(fileName, ReadWrite)
    @Assert(exists(fileName), true)
    a.add(file.seek(Begin(1)))
    file.write(arr)
    a.add(file.seek(Begin(10)))
    try {
        a.add(file.seek(Begin(9223372036854775807)))
    } catch (e: FSException) {
        a.add(-1)
    }
    file.close()
    remove(fileName)
    if (a != b) {
        println(a)
        return 1
    }
    return 0
}
