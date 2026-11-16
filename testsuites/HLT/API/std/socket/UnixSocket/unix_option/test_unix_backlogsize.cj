/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// (!target_win)EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win)RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args 

/*
 * Test description: Test the backlogSize option
 * Test API: backlogSize Apis in Class UnixServerSocket
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*

@When[os == "macOS" || os == "iOS"]
let flag = 10
@When[os != "macOS" && os != "iOS"]
let flag = 11
var data = Array<Byte>(4096, repeat: 10)

@Test
class Test_Unix_Backlogsize {
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
    func test_Illegal_input(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket0")
        var sum = 0
        try {
            server.backlogSize = 0
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message, "Backlog size must be positive, got '0'.")
        }
        try {
            server.backlogSize = -1
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message, "Backlog size must be positive, got '-1'.")
        }

        server.bind()
        try {
            server.backlogSize = 0
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already bound.")
        }
        try {
            server.backlogSize = -1
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already bound.")
        }
        server.close()
        try {
            server.backlogSize = 0
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        try {
            server.backlogSize = 100
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        @Expect(sum, 6)
    }

    @TestCase
    func test_with_permission(): Unit {
        @Assert(exists("./testsocket"), true)
        var sum = 0
        var server = UnixServerSocket(bindAt: "./testsocket/socket1")
        server.backlogSize = 10
        server.bind()
        try {
            server.backlogSize = 20
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 1)
        @Expect(server.backlogSize, 10)

        for (_ in 0..flag) {
            var client = UnixSocket("./testsocket/socket1")
            client.connect(timeout: 2 * Duration.second)
            client.write(data)
        }
        try {
            var client = UnixSocket("./testsocket/socket1")
            client.connect(timeout: 2 * Duration.second)
        } catch (e: SocketException) { // unix no timeout
            sum += 1
        }

        var serversocket = server.accept(timeout: 2 * Duration.second)
        var buf = Array<Byte>(4096, repeat: 0)
        serversocket.read(buf)
        @Expect(buf, data)

        var client = UnixSocket("./testsocket/socket1")
        client.connect(timeout: 2 * Duration.second)
        client.write(data)
        client.close()

        server.close()
        server.backlogSize
        try {
            server.backlogSize = 100
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 3)
    }
}
