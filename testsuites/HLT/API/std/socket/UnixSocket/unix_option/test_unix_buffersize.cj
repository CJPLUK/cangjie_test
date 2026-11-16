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
 * Test description: Test sendBufferSize and receiveBufferSize with
 * different inputs in unix server or socket
 * Test API: public mut prop sendBufferSize: Int64
 *           public mut prop receiveBufferSize: Int64
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

var ser = Option<UnixServerSocket>.None
var sum = 0
var bound = AtomicUInt16(0)
var flag = 0

@Test
class Test_Unix_Buffer_Size {
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
        unlink("./testsocket/socket")
        bound = AtomicUInt16(0)
        flag = 0
    }

    func startServer(): Unit {
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()
        bound.fetchAdd(1)
        ser = Option<UnixServerSocket>.Some(server)
    }

    @TestCase
    func test_size_change_or_not(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }

        var sum = 0
        var client = UnixSocket("./testsocket/socket")
        var cli_sndbuf = client.sendBufferSize
        var cli_rcvbuf = client.receiveBufferSize

        var ser_sndbuf = ser.getOrThrow().sendBufferSize
        var ser_rcvbuf = ser.getOrThrow().receiveBufferSize

        // kernel give the same buffersize for server or socket
        @Expect(cli_sndbuf, ser_sndbuf)
        @Expect(cli_rcvbuf, ser_rcvbuf)

        client.connect(timeout: 2 * Duration.second)
        cli_sndbuf = client.sendBufferSize
        @Expect(cli_rcvbuf, client.receiveBufferSize)

        var serversocket = ser.getOrThrow().accept()
        // serversocket and clientsocket should be same here
        @Expect(cli_sndbuf, serversocket.sendBufferSize)
        @Expect(cli_rcvbuf, serversocket.receiveBufferSize)

        client.close()
        // throw exception if socket closed
        try {
            client.sendBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        try {
            client.receiveBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }

        @Expect(cli_sndbuf, serversocket.sendBufferSize)
        @Expect(cli_rcvbuf, serversocket.receiveBufferSize)

        ser.getOrThrow().close()
        flag = 1
        while (flag == 0) {
            sleep(Duration.millisecond)
        }

        @Expect(cli_sndbuf, serversocket.sendBufferSize)
        @Expect(cli_rcvbuf, serversocket.receiveBufferSize)

        serversocket.close()
        // can not get when serversocket close
        try {
            serversocket.sendBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        try {
            serversocket.receiveBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        @Expect(sum, 4)
    }

    @TestCase
    func test_different_input_size(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }

        var sum = 0
        var client = UnixSocket("./testsocket/socket")
        // can not be zero or negative
        client.connect(timeout: 2 * Duration.second)
        try {
            client.sendBufferSize = -1
            println(client.sendBufferSize)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        try {
            client.receiveBufferSize = 0
            println(client.receiveBufferSize)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }

        try {
            ser.getOrThrow().sendBufferSize = 0
            println(ser.getOrThrow().sendBufferSize)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        try {
            ser.getOrThrow().receiveBufferSize = -1
            println(ser.getOrThrow().receiveBufferSize)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }

        client.sendBufferSize = 1
        client.receiveBufferSize = 1
        ser.getOrThrow().sendBufferSize = 10000
        ser.getOrThrow().receiveBufferSize = 20000

        // change by the kernel
        var cli_sndbuf = client.sendBufferSize
        var cli_rcvbuf = client.receiveBufferSize

        @Expect(client.sendBufferSize, cli_sndbuf)
        @Expect(client.receiveBufferSize, cli_rcvbuf)

        var serversocket = ser.getOrThrow().accept()
        @Expect(client.sendBufferSize, cli_sndbuf)
        @Expect(client.receiveBufferSize, cli_rcvbuf)
        @Expect(cli_sndbuf == serversocket.sendBufferSize, false)
        @Expect(cli_rcvbuf == serversocket.receiveBufferSize, false)

        client.close()
        // throw exception if socket closed
        try {
            client.sendBufferSize = 2345
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        try {
            client.receiveBufferSize = 8765
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }

        serversocket.close()
        try {
            serversocket.sendBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }
        try {
            serversocket.receiveBufferSize
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message, "Socket is already closed")
        }

        @Expect(sum, 8)
        ser.getOrThrow().close()
    }
}
