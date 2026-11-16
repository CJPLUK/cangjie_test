/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_mac & !target_win) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_mac & !target_win) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args
import std.unittest.*
import std.unittest.testmacro.*
import std.posix.*

@Test
class Test_open64 {
    @TestCase
    func test_open64_01(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_RDONLY
        )
        @Assert(fd != -1, true)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        remove("file.txt")
        close(fd)
        @Assert(res, true)
    }

    @TestCase
    func test_open64_02(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_RDWR
        )
        @Assert(fd != -1, true)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        close(fd)
        remove("file.txt")
        @Assert(res, true)
    }

    @TestCase
    func test_open64_03(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_WRONLY
        )
        @Assert(fd != -1, true)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        close(fd)
        remove("file.txt")
        @Assert(res, true)
    }

    @TestCase
    func test_open64_04(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_WRONLY | O_RDWR | O_RDONLY
        )
        @Assert(fd != -1, true)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        close(fd)
        remove("file.txt")
        @Assert(res, true)
    }

    @TestCase
    func test_open64_05(): Unit {
        let fd = open64("", O_WRONLY)
        @Assert(fd != -1, false)
        var res: Bool
        close(fd)
        @Assert(fd, -1)
    }

    @TestCase
    func test_open64_06(): Unit {
        var count = 0
        try {
            let fd = open64("\0", O_WRONLY)
        } catch (e: IllegalArgumentException) {
            count += 1
        }
        @Assert(count, 1)
    }

    @TestCase
    func test_open64_07(): Unit {
        let fd = open64("!@#$%^&*()", O_WRONLY)
        @Assert(fd != -1, false)
        var res: Bool
        close(fd)
        @Assert(fd, -1)
    }

    @TestCase
    func test_open64_08(): Unit {
        let fd = open64("       ", O_WRONLY)
        @Assert(fd != -1, false)
        var res: Bool
        close(fd)
        @Assert(fd, -1)
    }

    @TestCase
    func test_open64_09(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_RDONLY | O_APPEND | O_CLOEXEC | O_CREAT | O_DIRECTORY | O_DSYNC | O_EXCL | O_NOCTTY | O_NOFOLLOW |
                O_NONBLOCK | O_SYNC | O_TRUNC | O_RSYNC,
            S_IRUSR | S_IWUSR | S_IXUSR | S_IRWXU | S_IRGRP | S_IWGRP | S_IXGRP | S_IRWXG | S_IROTH | S_IWOTH | S_IXOTH |
                S_IRWXO
        )
        @Assert(fd != -1, false)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        remove("file.txt")
        close(fd)
        @Assert(res, false)
    }

    @TestCase
    func test_open64_10(): Unit {
        let fd = open64("/", O_RDONLY | O_CREAT)
        @Assert(fd != -1, false)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        close(fd)
        @Assert(res, false)
    }

    @TestCase
    func test_open64_11(): Unit {
        var cre = creat("file.txt", S_IRWXU)
        @Assert(cre != -1, true)
        let fd = open64(
            "file.txt",
            O_RDONLY | O_APPEND | O_CLOEXEC | O_CREAT | O_DSYNC | O_NOCTTY | O_NOFOLLOW | O_NONBLOCK | O_SYNC | O_TRUNC |
                O_RSYNC,
            S_IRUSR | S_IWUSR | S_IXUSR | S_IRWXU | S_IRGRP | S_IWGRP | S_IXGRP | S_IRWXG | S_IROTH | S_IWOTH | S_IXOTH |
                S_IRWXO
        )
        @Assert(fd != -1, true)
        var res: Bool
        if (fd > 1) {
            res = true
        } else {
            res = false
        }
        remove("file.txt")
        close(fd)
        @Assert(res, true)
    }
}
