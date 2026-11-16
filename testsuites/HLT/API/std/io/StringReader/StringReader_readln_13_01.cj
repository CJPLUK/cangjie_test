/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: ./test_readln_13_01.txt
// EXEC: %compiler %cmp_opt -o %output %f %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.io.*
import std.fs.*
import std.env.*
import std.collection.*

@Test
class TestStringReader {
    @TestCase
    func testCase00(): Unit {
        let filePath = "./test_readln_13_01.txt"
        let inputStream = File(filePath, ReadWrite)
        let strReader = StringReader(inputStream)
        let sb: StringBuilder = StringBuilder()
        var count: Int64 = 0
        while (count < 4) {
            let ret = strReader.readln()
            sb.append(ret ?? "$")
            count++
        }
        @Expect(sb.toString(), "AAAAAAAAAAAABBBBBBBBBBBBCCCCCCCCCCCCDDDDDDDDDDDD")
        inputStream.close()
        let e = @AssertThrows[FSException](
            while (true) {
                let res = strReader.readln()
                match (res) {
                    case Some(a) => sb.append(a)
                    case None => break
                }
            }
        )
        let fileFullPath = getWorkingDirectory().join(filePath)
        @Assert(e.message, "Cannot read file '${fileFullPath}': file is not opened.")
        @Assert(sb.toString(), "AAAAAAAAAAAABBBBBBBBBBBBCCCCCCCCCCCCDDDDDDDDDDDDEEEEEEEEEEEEFFFFFFFFFFFFGGGGGGGGGGGG")
    }
}
