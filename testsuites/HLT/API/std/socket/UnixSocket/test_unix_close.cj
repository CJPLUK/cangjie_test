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
 * Test description: Test the close api in UnixServerSocket or UnixSocket
 * Test API: public mut prop noDelay: Bool
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

var ser = Option<UnixServerSocket>.None
var cli = Option<UnixSocket>.None
var data = Array<Byte>(5, repeat: 10)
var bound = AtomicUInt16(0)
var flag = 0

@Test
class Test_Tcp_Close {
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

    public override func afterEach(): Unit {
        unlink("./testsocket/socket1")
        flag = 0
        bound = AtomicUInt16(0)
    }

    func startServer(): Unit {
        var server = UnixServerSocket(bindAt: "./testsocket/socket1")
        server.bind()
        bound.fetchAdd(1)
        ser = Option<UnixServerSocket>.Some(server)
    }

    @TestCase
    func test_close_1(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket1")
        server.close()
        @Expect(server.isClosed(), true)

        var socket = UnixSocket("./testsocket/socket1")
        socket.close()
        @Expect(socket.isClosed(), true)
    }

    @TestCase
    func test_close_2(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
        }

        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        var socket = UnixSocket("./testsocket/socket1")
        socket.connect()
        socket.close()
        ser.getOrThrow().close()
        flag = 1
        while (flag == 0) {
            sleep(Duration.millisecond)
        }
        @Expect(ser.getOrThrow().isClosed(), true)
        @Expect(socket.isClosed(), true)
    }

    @TestCase
    func test_close_3(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
            flag = 1
            while (flag == 0) {
                sleep(Duration.millisecond)
            }
            var serversocket = ser.getOrThrow().accept()
            serversocket.write(data)
        }

        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        var socket = UnixSocket("./testsocket/socket1")
        socket.connect()
        sleep(Duration.millisecond * 50)
        var buf = Array<Byte>(5, repeat: 0)
        var readlen = socket.read(buf)
        socket.close()
        ser.getOrThrow().close()
        @Expect(ser.getOrThrow().isClosed(), true)
        @Expect(socket.isClosed(), true)
        @Expect(readlen, data.size)
        @Expect(buf, data)
    }

    @TestCase
    func test_close_4(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
            flag = 1
            while (flag == 0) {
                sleep(Duration.millisecond)
            }
            var serversocket = ser.getOrThrow().accept()
            serversocket.write(data)
        }

        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        var socket = UnixSocket("./testsocket/socket1")
        socket.connect()
        var buf = Array<Byte>(5, repeat: 0)
        var readlen = socket.read(buf)
        socket.close()
        socket.close()
        ser.getOrThrow().close()
        sleep(Duration.second)
        @Expect(ser.getOrThrow().isClosed(), true)
        @Expect(socket.isClosed(), true)
        @Expect(readlen, data.size)
        @Expect(buf, data)
    }

    @TestCase
    func test_close_6(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
            flag = 1
            while (flag == 0) {
                sleep(Duration.millisecond)
            }
            var serversocket = ser.getOrThrow().accept()
            serversocket.write(data)
        }

        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        var socket = UnixSocket("./testsocket/socket1")
        socket.connect()
        var buf = Array<Byte>(5, repeat: 0)
        var readlen = socket.read(buf)
        socket.close()
        socket.close()
        ser.getOrThrow().close()
        sleep(Duration.second)
        @Expect(ser.getOrThrow().isClosed(), true)
        @Expect(socket.isClosed(), true)
        @Expect(readlen, data.size)
        @Expect(buf, data)
    }
}
