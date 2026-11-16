/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_win)EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win)RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args 

/*
 * Test description: Test the filepermission in creating or changing socket files
 * Test API:  Apis in Class UnixServerSocket & UnixSocket
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

var data = Array<Byte>(5000, repeat: 10)

@Test
class Test_Unix_FilePath {
    public override func beforeAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
        Directory.create("./testsocket")
    }

    public override func afterAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
    }

    @TestCase
    func test_abs_path(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket1")
        server.bind()

        var client = UnixSocket("./testsocket/socket1")
        client.connect(timeout: 2 * Duration.second)
        var serversocket = server.accept(timeout: 2 * Duration.second)
        serversocket.write(data)
        var buf = Array<Byte>(5000, repeat: 20)
        client.read(buf)
        @Expect(data, buf)
        client.close()
        server.close()
        unlink("./testsocket/socket1")
    }

    @TestCase
    func test_rel_path(): Unit {
        @Assert(exists("./testsocket"), true)
        Directory.create("./testsocket/abc")
        @Assert(exists("./testsocket/abc"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/abc/../socket11")
        server.bind()

        var client = UnixSocket("./testsocket/abc/../socket11")
        client.connect(timeout: 2 * Duration.second)
        var serversocket = server.accept(timeout: 2 * Duration.second)
        serversocket.write(data)
        var buf = Array<Byte>(5000, repeat: 20)
        client.read(buf)
        @Expect(data, buf)
        client.close()
        server.close()
        unlink("./testsocket/socket11")
    }

    @TestCase
    func test_rel_path0(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./socket11")
        server.bind()

        var client = UnixSocket("./socket11")
        client.connect(timeout: 2 * Duration.second)
        var serversocket = server.accept(timeout: 2 * Duration.second)
        serversocket.write(data)
        var buf = Array<Byte>(5000, repeat: 20)
        client.read(buf)
        @Expect(data, buf)
        client.close()
        server.close()
        unlink("./socket11")
    }

    @TestCase
    func test_special_path_1(): Unit {
        @Assert(exists("./testsocket"), true)
        if (exists("./仓颉")) {
            remove("./仓颉", recursive: true)
        }
        Directory.create("./仓颉")
        @Assert(exists("./仓颉"), true)
        var server = UnixServerSocket(bindAt: "./仓颉/socket1")
        server.bind()

        var client = UnixSocket("./仓颉/socket1")
        client.connect(timeout: 2 * Duration.second)
        var serversocket = server.accept(timeout: 2 * Duration.second)
        serversocket.write(data)
        var buf = Array<Byte>(5000, repeat: 20)
        client.read(buf)
        @Expect(data, buf)
        client.close()
        server.close()
    }

    @TestCase
    func test_special_path_2(): Unit {
        @Assert(exists("./testsocket"), true)
        var sum = 0
        try {
            var server = UnixServerSocket(bindAt: "./testsocket/socket2\0tmp\0")
            server.bind()
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        try {
            var client = UnixSocket("./testsocket/socket2\0tmp\0")
            client.connect(timeout: 2 * Duration.second)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        @Expect(sum, 2)
    }

    @TestCase
    func test_string_len(): Unit {
        @Assert(exists("./testsocket"), true)
        var dir = Path("./testsocket")
        dir = dir.join(String(Array<Rune>(91, repeat: r'a')))
        var server = UnixServerSocket(bindAt: dir.toString())
        server.bind()

        var client = UnixSocket(dir.toString())
        client.connect(timeout: 2 * Duration.second)
        var serversocket = server.accept(timeout: 2 * Duration.second)
        serversocket.write(data)
        var buf = Array<Byte>(5000, repeat: 20)
        client.read(buf)
        @Expect(data, buf)
        client.close()
        server.close()

        var dir1 = Path("./testsocket")
        dir1 = dir1.join(String(Array<Rune>(92, repeat: r'a')))
        var sum = 0
        try {
            UnixServerSocket(bindAt: dir.toString()).bind()
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 1)
    }
}
