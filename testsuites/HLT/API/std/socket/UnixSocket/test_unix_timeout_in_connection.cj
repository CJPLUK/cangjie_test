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
 * Test description: Test if timeout parameters of accept and connect works
 * correctly in tcp server or socket
 * Test API: public func connect(timeout!: ?Duration = None)
 *           public func connect(timeoutSeconds: Int64)
 *           public override func accept(): TcpSocket
 *           public override func accept(timeout!: ?Duration): TcpSocket
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

@When[os == "macOS" || os == "iOS"]
let flag = 7
@When[os != "macOS" && os != "iOS"]
let flag = 8
var ser = Option<UnixServerSocket>.None
var bound = AtomicUInt16(0)

@Test
class Test_Unix_Connect_Timeout {
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
    }

    func startServer(): Unit {
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.backlogSize = 7
        server.bind()
        bound.fetchAdd(1)
        ser = Option<UnixServerSocket>.Some(server)
    }

    @TestCase
    func test_connect_success(): Unit {
        // tese if connects received by the server
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        var timeoutseconds = [0, 10]
        for (i in timeoutseconds) {
            var client1 = UnixSocket("./testsocket/socket")
            client1.connect(timeout: Duration.second * i)
            var client2 = UnixSocket("./testsocket/socket")
            client2.connect(timeout: i * Duration.second)
        }
        var client3 = UnixSocket("./testsocket/socket")
        client3.connect()

        var client4 = UnixSocket("./testsocket/socket")
        var sum = 0

        try {
            client4.connect(timeout: -1 * Duration.nanosecond)
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        @Expect(sum, 1)

        ser.getOrThrow().close()
    }

    @TestCase
    func test_connect_nonblocking(): Unit {
        @Assert(exists("./testsocket"), true)
        var sum = 0
        // tese if connects can not received
        spawn {
            startServer()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        // backlogsize, set 7, actually 8
        for (_ in 0..flag) {
            var client1 = UnixSocket("./testsocket/socket")
            client1.connect(timeout: 1 * Duration.second)
        }

        var client2 = UnixSocket("./testsocket/socket")
        try {
            client2.connect(timeout: 2 * Duration.second)
        } catch (e: SocketException | SocketTimeoutException) { // unix no timeout
            sum += 1
        }
        ser.getOrThrow().accept()
        sleep(2 * Duration.second)

        for (_ in 0..4) {
            try {
                client2.connect(timeout: Duration.second)
                println("connect success 200!")
            } catch (e: SocketException | SocketTimeoutException) {
                sum += 1
            }
        }
        ser.getOrThrow().close()
        @Expect(sum >= 4 && sum <= 5)
    }

    @TestCase
    func test_connect_blocking(): Unit {
        // tese if connects can not received
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }
        // backlogsize, set 7, actually 8
        for (_ in 0..flag) {
            var client1 = UnixSocket("./testsocket/socket")
            client1.connect(timeout: 2 * Duration.second)
        }

        var client2 = UnixSocket("./testsocket/socket")
        let e = @AssertThrows[SocketException](client2.connect())
        @Expect(e.message.contains("connect"))
        ser.getOrThrow().close()
    }
}

@Test
class Test_Unix_Accept_Timeout {
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
    }

    func startClient(): Unit {
        var socket = UnixSocket("./testsocket/socket")
        socket.connect(timeout: 3 * Duration.second)
    }

    @TestCase
    func test_accept_blocking(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        var time1 = DateTime.now()
        spawn {
            sleep(3 * Duration.second)
            startClient()
        }
        var socket1 = server.accept()
        var time2 = DateTime.now()

        spawn {
            sleep(3 * Duration.second)
            startClient()
        }
        sleep(Duration.second)
        try {
            var _ = server.accept(timeout: -1 * Duration.nanosecond)
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
        }

        @Expect(time2 - time1 > 2.5 * Duration.second, true)
        sleep(10 * Duration.second)
        socket1.close()
        server.close()
    }

    @TestCase
    func test_accept_nonblocking_1(): Unit {
        // tese if nonblocking accepts deal with requests
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        sleep(500 * Duration.millisecond)
        var socket1 = server.accept(timeout: Duration.Zero)

        spawn {
            sleep(1000 * Duration.millisecond)
            startClient()
        }
        var socket2 = server.accept(timeout: 2 * Duration.second)
        @Expect(socket1.isClosed(), false)
        @Expect(socket2.isClosed(), false)
        server.close()

        sleep(10 * Duration.second)
        socket1.close()
        socket2.close()
        @Expect(socket1.isClosed(), true)
        @Expect(socket2.isClosed(), true)
    }

    @TestCase
    func test_accept_nonblocking_2(): Unit {
        // tese if nonblocking accepts timeout
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        var sum = 0
        try {
            server.accept(timeout: Duration.Zero)
        } catch (e: SocketTimeoutException) {
            sum += 1
        }

        var time1 = DateTime.now()
        try {
            server.accept(timeout: 2 * Duration.second)
        } catch (e: SocketTimeoutException) {
            sum += 1
        }
        var time2 = DateTime.now()

        @Expect(sum, 2)
        @Expect(time2 -time1 > 1.5 * Duration.second)
        @Expect(time2 -time1 < 3 * Duration.second)
        sleep(10 * Duration.second)
        server.close()
    }
}
