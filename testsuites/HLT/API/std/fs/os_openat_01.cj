/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: caserunner.cj test_fj.txt test_fj_notnull.txt
// (!target_mac & !target_win) EXEC-PIPE: %compiler %cmp_opt caserunner.cj -o %output %f
// (!target_mac & !target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_mac & !target_win) ASSERT: scan-not AssertionError
import std.posix.*

main() {
    var op1 = `open`("test_fj.txt", O_RDONLY)
    var opt1 = openat(op1, "test_fj_notnull.txt", O_RSYNC)
    CaseRunner<Int32>().runCases(
        [(opt1, -1)],
        description: "test case 1"
    )
    var op2 = `open`("test_fj.txt", O_RDWR)
    var opt2 = openat(op2, "test_fj_notnull.txt", O_TRUNC)
    CaseRunner<Int32>().runCases(
        [(opt2, -1)],
        description: "test case 2"
    )
    var op3 = `open`("test_fj.txt", O_WRONLY)
    var opt3 = openat(op3, "test_fj_notnull.txt", O_SYNC)
    CaseRunner<Int32>().runCases(
        [(opt3, -1)],
        description: "test case 3"
    )
    var op4 = `open`("test_fj.txt", O_APPEND)
    var opt4 = openat(op4, "test_fj_notnull.txt", O_NONBLOCK)
    CaseRunner<Int32>().runCases(
        [(opt4, -1)],
        description: "test case 4"
    )
    var op5 = `open`("test_fj.txt", O_CLOEXEC)
    var opt5 = openat(op5, "test_fj_notnull.txt", O_NOFOLLOW)
    CaseRunner<Int32>().runCases(
        [(opt5, -1)],
        description: "test case 5"
    )
    var op6 = `open`("test_fj.txt", O_CREAT)
    var opt6 = openat(op6, "test_fj_notnull.txt", O_NOCTTY)
    CaseRunner<Int32>().runCases(
        [(opt6, -1)],
        description: "test case 6"
    )
    var op7 = `open`("test_fj.txt", O_DIRECTORY)
    var opt7 = openat(op7, "test_fj_notnull.txt", O_EXCL)
    CaseRunner<Int32>().runCases(
        [(opt7, -1)],
        description: "test case 7"
    )
    var op8 = `open`("test_fj.txt", O_DSYNC)
    var opt8 = openat(op8, "test_fj_notnull.txt", O_DSYNC)
    CaseRunner<Int32>().runCases(
        [(opt8, -1)],
        description: "test case 8"
    )
    var op9 = `open`("test_fj.txt", O_EXCL)
    var opt9 = openat(op9, "test_fj_notnull.txt", O_DIRECTORY)
    CaseRunner<Int32>().runCases(
        [(opt9, -1)],
        description: "test case 9"
    )
    var op10 = `open`("test_fj.txt", O_NOCTTY)
    var opt10 = openat(op10, "test_fj_notnull.txt", O_CREAT)
    CaseRunner<Int32>().runCases(
        [(opt10, -1)],
        description: "test case 10"
    )
    var op11 = `open`("test_fj.txt", O_NOFOLLOW)
    var opt11 = openat(op11, "test_fj_notnull.txt", O_CLOEXEC)
    CaseRunner<Int32>().runCases(
        [(opt11, -1)],
        description: "test case 11"
    )
    var op12 = `open`("test_fj.txt", O_NONBLOCK)
    var opt12 = openat(op12, "test_fj_notnull.txt", O_APPEND)
    CaseRunner<Int32>().runCases(
        [(opt12, -1)],
        description: "test case 12"
    )
    var op13 = `open`("test_fj.txt", O_SYNC)
    var opt13 = openat(op13, "test_fj_notnull.txt", O_WRONLY)
    CaseRunner<Int32>().runCases(
        [(opt13, -1)],
        description: "test case 13"
    )
    var op14 = `open`("test_fj.txt", O_TRUNC)
    var opt14 = openat(op14, "test_fj_notnull.txt", O_RDWR)
    CaseRunner<Int32>().runCases(
        [(opt14, -1)],
        description: "test case 14"
    )
    var op15 = `open`("test_fj.txt", O_RSYNC)
    var opt15 = openat(op15, "test_fj_notnull.txt", O_RDONLY)
    CaseRunner<Int32>().runCases(
        [(opt15, -1)],
        description: "test case 15"
    )
    return 0
}
