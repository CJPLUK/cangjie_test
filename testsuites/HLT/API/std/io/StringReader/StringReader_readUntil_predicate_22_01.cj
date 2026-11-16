/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: ./test_readUntil.txt
// (!target_win) EXEC: %compiler %cmp_opt -o %output %f
// (!target_win) RUN-EXEC: %run %run_opt %output %run_args

import std.io.*
import std.fs.*
import std.collection.*

var f: (Rune) -> Bool = {
    c: Rune => return if (c == r'b' || c == r'B') {
        true
    } else {
        false
    }
}

main() {
    var inputStream = File("./test_readUntil.txt", ReadWrite)
    var strReader = StringReader(inputStream)
    var sb: StringBuilder = StringBuilder()
    try {
        while (true) {
            var ret = strReader.readUntil(f)
            match (ret) {
                case Some(a) =>
                    sb.append(a)
                    sb.append("|")
                case None => break
            }
        }
    } catch (e: FSException) {
        if (e.message != "The file not opened, can not to read.") {
            return 1
        }
    } finally {
        inputStream.close()
    }
    if (sb.toString() != "a\nb|\nc\nd\nA\nB|\nC\nD|") {
        return 2
    }
    return 0
}
